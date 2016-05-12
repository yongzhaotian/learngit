package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class FreezeCreditLine extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ
	 	SqlObject so=null;
	 	//�����ͬ��
		String sBCSerialNo   = (String)this.getAttribute("SerialNo");
		//���붳���־
		String sFreezeFlag = (String)this.getAttribute("FreezeFlag");
		
		if(sBCSerialNo == null) sBCSerialNo = "";
		if(sFreezeFlag == null) sFreezeFlag = "";
			  
	    //����CL_INFO�����Ӧ�Ķ����Ϣ
		so = new SqlObject("update CL_INFO set FreezeFlag =:FreezeFlag where BCSerialNo =:BCSerialNo ").setParameter("FreezeFlag", sFreezeFlag).setParameter("BCSerialNo", sBCSerialNo);
		Sqlca.executeSQL(so);
		
	    //����BUSINESS_CONTRACT�����Ӧ�Ķ����Ϣ
		so = new SqlObject("update BUSINESS_CONTRACT set FreezeFlag =:FreezeFlag where SerialNo =:SerialNo ").setParameter("FreezeFlag", sFreezeFlag).setParameter("SerialNo", sBCSerialNo);
		Sqlca.executeSQL(so);
		
	    return "1";
	    
	 }

}
