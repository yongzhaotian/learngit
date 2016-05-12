package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/*
 * Author: jgao1 2009.10.19
 * Tester:
 * Describe: 更新中小企业认定结束后status字段的值
 * Input Param:
 * 			ObjectNo: 对象编号
 * 			Status:   状态值
 * Output Param:
 * HistoryLog:
 */
public class UpdateCusStatus extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sStatus = (String)this.getAttribute("Status");
		//认定客户编号
		String sCustomerID="";

		String sSql = "";
		ASResultSet rs=null;
		SqlObject so;
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		//查询认定完成后，最终认定人的审批流程任务编号
		sSql = 	" select CustomerID from SME_APPLY"+
				" where SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			sCustomerID=rs.getString("CustomerID");
		}
		if(sCustomerID==null) sCustomerID="";
		rs.getStatement().close();

		//更新中小企业认定记录表 0代表未认定，1代表已认定，2代表被否决，3代表认定中
		sSql = " UPDATE CUSTOMER_INFO SET Status=:Status "+
		 		" WHERE CustomerID=:CustomerID";
		so = new SqlObject(sSql).setParameter("Status", sStatus).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
		return "1";
	}
}

