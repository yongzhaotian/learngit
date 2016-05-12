<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: �ͻ���Ϣ���
		Input Param:
			CustomerType���ͻ�����
					01����˾�ͻ���
					0201��һ�༯�ſͻ���
					0202�����༯�ſͻ���ϵͳ��ʱ���ã���
					03�����˿ͻ���
			CustomerName:�ͻ�����
			CertType:�ͻ�֤������
			CertID:�ͻ�֤������
		Output param:
  			ReturnStatus:����״̬
				01Ϊ�޸ÿͻ�
				02Ϊ��ǰ�û�����ÿͻ���������
				04Ϊ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ.
				05Ϊ��ǰ�û�û����ÿͻ���������,���к������ͻ���������Ȩ.
		History Log: 			
			2005/09/10 �ؼ����
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>���ͻ���Ϣ</title>
<%
	//���������Sql��䡢������Ϣ���ͻ����롢����Ȩ
	String sSql = "",sReturnStatus = "",sCustomerID = "",sBelongAttribute = "";	
	//���������������
	int iCount = 0;
	//�����������ѯ�����
	ASResultSet rs = null;
	SqlObject so = null;
	String sHaveCutomerType = "";//ϵͳ���Ѵ��ڸÿͻ��Ŀͻ����ͣ�������������ʱ�Ƿ���ȷ
	String sHaveCutomerTypeName = "";//ϵͳ���Ѵ��ڸÿͻ��Ŀͻ����ͣ�������������ʱ�Ƿ���ȷ
	String sStatus = "";//ϵͳ���Ѵ��ڸÿͻ��Ŀͻ����ͣ�������������ʱ�Ƿ���ȷ
	
	//��ȡҳ��������ͻ����͡��ͻ����ơ�֤�����͡�֤�����
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));	
	String sCertType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertType"));
	String sCertID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));	
	//����ֵת��Ϊ���ַ���
	if(sCustomerType == null) sCustomerType = "";
	if(sCustomerName == null) sCustomerName = "";
	if(sCertType == null) sCertType = "";
	if(sCertID == null) sCertID = "";
	
	if(sCustomerType.substring(0,2).equals("03")){	
		if(sCertType.equals("Ind01")){	//���Ϊ���֤������Ҫ��15λ��18λ���֤ת��
			String sCertID18 = StringFunction.fixPID(sCertID);
			sSql = 	" select CI.CustomerID as CustomerID,"
			+" CI.CustomerType as CustomerType,"
			+" getItemName('CustomerType',CI.CustomerType) as CustomerTypeName,"
			+" CI.Status as Status"+
			" from IND_INFO II,CUSTOMER_INFO CI"+
			" where II.CustomerID=CI.CustomerID"
			+" and II.CertType =:II.CertType "+
			" and II.CertID18 =:II.CertID18 ";
			so = new SqlObject(sSql).setParameter("II.CertType",sCertType).setParameter("II.CertID18",sCertID18);
		}else{
			sSql = 	" select CustomerID,CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,Status "+
			" from CUSTOMER_INFO "+
			" where CertType =:CertType "+
			" and CertID =:CertID ";
			so = new SqlObject(sSql).setParameter("CertType",sCertType).setParameter("CertID",sCertID);
		}
	//�ǹ������ſͻ���ͨ��֤�����͡�֤���������Ƿ���CI���д�����Ϣ	
	}else if(!sCustomerType.substring(0,2).equals("02")){
		sSql = 	" select CustomerID,CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,Status "+
				" from CUSTOMER_INFO "+
				" where CertType =:CertType "+
				" and CertID =:CertID ";
		so = new SqlObject(sSql).setParameter("CertType",sCertType).setParameter("CertID",sCertID);
	}else{ //�������ſͻ�ͨ���ͻ����Ƽ���Ƿ���CI���д�����Ϣ
		sSql = 	" select CustomerID,CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,Status "+
				" from CUSTOMER_INFO "+
				" where CustomerName =:CustomerName "+
				" and CustomerType =:CustomerType ";
		so = new SqlObject(sSql).setParameter("CustomerName",sCustomerName).setParameter("CustomerType",sCustomerType);
	}
	rs = Sqlca.getASResultSet(so);
	if(rs.next()){
		sCustomerID = rs.getString("CustomerID");
		sHaveCutomerType = rs.getString("CustomerType");
		sHaveCutomerTypeName = rs.getString("CustomerTypeName");
		sStatus = rs.getString("Status");
	}
	rs.getStatement().close();
	if(sCustomerID == null) sCustomerID = "";
	if(sHaveCutomerType == null) sHaveCutomerType = "";
	if(sHaveCutomerTypeName == null) sHaveCutomerTypeName = "";
	if(sStatus == null) sStatus = "";
	if(sCustomerID.equals("")){
		//�޸ÿͻ�
		sReturnStatus = "01"+"@"+sCustomerID+"@"+sHaveCutomerType+"@"+sHaveCutomerTypeName+"@"+sStatus;
	}else{
		//�õ���ǰ�û���ÿͻ�֮��ܻ���ϵ
		sSql = 	" select count(CustomerID) "+
				" from CUSTOMER_BELONG "+
				" where CustomerID =:CustomerID "+
				" and UserID =:UserID ";
		so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("UserID",CurUser.getUserID());
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		   	iCount = rs.getInt(1);
		rs.getStatement().close();		
		if(iCount > 0){
  			//02Ϊ��ǰ�û�����ÿͻ�������Ч����
 			sReturnStatus = "02"+"@"+sCustomerID+"@"+sHaveCutomerType+"@"+sHaveCutomerTypeName+"@"+sStatus;
		}else{
			//���ÿͻ��Ƿ��йܻ���
			sSql = 	" select count(CustomerID) "+
					" from CUSTOMER_BELONG "+
					" where CustomerID =:CustomerID "+
					" and BelongAttribute = '1'";
			so = new SqlObject(sSql).setParameter("CustomerID",sCustomerID);
			rs = Sqlca.getASResultSet(so);
			if(rs.next())
			   	iCount = rs.getInt(1);	
			rs.getStatement().close(); 			
			if(iCount > 0){
  				//05Ϊ��ǰ�û�û����ÿͻ���������,���кͿͻ���������Ȩ.
				sReturnStatus = "05"+"@"+sCustomerID+"@"+sHaveCutomerType+"@"+sHaveCutomerTypeName+"@"+sStatus;
			}else{
  				//04Ϊ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ.
				sReturnStatus = "04"+"@"+sCustomerID+"@"+sHaveCutomerType+"@"+sHaveCutomerTypeName+"@"+sStatus;
			}
		}
	}		
	
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnStatus);
	sReturnStatus = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnStatus);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>