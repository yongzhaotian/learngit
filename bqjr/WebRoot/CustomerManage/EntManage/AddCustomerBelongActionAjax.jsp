<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  --JBai 2005.12.17
		Tester:
		Content: --�ͻ���Ϣ���
		Input Param:
			  UserID���ͻ�����
			  OrgID����������			                				
			  CustomerID���ͻ���
			  sCustomerType ���ͻ�����
		Output param:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ���ϢУ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>

<%  
    //���������sql���
	String sSql = "",sReturnValue="";
	
	//����������
	
    //���ҳ��������ͻ���š��������롢�ͻ���š��ͻ�����
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));	
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
   
   	if(sCustomerType == null) sCustomerType = "";
   	
	if(sCustomerType.equals("02"))
	{
	   try 
	   {		
			String sNewSql = " update CUSTOMER_BELONG set OrgID = :OrgID , UserID = :UserID"+
							 " where CustomerID = :CustomerID and Belongattribute = '1'";
			SqlObject so = new SqlObject(sNewSql);
			so.setParameter("OrgID",sOrgID);
			so.setParameter("UserID",sUserID);
			so.setParameter("CustomerID",sCustomerID);
			Sqlca.executeSQL(so);
			sReturnValue="succeed";
		} catch(Exception e)
		{	
			throw new Exception("������ʧ�ܣ�"+e.getMessage());
		}			
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