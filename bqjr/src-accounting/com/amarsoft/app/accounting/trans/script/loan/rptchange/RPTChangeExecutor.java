package com.amarsoft.app.accounting.trans.script.loan.rptchange;

//还款，整合提前还款
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.product.ProductManage;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.rpt.pmt.IPMTScript;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.LoanFunctions;

public class RPTChangeExecutor implements ITransactionExecutor{
	
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//取Loan对象
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		List<BusinessObject> rptList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		List<BusinessObject> newRPTList = loanChange.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		
		//还款方式变更记账时把新的还款方式放入Loan
		loan.setAttributeValue("RPTTermID", loanChange.getString("RPTTermID"));
		loan.setAttributeValue("UpdateInstalAmtFlag", "1");//更新期供标示----loan中没有该字段
		loan.setAttributeValue("UpdatePMTSchdFlag", "1");//还款计划更新标识
		
		
		String businessDate = loan.getString("BusinessDate");
		String lastDueDate=LoanFunctions.getLastDueDate(loan);
		
		//取贷款原还款定义信息
		List<BusinessObject> removeRPTList = new ArrayList<BusinessObject>();
		for(BusinessObject rptSegment : rptList){
			String status = rptSegment.getString("Status");
			if(status.equals("1") || status.equals("3")){
				rptSegment.setAttributeValue("Status", "2");
				rptSegment.setAttributeValue("SegToDate", businessDate);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,rptSegment);
				removeRPTList.add(rptSegment);
			}
		}
		loan.removeRelativeObject(removeRPTList);
		
		ProductManage pm = new ProductManage(boManager.getSqlca());
		pm.initSegTermDate(lastDueDate, "", DateFunctions.TERM_UNIT_MONTH, 1, newRPTList);
		
		for(BusinessObject rptSegment : newRPTList){
			//新建对象并将变更对象值赋予新对象
			BusinessObject newRPTSegment = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment,boManager);
			newRPTSegment.setValue(rptSegment);
			newRPTSegment.setAttributeValue("Status", "1");
			newRPTSegment.setAttributeValue("ObjectNo", loan.getObjectNo());
			newRPTSegment.setAttributeValue("ObjectType", loan.getObjectType());
			if(newRPTSegment.getString("SegFromDate") == null || "".equals(newRPTSegment.getString("SegFromDate")))
			{
				newRPTSegment.setAttributeValue("SegFromDate",lastDueDate);
				newRPTSegment.setAttributeValue("LastDueDate", lastDueDate);
			}
			else
			{
				newRPTSegment.setAttributeValue("LastDueDate", newRPTSegment.getString("SegFromDate"));
			}
			
			loan.setRelativeObject(newRPTSegment);
			
			String nextDueDate=RPTFunctions.getDueDateScript(loan, newRPTSegment).getNextPayDate(loan, newRPTSegment);
			
			IPMTScript pmtScript = RPTFunctions.getPMTScript(loan, newRPTSegment);
			while(nextDueDate.compareTo(loan.getString("BusinessDate"))<=0&&nextDueDate.compareTo(loan.getString("MaturityDate"))<0){
				pmtScript.nextInstalment(loan,newRPTSegment);
				nextDueDate=newRPTSegment.getString("NextDueDate");
			}
			newRPTSegment.setAttributeValue("NextDueDate", nextDueDate);
			int t=RPTFunctions.getPeriodScript(loan, newRPTSegment).getTotalPeriod(loan,newRPTSegment);
			newRPTSegment.setAttributeValue("TotalPeriod", t);
			double instalmentAmount=pmtScript.getInstalmentAmount(loan,newRPTSegment);
			newRPTSegment.setAttributeValue("SegInstalmentAmt", instalmentAmount);
			newRPTSegment.setAttributeValue("SegRPTBalance", newRPTSegment.getDouble("SegRPTAmount"));
			loan.setRelativeObject(newRPTSegment);
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,newRPTSegment);
		}
	
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loanChange);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
		
		return 1;
	}

}