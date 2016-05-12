/***********************************************************************
 * Module:  DefaultCreditLineComputer.java
 * Author:  William
 * Modified: 2005.6.10 14:02:04
 * Purpose: Defines the Class DefaultCreditLineComputer
 ***********************************************************************/

package com.amarsoft.app.creditline;

import java.lang.reflect.Method;
import java.util.StringTokenizer;
import java.util.Vector;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.app.creditline.model.CreditLineType;
import com.amarsoft.are.ASException;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;

public class DefaultCreditLineKeeper extends CreditLineKeeper {

	/* (non-Javadoc)
     * @see com.amarsoft.app.creditline.ICreditLineKeeper#calcBalance(null, java.lang.String)
     */
    public double calcBalance(Transaction Sqlca, String sBalanceID)throws Exception{
        double dBalance = 0;//余额
        Any aReturn = null;
        String sExpression = "";
        try{
        	CreditLineType clType = this.getCreditLine().getType(Sqlca);
        	String m = "get" + sBalanceID.substring(0, 1).toUpperCase() + sBalanceID.substring(1);
			try {
				Method method = CreditLineType.class.getMethod(m);
				sExpression = (String)method.invoke(clType);
				if(sExpression==null) throw new ASException("没有取到额度计算公式。额度编号："+this.getCreditLine().id()+",字段："+sBalanceID+"。请检查额度类型定义（CL_TYPE）");
				
				try{
			        sExpression = Expression.pretreatConstant(sExpression,this.getCreditLine().getConstants());
			        //sExpression = Expression.pretreatMethod(sExpression,Sqlca);
			        aReturn = Expression.getExpressionValue(sExpression,Sqlca);
		        }catch(Exception ex){
		        	throw new ASException("额度计算公式解析错误。公式："+sExpression+ex.getMessage());
		        }
			} catch (NoSuchMethodException e) {
				throw new ASException(sBalanceID + " is Not Exist!");
			}
	        
	        try{
	        	dBalance = aReturn.doubleValue();
	        }catch(Exception ex){
	        	throw new ASException("额度计算公式返回值类型错误。公式："+sExpression);
	        }
        }catch(Exception ex){
        	throw new ASException("计算额度余额时出错："+ex.getMessage());
        }
	    return dBalance;
    }
    /* (non-Javadoc)
     * @see com.amarsoft.app.creditline.ICreditLineKeeper#calcBalance(null)
     */
    public double calcBalance(Transaction Sqlca) throws Exception{
    	return calcBalance(Sqlca,"LineSum1");
    }
    /* (non-Javadoc)
     * @see com.amarsoft.app.creditline.CreditLineKeeper#calcUsed(com.amarsoft.are.sql.Transaction)
     */
    
    public Vector checkLine(Transaction Sqlca,String sObjectType,String sObjectNo) throws Exception{
		Any aReturn = null;
		String sReturn = null;

    	String sExpression = (String) this.getCreditLine().getType(Sqlca).getCheckExpr();
		if (sExpression == null)
			throw new ASException("没有取到额度合法性检查公式。额度编号："+ this.getCreditLine().id()+ ",字段：CheckExpr。请检查额度类型定义（CL_TYPE）");
		try {
			sExpression = StringFunction.replace(sExpression,"#ObjectType",sObjectType);
			sExpression = StringFunction.replace(sExpression,"#ObjectNo",sObjectNo);
			
			sExpression = Expression.pretreatConstant(sExpression, this.getCreditLine().getConstants());
			//sExpression = Expression.pretreatMethod(sExpression, Sqlca);
			aReturn = Expression.getExpressionValue(sExpression, Sqlca);
		} catch (Exception ex) {
			throw new ASException("额度合法性检查公式解析错误。公式：" + sExpression + ex.getMessage());
		}
		try {
			sReturn = aReturn.toStringValue();
		} catch (Exception ex) {
			throw new ASException("额度合法性检查返回值类型错误。返回值类型:"+aReturn.getType() + ex.getMessage());
		}
		
		Vector errors = new Vector();
		StringTokenizer st = new StringTokenizer(sReturn,"@");
		while(st.hasMoreElements()){
			String sError = st.nextToken();
			errors.add(sError);
		}
		
		return errors;
    	
    }
	public Vector checkLimitations(Transaction Sqlca,String sObjectType,String sObjectNo) throws Exception {
		Vector errors = new Vector();
		if (this.getCreditLine().getLimitationSets() == null) {
			return errors;
		}
        for(int i=0;i<this.getCreditLine().getLimitationSets().length;i++){
        	LimitationSet limitationSet = this.getCreditLine().getLimitationSets()[i];
        	Vector tmpError = limitationSet.getChecker(Sqlca).check(Sqlca,sObjectType,sObjectNo);
        	for(int j=0;j<tmpError.size();j++){
        		String sError = (String)tmpError.get(j);
        		if(sError!=null && !sError.equalsIgnoreCase("Null") && sError.length()>0) errors.add(sError);
        	}
        }
        return errors;
	}
}