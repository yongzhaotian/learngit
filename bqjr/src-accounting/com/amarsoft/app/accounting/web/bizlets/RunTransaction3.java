package com.amarsoft.app.accounting.web.bizlets;
/**
 * 2011-04-16
 * xjzhao 
 * 根据交易类型调用交易，此方法会同时生成一个新的交易记录
 */

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class RunTransaction3 extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		try
		{
			String objectType = (String)this.getAttribute("ObjectType");//单据类型
			String objectNo = (String)this.getAttribute("ObjectNo");//单据编号
			String userID = (String)this.getAttribute("UserID");//操作用户
			String transactionTermID = (String)this.getAttribute("TransactionTermID");//交易组件类别
			String transactionDate = (String)this.getAttribute("TransactionDate");//交易日期
			String relativeObjectType = (String)this.getAttribute("RelativeObjectType");//关联对象类型
			String relativeObjectNo = (String)this.getAttribute("RelativeObjectNo");//关联对象号码
			String productID = (String)this.getAttribute("ProductID");//
			String productVersion = (String)this.getAttribute("ProductVersion");//
			if(transactionDate==null)
			{
				transactionDate = SystemConfig.getBusinessDate();
			}
			if(productVersion==null||productVersion.length()==0) productVersion=ProductConfig.getProductNewestVersionID(productID);
			
			String transactionCode = ProductConfig.getProductTermParameterAttribute(productID, productVersion, transactionTermID, "TransactionCode", "DefaultValue");
			if(transactionCode==null||transactionCode.length()==0) 
				throw new Exception("该产品｛"+productID+"-"+productVersion+"｝未配置交易组件｛"+transactionTermID+"｝的参数｛TransactionCode｝的默认值！请确认该类业务是否可使用此功能！");
			
			BusinessObject documentObject = bom.loadObjectWithKey(objectType, objectNo);
			BusinessObject relativeObject =null;
			if(relativeObjectType!=null &&!"".equals(relativeObjectType) && relativeObjectNo!=null &&!"".equals(relativeObjectNo) )
				relativeObject = bom.loadObjectWithKey(relativeObjectType, relativeObjectNo);
			if(relativeObject==null) relativeObject = documentObject;
			//加载关联交易
			ASValuePool as =  new ASValuePool();
			as.setAttribute("DocumentType", objectType);
			as.setAttribute("DocumentSerialNo", objectNo);
			as.setAttribute("TransDate", transactionDate);
			List<BusinessObject> transactionList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.transaction, "DocumentType=:DocumentType and DocumentSerialNo=:DocumentSerialNo", as);
			BusinessObject transaction = null;
			if(transactionList == null || transactionList.isEmpty()){
				transaction = TransactionFunctions.createTransaction(transactionCode, documentObject, relativeObject, userID, transactionDate, bom);
				bom.updateDB();
				bom.commit();
			}
			else{
				transaction = transactionList.get(0);
			}
			transaction = TransactionFunctions.loadTransaction(transaction, bom);
			TransactionFunctions.runTransaction(transaction, bom);
			bom.updateDB();//先更新数据库，如果交易失败则回滚


			//int i=TransactionFunctions.runOnlineTransaction(transaction, bom);
			int i = 1;
			if(i==1){
				bom.updateDB();
				bom.commit();
				return "true@交易成功";
			}
			else{
				bom.rollback();
				List<String> a = TransactionFunctions.getErrorMessage(transaction, "");
				String messageError = a.toString();
				return "false@错误原因："+messageError;
			}
		}catch(Exception e)
		{
			bom.rollback();
			e.printStackTrace();
			ARE.getLog().debug("系统出错", e);
			return "false@"+e.getMessage();
		}
	}
}
