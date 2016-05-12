package com.amarsoft.app.accounting.trans.script.loan.drawdown;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.product.ProductManage;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;

public class DraftDiscountScript implements ITransactionExecutor{


	//将预收利息放入费用自动扣收一次
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject businessPutout=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		List<BusinessObject> feeList=businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		BusinessObject fee=null;
		if(feeList==null||feeList.isEmpty()){
			fee = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee,boManager);
		}
		else fee=feeList.get(0);
		fee.setAttributeValue("ObjectType", businessPutout.getObjectType());
		fee.setAttributeValue("ObjectNo", businessPutout.getObjectNo());
		
		fee.setAttributeValue("Currency",businessPutout.getString("BusinessCurrency"));
		fee.setAttributeValue("AccountingOrgID", businessPutout.getString("OperateOrgID"));
		
		fee.setAttributeValue("FeeRate", businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment).get(0).getRate("BusinessRate"));
		
		ProductManage pm= new ProductManage(boManager);
		pm.initTermObject(fee, ProductConfig.getTerm("A400"));
		businessPutout.setRelativeObject(fee);
		
		pm.createTermObject("RPT05", businessPutout);
		
		return 1;
	}
}
