package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * ����¿ͻ���Ϣ
 * @author syang 2009/10/27 �����������
 *
 */
public class AddCustomerAction4Bmd extends Bizlet {
	/** 
	 * �ͻ�����
	 *	<li>01 ��˾�ͻ�</li> 
	 *		<li>0110 ������ҵ</li>
	 *		<li>0120 ��С��ҵ</li>  
	 *	<li>02 ���ſͻ�</li>  
	 *		<li>0210 ʵ�弯��</li>  
	 *		<li>0220 ���⼯��</li>  
	 *	<li>03 ���˿ͻ�</li>  
	 *		<li>0310 ���˿ͻ�</li>  
	 *		<li>0320 ���徭Ӫ��</li>
	 */
	private String sCustomerType = "";
	/** �ͻ��� */
	private String sCustomerName = "";
	/** ֤������ */
	private String sCertType = "";
	/** ֤���� */
	private String sCertID = "";
	/**
	 *  �ͻ�״̬ 
	 *	<li>01 �޸ÿͻ�</li>
	 *	<li>02 ��ǰ�û�����ÿͻ���������</li>
	 *	<li>04 ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ</li>
	 *	<li>05 ��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ</li>
	 */
	private String sStatus = "";
	/** �ͻ�ID */
	private String sCustomerID = "";
	/** �������� */
	private String sCustomerOrgType = "";
	/** �û�ID */
	private String sUserID = "";
	/** ����ID */
	private String sOrgID = "";
	/**  ���ݿ����� */
	private Transaction Sqlca = null;
	/** �������� */
	private String sToday = "";
	/** ���ſͻ���־ */
	private String sGroupType = "";
	/**���ڿͻ�����*/
	private String sHaCustomerType = "";
	/***************begin CCS-1334 ����ʽ�ᵥhuzp***********************/
	private String MobileTelephone = "";//�ֻ�����
	private String WorkCorp = "";//��λ����
	private String SelfMonthIncome ="";//����������
	private String RelativeType = "";//������ϵ
	private String KinshipName ="";//��������
	private String KinshipTel ="";//������ϵ�绰
	private String Contactrelation = "";//������ϵ�˹�ϵ
	private String OtherContact = "";//������ϵ������
	private String ContactTel ="";//������ϵ�˵绰
	private String switch_status ="";//Ԥ�󿪹�
	/*******************end********************************************/
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
	 * 		<p>Status			:��ǰ�ͻ�״̬
	 * 			<li>01 �޸ÿͻ�</li>
	 * 			<li>02 ��ǰ�û�����ÿͻ���������</li>
	 * 			<li>04 ��ǰ�û�û����ÿͻ���������,��û�к��κοͻ���������Ȩ</li>
	 * 			<li>05 ��ǰ�û�û����ÿͻ���������,���������ͻ���������Ȩ</li>
	 *		</p>
	 * 		<p>UserID			:�û�ID</p>
	 * 		<p>CustomerID		:�ͻ�ID</p>
	 * 		<p>OrgID			:����ID</p>
	 * @return ����ֵ˵��
	 * 		����״̬ 1 �ɹ�,0 ʧ��
	 * 
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/**
		 * ��ȡ����
		 */
		this.Sqlca = Sqlca;

