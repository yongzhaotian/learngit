package com.amarsoft.app.accounting.web.bizlets;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 放款测算
 * @author 
 * 
 */
public class PutOutLoanTry extends Bizlet {
	private BusinessObject transaction ;
	/**
	 * 放款测算
	 * @throws Exception
	 */
	public Object run(Transaction Sqlca) throws Exception {
		String ObjectNO = (String)this.getAttribute("ObjectNO");
		if(ObjectNO == null || "".equals(ObjectNO))
		{
			throw new Exception("合同流水为空！");
		}
		//BusinessObject bill = this.run(ObjectNO, Sqlca);
		String bill = this.run(ObjectNO, Sqlca);
		//return DataConvert.toMoney(bill.getDouble("TotalAmt"));
		return bill;
	}
	
	public String execute(String ObjectNO,Transaction Sqlca) throws Exception
	{
		return this.run(ObjectNO, Sqlca);
	}
	

	
	public String run(String contractserialno,Transaction Sqlca) throws Exception
	{
		if(contractserialno == null || "".equals(contractserialno))
		{
			throw new Exception("合同流水为空！");
		}
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		BusinessObject documentObject = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_contract, contractserialno);
		BusinessObject relativeObject = null;
		if(relativeObject==null) relativeObject = documentObject;
		
