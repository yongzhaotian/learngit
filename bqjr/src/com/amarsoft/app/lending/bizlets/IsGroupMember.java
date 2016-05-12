package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class IsGroupMember extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//��ȡҵ�����ͺ�ҵ����ˮ��
		String sObjectType = (String)this.getAttribute("ObjectType");		
		if(sObjectType==null) sObjectType="";
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo==null) sObjectNo="";
		String sCustomerID = "" ;
		String mark = "1";//����һ���ж��Ƿ�Ϊ���ſͻ��ı�־����
		SqlObject so;
		String sSql = " select ObjectTable from OBJECTTYPE_CATALOG where ObjectType =:ObjectType ";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType);
		String sTableName = Sqlca.getString(so);
		
		if(sTableName!=null&&!sObjectNo.equals("")){
			sSql = "select CustomerID from "+sTableName+" where SerialNo=:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			sCustomerID = Sqlca.getString(so);
			sSql = "select GROUPID from GROUP_FAMILY_MEMBER where MEMBERCUSTOMERID =:customerid";
			so = new SqlObject(sSql).setParameter("customerid", sCustomerID);
			sCustomerID = Sqlca.getString(so);//��ȡ�ÿͻ����ڹ������ŵ�CustomerID,,��CustomerID����GROUPID
			
			if(sCustomerID != null && !sCustomerID.equals("") )
			{
				mark = "2";//�ֶ�ֵΪ2���Ǽ��ſͻ���������Ϊ��ʼֵ1
			}						
		}		
		return mark;
	}
}