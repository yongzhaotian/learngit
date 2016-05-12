package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ȡ���ͻ��϶�����
 * @author 
 *
 */
public class CancelSMECusApply extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		if(sObjectNo == null) sObjectNo = "";
		String sSql = "";
		ASResultSet rs=null;
		String sCustomerID = "";
		SqlObject so = null;//��������
		sSql = 	" select CustomerID from SME_APPLY"+
		" where SerialNo=:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			sCustomerID=rs.getString("CustomerID");
		}
		if(sCustomerID==null) sCustomerID="";
		rs.getStatement().close();

		//�������õȼ���¼��
		sSql = " UPDATE CUSTOMER_INFO SET Status='0' "+
		   " WHERE CustomerID=:CustomerID ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
	    Sqlca.executeSQL(so);
	
		//ɾ��������Ϣ
	    sSql = "delete from SME_APPLY where SerialNo =:SerialNo ";
	    so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		
		/*
		 * ɾ�����������Ϣ		  
		*/
		Bizlet bzCancelFlow = new CancelFlow();
		bzCancelFlow.setAttribute("ObjectNo",sObjectNo); 
		bzCancelFlow.run(Sqlca);				
				
		return "OK";
	}		
}
