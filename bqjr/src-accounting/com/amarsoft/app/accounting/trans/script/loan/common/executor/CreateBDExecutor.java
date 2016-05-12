package com.amarsoft.app.accounting.trans.script.loan.common.executor;

import com.amarsoft.amarscript.Any;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * @author xjzhao 2011/04/02
 * 垫款交易
 */
public class CreateBDExecutor implements ITransactionExecutor{
	
	/**
	 * 进行数据处理
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject bd = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_duebill,boManager);
		Item[] colMapping = CodeCache.getItems("BD_Loan_ColumnsMapping1");
		for (int i=0;i<colMapping.length;i++) {
			Item item=colMapping[i];
			String bdAttributeID=item.getItemNo();
			String objectType=item.getItemAttribute();
			String attributeID=item.getRelativeCode();
			if(objectType!=null&&objectType.length()>0){
				BusinessObject sourceObject=transaction.getRelativeObjects(objectType).get(0);
				bd.setAttributeValue(bdAttributeID, sourceObject.getObject(attributeID));
			}
			else{
				Any a = ExtendedFunctions.getScriptValue(attributeID,transaction,boManager.getSqlca());
				bd.setAttributeValue(bdAttributeID, a);
			}
		}

		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, bd);
		transaction.setRelativeObject(bd);
		
		return 1;
	}
	
}
