/*
		Author: --ccxie 2010/03/16
		Tester:
		Describe: --������̵�������
		Input Param:
					SerialNo��������ˮ��
					ObjectNo: ҵ�������
					ObjectType:��������
		Output Param:
					returnResult�������Ƿ�ɹ���־
		HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ChangeFlowPhase extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {

		// ��ȡ����
		String sSerialNo = (String) this.getAttribute("SerialNo");
		String sObjectNo = (String) this.getAttribute("ObjectNo");
		String sObjectType = (String) this.getAttribute("ObjectType");
		if (sSerialNo == null) sSerialNo = "";
		if (sObjectNo == null)  sObjectNo = "";
		if (sObjectType == null) sObjectType = "";
		// �������
		String sSql = "";
		SqlObject so ;//��������
		// ���巵�ر��� 
		String returnResult = "success";
		//��ȡ��ǰ���̵������ˮ���к���Ϊ�¼�¼��RelativeSerialNo
		so = new SqlObject("select max(SerialNo) from FLOW_TASK F1 where ObjectNo =:ObjectNo and ObjectType =:ObjectType ").setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
		String maxSerialNo = Sqlca.getString(so);
		
		//��ȡ�µ���ˮ��
		/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
		String newSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK", "SerialNo",Sqlca);*/
		String newSerialNo = DBKeyHelp.getWorkNo();
		/** --end --*/

		//���µ���ǰ�����½׶���Ϣ
		sSql =  " update FLOW_TASK set EndTime =:EndTime ,PhaseOpinion1='ͬ��',PhaseAction = '���̵���' where SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("EndTime", StringFunction.getTodayNow()).setParameter("SerialNo", maxSerialNo);
		Sqlca.executeSQL(so);
		
		//����һ�����̵�������¼�¼
		sSql =  " INSERT INTO FLOW_TASK(SerialNo,ObjectNO,ObjectType,RelativeSerialNo,FlowNo,FlowName,PhaseNo,PhaseName," +
				" PhaseType,ApplyType,UserID,UserName,OrgID,OrgName,BeginTime,EndTime) " +
				" select '"+newSerialNo+"' as SerialNo,ObjectNo,ObjectType,'"+maxSerialNo+"' as RelativeSerialNo,FlowNo,FlowName,PhaseNo,PhaseName," +
				" PhaseType,ApplyType,UserID,UserName,OrgID,OrgName,'"+StringFunction.getTodayNow()+"' as BeginTime,'' as EndTime " +
				" from FLOW_TASK where SerialNo='"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
		//�������̶����Ľ׶���Ϣ
		sSql = 	" update FLOW_OBJECT FO set (PhaseNo, PhaseType,PhaseName) = (select PhaseNo, PhaseType,PhaseName from FLOW_TASK where SerialNo =:SerialNo) " +
		" where ObjectNo =:ObjectNo and ObjectType =:ObjectType ";
        so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
        Sqlca.executeSQL(so);
		return returnResult;
	}
}
