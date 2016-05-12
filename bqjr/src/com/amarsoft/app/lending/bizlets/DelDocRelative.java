package com.amarsoft.app.lending.bizlets;
/*
Author: --��ҵ� 2005-08-03
Tester:
Describe: --ɾ���ĵ�������Ϣ
Input Param:
		sDocNo���ĵ����

Output Param:

HistoryLog:
*/
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class DelDocRelative extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
	    SqlObject so ;//��������
	    //�Զ���ô���Ĳ���ֵ
		String sDocNo = (String)this.getAttribute("DocNo");//--�ĵ����
		if(sDocNo == null) sDocNo = "";
		//�������
		String sSql = " delete from DOC_RELATIVE where DocNo =:DocNo ";
		so = new SqlObject(sSql).setParameter("DocNo", sDocNo);
		Sqlca.executeSQL(so);
		sSql = " delete from DOC_ATTACHMENT  where DocNo =:DocNo ";
		so = new SqlObject(sSql).setParameter("DocNo", sDocNo);
	    Sqlca.executeSQL(so);
	    return null;
	 }
}
