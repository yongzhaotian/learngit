/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2007 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.app.als.sadre.simplebo;
 
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;

/**
 * <p>Title: BusinessContract.java </p>
 * <p>Description: 本类为业务合同对象 </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-6-9 下午04:08:00</p>
 *
 * logs: 1. </p>
 */
public class BusinessContract implements ISimpleBO{
	
	private String serialNo = "";
	
	private String customerId = "";
	
	private String customerName = "";
	
	private String businessType = "";
	
	private String businessName = "";
	
	private String vouchType = "";
	
	private String businessCurrency = "";
	
	private double businessSum = 0.0D;
	
	private double bailRatio = 0.0D;
	
	private double bailSum = 0.0D;
	
	private double balanceDouble = 0.0D;
	/**
	 * 字符型的合同余额,用于获取数据库的原始状态，判断是否发生过余额变更
	 */
	private String balanceString = null;
	
	private double convertedBalance = 0.0D;
	
	private String manageOrgId = "";
	
	private String creditAggreement = "";
	
	private String maturity = "";
	
	private String putoutDate = "";
	
	private String applyType = "";
	
	private String occurType = "";
	/**
	 * 为出帐金额
	 */
	private double unPutoutedSum = -1;
	
	private double exRate = 0.0D;
	
	/**
	 * 合同对应的担保合同
	 */
	private List<GuarantyContract> guarantyContracts = null;
	
	private Transaction Sqlca;
	
	public BusinessContract(String contractNo, Transaction to){
		this.serialNo = contractNo;
		this.Sqlca = to;
	}
	
	public void fullfill() throws SADREException {
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select CustomerId,CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessName," +
					"BusinessCurrency,VouchType,OccurType,BusinessSum,BailRatio,manageOrgId,maturity,putoutDate,applyType " +
					"from BUSINESS_CONTRACT where SERIALNO='"+getSerialNo()+"'");
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
				applyType		= StringUtil.getString(resultset.getString("APPLYTYPE"));
				manageOrgId	= StringUtil.getString(resultset.getString("manageOrgId"));
				maturity		= StringUtil.getString(resultset.getString("maturity"));
				putoutDate		= StringUtil.getString(resultset.getString("putoutDate"));
				
