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
	String sIndustryType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("IndustryType"));
%>
<%/*~END~*/%>


 

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Frame02;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Frame03.jsp"%>
<%/*~END~*/%>
 




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Frame03;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Frame04;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	myleft.width=340;
	OpenPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryType=<%=sIndustryType%>","frameleft","");
	OpenPage("/Blank.jsp?TextToShow=�������б���ѡ��һ��","frameright","");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
