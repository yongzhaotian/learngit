package com.amarsoft.app.accounting.trans.script.loan.drawdown;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.amarscript.Any;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.product.ProductManage;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.app.accounting.util.FeeFunctions;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.app.accounting.util.RateFunctions;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * 贷款发放
 */
public class DrawdownScript_createloan implements ITransactionExecutor{
	
	public BusinessObject loan;
	
	public List<BusinessObject> subDetailList;
	public List<BusinessObject> subDiaryList;

	private ITransactionScript transactionScript;
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript =transactionScript;
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject businessPutout=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//1.重新设置放款日期，如果已经输入了putoutDate，则以输入的日期为准，以支持起息不是放款日的情况
		String putoutDate = businessPutout.getString("PutoutDate");
		if(putoutDate==null||putoutDate.length()==0){
			businessPutout.setAttributeValue("PutoutDate", transaction.getString("TransDate"));
		}
		else if(DateFunctions.getDays(putoutDate, transaction.getString("TransDate")) < 0)
			throw new LoanException("发放日期不正确，请退回重新填写发放日期和到期日期！");
		
		//更新出账记录放款状态		
		businessPutout.setAttributeValue("PutoutStatus", "1");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, businessPutout);
		//2.根据BUSINESS_PUTOUT对象生成ACCT_LOAN对象
		createLoan();
		
		//生成还款计划、更新贷款信息
		loan.setAttributeValue("UpdatePMTSchdFlag", "1");
		loan.setAttributeValue("UpdateInstalAmtFlag", "1");

		String nextRepriceDate = RateFunctions.getNextRepriceDate(loan);//下次利率调整日
		loan.setAttributeValue("NextRepriceDate", nextRepriceDate);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,loan);

		return 1;
	}
	
	/**
	 * 根据出账信息生成贷款信息
	 * @throws Exception
	 */
	private void createLoan() throws Exception{
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject businessPutout=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		ProductManage pm = new ProductManage(boManager.getSqlca());
		//是否需要将产品的利率引入?
		pm.initBusinessObject(businessPutout);
		String putoutdate = businessPutout.getString("PutoutDate");
		if(putoutdate==null||putoutdate.length()==0) putoutdate=transaction.getString("TransDate");
		loan = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan,boManager);
		transaction.setAttributeValue("RelativeObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
		transaction.setAttributeValue("RelativeObjectNo", loan.getObjectNo());
		transaction.setRelativeObject(loan);
		Item[] colMapping = CodeCache.getItems("BC-Loan_ColumnsMapping");
		for (int i=0;i<colMapping.length;i++) {
			Item item=colMapping[i];
			String loanAttributeID=item.getItemNo();
			String objectType=item.getItemAttribute();
			String attributeID=item.getRelativeCode();
			if(objectType!=null&&objectType.length()>0){
				BusinessObject sourceObject=transaction.getRelativeObjects(objectType).get(0);
				loan.setAttributeValue(loanAttributeID, sourceObject.getObject(attributeID));
			}
			else{
				Any a = ExtendedFunctions.getScriptValue(attributeID,transaction,boManager.getSqlca());
				loan.setAttributeValue(loanAttributeID, a);
			}
		}
		//设置贷款账号字段同贷款流水号
		loan.setAttributeValue("AutoPayFlag", "1");
		//loan.setAttributeValue("HxFlag", "0");//核销标识-默认正常
		loan.setAttributeValue("LockFlag", "2");
		loan.setAttributeValue("AccountNo", loan.getString("SerialNo"));//此处需要修改账号生成方式
		loan.setAttributeValue("PutoutDate",putoutdate);//贷款发放日期
		loan.setAttributeValue("BusinessDate",SystemConfig.getBusinessDate());//贷款日期
		
		BusinessObject bc = businessPutout.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract, businessPutout.getString("SerialNo"));
		if(bc!=null){
			loan.setAttributeValue("OccurType", bc.getString("OccurType"));
		}
		else loan.setAttributeValue("OccurType", "010");

		String maturityCalcFlag = businessPutout.getString("MaturityCalcFlag");
		if(maturityCalcFlag==null||maturityCalcFlag.length()==0)
			maturityCalcFlag="01";
		if("02".equals(maturityCalcFlag))//以发放日加期限为准
		{
			//计算贷款到期日和期限
			int termMonth = businessPutout.getInt("TermMonth");
			int termDay = businessPutout.getInt("TermDay");
			String maturitydate = businessPutout.getString("Maturity");
			if(termMonth>=0 && termDay >= 0 && termMonth+termDay > 0){
				maturitydate=DateFunctions.getRelativeDate(putoutdate, DateFunctions.TERM_UNIT_MONTH, termMonth);
				maturitydate=DateFunctions.getRelativeDate(maturitydate, DateFunctions.TERM_UNIT_DAY, termDay);
				loan.setAttributeValue("MaturityDate",maturitydate);//贷款的到期日
				loan.setAttributeValue("OriginalMaturityDate",maturitydate);//贷款的到期日
			}
			else throw new LoanException("未录入正确贷款期限，请检查！");
		}
		else if("01".equals(maturityCalcFlag))//以录入到期日为准
		{
			String maturitydate = businessPutout.getString("Maturity");
			if(maturitydate == null || "".equals(maturitydate)) throw new LoanException("未录入贷款到期日，请检查！");
			loan.setAttributeValue("MaturityDate",maturitydate);//贷款的到期日
			loan.setAttributeValue("OriginalMaturityDate",maturitydate);//贷款的到期日
		}
		else throw new LoanException("该业务产品版本放款组件-贷款到期日确认方式未录入正确！");
		
		//插入RptSegment\RateSegment\SPTSegment\Accounts
		createLoanRelativeObjects(businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment));
		createLoanRelativeObjects(businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment));
		createLoanRelativeObjects(businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment));
		createLoanRelativeObjects(businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts));
		createLoanRelativeObjects(businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule));
		loan.setRelativeObjects("FixPaymentSchedule", businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule));//用于判断还款计划
		//初始化日期
		pm.initSegTermDate(loan.getString("PutoutDate"), "", DateFunctions.TERM_UNIT_MONTH, 1, loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment));
		pm.initSegTermDate(loan.getString("PutoutDate"), "", DateFunctions.TERM_UNIT_MONTH, 1, loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment));
		pm.initSegTermDate(loan.getString("PutoutDate"), "", DateFunctions.TERM_UNIT_MONTH, 1, loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment));
		//处理交易相关的费用，将放款前的费用关联到贷款上
		copyFeeToLoan();
		pm.initSegTermDate(loan.getString("PutoutDate"), "", DateFunctions.TERM_UNIT_MONTH, 1, loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee));
		
		
		//初始化组件
		//是否需要将产品的利率引入?
		pm.initBusinessObject(loan);
		
		//初始化还款信息
		ArrayList<BusinessObject> loanRPTList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		if(loanRPTList!=null&&!loanRPTList.isEmpty()){
			for(BusinessObject a:loanRPTList){
				String lastDueDate = a.getString("SegFromDate");
				if(lastDueDate==null||lastDueDate.length()==0) lastDueDate=loan.getString("PutoutDate");
				a.setAttributeValue("LastDueDate", lastDueDate);
				
				String defaultDueDay = a.getString("DefaultDueDay");//默认还款日
				if(defaultDueDay == null || "".equals(defaultDueDay) || "0".equals(defaultDueDay)) defaultDueDay = loan.getString("PutoutDate").substring(8);
				else if(defaultDueDay.length()<2) defaultDueDay="0"+defaultDueDay;
				a.setAttributeValue("DefaultDueDay", defaultDueDay);

				String nextPayDate = RPTFunctions.getDueDateScript(loan,a).getNextPayDate(loan, a);
				a.setAttributeValue("NextDueDate", nextPayDate);
				
				a.setAttributeValue("SEGRPTBalance", a.getDouble("SEGRPTAmount"));
				//a.setAttributeValue("CurrentPeriod", loan.getString("CurrentPeriod"));
				a.setAttributeValue("UpdateInstalAmtFlag", "1");
			}
		}
		
		//初始化利率信息
		this.updateInterestRate();
		
		//计算一些必须的字段
		loan.setAttributeValue("LastRepriceDate", putoutdate);//上次利率调整日
		loan.setAttributeValue("LastDueDate", putoutdate);//上次到期日
		String nextDueDate = LoanFunctions.getNextDueDate(loan);
		if(!nextDueDate.equals(loan.getString("NextDueDate"))){
			loan.setAttributeValue("NextDueDate", nextDueDate);
		}
		loan.setRelativeObject(businessPutout.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract, businessPutout.getString("SerialNo")));		
	}
	

	private void copyFeeToLoan() throws Exception{
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject businessPutout=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		List<BusinessObject> feeList = businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		List<BusinessObject> feeLogList = businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_log);
		List<BusinessObject> feeScheduleList = businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule);
		List<BusinessObject> feeAmortizeScheduleList = businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.feeAmortize_schedule);
		if(feeList!=null){
			for(BusinessObject fee:feeList){
				BusinessObject newFee = new BusinessObject(fee.getObjectType(),boManager);
				newFee.setValue(fee);
				
				loan.setRelativeObject(newFee);
				newFee.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
				newFee.setAttributeValue("ObjectNo", loan.getObjectNo());
				newFee.removeRelativeObject(businessPutout.getObjectType(), businessPutout.getObjectNo());
				newFee.setAttributeValue("Status", "1");
				fee.setAttributeValue("Status", "3");
				newFee.setAttributeValue("AccountingOrgID", loan.getString("AccountingOrgID"));
				
				//处理费用摊销计划
				if(feeAmortizeScheduleList!=null){
					for(BusinessObject feeAmortize:feeAmortizeScheduleList){
						if(feeAmortize.getString("FeeSerialNo").equals(fee.getObjectNo()))
						{
							BusinessObject newFeeAmortize = new BusinessObject(feeAmortize.getObjectType(),boManager);
							newFeeAmortize.setValue(feeAmortize);
							newFeeAmortize.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
							newFeeAmortize.setAttributeValue("ObjectNo", loan.getObjectNo());
							newFeeAmortize.setAttributeValue("FeeSerialNo", newFee.getObjectNo());
							feeAmortize.setAttributeValue("Status", "2");
							boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newFeeAmortize);
							loan.setRelativeObject(newFeeAmortize);
						}
					}
				}
				
				if(feeScheduleList!=null){
					for(BusinessObject feeSche:feeScheduleList){
						if(feeSche.getString("FeeSerialNo").equals(fee.getObjectNo()))
						{
							BusinessObject newFeeSche = new BusinessObject(feeSche.getObjectType(),boManager);
							newFeeSche.setValue(feeSche);
							newFeeSche.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
							newFeeSche.setAttributeValue("ObjectNo", loan.getObjectNo());
							newFeeSche.setAttributeValue("FeeSerialNo", newFee.getObjectNo());
							boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newFeeSche);
							loan.setRelativeObject(newFeeSche);
							newFee.setRelativeObject(feeSche);
							
							if(feeLogList!=null){
								for(BusinessObject feeLog:feeLogList){
									if(feeLog.getString("FeeScheduleSerialNo").equals(feeSche.getObjectNo()))
									{
										BusinessObject newFeeLog = new BusinessObject(feeLog.getObjectType(),boManager);
										newFeeLog.setValue(feeLog);
										newFeeLog.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
										newFeeLog.setAttributeValue("ObjectNo", loan.getObjectNo());
										newFeeLog.setAttributeValue("FeeSerialNo", newFee.getObjectNo());
										newFeeLog.setAttributeValue("FeeScheduleSerialNo", newFeeSche.getObjectNo());
										feeLog.setAttributeValue("Status", "2");
										boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newFeeLog);
										loan.setRelativeObject(newFeeLog);
									}
								}
							}
						}
					}
				}
				//处理费用减免信息
				List<BusinessObject> boList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive);
				if(boList != null)
				{
					for(BusinessObject feewaive:boList)
					{
						BusinessObject fw = new BusinessObject(feewaive.getObjectType(),boManager);
						fw.setValue(feewaive);
						fw.setAttributeValue("ObjectNo", newFee.getObjectNo());
						fw.setAttributeValue("ObjectType", newFee.getObjectType());
						
						if(fw.getString("WaiveFromDate") == null || fw.getString("WaiveFromDate").length() == 0)
							fw.setAttributeValue("WaiveFromDate", newFee.getString("SegFromDate"));
						if(fw.getString("WaiveToDate") == null || fw.getString("WaiveToDate").length() == 0)
							fw.setAttributeValue("WaiveToDate", newFee.getString("SegToDate"));
						if(fw.getInt("WaiveFromStage") == 0) fw.setAttributeValue("WaiveFromStage", newFee.getString("SegFromStage"));
						if(fw.getInt("WaiveToStage") == 0) fw.setAttributeValue("WaiveToStage", newFee.getString("SegToStage"));
						newFee.setRelativeObject(fw);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, fw);
					}
				}
				//处理费用账户信息
				boList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
				if(boList != null)//查看费用本身录入的费用存款账户信息
				{
					for(BusinessObject bo:boList)
					{
						BusinessObject la = new BusinessObject(bo.getObjectType(),boManager);
						la.setValue(bo);
						la.setAttributeValue("ObjectNo",newFee.getObjectNo());
						la.setAttributeValue("ObjectType", newFee.getObjectType());
						la.setAttributeValue("Status", "1");
						newFee.setRelativeObject(la);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, la);
					}
				}
				//在收费时找不到费用账户，自动找费用关联的账户信息是否更好一些？？？
				else//如果费用本身未录入的费用存款账户信息，则费用使用贷款录入的存款账户信息
				{
					boList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
					if(boList == null) return;
					for(BusinessObject bo:boList)
					{
						BusinessObject la = new BusinessObject(bo.getObjectType(),boManager);
						la.setValue(bo);
						la.setAttributeValue("ObjectNo",newFee.getObjectNo());
						la.setAttributeValue("ObjectType", newFee.getObjectType());
						la.setAttributeValue("Status", "1");
						newFee.setRelativeObject(la);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, la);
					}
				}
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newFee);
				ArrayList<BusinessObject> feeScheduleList_T = FeeFunctions.createFeeScheduleList(newFee,loan, boManager);
				newFee.setRelativeObjects(feeScheduleList_T);
				loan.setRelativeObjects(feeScheduleList_T);
				boManager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_new, feeScheduleList_T);
			}
		}
		
		//目前bp有账务产生都是在收费的地方,将费用的帐挂在loan的下面
		if(this.subDetailList!=null){
			for(BusinessObject a:subDetailList){
				a.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
				a.setAttributeValue("ObjectNo", loan.getObjectNo());
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, a);
				loan.setRelativeObject(a);
			}
		}
		
		if(this.subDiaryList!=null){
			for(BusinessObject a:subDiaryList){
				a.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
				a.setAttributeValue("ObjectNo", loan.getObjectNo());
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, a);
				loan.setRelativeObject(a);
			}
		}
	}
	
	protected void createLoanRelativeObjects(List<BusinessObject> list) throws Exception{
		if(list == null) return;
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		for(int i=0;i<list.size();i++){
			BusinessObject acctSegment = (BusinessObject)list.get(i);
			BusinessObject acctSegment1 = new BusinessObject(acctSegment.getObjectType(),boManager);
			acctSegment1.setValue(acctSegment);
			acctSegment1.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
			acctSegment1.setAttributeValue("ObjectNo", loan.getObjectNo());
			acctSegment1.setAttributeValue("Status","1");
			
			//if("".equals(acctSegment1.getString("FinalinstalmentFlag")))acctSegment1.setAttributeValue("FinalinstalmentFlag", "01");
			loan.setRelativeObject(acctSegment1);
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, acctSegment1);
		}
	}
	
	private void updateInterestRate() throws NumberFormatException, Exception{
		List<BusinessObject> loanRateList = InterestFunctions.getRateSegmentList(loan, ACCOUNT_CONSTANTS.RateType_Normal+","+ACCOUNT_CONSTANTS.RateType_Discount);
		for(BusinessObject a:loanRateList){	
			if(a.getString("RateUnit") == null || "".equals(a.getString("RateUnit"))){
				a.setAttributeValue("RateUnit", "01");
			}
			
			int yearDays = a.getInt("YearDays");
			if(yearDays<=0){
				yearDays=RateFunctions.getBaseDays(loan.getString("Currency"));
				a.setAttributeValue("YearDays",yearDays);
			}
			a.setAttributeValue("BaseRateGrade", "");
			double baseRate = RateFunctions.getBaseRate(loan,a);
			a.setAttributeValue("BaseRate", baseRate);//基准利率
			double businessRate = RateFunctions.getBusinessRate(loan,a);
			a.setAttributeValue("BusinessRate", businessRate);//执行利率
			a.setAttributeValue("LastInteDate",loan.getString("PutoutDate"));
		}
		List<BusinessObject> odRateList = InterestFunctions.getRateSegmentList(loan, ACCOUNT_CONSTANTS.RateType_Overdue);
		//处理罚息利率,第一段先计算最新的基准
		for(BusinessObject a:odRateList){
			//罚息的过滤掉，后一步单独处理
			if(a.getString("RateUnit") == null || "".equals(a.getString("RateUnit"))){
				a.setAttributeValue("RateUnit", ACCOUNT_CONSTANTS.RateUnit_Year);
			}
			
			int yearDays = a.getInt("YearDays");
			if(yearDays<=0){
				yearDays=RateFunctions.getBaseDays(loan.getString("Currency"));
				a.setAttributeValue("YearDays",yearDays);
			}
			a.setAttributeValue("BaseRateGrade", "");
			double baseRate = RateFunctions.getBaseRate(loan,a);
			a.setAttributeValue("BaseRate", baseRate);//基准利率
			double businessRate = RateFunctions.getBusinessRate(loan,a);
			a.setAttributeValue("BusinessRate", businessRate);//执行利率
			a.setAttributeValue("LastInteDate",loan.getString("PutoutDate"));
		}
	}

}
