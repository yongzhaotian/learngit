package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * �ڽ����弶����ģ�������󣬽����µ��˹��϶�������µ�CLASSIFY_RECORD���FinallyResult�ֶΡ�
 * @author jgao1
 * @date 2009/10/15
 */
public class UpdateCRFinally extends Bizlet {

	/**
	 * ���˹�����������µ�CLASSIFY_RECORD���С�
	 * @param ObjectNo CLASSIFY_RECORD���е���ˮ��
	 * @param SerialNo FLOW_OPINION���е���ˮ��
	 */
	public Object run(Transaction Sqlca) throws Exception{
		//������ˮ��   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//������ˮ��
		String sSerialNo = (String)this.getAttribute("SerialNo");
		
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
		SqlObject so; //��������
		String sSql = "";
		String sPhaseOpinion= "";
		//ȡ�øý׶��˹��϶����
		sSql = "select PhaseOpinion from FLOW_OPINION where SerialNo=:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
		sPhaseOpinion = Sqlca.getString(so);
		//�����˹��϶����
		sSql="update CLASSIFY_RECORD set FinallyResult  =:FinallyResult where SerialNo =:SerialNo";
		so = new SqlObject(sSql).setParameter("FinallyResult", sPhaseOpinion).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		return "1";
	}
}
