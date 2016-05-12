package com.amarsoft.app.accounting.trans.script.common.loader;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.ErrorCodeConfig;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionLoader;

public class TransactionLoader implements ITransactionLoader {
	
	@Override
	public BusinessObject load(String scriptID,ITransactionScript transactionScript)throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();

		String documentType = transaction.getString("DocumentType");
		String documentSerialNo = transaction.getString("DocumentSerialNo");
		if(documentType!=null&&documentType.length()>0&&documentSerialNo!=null&&documentSerialNo.length()>0){
			BusinessObject transactionDocument = transaction.getRelativeObject(documentType, documentSerialNo);
			if(transactionDocument==null){
				transactionDocument = boManager.loadObjectWithKey(documentType, documentSerialNo);
				if(transactionDocument==null) throw new Exception(ErrorCodeConfig.getMsg("E10010", new String[]{documentType,documentSerialNo}));
				transaction.setRelativeObject(transactionDocument);
			}
		}
		String relativeObjectType = transaction.getString("RelativeObjectType");
		String relativeObjectNo = transaction.getString("RelativeObjectNo");
		if(relativeObjectType!=null&&relativeObjectType.length()>0&&relativeObjectNo!=null&&relativeObjectNo.length()>0){
			BusinessObject relativeObject = transaction.getRelativeObject(relativeObjectType, relativeObjectNo);
			if(relativeObject==null){
				relativeObject = boManager.loadObjectWithKey(relativeObjectType, relativeObjectNo);
				if(relativeObject==null) throw new Exception(ErrorCodeConfig.getMsg("E10010", new String[]{relativeObjectType,relativeObjectNo}));
				transaction.setRelativeObject(relativeObject);
			}
		}
		return transaction;
	}
}
