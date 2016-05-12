package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * 更新客户类型
 * @author syang 2009/10/28
 *
 */
public class ChangeCustomerType extends Bizlet {
	/** 客户ID */
	private String sCustomerID = "";
	/** 客户类型 */
	private String sCustomerType = "";
	/** 用户ID */
	private String sUserID = "";
	/** 机构号 */
	private String sOrgID = "";
	/** 当前日期 */
	private String sToday = "";
	
	/** 数据库连接 */
	private Transaction Sqlca = null;

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
	 * 		<p>Status			:当前客户状态
	 * 			<li>01 无该客户</li>
	 * 			<li>02 当前用户已与该客户建立关联</li>
	 * 			<li>04 当前用户没有与该客户建立关联,且没有和任何客户建立主办权</li>
	 * 			<li>05 当前用户没有与该客户建立关联,但和其他客户建立主办权</li>
	 *		</p>
	 * 		<p>UserID			:用户ID</p>
	 * 		<p>CustomerID		:客户ID</p>
	 * 		<p>OrgID			:机构ID</p>
	 * @return 返回值说明
	 * 		返回状态 1 成功,0 失败
	 * 
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/**
		 * 获取参数
		 */
		sCustomerID = (String)this.getAttribute("CustomerID");	
		sCustomerType = (String)this.getAttribute("CustomerType");	
		sUserID = (String)this.getAttribute("UserID");	
		sOrgID = (String)this.getAttribute("OrgID");
		
		sToday = StringFunction.getToday();
		this.Sqlca = Sqlca;
 
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerType == null) sCustomerType = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		
		
		/**
		 * 变量定义
		 */
		String sReturn = "";
		
		/**
		 *	程序逻辑 
		 */
		
		try{
			//如果是转换的客户类型是大型企业，则更新其认定状态
			if(sCustomerType.equals("0110")){
				updateCustomerInfo("");
				updateEntInfo(sCustomerID, sCustomerType,null);
			}
			//如果是转换的客户类型是中小型企业，则更新其认定状态
			if(sCustomerType.equals("0120")){
				updateCustomerInfo("0");
				updateEntInfo(sCustomerID, sCustomerType,null);
			}
			//如果是转换的客户类型是个人客户，则客户类型
			if(sCustomerType.equals("0310")){
				updateCustomerInfo("");
				/**
				 * 如果是个人客户，则应该删除中小企业关联信息		  
				 */
				  Sqlca.executeSQL(new SqlObject("Delete from SME_CUSTRELA where RelativeSerialno=:RelativeSerialno").setParameter("RelativeSerialno", sCustomerID));
			}
			//如果是转换的客户类型是个人经营户，则客户类型
			if(sCustomerType.equals("0320")){
				updateCustomerInfo("");
			}
			
			//更新企业信息表ENT_INFO,将客户规模Scope字段更新 add by cbsu 2009-11-2
			sReturn = "1";
		}catch(Exception e){
			sReturn = "0";
		}
		return sReturn;
	}
	
	/**
	 * 更新客户信息表
	 * @param status
	 * @throws Exception
	 */
	private void updateCustomerInfo(String status) throws Exception{
		String sSql = 	" update CUSTOMER_INFO set"
			+" CustomerType =:CustomerType,"
			+" status =:status,"
			+" InputDate =:InputDate,"
			+" InputOrgID =:InputOrgID,"
			+" InputUserID =:InputUserID"
		    +" where CustomerID =:CustomerID ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("CustomerType", sCustomerType).setParameter("status", status).setParameter("InputDate", sToday);
		so.setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
	}
	
	/**
	 * 更新企业信息表ENT_INFO,将客户规模Scope字段和CreditBelong字段更新。
	 * 如果是中小企业转大型企业，则将Scope更新为"2"。
	 * 如果时大型企业转中小企业，则将Scope更新为空。因为存在中型企业和小型企业两个类别，无法设定Scope具体为哪一个。
	 *  add by cbsu 2009-11-02
	 * 企业规模转换时还需将存储信用等级评估模板CreditBelong字段置空。
	 *  add by cbsu 2009-11-06
	 * @param sCustomerID 客户编号
	 * @param sTargetCustomerType 转换的目标规模
	 * @param sEmployeeNumber 转换后员工人数（如果为空，则不转换）
	 * @throws Exception
	 */
	private void updateEntInfo(String sCustomerID, String sTargetCustomerType,String sEmployeeNumber) throws Exception{
		SqlObject so = null;//声明对象
        String sScope = "";
        String sSourceCustomerType = "";
        String sSql = " Select CustomerType from CUSTOMER_INFO Where CustomerID = :CustomerID";
        sSourceCustomerType = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID", sCustomerID));
        //转换客户规模的源客户必须是企业才能更新ENT_INFO表
        if ("01".equals(sSourceCustomerType.substring(0, 2))) {
            //根据目标规模来决定Scope字段的值
            if ("0110".equals(sTargetCustomerType)) {
                sScope = "2";
            }
            //将CreditBelong字段置空  add by cbsu 2009-11-06
            /*if(sEmployeeNumber == null){
            	sSql = " Update ENT_INFO set Scope =:Scope, CreditBelong = '' Where CustomerID =:CustomerID ";
            	so = new SqlObject(sSql).setParameter("Scope", sScope).setParameter("CustomerID", sCustomerID);
            	Sqlca.executeSQL(so);
            }else{*/
            	 sSql = " Update ENT_INFO set Scope =:Scope , CreditBelong = '',EmployeeNumber =:EmployeeNumber  Where CustomerID =:CustomerID ";
            	 so = new SqlObject(sSql).setParameter("Scope", sScope).setParameter("EmployeeNumber", sEmployeeNumber).setParameter("CustomerID", sCustomerID);
            	 Sqlca.executeSQL(so);
//            }
        }
    }
}
