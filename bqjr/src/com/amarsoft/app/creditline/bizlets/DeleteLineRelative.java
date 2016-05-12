package com.amarsoft.app.creditline.bizlets;
/*
Author: --jbye 2005-09-01 9:51
Tester:
Describe: --ɾ�����������Ϣ
Input Param:
		sLineID������Э����

Output Param:
* @updatesuer:yhshan
* @updatedate:2012/09/12
HistoryLog:
*/

import com.amarsoft.app.lending.bizlets.DeleteBusiness;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteLineRelative extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ
		String sLineID   = (String)this.getAttribute("LineID");//--�ĵ����
		if(sLineID==null) sLineID="";
		//�������
		String sSql= "";
		
		//ɾ�����Ŷ����Ϣ
		sSql = 	" update CL_INFO set BCSerialNo = null where BCSerialNo =:BCSerialNo ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("BCSerialNo", sLineID);
        Sqlca.executeSQL(so);
		
	    //ɾ������Э����Ϣ
		Bizlet bzDeleteBusiness = new DeleteBusiness();
		bzDeleteBusiness.setAttribute("ObjectType","BusinessContract"); 
		bzDeleteBusiness.setAttribute("ObjectNo",sLineID);
		bzDeleteBusiness.setAttribute("DeleteType","DeleteBusiness");
		bzDeleteBusiness.run(Sqlca);		
			
		return null;
	 }
}
