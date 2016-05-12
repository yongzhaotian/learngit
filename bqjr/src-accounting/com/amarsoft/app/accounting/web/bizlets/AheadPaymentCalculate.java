package com.amarsoft.app.accounting.web.bizlets;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ��ǰ�������
 * @author xuzhiming 2013/01/06
 * 
 */
public class AheadPaymentCalculate extends Bizlet {
	/**
	 * ��ǰ�������
	 * @throws Exception
	 */
	public Object run(Transaction Sqlca) throws Exception {
		String transactionSerialNo = (String)this.getAttribute("TransactionSerialNo");
		if(transactionSerialNo == null || "".equals(transactionSerialNo))
		{
			throw new Exception("������ˮΪ�գ�");
		}
		BusinessObject bill = this.run(transactionSerialNo, Sqlca);
		return DataConvert.toMoney(bill.getDouble("TotalAmt"));
	}
	
	public BusinessObject execute(String transactionSerialNo,Transaction Sqlca) throws Exception
	{
		return this.run(transactionSerialNo, Sqlca);
	}
	
	public BusinessObject run(String transactionSerialNo,Transaction Sqlca) throws Exception
	{
		if(transactionSerialNo == null || "".equals(transactionSerialNo))
		{
			throw new Exception("������ˮΪ�գ�");
		}
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		BusinessObject transaction = TransactionFunctions.loadTransaction(transactionSerialNo, bom);
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		String sTransDate = transaction.getString("TransDate");
		//������Ч���ڲ����ڵ���Ľ��л��ս��׵Ĵ���
		if(sTransDate.compareTo(loan.getString("BusinessDate"))>0){
			String date_9090=DateFunctions.getRelativeDate(sTransDate, DateFunctions.TERM_UNIT_DAY, -1);
			BusinessObject eodTransaction = TransactionFunctions.createTransaction("9090",null,loan,"",date_9090,bom);
			TransactionFunctions.runTransaction(eodTransaction, bom);
		}
		
		TransactionFunctions.runTransaction(transaction, bom);
		
		BusinessObject paymentBillBusinessObject = transaction.getRelativeObject(transaction.getString("DocumentType"),transaction.getString("DocumentSerialNo"));
		bom.close();
		
		AbstractBusinessObjectManager bom1 =new DefaultBusinessObjectManager(Sqlca);
		bom1.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, paymentBillBusinessObject);
		bom1.updateDB();
		Sqlca.commit();
		com.amarsoft.app.accounting.util.FeeFunctions.updateFeeAmount(transactionSerialNo,Sqlca);
		//�˻������
		double feeAmt = DataConvert.toDouble(Sqlca.getString("select sum(nvl(f.actualfeeamount,0 )) from acct_fee_log f where f.transactionserialno = '"+transactionSerialNo+"' and f.feetype in ('N1')"));
		//��ǰ����ΥԼ��
		double pundAmt = DataConvert.toDouble(Sqlca.getString("select sum(nvl(f.actualfeeamount,0 )) from acct_fee_log f where f.transactionserialno = '"+transactionSerialNo+"' and f.feetype not in ('N1')"));
		//�ܽ��
		double totalAmt = paymentBillBusinessObject.getDouble("PrePayPrincipalAmt")
				+paymentBillBusinessObject.getDouble("PrePayInteAmt")
				+paymentBillBusinessObject.getDouble("ActualPayPrincipalAmt")
				+paymentBillBusinessObject.getDouble("ActualPayInteAmt")
				+paymentBillBusinessObject.getDouble("ActualPayODPrincipalAmt")
				+paymentBillBusinessObject.getDouble("ActualPayODInteAmt")
				+paymentBillBusinessObject.getDouble("ActualPayFineAmt")
				+paymentBillBusinessObject.getDouble("ActualPayCompdInteAmt") ;
		
		paymentBillBusinessObject.setAttributeValue("FeeAmt", feeAmt);
		paymentBillBusinessObject.setAttributeValue("PundAmt", pundAmt);
		paymentBillBusinessObject.setAttributeValue("TotalAmt", totalAmt+feeAmt + pundAmt);
		paymentBillBusinessObject.setAttributeValue("PayAmt", totalAmt);
		bom1.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, paymentBillBusinessObject);
		bom1.updateDB();
		return paymentBillBusinessObject;
	}
}
