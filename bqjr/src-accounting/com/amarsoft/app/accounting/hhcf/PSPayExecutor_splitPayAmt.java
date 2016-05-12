package com.amarsoft.app.accounting.hhcf;

//还款，整合提前还款
//华亨财富修正
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;
import com.amarsoft.dict.als.cache.CodeCache;

public class PSPayExecutor_splitPayAmt implements ITransactionExecutor{
	
	private ITransactionScript transactionScript;
	
	private HashMap<String,BusinessObject> paymentLogList=new HashMap<String,BusinessObject>();

	private BusinessObject transaction;

	private AbstractBusinessObjectManager boManager;

	private BusinessObject loan;

	private BusinessObject paymentBill;

	private String transDate;
	
	public static String[][] paymentBillAttributeMapping={
		{"ActualPayPrincipalAmt","1,ActualPayPrincipalAmt"},
		{"ActualPayInteAmt","1,ActualPayInteAmt,ActualGraceInteAmt"},
		
		{"ActualPayFineAmt","1,ActualPayFineAmt"},
		{"ActualPayCompdInteAmt","1,ActualPayCompdInteAmt"},
	};
	
	public static String[][] paymentScheduleAttributes={
		{"PayPrincipalAmt","ActualPayPrincipalAmt"},
		{"PayInteAmt","ActualPayInteAmt"},
		{"PayGraceInteAmt","ActualPayGraceInteAmt"},
		{"PayFineAmt","ActualPayFineAmt"},
		{"PayCompdInteAmt","ActualPayCompdInteAmt"},
		
	};
	
	private void setPaymentLog(BusinessObject paymentSchedule,double payAmt,double actualPayAmt,String payAmtAttribute,String actualPayAmtAttribute) throws Exception{
		BusinessObject paymentLog = paymentLogList.get(paymentSchedule.getString("SerialNo"));
		if(paymentLog==null) {
			paymentLog=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.PaymentLog,boManager);
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,paymentLog);
			loan.setRelativeObject(paymentLog);
			transaction.setRelativeObject(paymentLog);
			paymentLogList.put(paymentSchedule.getString("SerialNo"), paymentLog);
			
