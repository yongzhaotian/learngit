/*
		Author: --zywei 2006-08-18
		Tester:
		Describe: ���µ���Ѻ��״̬�����������/����ۼ�
		Input Param:
			GuarantyID������Ѻ����
			GuarantyStatus������Ѻ��״̬
			UserID���Ǽ��˱��	
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


public class DistributeRiskSignal extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	 {
		SqlObject so ;//��������
		//�Զ���ô���Ĳ���ֵ
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";			
		String sCheckUser   = (String)this.getAttribute("CheckUser");
		if(sCheckUser == null) sCheckUser = "";		
				
		//�������
		String sCheckOrg = "",sCheckDate = "",sUpdateSql = "",sInsertSql = "";
				
		//��ȡϵͳ����
		sCheckDate = StringFunction.getToday();
		//��ȡ�û����ڻ���
		ASUser CurUser = ASUser.getUser(sCheckUser,Sqlca);
		sCheckOrg = CurUser.getOrgID();
		//���Ԥ����Ϣ�ַ���ˮ��
		String sROSerialNo = DBKeyHelp.getSerialNo("RISKSIGNAL_OPINION","SerialNo","",Sqlca);
		
		//����Ԥ���źŵ�Ԥ��״̬
		sUpdateSql = " update RISK_SIGNAL set SignalStatus = '20' "+
		 " where SerialNo =:SerialNo ";
		so = new SqlObject(sUpdateSql).setParameter("SerialNo", sObjectNo);
        Sqlca.executeSQL(so);
        sInsertSql = " insert into RISKSIGNAL_OPINION(ObjectNo,SerialNo,CheckUser,CheckOrg,CheckDate) "+
		 " values (:ObjectNo,:SerialNo,:CheckUser,:CheckOrg,:CheckDate) ";	
        so = new SqlObject(sInsertSql).setParameter("ObjectNo", sObjectNo).setParameter("SerialNo", sROSerialNo).setParameter("CheckUser", sCheckUser)
                .setParameter("CheckOrg", sCheckOrg).setParameter("CheckDate", sCheckDate);
        Sqlca.executeSQL(so); 
		return "1";
	 }
}
