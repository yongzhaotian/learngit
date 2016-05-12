<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "区段列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>

<%
	String parentTermID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentTermID"));
	if(parentTermID == null)
	{
		parentTermID = "";
	}
	String objectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(objectType == null)
	{
		objectType = "Term";
	}
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(objectNo == null)
	{
		objectNo = parentTermID;
	}
%>

<%
	ASDataObject doTemp = new ASDataObject("TermSetSegmentList",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	dwTemp.setEvent("AfterDelete","!ProductManage.DeleteTermParameter(#TermID,"+objectType+","+objectNo+")+!ProductManage.DeleteTermRelative(#TermID,"+parentTermID+","+objectType+","+objectNo+")");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(parentTermID+","+objectType+","+objectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
%>
<%
	String sButtons[][] = {
		{parentTermID.equals("")?"false":"true","","Button","新增区段","新增区段","newRecord()",sResourcesPath},
		{"true","","Button","编辑区段","编辑区段","viewAndEdit()",sResourcesPath},	
		{"true","","Button","删除区段","删除区段","deleteRecord()",sResourcesPath},	
	};
%> 


<%@include file="/Resources/CodeParts/List05.jsp"%>


<script language=javascript>

	function newRecord(){
		AsControl.OpenView("/Accounting/Config/TermSetSegmentInfo.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&ParentTermID=<%=parentTermID%>","_blank",OpenStyle);
		reloadSelf();
	}
	
	function deleteRecord(){
		var termID = getItemValue(0,getRow(),"TermID");
		if (typeof(termID)=="undefined" || termID.length==0){
			alert("请选择一条记录！");
			return;
		}		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	function viewAndEdit(){
		var termID = getItemValue(0,getRow(),"TermID");
		if(typeof(termID)=="undefined" || termID==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       	AsControl.OpenView("/Accounting/Config/TermSetSegmentInfo.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&ParentTermID=<%=parentTermID%>&TermID="+termID,"_blank",OpenStyle);
		reloadSelf();
	}
	
</script>



<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	

<%@ include file="/IncludeEnd.jsp"%>
