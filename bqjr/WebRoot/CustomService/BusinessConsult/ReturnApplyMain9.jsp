<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "������ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;������ѯ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "���Ժ�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���
	%>

	<%@include file="/Resources/CodeParts/Main04.jsp"%>


	<script type="text/javascript">
		myleft.width=1;
		AsControl.OpenView("/CustomService/BusinessConsult/StoreConsultList.jsp","temp=002","right","");
		
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	