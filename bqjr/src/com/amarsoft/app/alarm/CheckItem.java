package com.amarsoft.app.alarm;

import java.io.Serializable;

/**
 * @author syang
 * @date 2011-6-29
 * @describe �Զ�������̽������ģ��
 */
public class CheckItem implements Serializable {
	public static enum RunnerType{Java,SQL,AmarScript};
	private static final long serialVersionUID = 5030447938858986523L;
	private String itemID = "";							//�������
	private String itemName = "";						//���������
	private String itemDescribe = "";					//���������
	private RunnerType runnerType = RunnerType.Java;	//���з�ʽ
	private String runScript = "";						//���нű�
	private String runCondition = "";					//��������
	private String noPassDeal = "";						//δͨ���Ĵ���ʽ10��ֹ����20��ʾ
	private String passDeal = "";						//ͨ���Ĵ���ʽ
	private String passMessage = "";					//ͨ��ʱ��ʾ��Ϣ
	private String noPassMessage = "";					//δͨ��ʱ��ʾ��Ϣ
	private String remark = "";							//ע��
	private String bizViewer = "";						//δͨ��ҵ��鿴�ű�
	
	public CheckItem(){
		
	}

	/**
	 * @return �������
	 */
	public String getItemID() {
		return itemID;
	}

	/**
	 * @param itemID �������
	 */
	public void setItemID(String itemID) {
		this.itemID = itemID;
	}

	/**
	 * @return ���������
	 */
	public String getItemName() {
		return itemName;
	}

	/**
	 * @param itemName ���������
	 */
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	/**
	 * @return ���������
	 */
	public String getItemDescribe() {
		return itemDescribe;
	}

	/**
	 * @param itemDescribe ���������
	 */
	public void setItemDescribe(String itemDescribe) {
		this.itemDescribe = itemDescribe;
	}

	/**
	 * @return ���з�ʽ
	 */
	public RunnerType getRunnerType() {
		return runnerType;
	}

	/**
	 * @param runnerType ���з�ʽ
	 */
	public void setRunnerType(RunnerType runnerType) {
		this.runnerType = runnerType;
	}

	/**
	 * @return ���нű�
	 */
	public String getRunScript() {
		return runScript;
	}

	/**
	 * @param runScript ���нű�
	 */
	public void setRunScript(String runScript) {
		this.runScript = runScript;
	}

	/**
	 * @return ��������
	 */
	public String getRunCondition() {
		return runCondition;
	}

	/**
	 * @param runCondition ��������
	 */
	public void setRunCondition(String runCondition) {
		this.runCondition = runCondition;
	}

	/**
	 * @return δͨ���Ĵ���ʽ10��ֹ����20��ʾ
	 */
	public String getNoPassDeal() {
		return noPassDeal;
	}

	/**
	 * @param noPassDeal δͨ���Ĵ���ʽ10��ֹ����20��ʾ
	 */
	public void setNoPassDeal(String noPassDeal) {
		this.noPassDeal = noPassDeal;
	}

	/**
	 * @return ͨ���Ĵ���ʽ
	 */
	public String getPassDeal() {
		return passDeal;
	}

	/**
	 * @param passDeal ͨ���Ĵ���ʽ
	 */
	public void setPassDeal(String passDeal) {
		this.passDeal = passDeal;
	}

	/**
	 * @return ͨ��ʱ��ʾ��Ϣ
	 */
	public String getPassMessage() {
		return passMessage;
	}

	/**
	 * @param passMessage ͨ��ʱ��ʾ��Ϣ
	 */
	public void setPassMessage(String passMessage) {
		this.passMessage = passMessage;
	}

	/**
	 * @return δͨ��ʱ��ʾ��Ϣ
	 */
	public String getNoPassMessage() {
		return noPassMessage;
	}

	/**
	 * @param noPassMessage δͨ��ʱ��ʾ��Ϣ
	 */
	public void setNoPassMessage(String noPassMessage) {
		this.noPassMessage = noPassMessage;
	}

	/**
	 * @return ע��
	 */
	public String getRemark() {
		return remark;
	}

	/**
	 * @param remark ע��
	 */
	public void setRemark(String remark) {
		this.remark = remark;
	}
	/**
	 * δͨ��ҵ��鿴�ű�
	 * @return
	 */
	public String getBizViewer() {
		return bizViewer;
	}
	/**
	 * δͨ��ҵ��鿴�ű�
	 * @param bizViewer
	 */
	public void setBizViewer(String bizViewer) {
		this.bizViewer = bizViewer;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "CheckItem [itemID=" + itemID + ", itemName=" + itemName
				+ ", itemDescribe=" + itemDescribe + ", runnerType="
				+ runnerType + ", runScript=" + runScript + ", runCondition="
				+ runCondition + ", noPassDeal=" + noPassDeal + ", passDeal="
				+ passDeal + ", passMessage=" + passMessage
				+ ", noPassMessage=" + noPassMessage + ", remark=" + remark
				+ "]";
	}
	
}

