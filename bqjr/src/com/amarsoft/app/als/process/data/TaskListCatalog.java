package com.amarsoft.app.als.process.data;

public class TaskListCatalog {

	private String flowNo;
	private String phaseType;
	private String phaseNo;
	private String phaseName;
	private String itemCount = "0";
	private String finishFlag; //N:未完成,Y:已完成
	
	public String getFlowNo() {
		return flowNo;
	}
	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}
	public String getPhaseType() {
		return phaseType;
	}
	public void setPhaseType(String phaseType) {
		this.phaseType = phaseType;
	}
	public String getPhaseNo() {
		return phaseNo;
	}
	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}
	public String getPhaseName() {
		return phaseName;
	}
	public void setPhaseName(String phaseName) {
		this.phaseName = phaseName;
	}
	public String getItemCount() {
		return itemCount;
	}
	public void setItemCount(String itemCount) {
		this.itemCount = itemCount;
	}
	public String getFinishFlag() {
		return finishFlag;
	}
	public void setFinishFlag(String finishFlag) {
		this.finishFlag = finishFlag;
	}
	
	public boolean equals(TaskListCatalog catalog){
		if(catalog == null){
			return false;
		}
		if(this == catalog){
			return true;
		}
		if(this.finishFlag.equals(catalog.finishFlag) && this.flowNo.equals(catalog.flowNo) && 
		   this.phaseNo.equals(catalog.phaseNo) && this.phaseName.equals(catalog.phaseName) && 
		   this.phaseType.equals(catalog.phaseType)){
			return true;
		}
		return false;
	}
	
	public String toString(){
		return "FlowNo:"+ this.flowNo + ",PhaseType:" + this.phaseType + 
			   ",PhaseNo:" + this.phaseNo + ",PhaseName:" + this.phaseName + 
			   ",FinishFlag:" + this.finishFlag + ",ItemCount:" + this.itemCount;
	}
}
