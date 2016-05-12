package com.amarsoft.app.lending.bizlets;
/*
Author: --王业罡 2005-08-03
Tester:
Describe: --删除文档关联信息
Input Param:
		sDocNo：文档编号

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
	    SqlObject so ;//声明对象
	    //自动获得传入的参数值
		String sDocNo = (String)this.getAttribute("DocNo");//--文档编号
		if(sDocNo == null) sDocNo = "";
		//定义变量
		String sSql = " delete from DOC_RELATIVE where DocNo =:DocNo ";
		so = new SqlObject(sSql).setParameter("DocNo", sDocNo);
		Sqlca.executeSQL(so);
		sSql = " delete from DOC_ATTACHMENT  where DocNo =:DocNo ";
		so = new SqlObject(sSql).setParameter("DocNo", sDocNo);
	    Sqlca.executeSQL(so);
	    return null;
	 }
}
