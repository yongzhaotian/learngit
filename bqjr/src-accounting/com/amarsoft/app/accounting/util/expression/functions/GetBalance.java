package com.amarsoft.app.accounting.util.expression.functions;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.util.expression.FunctionManager;
import com.amarsoft.are.util.ASValuePool;

public class GetBalance extends GetRelativeObjectAttribute{
	
	public String run(ASValuePool functionDef,String paras) throws Exception {
		List[] paraList = FunctionManager.parseParas(paras);
		String s=this.getRelativeObjectAttribute(paraList[0], paraList[1]);
		if(s==null||s.equals("")) s="0";
		return s;
	}
	
}
