<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2006-08-11
		Tester:
		Describe:
			���ͻ��Ƿ��Ѿ������Ŵ���ϵ

		Input Param:					
			CertType: ֤������
			CertID:֤������
		Output Param:
			Message: ���ع����ͻ����RelativeID ���Ϊ�����ʾ��鲻ͨ��,����ʾ��Ϣ
		HistoryLog:
	*/
	%>
<%/*~END~*/%>

<%
	//��ȡҳ�����	
	String sCertType = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertType"));
	String sCertID = DataConvert.toRealString(iPostChange,CurPage.getParameter("CertID"));
	
	//�������
	String sRelativeID = "";
	String sSql = "";
	SqlObject so = null;
	String sMessage = "";	
	ASResultSet rs = null;
	
	//����֤�����ͺ�֤����ţ���ͻ����ƻ�ȡ�ͻ����
	sSql = 	" select CustomerID from CUSTOMER_INFO "+
			" where CertType =:CertType "+
			" and CertID =:CertID ";
	so = new SqlObject(sSql).setParameter("CertType",sCertType).setParameter("CertID",sCertID);
	rs = Sqlca.getResultSet(so);
	if (rs.next())
		sRelativeID = rs.getString("CustomerID");
	rs.getStatement().close();
	
	if(sRelativeID == null || sRelativeID.equals(""))
		sRelativeID = DBKeyHelp.getSerialNo("CUSTOMER_INFO","CustomerID",Sqlca);		
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sRelativeID);
	sRelativeID = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sRelativeID);
%>
<%/*~END~*/%>

<%@	include file="/IncludeEndAJAX.jsp"%>