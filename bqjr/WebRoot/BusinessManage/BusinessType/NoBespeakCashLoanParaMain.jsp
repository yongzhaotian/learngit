<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "��ԤԼ�ֽ���ⲿ�ͻ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ԤԼ�ֽ���ⲿ�ͻ�����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "���Ժ�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���
	
	//��Ʒ����
	String sProductType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));	
	if(null == sProductType) sProductType = "";
	%>

	<%@include file="/Resources/CodeParts/Main04.jsp"%>


	<script type="text/javascript">
		myleft.width=1;
		AsControl.OpenView("/BusinessManage/BusinessType/NoBespeakCashLoanParaList.jsp","ProductType=<%=sProductType%>","right","");//update �ֽ������(���Ӳ�Ʒ���Ͳ���) 
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	