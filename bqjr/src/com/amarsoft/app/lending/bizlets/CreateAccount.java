package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CreateAccount extends Bizlet {

	 public Object  run(Transaction Sqlca) throws Exception {	
		 	
		 	String sSerialno = (String)this.getAttribute("SerialNo");//�����ˮ
			//������
			String sAccountIdicator = (String)this.getAttribute("AccountIdicator");//�˻�����
			String sAccountNo = (String)this.getAttribute("AccountNo");//�˺�
			String sAccountName = (String)this.getAttribute("AccountName");//�˻�����
			String sObjectNo = (String)this.getAttribute("ObjectNo");//������
			String sObjectType = (String)this.getAttribute("ObjectType");//������
			
			String sSql  = "";
			
			//�����˻�AccountIdicator:00���ſ� 01������
			sSql = "insert into acct_deposit_accounts (SERIALNO, OBJECTNO, OBJECTTYPE, ACCOUNTTYPE, ACCOUNTNO, ACCOUNTCURRENCY, ACCOUNTNAME, ACCOUNTFLAG, PRI, ACCOUNTORGID, ACCOUNTINDICATOR, STATUS) "+
					"values ('"+sSerialno+"', '"+sObjectNo+"', '"+sObjectType+"', '01', '"+sAccountNo+"', '01', '"+sAccountName+"', '2', '1', '', '"+sAccountIdicator+"', '0')";
			Sqlca.executeSQL(sSql);
			
		    return "1";
		    
		 }
	}

