<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Frame00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ʾ�����¿��ҳ��
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Frame01;Describe=�����������ȡ����;]~*/%>
<%
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Frame02;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Frame03;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Frame04;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	OpenPage("/CreditManage/ApprovalWLS/ApplyInfoList.jsp?OrgID=<%=sOrgID%>","rightup","");
	OpenPage("/Blank.jsp?TextToShow=�����Ϸ��б���ѡ��һ��111","rightdown","");

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
