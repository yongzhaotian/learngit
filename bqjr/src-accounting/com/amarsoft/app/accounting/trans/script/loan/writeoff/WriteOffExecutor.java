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
 * �����������
 */
public class WriteOffExecutor implements ITransactionExecutor{
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		//���´�������ֶ���Ϣ����������Ҫ���»���ƻ�
		loan.setAttributeValue("LoanStatus", "5");//�������۳�
		loan.setAttributeValue("AutoPayFlag", "2");//���������Զ����пۿ�
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loan);
		//���»���ƻ��Զ��ۿ��ʾ
		List<BusinessObject> ls = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		if(ls != null && !ls.isEmpty())
		{
			for(BusinessObject pay:ls)
			{
				if(pay.getString("FinishDate") == null || "".equals(pay.getString("FinishDate")))
				{
					pay.setAttributeValue("AutoPayFlag", "2");//���������Զ����пۿ�
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, pay);
				}
			}
		}
		return 1;
	}

}
