package com.amarsoft.app.accounting.config.loader;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.CommonTransaction;
import com.amarsoft.app.accounting.util.expression.FunctionManager;
import com.amarsoft.are.io.FileTool;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.xml.Attribute;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

public class TransactionConfig extends AbstractCache{
	private static ASValuePool transactionDefSet;//交易定义集合
	private static Document transaction_document;
	private static Document function_document;
	
	/**
	 * 获取交易的分录模板列表
	 * @param transCode
	 * @return
	 * @throws Exception
	 */
	public static ArrayList<ASValuePool> getDetailTemplete(String transCode) throws Exception {
		ASValuePool transactionDef = TransactionConfig.getTransactionDef(transCode);
		return (ArrayList<ASValuePool>)transactionDef.getAttribute("DetailTemplete");
	}
	
	public static ASValuePool getTransactionDef(String transactionCode) throws Exception{
		ASValuePool transactionDef = (ASValuePool) transactionDefSet.getAttribute(transactionCode);
		if(transactionDef==null) throw new Exception("获取交易定义时出错，交易码"+transactionCode+"不存在！");
		return transactionDef;
	}
	
	public static String getTransactionDef(String transactionCode,String attributeID) throws Exception{
		String value = TransactionConfig.getTransactionDef(transactionCode).getString(attributeID);
		if(value==null||value.length()==0){
			Element e = (Element)TransactionConfig.getTransactionDef(transactionCode).getAttribute("XMLDocument");
			value = e.getAttributeValue(attributeID);
		}
		return value;
	}
	
	public static String getScriptAttribute(String transactionCode,String scriptID,String attributeID) throws Exception{
		Element e1 = (Element)TransactionConfig.getTransactionDef(transactionCode).getAttribute("XMLDocument");
		Element e = e1.getChild(scriptID);
		if(e==null) return "";
		String value = e.getAttributeValue(attributeID);
		if(value==null||value.length()==0) value = e.getChildTextTrim(attributeID);
		return value;
	}
	
