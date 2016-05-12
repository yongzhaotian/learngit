package com.amarsoft.app.accounting.util.expression;

import com.amarsoft.are.util.ASValuePool;

public interface IFunction {
	public String run(ASValuePool functionDef,String paras) throws Exception;
	
	public void setObjectPara(String objectName,Object object) throws Exception;
	
}
