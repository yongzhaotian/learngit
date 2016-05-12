<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xuzhang 2005-1-21
		Tester:
		Describe:选择新增预警信号风险提示;
		Input Param:
			CustomerID：客户编号
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "选择风险提示信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
	String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sSignalType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalType"));
	//out.println(sCustomerID+"   "+sSignalType);
	//先插入一条纪录以供显示编辑
	String sSerialNo=DBKeyHelp.getSerialNo("RISK_SIGNAL","SerialNo",Sqlca);

	String sSql="insert into RISK_SIGNAL(ObjectType,ObjectNo,SerialNo,SignalType) values('Customer',:ObjectNo,:SerialNo,:SignalType)";
	SqlObject so = new SqlObject(sSql);
	so.setParameter("ObjectNo",sCustomerID).setParameter("SerialNo",sSerialNo).setParameter("SignalType",sSignalType);
	Sqlca.executeSQL(so);

	//设置表头
	String sHeaders[][] = {	{"CustomerName","客户名称"},
						{"signalName","风险信号名称"},
						{"ObjectNo","客户号"},
						{"Remark","详细信息"},
						{"SignalStatus","预警信号状态"}
						};
	
	
	sSql =	"select getCustomerName(objectNo) as CustomerName,"+
			" getItemName('AlertSignal',Signaltype) as signalName,ObjectNo,Remark,SignalStatus,"+
			" InputUserID"+
			" from risk_signal" +
			" where serialNo='"+sSerialNo+"'";
	//通过sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "risk_signal";

	doTemp.setReadOnly("CustomerName,signalName", true);//只读条目
	doTemp.setVisible("ObjectNo,InputUserID",false);
	doTemp.setEditStyle("Remark","3");//显示类行为textarea
	//设置下拉框
	doTemp.setDDDWSql("SignalStatus","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'EffStatus'");
	//设置默认值
	doTemp.setDefaultValue("SignalStatus","01");

	doTemp.setHTMLStyle("CustomerName"," style={width:400px} ");
	doTemp.setHTMLStyle("signalName"," style={width:400px} ");


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置为Free风格
	//dwTemp.ReadOnly = "1"; //设置为只读


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件下一步
		//6.资源图片路径

	String sButtons[][] = {
		{"true","","Button","保存","保存该预警信息","Save()",sResourcesPath},
		{"true","","Button","取消","取消","Cancel()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	function Save(){
		sRemark=getItemValue(0,getRow(),"Remark");
		sSignalStatus=getItemValue(0,getRow(),"SignalStatus");
		//如果没有选择状态信息，则默认状态未有效
		if(typeof(sSignalStatus) == "undefined" || sSignalStatus == "" )
			sSignalStatus="01";
		if(confirm("你确定添加该预警信息吗？")){
			PopPageAjax("/CustomerManage/EntManage/SignalActionAjax.jsp?ActionType=Add&SerialNo=<%=sSerialNo%>&Remark="+sRemark+"&SignalStatus="+sSignalStatus,"_self",OpenStyle);
			self.close();
		}
	}
	
	function Cancel(){
		if(confirm("你确定取消添加预警信息操作吗？")){
			PopPageAjax("/CustomerManage/EntManage/SignalActionAjax.jsp?ActionType=Delete&SerialNo=<%=sSerialNo%>","_self",OpenStyle);
			self.close();
		}
	}
	//关闭窗口前提示是否保存添加的信息
	document.onbeforeunload = function(){
		if(event.clientX>360&&event.clientY<0||event.altKey){
			if(confirm("保存该预警信息吗？")){
				sRemark=getItemValue(0,getRow(),"Remark");
				sSignalStatus=getItemValue(0,getRow(),"SignalStatus");
				//如果没有选择状态信息，则默认状态未有效
				if(typeof(sSignalStatus) == "undefined" || sSignalStatus == "" )
					sSignalStatus="01";
				PopPageAjax("/CustomerManage/EntManage/SignalActionAjax.jsp?ActionType=Add&SerialNo=<%=sSerialNo%>&Remark="+sRemark+"&SignalStatus="+sSignalStatus,"_self",OpenStyle);
			}else
				PopPageAjax("/CustomerManage/EntManage/SignalActionAjax.jsp?ActionType=Delete&SerialNo=<%=sSerialNo%>","_self","");
		}
	};
	
  	function initRow(){
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
	}
</script>

<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>

<%@ include file="/IncludeEnd.jsp"%>
