package com.amarsoft.app.accounting.trans.script.loan.repay;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;

public class PaymentBillCreator implements ITransactionCreator {
	
	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject paymentBill = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		paymentBill.setAttributeValue("ObjectNo", loan.getString("SerialNo"));
		paymentBill.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.loan);
		paymentBill.setAttributeValue("TransCode", transaction.getString("TransCode"));
		paymentBill.setAttributeValue("Currency", loan.getString("Currency"));
		paymentBill.setAttributeValue("AccountingOrgID", loan.getString("AccountingOrgID"));
		
		if(paymentBill.getDouble("PayAmt") == 0) paymentBill.setAttributeValue("PayAmt", loan.getDouble("NormalBalance")+loan.getDouble("OverdueBalance")+loan.getDouble("ODInteBalance")+loan.getDouble("CompdInteBalance")+loan.getDouble("FineInteBalance")+loan.getDouble("AccrueInteBalance"));
		if(paymentBill.getDouble("ActualPayAmt") == 0) paymentBill.setAttributeValue("ActualPayAmt", 0.0d);
		if(paymentBill.getDouble("PayPrincipalAmt")==0d)	paymentBill.setAttributeValue("PayPrincipalAmt", loan.getDouble("NormalBalance"));
		if(paymentBill.getDouble("ActualPayPrincipalAmt")==0d)	paymentBill.setAttributeValue("ActualPayPrincipalAmt", 0d);
		if(paymentBill.getDouble("PayODPrincipalAmt")==0d)	paymentBill.setAttributeValue("PayODPrincipalAmt", loan.getDouble("OverdueBalance"));
		if(paymentBill.getDouble("ActualPayODPrincipalAmt")==0d)	paymentBill.setAttributeValue("ActualPayODPrincipalAmt", 0d);
		if(paymentBill.getDouble("PayInteAmt")==0d)	paymentBill.setAttributeValue("PayInteAmt", loan.getDouble("AccrueInteBalance"));
		if(paymentBill.getDouble("ActualPayInteAmt")==0d)	paymentBill.setAttributeValue("ActualPayInteAmt", 0d);
		if(paymentBill.getDouble("PayODInteAmt")==0d)	paymentBill.setAttributeValue("PayODInteAmt", loan.getDouble("ODInteBalance"));
		if(paymentBill.getDouble("ActualPayODInteAmt")==0d)	paymentBill.setAttributeValue("ActualPayODInteAmt", 0d);
		if(paymentBill.getDouble("PayFineAmt")==0d)	paymentBill.setAttributeValue("PayFineAmt", loan.getDouble("FineInteBalance"));
		if(paymentBill.getDouble("ActualPayFineAmt")==0d)	paymentBill.setAttributeValue("ActualPayFineAmt", 0d);
		if(paymentBill.getDouble("PayCompdInteAmt")==0d)	paymentBill.setAttributeValue("PayCompdInteAmt", loan.getDouble("CompdInteBalance"));
		if(paymentBill.getDouble("ActualPayCompdInteAmt")==0d)	paymentBill.setAttributeValue("ActualPayCompdInteAmt", 0d);
		if(paymentBill.getDouble("PrePayPrincipalAmt")==0d)	paymentBill.setAttributeValue("PrePayPrincipalAmt", 0d);
		if(paymentBill.getDouble("PrePayInteAmt")==0d)	paymentBill.setAttributeValue("PrePayInteAmt", 0d);
		
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, paymentBill);
		
		return transaction;
	}
	
}
