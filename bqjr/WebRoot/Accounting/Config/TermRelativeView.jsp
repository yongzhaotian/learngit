<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "组件关联关系列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//定义变量
	
	//获得组件参数
	
	//获得页面参数	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	String sTermID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TermID"));
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	if(sTermID==null) sTermID="";
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "TermRelativeView";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTermID+","+sObjectNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"true","","Button","添加互斥关联","添加互斥关联","addExclusiveRelative()",sResourcesPath},
			{"true","","Button","添加绑定关联","添加绑定关联","addBindRelative()",sResourcesPath},
			{"true","","Button","删除","删除组件关联","deleterelative()",sResourcesPath}
		};

	%>

	<%@include file="/Resources/CodeParts/List05.jsp"%>




	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	//---------------------定义按钮事件------------------------------------
	var s="";
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function addExclusiveRelative()
	{	
		var returnValue=setObjectValue("SelectAllTerms","termId,<%=sTermID%>","",0,0,"");
		if(typeof(returnValue) != "undefined" && returnValue != "" && returnValue != "_NONE_" && returnValue != "_CLEAR_" && returnValue != "_CANCEL_")
		{
			RunMethod("ProductManage","addExclusiveRelative","addExclusiveRelative,<%=sTermID%>,"+returnValue+","+"<%=sObjectType%>,"+"<%=sObjectNo%>");
			reloadSelf();
		} 
	}

	function addBindRelative()
	{
		var returnValue=setObjectValue("SelectAllTerms","termId,<%=sTermID%>","",0,0,"");
		if(typeof(returnValue) != "undefined" && returnValue != "" && returnValue != "_NONE_" && returnValue != "_CLEAR_" && returnValue != "_CANCEL_")
		{
			RunMethod("ProductManage","addBindRelative","addBindRelative,<%=sTermID%>,"+returnValue+","+"<%=sObjectType%>,"+"<%=sObjectNo%>");
			reloadSelf();
		} 

	}

	function deleterelative()
	{
		var sTermId = getItemValue(0,getRow(),"TERMID");	//组件ID
		var sRelativeTermID = getItemValue(0,getRow(),"RELATIVETERMID");//关联组件ID
        if(typeof(sTermId) == "undefined" || sTermId.length == 0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			//as_del("myiframe0");
			//as_save("myiframe0");  //如果单个删除，则要调用此语句
			RunMethod("ProductManage","deleteRelative","deleteRelative,"+sTermId+","+sRelativeTermID);
			reloadSelf();
		}
	}

</script>
	


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>
