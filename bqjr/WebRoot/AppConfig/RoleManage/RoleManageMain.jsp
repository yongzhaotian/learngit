<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��ɫ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ɫ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	OpenComp("RoleList","/AppConfig/RoleManage/RoleList.jsp","","right");			
</script>
<%@ include file="/IncludeEnd.jsp"%>