<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "�ʲ�ת�����÷�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ʲ�ת�����÷�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "���Ժ�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���
	%>

	<%@include file="/Resources/CodeParts/Main04.jsp"%>


	<script type="text/javascript">
		myleft.width=1;
		AsControl.OpenView("/CustomerManage/CooperationCustomerManage/AssetsTransferList.jsp","","right","");
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	