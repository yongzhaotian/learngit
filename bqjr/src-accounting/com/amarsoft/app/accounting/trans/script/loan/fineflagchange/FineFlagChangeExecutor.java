package com.amarsoft.app.accounting.trans.script.loan.fineflagchange;

//���������ǰ����
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.util.ASValuePool;

public class FineFlagChangeExecutor implements ITransactionExecutor{
	
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//ȡLoan����
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		String autoPayFlag = loanChange.getString("AutoPayFlag");//�Ƿ��Զ��ۿ�
		String stopInteFlag = loanChange.getString("StopInteFlag");//�Ƿ�ֹͣ���㷣Ϣ������
		
		ASValuePool as =  new ASValuePool();
		as.setAttribute("ObjectType",BUSINESSOBJECT_CONSTATNTS.loan);
		as.setAttribute("ObjectNo",loan.getString("SerialNo"));
		String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status in('1','3') and RateTermID like 'FIN%' " ;
		List<BusinessObject> rateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, whereClauseSql,as);
		if(rateList == null || rateList.size() == 0) throw new Exception("δȡ����Ӧ��Ϣ���ʣ�");
		for(BusinessObject rate : rateList){
			rate.setAttributeValue("Status", (!"1".equals(stopInteFlag) ? "3" : "1"));//����Ϣ��¼�������Ϊ��Ч
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,rate);
		}
		loan.setAttributeValue("AutoPayFlag", autoPayFlag);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
		
		return 1;
	}

}