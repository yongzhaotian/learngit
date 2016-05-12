package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetGroupCustomerID extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//获取业务类型和业务流水号
		String sObjectType = (String)this.getAttribute("ObjectType");
		if(sObjectType==null) sObjectType="";
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo==null) sObjectNo="";
		String sCustomerID = "" ;
		SqlObject so ;
		String sSql = " select ObjectTable from OBJECTTYPE_CATALOG where ObjectType =:ObjectType ";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType);
		String sTableName = Sqlca.getString(so);
		if(sTableName!=null&&!sObjectNo.equals("")){
			sSql = "select CustomerID from "+sTableName+" where SerialNo=:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			sCustomerID = Sqlca.getString(so);//获取此笔业务的客户的CustomerID
			
			sSql = "select GROUPID from GROUP_FAMILY_MEMBER where MEMBERCUSTOMERID =:customerid";
			so = new SqlObject(sSql).setParameter("customerid", sCustomerID);
			sCustomerID = Sqlca.getString(so);//获取该客户所在关联集团的CustomerID,该CustomerID等于GROUPID
		}
		return sCustomerID;
		
	}


}
