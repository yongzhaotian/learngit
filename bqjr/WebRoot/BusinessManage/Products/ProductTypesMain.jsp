<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "��Ʒ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��Ʒ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "���Ժ�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���
	
	//��Ʒ����
	String sProductType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));	
	//��Ʒ������
	String sSubProductType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));	
	
	if(null == sProductType) sProductType = "";
	if(null == sSubProductType) sSubProductType = "";
	%>

	<%@include file="/Resources/CodeParts/Main04.jsp"%>


	<script type="text/javascript">
		myleft.width=1;
		AsControl.OpenView("/BusinessManage/Products/ProductTypesList.jsp","ProductType=<%=sProductType%>&SubProductType=<%=sSubProductType%>","right","");//update �ֽ������(���Ӳ�Ʒ���Ͳ���)
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	