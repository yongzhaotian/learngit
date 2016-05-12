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
 * @date 2012-12-28 下午4:13:59
 *
 * logs: 1. 
 */
public class BusinessApprove implements ISimpleBO {
	/*客户类私有变量*/
	private String customerId  	= "";		//客户编号
	
	private String customerName = "";		//客户名称
	
	/*业务类私有变量*/
	private String approveSerialNo = "";		//业务批复流水号
	
	private String businessType = "";		//业务品种编号
	
	private String businessName = "";		//业务品种名称
	
	private String vouchType = "";			//主要担保方式
	
	private String businessCurrency = "";	//申请业务币种
	
	private double businessSum = 0.0D;		//申请金额
	
	private double bailRatio = 0.0D;		//保证金比例
	
	private double bailSum = 0.0D;			//保证金金额
	
	private String occurType = "";			//发生方式
	
	private String isLowRisk = "2";			//是否低风险业务,默认否
	
	private String applyType = "";			//申请类型：是否低风险...
	
	private String govermentPlat = "";		//是否政府融资平台业务
	
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
	 * 是否政府融资平台
	 * @return
	 */
	public String getGovermentPlat() {
		return govermentPlat;
	}
	
	/**
	 * 本币申请风险敞口金额
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
	 * 业务申请人
	 * @return
	 */
	public ICustomer getApplicant() throws SADREException{
		return CustomerInfo.getCustomer(getCustomerId(), Sqlca);
	}

}
