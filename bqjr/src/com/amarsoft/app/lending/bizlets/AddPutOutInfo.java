/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --将合同基本信息复制到出帐中
		Input Param:
				ObjectType: 批复对象
				ObjectNo: 批复流水号
				UserID：用户代码
		Output Param:
				SerialNo：合同流水号
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.product.ProductManage;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class AddPutOutInfo extends Bizlet {

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
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sBillNo == null) sBillNo = "";
		if(sUserID == null) sUserID = "";
		
		SqlObject so = null; //声明对象
		
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
		//定义变量：查询结果集
		ASResultSet rs = null;
		//实例化用户对象
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		//根据合同流水号获取发生类型
		sOccurType = Sqlca.getString(new SqlObject("select OccurType from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo));
		//将空值转化为空字符串			
		if(sOccurType == null) sOccurType = "";
	
		//根据业务品种获取交易代码
		sExchangeType = Sqlca.getString(new SqlObject("select SubTypeCode from BUSINESS_TYPE where TypeNo =:TypeNo").setParameter("TypeNo", sBusinessType));
		//将空值转化为空字符串
		if(sExchangeType == null) sExchangeType = "";
		if(sOccurType.equals("015")){ //展期
			sExchangeType = "6201";
		}
		
		//当业务品种为银行承兑汇票贴现、商业承兑汇票贴现、协议付息票据贴现
		if(sBusinessType.equals("1020010") || sBusinessType.equals("1020020") || sBusinessType.equals("1020030")){
			if(!sBillNo.equals("")){ //将单张汇票信息拷贝到出帐中
				sSql = 	" select * from BILL_INFO "+
				" where ObjectType = 'BusinessContract' "+
				" and ObjectNo =:ObjectNo "+
				" and BillNo =:BillNo "+
				" and BillNo not in "+
				" (select BillNo from BUSINESS_PUTOUT "+
				" where ContractSerialNo =:ContractSerialNo)";
				so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("BillNo", sBillNo).setParameter("ContractSerialNo", sObjectNo);
				rs = Sqlca.getASResultSet(so);
			}else{ //将贴现合同项下的汇票信息拷贝到出帐中
				sSql = 	" select * from BILL_INFO "+
				" where ObjectType = 'BusinessContract' "+
				" and ObjectNo =:ObjectNo"+
				" and BillNo not in "+
				" (select BillNo from BUSINESS_PUTOUT "+
				" where ContractSerialNo =:ContractSerialNo)";
				so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ContractSerialNo", sObjectNo);
				rs = Sqlca.getASResultSet(so);
			}
			while(rs.next()){
				//获得出帐流水号
				sSerialNo = DBKeyHelp.getSerialNo("BUSINESS_PUTOUT","SerialNo","",Sqlca);
				String billNo = rs.getString("BillNo");
				double billSum = rs.getDouble("BillSum");
				String putoutDate = rs.getString("FinishDate");
				String maturity = rs.getString("Maturity");
				int endorseTimes = rs.getInt("EndorseTimes");
				double rate = rs.getDouble("Rate");
				String holderID = rs.getString("HolderID");
				String currency = rs.getString("LCCurrency");
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
							"ResumeIntType, " +	
							"REPRICETYPE," +
							"REPRICEFLAG," +
							"REPRICECYC," +
							"REPRICEDATE," +
							"LoanRateTermID," +
							"RPTTermID," +
							"ProductVersion," +
							"PutoutStatus " +	
							") "+
							"select "+ 
							"'"+sSerialNo+"', " + 
							"'"+sExchangeType+"', " +	
							"'"+billNo+"', " +
							""+billSum+", " +
							""+billSum+", " +
							""+rate+", " +
							"'"+DateFunctions.getRelativeDate(maturity, DateFunctions.TERM_UNIT_DAY, endorseTimes)+"', " +							
							""+endorseTimes+", " +	
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
							"'"+putoutDate+"', " +							
							"ICType, " +
							"ICCyc, " +
							"PayCyc, " +					
							"CorpusPayMethod, " +
							"CreditAggreement, " +
							"Purpose, " +
							"RateFloatType, " +
							"PdgSum, " +
							"'"+holderID+"', " +
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
							"'1', " +
							"'7'," +
							"''," +
							"0," +//贴现放宽时该字段是整型，不能为空串。 2013-12-14
							"''," +
							"LoanRateTermID," +
							"RPTTermID," +
							"ProductVersion," +
							"'0' " +
							"from BUSINESS_CONTRACT " +
							"where SerialNo= :BCSerialNo";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo));
				
				transferAccountNo(Sqlca.getTransaction(),sObjectNo,sSerialNo);
				transferRate(Sqlca.getTransaction(),sObjectNo,sSerialNo);
				
				transferRPT(Sqlca.getTransaction(),sObjectNo,sSerialNo);
				transferSPT(Sqlca.getTransaction(),sObjectNo,sSerialNo);
				transferFee(Sqlca.getTransaction(),sObjectNo,sSerialNo,CurUser);
				AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
				BusinessObject bp = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_putout, sSerialNo);
				//	处理利率
				ProductManage pm= new ProductManage(bom);
				List<BusinessObject> boList = pm.createTermObject("RAT003",bp);
				if(boList != null && !boList.isEmpty())
				{
					boList.get(0).setAttributeValue("BusinessRate", rate);
				}
				bom.updateDB();
				sSerialNoStr = sSerialNoStr + sSerialNo + "@";
			}
			rs.getStatement().close();
		}else{
			//获取合同可用金额
			Bizlet bzGetPutOutSum = new GetPutOutSum();
			bzGetPutOutSum.setAttribute("ContractSerialNo",sObjectNo); 
			bzGetPutOutSum.setAttribute("SerialNo","");				
			String sSurplusPutOutSum = (String)bzGetPutOutSum.run(Sqlca);
			
			//获得出帐流水号
			sSerialNo = DBKeyHelp.getSerialNo("BUSINESS_PUTOUT","SerialNo","",Sqlca);
			//将合同信息复制到出帐信息中
			sSql =  "insert into BUSINESS_PUTOUT ( "+
						"SerialNo, " + 
						"ExchangeType, " +
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
						"Maturity, " +
						"BusinessRate, " +
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
						"BusinessSum, " +
						"PreIntType, " +						
						"ResumeIntType," +
						"REPRICETYPE," +
						"REPRICEFLAG," +
						"REPRICECYC," +
						"REPRICEDATE," +
						"LoanRateTermID," +
						"RPTTermID," +
						"ProductVersion," +
						"PutoutStatus " +						
						") "+
						"select "+ 
						"'"+sSerialNo+"', " + 
						"'"+sExchangeType+"', " +					
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
						"PutoutDate, " +
						"Maturity, " +
						"BusinessRate, " +
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
						""+sSurplusPutOutSum+", " +
						"'0', " +
						"'1', " +
						"REPRICETYPE," +
						"REPRICEFLAG," +
						"REPRICECYC," +
						"REPRICEDATE," +
						"LoanRateTermID," +
						"RPTTermID," +
						"ProductVersion," +
						"'0' " +		
						"from BUSINESS_CONTRACT " +
						"where SerialNo= :BCSerialNo";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo));
			
			transferAccountNo(Sqlca.getTransaction(),sObjectNo,sSerialNo);
			transferRate(Sqlca.getTransaction(),sObjectNo,sSerialNo);
			transferRPT(Sqlca.getTransaction(),sObjectNo,sSerialNo);
			transferSPT(Sqlca.getTransaction(),sObjectNo,sSerialNo);
			transferFee(Sqlca.getTransaction(),sObjectNo,sSerialNo,CurUser);
			
			sSerialNoStr = sSerialNoStr + sSerialNo + "@";
		}
				
		return sSerialNoStr;
	}	
	
	
	
	/**
	 * 拷贝审批意见对应的利率
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferRate(JBOTransaction tx,String BCSerialNo,String BPSerialNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
						.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract)
		                .setParameter("ObjectNo", BCSerialNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
			newCO.setAttributeValue("ObjectNo", BPSerialNo);
			m.saveObject(newCO);
		}
	}
	
	
	/**
	 * 拷贝审批意见对应的还款方式
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferRPT(JBOTransaction tx,String BCSerialNo,String BPSerialNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
									.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract)
							        .setParameter("ObjectNo", BCSerialNo)
							        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
			newCO.setAttributeValue("ObjectNo", BPSerialNo);
			m.saveObject(newCO);
		}
	}
	
	
	/**
	 * 拷贝审批意见对应的费用
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferFee(JBOTransaction tx,String BCSerialNo,String BPSerialNo,ASUser curUser) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.fee);
		BizObjectManager ms=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.fee_waive);
		BizObjectManager ma=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		tx.join(m);
		tx.join(ms);
		tx.join(ma);
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
								.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract)
						        .setParameter("ObjectNo", BCSerialNo)
						        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
			newCO.setAttributeValue("ObjectNo", BPSerialNo);
			newCO.setAttributeValue("Status","1");
			newCO.setAttributeValue("AccountingOrgID",curUser.getOrgID());
			m.saveObject(newCO);
			
			String oldFeeSerialNo = biz.getAttribute("SerialNo").getString();
			String feeSerialNo = newCO.getAttribute("SerialNo").getString();
			List<BizObject> feeWaive = ms.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo")
											.setParameter("ObjectNo", oldFeeSerialNo)
											.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee)
											.getResultList(false);
			for(BizObject boWaive : feeWaive)
			{
				BizObject newWaive = ms.newObject();
				newWaive.setAttributesValue(boWaive);
				newWaive.setAttributeValue("SerialNo", null);
				newWaive.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
				newWaive.setAttributeValue("ObjectNo", feeSerialNo);
				ms.saveObject(newWaive);
			}
			
			List<BizObject> boAccounts=ma.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo ")
										.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee)
							            .setParameter("ObjectNo", oldFeeSerialNo)
							            .getResultList(false);
			for(BizObject boAccount:boAccounts){
				BizObject newAccount = ma.newObject();
				newAccount.setAttributesValue(boAccount);
				newAccount.setAttributeValue("SerialNo", null);
				newAccount.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
				newAccount.setAttributeValue("ObjectNo", feeSerialNo);
				ma.saveObject(newAccount);
			}
		}
	}
	
	/**
	 * 拷贝审批意见对应的贴息
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferSPT(JBOTransaction tx,String BCSerialNo,String BPSerialNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
								.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract)
						        .setParameter("ObjectNo", BCSerialNo)
						        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
			newCO.setAttributeValue("ObjectNo", BPSerialNo);
			m.saveObject(newCO);
		}
	}
	
	/**
	 * 拷贝申请信息的账号信息
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferAccountNo(JBOTransaction tx,String BCSerialNo,String BPSerialNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
								.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract)
						        .setParameter("ObjectNo", BCSerialNo)
						        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
			newCO.setAttributeValue("ObjectNo", BPSerialNo);
			m.saveObject(newCO);
		}
	}
}
