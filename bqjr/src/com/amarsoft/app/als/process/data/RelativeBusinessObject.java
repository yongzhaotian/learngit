package com.amarsoft.app.als.process.data;

/**
 * ҵ�����,���ڱ������̲���������ҵ������
 * @author zszhang
 *
 */
public class RelativeBusinessObject {
	
	private String objectNo;    //������
	private String objectType;  //��������
	private String applyType;   //ҵ����������
	private String processDefID;//���̶�����
	private String phaseNo;     //ҵ��׶α��
	private String phaseType;   //ҵ��׶�����
	private String userID;      //ҵ�������û����
	private String userName;    //ҵ�������û�����
	private String orgID;       //ҵ�������������
	private String orgName;     //ҵ��������������
	private String inputTime;   //ҵ����ʱ�� 
	private String objectDescribe;//��������

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
