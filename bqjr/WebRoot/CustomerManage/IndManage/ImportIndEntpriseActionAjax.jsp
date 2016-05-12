<%@page import="org.apache.tomcat.util.digester.SetPropertiesRule"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
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
	 */
	//���������Sql��䡢������Ϣ���ͻ����롢����Ȩ
	String sSql = "",sReturnStatus = "",sCustomerID = "",sBelongAttribute = "";
	String sCustomerType = "",sStatus = "",sUserID = "";
	//���������������
	int iCount = 0;
	//�����������ѯ�����
	ASResultSet rs = null;
	
	//��ȡҳ��������ͻ����͡��ͻ����ơ�֤�����͡�֤�����
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));	
	String sCertType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertType"));
	String sCertID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));	
	String sRelativeSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeSerialNo"));
	//����ֵת��Ϊ���ַ���
	if(sCustomerName == null) sCustomerName = "";
	if(sRelativeSerialNo == null) sRelativeSerialNo = "";
	if(sCertType == null) sCertType = "";
	if(sCertID == null) sCertID = "";	
		
	sSql = " select CustomerID,CustomerType,Status "+
			" from CUSTOMER_INFO "+
			" where CertType = :CertType and CertID = :CertID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CertType",sCertType).setParameter("CertID",sCertID));
	if(rs.next()){
		sCustomerID = rs.getString("CustomerID");
		sCustomerType = rs.getString("CustomerType");
		sStatus = rs.getString("Status");
	}
	rs.getStatement().close();
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerType == null) sCustomerType = "";
	if(sStatus == null) sStatus = "";
	
	if(sCustomerID.equals("")){
		//ϵͳ���޸ÿͻ�����ȷ��¼��Ļ��������Ƿ���ȷ
		sReturnStatus = "01";
	}else{
		//�õ���ǰ�û���ÿͻ�֮������Ȩ�Ĺ�ϵ
		sSql = 	" select UserID "+
				" from CUSTOMER_BELONG "+
				" where CustomerID = :CustomerID "+
				" and BelongAttribute = '1'";
		sUserID = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
		if(sUserID == null) sUserID = "";
		if(sUserID.equals(CurUser.getUserID()) || sUserID.equals("")){
			if(!sCustomerType.equals("0120")){
				sReturnStatus = "02";//�ÿͻ����Ͳ�����С��ҵ���͡�
			}else{
				//1�������϶�����С��ҵ��8������˾�Ӫ����ҵ
				if(sStatus.equals("1")){
					sReturnStatus = "03";//������С��ҵ����
				}else if(sStatus.equals("8")){
					if(sUserID.equals(CurUser.getUserID()))
						sReturnStatus = "04";//�ø��˾�Ӫ���Ѵ���
					if(sUserID.equals(""))
						sReturnStatus = "05";//ȡ�øÿͻ��Ĺܻ�Ȩ����
				}else{
					sReturnStatus = "06";//����С��ҵ����δ���϶�
				}
			}
		}else{
			sReturnStatus = "07";//�ÿͻ��뵱ǰ�û�û������Ȩ��ϵ
		}		
	}
	
	//���״̬"03"��"05"�����������
	if(sReturnStatus.equals("03")){
		//����δ�ս�����ҵ����
		sSql = " select count(SerialNo) from BUSINESS_APPLY "+
			   " where CustomerID = :CustomerID "+
		       " and PigeonholeDate is null "+
		       " and OperateUserID = :OperateUserID " ;
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("OperateUserID",sUserID));
		if(rs.next()) iCount = rs.getInt(1);
		rs.getStatement().close(); 		
		if (iCount == 0){	//����ҵ��ȫ���ս�
			//����δ�ս������������ҵ����
			sSql = " select count(*) from BUSINESS_APPROVE "+
			   " where CustomerID = :CustomerID "+
		       " and PigeonholeDate is null "+
		       " and OperateUserID = :OperateUserID " ;
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("OperateUserID",sUserID));
			if(rs.next()) iCount = rs.getInt(1);
			rs.getStatement().close();
			if(iCount == 0){	//�����������ҵ��ȫ���ս�
				//����δ�ս��ͬҵ����
				sSql = " select count(*) from BUSINESS_CONTRACT "+
					   " where CustomerID = :CustomerID "+
				       " and FinishDate is null "+
				       " and ManageUserID = :ManageUserID " ;
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("ManageUserID",sUserID));
				if(rs.next()) iCount = rs.getInt(1);
				rs.getStatement().close();
				if (iCount == 0){	//��ͬҵ��ȫ���ս�
					if(sUserID.equals("")){
						//���ӹܻ�Ȩ
						String sNewSql = " insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3, "+
										 " BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
										 " values(:CustomerID,:OrgID,:UserID,'1','1','1','1','1',:InputOrgID, "+
										 " :InputUserID,:InputDate,:UpdateDate)";
						SqlObject so = new SqlObject(sNewSql);
						so.setParameter("CustomerID",sCustomerID);
						so.setParameter("OrgID",CurOrg.getOrgID());
						so.setParameter("UserID",CurUser.getUserID());
						so.setParameter("InputOrgID",CurOrg.getOrgID());
						so.setParameter("InputUserID",CurUser.getUserID());
						so.setParameter("InputDate",StringFunction.getToday());
						so.setParameter("UpdateDate",StringFunction.getToday());
						Sqlca.executeSQL(so);
					}
					if(sUserID.equals(CurUser.getUserID())){
						//������С��ҵ��־��
						sSql = " update CUSTOMER_INFO set Status = '8' where CustomerID = :CustomerID";
						Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));						
					}
					//ɾ���ÿͻ��������Ĺ�������֤Ψһ
					sSql = "delete from SME_CUSTRELA where CustomerID=:CustomerID";
					Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
					//���ӹ���
					sSql = 	" insert into SME_CUSTRELA(CustomerID,RelativeSerialNo,ObjectType) "+
							" values(:CustomerID,:RelativeSerialNo,'Customer')";
					Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("RelativeSerialNo",sRelativeSerialNo));
					//���³ɹ�
					sReturnStatus = "09";
				}else{
					sReturnStatus = "10";//�ÿͻ�����δ�ս�ĺ�ͬ��Ϣ
				}
			}else{
				sReturnStatus = "11";//�ÿͻ�����δ��ɵ������������
			}
		}else{
			sReturnStatus = "12";//�ÿͻ�����δ��ɵ�ҵ������
		}
	}
	if(sReturnStatus.equals("05")){
		//���ӹܻ�Ȩ
		sSql = 	" insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3, "+
				" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				" values(:CustomerID,:OrgID,:UserID,'1','1','1','1','1',:InputOrgID, "+
				" :InputUserID,:InputDate,:UpdateDate)";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("OrgID",CurOrg.getOrgID());
		so.setParameter("UserID",CurUser.getUserID());
		so.setParameter("InputOrgID",CurOrg.getOrgID());
		so.setParameter("InputUserID",CurUser.getUserID());
		so.setParameter("InputDate",StringFunction.getToday());
		so.setParameter("UpdateDate",StringFunction.getToday());
		Sqlca.executeSQL(so);
		//ɾ���ÿͻ��������Ĺ�������֤Ψһ
		sSql = "delete from SME_CUSTRELA where CustomerID=:CustomerID";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
		//���ӹ���
				/*" values('"+sCustomerID+"','"+sRelativeSerialNo+"','Customer')";*/
		sSql = 	" insert into SME_CUSTRELA(CustomerID,RelativeSerialNo,ObjectType) "+
				" values(:CustomerID,:RelativeSerialNo,'Customer')";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID",sCustomerID).setParameter("RelativeSerialNo",sRelativeSerialNo));
		sReturnStatus = "09";//���³ɹ�
	}
	out.println(sReturnStatus);//���ؼ��״ֵ̬�Ϳͻ���
%><%@ include file="/IncludeEndAJAX.jsp"%>