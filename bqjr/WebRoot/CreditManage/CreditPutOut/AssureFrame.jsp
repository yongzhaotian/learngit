<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Frame00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-6
		Tester:
		Describe: 
		Input Param:
			ObjectType: ��������(ҵ��׶�)��
			ObjectNo: �����ţ�����/����/��ͬ��ˮ�ţ���
			ContractType: ��ͬ����
				010 һ�㵣����Ϣ
				020 ��߶����ͬ
		Output Param:
			ObjectType: ��������(ҵ��׶�)��
			ObjectNo: �����ţ�����/����/��ͬ��ˮ�ţ���
			ContractType: ��������
				010 һ�㵣����Ϣ
				020 ��߶����ͬ
		HistoryLog:
			2005-08-07 ��ҵ�  ����ҳ�棬��������ͬ�б��չ�ֶ���һ��ҳ����ʵ��
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Frame02;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Frame03;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	<%
		String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
		String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));	
	%>
		OpenPage("/CreditManage/CreditPutOut/AssureList.jsp","rightup","");
		OpenPage("/Blank.jsp?TextToShow=�����Ϸ��б���ѡ��һ��������ͬ��Ϣ","rightdown","");
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
