package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class AddCustomerInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sCustomerName = (String)this.getAttribute("CustomerName");
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");
		String sLoanCardNo = (String)this.getAttribute("LoanCardNo");
		String sUserID = (String)this.getAttribute("UserID");
		String sCustomerType = (String)this.getAttribute("CustomerType");
		
		//将空值转化为空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";
		if(sLoanCardNo == null) sLoanCardNo = "";
		if(sUserID == null) sUserID = "";
		if(sCustomerType == null) sCustomerType = "";
		
		SqlObject so = null;//声明对象
		
		//定义变量
		ASResultSet rs = null;
		String sSql = "";
		int iCount = 0;
		
		//实例化用户对象
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		
		//根据客户编号查询系统中是否已建立信贷关系
		sSql = 	" select count(CustomerID) from CUSTOMER_INFO "+
		" where CustomerID =:CustomerID"; 
		so = new SqlObject(sSql);
		so.setParameter("CustomerID", sCustomerID);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		if(iCount == 0){			
			if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ent"))//公司客户，如果客户类型小于3个字符，无需比较
			{
				if(sCustomerType.equals("")) sCustomerType="0110";//如果外部没有传入客户类型，则自动默认为大型企业
				//在CI表中新建记录	
				//客户编号、客户名称、客户类型、证件类型、证件编号、登记机构、登记人、登记日期	、来源渠道、贷款卡编号
				sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel,LoanCardNo) "+
				   " values(:CustomerID,:CustomerName,:CustomerType,:CertType,:CertID,:InputOrgID, "+
				   " :InputUserID,:InputDate,'2',:LoanCardNo)";
				so = new SqlObject(sSql);
				so.setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName)
				.setParameter("CustomerType", sCustomerType)
				.setParameter("CertType", sCertType).setParameter("CertID", sCertID).setParameter("InputOrgID", CurUser.getOrgID())
				.setParameter("InputUserID", CurUser.getUserID())
				.setParameter("InputDate", StringFunction.getToday()).setParameter("LoanCardNo", sLoanCardNo);
				Sqlca.executeSQL(so);
				
				//证件类型为组织机构代码
				if(sCertType.equals("Ent01"))
				{
					//客户编号、组织机构代码证编号、客户名称、机构性质、集团客户标志、登记机构、登记人、登记日期、更新机构、更新人、更新日期、贷款卡编号
					sSql = " insert into ENT_INFO(CustomerID,CorpID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
					   " values(:CustomerID,:CorpID,:EnterpriseName,'0101','0',:InputOrgID,:InputUserID, "+
					   " :InputDate,:UpdateOrgID,:UpdateUserID,:UpdateDate,:LoanCardNo)";
					so = new SqlObject(sSql);
					so.setParameter("CustomerID", sCustomerID).setParameter("CorpID", sCertID).setParameter("EnterpriseName", sCustomerName).setParameter("InputOrgID", CurUser.getOrgID())
					.setParameter("InputUserID", CurUser.getUserID()).setParameter("InputDate", StringFunction.getToday()).setParameter("UpdateOrgID", CurUser.getOrgID())
					.setParameter("UpdateUserID", CurUser.getUserID()).setParameter("UpdateDate",StringFunction.getToday()).setParameter("LoanCardNo", sLoanCardNo);
					Sqlca.executeSQL(so);
					
				//证件类型为营业执照
				}else if(sCertType.equals("Ent02"))
				{
					//客户编号、营业执照号、客户名称、机构性质、集团客户标志、登记机构、登记人、登记日期、更新机构、更新人、更新日期、贷款卡编号
					sSql = " insert into ENT_INFO(CustomerID,LicenseNo,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
					   " values(:CustomerID,:LicenseNo,:EnterpriseName,'0101','0',:InputOrgID,:InputUserID, "+
					   " :InputDate,:UpdateOrgID,:UpdateUserID,:UpdateDate,:LoanCardNo)";
					so = new SqlObject(sSql);
					so.setParameter("CustomerID", sCustomerID).setParameter("LicenseNo", sCertID).setParameter("EnterpriseName", sCustomerName).setParameter("InputOrgID", CurUser.getOrgID())
					.setParameter("InputUserID", CurUser.getUserID()).setParameter("InputDate", StringFunction.getToday()).setParameter("UpdateOrgID", CurUser.getOrgID())
					.setParameter("UpdateUserID", CurUser.getUserID()).setParameter("UpdateDate", StringFunction.getToday()).setParameter("LoanCardNo", sLoanCardNo);
					Sqlca.executeSQL(so);
				
				}else
				{
					//客户编号、客户名称、机构性质、集团客户标志、登记机构、登记人、登记日期、更新机构、更新人、更新日期、贷款卡编号
					sSql = " insert into ENT_INFO(CustomerID,EnterpriseName,OrgNature,GroupFlag,InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate,LoanCardNo) "+
					   " values(:CustomerID,:EnterpriseName,'0101','0',:InputOrgID,:InputUserID,:InputDate, "+
					   " :UpdateOrgID,:UpdateUserID,:UpdateDate,:LoanCardNo)";
					so = new SqlObject(sSql);
					so.setParameter("CustomerID", sCustomerID).setParameter("EnterpriseName", sCustomerName).setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID())
					.setParameter("InputDate", StringFunction.getToday()).setParameter("UpdateOrgID", CurUser.getOrgID()).setParameter("UpdateUserID", CurUser.getUserID())
					.setParameter("UpdateDate", StringFunction.getToday()).setParameter("LoanCardNo", sLoanCardNo);
					Sqlca.executeSQL(so);
				}	
			}else if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ind")) //个人客户，如果客户类型小于3个字符，无需比较
			{
				if(sCustomerType.equals("")) sCustomerType="0310";//如果外部没有传入客户类型，则自动默认为个人客户
				//在CI表中新建记录	
				//客户编号、客户名称、客户类型、证件类型、证件编号、登记机构、登记人、登记日期	、来源渠道、贷款卡编号
				sSql = " insert into CUSTOMER_INFO(CustomerID,CustomerName,CustomerType,CertType,CertID,InputOrgID,InputUserID,InputDate,Channel,LoanCardNo) "+
				   " values(:CustomerID,:CustomerName,:CustomerType,:CertType,:CertID,:InputOrgID, "+
				   " :InputUserID,:InputDate,'2',null)";
				so = new SqlObject(sSql);
				so.setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("CustomerType", sCustomerType)
				.setParameter("CertType", sCertType).setParameter("CertID", sCertID).setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID())
				.setParameter("InputDate", StringFunction.getToday());
				Sqlca.executeSQL(so);
				
				//客户编号、姓名、证件类型、证件编号、登记机构、登记人、登记日期、更新日期
				sSql = " insert into IND_INFO(CustomerID,FullName,CertType,CertID,InputOrgID,InputUserID,InputDate,UpdateDate) "+
				   " values(:CustomerID,:FullName,:CertType,:CertID,:InputOrgID, "+
				   " :InputUserID,:InputDate,:UpdateDate)";
				so = new SqlObject(sSql);
				so.setParameter("CustomerID", sCustomerID).setParameter("FullName", sCustomerName).setParameter("CertType", sCertType).setParameter("CertID", sCertID)
				.setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID()).setParameter("InputDate", StringFunction.getToday())
				.setParameter("UpdateDate", StringFunction.getToday());
				Sqlca.executeSQL(so);
				
			}else{
				return "1";
			}
			
			String[] belongAttribute = {"1","1","1","1","1"};	//由于新增，默认赠予全部权限
			insertCustomerBelong(belongAttribute,sCustomerID,CurUser,Sqlca);
		}else{
			sSql = " select LoanCardNo from CUSTOMER_INFO where CustomerID =:CustomerID ";
			so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			String sExistLoanCardNo = Sqlca.getString(so);
			if(sExistLoanCardNo == null) sExistLoanCardNo = "";
			
			if(sExistLoanCardNo.equals("") || !sExistLoanCardNo.equals(sLoanCardNo))
			{
				sSql = "update CUSTOMER_INFO set LoancardNo =:LoancardNo where CustomerID =:CustomerID";
				so = new SqlObject(sSql);
				so.setParameter("LoancardNo", sLoanCardNo).setParameter("CustomerID", sCustomerID);
				Sqlca.executeSQL(so);
				
				//更新ENT_INFO和IND_INFO中的贷款卡号，保持一致
				if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ent"))//公司客户，如果客户类型小于3个字符，无需比较
			    {
					sSql =  " update ENT_INFO set LoanCardNo =:LoanCardNo where CustomerID =:CustomerID";
					so = new SqlObject(sSql).setParameter("LoanCardNo", sLoanCardNo).setParameter("CustomerID", sCustomerID);
					Sqlca.executeSQL(so);
					
			    }else if(sCertType.length()>2&&sCertType.substring(0,3).equals("Ind")) //个人客户，如果客户类型小于3个字符，无需比较
			    {
			    	sSql =  " update IND_INFO set LoanCardNo =:LoanCardNo  where CustomerID =:CustomerID ";
			    	so = new SqlObject(sSql).setParameter("LoanCardNo", sLoanCardNo).setParameter("CustomerID", sCustomerID);
			    	Sqlca.executeSQL(so);
			    }
			}
			String[] belongAttribute = {"2","1","2","2","2"};	//只给信息查看权
			insertCustomerBelong(belongAttribute,sCustomerID,CurUser,Sqlca);
		}
		return "1";
	}
	
	/**
	 * 插入数据至CUSTOMER_BELONG
	 * 如果该客户的权限属性没有，则与传入的客户建立此关联，若存在，则不用建立了
	 * @param attribute [主办权，信息查看权，信息维护权，业务办理权]标志,如果长度不足五个，则后面的使用默认值2,如果多余五个，则只取前五个
	 * @param sCustomerID 客户ID
	 * @param CurUser 相关用户
	 * @param Sqlca
	 * @throws Exception
	 */
  	private void insertCustomerBelong(String[] attribute,String sCustomerID,ASUser CurUser,Transaction Sqlca) throws Exception{
  		//检查当前客户与用户建立关联信息
  		boolean bExists = false;
  		String[] belongAttribute = {"2","2","2","2","2"};	//默认无任何权限
  		for(int i=0;i<attribute.length&&i<belongAttribute.length;i++){
  			belongAttribute[i] = attribute[i];
  		}
  		
  		//检查客户是否与当前用户 建立关联了，如果已建立，则不用再建立其他关联了
  		String sSql = " select UserID from CUSTOMER_BELONG "+
		" where CustomerID =:CustomerID and UserID=:UserID";
  		SqlObject so = new SqlObject(sSql);
  		so.setParameter("CustomerID", sCustomerID).setParameter("UserID", CurUser.getUserID());
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			bExists = true;
		}
		rs.getStatement().close();
		rs = null;
  		if(bExists == false){
  		sSql = "insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3," +
  				" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate)"+
  				" values (:CustomerID,:OrgID,:UserID,:BelongAttribute,:BelongAttribute1,:BelongAttribute2,:BelongAttribute3," +
  				" :BelongAttribute4,:InputOrgID,:InputUserID,:InputDate,:UpdateDate)";
  		so = new SqlObject(sSql);
  		so.setParameter("CustomerID", sCustomerID).setParameter("OrgID", CurUser.getOrgID()).setParameter("UserID", CurUser.getUserID()).setParameter("BelongAttribute", belongAttribute[0])
  		.setParameter("BelongAttribute1", belongAttribute[1]).setParameter("BelongAttribute2", belongAttribute[2]).setParameter("BelongAttribute3", belongAttribute[3])
  		.setParameter("BelongAttribute4", belongAttribute[4]).setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID())
  		.setParameter("InputDate", StringFunction.getToday()).setParameter("UpdateDate", StringFunction.getToday());
  		Sqlca.executeSQL(so);
  		
  		}
  	}
}
