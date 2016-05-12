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
package com.amarsoft.app.als.sadre;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.sadre.model.OccupiedCalcUnit;
import com.amarsoft.app.als.sadre.model.OccupiedFactory;
import com.amarsoft.app.als.sadre.simplebo.BusinessApply;
import com.amarsoft.app.als.sadre.simplebo.BusinessContract;
import com.amarsoft.app.als.sadre.simplebo.BusinessPutout;
import com.amarsoft.app.als.sadre.simplebo.ClassifyApply;
import com.amarsoft.app.als.sadre.simplebo.ICustomer;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.annotation.Comment;
import com.amarsoft.sadre.integration.WorkingRuleObject;

 /**
 * <p>Title: DefaultSynonymnImpl.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-6 下午12:03:48
 *
 * logs: 1. 
 */
public class DefaultSynonymnImpl extends WorkingRuleObject{
	public static final String 返回值_是否_是 = "1";
	public static final String 返回值_是否_否 = "2";
	/*业务类私有变量*/
	private String objectNo = "";		//对象编号
	private String objectType = "";		//对象类型

	private BusinessApply apply = null;		//申请业务对象
	private BusinessPutout putout = null;	//出帐业务对象
	private ClassifyApply classify = null;	//分类申请业务对象
	
	private ICustomer customer = null;		//申请客户对象
	
	private Transaction Sqlca = null;
	
	public DefaultSynonymnImpl(String objectNo,String objectType, Transaction sqlca){
		//申请,出帐,分类
		if(",CreditApply,PutOutApply,Classify".indexOf(objectType)<=0){
			ARE.getLog().error("对象类型异常,当前授权不支持!");
		}
		this.objectNo = objectNo;
		this.objectType = objectType;
		this.Sqlca = sqlca;
		try {
			this.loadData();
		} catch (SADREException e) {
			ARE.getLog().error(e);
		}
	}
	
	public String getType() {
		return "Default";
	}

	protected void finalPost() throws SADREException {
		// do nothing
	}
	
	@Override
	protected void prepare() throws SADREException {
	}

	@Override
	protected void process() throws SADREException {
		if("CreditApply".equals(objectType)){
			/*申请业务对象*/
			apply = new BusinessApply(getObjectNo(),Sqlca);
			apply.fullfill();
			/*申请人对象*/
			customer = apply.getApplicant();
		}else if("PutOutApply".equals(objectType)){
			/*出帐业务对象*/
			putout = new BusinessPutout(getObjectNo(),Sqlca);
			putout.fullfill();
			/*申请人对象*/
			customer = putout.getApplicant();
		}else if("Classify".equals(objectType)){
			/*分类申请业务对象*/
			classify = new ClassifyApply(getObjectNo(),Sqlca);
			classify.fullfill();
			/*分类业务(借据)借款人对象*/
			customer = classify.getApplicant();
		}
		
	}
	
	@Override
	protected void releaseResource() {
	}
	public String getObjectNo() {
		return objectNo;
	}
	
	public String getObjectType() {
		return objectType;
	}
	public BusinessApply getApply(){
		return apply;
	}
	public BusinessPutout getPutout() {
		return putout;
	}
	public ClassifyApply getClassify() {
		return classify;
	}
	
	public ICustomer getCustomer(){
		return customer;
	}
	
	/**
	 * 获取单户敞口统计单元
	 * @param type
	 * @return
	 */
	public OccupiedCalcUnit getCalcUnit(String type){
		return OccupiedFactory.getCalcUnit(type, this);
	}
	
	/**
	 * 单户授信总额
	 * @return
	 * @throws SADREException 
	 */
	@Comment(type=Comment.客户类参数,describe="客户信息:单户授信总额")
	public double getCustomerTotalSum() throws SADREException {
		return getCalcUnit("CustomerTotal").calculate()+apply.getBusinessSum();
	}
	
	/**
	 * 单户风险敞口金额
	 * @return
	 * @throws SADREException 
	 */
	@Comment(type=Comment.客户类参数,describe="客户信息:单户风险敞口金额")
	public double getCustomerRiskGapSum() throws SADREException {
		return getCalcUnit("CustomerRiskGap").calculate()+apply.getRiskGapSum();
	}
	
	@Comment(type=Comment.客户类参数,describe="客户信息:客户类型")
	public String getCustomerType() {
		return customer.getType();
	}
	
	@Comment(type=Comment.客户类参数,describe="客户所属行政区划")
	public String getRegionCode() {
		return customer.getAttribute("REGIONCODE");
	}
	
	@Comment(type=Comment.客户类参数,describe="客户信息:客户规模")
	public String getScope() {
		return customer.getAttribute("SCOPE");
	}
	
