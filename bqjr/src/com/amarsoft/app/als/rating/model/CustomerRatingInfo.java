package com.amarsoft.app.als.rating.model;

public class CustomerRatingInfo {
	
	private String serialNo;//流水号
	private String customerID;//客户编号
	private String refModelID;//模型编号
	private String version;//模型版本号
	private String bomTextIn;//评价结果记录
	private String statusFlag;//状态标志
	private String saveFlag;//暂存标志
	private String customerType;//客户类型
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String SerialNo) {
		this.serialNo = SerialNo;
	}
	
	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String CustomerID) {
		this.customerID = CustomerID;
	}
	
	public String getRefModelID() {
		return refModelID;
	}

	public void setRefModelID(String RefModelID) {
		this.refModelID = RefModelID;
	}
	
	public String getVersion() {
		return version;
	}

	public void setVersion(String Version) {
		this.version = Version;
	}
	
	public String getBomTextIn() {
		return bomTextIn;
	}

	public void setBomTextIn(String BomTextIn) {
		this.bomTextIn = BomTextIn;
	}
	
	public String getStatusFlag() {
		return statusFlag;
	}

	public void setStatusFlag(String StatusFlag) {
		this.statusFlag = StatusFlag;
	}
	
	public String getSaveFlag() {
		return saveFlag;
	}

	public void setSaveFlag(String SaveFlag) {
		this.saveFlag = SaveFlag;
	}
	
	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String CustomerType) {
		this.customerType = CustomerType;
	}
}
