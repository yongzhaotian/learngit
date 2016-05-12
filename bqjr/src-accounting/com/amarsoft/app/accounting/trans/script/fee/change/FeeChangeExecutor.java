package com.amarsoft.app.accounting.trans.script.fee.change;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.FeeFunctions;
import com.amarsoft.are.util.Arith;

public class FeeChangeExecutor implements ITransactionExecutor {
	
	@Override
	public int execute(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//取Loan对象
		BusinessObject feeRelativeObject = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		List<BusinessObject> oldFeeList = feeRelativeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(oldFeeList !=null){
			for(BusinessObject oldFee:oldFeeList){
				oldFee.setAttributeValue("Status", "2");//无效
				if(oldFee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule) != null){
					for(BusinessObject feeSchedule:oldFee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule)){
						if(feeSchedule.getString("FinishDate") == null || "".equals(feeSchedule.getString("FinishDate"))){
							if(feeSchedule.getDouble("ActualAmount") > 0.0d){
								oldFee.setAttributeValue("TotalAmount", Arith.round(oldFee.getDouble("TotalAmount")-(feeSchedule.getDouble("Amount")-feeSchedule.getDouble("ActualAmount")),2));
								feeSchedule.setAttributeValue("Amount", feeSchedule.getDouble("ActualAmount"));
								feeSchedule.setAttributeValue("FinishDate", transaction.getString("TransDate"));
								boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,feeSchedule);
							}
							else{
								boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete,feeSchedule);
							}
						}
					}
				}
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,oldFee);
			}
		}
		
		List<BusinessObject> newFeeList = loanChange.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(newFeeList != null){
			for(BusinessObject fee:newFeeList){
				fee.setAttributeValue("Status", "1");
				BusinessObject newFee = new BusinessObject(fee.getObjectType(),boManager);
				newFee.setValue(fee);
				newFee.setAttributeValue("ObjectType", feeRelativeObject.getObjectType());
				newFee.setAttributeValue("ObjectNo", feeRelativeObject.getObjectNo());
				newFee.setAttributeValue("AccountingOrgID", feeRelativeObject.getString("AccountingOrgID"));
				//处理费用减免信息
				List<BusinessObject> boList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive);
				if(boList != null){
					for(BusinessObject feewaive:boList){
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
				if(boList != null){//查看费用本身录入的费用存款账户信息
					for(BusinessObject feeAccount:boList)
					{
						BusinessObject la = new BusinessObject(feeAccount.getObjectType(),boManager);
						la.setValue(feeAccount);
						la.setAttributeValue("ObjectNo",newFee.getObjectNo());
						la.setAttributeValue("ObjectType", newFee.getObjectType());
						la.setAttributeValue("Status", "1");
						newFee.setRelativeObject(la);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, la);
					}
				}
				
				ArrayList<BusinessObject> feeScheduleList_T = FeeFunctions.createFeeScheduleList(newFee,feeRelativeObject, boManager);
				newFee.setRelativeObjects(feeScheduleList_T);
				feeRelativeObject.setRelativeObjects(feeScheduleList_T);
				boManager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_new, feeScheduleList_T);
				
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,newFee);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,fee);
			}
		}
		return 1;
	}
}
