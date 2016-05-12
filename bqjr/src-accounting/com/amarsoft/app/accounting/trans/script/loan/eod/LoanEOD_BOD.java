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
		if(eodTransCode==null||eodTransCode.length()==0) throw new DataException("������δ����EODTransactionCode��");
		String bodTransCode = TransactionConfig.getTransactionDef(transCode,"BODTransactionCode");
		if(bodTransCode==null||bodTransCode.length()==0) throw new DataException("������δ����BODTransactionCode��");
		
		String transactionDate = transaction.getString("TransDate");//��������
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"),transaction.getString("RelativeObjectNo"));
		String businessDate = loan.getString("BusinessDate");//�����ʱ��
		while (transactionDate.compareTo(businessDate) >= 0){
			try{
				//���ս��� 9091
				BusinessObject t1 = TransactionFunctions.createTransaction(eodTransCode,null,loan,"system",businessDate,boManager);
				TransactionFunctions.runTransaction(t1, boManager);
				
				businessDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_DAY, 1);
				loan.setAttributeValue("BusinessDate", businessDate);
				//�ճ�����9092
				BusinessObject t2 = TransactionFunctions.createTransaction(bodTransCode,null,loan,"system",businessDate,boManager);
				TransactionFunctions.runTransaction(t2, boManager);
				
				//ִ��Ԥ�ñ�� 
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
				//ֻ����ѯ�ã����ύ���ݿ⡣���д���Ҳ���׳���
				e.printStackTrace();
				ARE.getLog().warn("�����ս��׳���{"+loan.getObjectNo()+"},����ԭ��!"+e.getMessage() );
				throw e;
			}
		}
		return 1;
	}
	

}