package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdatePhoneInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String st1 = (String)this.getAttribute("st1");//��ˮ��
		String st2 = (String)this.getAttribute("st2");//�ͻ���
		String st3 = (String)this.getAttribute("st3");//�绰����
		String st4 = (String)this.getAttribute("st4");//��ͻ��Ĺ�ϵ
        System.out.println("------"+st4);
	
		//����ֵת��Ϊ���ַ���
		if(st1 == null) st1 = "";
		if(st2 == null) st2 = "";
		if(st3 == null) st3 = "";
		if(st4 == null) st4 = "";
		
		String sSql = "";
		ASResultSet rs = null;
		SqlObject so;
		//
		sSql = "select serialno from phone_info where phonecode=:phonecode and relation=:relation and customerid=:customerid ";
		so = new SqlObject(sSql).setParameter("phonecode", st3).setParameter("customerid", st2).setParameter("relation",st4);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()) 
		{
			String serialno=rs.getString("serialno");
			if(serialno == null) serialno = "";
			
            //����������ݣ�����
			sSql=" update phone_info set phonecode=:phonecode,customerid=:customerid where serialno=:serialno ";
			so = new SqlObject(sSql);
			so.setParameter("phonecode", st3).setParameter("customerid", st2).setParameter("serialno", serialno);
			Sqlca.executeSQL(so);
		}else{
			/** --update Object_Maxsnȡ���Ż�Ԥ��������ͻ tangyb 20150817 start-- */
			st1 = DBKeyUtils.getSerialNo("PI");
			/** --end --*/
			
			//�����ڣ���������
			sSql = "insert into phone_info(serialno,customerid,phonecode,relation) values(:SerialNo,:CustomerID,:PhoneCode,:Relation)";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", st1).setParameter("CustomerID", st2).setParameter("PhoneCode", st3).setParameter("Relation", st4);
			Sqlca.executeSQL(so);	
		}
		rs.getStatement().close();

		return "1";
	}	

}
