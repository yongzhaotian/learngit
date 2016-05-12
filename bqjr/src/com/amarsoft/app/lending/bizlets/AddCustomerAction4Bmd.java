package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * 添加新客户信息
 * @author syang 2009/10/27 重新整理此类
 *
 */
public class AddCustomerAction4Bmd extends Bizlet {
	/** 
	 * 客户类型
	 *	<li>01 公司客户</li> 
	 *		<li>0110 大型企业</li>
	 *		<li>0120 中小企业</li>  
	 *	<li>02 集团客户</li>  
	 *		<li>0210 实体集团</li>  
	 *		<li>0220 虚拟集团</li>  
	 *	<li>03 个人客户</li>  
	 *		<li>0310 个人客户</li>  
	 *		<li>0320 个体经营户</li>
	 */
	private String sCustomerType = "";
	/** 客户名 */
	private String sCustomerName = "";
	/** 证件类型 */
	private String sCertType = "";
	/** 证件号 */
	private String sCertID = "";
	/**
	 *  客户状态 
	 *	<li>01 无该客户</li>
	 *	<li>02 当前用户已与该客户建立关联</li>
	 *	<li>04 当前用户没有与该客户建立关联,且没有和任何客户建立主办权</li>
	 *	<li>05 当前用户没有与该客户建立关联,但和其他客户建立主办权</li>
	 */
	private String sStatus = "";
	/** 客户ID */
	private String sCustomerID = "";
	/** 机构性质 */
	private String sCustomerOrgType = "";
	/** 用户ID */
	private String sUserID = "";
	/** 机构ID */
	private String sOrgID = "";
	/**  数据库连接 */
	private Transaction Sqlca = null;
	/** 当天日期 */
	private String sToday = "";
	/** 集团客户标志 */
	private String sGroupType = "";
	/**存在客户类型*/
	private String sHaCustomerType = "";
	/***************begin CCS-1334 二段式提单huzp***********************/
	private String MobileTelephone = "";//手机号码
	private String WorkCorp = "";//单位名称
	private String SelfMonthIncome ="";//个人月收入
	private String RelativeType = "";//亲属关系
	private String KinshipName ="";//亲属姓名
	private String KinshipTel ="";//亲属联系电话
	private String Contactrelation = "";//其他联系人关系
	private String OtherContact = "";//其他联系人姓名
	private String ContactTel ="";//其他联系人电话
	private String switch_status ="";//预审开关
	/*******************end********************************************/
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
		this.Sqlca = Sqlca;

		sCustomerID 		= (String)this.getAttribute("CustomerID");	
		sCustomerName		= (String)this.getAttribute("CustomerName");	
		sCustomerType 		= (String)this.getAttribute("CustomerType");
		sCertType			= (String)this.getAttribute("CertType");
		sCertID 			= (String)this.getAttribute("CertID");	
		sStatus 			= (String)this.getAttribute("Status");
		sCustomerOrgType 	= (String)this.getAttribute("CustomerOrgType");
		sUserID 			= (String)this.getAttribute("UserID");
		sOrgID 				= (String)this.getAttribute("OrgID");
		sHaCustomerType 	= (String)this.getAttribute("HaCustomerType");
		/***************begin CCS-1334 二段式提单huzp***********************/
		switch_status 		= Sqlca.getString(new SqlObject("select t.switch_status from SYSTEM_SWITCH t where t.switch_type ='PRETRIAL_ENABLE'"));
		if("1".equals(switch_status)){
			MobileTelephone 		= (String)this.getAttribute("MobileTelephone");	
			WorkCorp		= (String)this.getAttribute("WorkCorp");	
			SelfMonthIncome 		= (String)this.getAttribute("SelfMonthIncome");
			RelativeType			= (String)this.getAttribute("RelativeType");
			KinshipName 			= (String)this.getAttribute("KinshipName");	
			KinshipTel 			= (String)this.getAttribute("KinshipTel");
			Contactrelation 	= (String)this.getAttribute("Contactrelation");
			OtherContact 			= (String)this.getAttribute("OtherContact");
			ContactTel 				= (String)this.getAttribute("ContactTel");
			
			if(MobileTelephone == null) MobileTelephone = "";
			if(WorkCorp == null) WorkCorp = "";
			if(SelfMonthIncome == null) SelfMonthIncome = "";
			if(RelativeType == null) RelativeType = "";
			if(KinshipName == null) KinshipName = "";
			if(KinshipTel == null) KinshipTel = "";
			if(Contactrelation == null) Contactrelation = "";
			if(OtherContact == null) OtherContact = "";
			if(ContactTel == null) ContactTel = "";
		}
		/***************end***********************/


