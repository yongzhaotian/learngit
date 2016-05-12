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

import com.amarsoft.app.als.sadre.util.DecimalUtil;
import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;

 /**
 * <p>Title: BusinessApprove.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2011-2015 Amarsoft Ltd. Co.</p> 
 *     
 * @author hwang@amarsoft.com
 * @version 
 * @date 2012-12-28 ����4:13:59
 *
 * logs: 1. 
 */
public class BusinessApprove implements ISimpleBO {
	/*�ͻ���˽�б���*/
	private String customerId  	= "";		//�ͻ����
	
	private String customerName = "";		//�ͻ�����
	
	/*ҵ����˽�б���*/
	private String approveSerialNo = "";		//ҵ��������ˮ��
	
	private String businessType = "";		//ҵ��Ʒ�ֱ��
	
	private String businessName = "";		//ҵ��Ʒ������
	
	private String vouchType = "";			//��Ҫ������ʽ
	
	private String businessCurrency = "";	//����ҵ�����
	
	private double businessSum = 0.0D;		//������
	
	private double bailRatio = 0.0D;		//��֤�����
	
	private double bailSum = 0.0D;			//��֤����
	
	private String occurType = "";			//������ʽ
	
	private String isLowRisk = "2";			//�Ƿ�ͷ���ҵ��,Ĭ�Ϸ�
	
	private String applyType = "";			//�������ͣ��Ƿ�ͷ���...
	
	private String govermentPlat = "";		//�Ƿ���������ƽ̨ҵ��
	
	private Transaction Sqlca = null;
	
	public BusinessApprove(String serialNo, Transaction to){
		this.approveSerialNo = serialNo;
		this.Sqlca = to;
	}
	
	public String getApproveSerialNo() {
		return approveSerialNo;
	}

	public String getBusinessType() {
		return businessType;
	}

	public String getBusinessName() {
		return businessName;
	}

	public String getVouchType() {
		return vouchType;
	}

	public String getBusinessCurrency() {
		return businessCurrency;
	}

	public double getBusinessSum() {
		return businessSum;
	}

	public double getBailRatio() {
		return bailRatio;
	}

	public double getBailSum() {
		return bailSum;
	}

	public String getOccurType() {
		return occurType;
	}

	public String isLowRisk() {
		return isLowRisk;
	}

	public String getApplyType() {
		return applyType;
	}

	public String getCustomerId() {
		return customerId;
	}

	public String getCustomerName() {
		return customerName;
	}

	/**
	 * �Ƿ���������ƽ̨
	 * @return
	 */
	public String getGovermentPlat() {
		return govermentPlat;
	}
	
	/**
	 * ����������ճ��ڽ��
	 * @return
	 */
	public double getRiskGapSum(){
		double gapRate = 1-getBailRatio()/100;
		return DecimalUtil.multiply(getBusinessSum(), (gapRate>0?gapRate:0));
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.sadre.simplebo.ISimpleBO#fullfill()
	 */
	public void fullfill() throws SADREException {
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select CustomerId,CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessName," +
					"BusinessCurrency,VouchType,OccurType,BusinessSum,BailRatio,LOWRISK,APPLYTYPE " +
					"from BUSINESS_APPROVE where SERIALNO='"+getApproveSerialNo()+"'");
			if(resultset.next()){
				customerId 	 	= StringUtil.getString(resultset.getString("CustomerId"));
				customerName 	= StringUtil.getString(resultset.getString("CustomerName"));
				businessType 	= StringUtil.getString(resultset.getString("BusinessType"));
				businessName	= StringUtil.getString(resultset.getString("BusinessName"));
				businessCurrency = StringUtil.getString(resultset.getString("BusinessCurrency"));
				vouchType 	 	= StringUtil.getString(resultset.getString("VouchType"));
				occurType 	 	= StringUtil.getString(resultset.getString("OccurType"));
				businessSum	 	= resultset.getDouble("BusinessSum");
				bailRatio	 	= resultset.getDouble("BailRatio");
				isLowRisk		= StringUtil.getString(resultset.getString("LOWRISK"));
				applyType		= StringUtil.getString(resultset.getString("APPLYTYPE"));
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
