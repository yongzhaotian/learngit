<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��:������������Mainҳ��--
	 */
	String PG_TITLE = "ԤԼ�ֽ��׼��ͻ�������ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;ԤԼ�ֽ��׼��ͻ�������ѯ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���

	//���ҳ�����

%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	AsControl.OpenView("/BusinessManage/AssociateCustomerQuery/OrderedCashLoanCustomerQueryList.jsp","","right","");
</script>
<%@ include file="/IncludeEnd.jsp"%>