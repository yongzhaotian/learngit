package com.amarsoft.app.accounting.trans.script.loan.repay;

//���������ǰ����
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.interest.settle.InterestSettleFunctions;
import com.amarsoft.app.accounting.interest.suspense.InterestSuspenseFunctions;
import com.amarsoft.app.accounting.rpt.RPTFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.LoanFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;

public class PayExecutor_prepay implements ITransactionExecutor{
	
	private BusinessObject transaction;

	private AbstractBusinessObjectManager boManager;

	private BusinessObject loan;

	private BusinessObject paymentBill;

	private String transDate;

	private BusinessObject nextPaymentSchedule;

	private double normalbalance;

	private double actualNormalBalance;
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transaction = transactionScript.getTransaction();
		this.boManager = transactionScript.getBOManager();
		this.loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		this.paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		this.transDate = transaction.getString("TransDate");
		normalbalance = AccountCodeConfig.getBusinessObjectBalance(loan,"AccountCodeNo",ACCOUNT_CONSTANTS.LOAN_BalanceGroup_Customer_Normal_Principal,ACCOUNT_CONSTANTS.Balance_Flag_CurrentDay);
		
		String prepayType = paymentBill.getString("PrepayType");// ��ǰ���ʽ��ȫ����������ǰ����
		if(prepayType==null||prepayType.length()==0) {
			prepayType=ACCOUNT_CONSTANTS.PrepaymentType_Part_FixTerm;
			paymentBill.setAttributeValue("PrepayType", prepayType);
		}
		
		String prepayAmountFlag = paymentBill.getString("PrepayAmountFlag");//���������ͣ�1����2����+��Ϣ
		if(prepayAmountFlag==null||prepayAmountFlag.length()==0){
			prepayAmountFlag=ACCOUNT_CONSTANTS.PREPAY_AMOUNT_TYPE_Principal_Interest;
			paymentBill.setAttributeValue("PrepayAmountFlag", prepayAmountFlag);
		}
		
		String prepayInterestBaseFlag = paymentBill.getString("PrepayInterestBaseFlag");//��ǰ������Ϣ���������1��ǰ�����2�������
		if(prepayInterestBaseFlag==null||prepayInterestBaseFlag.length()==0){
			prepayInterestBaseFlag=ACCOUNT_CONSTANTS.Prepayment_InterestBaseFlag_PayPrincipal;
			paymentBill.setAttributeValue("PrepayInterestBaseFlag", prepayInterestBaseFlag);
		}
		
		String prepayInterestDaysFlag = paymentBill.getString("PrepayInterestDaysFlag");//��ǰ������Ϣ�������ޣ�1��ǰ������2��һ������3�ϲ����������ڹ�
		if(prepayInterestDaysFlag==null||prepayInterestDaysFlag.length()==0){
			prepayInterestDaysFlag=ACCOUNT_CONSTANTS.Prepayment_InterestFlag_TransDate;
			paymentBill.setAttributeValue("PrepayInterestDaysFlag", prepayInterestDaysFlag);
		}
		
		nextPaymentSchedule=this.getNextPaymentSchedule();
		
		//���������ʱ����
		actualNormalBalance  = normalbalance;
		if(nextPaymentSchedule!=null){
			if(transDate.equals(nextPaymentSchedule.getString("PayDate"))){
				normalbalance=Arith.round(normalbalance- (nextPaymentSchedule.getDouble("PayPrincipalAmt")-nextPaymentSchedule.getDouble("ActualPayPrincipalAmt")+nextPaymentSchedule.getDouble("WaivePrincipalAmt")),2);
			}
		}
		
