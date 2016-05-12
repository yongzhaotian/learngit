/*
		Author: --wqchen 2010-03-22
		Tester:
		Describe: --��ͬ�������ݴ���
		Input Param:
				ObjectNo: ��ͬ���
				BusinessType: ҵ������
		Output Param:
		
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateBusinessType extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//��ú�ͬ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");//��ͬ���
		//
		String sBusinessType = (String)this.getAttribute("BusinessType");
		
		SqlObject so; //��������
		//����ֵת���ɿ��ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		
		//�������
		String sSql = "";
		sSql = "update BUSINESS_CONTRACT set BusinessType =:BusinessType, " +
			   "InputDate =:InputDate," +
			   "UpdateDate =:UpdateDate," +
			   "PigeonholeDate =:PigeonholeDate " +
			   "where SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("BusinessType", sBusinessType).setParameter("InputDate", StringFunction.getToday())
		.setParameter("UpdateDate", StringFunction.getToday()).setParameter("PigeonholeDate", StringFunction.getToday())
		.setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		
		//�޸�ҵ��Ʒ���Ժ�,����BC���ݴ��־Ϊ'1',��ֹ����ҵ��Ʒ�ֺͺ�ͬ������ϢҪ�ز�һ�µ����
		String sSql1 = "";
		sSql1 = "update BUSINESS_CONTRACT set TempSaveFlag = '1' "+   
				"where SerialNo =:SerialNo ";	
		so = new SqlObject(sSql1).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		return "Success";
	}

}
