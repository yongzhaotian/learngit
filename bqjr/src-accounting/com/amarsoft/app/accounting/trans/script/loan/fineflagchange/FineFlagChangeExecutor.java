package com.amarsoft.app.accounting.trans.script.loan.fineflagchange;

//还款，整合提前还款
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.util.ASValuePool;

public class FineFlagChangeExecutor implements ITransactionExecutor{
	
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//取Loan对象
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		String autoPayFlag = loanChange.getString("AutoPayFlag");//是否自动扣款
		String stopInteFlag = loanChange.getString("StopInteFlag");//是否停止计算罚息、复利
		
		ASValuePool as =  new ASValuePool();
		as.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.loan);
		as.setAttribute("ObjectNo",loan.getString("SerialNo"));
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status in('1','3') and RateTermID like 'FIN%' " ;
		List<BusinessObject> rateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, whereClauseSql,as);
		if(rateList == null || rateList.size() == 0) throw new Exception("未取到对应罚息利率！");
		for(BusinessObject rate : rateList){
			rate.setAttributeValue("Status", (!"1".equals(stopInteFlag) ? "3" : "1"));//将罚息记录锁定或变为生效
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,rate);
		}
		loan.setAttributeValue("AutoPayFlag", autoPayFlag);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
		
		return 1;
	}

}