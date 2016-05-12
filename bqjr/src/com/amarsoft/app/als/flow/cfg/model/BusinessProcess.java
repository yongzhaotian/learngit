package com.amarsoft.app.als.flow.cfg.model;

import java.util.List;

public class BusinessProcess {
	private String processID; //流程编号
	private String processName; //流程名称
	private List activities; //活动集合
	private List transitions; //转移集合
	
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
