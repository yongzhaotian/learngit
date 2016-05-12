/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: ��������ֵ׼��ȡ���϶������߼�������Reserve_Total�϶���־�ֶ�
 *	Input Param: 	
 *			ObjectNo����������ֵ׼��������ˮ��		
 *	Output Param:			
 *	HistoryLog:
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReserveCancelApply extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception {	
		//������ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		
		String sSql = "",sAccountMonth="",sDuebillNo="";
		ASResultSet rs=null;
		SqlObject so;
		//��ѯ��ֵ׼������Ļ���·����ݺ�
		sSql = "select AccountMonth,DuebillNo from RESERVE_APPLY where SerialNo=:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if (rs.next()){
			sAccountMonth = rs.getString("AccountMonth");
			sDuebillNo = rs.getString("DuebillNo");	
		}
		rs.getStatement().close();
		if(sAccountMonth == null) sAccountMonth = "";
		if(sDuebillNo == null) sDuebillNo = "";
		
		//����Reserve_Total�������ֶΣ��϶��׶�Ϊ�գ��ֽ�������ֵΪ0
		sSql = " update RESERVE_TOTAL set CognizanceFlag=null,AvailAbilityFlag=null,PrdDiscount=0.0 "+
	       " where AccountMonth=:AccountMonth and DuebillNo=:DuebillNo ";
		so = new SqlObject(sSql).setParameter("AccountMonth", sAccountMonth).setParameter("DuebillNo", sDuebillNo);
		Sqlca.executeSQL(so);
		return "1";	    
	 }
}
