package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateCustomerInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//获得参数：变更后的客户名称、证件类型、证件编号和贷款卡编号
	 	String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sNewCustomerName   = (String)this.getAttribute("NewCustomerName");
		String sNewCertType   = (String)this.getAttribute("NewCertType");
		String sNewCertID = (String)this.getAttribute("NewCertID");
		String sNewLoanCardNo = (String)this.getAttribute("NewLoanCardNo");
		//获得参数：流水号，修改机构，修改用户和修改时间
		boolean sDo = false;
		String sInputUserID = "";
		String sInputOrgID= "";
		String sInputDate = "";
		String sSerialNo = "";
		if(sCustomerID.indexOf("@")>0){
			String[] get = sCustomerID.split("@");
			sDo = true;
			sCustomerID = get[0];
			sInputUserID = get[1];
			sInputOrgID = get[2];
			sInputDate = get[3];
			sSerialNo = get[4];
		}

		//定义变量
		String sSql = "",sCustomerType = "";
		ASResultSet rs = null;//存放结果集
		String sOldCustomerName = "";//存放旧客户名称
		String sOldCertType = "";//存放旧证件类型
		String sOldCertID = "";//存放旧证件ID
		String sOldLoanCardNo = "";//存放旧贷款卡号
		SqlObject so; //声明对象
		
		//获取相关信息	
		sSql = " select CustomerName,CustomerType,CertType,CertID,LoanCardNo from CUSTOMER_INFO where CustomerID =:CustomerID ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			sOldCustomerName = rs.getString("CustomerName");
			sCustomerType = rs.getString("CustomerType");
			sOldCertType = rs.getString("CertType");
			sOldCertID = rs.getString("CertID");
			sOldLoanCardNo = rs.getString("LoanCardNo");
		}
		rs.getStatement().close();
		
		if (sCustomerType == null) sCustomerType = "";
		
		if(sDo){
		    //更新客户基本信息变更表
			sSql = " insert into CUSTOMER_INFO_CHANGE "+
		    	   "(SerialNo,CustomerID,OldCustomerName,NewCustomerName," +
		    	   "CustomerType,OldCertType,NewCertType,OldCertID,NewCertID," +
		    	   "OldLoanCardNo,NewLoanCardNo,InputOrgID,InputUserID,InputDate)" +
		    	   "values(:SerialNo, "+
		    	   ":CustomerID, "+
		    	   ":OldCustomerName, "+
		    	   ":NewCustomerName, "+
		    	   ":CustomerType, "+
		    	   ":OldCertType, "+
		    	   ":NewCertType, "+
		    	   ":OldCertID, "+
		    	   ":NewCertID, "+
		    	   ":OldLoanCardNo, "+
		    	   ":NewLoanCardNo, "+
		    	   ":InputOrgID, "+
		    	   ":InputUserID, "+
		    	   ":InputDate"+")";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", sSerialNo).setParameter("CustomerID", sCustomerID).setParameter("OldCustomerName", sOldCustomerName)
			.setParameter("NewCustomerName", sNewCustomerName).setParameter("CustomerType", sCustomerType).setParameter("OldCertType", sOldCertType)
			.setParameter("NewCertType", sNewCertType).setParameter("OldCertID", sOldCertID).setParameter("NewCertID", sNewCertID)
			.setParameter("OldLoanCardNo", sOldLoanCardNo).setParameter("NewLoanCardNo", sNewLoanCardNo).setParameter("InputOrgID", sInputOrgID)
			.setParameter("InputUserID", sInputUserID).setParameter("InputDate", sInputDate);
		    //执行插入语句
		    Sqlca.executeSQL(so);
		    }
			
		//控制空值情况
		if(sNewCustomerName == null||"".equals(sNewCustomerName)) sNewCustomerName = sOldCustomerName;
		if(sNewCertType == null||("".equals(sNewCertType))) sNewCertType = sOldCertType;
		if(sNewCertID == null||"".equals(sNewCertID)) sNewCertID = sOldCertID;
		if(sNewLoanCardNo == null||"".equals(sNewLoanCardNo)) sNewLoanCardNo = sOldLoanCardNo;
		
	    //更新客户基本信息表
		sSql = " update CUSTOMER_INFO set "+
		 	   " CustomerName =:CustomerName, "+
		 	   " CertType=:CertType, "+
		       " CertID =:CertID, "+
		       " LoanCardNo =:LoanCardNo "+
		       " where CUSTOMERID =:CUSTOMERID " ;
		so = new SqlObject(sSql).setParameter("CustomerName", sNewCustomerName).setParameter("CertType", sNewCertType)
		.setParameter("CertID", sNewCertID).setParameter("LoanCardNo", sNewLoanCardNo).setParameter("CUSTOMERID", sCustomerID);
		 Sqlca.executeSQL(so);
	    
	    if (!sCustomerType.equals("03")) //非个人客户
	    {
	    	
			if(sNewCertType.equals("Ent01"))//证件类型为组织机构代码
			{
				//更新企业基本信息表
				sSql = " update ENT_INFO set "+
			    	   " EnterpriseName =:EnterpriseName, "+
			    	   " CorpID =:CorpID, "+
			    	   " LoanCardNo =:LoanCardNo "+
		        	   " where CustomerID =:CustomerID " ;
				so = new SqlObject(sSql).setParameter("EnterpriseName", sNewCustomerName).setParameter("CorpID", sNewCertID)
				.setParameter("LoanCardNo", sNewLoanCardNo).setParameter("CustomerID", sCustomerID);
			}else if(sNewCertType.equals("Ent02"))//证件类型为营业执照
			{
				//更新企业基本信息表
				sSql = " update ENT_INFO set "+
			    	   " EnterpriseName =:EnterpriseName, "+
			    	   " LicenseNo =:LicenseNo, "+
			    	   " LoanCardNo =:LoanCardNo "+
		        	   " where CustomerID =:CustomerID " ;
				so= new SqlObject(sSql).setParameter("EnterpriseName", sNewCustomerName).setParameter("LicenseNo", sNewCertID)
				.setParameter("LoanCardNo", sNewLoanCardNo).setParameter("CustomerID", sCustomerID);
			}else
			{
		    	//更新企业基本信息表
				 sSql = " update ENT_INFO set "+
			    	   " EnterpriseName =:EnterpriseName, "+
			    	   " LoanCardNo =:LoanCardNo "+
		        	   " where CustomerID =:CustomerID " ;
				 so = new SqlObject(sSql).setParameter("EnterpriseName", sNewCustomerName).setParameter("LoanCardNo", sNewLoanCardNo)
				 .setParameter("CustomerID", sCustomerID);
			}
	    }else
	    {
		    //更新个人基本信息表
	    	sSql = " update IND_INFO set "+
		    	   " FullName =:FullName, "+
		    	   " CertType=:CertType, "+
		     	   " CertID =:CertID "+
		     	   " where CustomerID =:CustomerID " ;
	    	so = new SqlObject(sSql).setParameter("FullName", sNewCustomerName).setParameter("CertType", sNewCertType)
	    	.setParameter("CertID", sNewCertID).setParameter("CustomerID", sCustomerID);
	    }
	    //执行更新语句
	    Sqlca.executeSQL(so);	
	    
	    //更新案件台帐信息表
	    sSql = " update LAWCASE_BOOK set "+
		 	   " BankruptcyOrgName =:BankruptcyOrgName "+
		 	   " where BankruptcyOrgID =:BankruptcyOrgID " ;
	    so = new SqlObject(sSql).setParameter("BankruptcyOrgName", sNewCustomerName).setParameter("BankruptcyOrgID", sCustomerID);
		 //执行更新语句
		 Sqlca.executeSQL(so);
	    //更新担保合同信息表
		 sSql = " update GUARANTY_CONTRACT set "+
		  	    " GuarantorName =:GuarantorName, "+
		  	    " CertType=:CertType, "+	    	   
		  	    " CertID =:CertID, "+
		  	    " LoanCardNo =:LoanCardNo "+
		  	    " where GuarantorID =:GuarantorID " ;
		 so = new SqlObject(sSql).setParameter("GuarantorName", sNewCustomerName).setParameter("CertType", sNewCertType)
		 .setParameter("CertID", sNewCertID).setParameter("LoanCardNo", sNewLoanCardNo).setParameter("GuarantorID", sCustomerID);
		  Sqlca.executeSQL(so);
	    //更新担保物和资产情况变更记录表
		  sSql = " update GUARANTY_CHANGE set "+
			   	 " OldOwnerName =:OldOwnerName, "+
			   	 " OldCertType=:OldCertType, "+	    	   
			   	 " OldCertID =:OldCertID, "+
			   	 " OldLoanCardNo =:OldLoanCardNo "+
			   	 " where OldOwnerID =:OldOwnerID " ;
		  so = new SqlObject(sSql).setParameter("OldOwnerName", sNewCustomerName).setParameter("OldCertType", sNewCertType)
		  .setParameter("OldCertID", sNewCertID).setParameter("OldLoanCardNo", sNewLoanCardNo).setParameter("OldOwnerID", sCustomerID);
		   Sqlca.executeSQL(so);
		   
		   sSql = " update GUARANTY_CHANGE set "+
		    	  " NewOwnerName =:NewOwnerName, "+
		    	  " NewCertType=:NewCertType, "+	    	   
		    	  " NewCertID =:NewCertID, "+
		    	  " NewLoanCardNo =:NewLoanCardNo "+
		    	  " where NewOwnerID =:NewOwnerID " ;
		   
		   so = new SqlObject(sSql).setParameter("NewOwnerName", sNewCustomerName).setParameter("NewCertType", sNewCertType)
		   .setParameter("NewCertID", sNewCertID).setParameter("NewLoanCardNo", sNewLoanCardNo).setParameter("NewOwnerID", sCustomerID);
		Sqlca.executeSQL(so);	
	    
	    //更新担保物信息表
		sSql = " update GUARANTY_INFO set "+
		 	   " OwnerName =:OwnerName, "+
		 	   " CertType=:CertType, "+	    	   
		 	   " CertID =:CertID, "+
		 	   " LoanCardNo =:LoanCardNo "+
		 	   " where OwnerID =:OwnerID " ;
		so = new SqlObject(sSql).setParameter("OwnerName", sNewCustomerName).setParameter("CertType", sNewCertType)
		.setParameter("CertID", sNewCertID).setParameter("LoanCardNo", sNewLoanCardNo).setParameter("OwnerID", sCustomerID);
		 Sqlca.executeSQL(so);	   
	    //更新个人工作履历表
		 sSql = " update IND_RESUME set "+
		  	    " Employment =:Employment "+
		  	    " where CompanyCode =:CompanyCode " ;
	  //执行更新语句
		 so = new SqlObject(sSql).setParameter("Employment", sNewCustomerName).setParameter("CompanyCode", sCustomerID);
		 Sqlca.executeSQL(so);
  
	    //更新客户关联信息表
	  sSql = " update CUSTOMER_RELATIVE set "+
			 " CustomerName =:CustomerName, "+
			 " CertType=:CertType, "+
			 " CertID =:CertID, "+
			 " LoanCardNo =:LoanCardNo "+
			 " where RelativeID =:RelativeID " ;
	  so = new SqlObject(sSql).setParameter("CustomerName", sNewCustomerName).setParameter("CertType", sNewCertType)
	  .setParameter("CertID", sNewCertID)
	  .setParameter("LoanCardNo", sNewLoanCardNo).setParameter("RelativeID", sCustomerID);
	//执行更新语句
	  Sqlca.executeSQL(so);	
	  
	    //更新贸易合同信息表\
	  sSql = " update CONTRACT_INFO set "+
			 " PurchaserName =:PurchaserName "+
			 " where PurchaserID =:PurchaserID " ;
	  //执行更新语句
	  so = new SqlObject(sSql).setParameter("PurchaserName", sNewCustomerName).setParameter("PurchaserID", sCustomerID);
	  Sqlca.executeSQL(so);	  

	    sSql = " update CONTRACT_INFO set "+
		 	   " BargainorName =:BargainorName "+
		 	   " where BargainorID =:BargainorID " ;
		 //执行更新语句
	    so = new SqlObject(sSql).setParameter("BargainorName", sNewCustomerName).setParameter("BargainorID", sCustomerID);
		 Sqlca.executeSQL(so);		 
	    
	    //更新票据信息表
		 sSql = " update BILL_INFO set "+
			  	" Writer =:Writer "+
			  	" where WriterID =:WriterID " ;
		  //执行更新语句
		 so = new SqlObject(sSql).setParameter("Writer", sNewCustomerName).setParameter("WriterID", sCustomerID);
		  Sqlca.executeSQL(so);

		  sSql = " update BILL_INFO "+
			   	 " set Holder =:Holder "+
			   	 " where HolderID =:HolderID " ;
		   //执行更新语句
		  so = new SqlObject(sSql).setParameter("Holder", sNewCustomerName).setParameter("HolderID", sCustomerID);
		   Sqlca.executeSQL(so);
	   
		   sSql = " update BILL_INFO set "+
    	   		  " Beneficiary =:Beneficiary "+
    	   		  " where BeneficiaryID =:BeneficiaryID " ;
		    //执行更新语句
		   so = new SqlObject(sSql).setParameter("Beneficiary", sNewCustomerName).setParameter("BeneficiaryID", sCustomerID);
		    Sqlca.executeSQL(so);	
	    	
		    sSql = " update BILL_INFO set "+
	    	   		" Acceptor =:Acceptor "+
	    	   		" where AcceptorID =:AcceptorID " ;
		    //执行更新语句
		    so = new SqlObject(sSql).setParameter("Acceptor", sNewCustomerName).setParameter("AcceptorID", sCustomerID);
		    Sqlca.executeSQL(so);	
	    
	    //更新项目基本信息表
		    sSql = " update PROJECT_INFO set "+
	    	       " DevelopmentName =:DevelopmentName "+
	    	       " where DevelopmentID =:DevelopmentID " ;
		    //执行更新语句
		    so = new SqlObject(sSql).setParameter("DevelopmentName", sNewCustomerName).setParameter("DevelopmentID", sCustomerID);
		    Sqlca.executeSQL(so);

		    sSql = " update PROJECT_INFO set "+
	    	       " CopartnerName =:CopartnerName "+
	    	       " where CopartnerID =:CopartnerID " ;
		    //执行更新语句
		    so = new SqlObject(sSql).setParameter("CopartnerName", sNewCustomerName).setParameter("CopartnerID", sCustomerID);
		    Sqlca.executeSQL(so);
	    
	    //更新项目资金来源信息表	    
		    sSql = " update PROJECT_FUNDS set "+
	    	   	   " InvestorName =:InvestorName "+
	    	   	   " where InvestorCode =:InvestorCode " ;
	    //执行更新语句
		    so = new SqlObject(sSql).setParameter("InvestorName", sNewCustomerName).setParameter("InvestorCode", sCustomerID);
	    Sqlca.executeSQL(so);
	    

	    //更新业务出帐通知单表
		sSql = " update BUSINESS_PUTOUT set "+
	 	   	   " CustomerName =:CustomerName "+
	 	   	   " where CustomerID =:CustomerID " ;
		 //执行更新语句
		 so = new SqlObject(sSql).setParameter("CustomerName", sNewCustomerName).setParameter("CustomerID", sCustomerID);
		 Sqlca.executeSQL(so);	
	    
	    //更新业务合同信息表
		 sSql = " update BUSINESS_CONTRACT set "+
  	   			" CustomerName =:CustomerName "+
  	   			" where CustomerID =:CustomerID " ;
	  //执行更新语句
		 so = new SqlObject(sSql).setParameter("CustomerName", sNewCustomerName).setParameter("CustomerID", sCustomerID);
		 Sqlca.executeSQL(so);

	    //更新业务借据(账户)信息表
		 sSql = " update BUSINESS_DUEBILL set "+
		 		" CustomerName =:CustomerName "+
		 		" where CustomerID =:CustomerID " ;
		//执行更新语句
	  	so = new SqlObject(sSql).setParameter("CustomerName", sNewCustomerName).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
	    
	    //更新业务批准信息表
		  sSql = " update BUSINESS_APPROVE set "+
	 	   		 " CustomerName =:CustomerName "+
	 	   		 " where CustomerID =:CustomerID " ;
		 //执行更新语句
		  so = new SqlObject(sSql).setParameter("CustomerName", sNewCustomerName).setParameter("CustomerID", sCustomerID);
		  Sqlca.executeSQL(so);
	    //更新业务其他申请人表
		  sSql = " update BUSINESS_APPLICANT set "+
		  		 " ApplicantName =:ApplicantName "+
		  		 " where ApplicantID =:ApplicantID " ;
	   //执行更新语句
		  so = new SqlObject(sSql).setParameter("ApplicantName", sNewCustomerName).setParameter("ApplicantID", sCustomerID);
		  Sqlca.executeSQL(so);
	    
	    //更新业务申请信息表
	   sSql = " update BUSINESS_APPLY set "+
	   		  " CustomerName =:CustomerName "+
	   		  " where CustomerID =:CustomerID " ;
	   //执行更新语句
	   so = new SqlObject(sSql).setParameter("CustomerName", sNewCustomerName).setParameter("CustomerID", sCustomerID);
	   Sqlca.executeSQL(so);	
	   
	    //更新增值税发票信息表
	   sSql = " update INVOICE_INFO set "+
	   		  " PurchaserName =:PurchaserName "+
	   		  " where PurchaserID =:PurchaserID " ;
		//执行更新语句
	   so = new SqlObject(sSql).setParameter("PurchaserName", sNewCustomerName).setParameter("PurchaserID", sCustomerID);
	   Sqlca.executeSQL(so);	
	   
	   sSql = " update INVOICE_INFO set "+
	   		  " BargainorName =:BargainorName "+
	   		  " where BargainorID =:BargainorID " ;
	   //执行更新语句
	   so = new SqlObject(sSql).setParameter("BargainorName", sNewCustomerName).setParameter("BargainorID", sCustomerID);
	   Sqlca.executeSQL(so);
	      
	    return "Success";
	    
	 }

}
