package com.amarsoft.app.accounting.trans.script.loan.drawdownreverse;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.util.ASValuePool;

public class DrawdownReverseExecutor implements ITransactionExecutor{
	


	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		//取Loan对象
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		ArrayList<BusinessObject> subsidiaryList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger);
		if(subsidiaryList==null) throw new Exception("未取到分类账！");
		
		ArrayList<BusinessObject> paymentSchedules = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		if (paymentSchedules != null) {
			for(BusinessObject paymentSchedule:paymentSchedules){
				// String payDate = paymentSchedule.getString("PayDate");
				String payType = paymentSchedule.getString("PAYTYPE");
				if(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay.equals(payType)||ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay_All.equals(payType)) throw new Exception("做过提前还款，不允许冲销！");
				
				if(!ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal.equals(payType) && !ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay.equals(payType)&&!ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay_All.equals(payType)) //不是一般还款或者提前还款不考虑
					continue;
				//if(SystemConfig.getBusinessDate().compareTo(payDate) >= 0) throw new Exception("贷款已过结息日，不允许冲销！");
			}
		}
		
		BusinessObject bc = loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract, loan.getString("PutOutNo"));
		//基本检查
		if(loan.getDouble("NormalBalance")!=loan.getDouble("BusinessSum"))
			throw new Exception(" 正常本金："+loan.getDouble("NormalBalance")+"  放款本金："+loan.getDouble("BusinessSum")+" 不等！\n");
		
		double b= AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Overdue_Principal, ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay)
				+AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Overdue_Interest, ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay)
				+AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Fine_Interest, ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay)
				+AccountCodeConfig.getBusinessObjectBalance(loan, "AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Compound_Interest, ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		if(b > 0)
			throw new Exception("该贷款存在逾期不能进行冲账！");
		
		BusinessObject oldTransaction = transaction.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.transaction, transaction.getString("StrikeSerialNo"));
		oldTransaction.setAttributeValue("TransStatus", "2");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,oldTransaction);
		
		//删除未来还款计划
		//ArrayList<BusinessObject> paymentScheduleList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);	
		ASValuePool aspayment = new ASValuePool();
		aspayment.setAttribute("ObjectNo", loan.getObjectNo());
		aspayment.setAttribute("ObjectType", loan.getObjectType());
		BusinessObject paymentFilter = new BusinessObject(aspayment);
		List<BusinessObject> paymentScheduleList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule,paymentFilter);	
		
		ArrayList<BusinessObject> paymentScheduleListTmp = new ArrayList<BusinessObject>();
		for(int i=0;i<paymentScheduleList.size();i++)
		{
			BusinessObject a = paymentScheduleList.get(i);
			if(DateFunctions.getDays(a.getString("PayDate"),loan.getString("BusinessDate"))<0)
			{
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete,a);
			}
			else
				paymentScheduleListTmp.add(a);
		}
		loan.removeRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		loan.setRelativeObjects(paymentScheduleListTmp);
		
		//删除费用计划
		ArrayList<BusinessObject> feeScheduleList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule);
		ArrayList<BusinessObject> feeScheduleListTmp = new ArrayList<BusinessObject>();
		if(feeScheduleList!=null){
			for(int i=0;i<feeScheduleList.size();i++)
			{
				BusinessObject a = feeScheduleList.get(i);
				if(DateFunctions.getDays(a.getString("PayDate"),loan.getString("BusinessDate"))<0)
				{
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete,a);
				}
				else
					feeScheduleListTmp.add(a);
			}
		}
		
		loan.removeRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule);
		loan.setRelativeObjects(feeScheduleListTmp);
		
		//hhcf删除还款计划中的费用计划
		List<BusinessObject> feeList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(feeList!=null&&feeList.size()>0){
			for(BusinessObject fee:feeList){
				ArrayList<BusinessObject> feePaymentScheduleList = new ArrayList<BusinessObject>();
				feePaymentScheduleList=fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
				if(feePaymentScheduleList!=null){
					boManager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_delete,feePaymentScheduleList);
				}
			}
			
		}
		/*ArrayList<BusinessObject> pslist = new ArrayList<BusinessObject>();
		List<BusinessObject> feeList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(feeList!=null&&feeList.size()>0){
			for(BusinessObject fee:feeList){
				String feeNo = fee.getObjectNo();
				
				ASValuePool asfee = new ASValuePool();
				asfee.setAttribute("ObjectType", fee.getObjectType());
				asfee.setAttribute("ObjectNo", feeNo);
				asfee.setAttribute("PayDate",transaction.getString("TransDate"));
				String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo" ;
				List<BusinessObject> feepaymentScheduleList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule,whereClauseSql,asfee);
				if(feepaymentScheduleList !=null && !feepaymentScheduleList.isEmpty()){
					for(BusinessObject feeps:feepaymentScheduleList){
						if(feeps.getString("PayDate").compareTo(transaction.getString("BusinessDate"))>0){
							pslist.add(feeps);
						}
					}
				}
			}
		}
		
		if(pslist!=null && !pslist.isEmpty()){
			boManager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_delete, pslist);
		}*/
		
		
		//将实际出账金额更新
		bc.setAttributeValue("ActualputoutSum", bc.getDouble("ActualputoutSum") - loan.getDouble("BusinessSum"));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,bc);	
		//将bp的状态更新
		BusinessObject bp  = loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_putout, loan.getString("PutOutNo"));
		if(bp != null){
			bp.setAttributeValue("PutoutStatus","2" );
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,bp);	
		}
		loan.setAttributeValue("LoanStatus", "6");
		loan.setAttributeValue("FinishDate", SystemConfig.getBusinessDate());
		
		return 1;
	}
}
