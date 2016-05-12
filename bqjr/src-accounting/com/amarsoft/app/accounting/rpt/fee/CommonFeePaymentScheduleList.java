package com.amarsoft.app.accounting.rpt.fee;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;

public class CommonFeePaymentScheduleList {

	public static List<BusinessObject> createFeePaymentScheduleList(BusinessObject loan_T,BusinessObject fee_T,AbstractBusinessObjectManager bom) throws Exception {
		
		BusinessObject loan = loan_T.cloneObject();
		BusinessObject fee = fee_T.cloneObject();
		
		int x =0;
		ArrayList<BusinessObject> feepaymentScheduleList=new ArrayList<BusinessObject>();//新还款计划
		
		//计算还款期次，与还款计划脚本中计算方式一致
		ArrayList<BusinessObject> rptList = FeePSFunctions.getActiveRPTSegment(loan);
		int totalperiod = 0;
		for (BusinessObject rptSegment:rptList){
			int totalPeriodtmp =  RPTFunctions.getPeriodScript(loan, rptSegment).getTotalPeriod(loan, rptSegment);
			if(totalPeriodtmp > totalperiod)totalperiod = totalPeriodtmp;
			if("RPT33".equals(rptSegment.getString("RPTTermID"))){//hhcf,尾款不合并时加上最后一期
				totalperiod = rptSegment.getInt("TotalPeriod") + 1;
			}else{
				totalperiod = rptSegment.getInt("TotalPeriod");
			}
		}
		//double feeAmount = Arith.round(FeePSFunctions.calFeePSAmount(fee, loan, bom)/totalperiod,2);
		while(x < totalperiod)
		{
			x++;
			String nextDueDateTmp=LoanFunctions.getNextDueDate(loan);
			String nextDueDate = "";
			double feeAmount = 0d;
			//05为随还款计划收取
			if("05".equals(fee.getString("FeePayDateFlag")))
				feeAmount = Arith.round(FeePSFunctions.calFeePSAmount(x,fee, loan, bom)/totalperiod,2);
			else 
				feeAmount = Arith.round(FeePSFunctions.calFeePSAmount(x,fee, loan, bom),2);
			
			if(nextDueDate.equals("")) nextDueDate = nextDueDateTmp;
			
			loan.setAttributeValue("BusinessDate", nextDueDate);
			
			// 获取上次结息日，作为贷款的还款日
			String lastDueDate = LoanFunctions.getLastDueDate(loan);
			
			for (BusinessObject rptSegment:rptList){
				if(!nextDueDate.equals(rptSegment.getString("NextDueDate"))) continue;//不处理
				rptSegment.setAttributeValue("LastDueDate", nextDueDate);
				rptSegment.setAttributeValue("NextDueDate", RPTFunctions.getDueDateScript(loan, rptSegment).getNextPayDate(loan, rptSegment));
			}
			
			//一次收取，目前设置为BusinessDate
			if("01".equals(fee.getString("FeePayDateFlag"))||"02".equals(fee.getString("FeePayDateFlag"))||"03".equals(fee.getString("FeePayDateFlag")))
				nextDueDate = loan.getString("BusinessDate");
			

			if("01".equals(fee.getString("FeePayDateFlag")) && "0020".equals(fee.getString("TransCode"))){
				nextDueDate = loan.getString("PutOutDate");
			}
			if("A6".equals(fee.getString("FeeType"))){//佣金不产生在还款计划中
				break;
			}
			
			int currentPeriod = x;
			
			BusinessObject feepaymentSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,bom);
			
			feepaymentSchedule.setAttributeValue("ObjectType", fee.getObjectType());
			feepaymentSchedule.setAttributeValue("ObjectNo", fee.getString("SerialNo"));
			feepaymentSchedule.setAttributeValue("SeqID", currentPeriod);
			feepaymentSchedule.setAttributeValue("PayType", fee.getString("FeeType"));
			if("RPT18".equals(rptList.get(0).getString("RPTTermID"))){
				feepaymentSchedule.setAttributeValue("PayDate", lastDueDate);
			}else{
				feepaymentSchedule.setAttributeValue("PayDate", nextDueDate);
			}
			feepaymentSchedule.setAttributeValue("PayPrincipalAmt", feeAmount);
			feepaymentSchedule.setAttributeValue("AutoPayFlag", loan.getString("AutoPayFlag"));
			feepaymentSchedule.setAttributeValue("RelativeObjectType", loan.getObjectType());
			feepaymentSchedule.setAttributeValue("RelativeObjectNo", loan.getString("SerialNo"));
			feepaymentScheduleList.add(feepaymentSchedule);
			ARE.getLog().debug("SeqID="+feepaymentSchedule.getInt("SeqID")+";PayDate="+feepaymentSchedule.getString("PayDate")+";InstallmentAmt="+feeAmount
					+";principalAmount="+feeAmount+";interestAmount=0"
					+";PrincipalBalance=0");
			//一次性收取，则跳出循环
			if(!"05".equals(fee.getString("FeePayDateFlag")))break;
		}
		loan.setRelativeObjects(feepaymentScheduleList);
		return feepaymentScheduleList;
	}
	
}
