<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<% 
	/*
		Author: 
		Tester:
		Describe: �ֽ���Ԥ��
		Input Param:
			CustomerID �� ��ǰ�ͻ����
			BaseYear   : ��׼���:�������������һ��  
			YearCount  : Ԥ������:default=1
			ReportScope: ����ھ�	           
		Output Param:
			
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    �µİ汾�ĸ�д
	 */
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ��ֽ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    //���ҳ�����
 	String sCustomerID = DataConvert.toRealString(CurPage.getParameter("CustomerID"));
	String sBaseYear = DataConvert.toRealString(CurPage.getParameter("BaseYear"));
	String sYearCount = DataConvert.toRealString(CurPage.getParameter("YearCount"));
	String sReportScope = DataConvert.toRealString(CurPage.getParameter("ReportScope"));
	SqlObject so = null;
	String sNewSql = "";			

	String sReturnValue="";
    //����������

%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=ִ��SQL���;]~*/%>

<%
	try{
		sNewSql = "delete from CashFlow_Parameter where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope=:ReportScope";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("BaseYear",sBaseYear);
		so.setParameter("ReportScope",sReportScope);
		Sqlca.executeSQL(so);
		sNewSql = "delete from CashFlow_Data where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope=:ReportScope and FCN = :FCN ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("BaseYear",sBaseYear);
		so.setParameter("ReportScope",sReportScope);
		so.setParameter("FCN",sYearCount);
		Sqlca.executeSQL(so);
		sNewSql = "delete from CashFlow_Record where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope=:ReportScope and FCN = :FCN ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("BaseYear",sBaseYear);
		so.setParameter("ReportScope",sReportScope);
		so.setParameter("FCN",sYearCount);
		Sqlca.executeSQL(so);
		sReturnValue = "succeed";	
	}catch(Exception e){
		e.fillInStackTrace();
		sReturnValue="failed";
	}
%>
<%/*~END~*/%>

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
