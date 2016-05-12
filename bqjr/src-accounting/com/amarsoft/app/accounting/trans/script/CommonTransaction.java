package com.amarsoft.app.accounting.trans.script;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.TransactionConfig;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.app.accounting.trans.script.olinterface.OnlineInterfaceScript;

/**
 * 基础交易类
 *
 */
public class CommonTransaction implements ITransactionScript{
	public BusinessObject transaction;
	public AbstractBusinessObjectManager boManager;

	public BusinessObject getTransaction() {
		return transaction;
	}
	public void setTransaction(BusinessObject transaction) {
		this.transaction = transaction;
	}
	

	@Override
	public void setBOManager(AbstractBusinessObjectManager bom)
			throws Exception {
		this.boManager = bom;
	}
	@Override
	public AbstractBusinessObjectManager getBOManager() throws Exception {
		return boManager;
	}
	
	@Override
	public int run() throws Exception {
		String transCode = transaction.getString("TransCode");
		
		int i=1;
		int j=1;
		while(true){
			String scriptID = "ExecuteScript"+i;
			String classname = TransactionConfig.getScriptAttribute(transCode, scriptID, "class");
			if(classname!=null && !"".equals(classname)){
				Class<?> c = Class.forName(classname);
				ITransactionExecutor scriptClass=((ITransactionExecutor)c.newInstance());
				j = scriptClass.execute(scriptID,this);
				if(j!=1) return j;
			}
			else break;
			i++;
		}
		return 1;
	}

	@Override
	public int check() throws Exception {
		String transCode = transaction.getString("TransCode");
		
		int i=1;
		while(true){
			String classname = TransactionConfig.getScriptAttribute(transCode, "CheckScript"+i, "class");
			if(classname!=null && !"".equals(classname)){
				Class<?> c = Class.forName(classname);
				ITransactionChecker scriptClass=((ITransactionChecker)c.newInstance());
				scriptClass.check("CheckScript"+i,this);
			}
			else break;
			i++;
		}
		return 1;
		
	}
	
	@Override
	public int runOnlineInterface() throws Exception {
		String transCode = transaction.getString("TransCode");
		String documentSerialNo = transaction.getString("DocumentSerialNo");
		if(documentSerialNo==null||documentSerialNo.length()==0) return 1;//无单据信息
		BusinessObject document = transaction.getRelativeObject(transaction.getString("DocumentType"), documentSerialNo);
		
		String onlineAttributeID = TransactionConfig.getTransactionDef(transCode, "OnlineAttributeID");
		if(onlineAttributeID==null||onlineAttributeID.length()==0){
			onlineAttributeID = "CashOnlineFlag";
		}
		String onlineFlag = document.getString(onlineAttributeID);
		if(onlineFlag!=null&&onlineFlag.length()>0&&!onlineFlag.equals("1")) return 1;

		int i=1;
		while(true){
			
			String classname = TransactionConfig.getScriptAttribute(transCode, "OnlineInterfaceScript"+i, "class");
			if(classname!=null && !"".equals(classname)){
				Class<?> c = Class.forName(classname);
				OnlineInterfaceScript scriptClass=((OnlineInterfaceScript)c.newInstance());
				boolean res = scriptClass.run(transaction,boManager);
				if(!res){
					TransactionFunctions.setErrorMessage(transaction,"", "", scriptClass.getErrorMsg());
					return 0;
				}
			}
			else break;
			i++;
		}
		return 1;
	}
	
	@Override
	public BusinessObject init() throws Exception {
		String transCode = transaction.getString("TransCode");
		
		int i=1;
		while(true){
			String classname = TransactionConfig.getScriptAttribute(transCode, "InitScript"+i, "class");
			if(classname!=null && !"".equals(classname)){
				Class<?> c = Class.forName(classname);
				ITransactionCreator scriptClass=((ITransactionCreator)c.newInstance());
				scriptClass.init("InitScript"+i,this);
			}
			else break;
			i++;
		}
		return transaction;

	}

	@Override
	public BusinessObject load(BusinessObject transaction,AbstractBusinessObjectManager boManager) throws Exception {
		String transCode = transaction.getString("TransCode");
		
		int i=1;
		while(true){
			String classname = TransactionConfig.getScriptAttribute(transCode, "LoadScript"+i, "class");
			if(classname!=null && !"".equals(classname)){
				Class<?> c = Class.forName(classname);
				ITransactionLoader scriptClass=((ITransactionLoader)c.newInstance());
				scriptClass.load("LoadScript"+i,this);
			}
			else break;
			i++;
		}
		return transaction;
	}
	
}