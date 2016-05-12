package com.amarsoft.app.alarm;

import java.io.Serializable;

/**
 * @author syang
 * @date 2011-6-29
 * @describe 自动动风险探测检查项模型
 */
public class CheckItem implements Serializable {
	public static enum RunnerType{Java,SQL,AmarScript};
	private static final long serialVersionUID = 5030447938858986523L;
	private String itemID = "";							//检查项编号
	private String itemName = "";						//检查项名称
	private String itemDescribe = "";					//检查项描述
	private RunnerType runnerType = RunnerType.Java;	//运行方式
	private String runScript = "";						//运行脚本
	private String runCondition = "";					//运行条件
	private String noPassDeal = "";						//未通过的处理方式10禁止办理，20提示
	private String passDeal = "";						//通过的处理方式
	private String passMessage = "";					//通过时提示消息
	private String noPassMessage = "";					//未通过时提示消息
	private String remark = "";							//注释
	private String bizViewer = "";						//未通过业务查看脚本
	
	public CheckItem(){
		
	}

	/**
	 * @return 检查项编号
	 */
	public String getItemID() {
		return itemID;
	}

	/**
	 * @param itemID 检查项编号
	 */
	public void setItemID(String itemID) {
		this.itemID = itemID;
	}

	/**
	 * @return 检查项名称
	 */
	public String getItemName() {
		return itemName;
	}

	/**
	 * @param itemName 检查项名称
	 */
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	/**
	 * @return 检查项描述
	 */
	public String getItemDescribe() {
		return itemDescribe;
	}

	/**
	 * @param itemDescribe 检查项描述
	 */
	public void setItemDescribe(String itemDescribe) {
		this.itemDescribe = itemDescribe;
	}

	/**
	 * @return 运行方式
	 */
	public RunnerType getRunnerType() {
		return runnerType;
	}

	/**
	 * @param runnerType 运行方式
	 */
	public void setRunnerType(RunnerType runnerType) {
		this.runnerType = runnerType;
	}

	/**
	 * @return 运行脚本
	 */
	public String getRunScript() {
		return runScript;
	}

	/**
	 * @param runScript 运行脚本
	 */
	public void setRunScript(String runScript) {
		this.runScript = runScript;
	}

	/**
	 * @return 运行条件
	 */
	public String getRunCondition() {
		return runCondition;
	}

	/**
	 * @param runCondition 运行条件
	 */
	public void setRunCondition(String runCondition) {
		this.runCondition = runCondition;
	}

	/**
	 * @return 未通过的处理方式10禁止办理，20提示
	 */
	public String getNoPassDeal() {
		return noPassDeal;
	}

	/**
	 * @param noPassDeal 未通过的处理方式10禁止办理，20提示
	 */
	public void setNoPassDeal(String noPassDeal) {
		this.noPassDeal = noPassDeal;
	}

	/**
	 * @return 通过的处理方式
	 */
	public String getPassDeal() {
		return passDeal;
	}

	/**
	 * @param passDeal 通过的处理方式
	 */
	public void setPassDeal(String passDeal) {
		this.passDeal = passDeal;
	}

	/**
	 * @return 通过时提示消息
	 */
	public String getPassMessage() {
		return passMessage;
	}

	/**
	 * @param passMessage 通过时提示消息
	 */
	public void setPassMessage(String passMessage) {
		this.passMessage = passMessage;
	}

	/**
	 * @return 未通过时提示消息
	 */
	public String getNoPassMessage() {
		return noPassMessage;
	}

	/**
	 * @param noPassMessage 未通过时提示消息
	 */
	public void setNoPassMessage(String noPassMessage) {
		this.noPassMessage = noPassMessage;
	}

	/**
	 * @return 注释
	 */
	public String getRemark() {
		return remark;
	}

	/**
	 * @param remark 注释
	 */
	public void setRemark(String remark) {
		this.remark = remark;
	}
	/**
	 * 未通过业务查看脚本
	 * @return
	 */
	public String getBizViewer() {
		return bizViewer;
	}
	/**
	 * 未通过业务查看脚本
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