			paymentLog.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));
			paymentLog.setAttributeValue("PSSerialNo", paymentSchedule.getString("SerialNo"));
			paymentLog.setAttributeValue("PayDate", paymentSchedule.getString("PayDate"));
			//paymentLog.setAttributeValue("ActualPayDate", transaction.getString("TransDate"));
			paymentLog.setAttributeValue("ActualPayDate", SystemConfig.getBusinessDate());
			paymentLog.setAttributeValue("LoanSerialNo", loan.getString("SerialNo"));
			
		}
		paymentLog.setAttributeValue(payAmtAttribute, payAmt);
		paymentLog.setAttributeValue(actualPayAmtAttribute, actualPayAmt);
	}
	//HHCF
	private void setFeePaymentLog(BusinessObject paymentSchedule,double payAmt,double actualPayAmt,String payAmtAttribute,String actualPayAmtAttribute,BusinessObject fee) throws Exception{
		BusinessObject paymentLog = paymentLogList.get(paymentSchedule.getString("SerialNo"));
		if(paymentLog==null) {
			paymentLog=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.PaymentLog,boManager);
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,paymentLog);
			fee.setRelativeObject(paymentLog);
			transaction.setRelativeObject(paymentLog);
			paymentLogList.put(paymentSchedule.getString("SerialNo"), paymentLog);
			
			paymentLog.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));
			paymentLog.setAttributeValue("PSSerialNo", paymentSchedule.getString("SerialNo"));
			paymentLog.setAttributeValue("PayDate", paymentSchedule.getString("PayDate"));
			//paymentLog.setAttributeValue("ActualPayDate", transaction.getString("TransDate"));
			paymentLog.setAttributeValue("ActualPayDate", SystemConfig.getBusinessDate());
			paymentLog.setAttributeValue("LoanSerialNo", fee.getString("SerialNo"));
			
		}
		paymentLog.setAttributeValue(payAmtAttribute, payAmt);
		paymentLog.setAttributeValue(actualPayAmtAttribute, actualPayAmt);
	}
	
	private double split(double actualPayAmt,String amtOrder,List<BusinessObject> paymentScheduleList) throws Exception{
		String[] payOrder = amtOrder.split(",");
		String payType = payOrder[0];
		String payAmtAttribute = payOrder[2];
		String actualPayAmtAttribute = payOrder[3];
		if(payOrder.length<4) throw new DataException("还款顺序定义不正确！");
		
		for(BusinessObject paymentSchedule:paymentScheduleList){
			if(actualPayAmt<=0d) break;
			if(!payType.equals(paymentSchedule.getString("PayType"))) continue;
			String payDate = paymentSchedule.getString("PayDate");
			if(transDate.compareTo(payDate)<0) continue;
			//hhcf
			if("0055".equals(transaction.getString("TransCode"))&&transaction.getString("TransDate").equals(payDate)) continue;
			
			//应还-实还
			double payAmt=Arith.round(paymentSchedule.getDouble(payAmtAttribute)-paymentSchedule.getDouble(actualPayAmtAttribute),2);
			if(payAmt<=0d) continue;
			double a=0d;
			if(actualPayAmt>=payAmt) {
				a=payAmt;
				actualPayAmt=actualPayAmt-payAmt;
			}
			else if(actualPayAmt<payAmt){
				a= actualPayAmt;
				actualPayAmt=0d;
			}
			this.setPaymentLog(paymentSchedule, payAmt, a, payAmtAttribute, actualPayAmtAttribute);
		}
		return actualPayAmt;
	}
	
	private double splitfee(double actualPayAmt,String amtOrder,List<BusinessObject> paymentScheduleList,BusinessObject fee) throws Exception{
		String[] payOrder = amtOrder.split(",");
		//String payType = payOrder[0];
		String payAmtAttribute = payOrder[3];
		String actualPayAmtAttribute = payOrder[4];
		if(payOrder.length<5) throw new DataException("还款顺序定义不正确！");
		
		for(BusinessObject paymentSchedule:paymentScheduleList){
			if(actualPayAmt<=0d) break;
			//if(!payType.equals(paymentSchedule.getString("PayType"))) continue;
			String payDate = paymentSchedule.getString("PayDate");
			if(transDate.compareTo(payDate)<0) continue;
			//hhcf
			if("0055".equals(transaction.getString("TransCode"))&&transaction.getString("TransDate").equals(payDate)) continue;
			
			//应还-实还
			double payAmt=Arith.round(paymentSchedule.getDouble(payAmtAttribute)-paymentSchedule.getDouble(actualPayAmtAttribute),2);
			if(payAmt<=0d) continue;
			double a=0d;
			if(actualPayAmt>=payAmt) {
				a=payAmt;
				actualPayAmt=actualPayAmt-payAmt;
			}
			else if(actualPayAmt<payAmt){
				a= actualPayAmt;
				actualPayAmt=0d;
			}
			this.setFeePaymentLog(paymentSchedule, payAmt, a, payAmtAttribute, actualPayAmtAttribute,fee);
		}
		return actualPayAmt;
	}
	
	private void horizontalSplit(String[] amtOrderArray) throws Exception{
		double actualPayAmt= paymentBill.getDouble("ActualPayAmt");//还款金额
		String transDate = transaction.getString("TransDate");
		
		List<BusinessObject> paymentScheduleList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		ArrayList<String> payDateList = new ArrayList<String>();
		HashMap<String,List<BusinessObject>> r = new HashMap<String,List<BusinessObject>>();
		for(BusinessObject paymentSchedule:paymentScheduleList){
			String payDate = paymentSchedule.getString("PayDate");
			if(transDate.compareTo(paymentSchedule.getString("PayDate"))<0) continue;
			
			List<BusinessObject> l = r.get(payDate);
			if(l==null) { 
				l=new ArrayList<BusinessObject>();
				r.put(payDate, l);
				payDateList.add(payDate);
			}
			l.add(paymentSchedule);
		}
		
		for(String payDate:payDateList){
			if(actualPayAmt<=0d) break;
			List<BusinessObject> psList = r.get(payDate);
			if(psList==null||psList.isEmpty()) continue;
			for(String amtOrder:amtOrderArray){
				if(actualPayAmt<=0d) break;
				actualPayAmt = this.split(actualPayAmt, amtOrder, psList);
			}
		}
		if(actualPayAmt > 0)
			this.paymentBill.setAttributeValue("PrepayAmount", actualPayAmt);
	}
	
	private void verticalSplit(String[] amtOrderArray) throws Exception{
		double actualPayAmt= paymentBill.getDouble("ActualPayAmt");//还款金额
		List<BusinessObject> paymentScheduleList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		List<BusinessObject> feepaymentScheduleList = null;
		for(String amtOrder:amtOrderArray){
			if(actualPayAmt<=0d) break;
			String[] payOrder = amtOrder.split(",");
			String ObType = payOrder[1];
			if(ObType.equals("Loan"))
				actualPayAmt = this.split(actualPayAmt, amtOrder, paymentScheduleList);//正常贷款处理
			else if (ObType.equals("Fee")){//费用处理，根据组件编号获取费用记录，进而获取费用还款计划。
				String FeeTerm = payOrder[2];
				List<BusinessObject> feeList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
				if(feeList==null || feeList.size() == 0) {
					ARE.getLog().warn("贷款【"+loan.getObjectNo()+"】费用记录为空！");
					continue;
				}
				//if(feeList.size() ==0)throw  new DataException("feeList是空！");
				//String termID = "";
				//BusinessObject Fee = null;
				for(BusinessObject fee:feeList)
				{
					//termID = fee.getString("FeeTermId");
					if(fee.getString("FeeType").equals(FeeTerm)){
						//Fee = fee;
						feepaymentScheduleList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
						actualPayAmt = this.splitfee(actualPayAmt, amtOrder, feepaymentScheduleList,fee);
						//break;
					}
					else continue;
					//else termID = "";
				}
				//if(termID.equals("")||Fee == null)continue;
				/*feepaymentScheduleList = Fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
				actualPayAmt = this.splitfee(actualPayAmt, amtOrder, feepaymentScheduleList,Fee);*/
				
			}
			else
				throw new DataException("还款顺序定义错误！");
		}
	}
	
	private void manualSplit() throws Exception{
		String payType=ACCOUNT_CONSTANTS.PAYTYPE_NOMAL;
		List<BusinessObject> paymentScheduleList=PaymentScheduleFunctions.getPassDuePaymentScheduleList(loan, payType);
		double actualPayAmt= paymentBill.getDouble("ActualPayPrincipalAmt");//还本金额
		this.split(actualPayAmt, payType+",PayPrincipalAmt,ActualPayPrincipalAmt", paymentScheduleList);
		actualPayAmt= paymentBill.getDouble("ActualPayInteAmt");//还利息金额
		actualPayAmt = this.split(actualPayAmt, payType+",PayInteAmt,ActualPayInteAmt", paymentScheduleList);
		actualPayAmt = this.split(actualPayAmt, payType+",PayGraceInteAmt,ActualPayGraceInteAmt", paymentScheduleList);
		
		actualPayAmt= paymentBill.getDouble("ActualPayFineAmt");//还本金罚息金额
		this.split(actualPayAmt, payType+",PayFineAmt,ActualPayFineAmt", paymentScheduleList);
		
		actualPayAmt= paymentBill.getDouble("ActualPayCompdInteAmt");//还利息罚息金额
		this.split(actualPayAmt, payType+",PayCompdInteAmt,ActualPayCompdInteAmt", paymentScheduleList);
	}
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript =transactionScript;
		this.transaction = this.transactionScript.getTransaction();
		this.boManager = transactionScript.getBOManager();
		this.loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		this.paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		transDate = transaction.getString("TransDate");
		
		//更新单据状态
		paymentBill.setAttributeValue("Status", "1");
		//paymentBill.setAttributeValue("ActualPayDate", transaction.getString("TransDate"));//更新单据实还日期
		paymentBill.setAttributeValue("ActualPayDate", SystemConfig.getBusinessDate());//更新单据实还日期
		
		double prePayAmt = paymentBill.getMoney("PrepayAmount");
		double actualPayAmt = 0.0;
		if(prePayAmt > 0){
			actualPayAmt += prePayAmt;
			List<BusinessObject> psList = PaymentScheduleFunctions.getPassDuePaymentScheduleList(loan, ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
			for(BusinessObject a:psList){
				for(int i=0;i<paymentScheduleAttributes.length;i++){
					actualPayAmt += a.getMoney(paymentScheduleAttributes[i][0]);
				}
			}
			paymentBill.setAttributeValue("ActualPayAmt", actualPayAmt);
		}
		
		
		
		//初始化金额为零
		for(String[] s:paymentBillAttributeMapping){
			if(paymentBill.getDouble(s[0])==0d)	paymentBill.setAttributeValue(s[0], 0d);
		}
		
		String seqFlag=paymentBill.getString("SeqFlag");//10不良还款顺序20正常还款顺序
		if(seqFlag==null||seqFlag.length()==0){
				seqFlag=ACCOUNT_CONSTANTS.PS_SEQ_FLAG_NORMAL;
		}
		
		//获取还款顺序定义/拆分并计算各项还款金额，并更新还款计划
		String payorders = CodeCache.getItem("SeqFlag",seqFlag).getItemDescribe();
		if(payorders == null || "".equals(payorders)) throw new LoanException("无效的还款顺序，请检查！");
		String payOrder=payorders.substring(0,payorders.indexOf("@"));
		String[] amtOrderArray = payorders.substring(payorders.indexOf("@")+1).trim().split("@");
		if(ACCOUNT_CONSTANTS.PS_SEG_TYPE_AMTTYPE.equals(payOrder)){//金额类型优先的还款顺序
			//先将实还更新为0
			paymentBill.setAttributeValue("ActualPayODPrincipalAmt", 0d);
			paymentBill.setAttributeValue("ActualPayPrincipalAmt", 0d);
			paymentBill.setAttributeValue("ActualPayODInteAmt", 0d);
			paymentBill.setAttributeValue("ActualPayInteAmt", 0d);
			paymentBill.setAttributeValue("ActualPayFineAmt", 0d);
			paymentBill.setAttributeValue("ActualPayCompdInteAmt", 0d);
			this.verticalSplit(amtOrderArray);
		}
		else if(ACCOUNT_CONSTANTS.PS_SEG_TYPE_TERM.equals(payOrder)){//期次优先的还款顺序
			//先将实还更新为0
			paymentBill.setAttributeValue("ActualPayODPrincipalAmt", 0d);
			paymentBill.setAttributeValue("ActualPayPrincipalAmt", 0d);
			paymentBill.setAttributeValue("ActualPayODInteAmt", 0d);
			paymentBill.setAttributeValue("ActualPayInteAmt", 0d);
			paymentBill.setAttributeValue("ActualPayFineAmt", 0d);
			paymentBill.setAttributeValue("ActualPayCompdInteAmt", 0d);
			this.horizontalSplit(amtOrderArray);
		}
		//华亨财富
		else if("4".equals(payOrder)){//流动资金测试
			//先将实还更新为0
			paymentBill.setAttributeValue("ActualPayODPrincipalAmt", 0d);
			paymentBill.setAttributeValue("ActualPayPrincipalAmt", 0d);
			paymentBill.setAttributeValue("ActualPayODInteAmt", 0d);
			paymentBill.setAttributeValue("ActualPayInteAmt", 0d);
			paymentBill.setAttributeValue("ActualPayFineAmt", 0d);
			paymentBill.setAttributeValue("ActualPayCompdInteAmt", 0d);
			this.verticalSplit(amtOrderArray);
		}
		//
		else if(ACCOUNT_CONSTANTS.PS_SEG_TYPE_FIXAMT.equals(payOrder)){//指定金额还款
			this.manualSplit();
		}
		else{
			throw new Exception("无效的还款顺序，请检查！");
		}
		
		//依据生成的PaymentLog更新还款计划
		for(BusinessObject paymentLog:paymentLogList.values()){
			//正常还款计划
			if(loan.getString("SerialNo").equals(paymentLog.getString("LoanSerialNo")))
			{
				BusinessObject paymentSchedule 
					= loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule, paymentLog.getString("PSSerialNo"));
				for(String[] s:paymentScheduleAttributes){
					double amount = paymentLog.getDouble(s[1]);
					if(amount<=0) continue;
					paymentSchedule.setAttributeValue(s[1], Arith.round(paymentSchedule.getDouble(s[1])+amount,2));
					if(transDate.equals(paymentSchedule.getString("PayDate"))){
						paymentBill.setAttributeValue(s[1], Arith.round(paymentBill.getDouble(s[1])+amount,2));
					}
					else{
						if(s[1].equals("ActualPayPrincipalAmt"))
							paymentBill.setAttributeValue("ActualPayODPrincipalAmt", Arith.round(paymentBill.getDouble("ActualPayODPrincipalAmt")+amount,2));
						else if(s[1].equals("ActualPayInteAmt"))
							paymentBill.setAttributeValue("ActualPayODInteAmt", Arith.round(paymentBill.getDouble("ActualPayODInteAmt")+amount,2));
						else{}
					}
				}	
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,paymentSchedule);
			}	
			//费用还款计划
			else{
				List<BusinessObject> feeList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
				for(BusinessObject fee:feeList){
					BusinessObject feepaymentSchedule 
						= fee.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule, paymentLog.getString("PSSerialNo"));
					if(feepaymentSchedule == null)continue;
					for(String[] s:paymentScheduleAttributes){
						double amount = paymentLog.getDouble(s[1]);
						if(amount<=0) continue;
						feepaymentSchedule.setAttributeValue(s[1], Arith.round(feepaymentSchedule.getDouble(s[1])+amount,2));
						//更新费用中的实收费用
						fee.setAttributeValue("ActualReceiveAmount", fee.getDouble("ActualReceiveAmount")+amount);
					}
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,feepaymentSchedule);
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,fee);
				}
			}
		}
		return 1;
	}
}