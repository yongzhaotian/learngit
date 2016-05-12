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
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript =transactionScript;
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		String transactionDate = transaction.getString("TransDate");//��������
		BusinessObject loan = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan).get(0);
		String loanSerialNo = loan.getString("SerialNo");

		loan.setAttributeValue("LockFlag", "2");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
		
		String businessDate = loan.getString("BusinessDate");//�����ʱ��
		if(!transactionDate.equals(businessDate)){//�������
			ARE.getLog().warn("������¼�����ԣ�����{"+loanSerialNo+"}����������ϵͳ���ڲ�һ��" +
					",ϵͳ��������"+transactionDate+"�����������businessDate="+businessDate);
			return 0;
		}
		ARE.getLog().debug("������ˮ��="+loanSerialNo+",��ǰ��������businessDate="+businessDate);
		
		//�����������
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