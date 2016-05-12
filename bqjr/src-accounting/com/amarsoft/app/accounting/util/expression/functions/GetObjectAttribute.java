package com.amarsoft.app.accounting.util.expression.functions;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.util.expression.FunctionManager;
import com.amarsoft.app.accounting.util.expression.IFunction;
import com.amarsoft.are.util.ASValuePool;

public class GetObjectAttribute implements IFunction{
	
	private BusinessObject transaction;
	
	public void setObjectPara(String objectName,Object object){
		this.transaction = (BusinessObject) object;
	}

	public String run(ASValuePool functionDef, String paras) throws Exception {
		List[] paraList = FunctionManager.parseParas(paras);
		List paraValue = paraList[1];
		String objectType=(String)paraValue.get(0);
		String attributeID=(String)paraValue.get(1);
		
		if(objectType.equals(transaction.getObjectType())){
				return transaction.getString(attributeID);
		}
		else{
			ArrayList<BusinessObject> relativeObjectList = transaction.getRelativeObjects(objectType);
			if(relativeObjectList!=null&&!relativeObjectList.isEmpty()){
				if(relativeObjectList.size()==1){
					return relativeObjectList.get(0).getString(attributeID);
				}
				else{
					throw new Exception("找到多个业务对象{"+objectType+"}，此写法有问题！");
				}
			}
			else throw new Exception("未找到业务对象{"+objectType+"}");
		}
	}
}
