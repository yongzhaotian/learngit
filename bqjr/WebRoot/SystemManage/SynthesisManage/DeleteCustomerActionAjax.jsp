<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: zywei 2005/08/16
 * Tester:
 *
 * Content:   	删除无效客户动作。
 * Input Param:
 *		CustomerID：客户编号
 *		CustomerType：客户类型
 * Output param:
 *
 *  History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%
	String sSql = ""; //SQL语句
	String sCustomerID = ""; //客户编号
	String sCustomerType = ""; //客户类型
	String sMessage = "";
	int iCount=0;
	ASResultSet rs = null; //查询结果集
    //获取客户代码、客户类型
	sCustomerID   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	sCustomerType   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	//将空值转化成空字符串
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerType == null) sCustomerType = "";
	
	//查看客户是否存在已保存的客户概况信息
	if(!sCustomerType.equals("030")) //公司客户
	{		
		sSql =  " select count(CustomerID) from ENT_INFO "+
				" where CustomerID = :CustomerID "+
				" and TempSaveFlag = '2' ";
	}else //相关个人
	{		
		sSql =  " select count(CustomerID) from IND_INFO "+
				" where CustomerID = :CustomerID "+
				" and TempSaveFlag = '2' ";		
	}
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();
	if(iCount > 0)
		sMessage = "该客户存在客户概况信息，属于有效客户，不能进行清理操作。" + "@";
	
	//查看客户是否存在关联信息
	sSql = " select count(CustomerID) from CUSTOMER_RELATIVE where CustomerID = :CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();	
	if(iCount > 0)
		sMessage += "该客户存在关联信息，属于有效客户，不能进行清理操作。" + "@";
	
	//查看客户是否存在申请信息
	sSql = " select count(SerialNo) from BUSINESS_APPLY where CustomerID = :CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();
	if(iCount > 0)
		sMessage += "该客户存在申请信息，属于有效客户，不能进行清理操作。" + "@";
	
	//查看客户是否存在合同信息	
	sSql = " select count(SerialNo) from BUSINESS_CONTRACT where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();
	if(iCount > 0)
		sMessage += "该客户存在合同信息，属于有效客户，不能进行清理操作。" + "@";
	
	//查看客户是否存在担保信息	
	sSql = " select count(SerialNo) from GUARANTY_CONTRACT where GuarantorID = :GuarantorID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GuarantorID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();
	if(iCount > 0)
		sMessage += "该客户存在担保信息，属于有效客户，不能进行清理操作。" + "@";
	
	//查看客户是否存在担保物信息	
	sSql = " select count(GuarantyID) from GUARANTY_INFO where OwnerID = :OwnerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("OwnerID",sCustomerID));
	if (rs.next()) iCount = rs.getInt(1);
	rs.getStatement().close();
	if(iCount > 0)
		sMessage += "该客户存在担保物信息，属于有效客户，不能进行清理操作。" + "@";
	
	//如果上述信息都不存在，则删除该客户
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


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sMessage);
	sMessage = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sMessage);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>