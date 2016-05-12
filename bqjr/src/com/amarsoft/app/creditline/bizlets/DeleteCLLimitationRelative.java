package com.amarsoft.app.creditline.bizlets;
/*
Author: --jbye 2005-09-01 9:51
Tester:
Describe: --删除授信相关信息
Input Param:
		sLineID：授信协议编号
*/
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteCLLimitationRelative extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
	    SqlObject so = null;//声明对象
		//自动获得传入的参数值
		String sLineID   = (String)this.getAttribute("LineID");//--文档编号
		if(sLineID==null) sLineID="";
		//定义变量
		String sSql= "";
		//删除授信条件限制组信息
		sSql = "delete from CL_LIMITATION_SET where LineID =:LineID "; 
		so = new SqlObject(sSql);
		so.setParameter("LineID",sLineID);
		Sqlca.executeSQL(so);
		//删除授信限制条件信息
		sSql = "delete from CL_LIMITATION where LineID =:LineID "; 
		so = new SqlObject(sSql);
		so.setParameter("LineID",sLineID);
		Sqlca.executeSQL(so);
		return null;
	 }
}
