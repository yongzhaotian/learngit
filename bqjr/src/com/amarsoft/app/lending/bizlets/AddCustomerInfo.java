package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class AddCustomerInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sCustomerName = (String)this.getAttribute("CustomerName");
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");
		String sLoanCardNo = (String)this.getAttribute("LoanCardNo");
		String sUserID = (String)this.getAttribute("UserID");
		String sCustomerType = (String)this.getAttribute("CustomerType");
		
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		if(sLoanCardNo == null) sLoanCardNo = "";
		if(sUserID == null) sUserID = "";
		if(sCustomerType == null) sCustomerType = "";
		
		SqlObject so = null;//��������
		
		//�������
		ASResultSet rs = null;
		String sSql = "";
		int iCount = 0;
		
		//ʵ�����û�����
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		
		//���ݿͻ���Ų�ѯϵͳ���Ƿ��ѽ����Ŵ���ϵ
		sSql = 	" select count(CustomerID) from CUSTOMER_INFO "+
		" where CustomerID =:CustomerID"; 
		so = new SqlObject(sSql);
		so.setParameter("CustomerID", sCustomerID);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		if(iCount == 0){			
			if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ent"))//��˾�ͻ�������ͻ�����С��3���ַ�������Ƚ�
			{
				if(sCustomerType.equals("")) sCustomerType="0110";//����ⲿû�д���ͻ����ͣ����Զ�Ĭ��Ϊ������ҵ
				//��CI�����½���¼	
				//�ͻ���š��ͻ����ơ��ͻ����͡�֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ�����	����Դ������������
				sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel,LoanCardNo) "+
				   " values(:CustomerID,:CustomerName,:CustomerType,:CertType,:CertID,:InputOrgID, "+
				   " :InputUserID,:InputDate,'2',:LoanCardNo)";
				so = new SqlObject(sSql);
				so.setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName)
				.setParameter("CustomerType", sCustomerType)
				.setParameter("CertType", sCertType).setParameter("CertID", sCertID).setParameter("InputOrgID", CurUser.getOrgID())
				.setParameter("InputUserID", CurUser.getUserID())
				.setParameter("InputDate", StringFunction.getToday()).setParameter("LoanCardNo", sLoanCardNo);
				Sqlca.executeSQL(so);
				
				//֤������Ϊ��֯��������
				if(sCertType.equals("Ent01"))
				{
					//�ͻ���š���֯��������֤��š��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ�������
					sSql = " insert into ENT_INFO(CustomerID,CorpID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
					   " values(:CustomerID,:CorpID,:EnterpriseName,'0101','0',:InputOrgID,:InputUserID, "+
					   " :InputDate,:UpdateOrgID,:UpdateUserID,:UpdateDate,:LoanCardNo)";
					so = new SqlObject(sSql);
					so.setParameter("CustomerID", sCustomerID).setParameter("CorpID", sCertID).setParameter("EnterpriseName", sCustomerName).setParameter("InputOrgID", CurUser.getOrgID())
					.setParameter("InputUserID", CurUser.getUserID()).setParameter("InputDate", StringFunction.getToday()).setParameter("UpdateOrgID", CurUser.getOrgID())
					.setParameter("UpdateUserID", CurUser.getUserID()).setParameter("UpdateDate",StringFunction.getToday()).setParameter("LoanCardNo", sLoanCardNo);
					Sqlca.executeSQL(so);
					
				//֤������ΪӪҵִ��
				}else if(sCertType.equals("Ent02"))
				{
					//�ͻ���š�Ӫҵִ�պš��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ�������
					sSql = " insert into ENT_INFO(CustomerID,LicenseNo,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
					   " values(:CustomerID,:LicenseNo,:EnterpriseName,'0101','0',:InputOrgID,:InputUserID, "+
					   " :InputDate,:UpdateOrgID,:UpdateUserID,:UpdateDate,:LoanCardNo)";
					so = new SqlObject(sSql);
					so.setParameter("CustomerID", sCustomerID).setParameter("LicenseNo", sCertID).setParameter("EnterpriseName", sCustomerName).setParameter("InputOrgID", CurUser.getOrgID())
					.setParameter("InputUserID", CurUser.getUserID()).setParameter("InputDate", StringFunction.getToday()).setParameter("UpdateOrgID", CurUser.getOrgID())
					.setParameter("UpdateUserID", CurUser.getUserID()).setParameter("UpdateDate", StringFunction.getToday()).setParameter("LoanCardNo", sLoanCardNo);
					Sqlca.executeSQL(so);
				
				}else
				{
					//�ͻ���š��ͻ����ơ��������ʡ����ſͻ���־���Ǽǻ������Ǽ��ˡ��Ǽ����ڡ����»����������ˡ��������ڡ�������
					sSql = " insert into ENT_INFO(CustomerID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
					   " values(:CustomerID,:EnterpriseName,'0101','0',:InputOrgID,:InputUserID,:InputDate, "+
					   " :UpdateOrgID,:UpdateUserID,:UpdateDate,:LoanCardNo)";
					so = new SqlObject(sSql);
					so.setParameter("CustomerID", sCustomerID).setParameter("EnterpriseName", sCustomerName).setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID())
					.setParameter("InputDate", StringFunction.getToday()).setParameter("UpdateOrgID", CurUser.getOrgID()).setParameter("UpdateUserID", CurUser.getUserID())
					.setParameter("UpdateDate", StringFunction.getToday()).setParameter("LoanCardNo", sLoanCardNo);
					Sqlca.executeSQL(so);
				}	
			}else if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ind")) //���˿ͻ�������ͻ�����С��3���ַ�������Ƚ�
			{
				if(sCustomerType.equals("")) sCustomerType="0310";//����ⲿû�д���ͻ����ͣ����Զ�Ĭ��Ϊ���˿ͻ�
				//��CI�����½���¼	
				//�ͻ���š��ͻ����ơ��ͻ����͡�֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ�����	����Դ������������
				sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel,LoanCardNo) "+
				   " values(:CustomerID,:CustomerName,:CustomerType,:CertType,:CertID,:InputOrgID, "+
				   " :InputUserID,:InputDate,'2',null)";
				so = new SqlObject(sSql);
				so.setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("CustomerType", sCustomerType)
				.setParameter("CertType", sCertType).setParameter("CertID", sCertID).setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID())
				.setParameter("InputDate", StringFunction.getToday());
				Sqlca.executeSQL(so);
				
				//�ͻ���š�������֤�����͡�֤����š��Ǽǻ������Ǽ��ˡ��Ǽ����ڡ���������
				sSql = " insert into IND_INFO(CustomerID,FullName,CertType,CertID,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				   " values(:CustomerID,:FullName,:CertType,:CertID,:InputOrgID, "+
				   " :InputUserID,:InputDate,:UpdateDate)";
				so = new SqlObject(sSql);
				so.setParameter("CustomerID", sCustomerID).setParameter("FullName", sCustomerName).setParameter("CertType", sCertType).setParameter("CertID", sCertID)
				.setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID()).setParameter("InputDate", StringFunction.getToday())
				.setParameter("UpdateDate", StringFunction.getToday());
				Sqlca.executeSQL(so);
				
			}else{
				return "1";
			}
			
			String[] belongAttribute = {"1","1","1","1","1"};	//����������Ĭ������ȫ��Ȩ��
			insertCustomerBelong(belongAttribute,sCustomerID,CurUser,Sqlca);
		}else{
			sSql = " select LoanCardNo from CUSTOMER_INFO where CustomerID =:CustomerID ";
			so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			String sExistLoanCardNo = Sqlca.getString(so);
			if(sExistLoanCardNo == null) sExistLoanCardNo = "";
			
			if(sExistLoanCardNo.equals("") || !sExistLoanCardNo.equals(sLoanCardNo))
			{
				sSql = "update CUSTOMER_INFO set LoancardNo =:LoancardNo where CustomerID =:CustomerID";
				so = new SqlObject(sSql);
				so.setParameter("LoancardNo", sLoanCardNo).setParameter("CustomerID", sCustomerID);
				Sqlca.executeSQL(so);
				
				//����ENT_INFO��IND_INFO�еĴ���ţ�����һ��
				if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ent"))//��˾�ͻ�������ͻ�����С��3���ַ�������Ƚ�
			    {
					sSql =  " update ENT_INFO set LoanCardNo =:LoanCardNo where CustomerID =:CustomerID";
					so = new SqlObject(sSql).setParameter("LoanCardNo", sLoanCardNo).setParameter("CustomerID", sCustomerID);
					Sqlca.executeSQL(so);
					
			    }else if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ind")) //���˿ͻ�������ͻ�����С��3���ַ�������Ƚ�
			    {
			    	sSql =  " update IND_INFO set LoanCardNo =:LoanCardNo  where CustomerID =:CustomerID ";
			    	so = new SqlObject(sSql).setParameter("LoanCardNo", sLoanCardNo).setParameter("CustomerID", sCustomerID);
			    	Sqlca.executeSQL(so);
			    }
			}
			String[] belongAttribute = {"2","1","2","2","2"};	//ֻ����Ϣ�鿴Ȩ
			insertCustomerBelong(belongAttribute,sCustomerID,CurUser,Sqlca);
		}
		return "1";
	}
	
	/**
	 * ����������CUSTOMER_BELONG
	 * ����ÿͻ���Ȩ������û�У����봫��Ŀͻ������˹����������ڣ����ý�����
	 * @param attribute [����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ]��־,������Ȳ��������������ʹ��Ĭ��ֵ2,��������������ֻȡǰ���
	 * @param sCustomerID �ͻ�ID
	 * @param CurUser ����û�
	 * @param Sqlca
	 * @throws Exception
	 */
  	private void insertCustomerBelong(String[] attribute,String sCustomerID,ASUser CurUser,Transaction Sqlca) throws Exception{
  		//��鵱ǰ�ͻ����û�����������Ϣ
  		boolean bExists = false;
  		String[] belongAttribute = {"2","2","2","2","2"};	//Ĭ�����κ�Ȩ��
  		for(int i=0;i<attribute.length&&i<belongAttribute.length;i++){
  			belongAttribute[i] = attribute[i];
  		}
  		
  		//���ͻ��Ƿ��뵱ǰ�û� ���������ˣ�����ѽ����������ٽ�������������
  		String sSql = " select UserID from CUSTOMER_BELONG "+
		" where CustomerID =:CustomerID and UserID=:UserID";
  		SqlObject so = new SqlObject(sSql);
  		so.setParameter("CustomerID", sCustomerID).setParameter("UserID", CurUser.getUserID());
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			bExists = true;
		}
		rs.getStatement().close();
		rs = null;
  		if(bExists == false){
  		sSql = "insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3," +
  				" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate)"+
  				" values (:CustomerID,:OrgID,:UserID,:BelongAttribute,:BelongAttribute1,:BelongAttribute2,:BelongAttribute3," +
  				" :BelongAttribute4,:InputOrgID,:InputUserID,:InputDate,:UpdateDate)";
  		so = new SqlObject(sSql);
  		so.setParameter("CustomerID", sCustomerID).setParameter("OrgID", CurUser.getOrgID()).setParameter("UserID", CurUser.getUserID()).setParameter("BelongAttribute", belongAttribute[0])
  		.setParameter("BelongAttribute1", belongAttribute[1]).setParameter("BelongAttribute2", belongAttribute[2]).setParameter("BelongAttribute3", belongAttribute[3])
  		.setParameter("BelongAttribute4", belongAttribute[4]).setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID())
  		.setParameter("InputDate", StringFunction.getToday()).setParameter("UpdateDate", StringFunction.getToday());
  		Sqlca.executeSQL(so);
  		
  		}
  	}
}
