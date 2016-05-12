<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "角色下用户列表";
	//获得组件参数
	String sRoleID = CurPage.getParameter("RoleID");
	if(sRoleID == null) sRoleID = "";
	
	String sTempletNo = "ViewAllUserList"; //模版编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sRoleID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","关闭","关闭","goBack()","","","",""},
		{"true","","Button","导出Excel","导出Excel","exportAll()","","","",""},
	};
%> <%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function goBack(){
		top.close();
	}
	
	<%/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/%>
	function exportAll(){
		amarExport("myiframe0");
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>