		//加载关联交易
		ASValuePool as =  new ASValuePool();
		as.setAttribute("DocumentType", BUSINESSOBJECT_CONSTATNTS.business_contract);
		as.setAttribute("DocumentSerialNo",contractserialno);
		as.setAttribute("TransDate", SystemConfig.getBusinessDate());
		List<BusinessObject> transactionList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.transaction, "DocumentType=:DocumentType and DocumentSerialNo=:DocumentSerialNo", as);
		

		if(transactionList == null || transactionList.isEmpty()){
			transaction = TransactionFunctions.createTransaction("0020",documentObject,relativeObject,"System",SystemConfig.getBusinessDate(), bom);
			//bom.updateDB();
		}
		else{
			transaction = transactionList.get(0);
		}
		
		//到期日
		if("".equals(documentObject.getString("Maturity"))||documentObject.getString("Maturity")==null){
			String sMaturity = DateFunctions.getRelativeDate(SystemConfig.getBusinessDate(), DateFunctions.TERM_UNIT_MONTH, documentObject.getInt("Periods"));
			documentObject.setAttributeValue("Maturity", sMaturity);
			bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,documentObject);
		}
		
		transaction = TransactionFunctions.loadTransaction(transaction, bom);
		TransactionFunctions.runTransaction(transaction, bom);
		//bom.updateDB();
		//首期应付总金额
		double totalSum = 0.0;
		double totalSum2 = 0.0;
		double totalSumEnd = 0.0;
		double totalPaylAmt1 = 0.0;
		double totalPaylAmt2 = 0.0;
		//double totalSum = DataConvert.toDouble(Sqlca.getString("SELECT sum(nvl(aps.payprincipalamt, 0) + nvl(aps.payinteamt, 0)) FROM acct_payment_schedule aps where aps.seqid='1' and ((aps.objectno =(SELECT serialno FROM acct_loan where putoutno = '"+contractserialno+"') and aps.objecttype = 'jbo.app.ACCT_LOAN') or (aps.relativeobjectno =(SELECT serialno FROM acct_loan where putoutno = '"+contractserialno+"') and aps.relativeobjecttype = 'jbo.app.ACCT_LOAN'))"));
		//double totalSum2 = DataConvert.toDouble(Sqlca.getString("SELECT sum(nvl(aps.payprincipalamt, 0) + nvl(aps.payinteamt, 0)) FROM acct_payment_schedule aps where aps.seqid='2' and ((aps.objectno =(SELECT serialno FROM acct_loan where putoutno = '"+contractserialno+"') and aps.objecttype = 'jbo.app.ACCT_LOAN') or (aps.relativeobjectno =(SELECT serialno FROM acct_loan where putoutno = '"+contractserialno+"') and aps.relativeobjecttype = 'jbo.app.ACCT_LOAN'))"));
		//double totalSumEnd = DataConvert.toDouble(Sqlca.getString("SELECT sum(nvl(aps.payprincipalamt, 0) + nvl(aps.payinteamt, 0)) FROM acct_payment_schedule aps where aps.seqid=(SELECT bc.periods FROM business_contract bc where bc.serialno='"+contractserialno+"') and ((aps.objectno =(SELECT serialno FROM acct_loan where putoutno = '"+contractserialno+"') and aps.objecttype = 'jbo.app.ACCT_LOAN') or (aps.relativeobjectno =(SELECT serialno FROM acct_loan where putoutno = '"+contractserialno+"') and aps.relativeobjecttype = 'jbo.app.ACCT_LOAN'))"));

		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		int month = DateFunctions.getMonths(loan.getString("PutOutDate"), loan.getString("MaturityDate"));
		
		List<BusinessObject> pslists = new ArrayList<BusinessObject>();
		List<BusinessObject> psloans = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
		//本金
		if(psloans != null && !psloans.isEmpty()){
			for(BusinessObject psloan:psloans){
				if("1".equals(psloan.getString("SeqID")) || "2".equals(psloan.getString("SeqID")) || month==psloan.getInt("SeqID")){
					pslists.add(psloan);
				}
			}
		}
		//费用
		List<BusinessObject> feeList=loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(feeList!=null && !feeList.isEmpty()){
			for(BusinessObject fee:feeList){
				String feeNo = fee.getObjectNo();
				List<BusinessObject> psfees = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
				if(psfees != null && !psfees.isEmpty()){
					for(BusinessObject psfee:psfees){
						if("1".equals(psfee.getString("SeqID")) || "2".equals(psfee.getString("SeqID")) || month==psfee.getInt("SeqID")){
							pslists.add(psfee);
						}
					}
				}
			}
		}
		
		//月总值
		if(pslists!=null&&!pslists.isEmpty()){
			for(BusinessObject ps:pslists){
				if("1".equals(ps.getString("SeqID"))){
					totalSum += ps.getDouble("PayPrincipalAmt");
					totalSum += ps.getDouble("PayInteAmt");
					if("1".equals(ps.getString("PayType"))){
						totalPaylAmt1 += ps.getDouble("PayPrincipalAmt");
						totalPaylAmt1 += ps.getDouble("PayInteAmt");
					}
				}
				if("2".equals(ps.getString("SeqID"))){
					totalSum2 += ps.getDouble("PayPrincipalAmt");
					totalSum2 += ps.getDouble("PayInteAmt");
					if("1".equals(ps.getString("PayType"))){
						totalPaylAmt2 += ps.getDouble("PayPrincipalAmt");
						totalPaylAmt2 += ps.getDouble("PayInteAmt");
					}
				}
				if(month==ps.getInt("SeqID")){
					totalSumEnd += ps.getDouble("PayPrincipalAmt");
					totalSumEnd += ps.getDouble("PayInteAmt");
				}
			}
		}
		
		String returnvalue = totalSum+"@"+totalSum2+"@"+totalSumEnd+"@"+totalPaylAmt1+"@"+totalPaylAmt2;
		double tempSum = 0;
		if(totalSum2 < totalSumEnd) tempSum = totalSumEnd;
		else tempSum = totalSum2;
			
		//this.updateBC(documentObject.getString("SerialNo"),totalSum,tempSum,Sqlca);
		bom.close();
		ARE.getLog().debug("第一期应还总金额："+totalSum+" 第二期应还总金额："+totalSum2+" 最后一期应还总金额："+totalSumEnd+" 第一期应还本息："+totalPaylAmt1+" 第二期应还本息："+totalPaylAmt2);
		
		return returnvalue;
	}
	
	private String updateBC(String objectNo,double totalSum, double totalSum2, Transaction Sqlca) throws Exception
	{
		String sql = "update Business_Contract set FIRSTDRAWINGDATE = "+fix(totalSum)+",MonthRepayment = "+fix(totalSum2)+" where serialno='"+objectNo+"' ";
		Sqlca.executeSQL(sql);
		
		return "true";
	}
	
	/**
	 * 小数进位 
	 * @param objectNo
	 * @param totalSum
	 * @param totalSum2
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	 
	private double fix(double d) throws Exception
	{
		//ARE.getLog().debug("···········进位前："+d);
		double temp = d * 10;
		double value1 = Math.ceil(temp);//进位取整
		double finalyvalue = value1/10;
		if(d==Math.floor(d)){
			finalyvalue = d;
		}
		//ARE.getLog().debug("···········进位后："+finalyvalue);
		return finalyvalue;
	}

	public BusinessObject getTransaction() {
		return transaction;
	}

	public void setTransaction(BusinessObject transaction) {
		this.transaction = transaction;
	}
}
