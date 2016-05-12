package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * �����õȼ�����ʱ�������µ��˹�����������µ�EVALUATE_RECORD���С�
 * @author cbsu 2009-11-10
 */
public class UpdateEvaluateManResult extends Bizlet {

    /**
     * �����õȼ�����ʱ�������µ��˹�����������µ�EVALUATE_RECORD���CognScore��CognResult�ֶΡ�
     * @param ObjectNo EVALUATE_RECORD���е���ˮ��
     * @param SerialNo FLOW_OPINION���е���ˮ��
     */
    public Object run(Transaction Sqlca) throws Exception{
        
        //������ˮ��   
        String sEvaluateSerialNo = (String)this.getAttribute("ObjectNo");
        //������ˮ��
        String sFlowOpinionSerialNo = (String)this.getAttribute("SerialNo");
        if(sEvaluateSerialNo == null) sEvaluateSerialNo = "";
        if(sFlowOpinionSerialNo == null) sFlowOpinionSerialNo = "";
        
        String sSql = "";
        String sPhaseOpinion2 = "";
        double dBailSum = 0.0;
        String sInputTime = "";
        String sUpdateUser = "";
        String sInputOrg = "";
        //�˹����������Ƿ���ڵı�־λ
        boolean isManResultExisted = false;
        ASResultSet rs = null;
        SqlObject so;

        //ȡ�øý׶��˹��϶����
        sSql = "select PhaseOpinion2, BailSum, InputTime, UpdateUser, InputOrg from FLOW_OPINION where SerialNo=:SerialNo ";
        so = new SqlObject(sSql).setParameter("SerialNo", sFlowOpinionSerialNo);
        rs = Sqlca.getASResultSet(so);
        while (rs.next()) {
            sPhaseOpinion2 = rs.getString("PhaseOpinion2");
            dBailSum = rs.getDouble("BailSum");
            sInputTime = rs.getString("InputTime");
            sUpdateUser = rs.getString("UpdateUser");
            sInputOrg = rs.getString("InputOrg");
            isManResultExisted = true;
        }
        rs.getStatement().close();
        
        if (sPhaseOpinion2 == null) sPhaseOpinion2 = "";
        if (sInputTime == null) sInputTime = "";
        if (sUpdateUser == null) sUpdateUser = "";
        if (sInputOrg == null) sInputOrg = "";
                
        //�����϶�ʱ�䣬�˹������������˹����������EVALUATE_RECORD����
        if (isManResultExisted) {
        	sSql = " Update EVALUATE_RECORD Set CognDate =:CognDate,CognScore =:CognScore,CognResult =:CognResult," +
		           " CognOrgID =:CognOrgID,CognUserID =:CognUserID" +
		           " where SerialNo =:SerialNo "; 
        	so = new SqlObject(sSql).setParameter("CognDate", sInputTime).setParameter("CognScore", dBailSum).setParameter("CognResult", sPhaseOpinion2)
        	.setParameter("CognOrgID", sInputOrg).setParameter("CognUserID", sUpdateUser).setParameter("SerialNo", sEvaluateSerialNo);
        } else {
            //����˹��������������ڣ�����Ϊnull
        	sSql = " Update EVALUATE_RECORD Set CognDate =:CognDate,CognScore = null ,CognResult =:CognResult," +
		           " CognOrgID =:CognOrgID,CognUserID =:CognUserID " +
		           " where SerialNo =:SerialNo";
        	so = new SqlObject(sSql).setParameter("CognDate", sInputTime).setParameter("CognResult", sPhaseOpinion2).setParameter("CognOrgID", sInputOrg)
        	.setParameter("CognUserID", sUpdateUser).setParameter("SerialNo", sEvaluateSerialNo);
        	
        }
        
        Sqlca.executeSQL(so);
        return "1";
    }
}
