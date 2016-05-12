package com.amarsoft.proj.action;

import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 *   ��ȡԤ����
 * @author Tayle
 *
 */
public class PretrialApproveResult {
	private String  serialNo = "";//��ͬ���
	private String customerID = "";//�ͻ����
	private String customerType = "";//�ͻ�����
	private String sResult = "";//���ؽ�� 01�ܾ��� 02ͨ�� 
	
	/**
	 * ���ù��������ȡ���ؽ��
	 * @param Sqlca
	 * @return
	 */
	public  String getResult(Transaction Sqlca){
		ARE.getLog().debug("====================���ù�������=======================");
		ARE.getLog().debug("====================serialNo="+serialNo+",customerID="+customerID+"========");
		sResult = "02";
		ARE.getLog().debug("==================�������淵�ؽ��:"+sResult+"=======================");
		return sResult;
	}

	
	/**
	 * �ж��Ƿ����δԤ��ļ�¼
	 * @return
	 * @throws SQLException 
	 */
	public String isFinishAll(Transaction Sqlca) throws SQLException{
		int i=0;
		String sSql =  "select count(1) as  n  from contract_relative a where a.serialno=:serialno and (PRETRIALRESULT is null ) ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno", serialNo));
		if(rs.next()) 
		{
			i=rs.getInt("n");
		}
		rs.getStatement().close();
		
		if(i>0){//����
			return "false";
		}else{//������
			return "true";
		}
	}
	
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	
}