		if(sCustomerType == null) sCustomerType = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerOrgType == null) sCustomerOrgType = "";
		if(sStatus == null) sStatus = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		if(sHaCustomerType == null) sHaCustomerType = "";
		
		
//		// 获取客户编号
//		String sTempCustomerId = Sqlca.getString(new SqlObject("SELECT CUSTOMERID FROM IND_INFO WHERE CUSTOMERNAME=:CUSTOMERNAME AND CERTID=:CERTID")
//				.setParameter("CUSTOMERNAME", sCustomerName).setParameter("CERTID", sCertID));
//		if (sTempCustomerId != null) {
//			return sTempCustomerId;
//		}
		
		/**
		 * 变量定义
		 */
		String sReturn = "0";
		
		/**
		 *	程序逻辑 
		 */
		sToday = StringFunction.getToday();
		
	   	/** 根据客户类型设置集团客户类型 */
	  	if(sCustomerType.equals("0210")){ 
			sGroupType = "1";//一类集团
	  	}else if(sCustomerType.equals("0220")){ 
			sGroupType = "2";//二类集团
	  	}else{
			sGroupType = "0";//单一客户
	  	}
	  	
		//01为无该客户 
	  	if(sStatus.equals("01")){
	  		try{
	  			/**
	  			 * 1.插入CI表
	  			 */
	  			insertCustomerInfo(sCustomerType);
	  			/**
	  			 * 2.插入CB表,默认全部相关权限
	  			 */
	  			insertCustomerBelong("1");
	  			
	  			/**
	  			 * 插入ENT_INFO或者IND_INFO表
	  			 */
	  			//插入customer_center
	  			insertcustomercentre();
	  			
	  			//公司客户或者集团客户
	  			if(sCustomerType.substring(0,2).equals("01") ||sCustomerType.substring(0,2).equals("02")){
	  				insertEntInfo(sCustomerType,sCertType);
	  			}else if(sCustomerType.substring(0,2).equals("03")){//消费贷个人客户
	  				insertIndInfo(sCertType);
	  			}else if(sCustomerType.equals("03")){//汽车贷个人客户
	  				insertIndInfo(sCertType);
	  			}else if(sCustomerType.equals("04")){//汽车贷自雇客户
	  				insertEntInfo(sCustomerType,sCertType);
	  			}else if(sCustomerType.equals("05")){//汽车贷公司客户
	  				insertEntInfo(sCustomerType,sCertType);
	  			}
	  			sReturn = sCustomerID;
			} catch(Exception e){
				throw new Exception("事务处理失败！"+e.getMessage());
			}
		//该客户没有与任何用户建立有效关联
		}else if(sStatus.equals("04")){
			if(sHaCustomerType.equals(sCustomerType)){
				/**
				 * 将来源渠道由"2"变成"1"
				 */
				String sSql = 	" update CUSTOMER_INFO set Channel = '1' where CustomerID =:CustomerID ";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("CustomerID", sCustomerID));
				/**
				 * 插入CB表,默认全部相关权限
				 */
				insertCustomerBelong("1");
				sReturn = "1";
			}else{
				/**存在引入客户类型错误*/
				sReturn = "2";
			}
		}else if(sStatus.equals("05")){
			if(sHaCustomerType.equals(sCustomerType)){
				insertCustomerBelong("2");
				sReturn = "1";
			}else{
				sReturn = "2";
			}
		}
		return sReturn;
	}
	
	/**
	 * 插入数据至CUSTOMER_INFO
	 * @param cusotmerType 客户类型，不同的客户类型，插入的字段会有所不同
	 * @throws Exception 
	 */
  	private void insertCustomerInfo(String customerType) throws Exception{
		StringBuffer sbSql = new StringBuffer();
		SqlObject so ;//声明对象
		sbSql.append(" insert into CUSTOMER_INFO(") 
			.append(" CustomerID,")					//010.客户编号
			.append(" CustomerName,")				//020.客户名称
			.append(" CustomerType,")				//030.客户类型
			.append(" CertType,")					//040.证件类型
			.append(" CertID,")						//050.证件号
			.append(" InputOrgID,")					//060.登记机构
			.append(" InputUserID,")				//070.登记用户
			.append(" InputDate,")					//080.登记日期
			.append(" Channel")						//090.来源渠道
			.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :InputOrgID, :InputUserID, :InputDate, '1')");
		so = new SqlObject(sbSql.toString());
		so.setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("CustomerType", sCustomerType);
		//集团客户(无证件类型，证件号)
		if(customerType.substring(0,2).equals("02")){
			so.setParameter("CertType", "").setParameter("CertID", "");
		}else{
			so.setParameter("CertType", sCertType).setParameter("CertID", sCertID);
		}
		so.setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("InputDate", sToday);
		Sqlca.executeSQL(so);
  	}
  	
  	/**
  	 * 插入数据至CUSTOMER_BELONG
  	 * @param attribute [主办权，信息查看权，信息维护权，业务办理权]标志
  	 * @throws Exception
  	 */
  	private void insertCustomerBelong(String attribute) throws Exception{
  		StringBuffer sbSql = new StringBuffer("");
  		SqlObject so ;//声明对象
		sbSql.append("insert into CUSTOMER_BELONG(")
			.append(" CustomerID,")					//010.客户ID
			.append(" OrgID,")						//020.有权机构ID
			.append(" UserID,")						//030.有权人ID
			.append(" BelongAttribute,")			//040.主办权
			.append(" BelongAttribute1,")			//050.信息查看权
			.append(" BelongAttribute2,")			//060.信息维护权
			.append(" BelongAttribute3,")			//070.业务办理权
			.append(" BelongAttribute4,")			//080.
			.append(" InputOrgID,")					//090.登记机构
			.append(" InputUserID,")				//100.登记人
			.append(" InputDate,")					//110.登记日期
			.append(" UpdateDate")					//120.更新日期
			.append(" )values(:CustomerID, :OrgID1, :UserID1, :attribute, :attribute1, :attribute2, :attribute3, :attribute4, :OrgID2, :UserID2, :InputDate, :UpdateDate)");
		so = new SqlObject(sbSql.toString()).setParameter("CustomerID", sCustomerID).setParameter("OrgID1", sOrgID).setParameter("UserID1", sUserID)
		.setParameter("attribute", attribute).setParameter("attribute1", attribute).setParameter("attribute2", attribute)
		.setParameter("attribute3", attribute).setParameter("attribute4", attribute).setParameter("OrgID2", sOrgID).setParameter("UserID2", sUserID)
		.setParameter("InputDate", sToday).setParameter("UpdateDate", sToday);
		Sqlca.executeSQL(so);
  	}
  	
  	/**
  	 * 插入数据至ENT_INFO,不同的客户类型以及证件类型，插入的字段会有区别
  	 * @param customerType 客户类型
  	 * @param certType	证件类型
  	 * @throws Exception 
  	 */
  	private void insertEntInfo(String customerType,String certType) throws Exception{
  		SqlObject so =null;//声明对象
  		StringBuffer sbSql = new StringBuffer("");
  		//先插入通用信息
  		sbSql.append("insert into ENT_INFO(")
			.append(" CustomerID,")					//010.客户ID
			.append(" CustomerName,")				//020.客户名称
			.append(" CustomerType,")				//030.客户类型
			.append(" CertType,")					//030.证件类型
			.append(" CertID,")						//050.证件号
			.append(" OrgNature,")					//040.机构性质
			.append(" GroupFlag,")					//050.集团客户标志
			.append(" InputUserID,")				//060.登记人
			.append(" InputOrgID,")					//070.登记机构
			.append(" InputDate,")					//080.登记日期
			.append(" UpdateUserID,")				//090.更新人
			.append(" UpdateOrgID,")				//100.更新机构
			.append(" UpdateDate,")					//110.更新日期
			.append(" TempSaveFlag")				//120.暂存标志
			.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :OrgNature, :GroupFlag, :InputUserID, :InputOrgID, :InputDate, :UpdateUserID, :UpdateOrgID, :UpdateDate, '1')");
		so = new SqlObject(sbSql.toString());
		so.setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("CustomerType", sCustomerType).setParameter("CertType", sCertType).setParameter("CertID", sCertID).setParameter("OrgNature", sCustomerOrgType).setParameter("GroupFlag", sGroupType);
		so.setParameter("InputUserID", sUserID).setParameter("InputOrgID", sOrgID).setParameter("InputDate", sToday);
		so.setParameter("UpdateUserID", sUserID).setParameter("UpdateOrgID", sOrgID).setParameter("UpdateDate", sToday);
		Sqlca.executeSQL(so);
		
		//再更新特殊信息
  		//[01] 公司客户   [04]自雇    [05]公司
  	/*	if(sCustomerType.substring(0,2).equals("01") || sCustomerType.equals("04") || sCustomerType.equals("05")){
			//证件类型为营业执照 
			if(sCertType.equals("Ent02")){
				//更新营业执照号
				Sqlca.executeSQL(new SqlObject("update ENT_INFO set CertID = :CertID where CustomerID = :CustomerID").setParameter("CustomerID", sCustomerID).setParameter("CertID", sCertID));
			//其他证件
			}else{
				Sqlca.executeSQL(new SqlObject("update ENT_INFO set CorpID = :CorpID where CustomerID = :CustomerID").setParameter("CustomerID", sCustomerID).setParameter("CorpID", sCertID));
			}
		//[02] 关联集团客户
  		}else if(sCustomerType.substring(0,2).equals("02")){
			//更新组织机构代码（系统自动虚拟，同集团客户编号）
			Sqlca.executeSQL(new SqlObject("update ENT_INFO set CorpID = :CorpID where CustomerID = :CustomerID").setParameter("CustomerID", sCustomerID).setParameter("CorpID", sCustomerID));
  		}*/
  	}
  	
  	/**
  	 * 插入数据至IND_INFO,不同的证件类型，插入的字段会有区别
  	 * @throws Exception 
  	 */
  	private void insertIndInfo(String certType) throws Exception{
  		String sCertID18 = "";
  		StringBuffer sbSql = new StringBuffer("");
  		//如果为身份证,则作18位转换
  		if(certType.equals("Ind01")){
  			sCertID18 = StringFunction.fixPID(sCertID);
  		}else{
  			sCertID18 = "";
  		}
		/***************begin CCS-1334 二段式提单huzp***********************/
		if("1".equals(switch_status)){
		sbSql.append("insert into IND_INFO(")
		.append(" CustomerID,")					//010.客户ID
		.append(" CustomerName,")				//020.客户名
		.append(" CustomerType,")				//020.客户类型
		.append(" CertType,")					//030.证件类型
		.append(" CertID,")						//040.证件号
		.append(" CertID18,")					//050.18位证件号
		.append(" InputOrgID,")					//060.登记机构
		.append(" InputUserID,")				//070.登记人
		.append(" InputDate,")					//080.登记日期
		.append(" UpdateDate,")					//090.更新日期

		.append(" MobileTelephone,")					//手机号
		.append(" WorkCorp,")							//单位名称
		.append(" SelfMonthIncome,")					//个人月收入
		.append(" RelativeType,")						//亲属关系
		.append(" KinshipName,")						//亲属姓名
		.append(" KinshipTel,")							//亲属联系电话
		.append(" Contactrelation,")					//其他联系人关系
		.append(" OtherContact,")						//其他联系人姓名
		.append(" ContactTel,")							//其他联系人电话
		
		.append(" TempSaveFlag")				//100.暂存标志
		.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :CertID18, :sOrgID, :sUserID, :InputDate, :UpdateDate,"
				+ ":MobileTelephone, :WorkCorp, :SelfMonthIncome, :RelativeType, :KinshipName, :KinshipTel, :Contactrelation, :OtherContact, :ContactTel, '1')");
		SqlObject so = new SqlObject(sbSql.toString()).setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("CustomerType", sCustomerType)
				.setParameter("CertType", sCertType).setParameter("CertID", sCertID).setParameter("CertID18", sCertID18)
				.setParameter("sOrgID", sOrgID).setParameter("sUserID", sUserID).setParameter("InputDate", sToday).setParameter("UpdateDate", sToday)
				.setParameter("MobileTelephone", MobileTelephone).setParameter("WorkCorp", WorkCorp).setParameter("SelfMonthIncome", SelfMonthIncome).setParameter("RelativeType", RelativeType)
				.setParameter("KinshipName", KinshipName).setParameter("KinshipTel", KinshipTel).setParameter("Contactrelation", Contactrelation).setParameter("OtherContact", OtherContact)
				.setParameter("ContactTel", ContactTel);
		Sqlca.executeSQL(so);
		}else{
			sbSql.append("insert into IND_INFO(")
			.append(" CustomerID,")					//010.客户ID
			.append(" CustomerName,")				//020.客户名
			.append(" CustomerType,")				//020.客户类型
			.append(" CertType,")					//030.证件类型
			.append(" CertID,")						//040.证件号
			.append(" CertID18,")					//050.18位证件号
			.append(" InputOrgID,")					//060.登记机构
			.append(" InputUserID,")				//070.登记人
			.append(" InputDate,")					//080.登记日期
			.append(" UpdateDate,")					//090.更新日期
			.append(" TempSaveFlag")				//100.暂存标志
			.append(" )values(:CustomerID, :CustomerName, :CustomerType, :CertType, :CertID, :CertID18, :sOrgID, :sUserID, :InputDate, :UpdateDate, '1')");
		SqlObject so = new SqlObject(sbSql.toString()).setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("CustomerType", sCustomerType)
					.setParameter("CertType", sCertType).setParameter("CertID", sCertID).setParameter("CertID18", sCertID18)
					.setParameter("sOrgID", sOrgID).setParameter("sUserID", sUserID).setParameter("InputDate", sToday).setParameter("UpdateDate", sToday);
		Sqlca.executeSQL(so);
		}
		/********************end******************************/
  	}
	/**
  	 * 插入数据至CUSTOMER_CENTER
  	 * @throws Exception 
  	 */
	private void insertcustomercentre() throws Exception{
  		StringBuffer sbSql = new StringBuffer("");
  		sbSql.append("INSERT INTO CUSTOMER_CENTER(")
  		.append(" CustomerID,")	
  		.append(" CUSTOMERNAME,")
  		.append(" CERTID,")
  		.append(" CertType")	
  		.append(" )values(:CustomerID, :CustomerName, :CertID,:CertType)");
  		SqlObject so = new SqlObject(sbSql.toString())
  		.setParameter("CustomerID", sCustomerID)
  		.setParameter("CustomerName", sCustomerName)
  		.setParameter("CertID", sCertID)
  		.setParameter("CertType", sCertType);
  		Sqlca.executeSQL(so);
  	}
  	
}
