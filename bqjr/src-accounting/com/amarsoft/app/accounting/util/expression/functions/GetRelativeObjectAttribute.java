package com.amarsoft.app.accounting.util.expression.functions;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.util.expression.FunctionManager;
import com.amarsoft.app.accounting.util.expression.IFunction;
import com.amarsoft.are.util.ASValuePool;

public class GetRelativeObjectAttribute implements IFunction{
	
	protected BusinessObject transaction;
	
	protected String getRelativeObjectAttribute(List<Class> paraClass,List<Object> paraValue) throws Exception{
		String objectType=(String)paraValue.get(0);
		String relativeObjectType=(String)paraValue.get(1);
		String attributeID=(String)paraValue.get(2);
		
		BusinessObject businessObject=null;
		if(objectType.equals(transaction.getObjectType())){
				businessObject = transaction;
		}
		else{
			ArrayList<BusinessObject> relativeObjectList = transaction.getRelativeObjects(objectType);
			if(relativeObjectList!=null&&!relativeObjectList.isEmpty()){
				if(relativeObjectList.size()==1){
					businessObject=relativeObjectList.get(0);
				}
				else{
					throw new Exception("找到多个业务对象{"+objectType+"}，此写法有问题！");
				}
			}
			else throw new Exception("未找到业务对象{"+objectType+"}");
		}
		
		BusinessObject filter=new BusinessObject(new ASValuePool());
		for(int j=3;j<paraValue.size();j++){
			filter.setAttributeValue((String)paraValue.get(j), (String)paraValue.get(j+1));
			j++;
		}
		
		BusinessObject relativeObject=null;
		List<BusinessObject> relativeObjectList = businessObject.getRelativeObjects(relativeObjectType,filter);
		if(relativeObjectList!=null&&!relativeObjectList.isEmpty()){
			if(relativeObjectList.size()==1){
				relativeObject=relativeObjectList.get(0);
			}
			else{
				throw new Exception("找到多个业务对象{"+relativeObjectType+"}，此写法有问题！");
			}
		}
		else return "";//throw new Exception("未找到业务对象{"+relativeObjectType+"}");//不能报错，应该返回空值，由业务逻辑判断
		return relativeObject.getString(attributeID);
	}
	
	public void setObjectPara(String objectName,Object object){
		this.transaction = (BusinessObject) object;
	}

	public String run(ASValuePool functionDef, String paras) throws Exception {
		List[] paraList = FunctionManager.parseParas(paras);
		return this.getRelativeObjectAttribute(paraList[0], paraList[1]);
	}
}
