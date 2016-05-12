package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 新增集团客户前插入记录至CUSTOMER_INFO
 * @author lyin 2012-12-13  
 */

public class AddGroupCustomerAction extends Bizlet {

	//客户ID
	private String sCustomerID = "";
	//用户ID
	private String sUserID = "";
	//机构ID
	private String sOrgID = "";
	//数据库连接 
	private Transaction Sqlca = null;
	
	/**
	 * @param 参数说明
	 * 		<p>CustomerID		:客户ID</p>
	 * 		<p>UserID			:用户ID</p>
	 * 		<p>OrgID			:机构ID</p>
	 * @return 返回值说明
	 * 		返回状态 1 成功,0 失败
	 * 
	 */
	public Object run(Transaction Sqlca) throws Exception{

		//获取参数
		sCustomerID 		= (String)this.getAttribute("CustomerID");	
		sOrgID 				= (String)this.getAttribute("OrgID");
		sUserID 			= (String)this.getAttribute("UserID");

		if(sCustomerID == null) sCustomerID = "";
		if(sOrgID == null) sOrgID = "";
		if(sUserID == null) sUserID = "";

		this.Sqlca = Sqlca;
		

		//变量定义
		String sReturn = "0";
		
        //插入记录至CUSTOMER_INFO
		insertCustomerInfo();
		
		return sReturn;
	}
	
	/**
	 * 插入数据至CUSTOMER_INFO
	 * @param 
	 * @throws Exception 
	 */
  	private void insertCustomerInfo() throws Exception{
		StringBuffer sbSql = new StringBuffer();
		SqlObject so ;
		sbSql.append(" insert into CUSTOMER_INFO(") 
			.append(" CustomerID,")					//010.客户编号
			.append(" CustomerType,")				//020.客户类型
			.append(" InputUserID,")				//030.登记用户
			.append(" InputOrgID, ")				//040.登记机构
			.append(" InputDate ")					//050.登记日期
			.append(" )values(:CustomerID, :CustomerType, :InputUserID, :InputOrgID, :InputDate )");
		so = new SqlObject(sbSql.toString());
		so.setParameter("CustomerID", sCustomerID).setParameter("CustomerType", "0210").setParameter("InputUserID", sUserID).setParameter("InputOrgID", sOrgID)
		.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		Sqlca.executeSQL(so);
  	}	
  	
  
}
