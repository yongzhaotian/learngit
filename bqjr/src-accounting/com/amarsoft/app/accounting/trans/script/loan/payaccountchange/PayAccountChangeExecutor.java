package com.amarsoft.app.accounting.trans.script.loan.payaccountchange;

//���������ǰ����
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.util.ASValuePool;

public class PayAccountChangeExecutor implements ITransactionExecutor{
	
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//ȡLoan����
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		List<BusinessObject> oldAccountList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
		as.setAttribute("ObjectNo", loan.getObjectNo());
		as.setAttribute("Status","1");
		List<BusinessObject> feeList=boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee," ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status ",as);
		List<BusinessObject> feeAccountList=new ArrayList<BusinessObject>();
		List<BusinessObject> feeAccountList1=new ArrayList<BusinessObject>();
		for(BusinessObject fee:feeList){
			as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
			as.setAttribute("ObjectNo", fee.getObjectNo());
			as.setAttribute("Status","1");
			feeAccountList1=boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts," ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status ",as);
			if(feeAccountList1 != null )
			{
				for(BusinessObject account:feeAccountList1){
					for(BusinessObject boOld:oldAccountList)
					{
						if(account.getString("ACCOUNTINDICATOR").equals(boOld.getString("ACCOUNTINDICATOR"))
							&& account.getString("AccountNo").equals(boOld.getString("AccountNo"))){
							feeAccountList.add(account);
						}
					}
				}
			}
		}
		
		//�ҵ���Ӧ��ԭ���˻���Ϣ�������˻�������ͬ��ɾ�������򲻱�
		List<BusinessObject> newAccountList = loanChange.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		if(newAccountList != null)
		{
			for(BusinessObject bo:newAccountList)
			{		
				bo.setAttributeValue("status", "1");
				//�ҵ���Ӧ��ԭ���˻���Ϣ�������˻�������ͬ��ɾ�������򲻱�
				if(oldAccountList !=null)
				{
					for(BusinessObject boOld:oldAccountList)
					{
						if(bo.getString("ACCOUNTINDICATOR").equals(boOld.getString("ACCOUNTINDICATOR"))){
							boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete,boOld);
						}
					}
				}
				
				if(feeAccountList != null && !feeAccountList.isEmpty())
				{
					for(BusinessObject boOld: feeAccountList){
						if(bo.getString("ACCOUNTINDICATOR").equals(boOld.getString("ACCOUNTINDICATOR"))){
							boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete,boOld);
							BusinessObject newBo = new BusinessObject(bo.getObjectType(),boManager);
							newBo.setValue(bo);
							newBo.setAttributeValue("ObjectType", boOld.getString("ObjectType"));
							newBo.setAttributeValue("ObjectNo", boOld.getString("ObjectNo"));
							boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,newBo);
						}
					}
				}
								
				//�������¼�˻�����Ϊ��ִ�У����Ӵ����Ӧ�˻���Ϣ
				BusinessObject newBo = new BusinessObject(bo.getObjectType(),boManager);
				newBo.setValue(bo);
				newBo.setAttributeValue("ObjectType", loan.getObjectType());
				newBo.setAttributeValue("ObjectNo", loan.getObjectNo());
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,newBo);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,bo);
			}
		}
		
		return 1;
	}

}