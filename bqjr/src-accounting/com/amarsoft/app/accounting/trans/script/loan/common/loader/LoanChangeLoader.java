package com.amarsoft.app.accounting.trans.script.loan.common.loader;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.product.ProductManage;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;
import com.amarsoft.are.util.ASValuePool;

public class LoanChangeLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//设置变更生效日期
		loanChange.setAttributeValue("ChangeDate", SystemConfig.getBusinessDate());
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loanChange);
		//取Loan对象
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
			
		//加载LoanChange的还款计划信息，微贷需要使用调整后的还款计划
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo order by SeqID,PayDate,PayType " ;
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan_change);
		as.setAttribute("ObjectNo", loanChange.getString("SerialNo"));
		List<BusinessObject> paymentScheduleList_Change = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule, whereClauseSql,as);
		loan.setRelativeObjects("FixPaymentSchedule",paymentScheduleList_Change);
		loanChange.setRelativeObjects(paymentScheduleList_Change);
		ProductManage pm = new ProductManage(boManager);
		pm.initBusinessObject(loan);
		return transaction;
	}
}
