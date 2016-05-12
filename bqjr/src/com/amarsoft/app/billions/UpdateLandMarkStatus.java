package com.amarsoft.app.billions;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * ���º�ͬ�ر�״̬��ͬʱ¼������Ϣ
 * 
 * @author chiqizhong
 * @date 2015-04-29
 */
public class UpdateLandMarkStatus {
	
	private String serialNo; // ��ˮ��
	
	private String contractNo; // ��ͬ���
	
	private String expressNo; // ��ݵ���
	
	private String expressType; // ����
	
	private String inputUser; // ¼����
	
	private String inputOrg; // ¼���˲���
	
	private String inputTime; // ¼��ʱ��
	
	private String landMarkStatus; // ȷ�Ϻ�ĵر�״̬
	
	private String sortNo; // �����

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
	 * ���ĵر�״̬
	 * @param Sqlca
	 * @throws Exception
	 */
	public void updateLanMarkStatus(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		//����ͬ�ر�״̬��Ϊ�ܲ�(5.���ܲ�)
		if(null != landMarkStatus && "" != landMarkStatus){
			osql = new SqlObject(" update business_contract set landmarkStatus=:landMarkStatus where serialNo=:serialNo");
			osql.setParameter("landMarkStatus", landMarkStatus);
			osql.setParameter("serialNo", contractNo);
			Sqlca.executeSQL(osql);
		}
	}
	
	/**
	 * ¼������Ϣ
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
				+ getvalus(sortNo)+")";  // ���������к��С�������sql���ᷢ���仯���ôʷ������
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
