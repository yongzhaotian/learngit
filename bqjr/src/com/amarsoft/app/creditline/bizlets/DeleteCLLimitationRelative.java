package com.amarsoft.app.creditline.bizlets;
/*
Author: --jbye 2005-09-01 9:51
Tester:
Describe: --ɾ�����������Ϣ
Input Param:
		sLineID������Э����
*/
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteCLLimitationRelative extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
	    SqlObject so = null;//��������
		//�Զ���ô���Ĳ���ֵ
		String sLineID   = (String)this.getAttribute("LineID");//--�ĵ����
		if(sLineID==null) sLineID="";
		//�������
		String sSql= "";
		//ɾ������������������Ϣ
		sSql = "delete from CL_LIMITATION_SET where LineID =:LineID "; 
		so = new SqlObject(sSql);
		so.setParameter("LineID",sLineID);
		Sqlca.executeSQL(so);
		//ɾ����������������Ϣ
		sSql = "delete from CL_LIMITATION where LineID =:LineID "; 
		so = new SqlObject(sSql);
		so.setParameter("LineID",sLineID);
		Sqlca.executeSQL(so);
		return null;
	 }
}
