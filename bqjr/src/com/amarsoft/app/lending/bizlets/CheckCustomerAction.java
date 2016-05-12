package com.amarsoft.app.lending.bizlets;

/**
 * ���ͻ���Ϣ״̬
 * @author syang 2009/10/27 �����������
 */
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckCustomerAction extends Bizlet 
{
	/**
	 * @param ����˵��
	 *		<p>CustomerType���ͻ�����
	 *			<li>01    ��˾�ͻ�</li>
	 *			<li>0110  ������ҵ</li>  
	 *			<li>0120  ��С��ҵ</li>  
	 *			<li>02    ���ſͻ�</li>  
	 *			<li>0210  ʵ�弯��</li>  
	 *			<li>0220  ���⼯��</li>  
	 *			<li>03    ���˿ͻ�</li>  
	 *			<li>0310  ���˿ͻ�</li>  
	 *			<li>0320  ���徭Ӫ��</li>
	 *		</p>
	 * 		<p>CustomerName	:�ͻ�����</p>
	 * 		<p>CertType		:֤������</p>
	 * 		<p>CertID			:֤����</p>
	 * 		<p>UserID			:�û�ID</p>
	 * @return ����ֵ˵��
	 * 		ReturnStatus: ����״̬
	 * 			<li>01 �޸ÿͻ�</li> 
	 * 			<li>02 ��ǰ�û�����ÿͻ���������</li> 
	 * 			<li>04 ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ</li> 
	 * 			<li>05 ��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ</li> 
	 * 
	 */
	public Object run(Transaction Sqlca) throws Exception{
		
		/**
		 * ��ȡ����
		 */
		String sCustomerType = (String)this.getAttribute("CustomerType");
		String sCustomerName = (String)this.getAttribute("CustomerName");
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");
		String sUserID = (String)this.getAttribute("UserID");	
		
		if(sCustomerType == null) sCustomerType = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		if(sUserID == null) sUserID = "";
		
		/**
		 * �������
		 */
		String sSql = "";
		String sCustomerID = "";			//�ͻ�����
		ASResultSet rs = null;				//��ѯ�����
		String sHaveCutomerType = "";		//ϵͳ���Ѵ��ڸÿͻ��Ŀͻ����ͣ�������������ʱ�Ƿ���ȷ
		String sHaveCutomerTypeName = "";	//ϵͳ���Ѵ��ڸÿͻ��Ŀͻ����ͣ�������������ʱ�Ƿ���ȷ
		String sStatus = "";				//ϵͳ���Ѵ��ڸÿͻ��Ŀͻ����ͣ�������������ʱ�Ƿ���ȷ
		String sReturnStatus = "";			//������Ϣ
		String realCustomerName="";  // У��ͻ�����  added by yzheng 2013-7-2
		
		/**
		 * ��������߼�
		 */
		
		/**  1.���ݿͻ����ͣ�������ӦSQL */
		//01 ��˾�ͻ���ͨ��֤�����͡�֤���������Ƿ���CI���д�����Ϣ	
		if(sCustomerType.substring(0,2).equals("01")){
			sSql = 	" select CustomerID,CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,Status,CustomerName "+
					" from CUSTOMER_INFO "+
					" where CertType = :CertType "+
					" and CertID = :CertID ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CertType", sCertType).setParameter("CertID", sCertID));
			
		//02 ���ſͻ�ͨ���ͻ����Ƽ���Ƿ���CI���д�����Ϣ
		}else if(sCustomerType.substring(0,2).equals("02")){ 
			sSql = 	" select CustomerID,CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,Status,CustomerName "+
					" from CUSTOMER_INFO "+
					" where CustomerName = :CustomerName "+
					" and CustomerType = :CustomerType ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerType", sCustomerType).setParameter("CustomerName", sCustomerName));
		//03 ���˿ͻ�
		}else if(sCustomerType.substring(0,2).equals("03")){
			if(sCertType.equals("Ind01")){	
				//���Ϊ���֤������Ҫ��15λ��18λ���֤ת����Ȼ��ʹ��18λ�����֤ȥƥ��
				String sCertID18 = StringFunction.fixPID(sCertID);
				sSql = 	" select CI.CustomerID as CustomerID,"
						+" CI.CustomerType as CustomerType,"
						+" CI.CustomerName as CustomerName, "	//add by jqcao 	2013-07-09
						+" getItemName('CustomerType',CI.CustomerType) as CustomerTypeName,"
						+" CI.Status as Status"
						+" from IND_INFO II,CUSTOMER_INFO CI"
						+" where II.CustomerID=CI.CustomerID"
						+" and II.CertType = :sCertType "
						+" and II.CertID18 = :sCertID18 ";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCertID18", sCertID18).setParameter("sCertType", sCertType));
			}else{
				sSql = 	" select CustomerID,CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,Status,CustomerName "+
						" from CUSTOMER_INFO "
						+" where CertType =:CertType "
						+" and CertID =:CertID ";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CertType", sCertType).setParameter("CertID", sCertID));
			}
		// ���û��ָ���ͻ����ͣ���ֱ��ʹ��֤�����ͣ�֤���ţ���01 ��˾�ͻ���ͬ��
		}else{
			sSql = 	" select CustomerID,CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,Status,CustomerName "+
					" from CUSTOMER_INFO "+
					" where CertType = :sCertType "+
					" and CertID = :sCertID ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCertID", sCertID).setParameter("sCertType", sCertType));
		}
		
		/** ��ȡ��ѯ��� */
		if(rs.next()){
			sCustomerID = rs.getString("CustomerID");
			sHaveCutomerType = rs.getString("CustomerType");
			sHaveCutomerTypeName = rs.getString("CustomerTypeName");
			sStatus = rs.getString("Status");
			realCustomerName = rs.getString("CustomerName");  //added by yzheng 2013-7-2
		}
		rs.getStatement().close();
		rs = null;
		if(sCustomerID == null) sCustomerID = "";
		if(sHaveCutomerType == null) sHaveCutomerType = "";
		if(sHaveCutomerTypeName == null) sHaveCutomerTypeName = "";
		if(sStatus == null) sStatus = "";
		if(realCustomerName == null) realCustomerName = "";  //added by yzheng 2013-7-2
		
		/** �ͻ���Ϣ���*/
		
		//�޸ÿͻ�
		if(sCustomerID.equals("")){
			sReturnStatus = "01";
			
		//���ڸÿͻ�������ܻ�Ȩ������Ȩ
		}else{
			int iCount = 0;
			//��ȡ��ǰ�ͻ��Ƿ��뵱ǰ�û������˹���
			sSql = 	" select count(CustomerID)"
					+" from CUSTOMER_BELONG "
					+" where CustomerID = :sCustomerID "
					+" and UserID = :sUserID ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sUserID", sUserID).setParameter("sCustomerID", sCustomerID));
			if(rs.next()){
				iCount = rs.getInt(1);
			}
			rs.getStatement().close(); 
			rs = null;
			if(iCount > 0){
				//�û�����ÿͻ�������Ч����
				sReturnStatus = "02";
			}else{
				//���ÿͻ��Ƿ��йܻ���
				sSql = 	" select count(CustomerID) "
						+" from CUSTOMER_BELONG "
						+" where CustomerID = :sCustomerID "
						+" and BelongAttribute = '1'";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", sCustomerID));
				if(rs.next()){
				   	iCount = rs.getInt(1);
				}
				rs.getStatement().close();
				rs = null;
				if(iCount > 0){
					//��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ
					sReturnStatus = "05";
				}else{
					//��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ
					sReturnStatus = "04";
				}
			}

			sReturnStatus = sReturnStatus+"@"+sCustomerID+"@"+sHaveCutomerType+"@"+sHaveCutomerTypeName+"@"+sStatus +"@"+realCustomerName;
		}
		return sReturnStatus;
	}
}
