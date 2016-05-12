package com.amarsoft.app.accounting.trans.script.loan.repay;

//���������ǰ����
import java.util.ArrayList;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;

public class PayExecutor_updateloan implements ITransactionExecutor{
	

	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
	

		String prepayType = paymentBill.getString("PrepayType");//��ǰ���ʽ��־��10 ȫ����ǰ���11 ������ǰ����-���޲��䣻12 ������ǰ����-�ڹ�����
		if(prepayType!=null&&prepayType.equals(ACCOUNT_CONSTANTS.PrepaymentType_Part_FixInstalment)){
			ArrayList<BusinessObject> t = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			loan.setAttributeValue("MaturityDate", t.get(t.size()-1).getString("PayDate"));
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
			
			ArrayList<BusinessObject> rptList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
			if(rptList==null||rptList.isEmpty())  throw new Exception("δ�ҵ�����{"+loan.getObjectNo()+"}��Ч�Ļ����!");
			for (BusinessObject rptSegment:rptList){
				if(rptSegment.getString("Status").equals("1")){
					if(prepayType.equals(ACCOUNT_CONSTANTS.PrepaymentType_Part_FixInstalment) && rptSegment.getInt("SEGTERM") >=0){//���㻹��ƻ�ʱ��ǿ�Ʋ������ڹ�
						int SCTerm = RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);//ʣ���ڴ�
						if(SCTerm-1<0) SCTerm=1;
						int totalTerm = loan.getInt("CurrentPeriod")+SCTerm;//���ڴ�
						rptSegment.setAttributeValue("SEGTERM", totalTerm);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,rptSegment);
					}								
				}
			}
		}
		return 1;
	}

}