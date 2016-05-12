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
 * @date 2012-2-6 ����12:03:48
 *
 * logs: 1. 
 */
public class DefaultSynonymnImpl extends WorkingRuleObject{
	public static final String ����ֵ_�Ƿ�_�� = "1";
	public static final String ����ֵ_�Ƿ�_�� = "2";
	/*ҵ����˽�б���*/
	private String objectNo = "";		//������
	private String objectType = "";		//��������

	private BusinessApply apply = null;		//����ҵ�����
	private BusinessPutout putout = null;	//����ҵ�����
	private ClassifyApply classify = null;	//��������ҵ�����
	
	private ICustomer customer = null;		//����ͻ�����
	
	private Transaction Sqlca = null;
	
	public DefaultSynonymnImpl(String objectNo,String objectType, Transaction sqlca){
		//����,����,����
		if(",CreditApply,PutOutApply,Classify".indexOf(objectType)<=0){
			ARE.getLog().error("���������쳣,��ǰ��Ȩ��֧��!");
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
			/*����ҵ�����*/
			apply = new BusinessApply(getObjectNo(),Sqlca);
			apply.fullfill();
			/*�����˶���*/
			customer = apply.getApplicant();
		}else if("PutOutApply".equals(objectType)){
			/*����ҵ�����*/
			putout = new BusinessPutout(getObjectNo(),Sqlca);
			putout.fullfill();
			/*�����˶���*/
			customer = putout.getApplicant();
		}else if("Classify".equals(objectType)){
			/*��������ҵ�����*/
			classify = new ClassifyApply(getObjectNo(),Sqlca);
			classify.fullfill();
			/*����ҵ��(���)����˶���*/
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
	 * ��ȡ��������ͳ�Ƶ�Ԫ
	 * @param type
	 * @return
	 */
	public OccupiedCalcUnit getCalcUnit(String type){
		return OccupiedFactory.getCalcUnit(type, this);
	}
	
	/**
	 * ���������ܶ�
	 * @return
	 * @throws SADREException 
	 */
	@Comment(type=Comment.�ͻ������,describe="�ͻ���Ϣ:���������ܶ�")
	public double getCustomerTotalSum() throws SADREException {
		return getCalcUnit("CustomerTotal").calculate()+apply.getBusinessSum();
	}
	
	/**
	 * �������ճ��ڽ��
	 * @return
	 * @throws SADREException 
	 */
	@Comment(type=Comment.�ͻ������,describe="�ͻ���Ϣ:�������ճ��ڽ��")
	public double getCustomerRiskGapSum() throws SADREException {
		return getCalcUnit("CustomerRiskGap").calculate()+apply.getRiskGapSum();
	}
	
	@Comment(type=Comment.�ͻ������,describe="�ͻ���Ϣ:�ͻ�����")
	public String getCustomerType() {
		return customer.getType();
	}
	
	@Comment(type=Comment.�ͻ������,describe="�ͻ�������������")
	public String getRegionCode() {
		return customer.getAttribute("REGIONCODE");
	}
	
	@Comment(type=Comment.�ͻ������,describe="�ͻ���Ϣ:�ͻ���ģ")
	public String getScope() {
		return customer.getAttribute("SCOPE");
	}
	
	@Comment(type=Comment.�ͻ������,describe="�ͻ���Ϣ:���������ȼ�")
	public String getCreditLevel() {
		return customer.getCreditLevel();
	}
	
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:������")
	public double getBusinessSum() {
		return apply.getBusinessSum();
	}
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:����")
	public String getCurrnecy() {
		return apply.getBusinessCurrency();
	}
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:ҵ��Ʒ��")
	public String getBusinessType() {
		return apply.getBusinessType();
	}
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:��Ҫ������ʽ")
	public String getVouchType() {
		return apply.getVouchType();
	}
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:�Ƿ�ͷ���")
	public String isLowRisk() {
		return apply.isLowRisk().equals("1")?����ֵ_�Ƿ�_��:����ֵ_�Ƿ�_��;
	}
	
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:�Ƿ���ȫ�ֽ�֤ҵ��")
	public String isCashLikeGuarantee() {
		return apply.isLowRisk();
	}
	
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:�Ƿ���������ƽ̨ҵ��")
	public String getFinancing() {
		return apply.getGovermentPlat();
	}
	
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:ҵ����������")
	public String getManageScope() {
		//TODO;
		return "";
	}
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:��������")
	public String getOccurType() {
		return apply.getOccurType();
	}
	
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:�Ƿ�ת����������")
	public String getRiskTransform() {
		return ����ֵ_�Ƿ�_��;
	}
	
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:�Ƿ�������ҵ��")
	public String isDependentBiz() {
		return apply.getApplyType().matches("(DependentApply|SEIndependentApply)")?����ֵ_�Ƿ�_��:����ֵ_�Ƿ�_��;
	}
	
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:���ʽ��")
	public double getBPBusinessSum() {
		return putout.getBusinessSum();
	}
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:����")
	public String getBPCurrnecy() {
		return putout.getBusinessCurrency();
	}
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:ҵ��Ʒ��")
	public String getBPBusinessType() {
		return putout.getBusinessType();
	}
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:��ݽ��")
	public double getBDBusinessSum() {
		return classify.getBusinessSum();
	}
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:�����϶����")
	public String getClassifyFinallyResult() {
		return classify.getFinallyResult();
	}
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:��ݱ���")
	public String getBDCurrnecy() {
		return classify.getBusinessCurrency();
	}
	@Comment(type=Comment.ҵ�������,describe="������Ϣ:���ҵ��Ʒ��")
	public String getBDBusinessType() {
		return classify.getBusinessType();
	}
	
	@Comment(type=Comment.ͨ�������,describe="����������Ȩ��")
	public double getOwnersEquity(){
		return 200000000;		//ģ��2��
	}
	
	/**
	 * ��������ָ���ͻ����µ�����ҵ���ͬ��Ϣ
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
