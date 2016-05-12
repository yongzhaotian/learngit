package com.amarsoft.app.lending.bizlets;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckLoanCardNoChangeCustomer extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//自动获得传入的参数值
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sLoanCardNo = (String)this.getAttribute("LoanCardNo");
		if(sCustomerID == null) sCustomerID = "";
		if(sLoanCardNo == null) sLoanCardNo = "";
		ASResultSet rs = null;
		
		//返回标志
		String sFlag = "";
		String sExistCustomerID ="";
		
		String sSql = " select CustomerID from CUSTOMER_INFO where  substr(LoanCardNo,1,16) = '"+sLoanCardNo.substring(0,16)+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sExistCustomerID = rs.getString("CustomerID");
		}
		rs.getStatement().close();

		if(sExistCustomerID == null) sExistCustomerID = "";
		
		if(sExistCustomerID.equals(""))
			sFlag = "Only";
		else
		{
			if(sExistCustomerID.equals(sCustomerID))
				sFlag = "Only";
			else{
				sFlag = "Many";
			}
		}
		
		return sFlag;
	}
}
