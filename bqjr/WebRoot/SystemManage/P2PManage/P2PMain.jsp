<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��:P2Pƽ̨�������--
	 */
	String PG_TITLE = "P2Pƽ̨�������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;P2Pƽ̨�������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "0";//Ĭ�ϵ�treeview���

	//���ҳ�����

%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	myleft.width=1;
	AsControl.OpenView("/SystemManage/P2PManage/P2PList.jsp","","right","");
</script>
<%@ include file="/IncludeEnd.jsp"%>