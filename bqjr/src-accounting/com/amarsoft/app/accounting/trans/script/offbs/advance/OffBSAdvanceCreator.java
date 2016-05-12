package com.amarsoft.app.accounting.trans.script.offbs.advance;

import com.amarsoft.amarscript.Any;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.product.ProductManage;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionCreator;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

public class OffBSAdvanceCreator implements ITransactionCreator {
	
	@Override
	public BusinessObject init(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject relativeObject = transaction.getRelativeObject(transaction.getString("DocumentType"),transaction.getString("DocumentSerialNo"));
		BusinessObject businessContract = relativeObject.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract, relativeObject.getString("RelativeSerialNo1"));
		if(businessContract==null){
			businessContract = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_contract,relativeObject.getString("RelativeSerialNo2"));
		}
		if(businessContract==null) throw new Exception("未找到表外业务对应的合同信息，创建垫款交易失败！");
		transaction.setRelativeObject(businessContract);
		
		
		createBusinessPutout(transaction,boManager);
		return transaction;
	}
	
	/**
	 * 根据出账信息生成表外业务信息
	 * @throws Exception
	 */
	private void createBusinessPutout(BusinessObject transaction,AbstractBusinessObjectManager boManager) throws Exception{
		BusinessObject bd = transaction.getRelativeObject(transaction.getString("RelativeObjectType"),transaction.getString("RelativeObjectNo"));
		BusinessObject bp = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_putout,boManager);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, bp);
		transaction.setAttributeValue("DocumentType", bp.getObjectType());
		transaction.setAttributeValue("DocumentSerialNo", bp.getObjectNo());
		transaction.setRelativeObject(bp);
		Item[] colMapping = CodeCache.getItems("BP_BC_Advance_ColumnsMapping");
		for (int i=0;i<colMapping.length;i++) {
			Item item=colMapping[i];
			String bdAttributeID=item.getItemNo();
			String objectType=item.getItemAttribute();
			String attributeID=item.getRelativeCode();
			if(objectType!=null&&objectType.length()>0){
				BusinessObject sourceObject=transaction.getRelativeObjects(objectType).get(0);
				bp.setAttributeValue(bdAttributeID, sourceObject.getObject(attributeID));
			}
			else{
				Any a = ExtendedFunctions.getScriptValue(attributeID,transaction,boManager.getSqlca());
				bp.setAttributeValue(bdAttributeID, a);
			}
		}
		//根据垫款组件配置的参数，获取垫款业务品种，恶心的做法
		String bdType =bd.getString("BusinessType");
		String productID = ProductConfig.getProductTermParameterAttribute(bdType, ProductConfig.getProductNewestVersionID(bdType), "TRA003", "AdvanceProductID", "DefaultValue");
		String productVersion =  ProductConfig.getProductNewestVersionID(productID);
		bp.setAttributeValue("BusinessType", productID);
		bp.setAttributeValue("ProductVersion", productVersion);
		bp.setAttributeValue("PutoutDate", bd.getString("Maturity"));
		
		ProductManage pm= new ProductManage(boManager);
		pm.createTermObject(bp);
	}
}
