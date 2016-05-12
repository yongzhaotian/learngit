package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 在信用等级评估时，将最新的人工评估结果更新到EVALUATE_RECORD表中。
 * @author cbsu 2009-11-10
 */
public class UpdateEvaluateManResult extends Bizlet {

    /**
     * 在信用等级评估时，将最新的人工评估结果更新到EVALUATE_RECORD表的CognScore和CognResult字段。
     * @param ObjectNo EVALUATE_RECORD表中的流水号
     * @param SerialNo FLOW_OPINION表中的流水号
     */
    public Object run(Transaction Sqlca) throws Exception{
        
        //申请流水号   
        String sEvaluateSerialNo = (String)this.getAttribute("ObjectNo");
        //任务流水号
        String sFlowOpinionSerialNo = (String)this.getAttribute("SerialNo");
        if(sEvaluateSerialNo == null) sEvaluateSerialNo = "";
        if(sFlowOpinionSerialNo == null) sFlowOpinionSerialNo = "";
        
        String sSql = "";
        String sPhaseOpinion2 = "";
        double dBailSum = 0.0;
        String sInputTime = "";
        String sUpdateUser = "";
        String sInputOrg = "";
        //人工评估分数是否存在的标志位
        boolean isManResultExisted = false;
        ASResultSet rs = null;
        SqlObject so;

        //取得该阶段人工认定结果
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
                
        //更新认定时间，人工评估分数，人工评估结果到EVALUATE_RECORD表中
        if (isManResultExisted) {
        	sSql = " Update EVALUATE_RECORD Set CognDate =:CognDate,CognScore =:CognScore,CognResult =:CognResult," +
		           " CognOrgID =:CognOrgID,CognUserID =:CognUserID" +
		           " where SerialNo =:SerialNo "; 
        	so = new SqlObject(sSql).setParameter("CognDate", sInputTime).setParameter("CognScore", dBailSum).setParameter("CognResult", sPhaseOpinion2)
        	.setParameter("CognOrgID", sInputOrg).setParameter("CognUserID", sUpdateUser).setParameter("SerialNo", sEvaluateSerialNo);
        } else {
            //如果人工评估分数不存在，则置为null
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
