package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class SelectPretrialResult extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sSerialNo = (String)this.getAttribute("SerialNo");
	
		//����ֵת��Ϊ���ַ���
		if(sSerialNo == null) sSerialNo = "" ;
		
		String sSql = "";
		ASResultSet rs = null;
		SqlObject so;
		int i =0;
		String sPamString;
		//�ж��Ƿ���ھܾ�
		sSql = "select count(1) as  n  from contract_relative a where a.serialno=:serialno and (PRETRIALRESULT='01' ) ";
		so = new SqlObject(sSql).setParameter("serialno", sSerialNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()) 
		{
			i=rs.getInt("n");
		}
		rs.getStatement().close();
		
		if(i<=0){//ͨ��
			sPamString="02";
		}else{//�ܾ�
			sPamString="01";
		}
		
		//�Ѳ�ѯ�����Ľ�����µ�business_contract����PretrialResult�ֶ�
		sSql = " UPDATE business_contract SET PretrialResult=:PretrialResult "+
		 		" WHERE SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("PretrialResult", sPamString).setParameter("SerialNo", sSerialNo);
		Sqlca.executeSQL(so);
		return sPamString;
	}	

}
