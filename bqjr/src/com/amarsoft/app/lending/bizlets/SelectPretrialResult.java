package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class SelectPretrialResult extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sSerialNo = (String)this.getAttribute("SerialNo");
	
		//将空值转化为空字符串
		if(sSerialNo == null) sSerialNo = "" ;
		
		String sSql = "";
		ASResultSet rs = null;
		SqlObject so;
		int i =0;
		String sPamString;
		//判断是否存在拒绝
		sSql = "select count(1) as  n  from contract_relative a where a.serialno=:serialno and (PRETRIALRESULT='01' ) ";
		so = new SqlObject(sSql).setParameter("serialno", sSerialNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()) 
		{
			i=rs.getInt("n");
		}
		rs.getStatement().close();
		
		if(i<=0){//通过
			sPamString="02";
		}else{//拒绝
			sPamString="01";
		}
		
		//把查询出来的结果更新到business_contract表中PretrialResult字段
		sSql = " UPDATE business_contract SET PretrialResult=:PretrialResult "+
		 		" WHERE SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("PretrialResult", sPamString).setParameter("SerialNo", sSerialNo);
		Sqlca.executeSQL(so);
		return sPamString;
	}	

}
