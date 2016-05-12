package com.amarsoft.app.lending.bizlets;

import java.sql.PreparedStatement;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;
import com.amarsoft.core.util.StringUtil;

public class InsertChangeInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sMobilePhone = (String)this.getAttribute("MobilePhone");
		//将空值转化为空字符串
		if(sSerialNo == null) sSerialNo = "";
		
		//定义变量
		ASResultSet rs = null;
		String sSql = "";
		String sBCSerialno="";       //合同流水号
		String sCustomerID="";     //客户ID
	    String sCustomerName="";   //客户名称
	    String sCertID = "";       //证件类型
	   // String sTelPhone="";      //手机号码
	    String sReplaceAccount="";   //旧代扣账户编号
	    String sReplaceName = "";     //旧代扣账户户名
	    String sOpenBank="";      //旧代扣账户开户行 
	    String sCity = "";     //所在代扣账号省市
	    String sRepaymentWay = "";     //还款方式
	    String sInputUserID="";   //录入用户
	    String sInputOrgID = "";     //录入机构
	    String sInputDate="";      //录入日期
	    String sApplySerialno= "";      //申请流水号
		//int iCount = 0;
		
		//实例化用户对象
		SqlObject so = null; //声明对象
		//根据合同流水号查询需要插入至代扣账户信息表WITHHOLD_CHARGE_INFO中的字段。
		sSql = 	" select serialNo,CustomerID,CustomerName,CertID,ReplaceAccount,ReplaceName,OpenBank,city,repaymentway,"
				+ "InputUserID,InputOrgID,InputDate,applyserialno from BUSINESS_CONTRACT "+
		" where SerialNo =:SerialNo "; 
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
		rs = Sqlca.getASResultSet(so);
		while(rs.next()){
			sBCSerialno = rs.getString("serialNo");
			sCustomerID = rs.getString("CustomerID");
			sCustomerName = rs.getString("CustomerName");
			sCertID = rs.getString("CertID");
			//sTelPhone = rs.getString("MobilePhone");
			sReplaceAccount = rs.getString("ReplaceAccount");
			sReplaceAccount = StringUtil.trimToEmpty(sReplaceAccount);//避免往数据库插入NULL字符串
			sReplaceName = rs.getString("ReplaceName");
			sReplaceName = StringUtil.trimToEmpty(sReplaceName);//避免往数据库插入NULL字符串
			sOpenBank = rs.getString("OpenBank");
			sOpenBank = StringUtil.trimToEmpty(sOpenBank);//避免往数据库插入NULL字符串
			sCity = rs.getString("city");
			sCity = StringUtil.trimToEmpty(sCity);//避免往数据库插入NULL字符串
			sRepaymentWay = rs.getString("repaymentway");
			sInputUserID = rs.getString("InputUserID");
			sInputOrgID = rs.getString("InputOrgID");
			sInputDate = rs.getString("InputDate");
			sApplySerialno = rs.getString("applyserialno");
			
			sSql =  "insert into WITHHOLD_CHARGE_INFO ( "+
					"SerialNo, " + 
					"ApplySerialNo, " + 
					"ContractSerialNo, " +
					"CustomerName, " +
					"CustomerID, " +
					"CertID, " +
					"TelPhone, " +
					"OldAccount, " +
					"OldAccountName, " +												
					"OldBankName, " + 
					"OldCity, " +
					"OldRepaymentWay, " +
					"InputUserID, " + 
					"InputOrgID, " + 	
					"InputDate, " +
					"ApplicationType, " +
					"Status " +
					") "+
					"select "+ 
					"'"+DBKeyHelp.getSerialNo("WITHHOLD_CHARGE_INFO","SerialNo","",Sqlca)+"', " + 
					"'"+sApplySerialno+"', " + 
					"'"+sBCSerialno+"', " +	
					"'"+sCustomerName+"', " +
					"'"+sCustomerID+"', " +
					"'"+sCertID+"', " +
					"'"+sMobilePhone+"', " +
					"'"+sReplaceAccount+"', " +							
					"'"+sReplaceName+"', " +	
					"'"+sOpenBank+"', " + 
					"'"+sCity+"', " + 
					"'"+sRepaymentWay+"', " + 
					"'"+sInputUserID+"', " + 
					"'"+sInputOrgID+"', " + 
					"'"+sInputDate+"', " + 
					"'01', " + 
					"'01' " +
					"from BUSINESS_CONTRACT " +
					"where SerialNo= '"+sSerialNo+"'";
			Sqlca.executeSQL(sSql);
			
		}
		rs.getStatement().close();
		return "success";
	}
	
}
