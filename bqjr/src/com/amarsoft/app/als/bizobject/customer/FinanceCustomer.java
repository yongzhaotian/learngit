package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

/**
 * @author syang
 * @since 2011-6-13
 * @describe 同业客户
 */
public class FinanceCustomer extends Customer implements Serializable{
	private static final long serialVersionUID = 971793252836937430L;
	private String bankLicense = null;		//金融许可证编号
	private String alikeType =null; //同业类型
	private String alikeTypeDown =null;//同业子类型
	private String stateType =null; // 国别
	
	/**
	 * @return 金融许可证编号
	 */
	public String getBankLicense() {
		return bankLicense;
	}

	/**
	 * @param bankLicense 金融许可证编号
	 */
	public void setBankLicense(String bankLicense) {
		this.bankLicense = bankLicense;
	}

	public void setAlikeType(String alikeType) {
		this.alikeType = alikeType;
	}

	public String getAlikeType() {
		return alikeType;
	}

	public void setAlikeTypeDown(String AlikeTypeDown) {
		this.alikeTypeDown = AlikeTypeDown;
	}

	public String getAlikeTypeDown() {
		return alikeTypeDown;
	}

	public void setStateType(String stateType) {
		this.stateType = stateType;
	}

	public String getStateType() {
		return stateType;
	}

	
}
