package com.amarsoft.app.accounting.trans.script.common.executor;

import java.util.Date;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;

public class UpdateTransactionExecutor implements ITransactionExecutor {
	private ITransactionScript transactionScript;

	@Override
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		this.transactionScript=transactionScript;
		
		BusinessObject transaction = this.transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = this.transactionScript.getBOManager();

		
		//交易日期
		String transDate=transaction.getString("TransDate");
		if(transDate==null||transDate.length()==0) {
			transaction.setAttributeValue("TransDate",SystemConfig.getBusinessDate());
		}
		//发生日期
		transaction.setAttributeValue("OccurDate",SystemConfig.getSystemDate());
		transaction.setAttributeValue("OccurTime",DateFunctions.getDateTime(new Date(),"HH:mm:ss"));
		
		//判断交易状态，为0才允许记账
		transaction.setAttributeValue("TransStatus","1");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, transaction);
		return 1;
	}
	
}
