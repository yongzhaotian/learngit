<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "ҵ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;ҵ���������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���,����ʾ��ͼ
	
	//����������	
%>
<%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	AsControl.OpenView("/AppConfig/AppBizManage/AppBizObjectFrame.jsp","","right");
</script>
<%@ include file="/IncludeEnd.jsp"%>
