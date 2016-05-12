/*
		Author: --fwang 2009-11-19
		Tester:
		Describe: --绿色通道
		Input Param:
				ObjectNo: 申请流水号
				UserID：用户代码
		Output Param:
				SerialNo：合同流水号
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class GreenWay extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//获得流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");		
		//获取当前用户
		String sUserID = (String)this.getAttribute("UserID");
		//获取批复类型
		String sApproveType = (String)this.getAttribute("ApproveType");
		//获取否决意见
		String sDisagreeOpinion = (String)this.getAttribute("DisagreeOpinion");
		
		//将空值转化成空字符串
		if(sObjectNo == null) sObjectNo = "";		
		if(sUserID == null) sUserID = "";
		
		//获得批复流水号
		String sSerialNoApprove = DBKeyHelp.getSerialNo("BUSINESS_APPROVE","SerialNo","",Sqlca);
		//获得合同流水号
		String sSerialNo = DBKeyHelp.getSerialNo("BUSINESS_CONTRACT","SerialNo","",Sqlca);
		//定义变量：SQL语句、关联流水号1、字段列值、合同对象类型、额度关联流水号、额度协议号、是否可用、额度类型、业务类型
		String sSql = "",sRelativeSerialNo1 = "",sFieldValue = "",sContractObjectType = "",sCRSerialNo="",sLineNo="",sIsInUse="",sFlag="",sBusinessType="";;
		//定义变量:总列数、总列数1、字段列类型
		int iColumnCount = 0,iFieldType = 0;
		//定义变量：查询结果集、查询结果集1
		ASResultSet rs = null,rs1 = null,rs2 = null;
		//实例化用户对象
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		//批复表操作SQL语句
		String sqlInsertBUSINESS_APPROVE = null; //插入批复表
		//批复表数据库操作成员
		PreparedStatement psInsertBUSINESS_APPROVE = null;
		//合同表操作SQL语句
		String sqlInsertBUSINESS_CONTRACT = null; //插入合同表
		//合同表数据库操作成员
		PreparedStatement psInsertBUSINESS_CONTRACT = null;
		
		//设置合同对象
		sContractObjectType = "BusinessContract";
		//将空值转化成空字符串
		if(sContractObjectType == null) sContractObjectType = "";
		SqlObject so=null;
		//定义变量:申请信息
		String sBailCurrency = "",sRateFloatType = "",sBusinessCurrency = "";
		double dBusinessSum = 0.0,dBaseRate = 0.0,dRateFloat = 0.0,dBusinessRate = 0.0;
		double dBailSum = 0.0,dBailRatio = 0.0,dPdgRatio = 0.0,dPdgSum = 0.0;
		int iTermYear = 0,iTermMonth = 0,iTermDay = 0;
		
		//获取最后终审的任务流水号
		so = new SqlObject("select max(SerialNo) from FLOW_OPINION where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo").setParameter("ObjectNo", sObjectNo);
		String sTaskSerialNo = Sqlca.getString(so);
		//根据最后终审的任务流水号和对象编号获取相应的业务信息
		sSql = 	" select BusinessCurrency,BusinessSum,BaseRate, "+
		" RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
		" BailSum,BailRatio,PdgRatio,PdgSum,TermYear, "+
		" TermMonth,TermDay "+
		" from FLOW_OPINION "+
		" where SerialNo =:SerialNo "+
		" and ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("SerialNo", sTaskSerialNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{			
			sBusinessCurrency = rs.getString("BusinessCurrency");
			dBusinessSum = rs.getDouble("BusinessSum");
			dBaseRate = rs.getDouble("BaseRate");
			sRateFloatType = rs.getString("RateFloatType");
			dRateFloat = rs.getDouble("RateFloat");
			dBusinessRate = rs.getDouble("BusinessRate");
			sBailCurrency = rs.getString("BailCurrency");
			dBailSum = rs.getDouble("BailSum");
			dBailRatio = rs.getDouble("BailRatio");
			dPdgRatio = rs.getDouble("PdgRatio");
			dPdgSum = rs.getDouble("PdgSum");			
			iTermYear = rs.getInt("TermYear");
			iTermMonth = rs.getInt("TermMonth");
			iTermDay = rs.getInt("TermDay");
			
			//将空值转化为空字符串			
			if(sBusinessCurrency == null) sBusinessCurrency = "";
			if(sRateFloatType == null) sRateFloatType = "";
			if(sBailCurrency == null) sBailCurrency = "";			
		}
		rs.getStatement().close();
		
		//------------------------------拷贝申请基本信息到批复中--------------------------------------
		//取出申请表中信息
		sSql = "select "+ 
				"'"+sSerialNoApprove+"', " +  
				"SerialNo, " + 
				" "+dBusinessSum+", " + 
				"'"+CurUser.getOrgID()+"', " +
				"'"+CurUser.getUserID()+"', " +
				"'"+StringFunction.getToday()+"', " +
				"'"+StringFunction.getToday()+"', " +
				"'"+sApproveType+"', " + 
				"BusinessType, "+ 
				"'"+sDisagreeOpinion+"', " + 
				"'1', "+
				"'"+StringFunction.getToday()+"', " +
				"CustomerID, " +
				"CustomerName, " +
				"BusinessSubType, " +
				"OccurType, " +
				"FundSource, " +
				"OperateType, " +
				"CurrenyList, " +
				"CurrencyMode, " +
				"BusinessTypeList, " +
				"CalculateMode, " +
				"UseOrgList, " +
				"CycleFlag, " +
				"FlowReduceFlag, " +
				"ContractFlag, " +
				"SubContractFlag, " +
				"SelfUseFlag, " +
				"CreditAggreeMent, " +
				"RelativeAgreement, " +
				"LoanFlag, " +
				"TotalSum, " +
				"OurRole, " +
				"Reversibility, " +
				"BillNum, " +
				"HouseType, " +
				"LCTermType, " +
				"RiskAttribute, " +
				"SureType, " +
				"SafeGuardType, " +
				" '"+sBusinessCurrency+"', " +
				"BusinessProp, " +
				" "+iTermYear+", " +
				" "+iTermMonth+", " +
				" "+iTermDay+", " +
				"LGTerm, " +
				"BaseRateType, " +
				" "+dBaseRate+", " +
				" '"+sRateFloatType+"', " +
				" "+dRateFloat+", " +
				" "+dBusinessRate+", " +
				"ICType, " +
				"ICCyc, " +
				" "+dPdgRatio+", " +
				" "+dPdgSum+", " +
				"PdgPayMethod, " +
				"PdgPayPeriod, " +
				"PromisesFeeRatio, " +
				"PromisesFeeSum, " +
				"PromisesFeePeriod, " +
				"PromisesFeeBegin, " +
				"MFeeRatio, " +
				"MFeeSum, " +
				"MFeePayMethod, " +
				"AgentFee, " +
				"DealFee, " +
				"TotalCast, " +
				"DiscountInterest, " +
				"PurchaserInterest, " +
				"BargainorInterest, " +
				"DiscountSum, " +
				" "+dBailRatio+", " +
				" '"+sBailCurrency+"', " +
				" "+dBailSum+", " +
				"BailAccount, " +
				"FineRateType, " +
				"FineRate, " +
				"DrawingType, " +
				"FirstDrawingDate, " +
				"DrawingPeriod, " +
				"PayTimes, " +
				"PayCyc, " +
				"GracePeriod, " +
				"OverDraftPeriod, " +
				"OldLCNo, " +
				"OldLCTermType, " +
				"RemitMode, " +
				"OldLCSum, " +
				"OldLCLoadingDate, " +
				"OldLCValidDate, " +
				"Direction, " +
				"Purpose, " +
				"PlanalLocation, " +
				"ImmediacyPaySource, " +
				"PaySource, " +
				"CorpusPayMethod, " +
				"InterestPayMethod, " +
				"ThirdParty1, " +
				"ThirdPartyID1, " +
				"ThirdParty2, " +
				"ThirdPartyID2, " +
				"ThirdParty3, " +
				"ThirdPartyID3, " +
				"ThirdPartyRegion, " +
				"ThirdPartyAccounts, " +
				"CargoInfo, " +
				"ProjectName, " +
				"OperationInfo, " +
				"ContextInfo, " +
				"SecuritiesType, " +
				"SecuritiesRegion, " +
				"ConstructionArea, " +
				"UseArea, " +
				"Flag1, " +
				"Flag2, " +
				"Flag3, " +
				"TradeContractNo, " +
				"InvoiceNo, " +
				"TradeCurrency, " +
				"TradeSum, " +
				"PaymentDate, " +
				"OperationMode, " +
				"VouchClass, " +
				"VouchType, " +
				"VouchType1, " +
				"VouchType2, " +
				"VouchFlag, " +
				"Warrantor, " +
				"WarrantorID, " +
				"OtherCondition, " +
				"GuarantyValue, " +
				"GuarantyRate, " +
				"BaseEvaluateResult, " +
				"RiskRate, " +
				"LowRisk, " +
				"OtherAreaLoan, " +
				"LowRiskBailSum, " +
				"OriginalPutOutDate, " +
				"ExtendTimes, " +
				"LNGOTimes, " +
				"GOLNTimes, " +
				"DRTimes, " +
				"BaseClassifyResult, " +
				"ApplyType, " +
				"BailRate, " +
				"FinishOrg, " +
				"OperateOrgID, " +
				"OperateUserID, " +
				"OperateDate, " +
				"PigeonholeDate, " +
				"Flag4, " +
				"PayCurrency, " +
				"PayDate, "+
				"ClassifyResult, "+
				"ClassifyDate, "+
				"ClassifyFrequency, "+
				"AdjustRateType, "+ 
				"AdjustRateTerm, "+ 
				"FixCyc, "+ 
				"RateAdjustCyc, "+ 
				"FZANBalance, "+ 
				"ThirdPartyAdd2, "+ 
				"ThirdPartyZIP2, "+ 
				"ThirdPartyAdd1, "+ 
				"ThirdPartyZIP1, "+ 
				"ThirdPartyAdd3, "+ 
				"ThirdPartyZIP3, "+ 
				"TermDate1, "+ 
				"TermDate2, "+ 
				"TermDate3, "+ 
				"AcceptIntType, "+ 
				"Ratio, "+ 
				"Describe2, "+
				"Describe1, "+
				"'010', "+
				"CreditCycle "+
				" from BUSINESS_APPLY " +
				" where SerialNo='"+sObjectNo+"'";
		rs2 = Sqlca.getASResultSet(sSql);
		
		//将申请信息复制到批复信息中
		sqlInsertBUSINESS_APPROVE =  " insert into BUSINESS_APPROVE ( "+ 
				"SerialNo, " +  
				"RelativeSerialNo, " + 
				"BusinessSum, " + 
				"InputOrgID, " + 
				"InputUserID, " + 
				"InputDate, " + 
				"UpdateDate, " + 
				"ApproveType, " + 
				"BusinessType, " +
				"ApproveOpinion, " + 
				"TempSaveFlag, "+
				"OccurDate, " +
				"CustomerID, " +
				"CustomerName, " +
				"BusinesssubType, " +
				"OccurType, " +
				"FundSource, " +
				"OperateType, " +
				"CurrenyList, " +
				"CurrencyMode, " +
				"BusinessTypeList, " +
				"CalculateMode, " +
				"UseOrgList, " +
				"CycleFlag, " +
				"FlowReduceFlag, " +
				"ContractFlag, " +
				"SubContractFlag, " +
				"SelfUseFlag, " +
				"CreditAggreement, " +
				"RelativeAgreement, " +
				"LoanFlag, " +
				"TotalSum, " +
				"OurRole, " +
				"Reversibility, " +
				"BillNum, " +
				"HouseType, " +
				"LCTermType, " +
				"RiskAttribute, " +
				"SureType, " +
				"SafeGuardType, " +
				"BusinessCurrency, " +
				"BusinessProp, " +
				"TermYear, " +
				"TermMonth, " +
				"TermDay, " +
				"LGTerm, " +
				"BaseRateType, " +
				"BaseRate, " +
				"RateFloatType, " +
				"RateFloat, " +
				"BUsinessRate, " +
				"ICType, " +
				"ICCyc, " +
				"PDGRatio, " +
				"PDGSum, " +
				"PDGPayMethod, " +
				"PDGPayPeriod, " +
				"PromisesFeeRatio, " +
				"PromisesFeeSum, " +
				"PromisesFeePeriod, " +
				"PromisesFeeBegin, " +
				"MFeeRatio, " +
				"MFeeSum, " +
				"MFeePayMethod, " +
				"AgentFee, " +
				"DealFee, " +
				"TotalCast, " +
				"DiscountInterest, " +
				"PurchaserInterest, " +
				"BargainorInterest, " +
				"DiscountSum, " +
				"BailRatio, " +
				"BailCurrency, " +
				"BailSum, " +
				"BailAccount, " +
				"FineRateType, " +
				"FineRate, " +
				"DrawingType, " +
				"FirstDrawingDate, " +
				"DrawingPeriod, " +
				"PayTimes, " +
				"PayCyc, " +
				"GracePeriod, " +
				"OverDraftPeriod, " +
				"OldLCNo, " +
				"OldLCTermType, " +
				"RemitMode, " +
				"OldLCSum, " +
				"OldLCLoadingDate, " +
				"OldLCValidDate, " +
				"Direction, " +
				"Purpose, " +
				"PlanalLocation, " +
				"ImmediacyPaySource, " +
				"PaySource, " +
				"CorpusPayMethod, " +
				"InterestPayMethod, " +
				"ThirdParty1, " +
				"ThirdPartyID1, " +
				"ThirdParty2, " +
				"ThirdPartyID2, " +
				"ThirdParty3, " +
				"ThirdPartyID3, " +
				"ThirdPartyRegion, " +
				"ThirdPartyAccounts, " +
				"CargoInfo, " +
				"ProjectName, " +
				"OperationInfo, " +
				"ContextInfo, " +
				"SecuritiesType, " +
				"SecuritiesRegion, " +
				"ConstructionArea, " +
				"UseArea, " +
				"Flag1, " +
				"Flag2, " +
				"Flag3, " +
				"TradeContractNo, " +
				"InvoiceNo, " +
				"TradeCurrency, " +
				"TradeSum, " +
				"PaymentDate, " +
				"OperationMode, " +
				"VouchClass, " +
				"VouchType, " +
				"VouchType1, " +
				"VouchType2, " +
				"VouchFlag, " +
				"Warrantor, " +
				"WarrantorID, " +
				"OtherCondition, " +
				"GuarantyValue, " +
				"GuarantyRate, " +
				"BaseEvaluateResult, " +
				"RiskRate, " +
				"LowRisk, " +
				"OtherAreaLoan, " +
				"LowRiskBailSum, " +
				"OriginalPutOutDate, " +
				"ExtendTimes, " +
				"LNGOTimes, " +
				"GOLNTimes, " +
				"DRTimes, " +
				"BaseClassifyResult, " +
				"ApplyType, " +
				"BailRate, " +
				"FinishOrg, " +
				"OperateOrgID, " +
				"OperateUserID, " +
				"OperateDate, " +
				"PigeonholeDate, " +
				"Flag4, " +
				"PayCurrency, " +
				"PayDate, "+
				"ClassifyResult, "+
				"ClassifyDate, "+
				"ClassifyFrequency, "+
				"AdjustRateType, "+ 
				"AdjustRateTerm, "+ 
				"FixCyc, "+ 
				"RateAdjustCyc, "+ 
				"FZANBalance, "+ 
				"ThirdPartyAdd2, "+ 
				"ThirdPartyZIP2, "+ 
				"ThirdPartyAdd1, "+ 
				"ThirdPartyZIP1, "+ 
				"ThirdPartyAdd3, "+ 
				"ThirdPartyZIP3, "+ 
				"TermDate1, "+ 
				"TermDate2, "+ 
				"TermDate3, "+ 
				"AcceptIntType, "+ 
				"Ratio, "+ 
				"Describe2, "+
				"Describe1, "+
				"Flag5, "+
				"CreditCycle "+
				") VALUES("+ 
				"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
				"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
				"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
				"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
				"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
				"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
				"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?"+
				")";
		try {
		//批复表prepareStatement赋值
		psInsertBUSINESS_APPROVE = Sqlca.getConnection().prepareStatement(sqlInsertBUSINESS_APPROVE);
		} catch (SQLException e) {
			if (psInsertBUSINESS_APPROVE != null)
			psInsertBUSINESS_APPROVE.close();
			e.printStackTrace();
		}
		if(rs2.next()){
		psInsertBUSINESS_APPROVE.setString(1, rs2.getString(1));
		psInsertBUSINESS_APPROVE.setString(2, rs2.getString(2));
		psInsertBUSINESS_APPROVE.setDouble(3, rs2.getDouble(3));
		psInsertBUSINESS_APPROVE.setString(4, rs2.getString(4));
		psInsertBUSINESS_APPROVE.setString(5, rs2.getString(5));
		psInsertBUSINESS_APPROVE.setString(6, rs2.getString(6));
		psInsertBUSINESS_APPROVE.setString(7, rs2.getString(7));
		psInsertBUSINESS_APPROVE.setString(8, rs2.getString(8));
		psInsertBUSINESS_APPROVE.setString(9, rs2.getString(9));
		psInsertBUSINESS_APPROVE.setString(10, rs2.getString(10));
		psInsertBUSINESS_APPROVE.setString(11, rs2.getString(11));
		psInsertBUSINESS_APPROVE.setString(12, rs2.getString(12));
		psInsertBUSINESS_APPROVE.setString(13, rs2.getString(13));
		psInsertBUSINESS_APPROVE.setString(14, rs2.getString(14));
		psInsertBUSINESS_APPROVE.setString(15, rs2.getString(15));
		psInsertBUSINESS_APPROVE.setString(16, rs2.getString(16));
		psInsertBUSINESS_APPROVE.setString(17, rs2.getString(17));
		psInsertBUSINESS_APPROVE.setString(18, rs2.getString(18));
		psInsertBUSINESS_APPROVE.setString(19, rs2.getString(19));
		psInsertBUSINESS_APPROVE.setString(20, rs2.getString(20));
		psInsertBUSINESS_APPROVE.setString(21, rs2.getString(21));
		psInsertBUSINESS_APPROVE.setString(22, rs2.getString(22));
		psInsertBUSINESS_APPROVE.setString(23, rs2.getString(23));
		psInsertBUSINESS_APPROVE.setString(24, rs2.getString(24));
		psInsertBUSINESS_APPROVE.setString(25, rs2.getString(25));
		psInsertBUSINESS_APPROVE.setString(26, rs2.getString(26));
		psInsertBUSINESS_APPROVE.setString(27, rs2.getString(27));
		psInsertBUSINESS_APPROVE.setString(28, rs2.getString(28));
		psInsertBUSINESS_APPROVE.setString(29, rs2.getString(29));
		psInsertBUSINESS_APPROVE.setString(30, rs2.getString(30));
		psInsertBUSINESS_APPROVE.setString(31, rs2.getString(31));
		psInsertBUSINESS_APPROVE.setDouble(32, rs2.getDouble(32));
		psInsertBUSINESS_APPROVE.setString(33, rs2.getString(33));
		psInsertBUSINESS_APPROVE.setString(34, rs2.getString(34));
		psInsertBUSINESS_APPROVE.setDouble(35, rs2.getDouble(35));
		psInsertBUSINESS_APPROVE.setString(36, rs2.getString(36));
		psInsertBUSINESS_APPROVE.setString(37, rs2.getString(37));
		psInsertBUSINESS_APPROVE.setString(38, rs2.getString(38));
		psInsertBUSINESS_APPROVE.setString(39, rs2.getString(39));
		psInsertBUSINESS_APPROVE.setString(40, rs2.getString(40));
		psInsertBUSINESS_APPROVE.setString(41, rs2.getString(41));
		psInsertBUSINESS_APPROVE.setDouble(42, rs2.getDouble(42));
		psInsertBUSINESS_APPROVE.setInt(43, rs2.getInt(43));
		psInsertBUSINESS_APPROVE.setInt(44, rs2.getInt(44));
		psInsertBUSINESS_APPROVE.setInt(45, rs2.getInt(45));
		psInsertBUSINESS_APPROVE.setInt(46, rs2.getInt(46));
		psInsertBUSINESS_APPROVE.setString(47, rs2.getString(47));
		psInsertBUSINESS_APPROVE.setDouble(48, rs2.getDouble(48));
		psInsertBUSINESS_APPROVE.setString(49, rs2.getString(49));
		psInsertBUSINESS_APPROVE.setDouble(50, rs2.getDouble(50));
		psInsertBUSINESS_APPROVE.setDouble(51, rs2.getDouble(51));
		psInsertBUSINESS_APPROVE.setString(52, rs2.getString(52));
		psInsertBUSINESS_APPROVE.setString(53, rs2.getString(53));
		psInsertBUSINESS_APPROVE.setDouble(54, rs2.getDouble(54));
		psInsertBUSINESS_APPROVE.setDouble(55, rs2.getDouble(55));
		psInsertBUSINESS_APPROVE.setString(56, rs2.getString(56));
		psInsertBUSINESS_APPROVE.setString(57, rs2.getString(57));
		psInsertBUSINESS_APPROVE.setDouble(58, rs2.getDouble(58));
		psInsertBUSINESS_APPROVE.setDouble(59, rs2.getDouble(59));
		psInsertBUSINESS_APPROVE.setDouble(60, rs2.getDouble(60));
		psInsertBUSINESS_APPROVE.setString(61, rs2.getString(61));
		psInsertBUSINESS_APPROVE.setDouble(62, rs2.getDouble(62));
		psInsertBUSINESS_APPROVE.setDouble(63, rs2.getDouble(63));
		psInsertBUSINESS_APPROVE.setString(64, rs2.getString(64));
		psInsertBUSINESS_APPROVE.setDouble(65, rs2.getDouble(65));
		psInsertBUSINESS_APPROVE.setDouble(66, rs2.getDouble(66));
		psInsertBUSINESS_APPROVE.setDouble(67, rs2.getDouble(67));
		psInsertBUSINESS_APPROVE.setString(68, rs2.getString(68));
		psInsertBUSINESS_APPROVE.setString(69, rs2.getString(69));
		psInsertBUSINESS_APPROVE.setString(70, rs2.getString(70));
		psInsertBUSINESS_APPROVE.setDouble(71, rs2.getDouble(71));
		psInsertBUSINESS_APPROVE.setDouble(72, rs2.getDouble(72));
		psInsertBUSINESS_APPROVE.setString(73, rs2.getString(73));
		psInsertBUSINESS_APPROVE.setDouble(74, rs2.getDouble(74));
		psInsertBUSINESS_APPROVE.setString(75, rs2.getString(75));
		psInsertBUSINESS_APPROVE.setString(76, rs2.getString(76));
		psInsertBUSINESS_APPROVE.setDouble(77, rs2.getDouble(77));
		psInsertBUSINESS_APPROVE.setString(78, rs2.getString(78));
		psInsertBUSINESS_APPROVE.setString(79, rs2.getString(79));
		psInsertBUSINESS_APPROVE.setDouble(80, rs2.getDouble(80));
		psInsertBUSINESS_APPROVE.setDouble(81, rs2.getDouble(81));
		psInsertBUSINESS_APPROVE.setString(82, rs2.getString(82));
		psInsertBUSINESS_APPROVE.setDouble(83, rs2.getDouble(83));
		psInsertBUSINESS_APPROVE.setDouble(84, rs2.getDouble(84));
		psInsertBUSINESS_APPROVE.setString(85, rs2.getString(85));
		psInsertBUSINESS_APPROVE.setString(86, rs2.getString(86));
		psInsertBUSINESS_APPROVE.setString(87, rs2.getString(87));
		psInsertBUSINESS_APPROVE.setDouble(88, rs2.getDouble(88));
		psInsertBUSINESS_APPROVE.setString(89, rs2.getString(89));
		psInsertBUSINESS_APPROVE.setString(90, rs2.getString(90));
		psInsertBUSINESS_APPROVE.setString(91, rs2.getString(91));
		psInsertBUSINESS_APPROVE.setString(92, rs2.getString(92));
		psInsertBUSINESS_APPROVE.setString(93, rs2.getString(93));
		psInsertBUSINESS_APPROVE.setString(94, rs2.getString(94));
		psInsertBUSINESS_APPROVE.setString(95, rs2.getString(95));
		psInsertBUSINESS_APPROVE.setString(96, rs2.getString(96));
		psInsertBUSINESS_APPROVE.setString(97, rs2.getString(97));
		psInsertBUSINESS_APPROVE.setString(98, rs2.getString(98));
		psInsertBUSINESS_APPROVE.setString(99, rs2.getString(99));
		psInsertBUSINESS_APPROVE.setString(100, rs2.getString(100));
		psInsertBUSINESS_APPROVE.setString(101, rs2.getString(101));
		psInsertBUSINESS_APPROVE.setString(102, rs2.getString(102));
		psInsertBUSINESS_APPROVE.setString(103, rs2.getString(103));
		psInsertBUSINESS_APPROVE.setString(104, rs2.getString(104));
		psInsertBUSINESS_APPROVE.setString(105, rs2.getString(105));
		psInsertBUSINESS_APPROVE.setString(106, rs2.getString(106));
		psInsertBUSINESS_APPROVE.setString(107, rs2.getString(107));
		psInsertBUSINESS_APPROVE.setString(108, rs2.getString(108));
		psInsertBUSINESS_APPROVE.setString(109, rs2.getString(109));
		psInsertBUSINESS_APPROVE.setString(110, rs2.getString(110));
		psInsertBUSINESS_APPROVE.setString(111, rs2.getString(111));
		psInsertBUSINESS_APPROVE.setDouble(112, rs2.getDouble(112));
		psInsertBUSINESS_APPROVE.setDouble(113, rs2.getDouble(113));
		psInsertBUSINESS_APPROVE.setString(114, rs2.getString(114));
		psInsertBUSINESS_APPROVE.setString(115, rs2.getString(115));
		psInsertBUSINESS_APPROVE.setString(116, rs2.getString(116));
		psInsertBUSINESS_APPROVE.setString(117, rs2.getString(117));
		psInsertBUSINESS_APPROVE.setString(118, rs2.getString(118));
		psInsertBUSINESS_APPROVE.setString(119, rs2.getString(119));
		psInsertBUSINESS_APPROVE.setDouble(120, rs2.getDouble(120));
		psInsertBUSINESS_APPROVE.setString(121, rs2.getString(121));
		psInsertBUSINESS_APPROVE.setString(122, rs2.getString(122));
		psInsertBUSINESS_APPROVE.setString(123, rs2.getString(123));
		psInsertBUSINESS_APPROVE.setString(124, rs2.getString(124));
		psInsertBUSINESS_APPROVE.setString(125, rs2.getString(125));
		psInsertBUSINESS_APPROVE.setString(126, rs2.getString(126));
		psInsertBUSINESS_APPROVE.setString(127, rs2.getString(127));
		psInsertBUSINESS_APPROVE.setString(128, rs2.getString(128));
		psInsertBUSINESS_APPROVE.setString(129, rs2.getString(129));
		psInsertBUSINESS_APPROVE.setString(130, rs2.getString(130));
		psInsertBUSINESS_APPROVE.setDouble(131, rs2.getDouble(131));
		psInsertBUSINESS_APPROVE.setDouble(132, rs2.getDouble(132));
		psInsertBUSINESS_APPROVE.setString(133, rs2.getString(133));
		psInsertBUSINESS_APPROVE.setDouble(134, rs2.getDouble(134));
		psInsertBUSINESS_APPROVE.setString(135, rs2.getString(135));
		psInsertBUSINESS_APPROVE.setString(136, rs2.getString(136));
		psInsertBUSINESS_APPROVE.setDouble(137, rs2.getDouble(137));
		psInsertBUSINESS_APPROVE.setString(138, rs2.getString(138));
		psInsertBUSINESS_APPROVE.setString(139, rs2.getString(139));
		psInsertBUSINESS_APPROVE.setDouble(140, rs2.getDouble(140));
		psInsertBUSINESS_APPROVE.setDouble(141, rs2.getDouble(141));
		psInsertBUSINESS_APPROVE.setDouble(142, rs2.getDouble(142));
		psInsertBUSINESS_APPROVE.setDouble(143, rs2.getDouble(143));
		psInsertBUSINESS_APPROVE.setString(144, rs2.getString(144));
		psInsertBUSINESS_APPROVE.setDouble(145, rs2.getDouble(145));
		psInsertBUSINESS_APPROVE.setString(146, rs2.getString(146));
		psInsertBUSINESS_APPROVE.setString(147, rs2.getString(147));
		psInsertBUSINESS_APPROVE.setString(148, rs2.getString(148));
		psInsertBUSINESS_APPROVE.setString(149, rs2.getString(149));
		psInsertBUSINESS_APPROVE.setString(150, rs2.getString(150));
		psInsertBUSINESS_APPROVE.setString(151, rs2.getString(151));
		psInsertBUSINESS_APPROVE.setString(152, rs2.getString(152));
		psInsertBUSINESS_APPROVE.setString(153, rs2.getString(153));
		psInsertBUSINESS_APPROVE.setString(154, rs2.getString(154));
		psInsertBUSINESS_APPROVE.setString(155, rs2.getString(155));
		psInsertBUSINESS_APPROVE.setString(156, rs2.getString(156));
		psInsertBUSINESS_APPROVE.setString(157, rs2.getString(157));
		psInsertBUSINESS_APPROVE.setString(158, rs2.getString(158));
		psInsertBUSINESS_APPROVE.setString(159, rs2.getString(159));
		psInsertBUSINESS_APPROVE.setString(160, rs2.getString(160));
		psInsertBUSINESS_APPROVE.setDouble(161, rs2.getDouble(161));
		psInsertBUSINESS_APPROVE.setString(162, rs2.getString(162));
		psInsertBUSINESS_APPROVE.setString(163, rs2.getString(163));
		psInsertBUSINESS_APPROVE.setString(164, rs2.getString(164));
		psInsertBUSINESS_APPROVE.setString(165, rs2.getString(165));
		psInsertBUSINESS_APPROVE.setString(166, rs2.getString(166));
		psInsertBUSINESS_APPROVE.setString(167, rs2.getString(167));
		psInsertBUSINESS_APPROVE.setString(168, rs2.getString(168));
		psInsertBUSINESS_APPROVE.setString(169, rs2.getString(169));
		psInsertBUSINESS_APPROVE.setString(170, rs2.getString(170));
		psInsertBUSINESS_APPROVE.setString(171, rs2.getString(171));
		psInsertBUSINESS_APPROVE.setDouble(172, rs2.getDouble(172));
		psInsertBUSINESS_APPROVE.setString(173, rs2.getString(173));
		psInsertBUSINESS_APPROVE.setString(174, rs2.getString(174));
		psInsertBUSINESS_APPROVE.setString(175, rs2.getString(175));
		psInsertBUSINESS_APPROVE.setString(176, rs2.getString(176));
		}
			
		//执行插入
		psInsertBUSINESS_APPROVE.executeUpdate();
		rs2.getStatement().close();
		if(psInsertBUSINESS_APPROVE != null){
			try{
			psInsertBUSINESS_APPROVE.close();
			}catch(SQLException e){
				e.printStackTrace();
			}	
		}
		psInsertBUSINESS_APPROVE = null;
	
		//在初始化最终审批意见的同时，更改申请表中关于是否通过审批的标签
		sSql = "update BUSINESS_APPLY set Flag5 = '020' where SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		//------------------------------第一步：拷贝批复基本信息到合同中--------------------------------------
		//获取批复信息
		sSql = "select "+ 
				"'"+sSerialNo+"', " +  
				"SerialNo, " +
				"BusinessSum, " + 
				"'"+CurUser.getOrgID()+"', " + 
				"'"+CurUser.getUserID()+"', " + 
				"'"+StringFunction.getToday()+"', " + 
				"'"+StringFunction.getToday()+"', " + 					
				"'"+CurUser.getOrgID()+"', " + 
				"'"+CurUser.getOrgID()+"', " + 
				"'"+CurUser.getUserID()+"', " + 
				"'1', " + 
				"'"+StringFunction.getToday()+"', " +
				"CustomerID, " +
				"CustomerName, " +
				"BusinessType, " +
				"BusinessSubType, " +
				"OccurType, " +
				"FundSource, " +
				"OperateType, " +
				"CurrenyList, " +
				"CurrencyMode, " +
				"BusinessTypeList, " +
				"CalculateMode, " +
				"UseOrgList, " +					
				"FlowReduceFlag, " +
				"ContractFlag, " +
				"SubContractFlag, " +
				"SelfUseFlag, " +
				"CreditAggreement, " +
				"RelativeAgreement, " +
				"LoanFlag, " +
				"TotalSum, " +
				"OurRole, " +
				"Reversibility, " +
				"BillNum, " +
				"HouseType, " +
				"LCTermType, " +
				"RiskAttribute, " +
				"SureType, " +
				"SafeGuardType, " +
				"BusinessCurrency, " +
				"BusinessProp, " +
				"TermYear, " +
				"TermMonth, " +
				"TermDay, " +
				"LGTerm, " +
				"BaseRateType, " +
				"BaseRate, " +
				"RateFloatType, " +
				"RateFloat, " +
				"BusinessRate, " +
				"ICType, " +
				"ICCyc, " +
				"PDGratio, " +
				"PDGSum, " +
				"PDGPayMethod, " +
				"PDGPayPeriod, " +
				"PromisesFeeRatio, " +
				"PromisesFeeSum, " +
				"PromisesFeePeriod, " +
				"PromisesFeeBegin, " +
				"MFeeRatio, " +
				"MFeeSum, " +
				"MFeePayMethod, " +
				"AgentFee, " +
				"DealFee, " +
				"TotalCast, " +
				"DiscountInterest, " +
				"PurchaserInterest, " +
				"BargainorInterest, " +
				"DiscountSum, " +
				"BailRatio, " +
				"BailCurrency, " +
				"BailSum, " +
				"BailAccount, " +
				"FineRateType, " +
				"FineRate, " +
				"DrawingType, " +
				"FirstDrawingDate, " +
				"DrawingPeriod, " +
				"PayTimes, " +
				"PayCyc, " +
				"GracePeriod, " +
				"OverDraftPeriod, " +
				"OldLCNo, " +
				"OldLCTermType, " +
				"RemitMode, " +
				"OldLCSum, " +
				"OldLCLoadingDate, " +
				"OldLCValidDate, " +
				"Direction, " +
				"Purpose, " +
				"PlanalLocation, " +
				"ImmediacyPaySource, " +
				"PaySource, " +
				"CorpusPayMethod, " +
				"InterestPayMethod, " +
				"ThirdParty1, " +
				"ThirdPartyID1, " +
				"ThirdParty2, " +
				"ThirdPartyID2, " +
				"ThirdParty3, " +
				"ThirdPartyID3, " +
				"ThirdPartyRegion, " +
				"ThirdPartyAccounts, " +
				"CargoInfo, " +
				"ProjectName, " +
				"OperationInfo, " +
				"ContextInfo, " +
				"SecuritiesType, " +
				"SecuritiesRegion, " +
				"ConstructionArea, " +
				"UseArea, " +
				"Flag1, " +
				"Flag2, " +
				"Flag3, " +
				"TradeContractNo, " +
				"InvoiceNo, " +
				"TradeCurrency, " +
				"TradeSum, " +
				"PaymentDate, " +
				"OperationMode, " +
				"VouchClass, " +
				"VouchType, " +
				"VouchType1, " +
				"VouchType2, " +
				"VouchFlag, " +
				"Warrantor, " +
				"WarrantorID, " +
				"OtherCondition, " +
				"GuarantyValue, " +
				"GuarantyRate, " +
				"BaseEvaluateResult, " +
				"RiskRate, " +
				"LowRisk, " +
				"OtherAreaLoan, " +
				"LowRiskBailSum, " +
				"OriginalPutOutDate, " +
				"ExtendTimes, " +
				"LNGOTimes, " +
				"GOLNTimes, " +
				"DRTimes, " +
				"BaseClassifyResult, " +
				"ApplyType, " +
				"BailRate, " +
				"FinishOrg, " +
				"OperateOrgID, " +
				"OperateUserID, " +
				"OperateDate, " +
				"PigeonholeDate, " +
				"Remark, " +
				"Flag4, " +
				"PayCurrency, " +
				"PayDate, "+
				"ClassifyResult, "+
				"ClassifyDate, "+
				"ClassifyFrequency, "+
				"AdjustRateType, "+ 
				"AdjustRateTerm, "+ 
				"FixCyc, "+ 
				"RateAdjustCyc, "+ 
				"FZANBalance, "+ 
				"ThirdPartyAdd2, "+ 
				"ThirdPartyZIP2, "+ 
				"ThirdPartyAdd1, "+ 
				"ThirdPartyZIP1, "+ 
				"TermDate1, "+ 
				"TermDate2, "+ 
				"TermDate3, "+ 
				"AcceptIntType, "+ 
				"Ratio, "+ 
				"Describe2, "+
				"Describe1, "+
				"ApproveDate, "+
				"'1', " +
				"'2', " +
				"CreditCycle "+
				" from BUSINESS_APPROVE " +
				" where SerialNo='"+sSerialNoApprove+"'";
		rs2 = Sqlca.getASResultSet(sSql);
		
		//将批复信息复制到合同信息中
		sqlInsertBUSINESS_CONTRACT =  "insert into BUSINESS_CONTRACT ( "+
					"SerialNo, " +  
					"RelativeSerialNo, " + 
					"BusinessSum, " + 
					"InputOrgID, " +
					"InputUserID, " + 
					"InputDate, " + 
					"UpdateDate, " + 					
					"PutOutOrgID, " + 
					"ManageOrgID, " + 
					"ManageUserID, " + 
					"TempSaveFlag, " +
					"OccurDate, " +
					"CustomerID, " +
					"CustomerName, " +
					"BusinessType, " +
					"BusinessSubType, " +
					"OccurType, " +
					"FundSource, " +
					"OperateType, " +
					"CurrenyList, " +
					"CurrencyMode, " +
					"BusinessTypeList, " +
					"CalculateMode, " +
					"UseOrgList, " +					
					"FlowReduceFlag, " +
					"ContractFlag, " +
					"SubContractFlag, " +
					"SelfUseFlag, " +
					"CreditAggreement, " +
					"RelativeAgreement, " +
					"LoanFlag, " +
					"TotalSum, " +
					"OurRole, " +
					"Reversibility, " +
					"BillNum, " +
					"HouseType, " +
					"LCTermType, " +
					"RiskAttribute, " +
					"SureType, " +
					"SafeGuardType, " +
					"BusinessCurrency, " +
					"BusinessProp, " +
					"TermYear, " +
					"TermMonth, " +
					"TermDay, " +
					"LGTerm, " +
					"BaseRateType, " +
					"BaseRate, " +
					"RateFloatType, " +
					"RateFloat, " +
					"BusinessRate, " +
					"ICType, " +
					"ICCyc, " +
					"PDGRatio, " +
					"PDGSum, " +
					"PDGPayMethod, " +
					"PDGPayPeriod, " +
					"PromisesFeeRatio, " +
					"PromisesFeeSum, " +
					"PromisesFeePeriod, " +
					"PromisesFeeBegin, " +
					"MFeeRatio, " +
					"MFeeSum, " +
					"MFeePayMethod, " +
					"AgentFee, " +
					"DealFee, " +
					"TotalCast, " +
					"DiscountInterest, " +
					"PurchaserInterest, " +
					"BargainorInterest, " +
					"DiscountSum, " +
					"BailRatio, " +
					"BailCurrency, " +
					"BailSum, " +
					"BailAccount, " +
					"FineRateType, " +
					"FineRate, " +
					"DrawingType, " +
					"FirstDrawingDate, " +
					"DrawingPeriod, " +
					"PayTimes, " +
					"PayCyc, " +
					"GracePeriod, " +
					"OverDraftPeriod, " +
					"OldLCNo, " +
					"OldLCTermType, " +
					"RemitMode, " +
					"OldLCSum, " +
					"OldLCLoadingDate, " +
					"OldLCValidDate, " +
					"Direction, " +
					"Purpose, " +
					"PlanalLocation, " +
					"ImmediacyPaySource, " +
					"PaySource, " +
					"CorpusPayMethod, " +
					"InterestPayMethod, " +
					"ThirdParty1, " +
					"ThirdPartyID1, " +
					"ThirdParty2, " +
					"ThirdPartyID2, " +
					"ThirdParty3, " +
					"ThirdPartyID3, " +
					"ThirdPartyRegion, " +
					"ThirdPartyAccounts, " +
					"CargoInfo, " +
					"ProjectName, " +
					"OperationInfo, " +
					"ContextInfo, " +
					"SecuritiesType, " +
					"SecuritiesRegion, " +
					"ConstructionArea, " +
					"UseArea, " +
					"Flag1, " +
					"Flag2, " +
					"Flag3, " +
					"TradeContractNo, " +
					"InvoiceNo, " +
					"TradeCurrency, " +
					"TradeSum, " +
					"PaymentDate, " +
					"OperationMode, " +
					"VouchClass, " +
					"VouchType, " +
					"VouchType1, " +
					"VouchType2, " +
					"VouchFlag, " +
					"Warrantor, " +
					"WarrantorID, " +
					"OtherCondition, " +
					"GuarantyValue, " +
					"GuarantyRate, " +
					"BaseEvaluateResult, " +
					"RiskRate, " +
					"LowRisk, " +
					"OtherAreaLoan, " +
					"LowRiskBailSum, " +
					"OriginalPutOutDate, " +
					"ExtendTimes, " +
					"LNGOTimes, " +
					"GOLNTimes, " +
					"DRTimes, " +
					"BaseClassifyResult, " +
					"ApplyType, " +
					"BailRate, " +
					"FinishOrg, " +
					"OperateOrgID, " +
					"OperateUserID, " +
					"OperateDate, " +
					"PigeonholeDate, " +
					"Remark, " +
					"Flag4, " +
					"PayCurrency, " +
					"PayDate, "+
					"ClassifyResult, "+
					"ClassifyDate, "+
					"ClassifyFrequency, "+
					"AdjustRateType, "+ 
					"AdjustRateTerm, "+ 
					"FixCyc, "+ 
					"RateAdjustCyc, "+ 
					"FZANBalance, "+ 
					"ThirdPartyAdd2, "+ 
					"ThirdPartyZIP2, "+ 
					"ThirdPartyAdd1, "+ 
					"ThirdPartyZIP1, "+ 
					"TermDate1, "+ 
					"TermDate2, "+ 
					"TermDate3, "+
					"AcceptIntType, "+ 
					"Ratio, "+ 
					"Describe2, "+
					"Describe1, "+
					"ApproveDate, " +
					"FreezeFlag, " +					
					"CycleFlag, " +
					"CreditCycle "+
					") VALUES("+ 
					"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
					"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
					"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
					"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
					"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
					"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
					"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
					"?,?)";
		
		try {
		//合同表prepareStatement赋值
		psInsertBUSINESS_CONTRACT = Sqlca.getConnection().prepareStatement(sqlInsertBUSINESS_CONTRACT);
		} catch (SQLException e) {
			if (psInsertBUSINESS_CONTRACT != null)
				psInsertBUSINESS_CONTRACT.close();
			e.printStackTrace();
		}
		if(rs2.next()){
			psInsertBUSINESS_CONTRACT.setString(1, rs2.getString(1));
			psInsertBUSINESS_CONTRACT.setString(2, rs2.getString(2));
			psInsertBUSINESS_CONTRACT.setDouble(3, rs2.getDouble(3));
			psInsertBUSINESS_CONTRACT.setString(4, rs2.getString(4));
			psInsertBUSINESS_CONTRACT.setString(5, rs2.getString(5));
			psInsertBUSINESS_CONTRACT.setString(6, rs2.getString(6));
			psInsertBUSINESS_CONTRACT.setString(7, rs2.getString(7));
			psInsertBUSINESS_CONTRACT.setString(8, rs2.getString(8));
			psInsertBUSINESS_CONTRACT.setString(9, rs2.getString(9));
			psInsertBUSINESS_CONTRACT.setString(10, rs2.getString(10));
			psInsertBUSINESS_CONTRACT.setString(11, rs2.getString(11));
			psInsertBUSINESS_CONTRACT.setString(12, rs2.getString(12));
			psInsertBUSINESS_CONTRACT.setString(13, rs2.getString(13));
			psInsertBUSINESS_CONTRACT.setString(14, rs2.getString(14));
			psInsertBUSINESS_CONTRACT.setString(15, rs2.getString(15));
			psInsertBUSINESS_CONTRACT.setString(16, rs2.getString(16));
			psInsertBUSINESS_CONTRACT.setString(17, rs2.getString(17));
			psInsertBUSINESS_CONTRACT.setString(18, rs2.getString(18));
			psInsertBUSINESS_CONTRACT.setString(19, rs2.getString(19));
			psInsertBUSINESS_CONTRACT.setString(20, rs2.getString(20));
			psInsertBUSINESS_CONTRACT.setString(21, rs2.getString(21));
			psInsertBUSINESS_CONTRACT.setString(22, rs2.getString(22));
			psInsertBUSINESS_CONTRACT.setString(23, rs2.getString(23));
			psInsertBUSINESS_CONTRACT.setString(24, rs2.getString(24));
			psInsertBUSINESS_CONTRACT.setString(25, rs2.getString(25));
			psInsertBUSINESS_CONTRACT.setString(26, rs2.getString(26));
			psInsertBUSINESS_CONTRACT.setString(27, rs2.getString(27));
			psInsertBUSINESS_CONTRACT.setString(28, rs2.getString(28));
			psInsertBUSINESS_CONTRACT.setString(29, rs2.getString(29));
			psInsertBUSINESS_CONTRACT.setString(30, rs2.getString(30));
			psInsertBUSINESS_CONTRACT.setString(31, rs2.getString(31));
			psInsertBUSINESS_CONTRACT.setDouble(32, rs2.getDouble(32));
			psInsertBUSINESS_CONTRACT.setString(33, rs2.getString(33));
			psInsertBUSINESS_CONTRACT.setString(34, rs2.getString(34));
			psInsertBUSINESS_CONTRACT.setDouble(35, rs2.getDouble(35));
			psInsertBUSINESS_CONTRACT.setString(36, rs2.getString(36));
			psInsertBUSINESS_CONTRACT.setString(37, rs2.getString(37));
			psInsertBUSINESS_CONTRACT.setString(38, rs2.getString(38));
			psInsertBUSINESS_CONTRACT.setString(39, rs2.getString(39));
			psInsertBUSINESS_CONTRACT.setString(40, rs2.getString(40));
			psInsertBUSINESS_CONTRACT.setString(41, rs2.getString(41));
			psInsertBUSINESS_CONTRACT.setString(42, rs2.getString(42));
			psInsertBUSINESS_CONTRACT.setInt(43, rs2.getInt(43));
			psInsertBUSINESS_CONTRACT.setInt(44, rs2.getInt(44));
			psInsertBUSINESS_CONTRACT.setInt(45, rs2.getInt(45));
			psInsertBUSINESS_CONTRACT.setInt(46, rs2.getInt(46));
			psInsertBUSINESS_CONTRACT.setString(47, rs2.getString(47));
			psInsertBUSINESS_CONTRACT.setDouble(48, rs2.getDouble(48));
			psInsertBUSINESS_CONTRACT.setString(49, rs2.getString(49));
			psInsertBUSINESS_CONTRACT.setDouble(50, rs2.getDouble(50));
			psInsertBUSINESS_CONTRACT.setDouble(51, rs2.getDouble(51));
			psInsertBUSINESS_CONTRACT.setString(52, rs2.getString(52));
			psInsertBUSINESS_CONTRACT.setString(53, rs2.getString(53));
			psInsertBUSINESS_CONTRACT.setDouble(54, rs2.getDouble(54));
			psInsertBUSINESS_CONTRACT.setDouble(55, rs2.getDouble(55));
			psInsertBUSINESS_CONTRACT.setString(56, rs2.getString(56));
			psInsertBUSINESS_CONTRACT.setString(57, rs2.getString(57));
			psInsertBUSINESS_CONTRACT.setDouble(58, rs2.getDouble(58));
			psInsertBUSINESS_CONTRACT.setDouble(59, rs2.getDouble(59));
			psInsertBUSINESS_CONTRACT.setDouble(60, rs2.getDouble(60));
			psInsertBUSINESS_CONTRACT.setString(61, rs2.getString(61));
			psInsertBUSINESS_CONTRACT.setDouble(62, rs2.getDouble(62));
			psInsertBUSINESS_CONTRACT.setDouble(63, rs2.getDouble(63));
			psInsertBUSINESS_CONTRACT.setString(64, rs2.getString(64));
			psInsertBUSINESS_CONTRACT.setDouble(65, rs2.getDouble(65));
			psInsertBUSINESS_CONTRACT.setDouble(66, rs2.getDouble(66));
			psInsertBUSINESS_CONTRACT.setDouble(67, rs2.getDouble(67));
			psInsertBUSINESS_CONTRACT.setDouble(68, rs2.getDouble(68));
			psInsertBUSINESS_CONTRACT.setDouble(69, rs2.getDouble(69));
			psInsertBUSINESS_CONTRACT.setDouble(70, rs2.getDouble(70));
			psInsertBUSINESS_CONTRACT.setDouble(71, rs2.getDouble(71));
			psInsertBUSINESS_CONTRACT.setDouble(72, rs2.getDouble(72));
			psInsertBUSINESS_CONTRACT.setString(73, rs2.getString(73));
			psInsertBUSINESS_CONTRACT.setDouble(74, rs2.getDouble(74));
			psInsertBUSINESS_CONTRACT.setString(75, rs2.getString(75));
			psInsertBUSINESS_CONTRACT.setString(76, rs2.getString(76));
			psInsertBUSINESS_CONTRACT.setDouble(77, rs2.getDouble(77));
			psInsertBUSINESS_CONTRACT.setString(78, rs2.getString(78));
			psInsertBUSINESS_CONTRACT.setString(79, rs2.getString(79));
			psInsertBUSINESS_CONTRACT.setDouble(80, rs2.getDouble(80));
			psInsertBUSINESS_CONTRACT.setDouble(81, rs2.getDouble(81));
			psInsertBUSINESS_CONTRACT.setString(82, rs2.getString(82));
			psInsertBUSINESS_CONTRACT.setDouble(83, rs2.getDouble(83));
			psInsertBUSINESS_CONTRACT.setDouble(84, rs2.getDouble(84));
			psInsertBUSINESS_CONTRACT.setString(85, rs2.getString(85));
			psInsertBUSINESS_CONTRACT.setString(86, rs2.getString(86));
			psInsertBUSINESS_CONTRACT.setString(87, rs2.getString(87));
			psInsertBUSINESS_CONTRACT.setDouble(88, rs2.getDouble(88));
			psInsertBUSINESS_CONTRACT.setString(89, rs2.getString(89));
			psInsertBUSINESS_CONTRACT.setString(90, rs2.getString(90));
			psInsertBUSINESS_CONTRACT.setString(91, rs2.getString(91));
			psInsertBUSINESS_CONTRACT.setString(92, rs2.getString(92));
			psInsertBUSINESS_CONTRACT.setString(93, rs2.getString(93));
			psInsertBUSINESS_CONTRACT.setString(94, rs2.getString(94));
			psInsertBUSINESS_CONTRACT.setString(95, rs2.getString(95));
			psInsertBUSINESS_CONTRACT.setString(96, rs2.getString(96));
			psInsertBUSINESS_CONTRACT.setString(97, rs2.getString(97));
			psInsertBUSINESS_CONTRACT.setString(98, rs2.getString(98));
			psInsertBUSINESS_CONTRACT.setString(99, rs2.getString(99));
			psInsertBUSINESS_CONTRACT.setString(100, rs2.getString(100));
			psInsertBUSINESS_CONTRACT.setString(101, rs2.getString(101));
			psInsertBUSINESS_CONTRACT.setString(102, rs2.getString(102));
			psInsertBUSINESS_CONTRACT.setString(103, rs2.getString(103));
			psInsertBUSINESS_CONTRACT.setString(104, rs2.getString(104));
			psInsertBUSINESS_CONTRACT.setString(105, rs2.getString(105));
			psInsertBUSINESS_CONTRACT.setString(106, rs2.getString(106));
			psInsertBUSINESS_CONTRACT.setString(107, rs2.getString(107));
			psInsertBUSINESS_CONTRACT.setString(108, rs2.getString(108));
			psInsertBUSINESS_CONTRACT.setString(109, rs2.getString(109));
			psInsertBUSINESS_CONTRACT.setString(110, rs2.getString(110));
			psInsertBUSINESS_CONTRACT.setString(111, rs2.getString(111));
			psInsertBUSINESS_CONTRACT.setDouble(112, rs2.getDouble(112));
			psInsertBUSINESS_CONTRACT.setDouble(113, rs2.getDouble(113));
			psInsertBUSINESS_CONTRACT.setString(114, rs2.getString(114));
			psInsertBUSINESS_CONTRACT.setString(115, rs2.getString(115));
			psInsertBUSINESS_CONTRACT.setString(116, rs2.getString(116));
			psInsertBUSINESS_CONTRACT.setString(117, rs2.getString(117));
			psInsertBUSINESS_CONTRACT.setString(118, rs2.getString(118));
			psInsertBUSINESS_CONTRACT.setString(119, rs2.getString(119));
			psInsertBUSINESS_CONTRACT.setString(120, rs2.getString(120));
			psInsertBUSINESS_CONTRACT.setString(121, rs2.getString(121));
			psInsertBUSINESS_CONTRACT.setString(122, rs2.getString(122));
			psInsertBUSINESS_CONTRACT.setString(123, rs2.getString(123));
			psInsertBUSINESS_CONTRACT.setString(124, rs2.getString(124));
			psInsertBUSINESS_CONTRACT.setString(125, rs2.getString(125));
			psInsertBUSINESS_CONTRACT.setString(126, rs2.getString(126));
			psInsertBUSINESS_CONTRACT.setString(127, rs2.getString(127));
			psInsertBUSINESS_CONTRACT.setString(128, rs2.getString(128));
			psInsertBUSINESS_CONTRACT.setString(129, rs2.getString(129));
			psInsertBUSINESS_CONTRACT.setString(130, rs2.getString(130));
			psInsertBUSINESS_CONTRACT.setDouble(131, rs2.getDouble(131));
			psInsertBUSINESS_CONTRACT.setDouble(132, rs2.getDouble(132));
			psInsertBUSINESS_CONTRACT.setString(133, rs2.getString(133));
			psInsertBUSINESS_CONTRACT.setDouble(134, rs2.getDouble(134));
			psInsertBUSINESS_CONTRACT.setString(135, rs2.getString(135));
			psInsertBUSINESS_CONTRACT.setString(136, rs2.getString(136));
			psInsertBUSINESS_CONTRACT.setDouble(137, rs2.getDouble(137));
			psInsertBUSINESS_CONTRACT.setString(138, rs2.getString(138));
			psInsertBUSINESS_CONTRACT.setDouble(139, rs2.getDouble(139));
			psInsertBUSINESS_CONTRACT.setDouble(140, rs2.getDouble(140));
			psInsertBUSINESS_CONTRACT.setDouble(141, rs2.getDouble(141));
			psInsertBUSINESS_CONTRACT.setDouble(142, rs2.getDouble(142));
			psInsertBUSINESS_CONTRACT.setString(143, rs2.getString(143));
			psInsertBUSINESS_CONTRACT.setString(144, rs2.getString(144));
			psInsertBUSINESS_CONTRACT.setDouble(145, rs2.getDouble(145));
			psInsertBUSINESS_CONTRACT.setString(146, rs2.getString(146));
			psInsertBUSINESS_CONTRACT.setString(147, rs2.getString(147));
			psInsertBUSINESS_CONTRACT.setString(148, rs2.getString(148));
			psInsertBUSINESS_CONTRACT.setString(149, rs2.getString(149));
			psInsertBUSINESS_CONTRACT.setString(150, rs2.getString(150));
			psInsertBUSINESS_CONTRACT.setString(151, rs2.getString(151));
			psInsertBUSINESS_CONTRACT.setString(152, rs2.getString(152));
			psInsertBUSINESS_CONTRACT.setString(153, rs2.getString(153));
			psInsertBUSINESS_CONTRACT.setString(154, rs2.getString(154));
			psInsertBUSINESS_CONTRACT.setString(155, rs2.getString(155));
			psInsertBUSINESS_CONTRACT.setString(156, rs2.getString(156));
			psInsertBUSINESS_CONTRACT.setString(157, rs2.getString(157));
			psInsertBUSINESS_CONTRACT.setString(158, rs2.getString(158));
			psInsertBUSINESS_CONTRACT.setString(159, rs2.getString(159));
			psInsertBUSINESS_CONTRACT.setString(160, rs2.getString(160));
			psInsertBUSINESS_CONTRACT.setString(161, rs2.getString(161));
			psInsertBUSINESS_CONTRACT.setString(162, rs2.getString(162));
			psInsertBUSINESS_CONTRACT.setString(163, rs2.getString(163));
			psInsertBUSINESS_CONTRACT.setString(164, rs2.getString(164));
			psInsertBUSINESS_CONTRACT.setString(165, rs2.getString(165));
			psInsertBUSINESS_CONTRACT.setString(166, rs2.getString(166));
			psInsertBUSINESS_CONTRACT.setString(167, rs2.getString(167));
			psInsertBUSINESS_CONTRACT.setString(168, rs2.getString(168));
			psInsertBUSINESS_CONTRACT.setString(169, rs2.getString(169));
			psInsertBUSINESS_CONTRACT.setString(170, rs2.getString(170));
			psInsertBUSINESS_CONTRACT.setDouble(171, rs2.getDouble(171));
			psInsertBUSINESS_CONTRACT.setString(172, rs2.getString(172));
			psInsertBUSINESS_CONTRACT.setString(173, rs2.getString(173));
			psInsertBUSINESS_CONTRACT.setString(174, rs2.getString(174));
			psInsertBUSINESS_CONTRACT.setString(175, rs2.getString(175));
			psInsertBUSINESS_CONTRACT.setString(176, rs2.getString(176));
			psInsertBUSINESS_CONTRACT.setString(177, rs2.getString(177));
			}
		
		//执行插入
		psInsertBUSINESS_CONTRACT.executeUpdate();
		rs2.getStatement().close();
		if(psInsertBUSINESS_CONTRACT != null){
			try{
				psInsertBUSINESS_CONTRACT.close();
			}catch(SQLException e){
				e.printStackTrace();
			}	
		}
		psInsertBUSINESS_CONTRACT = null;
		
		//更改审批表中关于是否签订合同的标签
		sSql = "update BUSINESS_APPROVE set Flag5 = '020' where SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		
		
		//------------------------------第二步：拷贝批复信息所对应的担保信息到合同中--------------------------------------
		/*请注意：在批复的担保信息中存在新增的担保信息和引入最高额的担保信息，因此在进行担保信息拷贝时，
		         将担保信息全拷贝*/
		//查找出批复中引入的最高额担保合同信息，并与批复建立关联
		//(合同状态：ContractStatus－010：未签合同；020－已签合同；030－已失效)	
		sSql =  " select GC.SerialNo from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPROVE_RELATIVE AR "+
		" where AR.SerialNo =:SerialNo and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
		" and ContractStatus = '020' ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		while(rs.next())
		{
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
			" values(:SerialNo,'GuarantyContract',:ObjectNo) ";
			so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("ObjectNo", rs.getString("SerialNo"));
			Sqlca.executeSQL(so);
			//根据批复阶段担保信息的流水号查找到相应的担保物信息
			sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
			" where ObjectNo =:ObjectNo "+
			" and ContractNo =:ContractNo ";
			so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", rs.getString("SerialNo"));
			rs1 = Sqlca.getASResultSet(so);			
			while(rs1.next())
			{
				sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
				" values(:ObjectType,:ObjectNo,:ContractNo, "+
				" :GuarantyID,'Copy',:Status,:Type) ";
				so = new SqlObject(sSql);
				so.setParameter("ObjectType", sContractObjectType).setParameter("ObjectNo", sSerialNo).setParameter("ContractNo", rs.getString("SerialNo"))
				.setParameter("GuarantyID", rs1.getString("GuarantyID")).setParameter("Status", rs1.getString("Status")).setParameter("Type", rs1.getString("Type"));
				Sqlca.executeSQL(so);
			}
			rs1.getStatement().close();
		}
		rs.getStatement().close();
		
		//查找出批复关联的未签合同的担保信息，即批复阶段新增的担保信息，需要全部拷贝。	
		sSql =  " select GC.* from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPROVE_RELATIVE AR "+
		" where AR.SerialNo =:SerialNo and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
		" and GC.ContractStatus = '010' ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		//获得担保信息总列数
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得担保信息编号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("GUARANTY_CONTRACT","SerialNo",Sqlca);
			//插入担保信息
			sSql = " insert into GUARANTY_CONTRACT values(:RelativeSerialNo1";
			for(int i=2;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			//Sqlca.executeSQL(sSql);
			so = new SqlObject(sSql).setParameter("RelativeSerialNo1", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
			
			//更改担保合同状态
			//sSql =	" update GUARANTY_CONTRACT set ContractStatus='020' where SerialNo = '"+sRelativeSerialNo1+"' ";
			//Sqlca.executeSQL(sSql);
			
			//将新拷贝的担保信息与合同建立关联
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
			" values(:SerialNo,'GuarantyContract',:ObjectNo)";
			so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("ObjectNo", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
			//根据批复阶段担保信息的流水号查找到相应的担保物信息
			sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
			" where ObjectNo =:ObjectNo "+
			" and ContractNo =:ContractNo ";
			so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", rs.getString("SerialNo"));
			rs1 = Sqlca.getASResultSet(so);					
			while(rs1.next())
			{
				sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
				" values(:ObjectType,:ObjectNo,:ContractNo, "+
				" :GuarantyID,'Copy',:Status,:Type) ";
				so = new SqlObject(sSql);
				so.setParameter("ObjectType", sContractObjectType).setParameter("ObjectNo", sSerialNo).setParameter("ContractNo", sRelativeSerialNo1)
				.setParameter("GuarantyID", rs1.getString("GuarantyID")).setParameter("Status", rs1.getString("Status")).setParameter("Type", rs1.getString("Type"));
				Sqlca.executeSQL(so);
			}
			rs1.getStatement().close();
		}
		rs.getStatement().close();
		
		//------------------------------第三步：拷贝批复信息所对应的共同申请人信息到合同中--------------------------------------		
		//查询出批复信息对应的共同申请人信息
		sSql =  " select * from BUSINESS_APPLICANT where ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得共同申请信息流水号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("BUSINESS_APPLICANT","SerialNo",Sqlca);
			//插入共同申请人信息
			sSql = " insert into BUSINESS_APPLICANT values(:ContractObjectType,:SerialNo,:RelativeSerialNo1";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			//Sqlca.executeSQL(sSql);
			so = new SqlObject(sSql);
			so.setParameter("ContractObjectType", sContractObjectType).setParameter("SerialNo", sSerialNo).setParameter("RelativeSerialNo1", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();

		//------------------------------第四步：拷贝批复信息所对应的文档信息到合同中--------------------------------------				
		//只将批复信息对应的文档关联信息拷贝到合同中
		sSql =  " insert into DOC_RELATIVE(DocNo,ObjectType,ObjectNo) "+
				" select DocNo,'"+sContractObjectType+"','"+sSerialNo+"' from DOC_RELATIVE "+
				" where ObjectNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);
		
		//------------------------------第五步：拷贝批复信息所对应的项目信息到合同中--------------------------------------			
		//只将批复信息对应的项目关联信息拷贝到合同中
		sSql =  " insert into PROJECT_RELATIVE(ProjectNo,ObjectType,ObjectNo) "+
				" select ProjectNo,'"+sContractObjectType+"','"+sSerialNo+"' from PROJECT_RELATIVE "+
				" where ObjectNo = '"+sObjectNo+"' ";
		Sqlca.executeSQL(sSql);

		//------------------------------第六步：拷贝所对应的票据信息到合同中--------------------------------------					
		//查询出批复信息对应的票据信息
		sSql =  " select * from BILL_INFO where ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得票据信息流水号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("BILL_INFO","SerialNo",Sqlca);
			//插入票据信息
			sSql = " insert into BILL_INFO values(:ContractObjectType,:SerialNo,:RelativeSerialNo1";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			so = new SqlObject(sSql);
			so.setParameter("ContractObjectType", sContractObjectType).setParameter("SerialNo", sSerialNo).setParameter("RelativeSerialNo1", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();		
		
		//------------------------------第七步：拷贝所对应的信用证信息到合同中--------------------------------------					
		//查询出批复信息对应的信用证信息
		sSql =  " select * from LC_INFO where ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得信用证信息流水号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("LC_INFO","SerialNo",Sqlca);
			//插入信用证信息
			sSql = " insert into LC_INFO values(:ContractObjectType,:SerialNo,:RelativeSerialNo1";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			so = new SqlObject(sSql);
			so.setParameter("ContractObjectType", sContractObjectType).setParameter("SerialNo", sSerialNo).setParameter("RelativeSerialNo1", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();
		
		//------------------------------第八步：拷贝所对应的贸易合同信息到合同中--------------------------------------					
		//查询出批复信息对应的贸易合同信息
		sSql =  " select * from CONTRACT_INFO where ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得贸易合同信息流水号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("CONTRACT_INFO","SerialNo",Sqlca);
			//插入贸易合同信息
			sSql = " insert into CONTRACT_INFO values(:ContractObjectType,:SerialNo,:RelativeSerialNo1";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			so = new SqlObject(sSql);
			so.setParameter("ContractObjectType", sContractObjectType).setParameter("SerialNo", sSerialNo).setParameter("RelativeSerialNo1", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();		
		
		//------------------------------第九步：拷贝所对应的增值税发票信息到合同中--------------------------------------					
		//查询出批复信息对应的增值税发票信息
		sSql =  " select * from INVOICE_INFO where ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo",sObjectNo);
		rs = Sqlca.getASResultSet(so);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得增值税发票信息流水号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("INVOICE_INFO","SerialNo",Sqlca);
			//插入增值税发票信息
			sSql = " insert into INVOICE_INFO values(:ContractObjectType,:SerialNo,:RelativeSerialNo1";
			for(int i=4;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			so = new SqlObject(sSql);
			so.setParameter("ContractObjectType", sContractObjectType).setParameter("SerialNo", sSerialNo).setParameter("RelativeSerialNo1", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();						
			
		
		//------------------------------第十二步：拷贝中介信息到合同中--------------------------------------			
		//根据批复信息查询出相对应的中介信息
		sSql =  " select * from AGENCY_INFO where SerialNo in (select ObjectNo from APPROVE_RELATIVE "+
		" where SerialNo =:SerialNo and ObjectType='AGENCY_INFO') ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		//获得担保信息总列数
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//获得中介信息编号
			sRelativeSerialNo1 = DBKeyHelp.getSerialNo("AGENCY_INFO","SerialNo",Sqlca);
			//插入中介信息
			sSql = " insert into AGENCY_INFO values(:RelativeSerialNo1";
			for(int i=2;i<= iColumnCount;i++)
			{
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}
			}
			sSql= sSql + ")";
			//Sqlca.executeSQL(sSql);
			so = new SqlObject(sSql).setParameter("RelativeSerialNo1", sRelativeSerialNo1);
			
			//将新拷贝的中介信息与合同建立关联
			sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
			" values(:SerialNo,'AGENCY_INFO',:ObjectNo)";
			so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("ObjectNo", sRelativeSerialNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();		
		
		//------------------------------第十五步：拷贝批复信息所对应的汽车信息到合同中--------------------------------------					
		//查询出批复信息对应的汽车信息
		
		//------------------------------第十六步：拷贝消费信息到合同中--------------------------------------					
		//查询出批复信息对应的消费信息
		
		
					
		
		//------------------------------第二十步：拷贝批复信息所对应的直接关联信息到合同中--------------------------------------	
		//将与批复关联表直接关联的信息（除去担保信息）拷贝到合同中
		sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
				" select '"+sSerialNo+"',ObjectType,ObjectNo from APPLY_RELATIVE "+
				" where SerialNo = '"+sObjectNo+"' and ObjectType <> 'GuarantyContract' ";
		Sqlca.executeSQL(sSql);
		
		//------------------------------第二十一步：拷贝综合授信批复所对应的方案明细信息到合同中--------------------------------------					
		sSql =  " update CL_INFO set BCSerialNo =:BCSerialNo where ApplySerialNo =:ApplySerialNo ";
		so = new SqlObject(sSql).setParameter("BCSerialNo", sSerialNo).setParameter("ApplySerialNo", sObjectNo);
		Sqlca.executeSQL(so);	
		
		//------------------------------第二十三步：拷贝集团授信批复所对应的方案明细信息到合同中--------------------------------------					
		sSql =  " update GLINE_INFO set BCSerialNo =:BCSerialNo where ApplySerialNo =:ApplySerialNo ";
		so = new SqlObject(sSql).setParameter("BCSerialNo", sSerialNo).setParameter("ApplySerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		/****************add by hwang 20090702,拷贝关联额度信息*********************************/
		//------------------------------第二十二步：拷贝关联额度明细信息到批复中--------------------------------------
		sSql =  " select LineNo,IsInUse,Flag,BusinessType from CREDITLINE_RELA where ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		while(rs.next())
		{
			//获得关联额度表流水号
			sCRSerialNo = DBKeyHelp.getSerialNo("CREDITLINE_RELA","SerialNo",Sqlca);
			sLineNo=rs.getString("LineNo");
			sIsInUse=rs.getString("IsInUse");
			sFlag=rs.getString("Flag");
			sBusinessType=rs.getString("BusinessType");
			//插入关联额度信息
			sSql = " insert into CREDITLINE_RELA(SerialNo,ObjectType,ObjectNo,LineNo,IsInuse,Flag,BusinessType,"+
			"InputDate,InputUser,InputOrg,UpdateDate,UpdateUser,UpdateOrg)"+
			" values(:SerialNo,'BusinessContract',:ObjectNo,:LineNo,:IsInuse,"+
			"        :Flag,:BusinessType,:InputDate,:InputUser,:InputOrg,"+
			"        :UpdateDate,:UpdateUser,:UpdateOrg)  ";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", sCRSerialNo).setParameter("ObjectNo", sSerialNo).setParameter("LineNo", sLineNo).setParameter("IsInuse", sIsInUse)
			.setParameter("Flag", sFlag).setParameter("BusinessType", sBusinessType).setParameter("InputDate", StringFunction.getToday())
			.setParameter("InputUser", CurUser.getUserID()).setParameter("InputOrg", CurUser.getOrgID()).setParameter("UpdateDate", StringFunction.getToday())
			.setParameter("UpdateUser", CurUser.getUserID()).setParameter("UpdateOrg", CurUser.getOrgID());
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();
		
		return sSerialNo;
				
		
	}
	
	//判断字段类型是否为数字类型
	private static boolean isNumeric(int iType) 
	{
		if (iType==java.sql.Types.BIGINT ||iType==java.sql.Types.INTEGER || iType==java.sql.Types.SMALLINT || iType==java.sql.Types.DECIMAL || iType==java.sql.Types.NUMERIC || iType==java.sql.Types.DOUBLE || iType==java.sql.Types.FLOAT ||iType==java.sql.Types.REAL)
			return true;
		return false;
	}

}
