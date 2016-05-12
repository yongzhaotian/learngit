package com.amarsoft.app.accounting.trans.script.fee.common;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.app.accounting.util.FeeFunctions;
import com.amarsoft.are.util.ASValuePool;

public class CommonFeeLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeLog = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		//费用关联的对象
		//加载费用关联主对象
		BusinessObject relativeBusinessObject =  transaction.getRelativeObject(fee.getString("ObjectType"),fee.getString("ObjectNo"));
		if(relativeBusinessObject ==null){
			relativeBusinessObject = boManager.loadObjectWithKey(fee.getString("ObjectType"), fee.getString("ObjectNo"));
		}
		transaction.setRelativeObject(relativeBusinessObject);
		
		
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo " ;
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", relativeBusinessObject.getObjectType());
		as.setAttribute("ObjectNo", relativeBusinessObject.getObjectNo());
		List<BusinessObject> subLedgerList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger, whereClauseSql + " and (CloseDate is null or CloseDate='' )",as);
		relativeBusinessObject.setRelativeObjects(subLedgerList);
		transaction.setRelativeObjects(subLedgerList);
		
		
		
		//加载费用关联信息：减免信息、账户信息
		as = new ASValuePool();
		as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
		as.setAttribute("ObjectNo", fee.getObjectNo());
		fee = boManager.loadBusinessObject(fee, BUSINESSOBJECT_CONSTATNTS.fee_waive," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",as);
		fee = boManager.loadBusinessObject(fee, BUSINESSOBJECT_CONSTATNTS.loan_accounts," ObjectNo=:ObjectNo and ObjectType=:ObjectType order by ACCOUNTINDICATOR,PRI",as);
		//加载费用指定的还款计划
		String feeScheduleSerialNo=feeLog.getString("FeeScheduleSerialNo");
		if(feeScheduleSerialNo != null && !"".equals(feeScheduleSerialNo)){
			BusinessObject feeSchedule = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.fee_schedule,feeScheduleSerialNo);
			if(feeSchedule!=null) transaction.setRelativeObject(feeSchedule);
		}
		
		//加载费用的还款计划
		as = new ASValuePool();
		as.setAttribute("FeeSerialNo", fee.getObjectNo());
		List<BusinessObject> feeScheduleList = 
				boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule," FeeSerialNo=:FeeSerialNo order by paydate",as);
		relativeBusinessObject.setRelativeObjects(feeScheduleList);
		transaction.setRelativeObjects(feeScheduleList);

		FeeFunctions.importTermParameter(fee,relativeBusinessObject,boManager);
		
		return transaction;
	}
}
