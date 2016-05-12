package com.amarsoft.app.accounting.trans.script.loan.eod;
 
import java.util.ArrayList;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.ARE;

public class LoanBODExecutor_start implements ITransactionExecutor{
	
	private ITransactionScript transactionScript;


	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript =transactionScript;
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		String transactionDate = transaction.getString("TransDate");//交易日期
		BusinessObject loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		String loanSerialNo = loan.getString("SerialNo");

		loan.setAttributeValue("LockFlag", "2");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
		
		String businessDate = loan.getString("BusinessDate");//贷款处理时间
		if(!transactionDate.equals(businessDate)){//如果贷款
			ARE.getLog().warn("该条记录被忽略，贷款{"+loanSerialNo+"}处理日期与系统日期不一致" +
					",系统交易日期"+transactionDate+"，贷款处理日期businessDate="+businessDate);
			return 0;
		}
		ARE.getLog().debug("贷款流水号="+loanSerialNo+",当前处理日期businessDate="+businessDate);
		
		//将发生额归零
		ArrayList<BusinessObject> a = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger);
		if(a!=null)	clearLedgerBalance(a,businessDate);
		
		return 1;
	}
		
	private void clearLedgerBalance(ArrayList<BusinessObject> subledgers,String businessdate) throws Exception{		
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		for (BusinessObject subledger:subledgers) {
			subledger.setAttributeValue("DEBITAMTDAY", 0d);
			subledger.setAttributeValue("CREDITAMTDAY", 0d);
			if(businessdate.endsWith("/01")){
				subledger.setAttributeValue("DEBITAMTMONTH", 0d);
				subledger.setAttributeValue("CREDITAMTMONTH", 0d);
			}
			if(businessdate.endsWith("/01/01")){
				subledger.setAttributeValue("DEBITAMTYEAR", 0d);
				subledger.setAttributeValue("CREDITAMTYEAR", 0d);
			}
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, subledger);
		}
	}

}