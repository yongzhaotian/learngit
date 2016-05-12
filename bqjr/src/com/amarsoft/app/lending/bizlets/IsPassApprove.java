package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/*
 * Author: ccxie 2010/04/09
 * Tester:
 * Describe: �ж�һ�ʺ�ͬ�Ƿ񾭹���������
 * Input Param:
 * 			ObjectNo: ��ͬ��
 * Output Param:
 * 			false:δ����  
 * 			true :����
 * HistoryLog:
 */
public class IsPassApprove extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			

		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		String sSql = "",approveCount = "",applyCount="";
		SqlObject so;
		sSql = "select count(*) from BUSINESS_CONTRACT BC ,BUSINESS_APPROVE BA where BC.RelativeSerialNo = BA.SerialNo and BC.CustomerID = BA.CustomerID and BC.BusinessType = BA.BusinessType and BC.SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		approveCount = Sqlca.getString(so);
		sSql = "select count(*) from BUSINESS_CONTRACT BC ,BUSINESS_APPLY BA where BC.RelativeSerialNo = BA.SerialNo and BC.CustomerID = BA.CustomerID and BC.BusinessType = BA.BusinessType and BC.SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		applyCount = Sqlca.getString(so);
		
		return !applyCount.equals("0") && approveCount.equals("0")?"false":"true";
	}
}

