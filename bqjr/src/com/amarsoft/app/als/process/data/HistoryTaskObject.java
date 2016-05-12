package com.amarsoft.app.als.process.data;

/**
 * 流程历史任务对象，用来保存流程历史经过的数据。
 * @author zszhang
 *
 */
public class HistoryTaskObject {
	
	private String bizProcessTaskID; //业务流程任务编号
	private String phaseAction;      //历史选择动作
	private String useID;            //历史处理人
	
	public String getBizProcessTaskID() {
		return bizProcessTaskID;
	}
	public void setBizProcessTaskID(String bizProcessTaskID) {
		this.bizProcessTaskID = bizProcessTaskID;
	}
	public String getPhaseAction() {
		return phaseAction;
	}
	public void setPhaseAction(String phaseAction) {
		this.phaseAction = phaseAction;
	}
	public String getUseID() {
		return useID;
	}
	public void setUseID(String useID) {
		this.useID = useID;
	}
}
