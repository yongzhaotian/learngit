/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2011 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.app.als.sadre.simplebo;

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;

 /**
 * <p>Title: BusinessPutout.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2011-2015 Amarsoft Ltd. Co.</p> 
 *     
 * @author hwang@amarsoft.com
 * @version 
 * @date 2012-12-28 ����4:13:59
 *
 * logs: 1. 
 */
public class BusinessPutout implements ISimpleBO {
	/*�ͻ���˽�б���*/
	private String customerId  	= "";		//�ͻ����
	
	private String customerName = "";		//�ͻ�����
	
	/*ҵ����˽�б���*/
	private String bpSerialNo = "";		//����������ˮ��
	
	private String businessType = "";		//ҵ��Ʒ�ֱ��
	
	private String businessName = "";		//ҵ��Ʒ������
	
	private String businessCurrency = "";	//����ҵ�����
	
	private double businessSum = 0.0D;		//������
	
	/**
	 * ����(��)
	 */
	private double termMonth;
	/**
	 * ֧����ʽ
	 */	
	private String paymentMode;
	
	private Transaction Sqlca = null;
	
	
	public BusinessPutout(String bpSerialNo, Transaction to){
		this.bpSerialNo = bpSerialNo;
		this.Sqlca = to;
	}
	
	public String getBpSerialNo() {
		return bpSerialNo;
	}

	public String getBusinessType() {
		return businessType;
	}

	public String getBusinessName() {
		return businessName;
	}

	public String getBusinessCurrency() {
		return businessCurrency;
	}

	public double getBusinessSum() {
		return businessSum;
	}

	public String getCustomerId() {
		return customerId;
	}

	public String getCustomerName() {
		return customerName;
	}

	public double getTermMonth() {
		return termMonth;
	}

	public String getPaymentMode() {
		return paymentMode;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.sadre.simplebo.ISimpleBO#fullfill()
	 */
	public void fullfill() throws SADREException {
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select CustomerId,CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessName," +
					"BusinessCurrency,TermMonth,BusinessSum,PAYMENTMODE " +
					"from BUSINESS_PUTOUT where SERIALNO='"+getBpSerialNo()+"'");
			if(resultset.next()){
				customerId 	 	= StringUtil.getString(resultset.getString("CustomerId"));
				customerName 	= StringUtil.getString(resultset.getString("CustomerName"));
				businessType 	= StringUtil.getString(resultset.getString("BusinessType"));
				businessName	= StringUtil.getString(resultset.getString("BusinessName"));
				businessCurrency = StringUtil.getString(resultset.getString("BusinessCurrency"));
				termMonth	 	= resultset.getDouble("TermMonth");
				businessSum	 	= resultset.getDouble("BusinessSum");
				paymentMode		= StringUtil.getString(resultset.getString("PAYMENTMODE"));
			}
			resultset.getStatement().close();
			
		} catch (Exception e) {
			throw new SADREException(e);
		}

	}
	
	/**
	 * ҵ��������
	 * @return
	 */
	public ICustomer getApplicant() throws SADREException{
		return CustomerInfo.getCustomer(getCustomerId(), Sqlca);
	}

}
