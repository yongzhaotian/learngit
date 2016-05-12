package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class DeleteRelation extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值		
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sRelativeID   = (String)this.getAttribute("RelativeID");
		String sRelationShip = (String)this.getAttribute("RelationShip");
		
		//定义变量
		ASResultSet rs = null;
		String sItemDescribe = null;
		String sSql = null;
		SqlObject so ;//声明对象
		//根据参数获取需要的值
		sSql="select ItemDescribe from CODE_LIBRARY where CODENO = 'RelationShip' and ITEMNO =:ITEMNO ";
		so = new SqlObject(sSql).setParameter("ITEMNO", sRelationShip);
		rs = Sqlca.getResultSet(so);
		
	    if(rs.next())
	    {
	    	sItemDescribe = rs.getString(1);
	    }
	    
	    rs.getStatement().close();
	    sSql = 	" delete from CUSTOMER_RELATIVE where CUSTOMERID=:CUSTOMERID "+
    	" and RELATIVEID=:RELATIVEID "+
    	" and RELATIONSHIP=:RELATIONSHIP ";
	    so = new SqlObject(sSql).setParameter("CUSTOMERID", sRelativeID).setParameter("RELATIVEID", sCustomerID).setParameter("RELATIONSHIP", sItemDescribe);
        Sqlca.executeSQL(so);
	    return "1";
	 }

}
