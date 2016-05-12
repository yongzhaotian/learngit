/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: ��ϼ���ת����������λ�߼�
 *	Input Param: 
 *			SerialNo:������ˮ��			
 *	Output Param:			
 *	HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReserveCompToSingle extends Bizlet {
	
	public Object  run(Transaction Sqlca) throws Exception {
	 	//��ϼ���ת�������������ˮ��
		String sSerialNo = (String)this.getAttribute("SerialNo");
		if(sSerialNo == null) sSerialNo = "";
		String sSql = "",sAccountMonth="",sDuebillNo="";
		ASResultSet rs =null;
		SqlObject so;
		//������ϼ���ת��������������ˮ�ţ��ڱ�RESERVE_COMPTOSINȡ�û���·ݺͽ�ݺ�
		sSql = "select AccountMonth,DuebillNo from RESERVE_COMPTOSIN where SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
		rs = Sqlca.getASResultSet(so);
		if (rs.next()){
			sAccountMonth = rs.getString("AccountMonth");
			sDuebillNo = rs.getString("DuebillNo");	
		}
		rs.getStatement().close();
		if(sAccountMonth == null) sAccountMonth = "";
		if(sDuebillNo == null) sDuebillNo = "";	
		
		//ִ�и�����䣬�Ѽ���ģʽCalculateFlag����Ϊ20��������ᣬ�����϶��׶�Ϊ�գ��ֽ�������ֵΪ0
		sSql = " update Reserve_Total set CalculateFlag = '20',CognizanceFlag = null,PrdDiscount=0.0,AvailabilityFlag=null "+
		" where AccountMonth =:AccountMonth and DuebillNo =:DuebillNo ";
		 //ִ�и������
		so= new SqlObject(sSql).setParameter("AccountMonth", sAccountMonth).setParameter("DuebillNo", sDuebillNo);
		Sqlca.executeSQL(so);
	    return "1";
	 }
}
