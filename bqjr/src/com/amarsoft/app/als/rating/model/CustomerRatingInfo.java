package com.amarsoft.app.als.rating.model;

public class CustomerRatingInfo {
	
	private String serialNo;//��ˮ��
	private String customerID;//�ͻ����
	private String refModelID;//ģ�ͱ��
	private String version;//ģ�Ͱ汾��
	private String bomTextIn;//���۽����¼
	private String statusFlag;//״̬��־
	private String saveFlag;//�ݴ��־
	private String customerType;//�ͻ�����
	
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
