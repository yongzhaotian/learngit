package com.amarsoft.app.lending.bizlets;
/**
 * �ж�������˻��Ƿ����˻������Ѿ��Ǽ�
 * @author smiao  2011.06.07
 * 
 * 
 */


import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckRegister extends Bizlet{
	
	public Object run(Transaction Sqlca) throws Exception {
		
		//�Զ���ô���Ĳ���ֵ
		String sFundbackAccount=(String)this.getAttribute("FundbackAccount");
		String sRequitalAccount=(String)this.getAttribute("RequitalAccount");
		String sCustomerID=(String)this.getAttribute("CustomerID");
		//�������
		String sAccount = "";
		String sAICustomerID = "";
		String sSql = "";
		String flagRegister = "";
				
		sSql = "select Account,CustomerID from ACCOUNT_INFO where Account = :sFundbackAccount or Account = :sRequitalAccount ";
		
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sRequitalAccount", sRequitalAccount).setParameter("sFundbackAccount", sFundbackAccount));
		
		if(rs.next()){
			sAccount = rs.getString("Account");
			sAICustomerID = rs.getString("CustomerID");
		}
		if(sAICustomerID.equals(sCustomerID) &&(!sAccount.equals(""))){
			flagRegister = "true";
		}else if((!sAICustomerID.equals(sCustomerID)) && (!sAccount.equals(""))){
			flagRegister = "own";
		}else {
			flagRegister = "false";
		}
		rs.getStatement().close();
		return flagRegister;
	}
}
