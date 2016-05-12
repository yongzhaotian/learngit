package com.amarsoft.app.als.image;

public class ExpressUnpackingBean {
	
	private String expressNo;
	private String contractNo;
	private String expressType;
	private String serialNo;
	private String sortNo;
	public String getExpressNo() {
		return expressNo;
	}
	public void setExpressNo(String expressNo) {
		this.expressNo = expressNo;
	}
	public String getContractNo() {
		return contractNo;
	}
	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}
	public String getExpressType() {
		return expressType;
	}
	public void setExpressType(String expressType) {
		this.expressType = expressType;
	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getSortNo() {
		return sortNo;
	}
	public void setSortNo(String sortNo) {
		this.sortNo = sortNo;
	}
	@Override
	public String toString() {
		
		StringBuffer sb = new StringBuffer();
		sb.append("expressNo="+expressNo);
		sb.append(" contractNo="+contractNo);
		sb.append(" expressType="+expressType);
		sb.append(" serialNo="+serialNo);
		sb.append(" sortNo="+sortNo);
		return sb.toString();
	}
	
	

}
