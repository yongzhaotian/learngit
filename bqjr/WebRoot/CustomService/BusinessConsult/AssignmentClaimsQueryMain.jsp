<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		Author: zq 2016-01-12
		Tester:
		Describe: ����ծȨת��main�ļ�
		Jira:PRM-658
		Input Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������
		Output Param:
		HistoryLog:
	 */
	%>
<%
	String PG_TITLE = "ծȨת�ò�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;ծȨת�ò�ѯ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "���Ժ�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���
	
	//��Ʒ����
	String sProductType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));	
	if(null == sProductType) sProductType = "";
%>

<%@include file="/Resources/CodeParts/Main04.jsp"%>

<script type="text/javascript">
		myleft.width=1;
		AsControl.OpenView("/CustomService/BusinessConsult/AssignmentClaimsQueryList.jsp","ProductType=<%=sProductType%>","right",""); 
</script>
<%@ include file="/IncludeEnd.jsp"%>
	