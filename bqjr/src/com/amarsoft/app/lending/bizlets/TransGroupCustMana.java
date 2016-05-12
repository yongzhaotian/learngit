package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


/**
 * 转移集团客户管户权<br/>
 * 1.把当前客户与老用户之间的主权权移除掉，只留下信息查看权（更新原Customer_Belong）<br/>
 * 2.与新客户建立主办权关系（插入新;Customer_Belong）<br/>
 * @author syang 2009/11/11
 *
 */
public class TransGroupCustMana extends Bizlet {

	private String sCustomerID = "";
	private String sUserID = "";
	private String sOrgID = "";
	/**  数据库连接 */
	private Transaction Sqlca = null;
	/** 当天日期 */
	private String sToday = "";

	public Object run(Transaction Sqlca) throws Exception{
		/*
		 * 获取参数
		 */
		sCustomerID = (String)this.getAttribute("CustomerID");
		sUserID = (String)this.getAttribute("UserID");
		this.Sqlca = Sqlca;
		/*局部变量*/
		String sReturn = "1";
		
		/*处理逻辑*/
		if(sCustomerID == null) sCustomerID = "";
		if(sUserID == null) sUserID = "";
		sToday = StringFunction.getToday();
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		sOrgID = CurUser.getOrgID();
		
		//清除原管户权
		clearManage();
		//建立新管户权
		newManage();
		
		return sReturn;
  	}
	/**
	 * 清除客户的主办权，只保留信息查看权
	 * @throws Exception 
	 */
	public void clearManage() throws Exception{
		String sbSql = "update CUSTOMER_BELONG set BelongAttribute='2',BelongAttribute1='1',BelongAttribute2='2'," +
				" BelongAttribute3='2',BelongAttribute4='2' where CustomerID =:CustomerID and BelongAttribute='1'"; 
		SqlObject so = new SqlObject(sbSql).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
	}
	/**
	 * 建立主办权
	 * @throws Exception 
	 */
	public void newManage() throws Exception{
		String sbSql = "insert into CUSTOMER_BELONG (CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate)values" +
				"(:CustomerID,:OrgID,:UserID,'1','1','1','1','1',:InputOrgID,:InputUserID,:InputDate,:UpdateDate)";
		SqlObject so = new SqlObject(sbSql);
		so.setParameter("CustomerID", sCustomerID).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("InputOrgID", sOrgID)
		.setParameter("InputUserID", sUserID).setParameter("InputDate", sToday).setParameter("UpdateDate", sToday);
		Sqlca.executeSQL(so);
	}
}
