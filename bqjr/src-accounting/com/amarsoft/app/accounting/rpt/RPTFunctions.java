package com.amarsoft.app.accounting.rpt;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.rpt.due.CommonDueDateScript;
import com.amarsoft.app.accounting.rpt.due.CommonPeriodScript;
import com.amarsoft.app.accounting.rpt.due.IDueDateScript;
import com.amarsoft.app.accounting.rpt.due.IPeriodScript;
import com.amarsoft.app.accounting.rpt.pmt.IPMTScript;
import com.amarsoft.app.accounting.rpt.pmt.PMTScript5;
import com.amarsoft.app.accounting.rpt.ps.CommonPaymentScheduleScript;
import com.amarsoft.app.accounting.rpt.ps.IPaymentScheduleScript;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.PRODUCT_CONSTANTS;

public class RPTFunctions {

	public static double getOutStandingBalance(BusinessObject loan,BusinessObject rptSegment) throws Exception{
		String segRPTAmountFlag=rptSegment.getString("SegRPTAmountFlag");//区段金额标识
		if(segRPTAmountFlag==null||segRPTAmountFlag.length()==0)//组件中不配置时，默认本金余额
			segRPTAmountFlag="1";
		//计算本金余额  相关要素
		if("3".equals(segRPTAmountFlag)){//3-指定期还款额					
			return 0d;
		}
		else if("2".equals(segRPTAmountFlag)){// 2-指定归还本金金额
			return rptSegment.getDouble("SegRPTBalance");
		}
		else if("1".equals(segRPTAmountFlag)){// 1-本金余额
			return AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",
					ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
					ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		}else if("4".equals(segRPTAmountFlag)){// 4-尾款金额			
			return AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",
					ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
					ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay)
					- rptSegment.getDouble("SegRPTAmount");
		}
		else throw new Exception("贷款{"+loan.getObjectNo()+"}的还款属性SegRPTAmountFlag未定义！");
	}
	
	public static IPMTScript getPMTScript(BusinessObject loan,BusinessObject rptSegment) throws Exception{
		String className = RPTFunctions.getScriptClassName(loan, rptSegment, "PMTScript");
		if(className==null || "".equals(className))
			return new PMTScript5();
			//return null;
			//throw new DataException("组件{"+loan.getString("RPTTermID")+"}未找到参数{PMTScript}的定义！");
		Class<?> c = Class.forName(className);
		return (IPMTScript)c.newInstance();
	}
	
	public static IPeriodScript getPeriodScript(BusinessObject loan,BusinessObject rptSegment) throws Exception{
		String className = RPTFunctions.getScriptClassName(loan, rptSegment, "PeriodScript");
		if(className==null || "".equals(className))//为空赋默认值
			return new CommonPeriodScript();
		Class<?> c = Class.forName(className);
		return (IPeriodScript)c.newInstance();
	}
	
	public static IDueDateScript getDueDateScript(BusinessObject loan,BusinessObject rptSegment) throws Exception{
		String className = RPTFunctions.getScriptClassName(loan, rptSegment, "DueDateScript");
		if(className==null || "".equals(className))//为空赋默认值
			return new CommonDueDateScript();
		Class<?> c = Class.forName(className);
		return (IDueDateScript)c.newInstance();
	}
	
	public static IPaymentScheduleScript getPaymentScheduleScript(BusinessObject loan) throws Exception{
		String rptTermID = loan.getString("RPTTermID");
		String className = ProductConfig.getTermParameterAttribute(rptTermID, "PaymentScheduleScript", "DefaultValue");
		if(className==null || "".equals(className))//为空赋默认值
			return new CommonPaymentScheduleScript();
		Class<?> c = Class.forName(className);
		return (IPaymentScheduleScript)c.newInstance();
	}
	
	private static String getScriptClassName(BusinessObject loan,BusinessObject rptSegment,String scriptType) throws Exception{
		String termID=loan.getString("RPTTermID");
		String className = ProductConfig.getTermParameterAttribute(termID, scriptType, "DefaultValue");
		if(className==null || "".equals(className)){//默认首先取组件参数定义，如果未定义，则取Code_Library中CodeNo=PaymentMethod的属性
			String termID_T = rptSegment.getString("RPTTermID");
			className = ProductConfig.getTermParameterAttribute(termID_T, scriptType, "DefaultValue");
		}
		return className;
	}

	/**
	 * 针对还款方式是根据指定归还本金金额类型获得贷款余额 当前区段的本金余额通过利用贷款客户账本金余额减去未来各还款区段的区段本金金额
	 * 如果最终金额小于0，则返回0 对于最后一段还款方式，贷款的余额为客户账中的正常本金余额
	 * 
	 * @param loan
	 * @param rptSegment
	 * @return
	 * @throws Exception
	 */
	private static double getSegRPTBalance(BusinessObject loan, BusinessObject rptSegment) throws Exception {
		List<BusinessObject> rptSegmentList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		String beginDate = rptSegment.getString("SegFromDate");
		if (beginDate == null || beginDate.length() == 0) {
			beginDate = loan.getString("BusinessDate");
		}
		double balance = AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",
				ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,
				ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		if (rptSegmentList == null || rptSegmentList.size() == 0)
			return 0.0d;
		for (BusinessObject rpt : rptSegmentList) {
			if (!rpt.getString("SegRPTAmountFlag").equals(PRODUCT_CONSTANTS.SEGRPTAMOUNT_SEG_AMT))
				continue;
			String segFromDate = rpt.getString("SegFromDate");
			if (segFromDate != null && segFromDate.length() > 0 && segFromDate.compareTo(beginDate) <= 0)
				continue;
			String segToDate = rpt.getString("SegToDate");
			if (segToDate != null && segToDate.length() > 0 && segToDate.compareTo(beginDate) <= 0)
				continue;
			balance = balance - rpt.getDouble("SegRPTBalance");
		}
		if (balance < 0.0d)
			return 0.0d;
		else
			return balance;
	}

	/**
	 * 该方法判断当前结息日期是否为还息日期
	 * 
	 * @param loan
	 * @param settleDate
	 * @return boolean
	 * @throws Exception
	 */
	public static boolean getPayInterestFlag(BusinessObject loan, String settleDate) throws Exception {
		if (settleDate == null || settleDate.equals(""))
			throw new Exception("结息日期为空，请确认！");
		boolean flag_Interest = true;
		List<BusinessObject> rptSegmentList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		//Assertions.notEmpty(loan.getObjectNo(), rptSegmentList, "还款方式组件为空，请重新加载！");
		String nextDueDate = null;
		String paymentMethod = null;
		for (BusinessObject rptSegment : rptSegmentList) {
			nextDueDate = rptSegment.getString("NextDueDate");
			paymentMethod = rptSegment.getString("PaymentMethod");
			if (!nextDueDate.equals(settleDate))
				continue;
			if (!PRODUCT_CONSTANTS.Payment_Type_PayPrincipalAmt.equals(paymentMethod) && settleDate.equals(nextDueDate)) {
				flag_Interest = true;
				break;
			}
			if (PRODUCT_CONSTANTS.Payment_Type_PayPrincipalAmt.equals(paymentMethod) && settleDate.equals(nextDueDate)) {
				flag_Interest = false;
			}
		}
		return flag_Interest;
	}
}
