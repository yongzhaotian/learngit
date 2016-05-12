package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetCustomerID extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		if(sObjectType==null) sObjectType="";
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo==null) sObjectNo="";
		String sCustomerID = "" ;
		SqlObject so=null;
		String sSql = " select ObjectTable from OBJECTTYPE_CATALOG where ObjectType =:ObjectType ";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType);
		String sTableName = Sqlca.getString(so);
		if(sTableName!=null&&!sObjectNo.equals("")){
			sSql = "select CustomerID from "+sTableName+" where SerialNo=:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			sCustomerID = Sqlca.getString(so);
		}
		return sCustomerID;
	}

}
