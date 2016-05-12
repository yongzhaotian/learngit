<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xuzhang 2005-1-21
		Tester:
		Describe:预警信号风险提示详情;
		Input Param:
			serialNo：预警信息流水号
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户风险提示信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialNo"));
	String sEnter = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Enter"));
	if(sSerialNo == null) sSerialNo = "";
	if(sEnter == null) sEnter = "";
	//设置表头
	String sHeaders[][] = {
							{"CustomerName","客户名称"},
							{"signalName","风险信号名称"},
							{"ObjectNo","客户号"},
							{"Remark","详细信息"}
						   };
	
	
	String sSql =	"select getCustomerName(objectNo) as CustomerName,"+
					" getItemName('AlertSignal',Signaltype) as signalName, "+
					" ObjectNo,Remark"+
					" from risk_signal" +
					" where serialNo='"+sSerialNo+"'";
	//通过sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "risk_signal";


	doTemp.setVisible("ObjectNo",false);
	doTemp.setEditStyle("Remark","3");//显示类行为textarea
	doTemp.setHTMLStyle("CustomerName"," style={width:100px} ");
	doTemp.setHTMLStyle("signalName"," style={width:280px} ");


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置为Free风格
	dwTemp.ReadOnly = "1"; //设置为只读


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
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
		{"true","","Button","返回","返回新增风险预警列表","Back()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
//返回新增风险预警列表
	function Back()
	{
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		//alert("请选择一条记录"+sObjectNo);
		OpenComp("SignalInfoList","/CustomerManage/EntManage/CustomerSignalList.jsp","CustomerID="+sObjectNo+"&Enter=<%=sEnter%>","_self",OpenStyle);
	}

</script>
	
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@ include file="/IncludeEnd.jsp"%>

