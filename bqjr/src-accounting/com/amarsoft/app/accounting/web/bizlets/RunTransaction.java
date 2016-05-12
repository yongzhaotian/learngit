package com.amarsoft.app.accounting.web.bizlets;
/**
 * 2011-04-16
 * xjzhao 
 * 根据单据信息调用交易，此方法会同时生成一个新的交易记录
 */

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class RunTransaction extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		try
		{
			String objectType = (String)this.getAttribute("ObjectType");//单据类型
			String objectNo = (String)this.getAttribute("ObjectNo");//单据编号
			String userID = (String)this.getAttribute("UserID");//操作用户
			String transactionCode = (String)this.getAttribute("TransactionCode");//交易代码
			String transactionDate = (String)this.getAttribute("TransactionDate");//交易日期
			String relativeObjectType = (String)this.getAttribute("RelativeObjectType");//关联对象类型
			String relativeObjectNo = (String)this.getAttribute("RelativeObjectNo");//关联对象号码
			
			BusinessObject documentObject = bom.loadObjectWithKey(objectType, objectNo);
			
			BusinessObject relativeObject =null;
			if(relativeObjectType!=null &&!"".equals(relativeObjectType) && relativeObjectNo!=null &&!"".equals(relativeObjectNo) )
				relativeObject = bom.loadObjectWithKey(relativeObjectType, relativeObjectNo);
			if(relativeObject==null) relativeObject = documentObject;
			BusinessObject transaction = TransactionFunctions.createTransaction(transactionCode, documentObject, relativeObject, userID, transactionDate, bom);

			transaction = TransactionFunctions.loadTransaction(transaction, bom);
			TransactionFunctions.runTransaction(transaction, bom);
			bom.updateDB();//先更新数据库，如果交易失败则回滚

			int i=TransactionFunctions.runOnlineTransaction(transaction, bom);
			if(i==1){
				bom.commit();
				return "true";
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
