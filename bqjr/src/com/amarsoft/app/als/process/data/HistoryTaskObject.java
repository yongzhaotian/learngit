package com.amarsoft.app.als.process.data;

/**
 * ������ʷ���������������������ʷ���������ݡ�
 * @author zszhang
 *
 */
public class HistoryTaskObject {
	
	private String bizProcessTaskID; //ҵ������������
	private String phaseAction;      //��ʷѡ����
	private String useID;            //��ʷ������
	
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
