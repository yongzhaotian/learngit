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

import java.util.Hashtable;

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;

 /**
 * <p>Title: Customer.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-20 下午2:14:50
 *
 * logs: 1. 
 */
public abstract class CustomerInfo implements ICustomer,ISimpleBO {
	
	protected String name;
	protected String type;
	protected String certType;
	protected String certId;
	protected String id;
	protected String creditLevel;
	
	protected Transaction Sqlca;
	
	private Hashtable<String,String> extAtrribute = new Hashtable<String,String>();
	
	public CustomerInfo(String id, Transaction to){
		this.id = id;
		this.Sqlca = to;
	}
	public static ICustomer getCustomer(String sCustomerID,Transaction Sqlca) throws SADREException{
		ICustomer customer = null;
		String sCustomerType = "";
		
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select CustomerType " +
					"from CUSTOMER_INFO where CUSTOMERID='"+sCustomerID+"'");
			if(resultset.next()){
				sCustomerType = StringUtil.getString(resultset.getString("CustomerType"));
			}
			resultset.getStatement().close();
			
		} catch (Exception e) {
			throw new SADREException(e);
		}
		
		if(sCustomerType.startsWith("03")){		//个人客户
			customer = new IndInfo(sCustomerID,Sqlca);
		}else{
			customer = new EntInfo(sCustomerID,Sqlca);
		}
		((CustomerInfo)customer).fullfill();
		
		return customer;
	}
	public void fullfill() throws SADREException {
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select CustomerName,CustomerType,CertType,CertId " +
					"from CUSTOMER_INFO where CUSTOMERID='"+getId()+"'");
			if(resultset.next()){
				name 	 	= StringUtil.getString(resultset.getString("CustomerName"));
				type 	= StringUtil.getString(resultset.getString("CustomerType"));
				certType 	= StringUtil.getString(resultset.getString("CertType"));
				certId	= StringUtil.getString(resultset.getString("CertId"));
//				certId = StringUtil.getString(resultset.getString("CreditLevel"));
			}
			resultset.getStatement().close();
			
		} catch (Exception e) {
			throw new SADREException(e);
		}
	}
	
	public String getAttribute(String attrName){
		String value = extAtrribute.get(attrName.toUpperCase());
		return value==null?"":value;
//		return extAtrribute.get(attrName.toUpperCase());
	}
	
	public void setAttribute(String attrName,String attrValue){
		extAtrribute.put(attrName.toUpperCase(),attrValue);
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.sadre.simplebo.CustomerInfo#getCreditLevel()
	 */
	public String getCreditLevel(){
		return creditLevel;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.sadre.simplebo.CustomerInfo#getName()
	 */
	public String getName() {
		return name;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.sadre.simplebo.CustomerInfo#getId()
	 */
	public String getId() {
		return id;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.sadre.simplebo.CustomerInfo#getType()
	 */
	public String getType() {
		return type;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.sadre.simplebo.CustomerInfo#getCertType()
	 */
	public String getCertType() {
		return certType;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.sadre.simplebo.CustomerInfo#getCertId()
	 */
	public String getCertId() {
		return certId;
	}
	
}