		sCustomerID 		= (String)this.getAttribute("CustomerID");	
		sCustomerName		= (String)this.getAttribute("CustomerName");	
		sCustomerType 		= (String)this.getAttribute("CustomerType");
		sCertType			= (String)this.getAttribute("CertType");
		sCertID 			= (String)this.getAttribute("CertID");	
		sStatus 			= (String)this.getAttribute("Status");
		sCustomerOrgType 	= (String)this.getAttribute("CustomerOrgType");
		sUserID 			= (String)this.getAttribute("UserID");
		sOrgID 				= (String)this.getAttribute("OrgID");
		sHaCustomerType 	= (String)this.getAttribute("HaCustomerType");
		/***************begin CCS-1334 ����ʽ�ᵥhuzp***********************/
		switch_status 		= Sqlca.getString(new SqlObject("select t.switch_status from SYSTEM_SWITCH t where t.switch_type ='PRETRIAL_ENABLE'"));
		if("1".equals(switch_status)){
			MobileTelephone 		= (String)this.getAttribute("MobileTelephone");	
			WorkCorp		= (String)this.getAttribute("WorkCorp");	
			SelfMonthIncome 		= (String)this.getAttribute("SelfMonthIncome");
			RelativeType			= (String)this.getAttribute("RelativeType");
			KinshipName 			= (String)this.getAttribute("KinshipName");	
			KinshipTel 			= (String)this.getAttribute("KinshipTel");
			Contactrelation 	= (String)this.getAttribute("Contactrelation");
			OtherContact 			= (String)this.getAttribute("OtherContact");
			ContactTel 				= (String)this.getAttribute("ContactTel");
			
			if(MobileTelephone == null) MobileTelephone = "";
			if(WorkCorp == null) WorkCorp = "";
			if(SelfMonthIncome == null) SelfMonthIncome = "";
			if(RelativeType == null) RelativeType = "";
			if(KinshipName == null) KinshipName = "";
			if(KinshipTel == null) KinshipTel = "";
			if(Contactrelation == null) Contactrelation = "";
			if(OtherContact == null) OtherContact = "";
			if(ContactTel == null) ContactTel = "";
		}
		/***************end***********************/


		if(sCustomerType == null) sCustomerType = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerOrgType == null) sCustomerOrgType = "";
		if(sStatus == null) sStatus = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		if(sHaCustomerType == null) sHaCustomerType = "";
		
		