	private static void regFunctions() throws Exception{
		/**
		 * 获取机构存款账户信息，写法参见：
		 * 	'${GetOrgAccount('${jbo.app.ACCT_LOAN.AccountingOrgID}','010','${jbo.app.ACCT_LOAN.Currency}')}'
		 * 此段代码表示取信贷与核心往来账户
		 * 参数一，核算业务所属机构号
		 * 参数二，所取机构层面存款账户类型，参见代码OrgAccountType
		 * 参数三，核算业务所属币种
		 */
		FunctionManager.regFunction("GetOrgAccount", "com.amarsoft.app.accounting.config.loader.OrgConfig", "getOrgAccount");
		/**
		 * 获取核算对象自身关联的存款账户信息，写法参见：
		 *  '${GetRelativeAccount('jbo.app.ACCT_LOAN','PayAccountNo@PayAccountName@PayAccountOrgID@PayAccountCurrency@PayAccountType@PayAccountFlag','AccountIndicator@01')}'
		 *  此段代码取处理核算对象所关联的存款账户信息
		 * 参数一、交易处理核算对象类型
		 * 参数二、需要从交易单据中获取那些数据字段信息，排序及写法为：账号@账户名@账户机构@账户币种@账户类型@账户标示
		 * 参数三、需要从关联账户信息表中获取数据的条件，写法为：字段1@值1@字段2@值2@…… 例如 AccountIndicator@01 表示只取AccountIndicator=01的记录
		 */
		FunctionManager.regFunction("GetRelativeAccount", "com.amarsoft.app.accounting.util.expression.functions.GetRelativeAccount");//获取关联对象账户信息
		/**
		 * 获取交易关联的核算对象的属性值（该方法一般不使用，在表达式中可直接写变量名代替），写法参见:'${GetObjectAttribute('jbo.app.ACCT_LOAN','BusinessSum')}'
		 * 	这种写法可以用'${jbo.app.ACCT_LOAN.BusinessSum}'所代替
		 *  参数一、交易处理核算对象类型
		 *  参数二、核算对象所包含的属性
		 */
		FunctionManager.regFunction("GetObjectAttribute","com.amarsoft.app.accounting.util.expression.functions.GetObjectAttribute");//获取对象属性
		
		/**
		 * 获取交易关联的核算对象关联的子对象的属性值，写法参见： '${GetRelativeObjectAttribute('jbo.app.ACCT_LOAN','jbo.app.ACCT_DEPOSIT_ACCOUNTS','ACCOUNTNO','ACCOUNTINDICATOR','00')}'
		 *  参数一、交易处理核算对象类型
		 *  参数二、核算对象关联子对象
		 *  参数三、核算对象关联子对象属性字段名
		 *  参数四、参数五配合使用，表示核算对象关联子对象筛选条件，参数四是关联子对象属性字段，参数五是值
		 */
		FunctionManager.regFunction("GetRelativeObjectAttribute","com.amarsoft.app.accounting.util.expression.functions.GetRelativeObjectAttribute");//获取关联对象属性
		/**
		 * 获取交易关联的核算对象关联的子对象的金额值，写法参见： '${GetBalance('jbo.app.ACCT_LOAN','jbo.app.ACCT_SUBSIDIARY_LEDGER','DebitBalance','AccountCodeNo','LAS10301')}'
		 *  参数一、交易处理核算对象类型
		 *  参数二、核算对象关联子对象
		 *  参数三、核算对象关联子对象属性字段名
		 *  参数四、参数五配合使用，表示核算对象关联子对象筛选条件，参数四是关联子对象属性字段，参数五是值
		 */
		FunctionManager.regFunction("GetBalance","com.amarsoft.app.accounting.util.expression.functions.GetBalance");//获取关联对象金额信息，主要是针对分户账信息
		/**
		 * 获取两个日期之间的月数（向上取整），写法参见： ${GetUpMonths('${jbo.app.ACCT_LOAN.PutOutDate}','${jbo.app.ACCT_LOAN.MaturityDate}')}
		 *  参数一、起始日期
		 *  参数二、到期日期
		 */
		FunctionManager.regFunction("GetUpMonths","com.amarsoft.app.accounting.config.loader.DateFunctions","getUpMonths");//获取两个日期之间的月数（向上取整）
		/**
		 * 获取两个日期之间的月数（向下取整），写法参见： ${GetMonths('${jbo.app.ACCT_LOAN.PutOutDate}','${jbo.app.ACCT_LOAN.MaturityDate}')}
		 *  参数一、起始日期
		 *  参数二、到期日期
		 */
		FunctionManager.regFunction("GetMonths","com.amarsoft.app.accounting.config.loader.DateFunctions","getMonths");//获取两个日期之间的月数（向下取整）
		/**
		 * 获取两个日期之间的天数，写法参见： ${GetDays('${jbo.app.ACCT_LOAN.PutOutDate}','${jbo.app.ACCT_LOAN.MaturityDate}')}
		 *  参数一、起始日期
		 *  参数二、到期日期
		 */
		FunctionManager.regFunction("GetDays","com.amarsoft.app.accounting.config.loader.DateFunctions","getDays");//获取两个日期之间的天数（向下取整）
		
		
		File f = FileTool.findFile("function_config.xml"); 
		if(f==null) return;
		function_document = new Document(f);
		List l = function_document.getRootElement().getChildren("Function");
		for(Object o:l){
			Element e = (Element)o;
			String functionID = e.getAttributeValue("functionid");
			String className = e.getAttributeValue("class");
			String methodName = e.getAttributeValue("method");
			FunctionManager.regFunction(functionID,className,methodName);//获取两个日期之间的天数（向下取整）
		}
	}
	
	public static ITransactionScript getTransactionSript(String transactionCode,AbstractBusinessObjectManager bom) throws Exception{
		ITransactionScript scriptClass=null;
		ASValuePool transactionDef = TransactionConfig.getTransactionDef(transactionCode);
		String classname=transactionDef.getString("TransactionClass");
		if(classname!=null && !"".equals(classname)){
			Class<?> c = Class.forName(classname);
			scriptClass=((ITransactionScript)c.newInstance());
		}
		else scriptClass = new CommonTransaction();
		scriptClass.setBOManager(bom);
		return scriptClass;
	}


	
	
	public ASValuePool loadConfig(Transaction sqlca) throws Exception {
		return transactionDefSet;
	}
	
	/*
	 * 清空缓存对象
	 * @see com.amarsoft.dict.als.cache.AbstractCache#clear()
	 */
	public void clear() throws Exception {
		
	}
	

