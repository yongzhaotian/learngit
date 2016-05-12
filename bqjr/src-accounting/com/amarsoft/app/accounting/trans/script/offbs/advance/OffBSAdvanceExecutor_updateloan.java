package com.amarsoft.app.accounting.trans.script.offbs.advance;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;

/**
 * @author xjzhao 2011/04/02
 * 垫款交易
 */
public class OffBSAdvanceExecutor_updateloan implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject offBSBusiness = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject bp=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));

		//更新垫款与表外业务的关联
		double balance = AccountCodeConfig.getBusinessObjectBalance(offBSBusiness, "BookType,"+AccountCodeConfig.accountcode_type_las+",AccountCodeNo,LAS60101", ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		if(balance==0) {
			offBSBusiness.setAttributeValue("FinishDate", transaction.getString("TransDate"));
			offBSBusiness.setAttributeValue("FinishType", "100");
		}
		else{
			offBSBusiness.setAttributeValue("FinishDate", "");
			offBSBusiness.setAttributeValue("FinishType", "");
		}
		offBSBusiness.setAttributeValue("Balance", balance);
		offBSBusiness.setAttributeValue("NormalBalance", balance);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, offBSBusiness);
		//更新BP
		bp.setAttributeValue("PutoutStatus","1");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, bp);
		
		return 1;
	}
	
}
