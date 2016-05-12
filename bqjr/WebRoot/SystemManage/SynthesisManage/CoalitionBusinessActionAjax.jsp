<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:mfhu  2005-3-17
 * Tester:
 *
 * Content:   	ҵ��ϲ�
 * Input Param:
 *				
 * Output param:
 *			
 * 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%	
	//��ȡ�������ϲ�ǰ�ͻ���š��ϲ�ǰ�ͻ����ơ��ϲ���Ŀͻ���š��ϲ���ͻ����ơ��ϲ���֤�����͡��ϲ���֤����š��ϲ��������
	String sFromCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromCustomerID"));	    
	String sFromCustomerName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FromCustomerName"));
	String sToCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCustomerID"));	
	String sToCustomerName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCustomerName"));	
	String sToCertType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCertType"));	
	String sToCertID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToCertID"));	
	String sToLoanCardNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ToLoanCardNo"));	
	//����ֵת��Ϊ���ַ���
	if(sFromCustomerID == null) sFromCustomerID = "";
	if(sFromCustomerName == null) sFromCustomerName = "";
	if(sToCustomerID == null) sToCustomerID = "";
	if(sToCustomerName == null) sToCustomerName = "";
	if(sToCertType == null) sToCertType = "";
	if(sToCertID == null) sToCertID = "";
	if(sToLoanCardNo == null) sToLoanCardNo = "";
		
	//�������
	String sFlag = "";	
	String sSql = "";	
	SqlObject so = null;
	String sNewSql = "";
	//ת����־��Ϣ
	String sChangeReason = "ҵ��ϲ�������Ա����:"+CurUser.getUserID()+"   ������"+CurUser.getUserName()+"   �������룺"+CurOrg.getOrgID()+"   �������ƣ�"+CurOrg.getOrgName();
	String sInputDate   = StringFunction.getToday();

	try
	{
		//���������
		//Sqlca.executeSQL("update BUSINESS_APPLY set CustomerID = '"+sToCustomerID+"',CustomerName = '"+sToCustomerName+"' where CustomerID = '"+sFromCustomerID+"' ");
		sNewSql = "update BUSINESS_APPLY set CustomerID = :CustomerID1,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//����������
		sNewSql = "update BUSINESS_APPROVE set CustomerID = :CustomerID1,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//���º�ͬ��
		sNewSql = "update BUSINESS_CONTRACT set CustomerID = :CustomerID,CustomerName = :CustomerName where CustomerID = :CustomerID ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//�������Ŷ�ȱ�
		sNewSql = "update CL_INFO set CustomerID = :CustomerID1,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//���³��ʱ�
		sNewSql = "update BUSINESS_PUTOUT set CustomerID = :CustomerID1,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
				
		//���½�ݱ�
		sNewSql = "update BUSINESS_DUEBILL set CustomerID = :CustomerID1,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//������ˮ��
		sNewSql = "update BUSINESS_WASTEBOOK set CustomerID1 = :CustomerID,CustomerName = :CustomerName where CustomerID = :CustomerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("CustomerID1",sToCustomerID);
		so.setParameter("CustomerName",sToCustomerName);
		so.setParameter("CustomerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//���µ�����ͬ�͵�����Ϣ
		sNewSql = "update GUARANTY_CONTRACT set GuarantorID = :GuarantorID1,GuarantorName = :GuarantorName,CertType = :CertType,CertID = :CertID,LoanCardNo = :LoanCardNo where GuarantorID = :GuarantorID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("GuarantorID1",sToCustomerID);
		so.setParameter("GuarantorName",sToCustomerName);
		so.setParameter("CertType",sToCertType);
		so.setParameter("CertID",sToCertID);
		so.setParameter("LoanCardNo",sToLoanCardNo);
		so.setParameter("GuarantorID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		sNewSql = "update GUARANTY_INFO set OwnerID=:OwnerID1,OwnerName=:OwnerName,CertType = :CertType,CertID = :CertID,LoanCardNo = :LoanCardNo where OwnerID = :OwnerID2 ";
		so = new SqlObject(sNewSql);
		so.setParameter("OwnerID1",sToCustomerID);
		so.setParameter("OwnerName",sToCustomerName);
		so.setParameter("CertType",sToCertType);
		so.setParameter("CertID",sToCertID);
		so.setParameter("LoanCardNo",sToLoanCardNo);
		so.setParameter("OwnerID2",sFromCustomerID);
		Sqlca.executeSQL(so);
		
		//�����Ҫ�ϲ��������ݱ��еĿͻ������±���������������
		
		
		//��MANAGE_CHANGE���в����¼�����ڼ�¼��α������
        String sSerialNo1 =  DBKeyHelp.getSerialNo("MANAGE_CHANGE","SerialNo",Sqlca);
        sSql =  " INSERT INTO MANAGE_CHANGE(ObjectType,ObjectNo,SerialNo,OldOrgID,OldOrgName,NewOrgID,NewOrgName,OldUserID, "+
				" OldUserName,NewUserID,NewUserName,ChangeReason,ChangeOrgID,ChangeUserID,ChangeTime) "+
		        " VALUES('UniteBusiness',:ObjectNo,:SerialNo,:OldOrgID,:OldOrgName,:NewOrgID, "+
		        " :NewOrgName,'','','','',:ChangeReason,:ChangeOrgID,:ChangeUserID,:ChangeTime)";
    	so = new SqlObject(sNewSql);
		so.setParameter("ObjectNo",sFromCustomerID);
		so.setParameter("SerialNo",sSerialNo1);
		so.setParameter("OldOrgID",sFromCustomerID);
		so.setParameter("OldOrgName",sFromCustomerName);
		so.setParameter("NewOrgID",sToCustomerID);
		so.setParameter("NewOrgName",sToCustomerName);
		so.setParameter("ChangeReason",sChangeReason);
		so.setParameter("ChangeOrgID",CurOrg.getOrgID());
		so.setParameter("ChangeUserID",CurUser.getUserID());
		so.setParameter("ChangeTime",sInputDate);
		Sqlca.executeSQL(so);
		sFlag = "TRUE";
	}
	catch(Exception e)
	{
		sFlag="FALSE";
		throw new Exception("������ʧ�ܣ�"+e.getMessage());
	}
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sFlag);
	sFlag = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sFlag);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>