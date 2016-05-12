package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InsertSmeCustRela extends Bizlet{


	public Object run(Transaction Sqlca) throws Exception {
		
		String sCustomerID = (String)this.getAttribute("CustomerID");//��ȡ���Ǹ��徭Ӫ����ID
		String sRelativeSerialNo = (String)this.getAttribute("RelativeSerialNo");//��ȡ���Ǻ�ͬ�Ŀͻ����
		if(sCustomerID == null) sCustomerID = "";
		if(sRelativeSerialNo == null) sRelativeSerialNo ="";
		//�������
		String sql1 = "";
		String sql2 = "";
		SqlObject so;
		int count = 0;
		String reinforceFlag = "";
		boolean isReinforce = false;
		
		sql1= "select count(*)  from SME_CUSTRELA where " +
				  " CustomerID=:CustomerID and RelativeSerialNo=:RelativeSerialNo and ObjectType ='Customer'";
		so = new SqlObject(sql1).setParameter("CustomerID", sCustomerID).setParameter("RelativeSerialNo", sRelativeSerialNo);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			count = rs.getInt(1);
		}
		rs.close();
		if(count >0){  //�ж��Ƿ��ظ�����  
			return "EXIST";
		}
		else{
			sql1= "insert into SME_CUSTRELA(CustomerID,RelativeSerialNo,ObjectType) " +
					  " values(:CustomerID,:RelativeSerialNo,'Customer')";
			so = new SqlObject(sql1).setParameter("CustomerID", sCustomerID).setParameter("RelativeSerialNo", sRelativeSerialNo);
			Sqlca.executeSQL(so);
		}
		
		sql2 = "SELECT ReinforceFlag FROM BUSINESS_CONTRACT where CustomerID =:CustomerID";
		so = new SqlObject(sql2).setParameter("CustomerID", sCustomerID);
		rs = Sqlca.getASResultSet(so);
		while(rs.next()){
			reinforceFlag = rs.getString("ReinforceFlag");
			if (reinforceFlag.equals("000") == false){
				isReinforce = true;
				break;
			}
		}
		rs.getStatement().close();
		if(isReinforce){
			//����ǲ��ǵĸ��徭Ӫ�����򽫸þ�Ӫ�����϶�״̬��Ϊ�����϶���
			sql2 = "update CUSTOMER_INFO set Status ='1' where CustomerID =:CustomerID";
			so = new SqlObject(sql2).setParameter("CustomerID", sCustomerID);
			Sqlca.executeSQL(so);
		}
		
		return "success";
	}
}
