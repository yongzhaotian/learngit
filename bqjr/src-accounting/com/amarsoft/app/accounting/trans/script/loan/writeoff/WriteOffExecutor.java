package com.amarsoft.app.accounting.trans.script.loan.writeoff;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
/**
 * @author xjzhao 2011/04/02
 * 贷款核销交易
 */
public class WriteOffExecutor implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		//更新贷款余额字段信息，核销不需要更新还款计划
		loan.setAttributeValue("LoanStatus", "5");//核销、售出
		loan.setAttributeValue("AutoPayFlag", "2");//核销后不在自动进行扣款
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loan);
		//更新还款计划自动扣款标示
		List<BusinessObject> ls = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		if(ls != null && !ls.isEmpty())
		{
			for(BusinessObject pay:ls)
			{
				if(pay.getString("FinishDate") == null || "".equals(pay.getString("FinishDate")))
				{
					pay.setAttributeValue("AutoPayFlag", "2");//核销后不在自动进行扣款
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, pay);
				}
			}
		}
		return 1;
	}

}