				balanceDouble = resultset.getDouble("Balance");
				balanceString = StringUtil.getString(resultset.getString("Balance"));
//				//------------ 额度或者未出帐的合同,返回去合同金额
				convertedBalance = balanceString.length()==0?businessSum:balanceDouble;
			}
			resultset.getStatement().close();
			
		} catch (Exception e) {
			throw new SADREException(e);
		}
	}
	
	public List<GuarantyContract> getGuarantyContracts() throws Exception {
		
		if(guarantyContracts==null){
			guarantyContracts = new ArrayList<GuarantyContract>();
			//TODO;
//			try {
//				BizObjectQuery boq = JBOFactory.createBizObjectQuery("jbo.app.AGR_CRE_SEC_RELA", "SERIALNO=:SERIALNO and OBJECTTYPE='BusinessContract'");
//				boq.setParameter("SERIALNO", getSerialNo());
//				Iterator<BizObject> result = boq.getResultList(false).iterator();
//				if(result.hasNext()){
//					BizObject bo = result.next();
//					String sGCSerialNo = DataConvert.toString(bo.getAttribute("Gur_SerialNo").getString());
//					
//					/*担保合同对象实例化*/
//					GuarantyContract gc = new GuarantyContract(sGCSerialNo, Sqlca);
//					gc.fullfill();
//					guarantyContracts.add(gc);
//				}
//			} catch (JBOException e) {
//				throw new SADREException(e);
//			}
		}
		
		return guarantyContracts;
	}
	
	public String getPutoutDate() {
		return putoutDate;
	}

	public String getOccurType() {
		return occurType;
	}

	public String getApplyType() {
		return applyType;
	}

	public double getBalanceDouble() {
		return balanceDouble;
	}

	public String getMaturity() {
		return maturity;
	}
	
	/**
	 * 延迟加载业务所属授信额度编号
	 * @return
	 * @throws SADREException
	 */
	public String getCreditAggreement() throws SADREException{
		if(creditAggreement==null || creditAggreement.length()==0){
			//TODO;
//			
//			try {
//				BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.lmt.CL_OCCUPY");
//				
//				BizObjectQuery boq = bom.createQuery("select RELATIVESERIALNO from O,jbo.app.BUSINESS_CONTRACT BC " +
//						"where O.OBJECTNO=BC.SerialNo " +
//						"and O.OBJECTNO=:CONTRACTNO " +
//						"and O.OBJECTTYPE='BusinessContract' " +
//						"and BC.BusinessType not like '3030%'");
//				boq.setParameter("CONTRACTNO", getSerialNo());
//				BizObject bo = boq.getSingleResult(false);
//				if(bo!=null){
//					creditAggreement = DataConvert.toString(bo.getAttribute("RELATIVESERIALNO").getString());
//				}
//			} catch (JBOException e) {
//				throw new SADREException(e);
//			}
		}
		return creditAggreement;
	}
	
	/**
	 * 获取已出帐合同项下的未出帐金额:<br>
	 * 1.如果合同为额度/未放款合同,那么未出帐金额为0
	 * 2.如果合同为已发生放款的合同,那么未出帐金额=合同金额-已出帐金额
	 * 
	 * @return
	 * @throws Exception
	 */
	public double getUnPutoutedSum2RMB() throws SADREException {
		if(unPutoutedSum!=-1) return unPutoutedSum;

		//---------是否额度/未出帐合同
		if(getBalanceString().length()==0){
			unPutoutedSum = 0.0D;
			
		}else{
			double dPutoutedSum = 0.0D;
			//TODO;
//			try {
//				//"select sum(BusinessSum*getexchangerate(BusinessCurrency,'01')) as v.PutoutedSum "
//				BizObjectQuery boq = JBOFactory.createBizObjectQuery("jbo.app.BUSINESS_PUTOUT", "CONTRACTSERIALNO=:CONTRACTSERIALNO");
//				boq.setParameter("CONTRACTSERIALNO", getSerialNo());
//				Iterator<BizObject> result = boq.getResultList(false).iterator();
//				while(result.hasNext()){
//					BizObject bo = result.next();
//					double dERate = BizUtil.getExchangeRate(bo.getAttribute("BusinessCurrency").getString(),"01");
//					dPutoutedSum += DecimalUtil.multiply(bo.getAttribute("BusinessSum").getDouble(),dERate);
//				}
//				
//				unPutoutedSum = this.getBusinessSum()*BizUtil.getExchangeRate(getBusinessCurrency(),"01")-dPutoutedSum;
				
//			} catch (JBOException e) {
//				throw new SADREException(e);
//			}
			
		}
		
		return unPutoutedSum<0?0:unPutoutedSum;
	}

	public String getBalanceString() {
		return balanceString;
	}

	public String getManageOrgId() {
		return manageOrgId;
	}

	public String getBusinessCurrency() {
		return businessCurrency;
	}
	
	public String getSerialNo() {
		return serialNo;
	}

	public String getCustomerId() {
		return customerId;
	}

	public String getCustomerName() {
		return customerName;
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

	public double getBusinessSum() {
		return businessSum;
	}

	public double getBailRatio() {
		return bailRatio;
	}

	public double getBailSum() {
		return bailSum;
	}
	
	public double getConvertedBalance() {
		return convertedBalance;
	}

	public String toString(){
		return this.getSerialNo()+" |"+this.getCustomerName()+" |"+this.getBusinessName()+" |币种="+this.getBusinessCurrency()+" |合同金额="+this.getBusinessSum()+" |合同余额="+this.getConvertedBalance()+" |担保方式:"+this.getVouchType()+" |起始日:"+this.getPutoutDate()+" |到期日:"+this.getMaturity();
	}
	
}
