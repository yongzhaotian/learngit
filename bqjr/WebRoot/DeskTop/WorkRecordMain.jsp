<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: �����ƻ��ʼǿ��(��������̨)
	 */
	String PG_TITLE = "�����ƻ��ʼ�"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�����ƻ��ʼ�&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	String myleft_top_WIDTH = "0";//Ĭ�ϵ�treeview���
%><%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript">
	//�����������
	myleft.width=1;
	OpenComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","NoteType=All","right");
</script>
<%@ include file="/IncludeEnd.jsp"%>