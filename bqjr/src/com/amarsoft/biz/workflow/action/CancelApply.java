package com.amarsoft.biz.workflow.action;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class CancelApply {
	private String SerialNo=null;
	private String OpinionNo=null;
	private String PhaseOpinion=null;
	private String PhaseOpinion1=null;
	private String InputOrg=null;
	private String InputUser=null;
	private String InputTime=null;
	private String Remark=null;
	private String Opinion_Remark=null;
	
	//同步方法保存取消意见
	public synchronized String CancelApplySave(Transaction Sqlca){
		// 定义变量：动作、动作列表、阶段的类型、动作提示、阶段的属性
		try{
		String sSql = "";
		ASResultSet rsTemp = null;
		int cnt=0;
		
		sSql="select count(*) as cnt from flow_opinion where serialno=:SerialNo";
		rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "SerialNo", SerialNo));
		while(rsTemp.next()){
			cnt=Integer.parseInt(rsTemp.getString("cnt"));
		}
		if(cnt>0){
			sSql = "update flow_opinion set OpinionNo=:OpinionNo,PhaseOpinion=:PhaseOpinion,PhaseOpinion1=:PhaseOpinion1,"+
			"InputOrg=:InputOrg,InputUser=:InputUser,InputTime=:InputTime,"+
			"Remark=:Remark,Opinion_Remark=:Opinion_Remark where serialno=:SerialNo";
	Sqlca.executeSQL(new SqlObject(sSql)
			.setParameter( "SerialNo", SerialNo)
			.setParameter("OpinionNo", OpinionNo)
			.setParameter("PhaseOpinion", PhaseOpinion)
			.setParameter("PhaseOpinion1", PhaseOpinion1)
			.setParameter("InputOrg", InputOrg)
			.setParameter("InputUser", InputUser)
			.setParameter("InputTime", InputTime)
			.setParameter("Opinion_Remark", Opinion_Remark)
			.setParameter("Remark", Remark));
		}else{
			sSql = "insert into flow_opinion (SerialNo,OpinionNo,PhaseOpinion,PhaseOpinion1,"+
			"InputOrg,InputUser,InputTime,Remark,Opinion_Remark) values (:SerialNo,:OpinionNo,"+
			":PhaseOpinion,:PhaseOpinion1,:InputOrg,:InputUser,:InputTime,"+
			":Remark,:Opinion_Remark)";
			
		Sqlca.executeSQL(new SqlObject(sSql)
			.setParameter("SerialNo", SerialNo)
			.setParameter("OpinionNo", OpinionNo)
			.setParameter("PhaseOpinion", PhaseOpinion)
			.setParameter("PhaseOpinion1", PhaseOpinion1)
			.setParameter("InputOrg", InputOrg)
			.setParameter("InputUser", InputUser)
			.setParameter("InputTime", InputTime)
			.setParameter("Opinion_Remark", Opinion_Remark)
			.setParameter("Remark", Remark));
		}
		
			return "SUSSESS";
		}catch (Exception e) {
			return "Failer";
		}
	}

	public String getSerialNo() {
		return SerialNo;
	}

	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}

	public String getOpinionNo() {
		return OpinionNo;
	}

	public void setOpinionNo(String opinionNo) {
		OpinionNo = opinionNo;
	}

	public String getPhaseOpinion() {
		return PhaseOpinion;
	}

	public void setPhaseOpinion(String phaseOpinion) {
		PhaseOpinion = phaseOpinion;
	}

	public String getPhaseOpinion1() {
		return PhaseOpinion1;
	}

	public void setPhaseOpinion1(String phaseOpinion1) {
		PhaseOpinion1 = phaseOpinion1;
	}

	public String getInputOrg() {
		return InputOrg;
	}

	public void setInputOrg(String inputOrg) {
		InputOrg = inputOrg;
	}

	public String getInputUser() {
		return InputUser;
	}

	public void setInputUser(String inputUser) {
		InputUser = inputUser;
	}

	public String getInputTime() {
		return InputTime;
	}

	public void setInputTime(String inputTime) {
		InputTime = inputTime;
	}

	public String getRemark() {
		return Remark;
	}

	public void setRemark(String remark) {
		Remark = remark;
	}

	public String getOpinion_Remark() {
		return Opinion_Remark;
	}

	public void setOpinion_Remark(String opinion_Remark) {
		Opinion_Remark = opinion_Remark;
	}

		
}
