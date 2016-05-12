package com.amarsoft.app.accounting.hhcf;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;

/**
 * CPD逾期天数
 */
public class CPDExecutor implements ITransactionExecutor{
	
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager bomanager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		String businessDate = loan.getString("BusinessDate");
		String productID = loan.getString("BusinessType");
		String productVersion = ProductConfig.getProductNewestVersionID(productID);
		String CPD = ProductConfig.getProductTermParameterAttribute(productID,productVersion, "PS001", "CPD", "DefaultValue");
		
		if(loan.getDouble("OverdueBalance")>Double.parseDouble(CPD)) loan.setAttributeValue("CPDDays", loan.getString("OverDueDays"));
		
		/*第二种形式
		int days = DateFunctions.getDays(loan.getString("LastDueDate"),businessDate);
		if(loan.getDouble("OverdueBalance")>Double.parseDouble(CPD)) loan.setAttributeValue("CPDDays", Integer.parseInt(loan.getString("CPDDays"))+days);
		*/
		bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loan);
		
		return 1;
	}

}
