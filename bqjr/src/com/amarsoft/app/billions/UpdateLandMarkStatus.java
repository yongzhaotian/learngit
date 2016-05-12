package com.amarsoft.app.billions;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * 更新合同地标状态，同时录入快递信息
 * 
 * @author chiqizhong
 * @date 2015-04-29
 */
public class UpdateLandMarkStatus {
	
	private String serialNo; // 流水号
	
	private String contractNo; // 合同编号
	
	private String expressNo; // 快递单号
	
	private String expressType; // 类型
	
	private String inputUser; // 录入人
	
	private String inputOrg; // 录入人部门
	
	private String inputTime; // 录入时间
	
	private String landMarkStatus; // 确认后的地表状态
	
	private String sortNo; // 排序号

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getExpressNo() {
		return expressNo;
	}

	public void setExpressNo(String expressNo) {
		this.expressNo = expressNo;
	}

	public String getExpressType() {
		return expressType;
	}

	public void setExpressType(String expressType) {
		this.expressType = expressType;
	}

	public String getInputUser() {
		return inputUser;
	}

	public void setInputUser(String inputUser) {
		this.inputUser = inputUser;
	}

	public String getInputOrg() {
		return inputOrg;
	}

	public void setInputOrg(String inputOrg) {
		this.inputOrg = inputOrg;
	}

	public String getInputTime() {
		return inputTime;
	}

	public void setInputTime(String inputTime) {
		this.inputTime = inputTime;
	}
	
	public String getLandMarkStatus() {
		return landMarkStatus;
	}

	public void setLandMarkStatus(String landMarkStatus) {
		this.landMarkStatus = landMarkStatus;
	}
	
	public String getSortNo() {
		return sortNo;
	}

	public void setSortNo(String sortNo) {
		this.sortNo = sortNo;
	}

	/**
	 * 更改地标状态
	 * @param Sqlca
	 * @throws Exception
	 */
	public void updateLanMarkStatus(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		//将合同地标状态改为总部(5.是总部)
		if(null != landMarkStatus && "" != landMarkStatus){
			osql = new SqlObject(" update business_contract set landmarkStatus=:landMarkStatus where serialNo=:serialNo");
			osql.setParameter("landMarkStatus", landMarkStatus);
			osql.setParameter("serialNo", contractNo);
			Sqlca.executeSQL(osql);
		}
	}
	
	/**
	 * 录入快递信息
	 * @param Sqlca
	 * @throws Exception
	 */
	public void inserPostBill(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		String sql = "insert into business_contract_express ("
				+ "serialNo,"
				+ "contractNo,"
				+ "expressNo,"
				+ "expressType,"
				+ "inputUser,"
				+ "inputOrg,"
				+ "inputTime,"
				+ "sortNo"
				+ ") values ("
				+ getvalus(serialNo)+","
				+ getvalus(contractNo)+","
				+ getvalus(expressNo)+","
				+ getvalus(expressType)+","
				+ getvalus(inputUser)+","
				+ getvalus(inputOrg)+","
				+ ":inputTime,"
				+ getvalus(sortNo)+")";  // 日期类型中含有“：”；sql语句会发生变化，用词方法解决
		osql = new SqlObject(sql);
		osql.setParameter("inputTime", inputTime);
		Sqlca.executeSQL(osql);
	}
	
	private String getvalus(String val){
		if(null==val){
			return val;
		}
		if("undefined".equals(val)){
			return null;
		}
		
		return  "'"+val+"'";
	}

}
