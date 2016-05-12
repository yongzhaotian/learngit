package com.amarsoft.biz.workflow;

import java.sql.SQLException;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class FlowUtil {

	private String SerialNo;
	private String FlowNo;
	private String PhaseNo;
	private String PhaseOpinion;
	private String ReturnPoint;
	
	public String isRoleSubmit(Transaction Sqlca) throws SQLException{
		String phaseDescribe = "";
		String sql = "Select PhaseDescribe From Flow_Model Where FlowNo=:FlowNo and PhaseNo=:PhaseNo";
		SqlObject so = new SqlObject(sql);
		so.setParameter("FlowNo", FlowNo);
		so.setParameter("PhaseNo", PhaseNo);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			phaseDescribe = rs.getString("PhaseDescribe");
		}
		rs.getStatement().close();
		if("role".equalsIgnoreCase(phaseDescribe))return "1";
		return "0";
	}
	
	public String getRoleSubmitUsers(Transaction Sqlca) throws Exception{
		String users = "";
		String user = "";

		// 初始化任务对象
		FlowTask ftBusiness = new FlowTask(SerialNo, Sqlca);
		// 获取动作选择列表
		String[] actionList = ftBusiness.getActionList(PhaseOpinion);
		if(actionList==null)return "";
		for (int i = 0; i < actionList.length; i++) {
			System.out.println(actionList[i]);
			user = actionList[i].split(" ")[0];
			users = users + user + ",";
		}
		return users.substring(0, users.length() - 1);
	}
	
//	public String returnTask(Transaction Sqlca) throws Exception{
//		FlowTask ft = new FlowTask(SerialNo, Sqlca);
//		ft.returnTask(ReturnPoint, Sqlca);
//		return "退回成功";
//	}
	
	public String getFlowNo() {
		return FlowNo;
	}
	public void setFlowNo(String flowNo) {
		FlowNo = flowNo;
	}
	public String getPhaseNo() {
		return PhaseNo;
	}
	public void setPhaseNo(String phaseNo) {
		PhaseNo = phaseNo;
	}
	public String getSerialNo() {
		return SerialNo;
	}
	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}
	public String getPhaseOpinion() {
		return PhaseOpinion;
	}
	public void setPhaseOpinion(String phaseOpinion) {
		PhaseOpinion = phaseOpinion;
	}
	public String getReturnPoint() {
		return ReturnPoint;
	}
	public void setReturnPoint(String returnPoint) {
		ReturnPoint = returnPoint;
	}
}
