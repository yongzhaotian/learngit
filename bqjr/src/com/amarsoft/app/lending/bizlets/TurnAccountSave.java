package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class TurnAccountSave {
	/**�����˱��**/
	private String serialNoS;
	/**���б��**/
	private String areaCodes;
	/**��Ʒ������**/
	private String productTypes;
	/**�鼯���˺�**/
	private String turnAccountNumber;
	/**�鼯�˻�����**/
	private String turnAccountName;
	/**�鼯�˻�������**/
	private String turnAccountBlank;
	/**�����˺�ǰ׺**/
	private String backAccountPrefix;
	/**֧������**/
	private String subBankName;
	
	public String saveBank(Transaction transaction){
		StringBuffer sb = new StringBuffer("UPDATE PROVIDERSCITY SET TURNACCOUNTNUMBER = :TURNACCOUNTNUMBER,TURNACCOUNTNAME = :TURNACCOUNTNAME,");
		sb.append ("TURNACCOUNTBLANK = :TURNACCOUNTBLANK,BACKACCOUNTPREFIX = :BACKACCOUNTPREFIX,SUBBANKNAME = :SUBBANKNAME ");
		sb.append ("WHERE SERIALNO = :SERIALNO AND AREACODE = :AREACODE AND PRODUCTTYPE = :PRODUCTTYPE");
		try {
			transaction.executeSQL(new SqlObject(sb.toString())
					.setParameter("TURNACCOUNTNUMBER", turnAccountNumber)
					.setParameter("TURNACCOUNTNAME", turnAccountName)
					.setParameter("TURNACCOUNTBLANK", turnAccountBlank)
					.setParameter("BACKACCOUNTPREFIX", backAccountPrefix)
					.setParameter("SUBBANKNAME", subBankName)
					.setParameter("SERIALNO", serialNoS)
					.setParameter("AREACODE", areaCodes)
					.setParameter("PRODUCTTYPE", productTypes));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "false@�����쳣������ϵIT�����Ա��";
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			return "false@�����쳣������ϵIT�����Ա��";
		}
		return "ture@����ɹ�";
	}

	public String getSerialNoS() {
		return serialNoS;
	}

	public void setSerialNoS(String serialNoS) {
		this.serialNoS = serialNoS;
	}

	public String getAreaCodes() {
		return areaCodes;
	}

	public void setAreaCodes(String areaCodes) {
		this.areaCodes = areaCodes;
	}

	public String getProductTypes() {
		return productTypes;
	}

	public void setProductTypes(String productTypes) {
		this.productTypes = productTypes;
	}

	public String getTurnAccountNumber() {
		return turnAccountNumber;
	}

	public void setTurnAccountNumber(String turnAccountNumber) {
		this.turnAccountNumber = turnAccountNumber;
	}

	public String getTurnAccountName() {
		return turnAccountName;
	}

	public void setTurnAccountName(String turnAccountName) {
		this.turnAccountName = turnAccountName;
	}

	public String getTurnAccountBlank() {
		return turnAccountBlank;
	}

	public void setTurnAccountBlank(String turnAccountBlank) {
		this.turnAccountBlank = turnAccountBlank;
	}

	public String getBackAccountPrefix() {
		return backAccountPrefix;
	}

	public void setBackAccountPrefix(String backAccountPrefix) {
		this.backAccountPrefix = backAccountPrefix;
	}

	public String getSubBankName() {
		return subBankName;
	}

	public void setSubBankName(String subBankName) {
		this.subBankName = subBankName;
	}

	
}
