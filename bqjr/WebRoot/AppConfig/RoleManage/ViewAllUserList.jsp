<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��ɫ���û��б�";
	//����������
	String sRoleID = CurPage.getParameter("RoleID");
	if(sRoleID == null) sRoleID = "";
	
	String sTempletNo = "ViewAllUserList"; //ģ����
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sRoleID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","�ر�","�ر�","goBack()","","","",""},
		{"true","","Button","����Excel","����Excel","exportAll()","","","",""},
	};
%> <%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function goBack(){
		top.close();
	}
	
	<%/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/%>
	function exportAll(){
		amarExport("myiframe0");
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>