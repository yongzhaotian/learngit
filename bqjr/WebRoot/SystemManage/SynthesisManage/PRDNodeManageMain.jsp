<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��:�����������Ĳ�Ʒ�ڵ���ϢMainҳ��
		author: yzheng
		date: 2013/05/22
	 */
	String PG_TITLE = "��Ʒ�ڵ���Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��Ʒ�ڵ���Ϣ����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���

	//���ҳ�����

%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	myleft.width=1;
	AsControl.OpenView("/SystemManage/SynthesisManage/PRDNodeManageList.jsp","","right");
</script>
<%@ include file="/IncludeEnd.jsp"%>
