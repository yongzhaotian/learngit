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
					throw new Exception("�ҵ����ҵ�����{"+objectType+"}����д�������⣡");
				}
			}
			else throw new Exception("δ�ҵ�ҵ�����{"+objectType+"}");
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
				throw new Exception("�ҵ����ҵ�����{"+relativeObjectType+"}����д�������⣡");
			}
		}
		else return "";//throw new Exception("δ�ҵ�ҵ�����{"+relativeObjectType+"}");//���ܱ���Ӧ�÷��ؿ�ֵ����ҵ���߼��ж�
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
