/***********************************************************************
 * Module:  DefaultLimitationChecker.java
 * Author:  William
 * Modified: 2005.6.10 14:45:57
 * Purpose: Defines the Class DefaultLimitationChecker
 ***********************************************************************/

package com.amarsoft.app.creditline;

import java.util.Vector;

import com.amarsoft.awe.util.Transaction;

public abstract class LimitationChecker implements ILimitationChecker
{
	private LimitationSet limitationSet;
	public final void setLimitationSet(LimitationSet limset){
		this.limitationSet = limset;
	}
	public final LimitationSet getLimitationSet(){
		return this.limitationSet;
	}
  
	/** @param Sqlca 
	 * @throws Exception */
	public abstract Vector check(Transaction Sqlca,String sObjectType,String sObjectNo) throws Exception;

}