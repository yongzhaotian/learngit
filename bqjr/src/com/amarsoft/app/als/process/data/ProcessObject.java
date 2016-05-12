package com.amarsoft.app.als.process.data;

/**
 * ������ת����,���ڱ������̲���������Ӱ�쵽����������
 * @author zszhang
 *
 */
public class ProcessObject {

	private String processDefID;    //���̶�����
	private String processDefName;  //���̶�������
	private String activityID;      //����
	private String activityName;    //�����
	private String milestone;       //��̱�(�׶�����)
	private String processInstID;   //����ʵ�����
	private String taskID;          //������
	private String userID;          //�û����
	private String groupID;         //�û�����
	private String activityAction;  //�ύ����
	private String activityOpinion; //�ύ���
	private String objectDescribe;  //��������
	private String isPool;          //�Ƿ��������
	private String taskType;        //��������
	private String infoArea;        //��Ϣ��
	private String operateArea;     //������
	private String buttonArea;      //��ť��
	private String userVote;        //ͶƱ�û�
	private String isSecretary;     //�Ƿ���������
	
	public String getProcessDefID() {
		return processDefID;
	}
	public void setProcessDefID(String processDefID) {
		this.processDefID = processDefID;
	}
	public String getProcessDefName() {
		return processDefName;
	}
	public void setProcessDefName(String processDefName) {
		this.processDefName = processDefName;
	}
	public String getActivityID() {
		return activityID;
	}
	public void setActivityID(String activityID) {
		this.activityID = activityID;
	}
	public String getActivityName() {
		return activityName;
	}
	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}
	public String getMilestone() {
		return milestone;
	}
	public void setMilestone(String milestone) {
		this.milestone = milestone;
	}
	public String getProcessInstID() {
		return processInstID;
	}
	public void setProcessInstID(String processInstID) {
		this.processInstID = processInstID;
	}
	public String getTaskID() {
		return taskID;
	}
	public void setTaskID(String taskID) {
		this.taskID = taskID;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getGroupID() {
		return groupID;
	}
	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}
	public String getActivityAction() {
		return activityAction;
	}
	public void setActivityAction(String activityAction) {
		this.activityAction = activityAction;
	}
	public String getActivityOpinion() {
		return activityOpinion;
	}
	public void setActivityOpinion(String activityOpinion) {
		this.activityOpinion = activityOpinion;
	}
	public String getObjectDescribe() {
		return objectDescribe;
	}
	public void setObjectDescribe(String objectDescribe) {
		this.objectDescribe = objectDescribe;
	}
	public String getIsPool() {
		return isPool;
	}
	public void setIsPool(String isPool) {
		this.isPool = isPool;
	}
	public String getTaskType() {
		return taskType;
	}
	public void setTaskType(String taskType) {
		this.taskType = taskType;
	}
	public String getInfoArea() {
		return infoArea;
	}
	public void setInfoArea(String infoArea) {
		this.infoArea = infoArea;
	}
	public String getOperateArea() {
		return operateArea;
	}
	public void setOperateArea(String operateArea) {
		this.operateArea = operateArea;
	}
	public String getButtonArea() {
		return buttonArea;
	}
	public void setButtonArea(String buttonArea) {
		this.buttonArea = buttonArea;
	}
	public String getUserVote() {
		return userVote;
	}
	public void setUserVote(String userVote) {
		this.userVote = userVote;
	}
	public String getIsSecretary() {
		return isSecretary;
	}
	public void setIsSecretary(String isSecretary) {
		this.isSecretary = isSecretary;
	}
	public void setAttributes(ProcessObject po){
		this.activityAction = po.getActivityAction();
		this.activityID = po.getActivityID();
		this.activityName = po.getActivityName();
		this.activityOpinion = po.getActivityOpinion();
		this.milestone = po.getMilestone();
		this.objectDescribe = po.getObjectDescribe();
		this.processDefID = po.getProcessDefID();
		this.processDefName = po.getProcessDefName();
		this.processInstID = po.getProcessInstID();
		this.taskID = po.getTaskID();
		this.userID = po.getUserID();
		this.groupID = po.getGroupID();
		this.isPool = po.getIsPool();
		this.taskType = po.getTaskType();
		this.infoArea = po.getInfoArea();
		this.operateArea = po.getOperateArea();
		this.buttonArea = po.getButtonArea();
		this.userVote = po.getUserVote();
		this.isSecretary=po.getIsSecretary();
	}
}
