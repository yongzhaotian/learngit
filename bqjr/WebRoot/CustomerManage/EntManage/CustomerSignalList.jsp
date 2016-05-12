<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xuzhang 2005-1-21
		Tester:
		Describe:预警信号风险提示;
		Input Param:
			CustomerID：客户编号
		Output Param:
			
		HistoryLog:
	 */ 
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户风险提示信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sEnter = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Enter"));
	if(sEnter == null) sEnter = "";
	//设置表头
	String sHeaders[][] = {	{"CustomerName","客户名称"},
							{"signalName","风险信号名称"},
							{"serialNO","流水号"},
							{"SignalStatus","预警信号状态"}
							};
	
	
	String sSql =	" select serialNo,getCustomerName(objectNo) as CustomerName,"+
					" getItemName('AlertSignal',Signaltype) as signalName, "+
					" getItemName('SignalStatus',SignalStatus) as SignalStatus,"+
					" InputUserID"+
					" from risk_signal" +
					" where objectNo='"+sCustomerID+"'";
	//通过sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "risk_signal";
	doTemp.setKey("serialNo",true);	

	doTemp.setVisible("serialNo,InputUserID,SignalStatus",false);
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("signalName"," style={width:280px} ");


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
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
		{"true","","Button","新增","新增风险预警","Signal_add()",sResourcesPath},
		{"true","","Button","风险预警详情","查看风险预警的详细信息","Signal_Detail()",sResourcesPath},
		{"true","","Button","删除","删除该风险预警","Signal_Delete()",sResourcesPath},
		};
		if(sEnter.equals("80"))
		{
		    sButtons[0][0] = "false";
		    sButtons[2][0] = "false";
		}
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	//新增风险预警信号
	function Signal_add()
	{
		sReturn =popComp("SelectSignal","/CustomerManage/EntManage/SelectSignal.jsp","CustomerID=<%=sCustomerID%>","dialogWidth=28;dialogHeight=32;center:yes;status:no;statusbar:no;scrollbars:yes");
		if(typeof(sReturn) != "undefined" && sReturn != "" )
		{	
			sReturnValue=popComp("AddSignalInfo","/CustomerManage/EntManage/AddSignalInfo.jsp","CustomerID=<%=sCustomerID%>&SignalType="+sReturn,"dialogWidth=38;dialogHeight=32;center:yes;status:no;statusbar:no");
			OpenComp("SignalInfoList","/CustomerManage/EntManage/CustomerSignalList.jsp","CustomerID=<%=sCustomerID%>","_self",OpenStyle);
		}
	}

	//查看风险预警的详细信息
	function Signal_Detail()
	{
		sRecordNo = getItemValue(0,getRow(),"serialNo");
		if (typeof(sRecordNo) != "undefined" && sRecordNo != "" )
		{
			OpenComp("SignalInfo","/CustomerManage/EntManage/SignalInfo.jsp","serialNo="+sRecordNo+"&Enter=<%=sEnter%>","_self");
		}else
		{
			alert("请选择一条记录");
		}
	}

	//删除该风险预警
	function Signal_Delete()
	{
		sUserID=getItemValue(0,getRow(),"InputUserID");
		sRecordNo = getItemValue(0,getRow(),"serialNo");
		if (typeof(sRecordNo) == "undefined" && sRecordNo == "" )
		{
			alert("请选择一条记录");
		}
		else if(sUserID=='<%=CurUser.getUserID()%>')
		{
			if(confirm("你确认要删除该预警信息吗？"))
			{			
				sReturn = PopPageAjax("/CustomerManage/EntManage/SignalActionAjax.jsp?ActionType=Delete&SerialNo="+sRecordNo,"_self",OpenStyle);
				if(sReturn=="ok")
				{
					reloadSelf();
				}
			}
		}else alert(getHtmlMessage('3'));
	}
</script>
	
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@ include file="/IncludeEnd.jsp"%>

