<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��:������������Mainҳ��--
	 */
	String PG_TITLE = "���Ӻ�ͬ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���Ӻ�ͬ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "0";//Ĭ�ϵ�treeview���

	//���ҳ�����

%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	myleft.width=1;
	AsControl.OpenComp("Common/WorkFlow/PutOutApply/EDocMangeForPad.jsp","","right","");
	// AsControl.OpenView("Common/WorkFlow/PutOutApply/EDocMangeForPad.jsp","","right","");
</script>
<%@ include file="/IncludeEnd.jsp"%>