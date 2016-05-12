package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CancelFlow extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		
		String sSql = "";
		SqlObject so = null;//声明对象
		//删除流程对象信息
		sSql =  " delete from FLOW_OBJECT where ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
			
		//删除流程过程信息	
		sSql =  " delete from FLOW_TASK where ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
				
		return "1";
	}		
}
