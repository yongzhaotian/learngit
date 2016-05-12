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
			//��ò����������Ĵ����˻�����NewAccountName�������˻���NewAccount�������˻���NewBankName������NewCity�����ʽNewRePaymentWay
		 	String sContractSerialno   = (String)this.getAttribute("ContractSerialno");
		 	String sCustomerID   = (String)this.getAttribute("CustomerID");
		 	String sNewAccountName   = (String)this.getAttribute("NewAccountName");
			String sNewBankName   = (String)this.getAttribute("NewBankName");
			String sAccountIndicator   = (String)this.getAttribute("AccountIndicator");
			String sNewAccount = (String)this.getAttribute("NewAccount");
			String sNewCity = (String)this.getAttribute("NewCity");
			String sRePaymentWay = (String)this.getAttribute("NewRePaymentWay");//���ʽ1:���� 2���Ǵ���
			String sNewBankBranch=(String)this.getAttribute("NewBankBranch"); //add by yzhang9 CCS-444  �����˺ſ�����֧�� 
			
			if(sNewBankBranch == null) sNewBankBranch = "";//add by yzhang9 CCS-444 
			if(sContractSerialno == null) sContractSerialno = "";
			if(sCustomerID == null) sCustomerID = "";
			if(sNewAccountName == null) sNewAccountName = "";
			if(sNewBankName == null) sNewBankName = "";
			if(sAccountIndicator == null) sAccountIndicator = "";
			if(sNewAccount == null) sNewAccount = "";
			if(sNewCity == null) sNewCity = "";
			if(sRePaymentWay == null) sRePaymentWay = "";
			

			//�������
			String sSql = "";
			String updateADP = "";
			String updateBC = "";
			String updateWCI = "";
			String sFlag = "Success";
			ASResultSet rs = null;//��Ž����
			//SqlObject soBC; //��������
			//SqlObject soADP; //��������
			
			//���¿ͻ������к�ͬ
			updateBC = "update business_contract set repaymentway='"+sRePaymentWay+"', "
					+ " openbank='"+sNewBankName+"', replaceaccount='"+sNewAccount+"',replacename='"+sNewAccountName+"',"
					+ " city = '"+sNewCity+"'"
					+ " , OpenBranch = '"+sNewBankBranch+"'"  // add by yzhang9 CCS-444 �����˺ſ�����֧��
					+ " where customerid='"+sCustomerID+"' ";

			updateADP = "update acct_deposit_accounts set accountno='"+sNewAccount+"',accountname='"+sNewAccountName+"' where accountindicator='01' and accounttype='01' and objectno in (select serialno from acct_loan al where al.customerid='"+sCustomerID+"') ";
			
			//������ͻ��������к�ͬ�󣬽������˻���Ϣ��WITHHOLD_CHARGE_INFO ��ApplicationTypeΪ07�������˻������ɣ�\״̬Ϊ02���Ѵ���
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
