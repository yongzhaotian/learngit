package com.amarsoft.app.als.credit.apply.action;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.context.ASUser;

/**
 * 将申请基本信息及其关联信息复制到批复中,改写部分sqlca为jbo
 * @author xjzhao
 *
 */
public class AddOpinionInfo {
	
	private ASUser curUser = null;
	private String objectNo = "";
	private String objectType = "";
	private String taskNo = "";

	/**
	 * @param applyObject 申请对象
	 * @throws JBOException 
	 */
	public AddOpinionInfo(String objectNo,String objectType,String taskNo,ASUser curUser) throws JBOException {
		this.curUser = curUser;
		this.objectNo = objectNo;
		this.objectType = objectType;
		this.taskNo = taskNo;
	}

	/**
	 * 
	 * @param tx
	 * @throws Exception
	 */
	public String transfer(JBOTransaction tx) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.flow_opinion);
		tx.join(m);
		List<BizObject> lstbiz = m.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", this.taskNo).getResultList(false);
		if(lstbiz.size() == 0)
		{
			BizObjectManager ma=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.business_apply);
			tx.join(ma);
			BizObject boBa = ma.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", this.objectNo).getSingleResult(false);
			if(boBa == null) throw new Exception("未找到对应申请编号【"+this.objectNo+"】的申请信息！");
			BizObject bo = m.newObject();//新建审批意见
			bo.setAttributesValue(boBa);
			lstbiz = m.createQuery("O.SerialNo in(select FT.SerialNo from jbo.app.FLOW_TASK FT where FT.ObjectNo=:ObjectNo and FT.ObjectType=:ObjectType)" +
								   " and (EXISTS(select RS.SerialNo from jbo.app.ACCT_RATE_SEGMENT RS where RS.ObjectNo=O.OpinionNo and RS.ObjectType='"+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"') or exists( select AF.SerialNo from jbo.app.ACCT_FEE AF where AF.ObjectNo=O.OpinionNo and AF.ObjectType='"+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"')) order by OpinionNo desc ")
						.setParameter("ObjectNo", this.objectNo)
						.setParameter("ObjectType", this.objectType)
						.getResultList(false);
			String RelaObjectType,RelaObjectNo;
			if(lstbiz != null && lstbiz.size()!=0)
			{
				bo.setValue(lstbiz.get(0));
				RelaObjectNo = lstbiz.get(0).getAttribute("OpinionNo").getString();
				RelaObjectType = BUSINESSOBJECT_CONSTATNTS.flow_opinion;
				bo.setAttributeValue("OpinionNo", null);
			}
			else
			{
				RelaObjectNo = this.objectNo;
				RelaObjectType = BUSINESSOBJECT_CONSTATNTS.business_apply;
			}
			bo.setAttributeValue("SERIALNO",this.taskNo);
			bo.setAttributeValue("OBJECTNO",this.objectNo);
			bo.setAttributeValue("OBJECTTYPE",this.objectType);
			bo.setAttributeValue("INPUTORG",this.curUser.getOrgID());
			bo.setAttributeValue("INPUTUSER",this.curUser.getUserID());
			bo.setAttributeValue("INPUTTIME",SystemConfig.getBusinessTime());
			bo.setAttributeValue("UPDATEUSER",this.curUser.getUserID());
			bo.setAttributeValue("UPDATETIME",SystemConfig.getBusinessTime());
			bo.setAttributeValue("PhaseOpinion", "");
			m.saveObject(bo);
			
			transferAccountNo(tx,RelaObjectType,RelaObjectNo,BUSINESSOBJECT_CONSTATNTS.flow_opinion,bo.getAttribute("OpinionNo").getString());
			transferRate(tx,RelaObjectType,RelaObjectNo,BUSINESSOBJECT_CONSTATNTS.flow_opinion,bo.getAttribute("OpinionNo").getString());
			transferRPT(tx,RelaObjectType,RelaObjectNo,BUSINESSOBJECT_CONSTATNTS.flow_opinion,bo.getAttribute("OpinionNo").getString());
			transferSPT(tx,RelaObjectType,RelaObjectNo,BUSINESSOBJECT_CONSTATNTS.flow_opinion,bo.getAttribute("OpinionNo").getString());
			transferFee(tx,RelaObjectType,RelaObjectNo,BUSINESSOBJECT_CONSTATNTS.flow_opinion,bo.getAttribute("OpinionNo").getString());
			return bo.getAttribute("OpinionNo").getString();
		}
		return lstbiz.get(0).getAttribute("OpinionNo").getString();
	}
	
	
	/**
	 * 拷贝审批意见对应的利率
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferRate(JBOTransaction tx,String relaObjectType,String relaObjectNo,String newObjectType,String newObjectNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType='"+relaObjectType+"' and ObjectNo = :ObjectNo ")
		                .setParameter("ObjectNo", relaObjectNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", newObjectType);
			newCO.setAttributeValue("ObjectNo", newObjectNo);
			m.saveObject(newCO);
		}
	}
	
	
	/**
	 * 拷贝审批意见对应的还款方式
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferRPT(JBOTransaction tx,String relaObjectType,String relaObjectNo,String newObjectType,String newObjectNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType='"+relaObjectType+"' and ObjectNo = :ObjectNo ")
		                .setParameter("ObjectNo", relaObjectNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", newObjectType);
			newCO.setAttributeValue("ObjectNo", newObjectNo);
			m.saveObject(newCO);
		}
	}
	
	
	/**
	 * 拷贝审批意见对应的费用
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferFee(JBOTransaction tx,String relaObjectType,String relaObjectNo,String newObjectType,String newObjectNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.fee);
		BizObjectManager ms=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.fee_waive);
		BizObjectManager ma=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		tx.join(m);
		tx.join(ms);
		tx.join(ma);
		List<BizObject> lstbiz=m.createQuery("ObjectType='"+relaObjectType+"' and ObjectNo = :ObjectNo ")
		                .setParameter("ObjectNo", relaObjectNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", newObjectType);
			newCO.setAttributeValue("ObjectNo", newObjectNo);
			m.saveObject(newCO);
			
			String oldFeeSerialNo = biz.getAttribute("SerialNo").getString();
			String feeSerialNo = newCO.getAttribute("SerialNo").getString();
			List<BizObject> feeWaive = ms.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo")
											.setParameter("ObjectNo", oldFeeSerialNo)
											.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee)
											.getResultList(false);
			for(BizObject boWaive : feeWaive)
			{
				BizObject newWaive = ms.newObject();
				newWaive.setAttributesValue(boWaive);
				newWaive.setAttributeValue("SerialNo", null);
				newWaive.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
				newWaive.setAttributeValue("ObjectNo", feeSerialNo);
				ms.saveObject(newWaive);
			}
			
			List<BizObject> boAccounts=ma.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo ")
										.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee)
							            .setParameter("ObjectNo", oldFeeSerialNo)
							            .getResultList(false);
			for(BizObject boAccount:boAccounts){
				BizObject newAccount = ma.newObject();
				newAccount.setAttributesValue(boAccount);
				newAccount.setAttributeValue("SerialNo", null);
				newAccount.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
				newAccount.setAttributeValue("ObjectNo", feeSerialNo);
				ma.saveObject(newAccount);
			}
		}
	}
	
	/**
	 * 拷贝审批意见对应的贴息
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferSPT(JBOTransaction tx,String relaObjectType,String relaObjectNo,String newObjectType,String newObjectNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType='"+relaObjectType+"' and ObjectNo = :ObjectNo ")
		                .setParameter("ObjectNo", relaObjectNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", newObjectType);
			newCO.setAttributeValue("ObjectNo", newObjectNo);
			m.saveObject(newCO);
		}
	}
	
	/**
	 * 拷贝申请信息的账号信息
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferAccountNo(JBOTransaction tx,String relaObjectType,String relaObjectNo,String newObjectType,String newObjectNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType='"+relaObjectType+"' and ObjectNo = :ObjectNo ")
		                .setParameter("ObjectNo", relaObjectNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", newObjectType);
			newCO.setAttributeValue("ObjectNo", newObjectNo);
			m.saveObject(newCO);
		}
	}
	
}
