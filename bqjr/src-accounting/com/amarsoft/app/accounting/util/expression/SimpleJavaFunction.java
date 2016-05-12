package com.amarsoft.app.accounting.util.expression;

import java.lang.reflect.Method;
import java.util.List;

import com.amarsoft.are.util.ASValuePool;

public class SimpleJavaFunction  implements IFunction{
	
	public String run(ASValuePool functionDef,String paras) throws Exception {
		String className=functionDef.getString("ClassName");
		String methodName=functionDef.getString("MethodName");
		
		List[] paraList = FunctionManager.parseParas(paras);
		 Class[] cl=null;
		 Object[] args=null;
		if(paraList[0]!=null&&!paraList[0].isEmpty()){
			args=paraList[1].toArray();
		
			cl=new Class[paraList[0].size()];
			int i=0;
			for(Object o:paraList[0]){
				cl[i]=(Class)paraList[0].get(i);
				i++;
			}
		}
		
		Class c = Class.forName(className);
		Object obj=c.newInstance();
		Method meth = c.getMethod(methodName, cl); 
	
		Object o = meth.invoke(obj, args);
		if(o==null)return "";
		else return o.toString();
	}

	public void setObjectPara(String objectName, Object object)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

}
