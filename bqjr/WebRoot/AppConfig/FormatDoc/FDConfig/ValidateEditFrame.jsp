<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
/*
	Content: ���¿��ҳ��, �ϲ�����֤�����б�
 */
%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">
	setDialogTitle("��֤��������");
	AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/ValidateList.jsp","Dono="+CurPage.getParameter("Dono"),"rightup","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>