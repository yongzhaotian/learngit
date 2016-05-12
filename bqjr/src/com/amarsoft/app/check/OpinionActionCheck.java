package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.lending.bizlets.UpdateFlowOpinion;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * �������Ƿ�ǩ��һ���������ύǰ���
 * @author djia
 * @since 2009/10/29
 */

public class OpinionActionCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		String sSerialNo = (String)this.getAttribute("ObjectNo");
		String sTaskNo = (String)this.getAttribute("TaskNo");
		String sApplyType1 = (String)this.getAttribute("ApplyType1");
		if(sSerialNo == null) sSerialNo = "";
		if(sTaskNo == null) sTaskNo = "";
		if(sApplyType1 == null) sApplyType1 = "";
		
		
		//���������SQL��䡢�������
		String sSql = "",sPhaseOpinion = "";
		
		//����������ˮ�Ŵ����������¼���в�ѯǩ������
		sSql = "select PhaseOpinion from FLOW_OPINION where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("SerialNo", sTaskNo);
		sPhaseOpinion = Sqlca.getString(so);
		
		//����ֵת���ɿ��ַ���
		if (sPhaseOpinion == null || sPhaseOpinion.equals("")) 
			sPhaseOpinion = "";
		else 
			sPhaseOpinion = "�Ѿ�ǩ�����";//��ֹ�лس��������
		
		/** ���ؽ������ **/
		if(sPhaseOpinion == null || sPhaseOpinion.equals("")) {
			setPass(false);
		}else{
			setPass(true);
			
			//ֻ������ҵ������ʱ�����µ���׶ε��������鵽�����������
			if(!sApplyType1.equals("")){
				UpdateFlowOpinion ufo = new UpdateFlowOpinion();
				ufo.setAttribute("ObjectNo", sSerialNo);
				ufo.setAttribute("SerialNo", sTaskNo);
				ufo.run(Sqlca);
			}
		}
		
		return null;
	}

}
