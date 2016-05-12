package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InsertSmeCustRela extends Bizlet{


	public Object run(Transaction Sqlca) throws Exception {
		
		String sCustomerID = (String)this.getAttribute("CustomerID");//获取补登个体经营户的ID
		String sRelativeSerialNo = (String)this.getAttribute("RelativeSerialNo");//获取补登合同的客户编号
		if(sCustomerID == null) sCustomerID = "";
		if(sRelativeSerialNo == null) sRelativeSerialNo ="";
		//定义参数
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
		if(count >0){  //判断是否重复引入  
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
			//如果是补登的个体经营户，则将该经营户的认定状态置为“已认定”
			sql2 = "update CUSTOMER_INFO set Status ='1' where CustomerID =:CustomerID";
			so = new SqlObject(sql2).setParameter("CustomerID", sCustomerID);
			Sqlca.executeSQL(so);
		}
		
		return "success";
	}
}
