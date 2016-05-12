<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "核算交易定义详情"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//定义变量
	String sitemno =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));//交易编号
	if(sitemno==null) sitemno="";
	String scodeno =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));//交易代码
	if(scodeno==null) scodeno="";

	ASDataObject doTemp = new ASDataObject("TransactionConfigInfo",Sqlca);//交易定义详情模板

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sitemno);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存记录","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表也面","goBack()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------
	function saveRecord()
	{
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=SystemConfig.getBusinessTime()%>");
		as_save("myiframe0");
	}
	
	// 返回交易列表
	function goBack()
	{
		AsControl.OpenView("/Accounting/Config/TransactionConfigList.jsp","","right","");
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"TypeSortNo","1");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=SystemConfig.getBusinessTime()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=SystemConfig.getBusinessTime()%>");
			setItemValue(0,0,"CodeNo","T_Transaction_Def");
			bIsInsert = true;
		}
    }

	</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
