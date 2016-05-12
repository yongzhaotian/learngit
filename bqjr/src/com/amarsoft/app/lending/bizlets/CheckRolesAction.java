package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * 校验客户是否有客户主办权，信息查看权，信息维护权，业务申办权
 * @author syang 2009/10/27
 *
 */
public class CheckRolesAction extends Bizlet {

	
	/**
	 * @param 参数说明<br/>
	 * 		CustomerID	:客户ID<br/>
	 * 		UserID		:用户ID
	 * @return 返回值说明
	 * 		<p>主办权@信息查看权@信息维护权@业务申办权</p>
	 * 		<li>主办权值域　　：Y/N</li>
	 * 		<li>信息查看权值域：Y1/N1</li>
	 * 		<li>信息维护权值域：Y2/N2</li>
	 * 		<li>业务申办权值域：Y3/N3</li>
	 * 
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/**
		 * 获取参数
		 */
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sUserID = (String)this.getAttribute("UserID");
		
		if(sCustomerID == null) sCustomerID = "";
		if(sUserID == null) sUserID = "";
		
		/**
		 * 定义变量
		 */
		String sReturn = "";			//返回结果
	    ASResultSet rs = null;			//存放结果集    
	    String sBelongAttribute = "";	//客户主办权    
	    String sBelongAttribute1 = "";	//信息查看权
	    String sBelongAttribute2 = "";	//信息维护权
	    String sBelongAttribute3 = "";	//业务申办权    
	    String sReturnValue = "";		//主办权标志   
	    String sReturnValue1 = "";		//信息查看权标志
	    String sReturnValue2 = "";		//信息维护权标志
	    String sReturnValue3 = "";		//业务申办权标志
	    
	    /**
	     * 程序逻辑
	     */
	    
	    String sSql = " select BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3 "+
        " from CUSTOMER_BELONG "+
        " where CustomerID =:CustomerID "+
        " and UserID =:UserID  ";
	    SqlObject so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID).setParameter("UserID", sUserID);
		rs = Sqlca.getResultSet(so);
	    
		if(rs.next()){
			sBelongAttribute = rs.getString("BelongAttribute");
			sBelongAttribute1 = rs.getString("BelongAttribute1");
			sBelongAttribute2 = rs.getString("BelongAttribute2");
			sBelongAttribute3 = rs.getString("BelongAttribute3");	   
		}
		rs.getStatement().close();
		rs = null;
		if(sBelongAttribute == null) sBelongAttribute = "";
		if(sBelongAttribute1 == null) sBelongAttribute1 = "";
		if(sBelongAttribute2 == null) sBelongAttribute2 = "";
		if(sBelongAttribute3 == null) sBelongAttribute3 = "";
		
		
		
		//如果有客户主办权返回Y，否则返回N	
	    if(sBelongAttribute.equals("1")){
	        sReturnValue = "Y";
	    }else{ 
	    	sReturnValue = "N";
	    }
	        
	    //如果有信息查看权返回Y1，否则返回N1	
	    if(sBelongAttribute1.equals("1")){
	        sReturnValue1 = "Y1";
	    }else{ 
	    	sReturnValue1 = "N1";
	    }
	    
	    //如果有信息维护权返回Y2，否则返回N2	
	    if(sBelongAttribute2.equals("1")){
	        sReturnValue2 = "Y2";
	    }else{ 
	    	sReturnValue2 = "N2";
	    }
	    
	    //如果有业务申办权返回Y3，否则返回N3	
	    if(sBelongAttribute3.equals("1")){
	        sReturnValue3 = "Y3";
	    }else{ 
	    	sReturnValue3 = "N3";
	    }
	        
	    sReturn = sReturnValue+"@"+sReturnValue1+"@"+sReturnValue2+"@"+sReturnValue3;
		return sReturn;
	
  	}
}
