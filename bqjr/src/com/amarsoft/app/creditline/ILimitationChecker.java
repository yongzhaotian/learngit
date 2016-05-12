/***********************************************************************
 * Module:  ILimitationChecker.java
 * Author:  William
 * Modified: 2005.6.10 8:43:20
 * Purpose: Defines the Interface ILimitationChecker
 ***********************************************************************/

package com.amarsoft.app.creditline;

import java.util.Vector;

import com.amarsoft.awe.util.Transaction;

public interface ILimitationChecker
{
	/** @param Sqlca 
	 * @throws Exception */
   Vector check(Transaction Sqlca,String sObjectType,String sObjectNo) throws Exception;
   
   public void setLimitationSet(LimitationSet limset);
   public LimitationSet getLimitationSet();
   
}