//		// ��ȡ�ͻ����
//		String sTempCustomerId = Sqlca.getString(new SqlObject("SELECT CUSTOMERID FROM IND_INFO WHERE CUSTOMERNAME=:CUSTOMERNAME AND CERTID=:CERTID")
//				.setParameter("CUSTOMERNAME", sCustomerName).setParameter("CERTID", sCertID));
//		if (sTempCustomerId != null) {
//			return sTempCustomerId;
//		}
		
		/**
		 * ��������
		 */
		String sReturn = "0";
		
		/**
		 *	�����߼� 
		 */
		sToday = StringFunction.getToday();
		
	   	/** ���ݿͻ��������ü��ſͻ����� */
	  	if(sCustomerType.equals("0210")){ 
			sGroupType = "1";//һ�༯��
	  	}else if(sCustomerType.equals("0220")){ 
			sGroupType = "2";//���༯��
	  	}else{
			sGroupType = "0";//��һ�ͻ�
	  	}
	  	
		//01Ϊ�޸ÿͻ� 
	  	if(sStatus.equals("01")){
	  		try{
	  			/**
	  			 * 1.����CI��
	  			 */
	  			insertCustomerInfo(sCustomerType);
	  			/**
	  			 * 2.����CB��,Ĭ��ȫ�����Ȩ��
	  			 */
	  			insertCustomerBelong("1");
	  			
	  			/**
	  			 * ����ENT_INFO����IND_INFO��
	  			 */
	  			//����customer_center
	  			insertcustomercentre();
	  			
	  			//��˾�ͻ����߼��ſͻ�
	  			if(sCustomerType.substring(0,2).equals("01") ||sCustomerType.substring(0,2).equals("02")){
	  				insertEntInfo(sCustomerType,sCertType);
	  			}else if(sCustomerType.substring(0,2).equals("03")){//���Ѵ����˿ͻ�
	  				insertIndInfo(sCertType);
	  			}else if(sCustomerType.equals("03")){//���������˿ͻ�
	  				insertIndInfo(sCertType);
	  			}else if(sCustomerType.equals("04")){//�������ԹͿͻ�
	  				insertEntInfo(sCustomerType,sCertType);
	  			}else if(sCustomerType.equals("05")){//��������˾�ͻ�
	  				insertEntInfo(sCustomerType,sCertType);
	  			}
	  			sReturn = sCustomerID;
			} catch(Exception e){
				throw new Exception("������ʧ�ܣ�"+e.getMessage());
			}
		//�ÿͻ�û�����κ��û�������Ч����
		}else if(sStatus.equals("04")){
			if(sHaCustomerType.equals(sCustomerType)){
				/**
				 * ����Դ������"2"���"1"
				 */
				String sSql = 	" update CUSTOMER_INFO set Channel = '1' where CustomerID =:CustomerID ";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID", sCustomerID));
				/**
				 * ����CB��,Ĭ��ȫ�����Ȩ��
				 */
				insertCustomerBelong("1");
				sReturn = "1";
			}else{
				/**��������ͻ����ʹ���*/
				sReturn = "2";
			}
		}else if(sStatus.equals("05")){
			if(sHaCustomerType.equals(sCustomerType)){
				insertCustomerBelong("2");
				sReturn = "1";
			}else{
				sReturn = "2";
			}
		}
		return sReturn;
	}
	
	/**
	 * ����������CUSTOMER_INFO
	 * @param cusotmerType �ͻ����ͣ���ͬ�Ŀͻ����ͣ�������ֶλ�������ͬ
	 * @throws Exception 
	 */
  	private void insertCustomerInfo(String customerType) throws Exception{
		StringBuffer sbSql = new StringBuffer();
		SqlObject so ;//��������
		sbSql.append(" insert into CUSTOMER_INFO(") 
			.append(" CustomerID,")					//010.�ͻ����
			.append(" CustomerName,")				//020.�ͻ�����
			.append(" CustomerType,")				//030.�ͻ�����
			.append(" CertType,")					//040.֤������
			.append(" CertID,")						//050.֤����
			.append(" InputOrgID,")					//060.�Ǽǻ���
			.append(" InputUserID,")				//070.�Ǽ��û�
			.append(" InputDate,")					//080.�Ǽ�����
			.append(" Channel")						//090.��Դ����
			.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :InputOrgID, :InputUserID, :InputDate, '1')");
		so = new SqlObject(sbSql.toString());
		so.setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("CustomerType", sCustomerType);
		//���ſͻ�(��֤�����ͣ�֤����)
		if(customerType.substring(0,2).equals("02")){
			so.setParameter("CertType", "").setParameter("CertID", "");
		}else{
			so.setParameter("CertType", sCertType).setParameter("CertID", sCertID);
		}
		so.setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("InputDate", sToday);
		Sqlca.executeSQL(so);
  	}
  	
  	/**
  	 * ����������CUSTOMER_BELONG
  	 * @param attribute [����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ]��־
  	 * @throws Exception
  	 */
  	private void insertCustomerBelong(String attribute) throws Exception{
  		StringBuffer sbSql = new StringBuffer("");
  		SqlObject so ;//��������
		sbSql.append("insert into CUSTOMER_BELONG(")
			.append(" CustomerID,")					//010.�ͻ�ID
			.append(" OrgID,")						//020.��Ȩ����ID
			.append(" UserID,")						//030.��Ȩ��ID
			.append(" BelongAttribute,")			//040.����Ȩ
			.append(" BelongAttribute1,")			//050.��Ϣ�鿴Ȩ
			.append(" BelongAttribute2,")			//060.��Ϣά��Ȩ
			.append(" BelongAttribute3,")			//070.ҵ�����Ȩ
			.append(" BelongAttribute4,")			//080.
			.append(" InputOrgID,")					//090.�Ǽǻ���
			.append(" InputUserID,")				//100.�Ǽ���
			.append(" InputDate,")					//110.�Ǽ�����
			.append(" UpdateDate")					//120.��������
			.append(" )values(:CustomerID, :OrgID1, :UserID1, :attribute, :attribute1, :attribute2, :attribute3, :attribute4, :OrgID2, :UserID2, :InputDate, :UpdateDate)");
		so = new SqlObject(sbSql.toString()).setParameter("CustomerID", sCustomerID).setParameter("OrgID1", sOrgID).setParameter("UserID1", sUserID)
		.setParameter("attribute", attribute).setParameter("attribute1", attribute).setParameter("attribute2", attribute)
		.setParameter("attribute3", attribute).setParameter("attribute4", attribute).setParameter("OrgID2", sOrgID).setParameter("UserID2", sUserID)
		.setParameter("InputDate", sToday).setParameter("UpdateDate", sToday);
		Sqlca.executeSQL(so);
  	}
  	
  	/**
  	 * ����������ENT_INFO,��ͬ�Ŀͻ������Լ�֤�����ͣ�������ֶλ�������
  	 * @param customerType �ͻ�����
  	 * @param certType	֤������
  	 * @throws Exception 
  	 */
  	private void insertEntInfo(String customerType,String certType) throws Exception{
  		SqlObject so =null;//��������
  		StringBuffer sbSql = new StringBuffer("");
  		//�Ȳ���ͨ����Ϣ
  		sbSql.append("insert into ENT_INFO(")
			.append(" CustomerID,")					//010.�ͻ�ID
			.append(" CustomerName,")				//020.�ͻ�����
			.append(" CustomerType,")				//030.�ͻ�����
			.append(" CertType,")					//030.֤������
			.append(" CertID,")						//050.֤����
			.append(" OrgNature,")					//040.��������
			.append(" GroupFlag,")					//050.���ſͻ���־
			.append(" InputUserID,")				//060.�Ǽ���
			.append(" InputOrgID,")					//070.�Ǽǻ���
			.append(" InputDate,")					//080.�Ǽ�����
			.append(" UpdateUserID,")				//090.������
			.append(" UpdateOrgID,")				//100.���»���
			.append(" UpdateDate,")					//110.��������
			.append(" TempSaveFlag")				//120.�ݴ��־
			.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :OrgNature, :GroupFlag, :InputUserID, :InputOrgID, :InputDate, :UpdateUserID, :UpdateOrgID, :UpdateDate, '1')");
		so = new SqlObject(sbSql.toString());
		so.setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("CustomerType", sCustomerType).setParameter("CertType", sCertType).setParameter("CertID", sCertID).setParameter("OrgNature", sCustomerOrgType).setParameter("GroupFlag", sGroupType);
		so.setParameter("InputUserID", sUserID).setParameter("InputOrgID", sOrgID).setParameter("InputDate", sToday);
		so.setParameter("UpdateUserID", sUserID).setParameter("UpdateOrgID", sOrgID).setParameter("UpdateDate", sToday);
		Sqlca.executeSQL(so);
		
		//�ٸ���������Ϣ
  		//[01] ��˾�ͻ�   [04]�Թ�    [05]��˾
  	/*	if(sCustomerType.substring(0,2).equals("01") || sCustomerType.equals("04") || sCustomerType.equals("05")){
			//֤������ΪӪҵִ�� 
			if(sCertType.equals("Ent02")){
				//����Ӫҵִ�պ�
				Sqlca.executeSQL(new SqlObject("update ENT_INFO set CertID = :CertID where CustomerID = :CustomerID").setParameter("CustomerID", sCustomerID).setParameter("CertID", sCertID));
			//����֤��
			}else{
				Sqlca.executeSQL(new SqlObject("update ENT_INFO set CorpID = :CorpID where CustomerID = :CustomerID").setParameter("CustomerID", sCustomerID).setParameter("CorpID", sCertID));
			}
		//[02] �������ſͻ�
  		}else if(sCustomerType.substring(0,2).equals("02")){
			//������֯�������루ϵͳ�Զ����⣬ͬ���ſͻ���ţ�
			Sqlca.executeSQL(new SqlObject("update ENT_INFO set CorpID = :CorpID where CustomerID = :CustomerID").setParameter("CustomerID", sCustomerID).setParameter("CorpID", sCustomerID));
  		}*/
  	}
  	
  	/**
  	 * ����������IND_INFO,��ͬ��֤�����ͣ�������ֶλ�������
  	 * @throws Exception 
  	 */
  	private void insertIndInfo(String certType) throws Exception{
  		String sCertID18 = "";
  		StringBuffer sbSql = new StringBuffer("");
  		//���Ϊ���֤,����18λת��
  		if(certType.equals("Ind01")){
  			sCertID18 = StringFunction.fixPID(sCertID);
  		}else{
  			sCertID18 = "";
  		}
		/***************begin CCS-1334 ����ʽ�ᵥhuzp***********************/
		if("1".equals(switch_status)){
		sbSql.append("insert into IND_INFO(")
		.append(" CustomerID,")					//010.�ͻ�ID
		.append(" CustomerName,")				//020.�ͻ���
		.append(" CustomerType,")				//020.�ͻ�����
		.append(" CertType,")					//030.֤������
		.append(" CertID,")						//040.֤����
		.append(" CertID18,")					//050.18λ֤����
		.append(" InputOrgID,")					//060.�Ǽǻ���
		.append(" InputUserID,")				//070.�Ǽ���
		.append(" InputDate,")					//080.�Ǽ�����
		.append(" UpdateDate,")					//090.��������

		.append(" MobileTelephone,")					//�ֻ���
		.append(" WorkCorp,")							//��λ����
		.append(" SelfMonthIncome,")					//����������
		.append(" RelativeType,")						//������ϵ
		.append(" KinshipName,")						//��������
		.append(" KinshipTel,")							//������ϵ�绰
		.append(" Contactrelation,")					//������ϵ�˹�ϵ
		.append(" OtherContact,")						//������ϵ������
		.append(" ContactTel,")							//������ϵ�˵绰
		
		.append(" TempSaveFlag")				//100.�ݴ��־
		.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :CertID18, :sOrgID, :sUserID, :InputDate, :UpdateDate,"
				+ ":MobileTelephone, :WorkCorp, :SelfMonthIncome, :RelativeType, :KinshipName, :KinshipTel, :Contactrelation, :OtherContact, :ContactTel, '1')");
		SqlObject so = new SqlObject(sbSql.toString()).setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("CustomerType", sCustomerType)
				.setParameter("CertType", sCertType).setParameter("CertID", sCertID).setParameter("CertID18", sCertID18)
				.setParameter("sOrgID", sOrgID).setParameter("sUserID", sUserID).setParameter("InputDate", sToday).setParameter("UpdateDate", sToday)
				.setParameter("MobileTelephone", MobileTelephone).setParameter("WorkCorp", WorkCorp).setParameter("SelfMonthIncome", SelfMonthIncome).setParameter("RelativeType", RelativeType)
				.setParameter("KinshipName", KinshipName).setParameter("KinshipTel", KinshipTel).setParameter("Contactrelation", Contactrelation).setParameter("OtherContact", OtherContact)
				.setParameter("ContactTel", ContactTel);
		Sqlca.executeSQL(so);
		}else{
			sbSql.append("insert into IND_INFO(")
			.append(" CustomerID,")					//010.�ͻ�ID
			.append(" CustomerName,")				//020.�ͻ���
			.append(" CustomerType,")				//020.�ͻ�����
			.append(" CertType,")					//030.֤������
			.append(" CertID,")						//040.֤����
			.append(" CertID18,")					//050.18λ֤����
			.append(" InputOrgID,")					//060.�Ǽǻ���
			.append(" InputUserID,")				//070.�Ǽ���
			.append(" InputDate,")					//080.�Ǽ�����
			.append(" UpdateDate,")					//090.��������
			.append(" TempSaveFlag")				//100.�ݴ��־
			.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :CertID18, :sOrgID, :sUserID, :InputDate, :UpdateDate, '1')");
		SqlObject so = new SqlObject(sbSql.toString()).setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("CustomerType", sCustomerType)
					.setParameter("CertType", sCertType).setParameter("CertID", sCertID).setParameter("CertID18", sCertID18)
					.setParameter("sOrgID", sOrgID).setParameter("sUserID", sUserID).setParameter("InputDate", sToday).setParameter("UpdateDate", sToday);
		Sqlca.executeSQL(so);
		}
		/********************end******************************/
  	}
	/**
  	 * ����������CUSTOMER_CENTER
  	 * @throws Exception 
  	 */
	private void insertcustomercentre() throws Exception{
  		StringBuffer sbSql = new StringBuffer("");
  		sbSql.append("INSERT INTO CUSTOMER_CENTER(")
  		.append(" CustomerID,")	
  		.append(" CUSTOMERNAME,")
  		.append(" CERTID,")
  		.append(" CertType")	
  		.append(" )values(:CustomerID, :CustomerName, :CertID,:CertType)");
  		SqlObject so = new SqlObject(sbSql.toString())
  		.setParameter("CustomerID", sCustomerID)
  		.setParameter("CustomerName", sCustomerName)
  		.setParameter("CertID", sCertID)
  		.setParameter("CertType", sCertType);
  		Sqlca.executeSQL(so);
  	}
  	
}
