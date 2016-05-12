package com.amarsoft.app.accounting.trans.script.loan.impairechange;

//还款，整合提前还款
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.TransactionConfig;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.ASValuePool;

public class ImpairmentToNormal implements ITransactionExecutor{
	
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		//取Loan对象
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		loan.setAttributeValue("IMPAIRMENTFLAG", ACCOUNT_CONSTANTS.IMPAIRMENTFLAG_Normal);//非减值标志  @by Lambert
		
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", loan.getObjectType());
		as.setAttribute("ObjectNo", loan.getString("SerialNo"));
		as.setAttribute("RateType", "07");
		as.setAttribute("Status", "1");
		List<BusinessObject> rateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType and Status=:Status order by SegFromDate desc",as);
		for(BusinessObject rate:rateList)
		{
			rate.setAttributeValue("SegToDate", SystemConfig.getBusinessDate());
		}
		boManager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_update, rateList);
		
		return 1;
	}

}