/***********************************************************************
 * Module:  DefaultLimitationChecker.java
 * Author:  William
 * Modified: 2005.6.10 14:45:57
 * Purpose: Defines the Class DefaultLimitationChecker
 ***********************************************************************/

package com.amarsoft.app.creditline;

import java.util.StringTokenizer;
import java.util.Vector;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.are.ASException;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;

public class DefaultLimitationChecker extends LimitationChecker
{
   
	/** @param Sqlca 
	 * @throws Exception */
	public Vector check(Transaction Sqlca,String sObjectType,String sObjectNo) throws Exception{
		Any aReturn = null;
		String sReturn = null;
		Vector errors = new Vector(); 

    	String sExpression = (String) this.getLimitationSet().getType(Sqlca).getAttribute("LimitationExpr");
		if (sExpression == null){
			throw new ASException("没有取到额度限制检查公式。请检查限制类型定义"+this.getLimitationSet().getType(Sqlca).getAttribute("TypeID")+"（CL_LIMITATION_TYPE）");
		}
		try {
			String[][] sConstatnts = this.getLimitationSet().getCreditLine().getConstants();
			
			sExpression = StringFunction.replace(sExpression,"#ObjectType",sObjectType);
			sExpression = StringFunction.replace(sExpression,"#ObjectNo",sObjectNo);

			sExpression = StringFunction.replace(sExpression,"#LimitationSetID",(String)this.getLimitationSet().getAttribute("LimitationSetID"));

			sExpression = Expression.pretreatConstant(sExpression,sConstatnts);
			//sExpression = Expression.pretreatMethod(sExpression, Sqlca);
			aReturn = Expression.getExpressionValue(sExpression, Sqlca);
		} catch (Exception ex) {
			throw new ASException("额度限制检查公式解析错误。公式：" + sExpression+ex.getMessage());
		}
		try {
			sReturn = aReturn.toStringValue();
		} catch (Exception ex) {
			throw new ASException("额度限制检查返回值类型错误。公式：" + sExpression+ex.getMessage());
		}
		
		StringTokenizer st = new StringTokenizer(sReturn,";");
		while(st.hasMoreTokens()){
			String error = st.nextToken();
			if(error!=null && error.length()>0) errors.add(error);
		}
		return errors;
   }

}