	@Comment(type=Comment.客户类参数,describe="客户信息:信用评级等级")
	public String getCreditLevel() {
		return customer.getCreditLevel();
	}
	
	@Comment(type=Comment.业务类参数,describe="申请信息:申请金额")
	public double getBusinessSum() {
		return apply.getBusinessSum();
	}
	@Comment(type=Comment.业务类参数,describe="申请信息:币种")
	public String getCurrnecy() {
		return apply.getBusinessCurrency();
	}
	@Comment(type=Comment.业务类参数,describe="申请信息:业务品种")
	public String getBusinessType() {
		return apply.getBusinessType();
	}
	@Comment(type=Comment.业务类参数,describe="申请信息:主要担保方式")
	public String getVouchType() {
		return apply.getVouchType();
	}
	@Comment(type=Comment.业务类参数,describe="申请信息:是否低风险")
	public String isLowRisk() {
		return apply.isLowRisk().equals("1")?返回值_是否_是:返回值_是否_否;
	}
	
	@Comment(type=Comment.业务类参数,describe="申请信息:是否完全现金保证业务")
	public String isCashLikeGuarantee() {
		return apply.isLowRisk();
	}
	
	@Comment(type=Comment.业务类参数,describe="申请信息:是否政府融资平台业务")
	public String getFinancing() {
		return apply.getGovermentPlat();
	}
	
	@Comment(type=Comment.业务类参数,describe="申请信息:业务所属区域")
	public String getManageScope() {
		//TODO;
		return "";
	}
	@Comment(type=Comment.业务类参数,describe="申请信息:发生类型")
	public String getOccurType() {
		return apply.getOccurType();
	}
	
	@Comment(type=Comment.业务类参数,describe="申请信息:是否转化风险授信")
	public String getRiskTransform() {
		return 返回值_是否_否;
	}
	
	@Comment(type=Comment.业务类参数,describe="申请信息:是否额度项下业务")
	public String isDependentBiz() {
		return apply.getApplyType().matches("(DependentApply|SEIndependentApply)")?返回值_是否_是:返回值_是否_否;
	}
	
	@Comment(type=Comment.业务类参数,describe="出帐信息:出帐金额")
	public double getBPBusinessSum() {
		return putout.getBusinessSum();
	}
	@Comment(type=Comment.业务类参数,describe="出帐信息:币种")
	public String getBPCurrnecy() {
		return putout.getBusinessCurrency();
	}
	@Comment(type=Comment.业务类参数,describe="出帐信息:业务品种")
	public String getBPBusinessType() {
		return putout.getBusinessType();
	}
	@Comment(type=Comment.业务类参数,describe="分类信息:借据金额")
	public double getBDBusinessSum() {
		return classify.getBusinessSum();
	}
	@Comment(type=Comment.业务类参数,describe="分类信息:最终认定结果")
	public String getClassifyFinallyResult() {
		return classify.getFinallyResult();
	}
	@Comment(type=Comment.业务类参数,describe="分类信息:借据币种")
	public String getBDCurrnecy() {
		return classify.getBusinessCurrency();
	}
	@Comment(type=Comment.业务类参数,describe="分类信息:借据业务品种")
	public String getBDBusinessType() {
		return classify.getBusinessType();
	}
	
	@Comment(type=Comment.通用类参数,describe="本行所有者权益")
	public double getOwnersEquity(){
		return 200000000;		//模拟2亿
	}
	
	/**
	 * 检索过滤指定客户项下的所有业务合同信息
	 * @param customerId
	 * @return
	 * @throws SADREException
	 */
	public List<BusinessContract> getContracts(String customerId) throws SADREException{
		List<BusinessContract> contract = new ArrayList<BusinessContract>();
		//TODO;
//		String sBCSerialNo = "";
//		try {
//			BizObjectQuery boqe = JBOFactory.createBizObjectQuery("jbo.app.BUSINESS_CONTRACT", "CUSTOMERID=:CUSTOMERID and (FINISHDATE is null or FINISHDATE = '')");
//			boqe.setParameter("CUSTOMERID", customerId);
//			Iterator<BizObject> bcs = boqe.getResultList(false).iterator();
//			while(bcs.hasNext()){
//				BizObject bo = bcs.next();
//				sBCSerialNo = StringUtil.getString(bo.getAttribute("SERIALNO").getString());
//				
//				BusinessContract bctmp = new BusinessContract(sBCSerialNo);
//				bctmp.fullfill();
//				
//				contract.add(bctmp);
//			}
//			
//		} catch (JBOException e) {
//			throw new SADREException(e);
//		}
		
		return contract;
	}
}
