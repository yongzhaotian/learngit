package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class FreezeCreditLine extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值
	 	SqlObject so=null;
	 	//传入合同号
		String sBCSerialNo   = (String)this.getAttribute("SerialNo");
		//传入冻结标志
		String sFreezeFlag = (String)this.getAttribute("FreezeFlag");
		
		if(sBCSerialNo == null) sBCSerialNo = "";
		if(sFreezeFlag == null) sFreezeFlag = "";
			  
	    //更新CL_INFO中相对应的额度信息
		so = new SqlObject("update CL_INFO set FreezeFlag =:FreezeFlag where BCSerialNo =:BCSerialNo ").setParameter("FreezeFlag", sFreezeFlag).setParameter("BCSerialNo", sBCSerialNo);
		Sqlca.executeSQL(so);
		
	    //更新BUSINESS_CONTRACT中相对应的额度信息
		so = new SqlObject("update BUSINESS_CONTRACT set FreezeFlag =:FreezeFlag where SerialNo =:SerialNo ").setParameter("FreezeFlag", sFreezeFlag).setParameter("SerialNo", sBCSerialNo);
		Sqlca.executeSQL(so);
		
	    return "1";
	    
	 }

}
