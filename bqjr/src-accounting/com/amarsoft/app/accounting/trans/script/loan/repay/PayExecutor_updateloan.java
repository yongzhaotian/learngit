package com.amarsoft.app.accounting.trans.script.loan.repay;

//还款，整合提前还款
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
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
	

		String prepayType = paymentBill.getString("PrepayType");//提前还款方式标志：10 全部提前还款；11 部分提前还款-期限不变；12 部分提前还款-期供不变
		if(prepayType!=null&&prepayType.equals(ACCOUNT_CONSTANTS.PrepaymentType_Part_FixInstalment)){
			ArrayList<BusinessObject> t = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			loan.setAttributeValue("MaturityDate", t.get(t.size()-1).getString("PayDate"));
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
			
			ArrayList<BusinessObject> rptList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
			if(rptList==null||rptList.isEmpty())  throw new Exception("未找到贷款{"+loan.getObjectNo()+"}有效的还款定义!");
			for (BusinessObject rptSegment:rptList){
				if(rptSegment.getString("Status").equals("1")){
					if(prepayType.equals(ACCOUNT_CONSTANTS.PrepaymentType_Part_FixInstalment) && rptSegment.getInt("SEGTERM") >=0){//计算还款计划时，强制不重算期供
						int SCTerm = RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);//剩余期次
						if(SCTerm-1<0) SCTerm=1;
						int totalTerm = loan.getInt("CurrentPeriod")+SCTerm;//总期次
						rptSegment.setAttributeValue("SEGTERM", totalTerm);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,rptSegment);
					}								
				}
			}
		}
		return 1;
	}

}