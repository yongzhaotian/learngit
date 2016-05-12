package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateCLInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//��������	
	 	String sObjectType = (String)this.getAttribute("ObjectType");
		//������
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//���Ž��
		String sBusinessSum = (String)this.getAttribute("BusinessSum");
		//���ű���
		String sBusinessCurrency = (String)this.getAttribute("BusinessCurrency");
		//���ʹ���������
		String sLimitationTerm = (String)this.getAttribute("LimitationTerm");
		//�����Ч��
		String sBeginDate = (String)this.getAttribute("BeginDate");
		//��ʼ��
		String sPutOutDate = (String)this.getAttribute("PutOutDate");
		//������
		String sMaturity = (String)this.getAttribute("Maturity");
		//�������ҵ����ٵ�������
		String sUseTerm = (String)this.getAttribute("UseTerm");
		//����Ƿ�ѭ��
		String sRotative = (String)this.getAttribute("Rotative");
		
		//����ֵת��Ϊ���ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessSum == null || sBusinessSum.equals("")||sBusinessSum.equalsIgnoreCase("null")) sBusinessSum = "0";
	    if(sBusinessCurrency == null) sBusinessCurrency = "";
	    if(sLimitationTerm == null) sLimitationTerm = "";
	    if(sBeginDate == null) sBeginDate = "";
	    if(sPutOutDate == null) sPutOutDate = "";
	    if(sMaturity == null) sMaturity = "";
	    if(sUseTerm == null) sUseTerm = "";
	    if(sRotative == null) sRotative = "";
	    SqlObject so; //��������
	   	    
		//�������
		String sSql = "";
		
		//���ݶ������͸������Ŷ����Ϣ
		if(sObjectType.equals("CreditApply")){
			sSql = " update CL_INFO set LineSum1 =:LineSum1 ,Currency=:Currency ,Rotative=:Rotative"+
        	   " where ApplySerialNo =:ApplySerialNo and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
			so = new SqlObject(sSql).setParameter("LineSum1", sBusinessSum).setParameter("Currency", sBusinessCurrency).setParameter("Rotative", sRotative)
			.setParameter("ApplySerialNo", sObjectNo);
			Sqlca.executeSQL(so);
		}
		if(sObjectType.equals("ApproveApply")){
			sSql = " update CL_INFO set LineSum1 =:LineSum1,Currency=:Currency "+
        	   " where ApproveSerialNo =:ApproveSerialNo and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
			so = new SqlObject(sSql).setParameter("LineSum1", sBusinessSum).setParameter("Currency", sBusinessCurrency)
			.setParameter("ApproveSerialNo", sObjectNo);
			Sqlca.executeSQL(so);
		}
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("ReinforceContract")){//���ӶԲ��Ƕ�ȵĲ��� jschen 20100317
			sSql = " update CL_INFO set LineSum1 =:LineSum1,Currency=:Currency, "+
        	   		" PutOutDeadLine =:PutOutDeadLine,LineEffDate =:LineEffDate, "+
        	   		" BeginDate =:BeginDate,EndDate =:EndDate,MaturityDeadLine =:MaturityDeadLine "+
        	   		" where BCSerialNo =:BCSerialNo and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
		so = new SqlObject(sSql);
		so.setParameter("LineSum1", sBusinessSum).setParameter("Currency", sBusinessCurrency).setParameter("PutOutDeadLine", sLimitationTerm)
		.setParameter("LineEffDate", sBeginDate).setParameter("BeginDate", sPutOutDate).setParameter("EndDate", sMaturity)
		.setParameter("MaturityDeadLine", sUseTerm).setParameter("BCSerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		}
	   
	    return "1";
	    
	 }

}