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
			throw new ASException("û��ȡ��������Ƽ�鹫ʽ�������������Ͷ���"+this.getLimitationSet().getType(Sqlca).getAttribute("TypeID")+"��CL_LIMITATION_TYPE��");
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
			throw new ASException("������Ƽ�鹫ʽ�������󡣹�ʽ��" + sExpression+ex.getMessage());
		}
		try {
			sReturn = aReturn.toStringValue();
		} catch (Exception ex) {
			throw new ASException("������Ƽ�鷵��ֵ���ʹ��󡣹�ʽ��" + sExpression+ex.getMessage());
		}
		
		StringTokenizer st = new StringTokenizer(sReturn,";");
		while(st.hasMoreTokens()){
			String error = st.nextToken();
			if(error!=null && error.length()>0) errors.add(error);
		}
		return errors;
   }

}