		//��¼���ϴλ����գ����������Ҫ���»�ȥ
		//paymentBill.setAttributeValue("PrepayInteAmt",paymentBill.getDouble("PayPrinciPalAmt"));
		//paymentBill.setAttributeValue("PrepayPrincipalAmt",paymentBill.getDouble("PayInteAmt"));
		paymentBill.setAttributeValue("PrepayInteAmt",this.getPrepayInterestAmt());
		paymentBill.setAttributeValue("PrepayPrincipalAmt",this.getPrepayPrincipalAmt());
		String lastDueDate = LoanFunctions.getLastDueDate(loan);
		String nextDueDate = LoanFunctions.getNextDueDate(loan);
		paymentBill.setAttributeValue("Remark","LastDueDate@"+lastDueDate + ",NextDuedate@"+nextDueDate+",MaturityDate@"+loan.getString("MaturityDate"));
		paymentBill.setAttributeValue("EX_SettleDate",this.getSettleDate());
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, paymentBill);
		
		createPaymentSchedule();
		updateLoan();
		ArrayList<BusinessObject> t = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		for(BusinessObject l:t)
			ARE.getLog().debug(l.toString());
		return 1;
	}
	
	private String getSettleDate() throws Exception{
		BusinessObject nextPaymentSchedule = this.getNextPaymentSchedule();
		String prepayInterestDaysFlag = paymentBill.getString("PrepayInterestDaysFlag");//��ǰ������Ϣ�������ޣ�1��ǰ������2��һ������3�ϲ����������ڹ�
		String settleDate = null;
		if (prepayInterestDaysFlag.equals("02")||nextPaymentSchedule==null)//��������ǰ������
			settleDate = this.transDate;
		else if (prepayInterestDaysFlag.equals("01")&&nextPaymentSchedule!=null)//��������һ�����գ����ϲ�����
			settleDate = nextPaymentSchedule.getString("PayDate");
		else if (prepayInterestDaysFlag.equals("03")&&nextPaymentSchedule!=null)//��������һ�����գ��Һϲ�����
			settleDate = nextPaymentSchedule.getString("PayDate");
		else if (prepayInterestDaysFlag.equals("04"))//������Ϣ
			settleDate = loan.getString("PutOutDate");
		else
			throw new Exception("������ˮ��{" + loan.getObjectNo()+ "}����ǰ��������{PrepayInterestDaysFlag}���岻��ȷ��");
		return settleDate;
	}
	
	private double getPrepayInterestAmt() throws Exception{
		String prepayInterestDaysFlag = paymentBill.getString("PrepayInterestDaysFlag");
		if(prepayInterestDaysFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestFlag_NoneInterest)){
			return 0d;
		}
		else if(prepayInterestDaysFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestFlag_NetNextInstalment)){//һ����ȡ�����ڹ�
			nextPaymentSchedule=this.getNextPaymentSchedule();
			if(nextPaymentSchedule!=null) return nextPaymentSchedule.getMoney("PayInteAmt");
		}
		
		double interestBase=0d;//����
		double suspenseInterest = 0.0d;//��Ϣ
		String settleDate = this.getSettleDate();
		List<BusinessObject> rateTermSegList = InterestFunctions.getRateSegmentList(loan, ACCOUNT_CONSTANTS.RateType_Normal);
		for (BusinessObject rateSegment: rateTermSegList){
			String lastSettleDate = InterestSettleFunctions.getLastInteSettleDate(loan, loan, ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest);
			interestBase+=InterestFunctions.getInterest(1.0d,rateSegment,loan, lastSettleDate, settleDate);
			suspenseInterest+=InterestSuspenseFunctions.getSuspenseInterest(loan, loan, rateSegment,ACCOUNT_CONSTANTS.INTEREST_TYPE_NormalInterest);
		}
		
		String prepayInterestBaseFlag = paymentBill.getString("PrepayInterestBaseFlag");//��ǰ������Ϣ���������1��ǰ�����2�������
		
		if (prepayInterestBaseFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestBaseFlag_PayPrincipal)){
			double prepayAmount = paymentBill.getMoney("PrepayAmount");
			String prepayAmountFlag = paymentBill.getString("PrepayAmountFlag");//���������ͣ�1����2����+��Ϣ
			
			if(ACCOUNT_CONSTANTS.PREPAY_AMOUNT_TYPE_Principal.equals(prepayAmountFlag)){//����
				return Arith.round(prepayAmount*interestBase, 2);
			}
			else if(ACCOUNT_CONSTANTS.PREPAY_AMOUNT_TYPE_Principal_Interest.equals(prepayAmountFlag)){//����+��Ϣ
				double prepayPrincipalAmt = Arith.round(prepayAmount/ (1 + interestBase), 2);
				return Arith.round(prepayAmount-prepayPrincipalAmt, 2);
			}
			else{
				throw new Exception("{Loan-"+loan.getObjectNo()+"}��Ч����ǰ����������{"+prepayAmountFlag+"}��");
			}
		}
		else if(prepayInterestBaseFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestBaseFlag_NormalBalance)){
			return Arith.round(normalbalance*interestBase, 2)+suspenseInterest;
		}
		
		
		return 0d;
	}
	
	private double getPrepayPrincipalAmt() throws Exception{
		
		String prepayType = paymentBill.getString("PrepayType");// ��ǰ���ʽ��ȫ����������ǰ����
		if(prepayType.equals(ACCOUNT_CONSTANTS.PrepaymentType_All)){
			return this.actualNormalBalance;
		}
		else{//������ǰ����
			double prepayPrincipalAmt=0d;
			double prepayAmount = paymentBill.getMoney("PrepayAmount");
			String prepayAmountFlag = paymentBill.getString("PrepayAmountFlag");//���������ͣ�1����2����+��Ϣ
			if(prepayAmountFlag.equals(ACCOUNT_CONSTANTS.PREPAY_AMOUNT_TYPE_Principal)){
				prepayPrincipalAmt = prepayAmount;
			}
			else	if(prepayAmountFlag.equals(ACCOUNT_CONSTANTS.PREPAY_AMOUNT_TYPE_Principal_Interest)){
				double prepayInterestAmt=getPrepayInterestAmt();
				if(prepayAmount<prepayInterestAmt) {
					return 0d;//�������Ľ��С����Ϣ���򱨴�
				}
				else prepayPrincipalAmt = Arith.round(prepayAmount-prepayInterestAmt, 2);
			}
			else throw new DataException("��Ч��PrepayAmountFlag��");
			if(prepayPrincipalAmt>actualNormalBalance) prepayPrincipalAmt=actualNormalBalance;
			return prepayPrincipalAmt;
		}
		
	}

	private void createPaymentSchedule() throws Exception{
		BusinessObject paymentSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,boManager);
		loan.setRelativeObject(paymentSchedule);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,paymentSchedule);
		paymentSchedule.setAttributeValue("ObjectType", loan.getObjectType());
		paymentSchedule.setAttributeValue("ObjectNo", loan.getObjectNo());
		
		
		paymentSchedule.setAttributeValue("SeqIDTransFer", nextPaymentSchedule.getString("SeqIDTransFer"));
		
		
		int currentPeriod = loan.getInt("CurrentPeriod");
		paymentSchedule.setAttributeValue("SeqID", currentPeriod);
		
		String prepayType = paymentBill.getString("PrepayType");// ��ǰ���ʽ��ȫ����������ǰ����
		if(ACCOUNT_CONSTANTS.PrepaymentType_All.equals(prepayType)){//ȫ����ǰ����
			paymentSchedule.setAttributeValue("PayType", ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay_All);// ���Ϊ��ǰ����
		}else{//������ǰ����
			paymentSchedule.setAttributeValue("PayType", ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay);// ���Ϊ��ǰ����
		}
		
		BusinessObject nextPaymentSchedule =this.getNextPaymentSchedule();
		String prepayInterestDaysFlag = paymentBill.getString("PrepayInterestDaysFlag");
		if(nextPaymentSchedule!=null&&prepayInterestDaysFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestFlag_NetNextInstalment)){//һ����ȡ�����ڹ�,������д��һ��
			paymentSchedule.setAttributeValue("InteDate", nextPaymentSchedule.getString("PayDate"));
			paymentSchedule.setAttributeValue("PayDate",  nextPaymentSchedule.getString("PayDate"));
		}else if(ACCOUNT_CONSTANTS.PrepaymentType_All.equals(prepayType)){
			paymentSchedule.setAttributeValue("InteDate", SystemConfig.getBusinessDate());
			paymentSchedule.setAttributeValue("PayDate", SystemConfig.getBusinessDate());
		}
		else{
			paymentSchedule.setAttributeValue("InteDate", transDate);
			paymentSchedule.setAttributeValue("PayDate", transDate);
		}
		
		paymentSchedule.setAttributeValue("PayPrincipalAmt",paymentBill.getDouble("PrePayPrincipalAmt"));
		paymentSchedule.setAttributeValue("ActualPayPrincipalAmt",paymentBill.getDouble("PrePayPrincipalAmt"));
		paymentSchedule.setAttributeValue("PayInteAmt",paymentBill.getDouble("PrePayInteAmt"));
		paymentSchedule.setAttributeValue("ActualPayInteAmt",paymentBill.getDouble("PrePayInteAmt"));

		paymentSchedule.setAttributeValue("PrincipalBalance", Arith.round(actualNormalBalance - paymentBill.getDouble("PrePayPrincipalAmt"), 2));
		//paymentSchedule.setAttributeValue("FinishDate", transDate);
		paymentSchedule.setAttributeValue("FinishDate", SystemConfig.getBusinessDate());
		paymentSchedule.setAttributeValue("SettleDate", SystemConfig.getBusinessDate());
		//paymentSchedule.setAttributeValue("SettleDate", transDate);
		paymentSchedule.setAttributeValue("LoanRate", loan.getRate("LoanRate"));
		String nextPayDate = loan.getString("NextDuedate");
		paymentSchedule.setAttributeValue("Remark","��ǰ����@" + transaction.getObjectNo() + "@" + nextPayDate);
		
		
		BusinessObject paymentLog=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.PaymentLog,boManager);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,paymentLog);
		loan.setRelativeObject(paymentLog);
		transaction.setRelativeObject(paymentLog);
		paymentLog.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));
		paymentLog.setAttributeValue("PSSerialNo", paymentSchedule.getString("SerialNo"));
		paymentLog.setAttributeValue("PayDate", paymentSchedule.getString("PayDate"));
		//paymentLog.setAttributeValue("ActualPayDate", transaction.getString("TransDate"));
		paymentLog.setAttributeValue("ActualPayDate", SystemConfig.getBusinessDate());
		paymentLog.setAttributeValue("ActualPayPrincipalAmt",paymentBill.getDouble("PrePayPrincipalAmt"));
		paymentLog.setAttributeValue("ACTUALPAYINTEAMT",paymentBill.getDouble("PrePayInteAmt"));
		paymentLog.setAttributeValue("LoanSerialNo", loan.getString("SerialNo"));
		//�������û���ƻ�
		if(paymentBill.getDouble("PayAmt") > normalbalance){
			double AccountManageFee = paymentBill.getDouble("AccountManageFee");//ʵ����������A7
			double CustomerServeFee = paymentBill.getDouble("CustomerServeFee");//ʵ���ͻ������A2
			double PayInSuranceFee = paymentBill.getDouble("PayInSuranceFee");//ʵ�����շ�A12
			double StampTax = paymentBill.getDouble("StampTax");//ʵ��ӡ��˰A10
			double PrePayMentFee = paymentBill.getDouble("PrePayMentFee");//ʵ����ǰ����������A9
			double bugPayAmt = paymentBill.getDouble("BugPayAmt");//ʵ�����Ļ������A18
			List<BusinessObject> feelists = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
			String feeSerialNo = "";//������ˮ��
			for(BusinessObject fee:feelists){
				if("A7".equals(fee.getString("FeeType")) && AccountManageFee>0){
					feeSerialNo = fee.getObjectNo();
					createFeePaymentSchedule("A7",paymentBill.getDouble("AccountManageFee"),feeSerialNo);
				}else if("A2".equals(fee.getString("FeeType")) && CustomerServeFee>0){
					feeSerialNo = fee.getObjectNo();
					createFeePaymentSchedule("A2",paymentBill.getDouble("CustomerServeFee"),feeSerialNo);
				}else if("A12".equals(fee.getString("FeeType")) && PayInSuranceFee>0){
					feeSerialNo = fee.getObjectNo();
					createFeePaymentSchedule("A12",paymentBill.getDouble("PayInSuranceFee"),feeSerialNo);
				}else if("A10".equals(fee.getString("FeeType")) && StampTax>0){
					feeSerialNo = fee.getObjectNo();
					createFeePaymentSchedule("A12",StampTax,feeSerialNo);
				}else if("A9".equals(fee.getString("FeeType")) && PrePayMentFee>0){
					feeSerialNo = fee.getObjectNo();
					createFeePaymentSchedule("A9",PrePayMentFee,feeSerialNo);
				}else if("A18".equals(fee.getString("FeeType")) && bugPayAmt>0){
					feeSerialNo = fee.getObjectNo();
					createFeePaymentSchedule("A18",bugPayAmt,feeSerialNo);
				}
				
			}
				
			
		}
		
	}
	private void createFeePaymentSchedule(String feeType,double feeAmt,String feeSerialNo) throws Exception{
		BusinessObject feePaymentSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.payment_schedule,boManager);
		loan.setRelativeObject(feePaymentSchedule);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,feePaymentSchedule);
		feePaymentSchedule.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
		feePaymentSchedule.setAttributeValue("ObjectNo", feeSerialNo);
		feePaymentSchedule.setAttributeValue("RelativeObjectType", loan.getObjectType());
		feePaymentSchedule.setAttributeValue("RelativeObjectNo", loan.getObjectNo());
		
		int currentPeriod = loan.getInt("CurrentPeriod");
		feePaymentSchedule.setAttributeValue("SeqID", currentPeriod);
		
		String prepayType = paymentBill.getString("PrepayType");// ��ǰ���ʽ��ȫ����������ǰ����
		if(ACCOUNT_CONSTANTS.PrepaymentType_All.equals(prepayType)){//ȫ����ǰ����
			feePaymentSchedule.setAttributeValue("PayType", ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay_All);// ���Ϊ��ǰ����
		}else{//������ǰ����
			feePaymentSchedule.setAttributeValue("PayType", ACCOUNT_CONSTANTS.PS_PAY_TYPE_Prepay);// ���Ϊ��ǰ����
		}
		
		BusinessObject nextPaymentSchedule =this.getNextPaymentSchedule();
		String prepayInterestDaysFlag = paymentBill.getString("PrepayInterestDaysFlag");
		if(nextPaymentSchedule!=null&&prepayInterestDaysFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestFlag_NetNextInstalment)){//һ����ȡ�����ڹ�,������д��һ��
			feePaymentSchedule.setAttributeValue("InteDate", nextPaymentSchedule.getString("PayDate"));
			feePaymentSchedule.setAttributeValue("PayDate",  nextPaymentSchedule.getString("PayDate"));
		}else if(ACCOUNT_CONSTANTS.PrepaymentType_All.equals(prepayType)){
			feePaymentSchedule.setAttributeValue("InteDate", SystemConfig.getBusinessDate());
			feePaymentSchedule.setAttributeValue("PayDate", SystemConfig.getBusinessDate());
		}
		else{
			feePaymentSchedule.setAttributeValue("InteDate", transDate);
			feePaymentSchedule.setAttributeValue("PayDate", transDate);
		}
		
		feePaymentSchedule.setAttributeValue("PayDate",  nextPaymentSchedule.getString("PayDate"));
		feePaymentSchedule.setAttributeValue("PayPrincipalAmt",Arith.round(feeAmt,2));
		feePaymentSchedule.setAttributeValue("ActualPayPrincipalAmt",Arith.round(feeAmt,2));
		
		//feePaymentSchedule.setAttributeValue("FinishDate", transDate);
		//feePaymentSchedule.setAttributeValue("SettleDate", transDate);
		feePaymentSchedule.setAttributeValue("FinishDate", SystemConfig.getBusinessDate());
		feePaymentSchedule.setAttributeValue("SettleDate", SystemConfig.getBusinessDate());
		String nextPayDate = loan.getString("NextDuedate");
		//feePaymentSchedule.setAttributeValue("Remark","��ǰ����(����)@" + transaction.getObjectNo() + "@" + nextPayDate);
		feePaymentSchedule.setAttributeValue("Remark",feeType);
		
		
		BusinessObject paymentLog=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.PaymentLog,boManager);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,paymentLog);
		loan.setRelativeObject(paymentLog);
		transaction.setRelativeObject(paymentLog);
		paymentLog.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));
		paymentLog.setAttributeValue("PSSerialNo", feePaymentSchedule.getString("SerialNo"));
		paymentLog.setAttributeValue("PayDate", feePaymentSchedule.getString("PayDate"));
		//paymentLog.setAttributeValue("ActualPayDate", transaction.getString("TransDate"));
		paymentLog.setAttributeValue("ActualPayDate", SystemConfig.getBusinessDate());
		paymentLog.setAttributeValue("ActualPayPrincipalAmt",Arith.round(feeAmt,2));
		paymentLog.setAttributeValue("LoanSerialNo", loan.getString("SerialNo"));
		
	}
	
	private BusinessObject getNextPaymentSchedule() throws Exception {

		if(this.nextPaymentSchedule!=null) return nextPaymentSchedule;
		ArrayList<BusinessObject> paymentScheduleList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		for(BusinessObject a:paymentScheduleList){
			String paydate=a.getString("PayDate");
			String payType=a.getString("PayType");
			if(payType!=null&&!payType.equals(ACCOUNT_CONSTANTS.PS_PAY_TYPE_Normal)) continue;
			if(paydate.compareTo(transDate)>=0){
				nextPaymentSchedule=a;
				break;
			}
		}
		return nextPaymentSchedule;
	}

	private void updateLoan() throws Exception{
		//���»���ƻ�
		loan.setAttributeValue("UPDATEPMTSCHDFLAG", "1");
				
		String prepayType = paymentBill.getString("PrepayType");// ��ǰ���ʽ��ȫ����������ǰ����
		if(prepayType.equals(ACCOUNT_CONSTANTS.PrepaymentType_Part_FixInstalment)){//���㻹��ƻ�ʱ��ǿ�Ʋ������ڹ�
			loan.setAttributeValue("UpdateInstalAmtFlag", "0");
		}
		else{
			loan.setAttributeValue("UpdateInstalAmtFlag", "1");
		}
		
		nextPaymentSchedule=this.getNextPaymentSchedule();
		String prepayInterestDaysFlag = paymentBill.getString("PrepayInterestDaysFlag");
		if(nextPaymentSchedule!=null&&prepayInterestDaysFlag.equals(ACCOUNT_CONSTANTS.Prepayment_InterestFlag_NetNextInstalment)){//һ����ȡ�����ڹ�
			//�����´λ�����,ԭ������һ�ڽ�����
			ArrayList<BusinessObject> rptList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
			if(rptList!=null&&!rptList.isEmpty()){
				for (BusinessObject rptSegment:rptList){
					String status = rptSegment.getString("Status");
					if(!status.equals("1")) continue; 
					rptSegment.setAttributeValue("LastDueDate", transDate);
					
					if(transDate.compareTo(rptSegment.getString("NextDueDate"))>=0) continue;//������
					RPTFunctions.getPMTScript(loan, rptSegment).nextInstalment(loan, rptSegment);
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, rptSegment);
				}
			}
		}
	}
}