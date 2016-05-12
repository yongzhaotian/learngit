package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

/**
 * @author syang
 * @since 2011-6-13
 * @describe ͬҵ�ͻ�
 */
public class FinanceCustomer extends Customer implements Serializable{
	private static final long serialVersionUID = 971793252836937430L;
	private String bankLicense = null;		//�������֤���
	private String alikeType =null; //ͬҵ����
	private String alikeTypeDown =null;//ͬҵ������
	private String stateType =null; // ����
	
	/**
	 * @return �������֤���
	 */
	public String getBankLicense() {
		return bankLicense;
	}

	/**
	 * @param bankLicense �������֤���
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
