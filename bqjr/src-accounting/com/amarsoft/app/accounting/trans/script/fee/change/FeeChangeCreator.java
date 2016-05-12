package com.amarsoft.app.accounting.trans.script.fee.change;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.are.util.ASValuePool;

public class FeeChangeCreator implements ITransactionCreator {
	


	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));

		ASValuePool rela = new ASValuePool();
		rela.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
		rela.setAttribute("ObjectNo", "${SerialNo}");
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status " ;
		
		
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType",transaction.getString("RelativeObjectType"));
		as.setAttribute("ObjectNo",transaction.getString("RelativeObjectNo"));
		as.setAttribute("Status","1");
		List<BusinessObject> oldFeeList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, whereClauseSql,as,BUSINESSOBJECT_CONSTATNTS.fee_waive," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
		oldFeeList = boManager.loadBusinessObjects(oldFeeList, BUSINESSOBJECT_CONSTATNTS.loan_accounts," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
		for(BusinessObject fee:oldFeeList){
			BusinessObject newFee = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee,boManager);
			newFee.setValue(fee);
			newFee.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan_change);
			newFee.setAttributeValue("ObjectNo", loanChange.getString("SerialNo"));
			newFee.setAttributeValue("Status", "2");
			
			//处理费用减免信息
			List<BusinessObject> boList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive);
			if(boList != null)
			{
				for(BusinessObject feewaive:boList)
				{
					BusinessObject fw = new BusinessObject(feewaive.getObjectType(),boManager);
					fw.setValue(feewaive);
					fw.setAttributeValue("ObjectNo", newFee.getObjectNo());
					fw.setAttributeValue("ObjectType", newFee.getObjectType());
					
					if(fw.getString("WaiveFromDate") == null || fw.getString("WaiveFromDate").length() == 0)
						fw.setAttributeValue("WaiveFromDate", newFee.getString("SegFromDate"));
					if(fw.getString("WaiveToDate") == null || fw.getString("WaiveToDate").length() == 0)
						fw.setAttributeValue("WaiveToDate", newFee.getString("SegToDate"));
					if(fw.getInt("WaiveFromStage") == 0) fw.setAttributeValue("WaiveFromStage", newFee.getString("SegFromStage"));
					if(fw.getInt("WaiveToStage") == 0) fw.setAttributeValue("WaiveToStage", newFee.getString("SegToStage"));
					newFee.setRelativeObject(fw);
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, fw);
				}
			}
			//处理费用账户信息
			boList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
			if(boList != null)//查看费用本身录入的费用存款账户信息
			{
				for(BusinessObject bo:boList)
				{
					BusinessObject la = new BusinessObject(bo.getObjectType(),boManager);
					la.setValue(bo);
					la.setAttributeValue("ObjectNo",newFee.getObjectNo());
					la.setAttributeValue("ObjectType", newFee.getObjectType());
					la.setAttributeValue("Status", "1");
					newFee.setRelativeObject(la);
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, la);
				}
			}
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newFee);
		}
		
		return transaction;
	}
}
