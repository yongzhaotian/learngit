package com.amarsoft.app.accounting.trans.script.loan.drawdown;

import java.util.ArrayList;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.FeeFunctions;

/**
 * �����
 */
public class DrawdownScript_updateloan implements ITransactionExecutor{

	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		BusinessObject businessPutout=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		//�����滹��ƻ�����
		ArrayList<BusinessObject> feeList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(feeList !=null)
		{
			for(BusinessObject fee:feeList)
			{
				if(fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule)==null || fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule).isEmpty())
				{
					ArrayList<BusinessObject> feeScheduleList_T = FeeFunctions.createFeeScheduleList(fee,loan, boManager);
					fee.setRelativeObjects(feeScheduleList_T);
					loan.setRelativeObjects(feeScheduleList_T);
					boManager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_new, feeScheduleList_T);
				}
			}
		}
		
		//��bc��ʵ�ʷſ������
		BusinessObject bc = businessPutout.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract, businessPutout.getString("ContractSerialNo"));
		if(bc!=null){
			bc.setAttributeValue("ActualputoutSum", bc.getDouble("ActualputoutSum")+loan.getDouble("BusinessSum"));
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,bc);
		}
		
		
		
		return 1;
	}

}
