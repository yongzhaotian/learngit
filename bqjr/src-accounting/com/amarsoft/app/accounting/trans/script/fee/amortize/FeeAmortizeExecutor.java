package com.amarsoft.app.accounting.trans.script.fee.amortize;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

/*
 * ����̯������
 */
public class FeeAmortizeExecutor implements ITransactionExecutor{
	
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject feeAmortize = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject fee = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject relativeObject = transaction.getRelativeObject(fee.getString("ObjectType"), fee.getString("ObjectNo"));
		
		ASValuePool asPool1 = ProductConfig.getProductTermParameter(relativeObject.getString("BusinessType"), relativeObject.getString("productversion"),fee.getString("feetermid"),"DiscountSubjectNo"); 
		if(asPool1!=null)
		{
			transaction.setAttributeValue("DiscountSubjectNo",asPool1.getString("DefaultValue"));
		}
		ASValuePool asPool2 = ProductConfig.getProductTermParameter(relativeObject.getString("BusinessType"), relativeObject.getString("productversion"),fee.getString("feetermid"),"SubjectNo");
		if(asPool2!=null)
		{
			transaction.setAttributeValue("SubjectNo",asPool2.getString("DefaultValue"));
		}
		//̯��״̬����
		feeAmortize.setAttributeValue("Status", "1");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,feeAmortize);
		//���õ�̯��������
		double amortizeAmount = feeAmortize.getDouble("AmortizeAmount");
		fee.setAttributeValue("AmortizeBalance", Arith.round(fee.getDouble("AmortizeBalance")-amortizeAmount,2));
		fee.setAttributeValue("AmortizeOccurDate", DateFunctions.getRelativeDate(transaction.getString("TransDate"), DateFunctions.TERM_UNIT_DAY, 1));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,fee);
		
		return 1;
	}

}