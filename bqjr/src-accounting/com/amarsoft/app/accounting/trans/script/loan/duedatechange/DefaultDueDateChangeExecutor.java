package com.amarsoft.app.accounting.trans.script.loan.duedatechange;

//���������ǰ����
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.util.ASValuePool;

public class DefaultDueDateChangeExecutor implements ITransactionExecutor{
	
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//ȡLoan����
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		String newPayDate = loanChange.getString("DefaultDueDay");//�»�����
		if(newPayDate==null || "".equals(newPayDate))
			throw new Exception("û���µĻ����գ�����!");
		if(newPayDate.length()<2)newPayDate="0"+newPayDate;
		//ȡ����Ļ�����Ϣ
		ArrayList<BusinessObject> rptSegmentList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		if(rptSegmentList==null||rptSegmentList.isEmpty())  throw new Exception("δ�ҵ�����{"+loan.getObjectNo()+"}��Ч�Ļ����!");
		
		//�����´λ�����
		for (BusinessObject rptSegment:rptSegmentList){
			if(!"1".equals(rptSegment.getString("Status"))) continue;
			loanChange.setAttributeValue("OLDDefaultDueDay",rptSegment.getString("DefaultDueDay"));
			rptSegment.setAttributeValue("DefaultDueDay", newPayDate);
			String segFromDate = rptSegment.getString("SegFromDate");
			if(segFromDate!=null&&segFromDate.length()>0&&segFromDate.compareTo(loan.getString("BusinessDate"))>0)
				continue;
			String segToDate = rptSegment.getString("SegToDate");
			if(segToDate!=null&&segToDate.length()>0&&segToDate.compareTo(loan.getString("BusinessDate"))<0)
				continue;
			
			String newNextDueDate=RPTFunctions.getDueDateScript(loan, rptSegment).getNextPayDate(loan,rptSegment);
			int i = 0;
			while(newNextDueDate.compareTo(transaction.getString("TransDate")) <= 0)
			{
				BusinessObject rptSegmentTemp = rptSegment.cloneObject();
				rptSegmentTemp.setAttributeValue("LastDueDate", newNextDueDate);
				newNextDueDate=RPTFunctions.getDueDateScript(loan, rptSegmentTemp).getNextPayDate(loan,rptSegmentTemp);
				i++;
				if(i > 100) break;
			}
			if(newNextDueDate.compareTo(transaction.getString("TransDate"))>0){
				rptSegment.setAttributeValue("nextDueDate", newNextDueDate);
			}
			else
				throw new Exception("�������ڲ��ܴ��ڱ������´λ����գ���ȷ�ϱ����Ч���ڣ�");
			rptSegment.setAttributeValue("UpdateInstalAmtFlag", "0");
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,rptSegment);
		}

		loan.setAttributeValue("UPDATEPMTSCHDFLAG", "1");//�������ɻ���ƻ�
		loan.setAttributeValue("UpdateInstalAmtFlag", "0");//�������ڹ�
		
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
		
		//���ط��õĻ���ƻ���Ϣ
		ASValuePool as = new ASValuePool();
		as.setAttribute("RelativeObjectType", loan.getObjectType());
		as.setAttribute("RelativeObjectNo", loan.getObjectNo());
		
		//����Loan����ƻ�
		String sBusinessDate = SystemConfig.getBusinessDate();
		List<BusinessObject> FeePaymentScheduleList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule, "RelativeObjectType=:RelativeObjectType and RelativeObjectNo=:RelativeObjectNo and finishdate is null order by paydate",as);
		if(FeePaymentScheduleList!=null && !FeePaymentScheduleList.isEmpty()){
			for(BusinessObject FeePS:FeePaymentScheduleList){
				if(DateFunctions.getDays(FeePS.getString("paydate"), sBusinessDate)>=0 ) continue;
				FeePS.setAttributeValue("paydate", FeePS.getString("paydate").substring(0, 7)+"/"+newPayDate);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,FeePS);
			}
		}
		return 1;
	}

}