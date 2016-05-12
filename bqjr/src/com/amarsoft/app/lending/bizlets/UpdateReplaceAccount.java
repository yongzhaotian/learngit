package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateReplaceAccount extends Bizlet 
{

	 public Object  run(Transaction Sqlca) throws Exception
		 {
			//获得参数：变更后的代扣账户名称NewAccountName、代扣账户号NewAccount、代扣账户行NewBankName、城市NewCity、还款方式NewRePaymentWay
		 	String sContractSerialno   = (String)this.getAttribute("ContractSerialno");
		 	String sCustomerID   = (String)this.getAttribute("CustomerID");
		 	String sNewAccountName   = (String)this.getAttribute("NewAccountName");
			String sNewBankName   = (String)this.getAttribute("NewBankName");
			String sAccountIndicator   = (String)this.getAttribute("AccountIndicator");
			String sNewAccount = (String)this.getAttribute("NewAccount");
			String sNewCity = (String)this.getAttribute("NewCity");
			String sRePaymentWay = (String)this.getAttribute("NewRePaymentWay");//还款方式1:代扣 2：非代扣
			String sNewBankBranch=(String)this.getAttribute("NewBankBranch"); //add by yzhang9 CCS-444  代扣账号开户行支行 
			
			if(sNewBankBranch == null) sNewBankBranch = "";//add by yzhang9 CCS-444 
			if(sContractSerialno == null) sContractSerialno = "";
			if(sCustomerID == null) sCustomerID = "";
			if(sNewAccountName == null) sNewAccountName = "";
			if(sNewBankName == null) sNewBankName = "";
			if(sAccountIndicator == null) sAccountIndicator = "";
			if(sNewAccount == null) sNewAccount = "";
			if(sNewCity == null) sNewCity = "";
			if(sRePaymentWay == null) sRePaymentWay = "";
			

			//定义变量
			String sSql = "";
			String updateADP = "";
			String updateBC = "";
			String updateWCI = "";
			String sFlag = "Success";
			ASResultSet rs = null;//存放结果集
			//SqlObject soBC; //声明对象
			//SqlObject soADP; //声明对象
			
			//更新客户下所有合同
			updateBC = "update business_contract set repaymentway='"+sRePaymentWay+"', "
					+ " openbank='"+sNewBankName+"', replaceaccount='"+sNewAccount+"',replacename='"+sNewAccountName+"',"
					+ " city = '"+sNewCity+"'"
					+ " , OpenBranch = '"+sNewBankBranch+"'"  // add by yzhang9 CCS-444 代扣账号开户行支行
					+ " where customerid='"+sCustomerID+"' ";

			updateADP = "update acct_deposit_accounts set accountno='"+sNewAccount+"',accountname='"+sNewAccountName+"' where accountindicator='01' and accounttype='01' and objectno in (select serialno from acct_loan al where al.customerid='"+sCustomerID+"') ";
			
			//更新完客户项下所有合同后，将代扣账户信息表WITHHOLD_CHARGE_INFO 的ApplicationType为07（代扣账户变更完成）\状态为02（已处理）
			updateWCI = "update WITHHOLD_CHARGE_INFO set ApplicationType='07',Status = '02'  where ContractSerialno= '"+sContractSerialno+"'";
				
/*			
			if(sRePaymentWay.equals("1")){
				soBC = new SqlObject(updateBC).setParameter("repaymentway", sRePaymentWay).setParameter("openbank", sNewBankName).setParameter("AccountNo", sNewAccount).setParameter("AccountName", sNewAccountName);
				soADP = new SqlObject(updateADP).setParameter("AccountNo", sNewAccount).setParameter("AccountName", sNewAccountName);
			}else{
				soBC = new SqlObject(updateBC).setParameter("repaymentway", sRePaymentWay);
				soADP = new SqlObject(updateADP).setParameter("AccountNo", DBKeyHelp.getSerialNo("acct_deposit_accounts", "serialno", "System")).setParameter("AccountName", sNewAccountName);
			}*/
			
			Sqlca.executeSQL(updateBC);
			Sqlca.executeSQL(updateADP);
			Sqlca.executeSQL(updateWCI);
		      
		    return sFlag;
		    
		 }

	}
