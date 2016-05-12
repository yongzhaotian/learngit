package com.amarsoft.app.accounting.trans.script.loan.repricetypechange;

//还款，整合提前还款
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.RateFunctions;

public class RepriceTypeChangeExecutor implements ITransactionExecutor{
	
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//取Loan对象
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		String repriceType = loanChange.getString("RepriceType");//新利率调整方式
		String repriceDate = loanChange.getString("RepriceDate");//新利率调整日期
		String repriceFlag = loanChange.getString("RepriceFlag");//新利率调整期限单位
		String repriceCyc = loanChange.getString("RepriceCyc");//新利率调整周期
		
		
		loan.setAttributeValue("RepriceType", repriceType);
		loan.setAttributeValue("RepriceDate", repriceDate);
		loan.setAttributeValue("RepriceFlag", repriceFlag);
		loan.setAttributeValue("RepriceCyc", repriceCyc);
		String nextRepriceDate = RateFunctions.getNextRepriceDate(loan);//下次利率调整日
		loan.setAttributeValue("NextRepriceDate", nextRepriceDate);
		
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
		return 1;
	}

}