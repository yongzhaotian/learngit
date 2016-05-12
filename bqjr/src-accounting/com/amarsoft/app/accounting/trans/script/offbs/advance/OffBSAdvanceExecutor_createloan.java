package com.amarsoft.app.accounting.trans.script.offbs.advance;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.amarscript.Any;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.trigger.TriggerTools;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.product.ProductManage;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.rpt.due.IPeriodScript;
import com.amarsoft.app.accounting.rpt.pmt.IPMTScript;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.app.accounting.util.PaymentScheduleFunctions;
import com.amarsoft.app.accounting.util.RateFunctions;
import com.amarsoft.are.util.Arith;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * @author xjzhao 2011/04/02
 * ����
 */
public class OffBSAdvanceExecutor_createloan implements ITransactionExecutor{
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject bp=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		bp.setAttributeValue("PutoutDate", transaction.getString("TransDate"));
		
		BusinessObject loan = createLoan(transaction,boManager);//����Loan
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, loan);
		transaction.setRelativeObject(loan);
		
		List<BusinessObject> pslist = createPaymentSchedule(loan,boManager);//���ɻ���ƻ�
		boManager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_new, pslist);
		transaction.setRelativeObjects(pslist);
		loan.setRelativeObjects(pslist);
		updateLoanAttributes(loan, boManager);
		return 1;
		
	}
	
	/**
	 * ���ݳ�����Ϣ���ɴ�����Ϣ
	 * @throws Exception
	 */
	private BusinessObject createLoan(BusinessObject transaction,AbstractBusinessObjectManager boManager) throws Exception{
		BusinessObject bp=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		
		BusinessObject loan = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan,boManager);
		
		Item[] colMapping = CodeCache.getItems("BP-Loan_ColumnsMapping");
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
		loan.setAttributeValue("AutoPayFlag", "1");
		loan.setAttributeValue("AccountNo", loan.getObjectNo());
		loan.setAttributeValue("OccurType", "070");
		loan.setAttributeValue("PutoutDate", SystemConfig.getBusinessDate());
		loan.setAttributeValue("MaturityDate", SystemConfig.getBusinessDate());
		loan.setAttributeValue("LastDueDate", SystemConfig.getBusinessDate());
		loan.setAttributeValue("NextDueDate", SystemConfig.getBusinessDate());
		loan.setAttributeValue("ORIGINALMATURITYDATE", SystemConfig.getBusinessDate());
		loan.setAttributeValue("BusinessDate", SystemConfig.getBusinessDate());
		copyLoanRelativeObjectList(bp,loan,BUSINESSOBJECT_CONSTATNTS.loan_rate_segment,boManager);
		copyLoanRelativeObjectList(bp,loan,BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment,boManager);
		copyLoanRelativeObjectList(bp,loan,BUSINESSOBJECT_CONSTATNTS.loan_accounts,boManager);
		
		List<BusinessObject> list = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		ProductManage pm=new ProductManage(boManager);
		pm.initSegTermDate(loan.getString("PutoutDate"), "", DateFunctions.TERM_UNIT_MONTH, 1, list);//��Ϊ�Ƿ�Ϣ���ʣ�����û�н������ڣ�Ĭ�϶��ǰ������ڴ�
		for(BusinessObject rateSegment:list)
		{
			int yearDays = rateSegment.getInt("YearDays");
			if(yearDays<=0){
				yearDays=RateFunctions.getBaseDays(loan.getString("Currency"));
				rateSegment.setAttributeValue("YearDays",yearDays);
			}
			rateSegment.setAttributeValue("YearDays", yearDays);
		}
		//��ʼ�����
		//�Ƿ���Ҫ����Ʒ����������?
		pm.initBusinessObject(loan);
		
		return loan;
	}
	
	private void copyLoanRelativeObjectList(BusinessObject businessPutout,BusinessObject loan,String objectType,AbstractBusinessObjectManager boManager) throws Exception{
		List<BusinessObject> list = businessPutout.getRelativeObjects(objectType);
		if(list == null) return;
		for(BusinessObject termObject:list){
			BusinessObject newTermObject = new BusinessObject(objectType,boManager);
			newTermObject.setValue(termObject);
			newTermObject.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
			newTermObject.setAttributeValue("ObjectNo", loan.getObjectNo());
			newTermObject.setAttributeValue("Status","1");
			loan.setRelativeObject(newTermObject);
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newTermObject);
		}
	}
	
	private List<BusinessObject> createPaymentSchedule(BusinessObject loan,AbstractBusinessObjectManager boManager) throws Exception{
		BusinessObject ps = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,boManager);
		ps.setAttributeValue("ObjectType", loan.getObjectType());
		ps.setAttributeValue("ObjectNo", loan.getObjectNo());
		ps.setAttributeValue("SeqID", 1);
		ps.setAttributeValue("PayType", ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal);
		ps.setAttributeValue("PayDate", loan.getString("MaturityDate"));
		ps.setAttributeValue("PayPrincipalAmt", loan.getDouble("BusinessSum"));
		ArrayList<BusinessObject> list=new ArrayList<BusinessObject>();
		list.add(ps);
		return list;
	}
	
	private void updateLoanAttributes(BusinessObject loan,AbstractBusinessObjectManager bomanager) throws Exception{
		String businessDate = loan.getString("BusinessDate");
	
		String updatePSFlag=loan.getString("UpdatePMTSchdFlag");
		String updateInstalAmtFlag = loan.getString("UpdateInstalAmtFlag");
		if(updatePSFlag!=null&&updatePSFlag.equals("1")){
			//���û��ʽ��Ϣ�Ƿ�����¹�
			ArrayList<BusinessObject> rptList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
			for(BusinessObject rpt:rptList)
			{
				if("1".equals(updateInstalAmtFlag))
				{
					rpt.setAttributeValue("UpdateInstalAmtFlag", "1");
				}
			}
			
			// �����µĻ���ƻ�
			List<BusinessObject> paymentScheduleListNew = PaymentScheduleFunctions.createLoanPaymentScheduleList(loan,null,bomanager);
			PaymentScheduleFunctions.removeFuturePaymentScheduleList(loan, null, bomanager);//ɾ��ԭ�л���ƻ�
			loan.setRelativeObjects(paymentScheduleListNew);//��ֵ�µĻ���ƻ�
			bomanager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_new, paymentScheduleListNew);
			/*****����RPT���ڹ�*****/
			for(BusinessObject rpt:rptList){
				String status = rpt.getString("Status");
				if("1".equals(status)) {
					IPeriodScript periodScript = RPTFunctions.getPeriodScript(loan, rpt);
					int t=periodScript.getTotalPeriod(loan, rpt);
					rpt.setAttributeValue("TotalPeriod", t);
					IPMTScript pmtScript = RPTFunctions.getPMTScript(loan, rpt);
					if(pmtScript!=null){
						double instalmentAmount=RPTFunctions.getPMTScript(loan, rpt).getInstalmentAmount(loan, rpt);
						rpt.setAttributeValue("SegInstalmentAmt", instalmentAmount);
						bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, rpt);
					}
				}
				rpt.setAttributeValue("UpdateInstalAmtFlag","0");
			}
			//�ڹ���ʶ�޸�Ϊ�������¼��㣬����ÿ�������ڹ�
			loan.setAttributeValue("UpdateInstalAmtFlag","0");
			loan.setAttributeValue("UpdatePMTSchdFlag", "2");
		}
		
		double normalBalance =0d,overdueBalance=0d,odInterest=0d,fineInterest=0d,compInterest=0d,pmtAmount=0d;
		
		int lcaTimes = 0;//����Ƿ�����
		
		String nextDueDate="";//�´λ�����
		int currentPeriod = loan.getInt("CurrentPeriod");
		//���ݻ���ƻ��������
		ArrayList<BusinessObject> a = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		if(a!=null){
			for(BusinessObject paymentschedule:a){
				String paydate=paymentschedule.getString("PayDate");
				String payType=paymentschedule.getString("PayType");
				String finishDate=paymentschedule.getString("FinishDate");
				if(finishDate==null)finishDate="";
				if(payType!=null&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay)&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay_All)) continue;//ֻ������������ǰ�����¼
				if(paydate.compareTo(businessDate)>0&&finishDate.length()==0){//δ������ƻ�����δ����
					if(nextDueDate.length()==0||nextDueDate.compareTo(paydate)>0){
						nextDueDate=paydate;
						pmtAmount=paymentschedule.getDouble("PayPrincipalAmt")+paymentschedule.getDouble("PayInteAmt");//�´λ����
						currentPeriod=paymentschedule.getInt("SeqID")-1;
					}
				}
				//���»���ƻ�״̬
				double prinacipal = Arith.round(paymentschedule.getDouble("PayPrincipalAmt") - paymentschedule.getDouble("ActualPayPrincipalAmt"), 2);
				double inte = Arith.round(paymentschedule.getDouble("PayInteAmt") - paymentschedule.getDouble("ActualPayInteAmt"), 2);
				double fine = Arith.round(paymentschedule.getDouble("PayFineAmt") - paymentschedule.getDouble("ActualPayFineAmt"), 2);
				double comp = Arith.round(paymentschedule.getDouble("PayCompdInteAmt") - paymentschedule.getDouble("ActualPayCompdInteAmt"), 2);
				
				//����ȫ���������ڣ�������Ϣ
				if( prinacipal + inte+ fine + comp <=0 && paydate.compareTo(businessDate) <= 0){
					if("".equals(paymentschedule.getString("FinishDate"))||paymentschedule.getString("FinishDate")==null) {
						paymentschedule.setAttributeValue("FinishDate", businessDate);
					}
				}
				else{
					paymentschedule.setAttributeValue("FinishDate", "");
				}
				
				//�����ڹ��������ڣ���������Ϣ
				if( prinacipal + inte <=0 ){
					if(paymentschedule.getString("SettleDate")==null||paymentschedule.getString("SettleDate").equals("")) {
						paymentschedule.setAttributeValue("SettleDate", businessDate);
					}
				}
				else{
					paymentschedule.setAttributeValue("SettleDate", "");
				}
				
					
				String finishdate = paymentschedule.getString("FinishDate");//�ѽ���Ļ���ƻ�������
				if(!"".equals(finishdate)&&finishdate!=null) continue;
				
				fineInterest += fine;//�ۼƷ�Ϣ���
				compInterest += comp;//�ۼƸ������
				
				if(paydate.compareTo(businessDate) >= 0){
					normalBalance+= prinacipal;//���������������
				}
				else{
					if(paymentschedule.getString("SettleDate").equals("")){
						lcaTimes++;
					}
					overdueBalance += prinacipal;//�ۼ��ѵ��ڱ�����
					odInterest += inte;//�ۼ�ǷϢ���
				}
			}
		}
		loan.setAttributeValue("NextDueDate", nextDueDate);//�´λ�����
		loan.setAttributeValue("OverdueBalance", Arith.round(overdueBalance,2));//�������
		loan.setAttributeValue("NormalBalance", Arith.round(normalBalance,2));//�������
		loan.setAttributeValue("ODInteBalance", Arith.round(odInterest,2));//�ڹ�ǷϢ
		loan.setAttributeValue("FineInteBalance", Arith.round(fineInterest,2));//��Ϣ
		loan.setAttributeValue("CompdInteBalance", Arith.round(compInterest,2));//����
		loan.setAttributeValue("LcaTimes", lcaTimes);//�������ڴ���
		loan.setAttributeValue("NextInstalmentAmt", pmtAmount);//�´λ����
		loan.setAttributeValue("CurrentPeriod", currentPeriod);//��ǰ�ڴ�
		
		int overdueDays=LoanFunctions.getOverDays(loan);
		loan.setAttributeValue("OverdueDays", overdueDays);
		
		LoanFunctions.updateLoanStatus(loan, bomanager);
		LoanFunctions.updateLoanRptSegment(loan, bomanager);
		TriggerTools.deal(bomanager,loan);//�������¹�������
		bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, loan);
	}
	
}
