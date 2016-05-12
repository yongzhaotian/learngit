package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 在个体经营户管理中删除该户下属中小企业时，所做接触该企业与该户关联关系操作。
 * @author pwang
 *
 */
public class DelIndEntRela extends Bizlet {
	/**
	 * @param  CustomerID
	 * @param  UserID
	 * @author pwang
	 */
	public Object run(Transaction Sqlca) throws Exception{
		//定义变量
		String sReturnValue = "";		
		
		//获取页面参数：客户ID,用户ID
		String sCustomerID   = (String)this.getAttribute("CustomerID");	

		//将空值转化为空字符串
		if(sCustomerID == null) sCustomerID = "";
	
		try{
			//删除sme_custrela关联关系表
			//因为customerid只可能跟一个relativeserialno有关系
			SqlObject so = new SqlObject("Delete from  SME_CUSTRELA where CustomerID=:CustomerID").setParameter("CustomerID", sCustomerID);
			Sqlca.executeSQL(so);
			//返回值
			sReturnValue = "1";
		}catch(Exception e)
		{
			throw new Exception("删除处理失败！"+e.getMessage());
		}
		return sReturnValue ;
	}
	
}
