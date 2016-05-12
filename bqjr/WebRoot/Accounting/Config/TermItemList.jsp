<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "组件参数列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>


<%
	String termID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TermID"));
	if(termID == null)termID = "";
	String objectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(objectType==null) objectType = "Term";
	String objectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(objectNo==null) objectNo = termID;
	String termType="",setFlag="";
	ASResultSet rs=Sqlca.getASResultSet("select TermType,SetFlag from PRODUCT_TERM_LIBRARY "+
										"where ObjectType='Term' and TermID = '"+termID+"'");
	if(rs.next()){
		termType=rs.getString("TermType");
		setFlag=rs.getString("SetFlag");
	}
	rs.getStatement().close();

	CurPage.setAttribute("TempletNo", "TermItemList");
	String sTempletNo = "TermItemList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(40);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(termID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
%>


<%
	String sButtons[][] = {
		{"true","","Button","引入","引入","importParameters()",sResourcesPath},
		{"true","","Button","删除","删除","deleteParam()",sResourcesPath},
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
	};
%> 


<%@include file="/Resources/CodeParts/List05.jsp"%>			

	<script language=javascript>

	function importParameters()
	{
		var sReturn = selectObjectValue("SelectTermParameters","TermType,<%=termType%>,SetFlag,<%=setFlag%>","",0,0,"");
		if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn != "_NONE_" && sReturn != "_CLEAR_" && sReturn != "_CANCEL_") 
		{
			var methodResult = RunMethod("ProductManage","ImportTermParameters","importTermParameters2,<%=objectNo%>,<%=termID%>,"+sReturn);
			var ddd = parent;
			reloadSelf();
		}
	}
	
	function saveRecord()
	{
		as_save("myiframe0","");
	}
	
	function deleteParam()
	{
		var sParaID = getItemValue(0,getRow(),"ParaID");
		if (typeof(sParaID)=="undefined" || sParaID.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		if(confirm("确定删除该信息吗？"))
		{
			as_del("myiframe0");
			as_save("myiframe0","reloadSelf();");  //如果单个删除，则要调用此语句
		}
	}
	</script>


	<script language=javascript>	
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		var obj = parent.document.getElementById('ParameterList');
		if(typeof(obj) != "undefined" && obj != null)
		{
			obj.style.height = ((getRowCount(0))*18+55)+"%";
		}
	</script>	

<%@ include file="/IncludeEnd.jsp"%>