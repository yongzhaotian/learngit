<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jbye  2004-12-20 9:14
		Tester:
		Content: �ж϶�Ӧ�ı��������Ƿ����
		Input Param:
			                
		Output param:
		History Log: 
			���ø��������һ����������ɾ��һ�ױ���
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������²����ж�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
    //�������
	String sSql = "",sObjectNo = "",sReportDate = "",sReportScope = "",sReturnValue = "pass";
	ASResultSet rs = null;
	//����������
	//������ ��ʱΪ�ͻ���
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//���ҳ�����
	sReportDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportDate"));
	sReportScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportScope"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sReportScope == null) sReportScope = "";
	if(sReportDate == null)	sReportDate = "";
	
	//��ѯ��ǰ�����Ĳ��񱨱��Ƿ��ظ�
	
	sSql = 	" select RecordNo from CUSTOMER_FSRECORD "+
			" where CustomerID = :CustomerID "+			
			" and ReportDate = :ReportDate "+
			" and ReportScope = :ReportScope ";

	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CustomerID",sObjectNo).setParameter("ReportDate",sReportDate).setParameter("ReportScope",sReportScope));
	if(rs.next())
	{
		sReturnValue = "refuse";
	}
	rs.getStatement().close();
	//out.println(sSql);
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>