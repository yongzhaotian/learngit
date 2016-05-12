package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CreateAccount extends Bizlet {

	 public Object  run(Transaction Sqlca) throws Exception {	
		 	
		 	String sSerialno = (String)this.getAttribute("SerialNo");//贷款卡流水
			//对象编号
			String sAccountIdicator = (String)this.getAttribute("AccountIdicator");//账户性质
			String sAccountNo = (String)this.getAttribute("AccountNo");//账号
			String sAccountName = (String)this.getAttribute("AccountName");//账户名称
			String sObjectNo = (String)this.getAttribute("ObjectNo");//对象编号
			String sObjectType = (String)this.getAttribute("ObjectType");//对象编号
			
			String sSql  = "";
			
			//插入账户AccountIdicator:00：放款 01：还款
			sSql = "insert into acct_deposit_accounts (SERIALNO, OBJECTNO, OBJECTTYPE, ACCOUNTTYPE, ACCOUNTNO, ACCOUNTCURRENCY, ACCOUNTNAME, ACCOUNTFLAG, PRI, ACCOUNTORGID, ACCOUNTINDICATOR, STATUS) "+
					"values ('"+sSerialno+"', '"+sObjectNo+"', '"+sObjectType+"', '01', '"+sAccountNo+"', '01', '"+sAccountName+"', '2', '1', '', '"+sAccountIdicator+"', '0')";
			Sqlca.executeSQL(sSql);
			
		    return "1";
		    
		 }
	}

