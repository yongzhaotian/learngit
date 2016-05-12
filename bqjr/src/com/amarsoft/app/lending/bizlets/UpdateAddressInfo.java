package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateAddressInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String st1 = (String)this.getAttribute("st1");//ʡ�д���
		String st2 = (String)this.getAttribute("st2");//ʡ������
		String st3 = (String)this.getAttribute("st3");//������
		String st4 = (String)this.getAttribute("st4");//�ֵ�/��
		String st5 = (String)this.getAttribute("st5");//С��/¥��
		String st6 = (String)this.getAttribute("st6");//��/��Ԫ/�����
		String st7 = (String)this.getAttribute("st7");//�ͻ����
		String st8 = (String)this.getAttribute("st8");//��ַ����
		String st9 = (String)this.getAttribute("st9");//��ַ��ˮ��
	
		//����ֵת��Ϊ���ַ���
		if(st1 == null) st1 = "";
		if(st2 == null) st2 = "";
		if(st3 == null) st3 = "";
		if(st4 == null) st4 = "";
		if(st5 == null) st5 = "";
		if(st6 == null) st6 = "";
		if(st7 == null) st7 = "";
		if(st8 == null) st8 = "";
		if(st9 == null) st9 = "";
		
		String sSql = "";
		ASResultSet rs = null;
		SqlObject so;
		//����sSerialNo������������е���Ϣ������Щ��Ϣ���µ������������
		sSql = "select serialno from customer_add_info where customerid=:customerid and address=:address and township=:township and street=:street and cell=:cell and room=:room and addtype=:addtype ";
		so = new SqlObject(sSql).setParameter("customerid", st7).setParameter("address", st1).setParameter("township", st3).setParameter("street", st4).setParameter("cell", st5).setParameter("room", st6).setParameter("addtype", st8);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()) 
		{
			String serialno=rs.getString("serialno");
			if(serialno == null) serialno = "";
			
            //����������ݣ�����
			sSql="update customer_add_info set customerid=:customerid,address=:address,township=:township,street=:street,cell=:cell,room=:room,addtype=:addtype where serialno=:serialno ";
			so = new SqlObject(sSql);
			so.setParameter("customerid", st7).setParameter("address", st1).setParameter("township", st3).setParameter("street", st4)
			.setParameter("cell", st5).setParameter("room", st6).setParameter("addtype", st8).setParameter("serialno", serialno);
			Sqlca.executeSQL(so);
		}else{
			/** --update Object_Maxsnȡ���Ż�Ԥ��������ͻ tangyb 20150817 start-- */
			st9 = DBKeyUtils.getSerialNo("CA");
			/** --end --*/
			//�����ڣ���������
			sSql = "insert into customer_add_info(serialno,customerid,address,township,street,cell,room,addtype) values(:SerialNo,:CustomerID,:Address,:TownShip,:Street,:Cell,:Room,:AddType)";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", st9).setParameter("CustomerID", st7).setParameter("Address", st1).setParameter("TownShip", st3).setParameter("Street", st4).setParameter("Cell", st5).setParameter("Room", st6).setParameter("AddType", st8);
			Sqlca.executeSQL(so);	
		}
		rs.getStatement().close();

		return "1";
	}	

}
