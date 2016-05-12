/**
 * ȡ�õ�����ͬ�Ŀ��õ������
 * @author syang
 * @date 2009/10/20
 */
package com.amarsoft.app.creditline.bizlets;

import java.text.DecimalFormat;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;



public class GetGuarantyBalance extends Bizlet {

 public Object  run(Transaction Sqlca) throws Exception{
	 
	 	/**
	 	 * ������ͬ��
	 	 */
	 	String sGuarantyNo = (String)this.getAttribute("GuarantyNo");
	 	if(sGuarantyNo == null) sGuarantyNo = "";
	 	
	 	/**
	 	 * �������
	 	 */
	 	String sSql = "";
	 	String sTmp = "";
	 	
	 	double dUsedLimit = 0.0;		//��ռ�ö��
	 	double dGuarantySum = 0.0;		//�ܵ������
	 	double dGuarantyBalance = 0.0; 	//�������
		SqlObject so = null;//��������
	 	
	 	//��ѯ�ñʵ�������������ҵ���ͬ������ȡ����Ч��ͬ���������ǵ��ܶ�
		sSql = "select sum(Balance*GetErate(businesscurrency,'01','')) from BUSINESS_CONTRACT BC "
	 			+" where SerialNo in("
	 			+" select SerialNo from Contract_Relative "
	 			+" where objecttype='GuarantyContract' "
	 			+" and ObjectNo=:ObjectNo "
	 			+")"
	 			+" and (BC.FinishDate is null or BC.FinishDate = '' or BC.FinishDate = ' ')"
	 			;
		so = new SqlObject(sSql);
		so.setParameter("ObjectNo", sGuarantyNo);
		sTmp = Sqlca.getString(so);
	 	if(sTmp == null) sTmp = "0";
	 	
	 	dUsedLimit = Double.parseDouble(sTmp);
	 	
	 	//ȡ���������ܶ�
	 	sSql = "select GuarantyValue*GetErate(GuarantyCurrency,'01','') from GUARANTY_CONTRACT GC where SerialNo=:SerialNo";
	 	so = new SqlObject(sSql);
		so.setParameter("SerialNo", sGuarantyNo);
		sTmp = Sqlca.getString(so);
	 	if(sTmp == null) sTmp = "0";
	 	dGuarantySum = Double.parseDouble(sTmp);
	 	
	 	//���㵣�����
	 	dGuarantyBalance = dGuarantySum - dUsedLimit;
	 	DecimalFormat df = new DecimalFormat("#.####");//�����С��������4λС��
	 	sTmp = df.format(dGuarantyBalance);
	 	return sTmp;
 }
}
