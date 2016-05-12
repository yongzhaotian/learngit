package com.amarsoft.app.accounting.trans.script.loan.accountorgchange;

//还款，整合提前还款
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.common.executor.BookKeepExecutor;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

public class AccountOrgChangeExecutor extends BookKeepExecutor{
	
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		ArrayList<BusinessObject> detailList = new ArrayList<BusinessObject>();
		//交易对应的借据对象
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		//交易对应的单据对象
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//取新机构
		String newAccountingOrgID = loanChange.getString("AccountingOrgID");
		//把原借据对象的入账机构设置到单据的原入账机构中
		loan.setAttributeValue("AccountingOrgID", loanChange.getString("AccountingOrgID"));

		//此处处理分录
		List<BusinessObject> subledgers = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger);
		if(subledgers != null){
			for(int i =0; i < subledgers.size(); i ++){
				String subLedgerSerialNo = subledgers.get(i).getString("SerialNo");
				String objectType = subledgers.get(i).getString("ObjectType");
				String objectNo = subledgers.get(i).getString("ObjectNo");
				String oldAccountingOrgID = subledgers.get(i).getString("AccountingOrgID");
				String bookType = subledgers.get(i).getString("BookType");
				String accountCodeNo = subledgers.get(i).getString("AccountCodeNo");
				String currency = subledgers.get(i).getString("Currency");
				double occuramt = subledgers.get(i).getDouble("DebitBalance")-subledgers.get(i).getDouble("CreditBalance");
				
				double exchangeRate=0d,baseCurrencyAmount=0d;
				String baseCurrency="";
				if(!bookType.equals(AccountCodeConfig.accountcode_type_s)){
					ASValuePool accountCodeDefinition=(ASValuePool) AccountCodeConfig.getAccountCodeDefinition(bookType, accountCodeNo);
					//本币币种
					baseCurrency =  accountCodeDefinition.getString("BaseCurrency");
					if(baseCurrency==null||baseCurrency.length()==0){
						throw new Exception("科目{"+accountCodeNo+"}未定义本币币种！");
					}
					//取交易发生时的实时汇率\取最近一次交易汇率 项目组根据情况选择
					//exchangeRate = RateConfig.getExchangeRate(currency, baseCurrency);
					exchangeRate = subledgers.get(i).getDouble("ExchangeRate");
					//折本币金额
					baseCurrencyAmount =occuramt*exchangeRate;
				}
				
				//产生老机构的销账分录
				BusinessObject subDetail = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.subledger_detail,boManager);
				subDetail.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));//设置交易编号
				subDetail.setAttributeValue("SubLedgerSerialNo", subLedgerSerialNo);//设置分户账流水号
				subDetail.setAttributeValue("ExchangeRate",exchangeRate);
				subDetail.setAttributeValue("BookType",bookType);
				subDetail.setAttributeValue("BaseCurrency",baseCurrency);
				subDetail.setAttributeValue("ObjectType",objectType);
				subDetail.setAttributeValue("ObjectNo",objectNo);
				subDetail.setAttributeValue("AccountCodeNo",accountCodeNo);
				subDetail.setAttributeValue("Reference",transaction.getString("TransCode"));
				subDetail.setAttributeValue("SortNo",String.valueOf(i+1));
				subDetail.setAttributeValue("Currency",currency);
				subDetail.setAttributeValue("AccountingOrgID",oldAccountingOrgID);
				subDetail.setAttributeValue("DebitAmt",-subledgers.get(i).getDouble("DebitBalance"));
				subDetail.setAttributeValue("CreditAmt",-subledgers.get(i).getDouble("CreditBalance"));
				subDetail.setAttributeValue("ODebitBalance",subledgers.get(i).getDouble("DebitBalance"));//记录变化前的余额
				subDetail.setAttributeValue("DebitBalance",0.0d);//记录变化前的余额
				subDetail.setAttributeValue("OCreditBalance",subledgers.get(i).getDouble("CreditBalance"));//记录变化前的余额
				subDetail.setAttributeValue("CreditBalance",0.0d);//记录变化后的余额
				subDetail.setAttributeValue("BaseCurrencyAmount",Arith.round(-baseCurrencyAmount,2));
				subDetail.setAttributeValue("Description", "机构调整");
				subDetail.setAttributeValue("LDStatus","1");
				subDetail.setAttributeValue("OccurDate",transaction.getString("TransDate"));
				subDetail.setAttributeValue("OccurTime",DateFunctions.getDateTime(new java.util.Date(),"HH:mm:ss"));
				detailList.add(subDetail);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,subDetail);
				
				//产生新机构的入账分录
				BusinessObject newSubDetail = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.subledger_detail,boManager);
				newSubDetail.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));//设置交易编号
				newSubDetail.setAttributeValue("SubLedgerSerialNo", subLedgerSerialNo);//设置分户账流水号
				newSubDetail.setAttributeValue("ExchangeRate",exchangeRate);
				newSubDetail.setAttributeValue("BookType",bookType);
				newSubDetail.setAttributeValue("BaseCurrency",baseCurrency);
				newSubDetail.setAttributeValue("ObjectType",objectType);
				newSubDetail.setAttributeValue("ObjectNo",objectNo);
				newSubDetail.setAttributeValue("AccountCodeNo",accountCodeNo);
				newSubDetail.setAttributeValue("Reference",transaction.getString("TransCode"));
				newSubDetail.setAttributeValue("SortNo",String.valueOf(i+1));
				newSubDetail.setAttributeValue("Currency",currency);
				newSubDetail.setAttributeValue("AccountingOrgID",newAccountingOrgID);
				newSubDetail.setAttributeValue("DebitAmt",subledgers.get(i).getDouble("DebitBalance"));
				newSubDetail.setAttributeValue("CreditAmt",subledgers.get(i).getDouble("CreditBalance"));
				newSubDetail.setAttributeValue("ODebitBalance",0.0d);//记录变化前的余额
				newSubDetail.setAttributeValue("DebitBalance",subledgers.get(i).getDouble("DebitBalance"));//记录变化前的余额
				newSubDetail.setAttributeValue("OCreditBalance",0.0d);//记录变化前的余额
				newSubDetail.setAttributeValue("CreditBalance",subledgers.get(i).getDouble("CreditBalance"));//记录变化后的余额
				newSubDetail.setAttributeValue("BaseCurrencyAmount",Arith.round(baseCurrencyAmount,2));
				newSubDetail.setAttributeValue("Description", "机构调整");
				newSubDetail.setAttributeValue("LDStatus","1");
				newSubDetail.setAttributeValue("OccurDate",transaction.getString("TransDate"));
				newSubDetail.setAttributeValue("OccurTime",DateFunctions.getDateTime(new java.util.Date(),"HH:mm:ss"));
				detailList.add(newSubDetail);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,newSubDetail);
				
				//更新分户账信息表机构
				subledgers.get(i).setAttributeValue("AccountingOrgID", newAccountingOrgID);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,subledgers.get(i));
			}
		}
		//检查账务信息
		checkbalance(detailList);
		
		//更改关联费用机构信息
		List<BusinessObject> feeList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(feeList != null){
			for(BusinessObject fee:feeList){
				fee.setAttributeValue("AccountingOrgID", newAccountingOrgID);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,fee);	
			}
		}
		
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);	
		return 1;
	}

}