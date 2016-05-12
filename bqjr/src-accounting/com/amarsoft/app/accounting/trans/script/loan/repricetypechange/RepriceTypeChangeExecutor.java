package com.amarsoft.app.accounting.trans.script.loan.repricetypechange;

//���������ǰ����
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.RateFunctions;

public class RepriceTypeChangeExecutor implements ITransactionExecutor{
	
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//ȡLoan����
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		String repriceType = loanChange.getString("RepriceType");//�����ʵ�����ʽ
		String repriceDate = loanChange.getString("RepriceDate");//�����ʵ�������
		String repriceFlag = loanChange.getString("RepriceFlag");//�����ʵ������޵�λ
		String repriceCyc = loanChange.getString("RepriceCyc");//�����ʵ�������
		
		
		loan.setAttributeValue("RepriceType", repriceType);
		loan.setAttributeValue("RepriceDate", repriceDate);
		loan.setAttributeValue("RepriceFlag", repriceFlag);
		loan.setAttributeValue("RepriceCyc", repriceCyc);
		String nextRepriceDate = RateFunctions.getNextRepriceDate(loan);//�´����ʵ�����
		loan.setAttributeValue("NextRepriceDate", nextRepriceDate);
		
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
		return 1;
	}

}