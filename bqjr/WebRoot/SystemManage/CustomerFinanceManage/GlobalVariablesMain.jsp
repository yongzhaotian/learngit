<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	//CCS-769 ����ȫ�ֱ����޸�ΪBIB���õ����� update huzp 20150520
	String PG_TITLE = "BIB����"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;BIB����&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "���Ժ�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "1";//Ĭ�ϵ�treeview���
	%>

	<%@include file="/Resources/CodeParts/Main04.jsp"%>


	<script type="text/javascript">
		//myleft.width=1;
		//AsControl.OpenView("/SystemManage/CustomerFinanceManage/GlobalVariablesInfo.jsp","","right","");
	/******************************CCS-769 ����ȫ�ֱ����޸�ΪBIB���õ�����add huzp 20150527************/
		var org="<%=CurUser.getOrgID()%>"; 	
		if(org=="11"){//���ݵ�¼��Ա���Ż����ж���ʾ����ͬ��BIB���档11Ϊ��˲�����Ա����ǰ��BIB����
			myleft.width=1;
			AsControl.OpenView("/SystemManage/CustomerFinanceManage/GlobalVariablesInfo.jsp","","right","");
		}else if (org=="10"){//���ݵ�¼��Ա���Ż����ж���ʾ����ͬ��BIB���档10Ϊ��ز�����Ա��������BIB����
			myleft.width=1;
			AsControl.OpenView("/SystemManage/CustomerFinanceManage/GlobalVariablesLateInfo.jsp","","right","");
		}
	/******************************end******************************************************/	
		
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	