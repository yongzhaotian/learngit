package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.TransactionConfig;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.ARE;

public class LoanEOD_BOD implements ITransactionExecutor{

	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		String transCode = transaction.getString("TransCode");
		String eodTransCode = TransactionConfig.getTransactionDef(transCode, "EODTransactionCode");
		if(eodTransCode==null||eodTransCode.length()==0) throw new DataException("交易中未定义EODTransactionCode！");
		String bodTransCode = TransactionConfig.getTransactionDef(transCode,"BODTransactionCode");
		if(bodTransCode==null||bodTransCode.length()==0) throw new DataException("交易中未定义BODTransactionCode！");
		
		String transactionDate = transaction.getString("TransDate");//交易日期
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"),transaction.getString("RelativeObjectNo"));
		String businessDate = loan.getString("BusinessDate");//贷款处理时间
		while (transactionDate.compareTo(businessDate) >= 0){
			try{
				//日终交易 9091
				BusinessObject t1 = TransactionFunctions.createTransaction(eodTransCode,null,loan,"system",businessDate,boManager);
				TransactionFunctions.runTransaction(t1, boManager);
				
				businessDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_DAY, 1);
				loan.setAttributeValue("BusinessDate", businessDate);
				//日初交易9092
				BusinessObject t2 = TransactionFunctions.createTransaction(bodTransCode,null,loan,"system",businessDate,boManager);
				TransactionFunctions.runTransaction(t2, boManager);
				
				//执行预置变更 
				List<BusinessObject> preTransactionList =  transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.transaction);
				if(preTransactionList!=null && preTransactionList.size()>0){
					for(BusinessObject preTransaction : preTransactionList){
						if(preTransaction.getString("TransStatus").equals("3")
								&& preTransaction.getString("TransDate").equals(businessDate)){
							BusinessObject t3 = TransactionFunctions.loadTransaction(preTransaction, boManager);
							TransactionFunctions.runTransaction(t3, boManager);
						}
					}
				}
			}catch(Exception e){
				//只是咨询用，不提交数据库。若有错误，也不抛出。
				e.printStackTrace();
				ARE.getLog().warn("处理换日交易出错{"+loan.getObjectNo()+"},请检查原因!"+e.getMessage() );
				throw e;
			}
		}
		return 1;
	}
	

}