<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "会计分录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","200");
	CurPage.setAttribute("DetailFrameInitialText","请选择一笔记录");
	
    //定义变量
	String sTransID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
	String inputparatemplete =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("attribute1"));
	if(sTransID==null) sTransID="";
    if(inputparatemplete==null) inputparatemplete="";
	
	ASDataObject doTemp = new ASDataObject("TransEntryConfigList",Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTransID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
	};
%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>

	function newRecord(){
		var transID = "<%=sTransID%>";
		AsControl.OpenView("/Accounting/Config/TransEntryConfigInfo.jsp","TransID="+transID+"&Inputparatemplete=<%=inputparatemplete%>&ToInheritObj=y","DetailFrame","");
	}

	function mySelectRow(){
		var transID = getItemValue(0,getRow(),"TransID");
		var sortID = getItemValue(0,getRow(),"SortID");
		if (typeof(transID) == "undefined" || transID.length == 0)	return;
		AsControl.OpenView("/Accounting/Config/TransEntryConfigInfo.jsp","TransID="+transID+"&SortID="+sortID+"&Inputparatemplete=<%=inputparatemplete%>&ToInheritObj=y","DetailFrame","");
	}
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sortID = getItemValue(0,getRow(),"SortID");
		if (typeof(sortID)=="undefined" || sortID.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("确定删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	</script>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	var bHighlightFirst = true;
</script>	

<%@ include file="/IncludeEnd.jsp"%>