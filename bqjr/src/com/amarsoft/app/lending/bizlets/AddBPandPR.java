/*
 * 		Author: sjchuan 2009-09-23
 * 		Tester:
 * 		Describe: 将票据业务的合同基本信息复制到BUSINESS_PUTOUT，将票据信息和出账信息的关联复制到PUTOUT_RELATIVE中
 * 		Input Param:
 * 				ObjectType: 合同对象
 * 				ObjectNo: 合同流水号
 * 				UserID：用户编号
 * 		Output Param:
 * 				SerialNo：出账流水号
 * 		HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class AddBPandPR extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//获得合同对象
		String sObjectType = (String)this.getAttribute("ObjectType");
		//获得合同流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//获得业务品种
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//获得汇票编号
		String sBillNo = (String)this.getAttribute("BillNo");
		//获取当前用户
		String sUserID = (String)this.getAttribute("UserID");
		
		SqlObject so = null;//声明对象
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sBillNo == null) sBillNo = "";
		if(sUserID == null) sUserID = "";
		
		//定义变量：出帐流水号
		String sSerialNo = "";
		//定义变量：出帐流水号字符串（@分隔）
		String sSerialNoStr = "";
		//定义变量：Sql语句
		String sSql = "";
		//定义变量：发生类型
		String sOccurType = "";
		//定义变量：交易代码
		String sExchangeType = "";	
		//实例化用户对象
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		//根据合同流水号获取发生类型
		so = new SqlObject("select OccurType from BUSINESS_CONTRACT where SerialNo =:SerialNo ");
		so.setParameter("SerialNo", sObjectNo);
		sOccurType = Sqlca.getString(so);
		
			//将空值转化为空字符串			
		if(sOccurType == null) sOccurType = "";
	
		//根据业务品种获取交易代码
		so = new SqlObject("select SubTypeCode from BUSINESS_TYPE where TypeNo=:TypeNo ");
		so.setParameter("TypeNo", sBusinessType);
		sExchangeType = Sqlca.getString(so);
		
		//将空值转化为空字符串
		if(sExchangeType == null) sExchangeType = "";
		if(sOccurType.equals("015")) //展期
		{
			sExchangeType = "6201";
		}
		
		//当业务品种为银行承兑汇票贴现、商业承兑汇票贴现、协议付息票据贴现
		//
		//获得出帐流水号
		sSerialNo = DBKeyHelp.getSerialNo("BUSINESS_PUTOUT","SerialNo","",Sqlca);
		//因为票据业务的出账申请并不是对某一张具体的票据信息进行出账申请，所以并不需要将具体的票据信息复制到出账信息表中，复制自己定义的默认值即可
        sBillNo = null;
		String sBillSum ="0.0" ;
		String sRate = "0.0";
		String sMaturity ="";					
		String sEndorseTimes = "0";
		//将合同信息复制到出帐信息中
		sSql =  "insert into BUSINESS_PUTOUT ( "+
				"SerialNo, " + 
				"ExchangeType, " +
				"BillNo, " +
				"BillSum, " +
				"BusinessSum, " +
				"BusinessRate, " +
				"Maturity, " +
				"FixCyc, " +												
				"OperateOrgID, " + 
				"OperateUserID, " + 
				"OperateDate, " + 	
				"InputOrgID, " +
				"InputUserID, " + 
				"InputDate, " + 
				"UpdateDate, " + 	
				"ContractSerialNo, " + 
				"ArtificialNo, " + 					
				"CustomerID, " +
				"CustomerName, " +
				"BusinessType, " +				
				"BusinessCurrency, " +
				"ContractSum, " +					
				"TermYear, " +
				"TermMonth, " +
				"TermDay, " +
				"PutoutDate, " +
				"ICType, " +
				"ICCyc, " +
				"PayCyc, " +					
				"CorpusPayMethod, " +
				"CreditAggreement, " +
				"Purpose, " +
				"RateFloatType, " +
				"PdgSum, " +
				"PdgPayMethod, " +
				"ConsignAccountNo, " +
				"AccountNo, " +
				"LoanAccountNo, " +
				"SecondPayAccount, " +					
				"OccurDate, " +					
				"BaseRateType, " +
				"BaseRate, " +
				"RateFloat, " +
				"AdjustRateType, " +
				"AdjustRateTerm, " +
				"AcceptIntType, " +
				"OverIntType, " +
				"RateAdjustCyc, " +
				"PdgAccountNo, " +
				"BailAccount, " +
				"FZANBalance, " +
				"BailCurrency, " +
				"BailRatio, " +
				"RiskRate, " +	
				"PreIntType, " +
				"ResumeIntType " +								
				") "+
				"select "+ 
				"'"+sSerialNo+"', " + 
				"'"+sExchangeType+"', " +	
				"'"+sBillNo+"', " +
				""+sBillSum+", " +
				""+sBillSum+", " +
				""+sRate+", " +
				"'"+sMaturity+"', " +							
				""+sEndorseTimes+", " +	
				"'"+CurUser.getOrgID()+"', " + 
				"'"+CurUser.getUserID()+"', " + 
				"'"+StringFunction.getToday()+"', " + 
				"'"+CurUser.getOrgID()+"', " + 
				"'"+CurUser.getUserID()+"', " + 
				"'"+StringFunction.getToday()+"', " + 
				"'"+StringFunction.getToday()+"', " + 	
				"SerialNo, " + 
				"ArtificialNo, " + 					
				"CustomerID, " +
				"CustomerName, " +
				"BusinessType, " +				
				"BusinessCurrency, " +
				"BusinessSum, " +
				"TermYear, " +
				"TermMonth, " +
				"TermDay, " +
				"'', " +							
				"ICType, " +
				"ICCyc, " +
				"PayCyc, " +					
				"CorpusPayMethod, " +
				"CreditAggreement, " +
				"Purpose, " +
				"RateFloatType, " +
				"PdgSum, " +
				"PdgPayMethod, " +
				"ThirdPartyAccounts, " +
				"AccountNo, " +
				"LoanAccountNo, " +
				"SecondPayAccount, " +
				"OccurDate, " +										
				"BaseRateType, " +
				"BaseRate, " +
				"RateFloat, " +
				"AdjustRateType, " +
				"AdjustRateTerm, " +
				"AcceptIntType, " +
				"OverIntType, " +
				"RateAdjustCyc, " +
				"PdgAccountNo, " +
				"BailAccount, " +
				"PdgRatio, " +
				"BailCurrency, " +
				"BailRatio, " +
				"RiskRate, " +								
				"'0', " +
				"'1' " +							
				"from BUSINESS_CONTRACT " +
				"where SerialNo='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);	
		//建立某次出账申请与某笔票据的关联
		sSql =  "insert into PUTOUT_RELATIVE ("+
				"PutOutNo, " +
				"SerialNo, " +
				"OccurDate, " +
				"InputUserID, " +
				"BusinessType " +
				") "+
				"select "+ 
				"'"+sSerialNo+"', " + 
				"SerialNo, " +	
				"'"+StringFunction.getToday()+"', " + 
				"'"+CurUser.getUserID()+"', " + 
				"'"+sBusinessType+"' " + 			
				"from BILL_INFO " +
				"where ObjectNo='"+sObjectNo+"' and ObjectType ='BusinessContract'";
		Sqlca.executeSQL(sSql);
		
		sSerialNoStr = sSerialNoStr + sSerialNo + "@";
		return sSerialNoStr;
	}	
}
