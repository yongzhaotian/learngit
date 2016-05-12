package com.amarsoft.app.accounting.trans.script.loan.eod;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.dict.als.cache.CodeCache;

public class DelayFineExecutor implements ITransactionExecutor {
	//滞纳金处理
	@Override
	public int execute(String scriptID, ITransactionScript transactionScript)
			throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));

		List<BusinessObject> paymentScheduleList = loan .getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		String businessdate = transaction.getString("TransDate");
		String feeType = "A10";//滞纳金费用代码
		int seqID = 9999;
		BusinessObject FeePS = null;
		//从还款计划中获取最早逾期的那一期的应还日期
		for(BusinessObject paymentSchedule:paymentScheduleList){
			String payDate = paymentSchedule.getString("PayDate");
			if(payDate.compareTo(businessdate)>=0)continue;
			else{
				int seqId = paymentSchedule.getInt("SeqID");
				if(seqId<seqID)seqID = seqId;
				FeePS = paymentSchedule;
			}
		}
		if(seqID == 9999)return 1;
		String ODdate = FeePS.getString("PayDate");
		int days = DateFunctions.getDays(ODdate, businessdate);
		//通过代码表获取滞纳金收取时点和金额信息
		String payorders = CodeCache.getItem("DelayFine","01").getItemDescribe();
		if(payorders == null || "".equals(payorders)) throw new LoanException("无效的滞纳金相关信息，请检查！");
		String[] amtOrderArray = payorders.substring(payorders.indexOf("@")+1).trim().split("@");
		int i = 0;//用来表示具体某一期的滞纳金（如30天为第一期，60天为第二期等等）
		for(String amtOrder:amtOrderArray){
			i++;
			String[] rules = amtOrder.split(",");
			String ruleDate = rules[0];
			String addAmount = rules[1];
			if(days >= Integer.parseInt(ruleDate))//转换并比较当前逾期天数与代码中配置的天数
			{
				//判断当前天数对应的fee记录和还款计划记录是否生成,如尚未生成则调用相关逻辑生成fee和ps记录
				int isChecked = ischecked(loan,feeType,ruleDate,i);
				if(isChecked == 0){
					addFeeandPS(loan,feeType,ruleDate,addAmount,businessdate,boManager,i);
				}
				else continue;
			}
			else break;
		}
		
		
		return 1;
	}
	//根据当前滞纳金的信息判断是否存在应附加记录
		private int ischecked(BusinessObject loan, String feeType, String ruleDate, int i) throws Exception {
			
			List<BusinessObject> feeList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
			for(BusinessObject fee:feeList){
				String feeTypeNew = fee.getString("FeeType");
				if(feeType.equals(feeTypeNew)){
					List<BusinessObject> feePSList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
					for(BusinessObject feePS:feePSList){
						int seqID = feePS.getInt("SeqID");
						if(i == seqID)return 1;
						else continue;
					}
					break;
				}
				else continue;
			}
			return 0;
		}

		private void addFeeandPS(BusinessObject loan, String feeType, String ruleDate, String addAmount, String businessdate, AbstractBusinessObjectManager boManager, int i) throws Exception {
			//判定是否需要新增费用
			List<BusinessObject> feeList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
			BusinessObject dffee = null;
			for(BusinessObject fee:feeList){
				String feeTypeNew = fee.getString("FeeType");
				if(feeType.equals(feeTypeNew)){
					dffee = fee;
					break;
				}
				else continue;
			}
			if(dffee == null){//若滞纳金记录为空，新增费用记录
				dffee = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee,boManager);
				dffee.setAttributeValue("ObjectNo", loan.getObjectNo());
				dffee.setAttributeValue("ObjectType", loan.getObjectType());
				dffee.setAttributeValue("FeeType", "A10");
				dffee.setAttributeValue("FeeTermID", "");//滞纳金组件编号？
				dffee.setAttributeValue("Currency", "01");
				dffee.setAttributeValue("Amount", Double.parseDouble(addAmount));
				dffee.setAttributeValue("FeeFlag", "R");
				dffee.setAttributeValue("FeeCalType", "01");
				dffee.setAttributeValue("FeeFrequency", "3");
				dffee.setAttributeValue("FeePayDateFlag", "03");
				dffee.setAttributeValue("Status", "1");
				dffee.setAttributeValue("TransCode", "9091");
				loan.setRelativeObject(dffee);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, dffee);
			}
			else{
				dffee.setAttributeValue("Amount", dffee.getDouble("Amount")+Double.parseDouble(addAmount));
				dffee.setAttributeValue("TotalAmount", dffee.getDouble("TotalAmount")+Double.parseDouble(addAmount));
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, dffee);
			}
			BusinessObject feepS = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,boManager);
			
			feepS.setAttributeValue("ObjectType", dffee.getObjectType());
			feepS.setAttributeValue("ObjectNo", dffee.getString("SerialNo"));
			feepS.setAttributeValue("SeqID", i);
			feepS.setAttributeValue("PayType", dffee.getString("FeeType"));
			feepS.setAttributeValue("PayDate", businessdate);
			feepS.setAttributeValue("PayIntAmt", Integer.parseInt(addAmount));
			feepS.setAttributeValue("AutoPayFlag", loan.getString("AutoPayFlag"));
			feepS.setAttributeValue("RelativeObjectType", loan.getObjectType());
			feepS.setAttributeValue("RelativeObjectNo", loan.getString("SerialNo"));
			dffee.setRelativeObject(feepS);
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, feepS);
		}
}
