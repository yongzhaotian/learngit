<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.web.config.check.ASConfigCheck"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:Thong 2005.8.29 15:20
		Tester:
		Content: �Ժ�̨У����Ĵ��� �����ϵ�ǰ����ʾ  
		Input Param:	sKindCode	��������ݵ�CODENO�ֶν���һ��һ�Ƚ�
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "У�����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//����������	
	String sKindCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("KindCode"));

	//sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	//���ҳ�����	
	//sParameter =  DataConvert.toRealString(iPostChange,(String)request.getParameter("Parameter"));
%>
<%/*~END~*/%>

<%
	ASConfigCheck asc = new ASConfigCheck(Sqlca,sKindCode) ;
	asc.setBaseConfig();
%>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
		self.close();
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
