<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Author:
		Tester:
		Content: 取业务类别
		Input Param:
			ObjectNo:  对象流水号
			ObjectType：对象类型
		Output param:
		History Log: djia 修正中小企业客户0120判断  2009.10.29
					 xhgao 2009/10/14  业务关联授信额度改为从CREDITLINE_RELA取得
	 */
	//获得页面参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 		//对象流水号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));	//对象类型
	if(sObjectType == null) sObjectType ="CreditApply";
	String sBusinessType = "",sCreditAggreement = "",sCustomerID="",sCustomerType="";
	double dBailRatio = 0.0;
	String sSql = "",sReturn = "";
	int i=0;
	
	sSql = "select BusinessType,BailRatio,CreditAggreement,CustomerID from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	if(rs.next()){ 
		sBusinessType = rs.getString("BusinessType");
		dBailRatio = rs.getDouble("BailRatio");
		sCreditAggreement = rs.getString("CreditAggreement");
		sCustomerID = rs.getString("CustomerID");
		if(sBusinessType == null) sBusinessType = "";
		if(sCreditAggreement == null) sCreditAggreement = "";
		if(sCustomerID == null) sCustomerID = "";
	}
	rs.getStatement().close();
	
	//业务关联授信额度改为从CREDITLINE_RELA取得
	sSql =	" select count(SerialNo) from CREDITLINE_RELA where ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' " ;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){ 
		i = rs.getInt(1);
	}
	rs.getStatement().close();
	
	sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'");
	if(sCustomerType == null) sCustomerType = "";

	if(dBailRatio == 100) sReturn = "1";//低风险业务
	//else if(!sCreditAggreement.equals("")) sReturn = "2";//授信项下业务 
	else if(i>0) sReturn = "2";//授信项下业务 
	else if(sBusinessType.equals("1020010")) sReturn = "3";//银票贴现业务
	else if(sBusinessType.startsWith("3")) sReturn = "4";//授信业务
	else if (sCustomerType.startsWith("03"))  sReturn = "8";//个人客户
	else if (sCustomerType.equals("0120"))  sReturn = "9";//中小企业客户
	else sReturn = "5";//初上述之外的信贷业务
		
	out.print(sReturn); 
%><%@ include file="/IncludeEndAJAX.jsp"%>