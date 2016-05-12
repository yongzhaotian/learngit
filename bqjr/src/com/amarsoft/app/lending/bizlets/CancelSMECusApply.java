package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 取消客户认定申请
 * @author 
 *
 */
public class CancelSMECusApply extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		String sSql = "";
		ASResultSet rs=null;
		String sCustomerID = "";
		SqlObject so = null;//声明对象
		sSql = 	" select CustomerID from SME_APPLY"+
		" where SerialNo=:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			sCustomerID=rs.getString("CustomerID");
		}
		if(sCustomerID==null) sCustomerID="";
		rs.getStatement().close();

		//更新信用等级记录表
		sSql = " UPDATE CUSTOMER_INFO SET Status='0' "+
		   " WHERE CustomerID=:CustomerID ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
	    Sqlca.executeSQL(so);
	
		//删除申请信息
	    sSql = "delete from SME_APPLY where SerialNo =:SerialNo ";
	    so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		
		/*
		 * 删除流程相关信息		  
		*/
		Bizlet bzCancelFlow = new CancelFlow();
		bzCancelFlow.setAttribute("ObjectNo",sObjectNo); 
		bzCancelFlow.run(Sqlca);				
				
		return "OK";
	}		
}
