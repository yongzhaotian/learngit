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
 * �����
 */
public class DrawdownScript_createloan implements ITransactionExecutor{
	
	public BusinessObject loan;
	
	public List<BusinessObject> subDetailList;
	public List<BusinessObject> subDiaryList;

	private ITransactionScript transactionScript;
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript =transactionScript;
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject businessPutout=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//1.�������÷ſ����ڣ�����Ѿ�������putoutDate���������������Ϊ׼����֧����Ϣ���Ƿſ��յ����
		String putoutDate = businessPutout.getString("PutoutDate");
		if(putoutDate==null||putoutDate.length()==0){
			businessPutout.setAttributeValue("PutoutDate", transaction.getString("TransDate"));
		}
		else if(DateFunctions.getDays(putoutDate, transaction.getString("TransDate")) < 0)
			throw new LoanException("�������ڲ���ȷ�����˻�������д�������ں͵������ڣ�");
		
		//���³��˼�¼�ſ�״̬		
		businessPutout.setAttributeValue("PutoutStatus", "1");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, businessPutout);
		//2.����BUSINESS_PUTOUT��������ACCT_LOAN����
		createLoan();
		
		//���ɻ���ƻ������´�����Ϣ
		loan.setAttributeValue("UpdatePMTSchdFlag", "1");
		loan.setAttributeValue("UpdateInstalAmtFlag", "1");

		String nextRepriceDate = RateFunctions.getNextRepriceDate(loan);//�´����ʵ�����
		loan.setAttributeValue("NextRepriceDate", nextRepriceDate);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,loan);

		return 1;
	}
	
	/**
	 * ���ݳ�����Ϣ���ɴ�����Ϣ
	 * @throws Exception
	 */
	private void createLoan() throws Exception{
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject businessPutout=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		ProductManage pm = new ProductManage(boManager.getSqlca());
		//�Ƿ���Ҫ����Ʒ����������?
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
		//���ô����˺��ֶ�ͬ������ˮ��
		loan.setAttributeValue("AutoPayFlag", "1");
		//loan.setAttributeValue("HxFlag", "0");//������ʶ-Ĭ������
		loan.setAttributeValue("LockFlag", "2");
		loan.setAttributeValue("AccountNo", loan.getString("SerialNo"));//�˴���Ҫ�޸��˺����ɷ�ʽ
		loan.setAttributeValue("PutoutDate",putoutdate);//���������
		loan.setAttributeValue("BusinessDate",SystemConfig.getBusinessDate());//��������
		
		BusinessObject bc = businessPutout.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract, businessPutout.getString("SerialNo"));
		if(bc!=null){
			loan.setAttributeValue("OccurType", bc.getString("OccurType"));
		}
		else loan.setAttributeValue("OccurType", "010");

		String maturityCalcFlag = businessPutout.getString("MaturityCalcFlag");
		if(maturityCalcFlag==null||maturityCalcFlag.length()==0)
			maturityCalcFlag="01";
		if("02".equals(maturityCalcFlag))//�Է����ռ�����Ϊ׼
		{
			//���������պ�����
			int termMonth = businessPutout.getInt("TermMonth");
			int termDay = businessPutout.getInt("TermDay");
			String maturitydate = businessPutout.getString("Maturity");
			if(termMonth>=0 && termDay >= 0 && termMonth+termDay > 0){
				maturitydate=DateFunctions.getRelativeDate(putoutdate, DateFunctions.TERM_UNIT_MONTH, termMonth);
				maturitydate=DateFunctions.getRelativeDate(maturitydate, DateFunctions.TERM_UNIT_DAY, termDay);
				loan.setAttributeValue("MaturityDate",maturitydate);//����ĵ�����
				loan.setAttributeValue("OriginalMaturityDate",maturitydate);//����ĵ�����
			}
			else throw new LoanException("δ¼����ȷ�������ޣ����飡");
		}
		else if("01".equals(maturityCalcFlag))//��¼�뵽����Ϊ׼
		{
			String maturitydate = businessPutout.getString("Maturity");
			if(maturitydate == null || "".equals(maturitydate)) throw new LoanException("δ¼�������գ����飡");
			loan.setAttributeValue("MaturityDate",maturitydate);//����ĵ�����
			loan.setAttributeValue("OriginalMaturityDate",maturitydate);//����ĵ�����
		}
		else throw new LoanException("��ҵ���Ʒ�汾�ſ����-�������ȷ�Ϸ�ʽδ¼����ȷ��");
		
		//����RptSegment\RateSegment\SPTSegment\Accounts
		createLoanRelativeObjects(businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment));
		createLoanRelativeObjects(businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment));
		createLoanRelativeObjects(businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment));
		createLoanRelativeObjects(businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts));
		createLoanRelativeObjects(businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule));
		loan.setRelativeObjects("FixPaymentSchedule", businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule));//�����жϻ���ƻ�
		//��ʼ������
		pm.initSegTermDate(loan.getString("PutoutDate"), "", DateFunctions.TERM_UNIT_MONTH, 1, loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment));
		pm.initSegTermDate(loan.getString("PutoutDate"), "", DateFunctions.TERM_UNIT_MONTH, 1, loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment));
		pm.initSegTermDate(loan.getString("PutoutDate"), "", DateFunctions.TERM_UNIT_MONTH, 1, loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment));
		//��������صķ��ã����ſ�ǰ�ķ��ù�����������
		copyFeeToLoan();
		pm.initSegTermDate(loan.getString("PutoutDate"), "", DateFunctions.TERM_UNIT_MONTH, 1, loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee));
		
		
		//��ʼ�����
		//�Ƿ���Ҫ����Ʒ����������?
		pm.initBusinessObject(loan);
		
		//��ʼ��������Ϣ
		ArrayList<BusinessObject> loanRPTList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		if(loanRPTList!=null&&!loanRPTList.isEmpty()){
			for(BusinessObject a:loanRPTList){
				String lastDueDate = a.getString("SegFromDate");
				if(lastDueDate==null||lastDueDate.length()==0) lastDueDate=loan.getString("PutoutDate");
				a.setAttributeValue("LastDueDate", lastDueDate);
				
				String defaultDueDay = a.getString("DefaultDueDay");//Ĭ�ϻ�����
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
		
		//��ʼ��������Ϣ
		this.updateInterestRate();
		
		//����һЩ������ֶ�
		loan.setAttributeValue("LastRepriceDate", putoutdate);//�ϴ����ʵ�����
		loan.setAttributeValue("LastDueDate", putoutdate);//�ϴε�����
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
				
				//�������̯���ƻ�
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
				//������ü�����Ϣ
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
				//��������˻���Ϣ
				boList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
				if(boList != null)//�鿴���ñ���¼��ķ��ô���˻���Ϣ
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
				//���շ�ʱ�Ҳ��������˻����Զ��ҷ��ù������˻���Ϣ�Ƿ����һЩ������
				else//������ñ���δ¼��ķ��ô���˻���Ϣ�������ʹ�ô���¼��Ĵ���˻���Ϣ
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
		
		//Ŀǰbp����������������շѵĵط�,�����õ��ʹ���loan������
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
			a.setAttributeValue("BaseRate", baseRate);//��׼����
			double businessRate = RateFunctions.getBusinessRate(loan,a);
			a.setAttributeValue("BusinessRate", businessRate);//ִ������
			a.setAttributeValue("LastInteDate",loan.getString("PutoutDate"));
		}
		List<BusinessObject> odRateList = InterestFunctions.getRateSegmentList(loan, ACCOUNT_CONSTANTS.RateType_Overdue);
		//����Ϣ����,��һ���ȼ������µĻ�׼
		for(BusinessObject a:odRateList){
			//��Ϣ�Ĺ��˵�����һ����������
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
			a.setAttributeValue("BaseRate", baseRate);//��׼����
			double businessRate = RateFunctions.getBusinessRate(loan,a);
			a.setAttributeValue("BusinessRate", businessRate);//ִ������
			a.setAttributeValue("LastInteDate",loan.getString("PutoutDate"));
		}
	}

}
