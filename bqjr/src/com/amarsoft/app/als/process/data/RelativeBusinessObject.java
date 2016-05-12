package com.amarsoft.app.als.process.data;

/**
 * 业务对象,用于保存流程操作过程中业务数据
 * @author zszhang
 *
 */
public class RelativeBusinessObject {
	
	private String objectNo;    //对象编号
	private String objectType;  //对象类型
	private String applyType;   //业务申请类型
	private String processDefID;//流程定义编号
	private String phaseNo;     //业务阶段编号
	private String phaseType;   //业务阶段类型
	private String userID;      //业务所属用户编号
	private String userName;    //业务所属用户名称
	private String orgID;       //业务所属机构编号
	private String orgName;     //业务所属机构名称
	private String inputTime;   //业务发起时间 
	private String objectDescribe;//对象描述

	public String getApplyType() {
		return applyType;
	}
	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}
	public String getProcessDefID() {
		return processDefID;
	}
	public void setProcessDefID(String processDefID) {
		this.processDefID = processDefID;
	}
	public String getPhaseType() {
		return phaseType;
	}
	public void setPhaseType(String phaseType) {
		this.phaseType = phaseType;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getOrgID() {
		return orgID;
	}
	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	public String getObjectDescribe() {
		return objectDescribe;
	}
	public void setObjectDescribe(String objectDescribe) {
		this.objectDescribe = objectDescribe;
	}
	public String getInputTime() {
		return inputTime;
	}
	public void setInputTime(String inputTime) {
		this.inputTime = inputTime;
	}
	public String getObjectNo() {
		return objectNo;
	}
	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
	public String getPhaseNo() {
		return phaseNo;
	}
	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}
	public String getObjectType() {
		return objectType;
	}
	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}
}
