/***********************************************************************
 * Module:  LimitationSet.java
 * Author:  William
 * Modified: 2005.6.10 14:35:26
 * Purpose: Defines the Class LimitationSet
 ***********************************************************************/

package com.amarsoft.app.creditline;

import com.amarsoft.app.creditline.model.LimitationType;
import com.amarsoft.are.ASException;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;

public class LimitationSet {
	public ASValuePool attributes = new ASValuePool();

	private LimitationType type;
	private CreditLine line;
	private ILimitationChecker checker;
   
	public LimitationSet(CreditLine creditLine) {
		this.line = creditLine;
	}
   
	public CreditLine getCreditLine() {
		return this.line;
	}

	public Object getAttribute(String sKey) throws Exception {
		return this.attributes.getAttribute(sKey);
	}
   
	/** @param obj */
	public void setAttribute(String sKey, Object obj) throws Exception {
		this.attributes.setAttribute(sKey, obj);
	}
	
	public LimitationType getType(Transaction Sqlca) throws Exception{
		if(this.type!=null) return this.type;
		String sLimitationType = (String)this.getAttribute("LimitationType");
		this.type = CreditLineManager.getLimitationType(sLimitationType);
		return this.type;
	}
   
	public ILimitationChecker getChecker(Transaction Sqlca) throws Exception {
		if (this.checker == null) {
            String sClassName = null;
            sClassName = (String) this.getType(Sqlca).getAttribute("CheckerClass");
            if (sClassName == null || sClassName.equals("")) {
                //缺省使用DefaultCreditLinechecker
                this.checker = new DefaultLimitationChecker();
            }else{
                //否则动态装载指定的类
                try {
                    Class tClass = Class.forName(sClassName);
                    this.checker = (ILimitationChecker) tClass.newInstance();
                }catch(Exception ex) {
                    throw new ASException("类[" + sClassName + "]装载失败："+ ex.getMessage());
                }
            }
            this.checker.setLimitationSet(this);
        }
        return checker;
   }

}