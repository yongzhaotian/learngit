/*
		Author: --ccxie 2010/03/16
		Tester:
		Describe: --������̵�������
		Input Param:
					SerialNo��������ˮ��
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
import com.amarsoft.context.ASUser;

public class ChangeFlowOperator extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		SqlObject so = null;//��������
		// ��ȡ����	
		String sObjectNo = (String) this.getAttribute("ObjectNo");
		String sObjectType = (String) this.getAttribute("ObjectType");
		String sUserID = (String) this.getAttribute("UserID");
		if (sObjectNo == null) sObjectNo = "";
		if (sObjectType == null) sObjectType = "";
		if (sUserID == null) sUserID = "";
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		so = new SqlObject("select max(SerialNo) from FLOW_TASK where ObjectNo =:ObjectNo  and ObjectType =:ObjectType ").setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
		String sSerialNo = Sqlca.getString(so);
		// �������
		String sSql = "";
		// ���巵�ر���
		String returnResult = "success";
		//��ȡ����ˮ��
		/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
		String newSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK", "SerialNo",Sqlca);*/
		String newSerialNo = DBKeyHelp.getWorkNo();
		/** --end --*/
		
		//���µ���ǰ�����½׶���Ϣ
		sSql = " update FLOW_TASK set EndTime =:EndTime ,PhaseOpinion1='ͬ��',PhaseAction = 'ҵ���ƽ�' where SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("EndTime", StringFunction.getTodayNow()).setParameter("SerialNo", sSerialNo);
		Sqlca.executeSQL(so);
		//����һ�����̵�������¼�¼
		sSql =  " INSERT INTO FLOW_TASK(SerialNo,ObjectNO,ObjectType,RelativeSerialNo,FlowNo,FlowName,PhaseNo,PhaseName," +
				" PhaseType,ApplyType,UserID,UserName,OrgID,OrgName,BeginTime,EndTime) " +
				" select '"+newSerialNo+"' as SerialNo,ObjectNo,ObjectType,'"+sSerialNo+"' as RelativeSerialNo,FlowNo,FlowName,PhaseNo,PhaseName," +
				" PhaseType,ApplyType,'"+CurUser.getUserID()+"','"+CurUser.getUserName()+"','"+CurUser.getOrgID()+"','"+CurUser.getOrgName()+"','"+StringFunction.getTodayNow()+"' as BeginTime,'' as EndTime " +
				" from FLOW_TASK where SerialNo='"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
	
		return returnResult;
	}
}
