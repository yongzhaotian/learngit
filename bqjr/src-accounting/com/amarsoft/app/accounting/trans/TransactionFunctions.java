package com.amarsoft.app.accounting.trans;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.ErrorCodeConfig;
import com.amarsoft.app.accounting.config.loader.TransactionConfig;
import com.amarsoft.app.accounting.exception.ErrorMessage;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.context.ASUser;

public class TransactionFunctions {

	public static BusinessObject loadTransaction(String transactionSerialNo,AbstractBusinessObjectManager bom) throws Exception{
		BusinessObject transaction = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction,transactionSerialNo);
		if(transaction == null) throw new Exception("未找到交易{"+transactionSerialNo+"}");
		return loadTransaction(transaction,bom);
	}
	
	public static BusinessObject loadTransaction(BusinessObject transaction,AbstractBusinessObjectManager bom) throws Exception{
		ITransactionScript script = TransactionConfig.getTransactionSript(transaction.getString("TransCode"), bom);
		script.setTransaction(transaction);
		transaction = script.load(transaction, bom);
		return transaction;
	}
	
	public static BusinessObject createTransaction(String transactionCode,BusinessObject documentObject, BusinessObject relativeObject,	String userID, String transactionDate,
			AbstractBusinessObjectManager boManager) throws Exception {

		ASValuePool transactionDef = TransactionConfig.getTransactionDef(transactionCode);
		BusinessObject transaction = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.transaction,boManager);
		transaction.setAttributeValue("TransCode", transactionCode);
		transaction.setAttributeValue("TransName", transactionDef.getString("TransName"));
		transaction.setAttributeValue("TransStatus","0");
		transaction.setAttributeValue("OccurDate",SystemConfig.getSystemDate());
		transaction.setAttributeValue("OccurTime",StringFunction.getNow());
		transaction.setAttributeValue("InputTime",SystemConfig.getSystemDate()+" "+StringFunction.getNow());
		if(transactionDate!=null&&transactionDate.length()>0){
			transaction.setAttributeValue("TransDate", transactionDate);
		}
		else{
			transaction.setAttributeValue("TransDate",SystemConfig.getBusinessDate());
		}
		
		transaction.setAttributeValue("InputUserID", userID);
		if(userID!=null && userID.length()>0&&!userID.equalsIgnoreCase("system")){
			try{
				ASUser user = ASUser.getUser(userID,boManager.getSqlca());
				String orgid = user.getOrgID();
				transaction.setAttributeValue("InputOrgID", orgid);
			}catch(Exception e){
				
			}
		}
		
		if(relativeObject!=null){// throw new Exception("创建交易时传入的关联对象为空！");
			transaction.setAttributeValue("RelativeObjectType", relativeObject.getObjectType());
			transaction.setAttributeValue("RelativeObjectNo", relativeObject.getObjectNo());
			transaction.setRelativeObject(relativeObject);
		}
		
		//创建交易单据
		String documentType = transactionDef.getString("DocumentType");
		if(documentType==null||documentType.length()==0)
			throw new Exception(ErrorCodeConfig.getMsg("E10012", new String[]{transactionCode}));
		else if(documentType.equals("-")) {
			documentObject=null;//交易不需要单据，如计提等交易
		}
		else{//如果需要单据
			if(documentObject==null){
				documentObject = new BusinessObject(documentType,boManager);
				transaction.setRelativeObject(documentObject);
				transaction.setAttributeValue("DocumentType", documentObject.getObjectType());
				transaction.setAttributeValue("DocumentSerialNo", documentObject.getObjectNo());
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, documentObject);
			}
			else if(!documentType.equals(documentObject.getObjectType()))throw new Exception(ErrorCodeConfig.getMsg("E10013", null));
			else{
				transaction.setRelativeObject(documentObject);
				transaction.setAttributeValue("DocumentType", documentObject.getObjectType());
				transaction.setAttributeValue("DocumentSerialNo", documentObject.getObjectNo());
			}
		}
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, transaction);
		
		ITransactionScript script = TransactionConfig.getTransactionSript(transaction.getString("TransCode"), boManager);
		script.setTransaction(transaction);
		transaction = script.init();
		
		return transaction;
	}

	public static int runTransaction(BusinessObject transaction,AbstractBusinessObjectManager bom) throws Exception{
		ITransactionScript script = TransactionConfig.getTransactionSript(transaction.getString("TransCode"), bom);
		script.setTransaction(transaction);
		script.check();
		script.run();
		return 1;
	}
	
	
	public static int runOnlineTransaction(BusinessObject transaction,AbstractBusinessObjectManager bom) throws Exception{
		ITransactionScript script = TransactionConfig.getTransactionSript(transaction.getString("TransCode"), bom);
		script.setTransaction(transaction);
		return script.runOnlineInterface();
	}

	public static void setErrorMessage(BusinessObject transaction,String type,String messagecode,String messagedesc) throws Exception{
		Object o = transaction.getObject("ErrorMessage");
		ErrorMessage e=null;
		if(o==null){
			e=new ErrorMessage();
			transaction.setAttributeValue("ErrorMessage", e);
		}
		else{
			e=(ErrorMessage)o;
		}
		e.setErrorMessage(type, messagecode, messagedesc);
	}
	
	public static List<String> getErrorMessage(BusinessObject transaction,String type) throws Exception{
		Object o = transaction.getObject("ErrorMessage");
		ErrorMessage e=null;
		if(o==null){
			e=new ErrorMessage();
		}
		else{
			e=(ErrorMessage)o;
		}
		return e.getMessage(type);
	}
}
