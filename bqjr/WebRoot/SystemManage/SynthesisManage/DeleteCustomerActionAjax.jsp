<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: zywei 2005/08/16
 * Tester:
 *
 * Content:   	ɾ����Ч�ͻ�������
 * Input Param:
 *		CustomerID���ͻ����
 *		CustomerType���ͻ�����
 * Output param:
 *
 *  History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%
	String sSql = ""; //SQL���
	String sCustomerID = ""; //�ͻ����
	String sCustomerType = ""; //�ͻ�����
	String sMessage = "";
	int iCount=0;
	ASResultSet rs = null; //��ѯ�����
    //��ȡ�ͻ����롢�ͻ�����
	sCustomerID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	sCustomerType   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	//����ֵת���ɿ��ַ���
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerType == null) sCustomerType = "";
	
	//�鿴�ͻ��Ƿ�����ѱ���Ŀͻ��ſ���Ϣ
	if(!sCustomerType.equals("030")) //��˾�ͻ�
	{		
		sSql =  " select count(CustomerID) from ENT_INFO "+
				" where CustomerID = :CustomerID "+
				" and TempSaveFlag = '2' ";
	}else //��ظ���
	{		
		sSql =  " select count(CustomerID) from IND_INFO "+
				" where CustomerID = :CustomerID "+
				" and TempSaveFlag = '2' ";		
	}
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();
	if(iCount > 0)
		sMessage = "�ÿͻ����ڿͻ��ſ���Ϣ��������Ч�ͻ������ܽ������������" + "@";
	
	//�鿴�ͻ��Ƿ���ڹ�����Ϣ
	sSql = " select count(CustomerID) from CUSTOMER_RELATIVE where CustomerID = :CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();	
	if(iCount > 0)
		sMessage += "�ÿͻ����ڹ�����Ϣ��������Ч�ͻ������ܽ������������" + "@";
	
	//�鿴�ͻ��Ƿ����������Ϣ
	sSql = " select count(SerialNo) from BUSINESS_APPLY where CustomerID = :CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();
	if(iCount > 0)
		sMessage += "�ÿͻ�����������Ϣ��������Ч�ͻ������ܽ������������" + "@";
	
	//�鿴�ͻ��Ƿ���ں�ͬ��Ϣ	
	sSql = " select count(SerialNo) from BUSINESS_CONTRACT where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();
	if(iCount > 0)
		sMessage += "�ÿͻ����ں�ͬ��Ϣ��������Ч�ͻ������ܽ������������" + "@";
	
	//�鿴�ͻ��Ƿ���ڵ�����Ϣ	
	sSql = " select count(SerialNo) from GUARANTY_CONTRACT where GuarantorID = :GuarantorID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GuarantorID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();
	if(iCount > 0)
		sMessage += "�ÿͻ����ڵ�����Ϣ��������Ч�ͻ������ܽ������������" + "@";
	
	//�鿴�ͻ��Ƿ���ڵ�������Ϣ	
	sSql = " select count(GuarantyID) from GUARANTY_INFO where OwnerID = :OwnerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("OwnerID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();
	if(iCount > 0)
		sMessage += "�ÿͻ����ڵ�������Ϣ��������Ч�ͻ������ܽ������������" + "@";
	
	//���������Ϣ�������ڣ���ɾ���ÿͻ�
	if(sMessage.equals(""))
	{
		sSql = " delete from CUSTOMER_INFO where CustomerID = :CustomerID ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
		sSql = " delete from CUSTOMER_BELONG where CustomerID = :CustomerID ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
		sSql = " delete from ENT_INFO where CustomerID = :CustomerID ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
		sSql = " delete from IND_INFO where CustomerID = :CustomerID ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	}

%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sMessage);
	sMessage = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sMessage);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>