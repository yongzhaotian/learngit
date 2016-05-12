package com.amarsoft.app.accounting.web.bizlets;
/**
 * ygwang
 * 创建一个交易
 */

import com.amarsoft.app.accounting.util.FeeFunctions;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;

public class CreateFee extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String objectType = (String)this.getAttribute("ObjectType");//单据类型
		String objectNo = (String)this.getAttribute("ObjectNo");//单据编号
		String userID = (String)this.getAttribute("UserID");//操作用户
		String feeTermID = (String)this.getAttribute("FeeTermID");//交易代码
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		
		BusinessObject relativeObject=null;
		if(objectNo.length()>0&&objectType.length()>0){
			relativeObject = bom.loadObjectWithKey(objectType, objectNo);
			if(relativeObject==null) throw new Exception("未找到对象{"+objectType+"-"+objectNo+"}");
		}
		else{
			 throw new Exception("未传入对象类型和对象编号!");
		}
		BusinessObject fee = FeeFunctions.createFee(feeTermID, relativeObject,bom);
		bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, fee);
		bom.updateDB();
		return fee.getString("SerialNo");
	}
}