	/*
	 * 加载交易参数定义信息
	 * @see com.amarsoft.dict.als.cache.AbstractCache#load(com.amarsoft.awe.util.Transaction)
	 */
	public synchronized boolean load(Transaction transaction) throws Exception {
		try
		{
			File f=FileTool.findFile("accounting-transaction.xml"); 
			transaction_document = new Document(f);
			
			ASValuePool transactionDefSet = new ASValuePool();
			String sql = " select * from Code_Library where CodeNo = 'T_Transaction_Def' and IsInUse = '1' order by ItemNo";
			ASResultSet rs = transaction.getASResultSet(DataConvert.toString(sql));
			while(rs.next()){
				ASValuePool transactionDef=new ASValuePool();
				String transCode = rs.getString("ItemNo");
				transactionDef.setAttribute("TransCode", transCode);//交易编号
				transactionDef.setAttribute("TransName",rs.getString("ItemName"));//交易名称
				transactionDef.setAttribute("FlowNo",rs.getString("BankNo"));//适用流程
				
				transactionDef.setAttribute("ViewTempletNo", rs.getString("attribute1"));//交易详细信息模板
				transactionDef.setAttribute("Type", rs.getString("attribute2"));//交易种类
				transactionDef.setAttribute("StrikeTransID", rs.getString("attribute3"));//反交易编号
				transactionDef.setAttribute("JSFile", rs.getString("attribute4"));//java script脚本文件
				transactionDef.setAttribute("ObjectSelector",rs.getString("attribute5"));//业务对象选择器
				
				List l = transaction_document.getRootElement().getChildren("Accounting-Transaction");
				for(Object o:l){
					Element e = (Element)o;
					if(!transCode.equals(e.getAttributeValue("TransactionCode"))) continue;
					List el = e.getAttributeList();
					for(Object eo:el){
						Attribute a=(Attribute)eo;
						transactionDef.setAttribute(a.getName(),a.getValue());
					}
					transactionDef.setAttribute("XMLDocument", e);
					break;
				}
				
				ArrayList<ASValuePool> detailTemplete = new ArrayList<ASValuePool>();
				transactionDef.setAttribute("DetailTemplete", detailTemplete);
				transactionDefSet.setAttribute(rs.getString("ItemNo"),transactionDef);
			}
			rs.close();
					
			rs = transaction.getASResultSet(" select * from Trans_Entry where Status = '1' order by TransID,SortID ");
			while(rs.next()){
				String transcode=rs.getString("TransID");
				ASValuePool transactionDef =(ASValuePool) transactionDefSet.getAttribute(transcode);
				if(transactionDef==null) continue;
				ArrayList<ASValuePool> detailTempleteList=(ArrayList<ASValuePool>) transactionDef.getAttribute("DetailTemplete");
				ASValuePool businessObject=new ASValuePool();
				businessObject.setAttribute("TransCode",transcode);//交易码
				businessObject.setAttribute("SortID",rs.getString("SortID"));//顺序号
				businessObject.setAttribute("Direction",rs.getString("Direction"));//发生方向
				businessObject.setAttribute("AccountNoScript",rs.getString("AccountNoScript"));//LAS科目脚本
				businessObject.setAttribute("BookType", rs.getString("BookType"));//帐套
				businessObject.setAttribute("TransFlag",rs.getString("TransFlag"));//顺序号
				businessObject.setAttribute("ObjectType",rs.getString("ObjectType"));//关联业务对象，暂时不用
				businessObject.setAttribute("Description",rs.getString("Remark"));
				businessObject.setAttribute("AmtScript",rs.getString("SumScript"));//金额脚本
				businessObject.setAttribute("BooleanScript",rs.getString("BooleanScript"));//是否有效
				businessObject.setAttribute("CurrencyScript",rs.getString("CurrencyScript"));//币种脚本
				businessObject.setAttribute("OrgIDScript",rs.getString("OrgIDScript"));//机构脚本
				businessObject.setAttribute("AdversaryScript",rs.getString("AdversaryScript"));//交易对手，仅为了部分核心系统需要显示对手账户设置
				businessObject.setAttribute("ExchangeRateScript",rs.getString("ExchangeRateScript"));//汇率表达式
				
				businessObject.setAttribute("ExBookType", rs.getString("ExBookType"));//帐套
				//businessObject.setAttribute("GroupID", rs.getString("GroupID"));//组别
				
				detailTempleteList.add(businessObject);
			}
			rs.close();
			TransactionConfig.transactionDefSet = transactionDefSet;
			
			regFunctions();
	   return true;
		}catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
	}
}
