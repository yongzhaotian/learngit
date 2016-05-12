package com.amarsoft.app.lending.bizlets;

/**
 * 检查客户信息状态
 * @author syang 2009/10/27 重新整理此类
 */
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckCustomerAction extends Bizlet 
{
	/**
	 * @param 参数说明
	 *		<p>CustomerType：客户类型
	 *			<li>01    公司客户</li>
	 *			<li>0110  大型企业</li>  
	 *			<li>0120  中小企业</li>  
	 *			<li>02    集团客户</li>  
	 *			<li>0210  实体集团</li>  
	 *			<li>0220  虚拟集团</li>  
	 *			<li>03    个人客户</li>  
	 *			<li>0310  个人客户</li>  
	 *			<li>0320  个体经营户</li>
	 *		</p>
	 * 		<p>CustomerName	:客户名称</p>
	 * 		<p>CertType		:证件类型</p>
	 * 		<p>CertID			:证件号</p>
	 * 		<p>UserID			:用户ID</p>
	 * @return 返回值说明
	 * 		ReturnStatus: 返回状态
	 * 			<li>01 无该客户</li> 
	 * 			<li>02 当前用户已与该客户建立关联</li> 
	 * 			<li>04 当前用户没有与该客户建立关联,且没有和任何客户建立主办权</li> 
	 * 			<li>05 当前用户没有与该客户建立关联,但和其他客户建立主办权</li> 
	 * 
	 */
	public Object run(Transaction Sqlca) throws Exception{
		
		/**
		 * 获取参数
		 */
		String sCustomerType = (String)this.getAttribute("CustomerType");
		String sCustomerName = (String)this.getAttribute("CustomerName");
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");
		String sUserID = (String)this.getAttribute("UserID");	
		
		if(sCustomerType == null) sCustomerType = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		if(sUserID == null) sUserID = "";
		
		/**
		 * 定义变量
		 */
		String sSql = "";
		String sCustomerID = "";			//客户代码
		ASResultSet rs = null;				//查询结果集
		String sHaveCutomerType = "";		//系统中已存在该客户的客户类型，用以区分引入时是否正确
		String sHaveCutomerTypeName = "";	//系统中已存在该客户的客户类型，用以区分引入时是否正确
		String sStatus = "";				//系统中已存在该客户的客户类型，用以区分引入时是否正确
		String sReturnStatus = "";			//返回信息
		String realCustomerName="";  // 校验客户名称  added by yzheng 2013-7-2
		
		/**
		 * 程序计算逻辑
		 */
		
		/**  1.根据客户类型，生成相应SQL */
		//01 公司客户需通过证件类型、证件号码检查是否在CI表中存在信息	
		if(sCustomerType.substring(0,2).equals("01")){
			sSql = 	" select CustomerID,CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,Status,CustomerName "+
					" from CUSTOMER_INFO "+
					" where CertType = :CertType "+
					" and CertID = :CertID ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CertType", sCertType).setParameter("CertID", sCertID));
			
		//02 集团客户通过客户名称检查是否在CI表中存在信息
		}else if(sCustomerType.substring(0,2).equals("02")){ 
			sSql = 	" select CustomerID,CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,Status,CustomerName "+
					" from CUSTOMER_INFO "+
					" where CustomerName = :CustomerName "+
					" and CustomerType = :CustomerType ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerType", sCustomerType).setParameter("CustomerName", sCustomerName));
		//03 个人客户
		}else if(sCustomerType.substring(0,2).equals("03")){
			if(sCertType.equals("Ind01")){	
				//如果为身份证，则需要作15位，18位身份证转换，然后使用18位的身份证去匹配
				String sCertID18 = StringFunction.fixPID(sCertID);
				sSql = 	" select CI.CustomerID as CustomerID,"
						+" CI.CustomerType as CustomerType,"
						+" CI.CustomerName as CustomerName, "	//add by jqcao 	2013-07-09
						+" getItemName('CustomerType',CI.CustomerType) as CustomerTypeName,"
						+" CI.Status as Status"
						+" from IND_INFO II,CUSTOMER_INFO CI"
						+" where II.CustomerID=CI.CustomerID"
						+" and II.CertType = :sCertType "
						+" and II.CertID18 = :sCertID18 ";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCertID18", sCertID18).setParameter("sCertType", sCertType));
			}else{
				sSql = 	" select CustomerID,CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,Status,CustomerName "+
						" from CUSTOMER_INFO "
						+" where CertType =:CertType "
						+" and CertID =:CertID ";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CertType", sCertType).setParameter("CertID", sCertID));
			}
		// 如果没有指定客户类型，则直接使用证件类型，证件号（和01 公司客户相同）
		}else{
			sSql = 	" select CustomerID,CustomerType,getItemName('CustomerType',CustomerType) as CustomerTypeName,Status,CustomerName "+
					" from CUSTOMER_INFO "+
					" where CertType = :sCertType "+
					" and CertID = :sCertID ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCertID", sCertID).setParameter("sCertType", sCertType));
		}
		
		/** 获取查询结果 */
		if(rs.next()){
			sCustomerID = rs.getString("CustomerID");
			sHaveCutomerType = rs.getString("CustomerType");
			sHaveCutomerTypeName = rs.getString("CustomerTypeName");
			sStatus = rs.getString("Status");
			realCustomerName = rs.getString("CustomerName");  //added by yzheng 2013-7-2
		}
		rs.getStatement().close();
		rs = null;
		if(sCustomerID == null) sCustomerID = "";
		if(sHaveCutomerType == null) sHaveCutomerType = "";
		if(sHaveCutomerTypeName == null) sHaveCutomerTypeName = "";
		if(sStatus == null) sStatus = "";
		if(realCustomerName == null) realCustomerName = "";  //added by yzheng 2013-7-2
		
		/** 客户信息检查*/
		
		//无该客户
		if(sCustomerID.equals("")){
			sReturnStatus = "01";
			
		//存在该客户，则检查管户权及主办权
		}else{
			int iCount = 0;
			//获取当前客户是否与当前用户建立了关联
			sSql = 	" select count(CustomerID)"
					+" from CUSTOMER_BELONG "
					+" where CustomerID = :sCustomerID "
					+" and UserID = :sUserID ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sUserID", sUserID).setParameter("sCustomerID", sCustomerID));
			if(rs.next()){
				iCount = rs.getInt(1);
			}
			rs.getStatement().close(); 
			rs = null;
			if(iCount > 0){
				//用户已与该客户建立有效关联
				sReturnStatus = "02";
			}else{
				//检查该客户是否有管户人
				sSql = 	" select count(CustomerID) "
						+" from CUSTOMER_BELONG "
						+" where CustomerID = :sCustomerID "
						+" and BelongAttribute = '1'";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", sCustomerID));
				if(rs.next()){
				   	iCount = rs.getInt(1);
				}
				rs.getStatement().close();
				rs = null;
				if(iCount > 0){
					//当前用户没有与该客户建立关联,但和其他客户建立主办权
					sReturnStatus = "05";
				}else{
					//当前用户没有与该客户建立关联,且没有和任何客户建立主办权
					sReturnStatus = "04";
				}
			}

			sReturnStatus = sReturnStatus+"@"+sCustomerID+"@"+sHaveCutomerType+"@"+sHaveCutomerTypeName+"@"+sStatus +"@"+realCustomerName;
		}
		return sReturnStatus;
	}
}
