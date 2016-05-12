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
 * <p>Title: BusinessApply.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-20 ����4:13:59
 *
 * logs: 1. 
 */
public class ClassifyApply implements ISimpleBO {
	/*�ͻ���˽�б���*/
	private String customerId  	= "";		//�ͻ����
	
	/*ҵ����˽�б���*/
	private String classifySerialNo = "";		//����������ˮ��
	
	private String finallyResult = "";		//�����϶����

	private String bdSerialNo = "";		//��ݱ��
	
//	private BusinessDuebill bd = null;		//���ҵ�����

	private String customerName  	= "";		//�ͻ�����
	
	private String businessType = "";		//ҵ��Ʒ������
	
//	private String vouchType = "";			//��Ҫ������ʽ
	
	private String businessCurrency = "";	//����ҵ�����
	
	private double businessSum = 0.0D;		//������
	
	
	private Transaction Sqlca = null;
	
	public ClassifyApply(String serialNo, Transaction to){
		this.classifySerialNo = serialNo;
		this.Sqlca = to;
	}
	
	public String getClassifySerialNo() {
		return classifySerialNo;
	}
	
	public String getFinallyResult() {
		return finallyResult;
	}

	public String getBusinessType() {
		return businessType;
	}

//	public String getVouchType() {
//		return vouchType;
//	}

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

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.sadre.simplebo.ISimpleBO#fullfill()
	 */
	public void fullfill() throws SADREException {
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select CustomerId,ObjectNo,FinallyResult " +
					"from CLASSIFY_RECORD where ObjectType='BusinessDueBill' and SERIALNO='"+getClassifySerialNo()+"'");
			if(resultset.next()){
				customerId 	 	= StringUtil.getString(resultset.getString("CustomerId"));
				bdSerialNo 	= StringUtil.getString(resultset.getString("ObjectNo"));
				finallyResult 	= StringUtil.getString(resultset.getString("FinallyResult"));
			}
			resultset.getStatement().close();
			resultset = Sqlca.getASResultSet("select customerName,businessType,businessCurrency,businessSum " +
					"from BUSINESS_DUEBILL where SERIALNO='"+bdSerialNo+"'");
			if(resultset.next()){
				customerName 	= StringUtil.getString(resultset.getString("customerName"));
				businessType 	= StringUtil.getString(resultset.getString("businessType"));
				businessCurrency = StringUtil.getString(resultset.getString("BusinessCurrency"));
//				vouchType 	 	= StringUtil.getString(resultset.getString("VouchType"));
				businessSum	 	= resultset.getDouble("BusinessSum");
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
