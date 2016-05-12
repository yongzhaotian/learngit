package com.amarsoft.app.als.flow.cfg.model;

import java.util.List;

public class BusinessProcess {
	private String processID; //���̱��
	private String processName; //��������
	private List activities; //�����
	private List transitions; //ת�Ƽ���
	
	public BusinessProcess(){
	}
	
	public BusinessProcess(String processID, String processName){
		this.processID = processID;
		this.processName = processName;
	}
	
	public String getProcessID() {
		return processID;
	}
	
	public void setProcessID(String processID) {
		this.processID = processID;
	}
	
	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	public List getActivities() {
		return activities;
	}
	
	public void setActivities(List activities) {
		this.activities = activities;
	}
	
	public List getTransitions() {
		return transitions;
	}
	
	public void setTransitions(List transitions) {
		this.transitions = transitions;
	}
	
	public String toString() {
		return "BusinessProcess [processID=" + processID + 
			   ", processName=" + processName + 
			   ", activities=" + activities + 
			   ", transitions=" + transitions + "]";
	}

}
