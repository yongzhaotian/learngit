package com.amarsoft.app.accounting.trans.script.common.executor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.ErrorCodeConfig;
import com.amarsoft.app.accounting.config.loader.OrgConfig;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.config.loader.TransactionConfig;
import com.amarsoft.app.accounting.exception.DataException;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.dict.als.cache.CodeCache;

public class BookKeepExecutor implements ITransactionExecutor {
	protected ITransactionScript transactionScript;

	@Override
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript=transactionScript;
		BusinessObject transaction = this.transactionScript.getTransaction();
		String groupID = TransactionConfig.getScriptAttribute(transaction.getString("TransCode"), scriptID, "GroupID");
		List<BusinessObject> detailList = this.createDetails(groupID);
		this.updateLedgerAccount(detailList);
		this.transactionScript.getTransaction().setRelativeObjects(detailList);//最后赋值，避免多次运行出现重复数据
		return 1;
	}
	
	private final List<BusinessObject> createDetails(String groupID) throws Exception {
		BusinessObject transaction = this.transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = this.transactionScript.getBOManager();
		List<BusinessObject> detailList = new ArrayList<BusinessObject>();
		if(groupID==null)groupID="";
		
		String transactionBookTypeFilter = transaction.getString("BookTypeFilter");
		if(transactionBookTypeFilter==null||transactionBookTypeFilter.length()==0) transactionBookTypeFilter=AccountCodeConfig.accountcode_type_all;
		ArrayList<ASValuePool> detailTemplete = TransactionConfig.getDetailTemplete(transaction.getString("TransCode"));
		for(int i=0;i<detailTemplete.size();i++){
			ASValuePool ledgerDetailConfigure = (ASValuePool) detailTemplete.get(i);
			String groupID_T = ledgerDetailConfigure.getString("GroupID");
			if(groupID_T==null)groupID_T="";
				
			if(!groupID.equals(groupID_T)) continue;
			//获取账套/扩展账套
			String bookType_T = ledgerDetailConfigure.getString("BookType");
			if(transactionBookTypeFilter.indexOf(bookType_T) <= -1 ) continue; 
			if(!ExtendedFunctions.getScriptBooleanValue(ledgerDetailConfigure.getString("BooleanScript"),transaction,boManager.getSqlca())) continue;
			
			
			String exBookType_T = ledgerDetailConfigure.getString("ExBookType");
			if(bookType_T==null||bookType_T.length()==0) 
				throw new DataException(ErrorCodeConfig.getMsg("E20001", new String[]{transaction.getString("TransCode")}));
			if(exBookType_T==null||exBookType_T.length()==0)
				exBookType_T = "";
			/*判断系统定义的账套和扩展账套，根据系统定义的账套生成指定账套的分录，如果系统仅指定了新会计准则的账套，则只生成新准则的分录
			  在系统采用的账套中，此处账套或扩展账套两个有一个满足都进行处理
			*/
			
			
			//开始创建交易分录
			String direction=ledgerDetailConfigure.getString("Direction");
			
			//发生额计算
			double occuramt = ExtendedFunctions.getScriptDoubleValue(ledgerDetailConfigure.getString("AmtScript"),transaction,boManager.getSqlca());
			occuramt = Arith.round(occuramt,2);
			if(occuramt==0.0) continue;
			
			//发生额红蓝字标记
			String transflag=ledgerDetailConfigure.getString("TransFlag");
			if("R".equals(transflag)) occuramt=0-occuramt;
			else if(!"B".equals(transflag)) throw new DataException(ErrorCodeConfig.getMsg("E20002", new String[]{transaction.getString("TransCode")}));
			
			//币种 
			String currency = ExtendedFunctions.getScriptStringValue(ledgerDetailConfigure.getString("CurrencyScript"),transaction,boManager.getSqlca());
			if(currency==null||currency.length()==0)
				throw new DataException(ErrorCodeConfig.getMsg("E20003", new String[]{transaction.getString("TransCode")}));
			
			//账务发生机构
			String orgID = ExtendedFunctions.getScriptStringValue(ledgerDetailConfigure.getString("OrgIDScript"),transaction,boManager.getSqlca());
			if(orgID==null||orgID.length()==0) 
				throw new DataException(ErrorCodeConfig.getMsg("E20004", new String[]{transaction.getString("TransCode")}));
			//科目号
			String accountCodeNo = ExtendedFunctions.getScriptStringValue(ledgerDetailConfigure.getString("AccountNoScript"),transaction,boManager.getSqlca());
			if(!bookType_T.equals(AccountCodeConfig.accountcode_type_s) && (accountCodeNo==null||accountCodeNo.length()==0))
				throw new DataException(ErrorCodeConfig.getMsg("E20005", new String[]{transaction.getString("TransCode"),(i+1)+""}));
			
			//外币汇率折算
			double exchangeRate=0d,baseCurrencyAmount=0d;
			String baseCurrency="";
			if(!bookType_T.equals(AccountCodeConfig.accountcode_type_s)){
				ASValuePool accountCodeDefinition=(ASValuePool) AccountCodeConfig.getAccountCodeDefinition(bookType_T, accountCodeNo);
				//本币币种
				baseCurrency =  accountCodeDefinition.getString("BaseCurrency");
				if(baseCurrency==null||baseCurrency.length()==0){
					throw new Exception(ErrorCodeConfig.getMsg("E10005", new String[]{accountCodeNo}));
				}
				//取交易发生时的汇率
				exchangeRate = RateConfig.getExchangeRate(currency, baseCurrency);
				//折本币金额，取最新汇率？
				baseCurrencyAmount =occuramt*exchangeRate;
			}
			
			//关联业务对象
			String objectType = ledgerDetailConfigure.getString("ObjectType");
			String objectNo="";
			if(objectType!=null&&objectType.length()>0){
				List<BusinessObject> relativeObjectList = transaction.getRelativeObjects(objectType);
				if(relativeObjectList!=null&&!relativeObjectList.isEmpty()){
					if(relativeObjectList.size()==1)
						objectNo=((BusinessObject)relativeObjectList.get(0)).getObjectNo();
					else throw new Exception(ErrorCodeConfig.getMsg("E10006", new String[]{objectType}));
				}
				else{
					throw new Exception(ErrorCodeConfig.getMsg("E10007", new String[]{objectType}));
				}
			}
			
			//交易对手信息-未使用，有些核心需要
			String adversary = ExtendedFunctions.getScriptStringValue(ledgerDetailConfigure.getString("AdversaryScript"),transaction,boManager.getSqlca());
			
			
			BusinessObject ledgerDetail = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.subledger_detail,boManager);
			ledgerDetail.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));//设置交易编号
			ledgerDetail.setAttributeValue("ExchangeRate",exchangeRate);
			ledgerDetail.setAttributeValue("BookType",bookType_T);
			ledgerDetail.setAttributeValue("BaseCurrency",baseCurrency);
			ledgerDetail.setAttributeValue("ObjectType",objectType);
			ledgerDetail.setAttributeValue("ObjectNo",objectNo);
			ledgerDetail.setAttributeValue("Direction",direction);//ygwang增加此字段
			if(bookType_T.equals(AccountCodeConfig.accountcode_type_s) && accountCodeNo!=null&&accountCodeNo.length()!=0)
			{
				StringTokenizer st = new StringTokenizer(accountCodeNo,"@");
				ledgerDetail.setAttributeValue("AccountCodeNo", st.nextToken());
				ledgerDetail.setAttributeValue("AccountInfo", accountCodeNo);//格式：账号@账户名@账户机构@账户币种@账户类型@账户标示#账号@账户名@账户机构@账户币种@账户类型@账户标示#……
			}
			else
				ledgerDetail.setAttributeValue("AccountCodeNo",accountCodeNo);
			ledgerDetail.setAttributeValue("Reference",transaction.getString("TransCode"));
			ledgerDetail.setAttributeValue("SortNo",ledgerDetailConfigure.getString("SortID"));
			ledgerDetail.setAttributeValue("Currency",currency);
			ledgerDetail.setAttributeValue("AccountingOrgID",orgID);
			ledgerDetail.setAttributeValue("Adversary",adversary);
			if("D".equals(direction) || "R".equals(direction)){
				ledgerDetail.setAttributeValue("DebitAmt",occuramt);
				ledgerDetail.setAttributeValue("CreditAmt",0d);
				ledgerDetail.setAttributeValue("BaseCurrencyAmount",Arith.round(baseCurrencyAmount,2));
			}else{
				ledgerDetail.setAttributeValue("DebitAmt",0d);
				ledgerDetail.setAttributeValue("CreditAmt",occuramt);
				ledgerDetail.setAttributeValue("BaseCurrencyAmount",Arith.round(-baseCurrencyAmount,2));
			}
			ledgerDetail.setAttributeValue("Description", ledgerDetailConfigure.getString("Description"));
			
			ledgerDetail.setAttributeValue("LDStatus", "0");
			ledgerDetail.setAttributeValue("OccurDate",transaction.getString("TransDate"));//设置为操作时间日期
			
			
			String exbookType=ledgerDetailConfigure.getString("ExBookType");
			if(exbookType!=null&&exbookType.length()>0){
				String[] s=exbookType.split(",");
				for(String s1:s){
					if(AccountCodeConfig.accountcode_type_all.indexOf(s1) >= 0)//非系统采用的账套，不生成数据
					{
						BusinessObject exdetail = createExLedgerdetail(ledgerDetail,s1);
						detailList.add(exdetail);
					}
				}
			}
			if(AccountCodeConfig.accountcode_type_all.indexOf(bookType_T) >= 0)//非系统采用的账套，只调用不生成具体数据
			{
				detailList.add(ledgerDetail);
			}
		}
		
		
		if(checkbalance(detailList)){
			return detailList;
		}
		else{
			throw new Exception(this.transactionScript.toString());
		}
		
	}
	
	protected final void updateLedgerAccount(List<BusinessObject> detailList) throws Exception {
		if(detailList==null||detailList.isEmpty()) return;
		BusinessObject transaction = this.transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = this.transactionScript.getBOManager();
		
		String transDate = transaction.getString("TransDate");
		for(int i=0;i<detailList.size();i++){
			BusinessObject ledgerDetail = (BusinessObject) detailList.get(i);
			String accountCodeNo = ledgerDetail.getString("AccountCodeNo");
			if(!AccountCodeConfig.accountcode_type_s.equals(ledgerDetail.getString("BookType")))
			{
				//设置分户账帐户信息
				BusinessObject subsidiaryledger = this.getSubledger(ledgerDetail);
				if(subsidiaryledger==null){
					subsidiaryledger=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger,boManager);
					subsidiaryledger.setAttributeValue("AccountCodeNo", ledgerDetail.getString("AccountCodeNo"));
					subsidiaryledger.setAttributeValue("AccountingOrgID", ledgerDetail.getString("AccountingOrgID"));
					subsidiaryledger.setAttributeValue("Currency", ledgerDetail.getString("Currency"));
	
					//取科目定义属性
					ASValuePool accountCodeDefinition = (ASValuePool) AccountCodeConfig.getAccountCodeDefinition(
							ledgerDetail.getString("BookType"), accountCodeNo);
					String subjectDirection=accountCodeDefinition.getString("Direction");
					subsidiaryledger.setAttributeValue("Direction", subjectDirection);
					
					subsidiaryledger.setAttributeValue("AccountStatus", "1");
					
					subsidiaryledger.setAttributeValue("CreateDate",SystemConfig.getBusinessDate());
					subsidiaryledger.setAttributeValue("ObjectNo",ledgerDetail.getString("ObjectNo"));
					subsidiaryledger.setAttributeValue("ObjectType",ledgerDetail.getString("ObjectType"));
					subsidiaryledger.setAttributeValue("BookType",ledgerDetail.getString("BookType"));
					
					String objectType=ledgerDetail.getString("ObjectType");
					String objectNo=ledgerDetail.getString("ObjectNo");
					BusinessObject businessObject = transaction.getRelativeObject(objectType, objectNo);
					if(businessObject==null) throw new Exception(ErrorCodeConfig.getMsg("E10010", new String[]{objectType,objectNo}));
					businessObject.setRelativeObject(subsidiaryledger);
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, subsidiaryledger);
				}
				else{
					boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, subsidiaryledger);
				}
				
				ledgerDetail.setAttributeValue("SubLedgerSerialNo", subsidiaryledger.getString("SerialNo"));
				if(!"0".equals(ledgerDetail.getString("LDStatus")))continue;//如果已经记账，则跳过
				double debitAmt=ledgerDetail.getDouble("DebitAmt");
				double creditAmt=ledgerDetail.getDouble("CreditAmt");
				double baseAmt=ledgerDetail.getMoney("BaseCurrencyAmount");
				
				String accountdirection=subsidiaryledger.getString("Direction");
				double debitbalance=subsidiaryledger.getDouble("DebitBalance");
				double creditbalance=subsidiaryledger.getDouble("CreditBalance");
							
				if("D".equals(accountdirection)){
					ledgerDetail.setAttributeValue("ODebitBalance",Arith.round(debitbalance,2));//记录变化前的余额
					ledgerDetail.setAttributeValue("DebitBalance",Arith.round(debitbalance+debitAmt-creditAmt,2));//记录变化后的余额
					subsidiaryledger.setAttributeValue("DebitBalance",Arith.round(debitbalance+debitAmt-creditAmt,2));
					//更新本币金额
					subsidiaryledger.setAttributeValue("BASEDEBITBALANCE",
							Arith.round(subsidiaryledger.getMoney("BASEDEBITBALANCE")+baseAmt,2));
				}
				else if("C".equals(accountdirection)){
					ledgerDetail.setAttributeValue("OCreditBalance",Arith.round(creditbalance,2));//记录变化前的余额
					ledgerDetail.setAttributeValue("CreditBalance",Arith.round(creditbalance+creditAmt-debitAmt,2));//记录变化后的余额
					subsidiaryledger.setAttributeValue("CreditBalance",Arith.round(creditbalance+creditAmt-debitAmt,2));
					
					//更新本币金额
					subsidiaryledger.setAttributeValue("BaseCreditBalance",
							Arith.round(subsidiaryledger.getMoney("BaseCreditBalance")-baseAmt,2));
				}
				else{//双向科目
					ledgerDetail.setAttributeValue("ODebitBalance",Arith.round(debitbalance,2));//记录变化前的余额
					ledgerDetail.setAttributeValue("DebitBalance",Arith.round(debitbalance+debitAmt,2));//记录变化后的余额
					subsidiaryledger.setAttributeValue("DebitBalance",Arith.round(debitbalance+debitAmt,2));
					
					ledgerDetail.setAttributeValue("OCreditBalance",Arith.round(creditbalance,2));//记录变化前的余额
					ledgerDetail.setAttributeValue("CreditBalance",Arith.round(creditbalance+creditAmt,2));//记录变化后的余额
					subsidiaryledger.setAttributeValue("CreditBalance",Arith.round(creditbalance+creditAmt,2));
					
					//更新本币金额
					if(baseAmt>0){
						subsidiaryledger.setAttributeValue("BASEDEBITBALANCE",
								Arith.round(subsidiaryledger.getMoney("BASEDEBITBALANCE")+baseAmt,2));
					}
					else{
						subsidiaryledger.setAttributeValue("BaseCreditBalance",
								Arith.round(subsidiaryledger.getMoney("BaseCreditBalance")-baseAmt,2));
					}
				}
				
				//CR-0xx，记录账户最近一次交易的汇率
				subsidiaryledger.setAttributeValue("ExchangeRate",ledgerDetail.getDouble("ExchangeRate"));
				
							
				//1.当日发生额,应为分户明细中的发生金额。
				subsidiaryledger.setAttributeValue("DEBITAMTDAY",Arith.round(subsidiaryledger.getDouble("DEBITAMTDAY")+debitAmt,2));
				subsidiaryledger.setAttributeValue("CREDITAMTDAY",Arith.round(subsidiaryledger.getDouble("CREDITAMTDAY")+creditAmt,2));
				
				//2.当月发生额
				subsidiaryledger.setAttributeValue("DEBITAMTMONTH",Arith.round(subsidiaryledger.getDouble("DEBITAMTMONTH")+debitAmt,2));
				subsidiaryledger.setAttributeValue("CREDITAMTMONTH",Arith.round(subsidiaryledger.getDouble("CREDITAMTMONTH")+creditAmt,2));
				
				//3.当年发生额
				subsidiaryledger.setAttributeValue("DEBITAMTYEAR",Arith.round(subsidiaryledger.getDouble("DEBITAMTYEAR")+debitAmt,2));
				subsidiaryledger.setAttributeValue("CREDITAMTYEAR",Arith.round(subsidiaryledger.getDouble("CREDITAMTYEAR")+creditAmt,2));
			}
			ledgerDetail.setAttributeValue("LDStatus","1");
			ledgerDetail.setAttributeValue("OccurDate",transDate);
			ledgerDetail.setAttributeValue("OccurTime",DateFunctions.getDateTime(new java.util.Date(),"HH:mm:ss"));
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, ledgerDetail);
		}
	}
	
	
	private BusinessObject getSubledger(BusinessObject ledgerDetail) throws Exception{
		String objectType=ledgerDetail.getString("ObjectType");
		String objectNo=ledgerDetail.getString("ObjectNo");
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", ledgerDetail.getString("ObjectType"));
		as.setAttribute("ObjectNo", ledgerDetail.getString("ObjectNo"));
		as.setAttribute("AccountCodeNo", ledgerDetail.getString("AccountCodeNo"));
		as.setAttribute("AccountingOrgID", ledgerDetail.getString("AccountingOrgID"));
		as.setAttribute("BookType", ledgerDetail.getString("BookType"));
		BusinessObject attributesFilter = new BusinessObject(as);
		
		BusinessObject businessObject = this.transactionScript.getTransaction().getRelativeObject(objectType, objectNo);
		if(businessObject==null) throw new Exception(ErrorCodeConfig.getMsg("E10010", new String[]{objectType,objectNo}));
		List<BusinessObject>  relativeSubledgerList = businessObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger,attributesFilter);
		if(relativeSubledgerList!=null&&!relativeSubledgerList.isEmpty()){
			if(relativeSubledgerList.size()>1) throw  new Exception(ErrorCodeConfig.getMsg("E10011", new String[]{objectType,objectNo}));
			else return relativeSubledgerList.get(0);
		}
		return null;
	}
	
	
	protected boolean checkbalance(List<BusinessObject> detailList) throws Exception{
		BusinessObject transaction = this.transactionScript.getTransaction();
		
		HashMap<String,Double> debitMap = new HashMap<String,Double>();
		HashMap<String,Double> creditMap = new HashMap<String,Double>();
		String objectType = "";
		String objectNo = "";
		for(int i=0;i<detailList.size();i++){
			BusinessObject subledgerdetail = (BusinessObject) detailList.get(i);
			objectType = subledgerdetail.getString("ObjectType");
			objectNo = subledgerdetail.getString("ObjectNo");
			String bookType = subledgerdetail.getString("BookType");
			String currency=subledgerdetail.getString("Currency");
			String orgID=subledgerdetail.getString("AccountingOrgID");
			if(!bookType.equals(AccountCodeConfig.accountcode_type_s))
			{
				ASValuePool accountCodeDefinition = (ASValuePool) AccountCodeConfig.getAccountCodeDefinition(
						subledgerdetail.getString("BookType"), subledgerdetail.getString("AccountCodeNo"));
				String onBalanceSheetFlag = accountCodeDefinition.getString("OnBalanceSheetFlag");
				if("2".equals(onBalanceSheetFlag)) continue;
			}
			
			Double debitAmt = debitMap.get(bookType+"@"+orgID+"@"+currency);
			if(debitAmt == null) debitMap.put(bookType+"@"+orgID+"@"+currency, new Double(subledgerdetail.getDouble("DebitAmt")));
			else debitMap.put(bookType+"@"+orgID+"@"+currency, new Double(debitAmt.doubleValue()+subledgerdetail.getDouble("DebitAmt")));
			
			Double creditAmt = creditMap.get(bookType+"@"+orgID+"@"+currency);
			if(creditAmt == null) creditMap.put(bookType+"@"+orgID+"@"+currency, new Double(subledgerdetail.getDouble("CreditAmt")));
			else creditMap.put(bookType+"@"+orgID+"@"+currency, new Double(creditAmt.doubleValue()+subledgerdetail.getDouble("CreditAmt")));
		}
		
		StringBuffer sb = new StringBuffer();
		boolean flag = true;
		//先扫描借方
		for(Object a:debitMap.keySet().toArray())
		{
			String key = (String)a;
			Double creditAmt = creditMap.get(key);
			Double debitAmt = debitMap.get(key);
			if(creditAmt == null) creditAmt = new Double(0.0d);
			if(debitAmt == null) debitAmt = new Double(0.0d);
			if(Arith.round(Math.abs(creditAmt-debitAmt),2)<0.0000001) {
				//借贷平衡
			}
			else {
				flag = false;
				sb.append("核算对象【"+objectType+"-"+objectNo+"】账簿【"+CodeCache.getItemName("AccountBookType",key.split("@")[0])+"】机构【"+OrgConfig.getOrg(key.split("@")[1]).getString("OrgName")+"】币种【"+CodeCache.getItemName("Currency",key.split("@")[2])+"】借贷不平【贷方:"+creditAmt+" ，借方:"+debitAmt+"】<br>");
			}
		}
		
		//再扫描贷方
		for(Object a:creditMap.keySet().toArray())
		{
			String key = (String)a;
			Double creditAmt = creditMap.get(key);
			Double debitAmt = debitMap.get(key);
			if(creditAmt == null) creditAmt = new Double(0.0d);
			if(debitAmt == null) debitAmt = new Double(0.0d);
			if(Arith.round(Math.abs(creditAmt-debitAmt),2)<0.0000001) {
				//借贷平衡
			}
			else {
				flag = false;
				sb.append("核算对象【"+objectType+"-"+objectNo+"】账簿【"+CodeCache.getItemName("AccountBookType",key.split("@")[0])+"】机构【"+OrgConfig.getOrg(key.split("@")[1]).getString("OrgName")+"】币种【"+CodeCache.getItemName("Currency",key.split("@")[2])+"】借贷不平【贷方:"+creditAmt+" ，借方:"+debitAmt+"】<br>");
			}
		}
		if(sb.length()>0) TransactionFunctions.setErrorMessage(transaction,"", "", sb.toString());
		return flag;
	}
	
	
	protected BusinessObject createExLedgerdetail(BusinessObject ledgerDetail,String bookType) throws NumberFormatException, Exception{
		BusinessObject transaction = this.transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = this.transactionScript.getBOManager();
		
		BusinessObject exledgerDetail = ledgerDetail.cloneObject();//CLONE对象
		exledgerDetail.setAttributeValue("SerialNo", "");//设置主键流水为空，让其重新生成
		boManager.generateObjectNo(exledgerDetail);//重新生成流水号
		
		String accountCodeNo = ledgerDetail.getString("AccountCodeNo");//获取系统内部账务代码
		ASValuePool accountCodeDefinition = (ASValuePool) AccountCodeConfig.getAccountCodeDefinition(
				ledgerDetail.getString("BookType"), accountCodeNo);//获取系统内部账务代码对应的配置信息
		
		//获取对应科目号
		String exaccountCodeNo = "";
		String mappingScript = accountCodeDefinition.getString("MappingScript");//获取内部账务代码映射扩展行内科目代码脚本
		if(mappingScript==null||mappingScript.length()==0)//脚本不为空，以脚本进行扩展
		{
			String objectType = ledgerDetail.getString("ObjectType");
			if(objectType!=null&&objectType.length()>0){
				List<BusinessObject> relativeObjectList = transaction.getRelativeObjects(transaction.getString("RelativeObjectType"));
				if(relativeObjectList!=null&&!relativeObjectList.isEmpty()){
					if(relativeObjectList.size()==1)
					{
						BusinessObject bo = relativeObjectList.get(0);
						exaccountCodeNo = AccountCodeConfig.getAccountingCatalog(bo, accountCodeNo,boManager.getSqlca());
						if(exaccountCodeNo==null||exaccountCodeNo.length()==0){
							throw new Exception(ErrorCodeConfig.getMsg("E10008", new String[]{accountCodeNo}));
						}
					}
					else throw new Exception(ErrorCodeConfig.getMsg("E10006", new String[]{objectType}));
				}
			}
		}
		else //如果脚本为空则以账务方案进行映射
		{
			exaccountCodeNo = ExtendedFunctions.getScriptStringValue(mappingScript,transaction,boManager.getSqlca());
			if(exaccountCodeNo==null||exaccountCodeNo.length()==0){
				throw new Exception(ErrorCodeConfig.getMsg("E10009", new String[]{accountCodeNo}));
			}
		}
		
		if(bookType.equals(AccountCodeConfig.accountcode_type_s))
		{
			StringTokenizer st = new StringTokenizer(exaccountCodeNo,"@");
			exledgerDetail.setAttributeValue("AccountCodeNo", st.nextToken());
			exledgerDetail.setAttributeValue("AccountInfo", exaccountCodeNo);//格式：账号@账户名@账户机构@账户币种@账户类型@账户标示#账号@账户名@账户机构@账户币种@账户类型@账户标示#……
		}
		else
			exledgerDetail.setAttributeValue("AccountCodeNo", exaccountCodeNo);
		exledgerDetail.setAttributeValue("BookType",bookType);
		return exledgerDetail;
	}

}
