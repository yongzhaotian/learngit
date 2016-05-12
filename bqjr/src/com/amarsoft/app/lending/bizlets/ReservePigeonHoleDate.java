/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: ���ù鵵����
 *	Input Param: 	
 *			ObjectNo����������ֵ׼��������ˮ��		
 *	Output Param:			
 *	HistoryLog:
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReservePigeonHoleDate extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception {
		//������ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		String sSql = "";
		
		//����Reserve_Apply�������ֶΣ�ʹ������¼�Զ��鵵
		sSql = " update RESERVE_APPLY set PigeonholeDate=:PigeonholeDate "+
	       " where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("PigeonholeDate", StringFunction.getToday()).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		return "1";	    
	 }
}
