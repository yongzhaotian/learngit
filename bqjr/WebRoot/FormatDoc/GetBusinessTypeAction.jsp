<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Author:
		Tester:
		Content: ȡҵ�����
		Input Param:
			ObjectNo:  ������ˮ��
			ObjectType����������
		Output param:
		History Log: djia ������С��ҵ�ͻ�0120�ж�  2009.10.29
					 xhgao 2009/10/14  ҵ��������Ŷ�ȸ�Ϊ��CREDITLINE_RELAȡ��
	 */
	//���ҳ�����	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo")); 		//������ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));	//��������
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
	
	//ҵ��������Ŷ�ȸ�Ϊ��CREDITLINE_RELAȡ��
	sSql =	" select count(SerialNo) from CREDITLINE_RELA where ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' " ;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){ 
		i = rs.getInt(1);
	}
	rs.getStatement().close();
	
	sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'");
	if(sCustomerType == null) sCustomerType = "";

	if(dBailRatio == 100) sReturn = "1";//�ͷ���ҵ��
	//else if(!sCreditAggreement.equals("")) sReturn = "2";//��������ҵ�� 
	else if(i>0) sReturn = "2";//��������ҵ�� 
	else if(sBusinessType.equals("1020010")) sReturn = "3";//��Ʊ����ҵ��
	else if(sBusinessType.startsWith("3")) sReturn = "4";//����ҵ��
	else if (sCustomerType.startsWith("03"))  sReturn = "8";//���˿ͻ�
	else if (sCustomerType.equals("0120"))  sReturn = "9";//��С��ҵ�ͻ�
	else sReturn = "5";//������֮����Ŵ�ҵ��
		
	out.print(sReturn); 
%><%@ include file="/IncludeEndAJAX.jsp"%>