/***********************************************************************
 * Module:  ICreditLineKeeper.java
 * Author:  William
 * Modified: 2005.6.10 14:57:31
 * Purpose: Defines the Interface ICreditLineKeeper
 ***********************************************************************/

package com.amarsoft.app.creditline;

import java.util.Vector;

import com.amarsoft.awe.util.Transaction;

public interface ICreditLineKeeper
{
   /** @param Sqlca */
   double calcBalance(Transaction Sqlca) throws Exception;
   /** @param Sqlca 
     * @param BalanceID 
 * @throws Exception */
   double calcBalance(Transaction Sqlca, String BalanceID) throws Exception;
   /** @param Sqlca 
     * @param ObjectType 
     * @param ObjectNo */
   Vector check(Transaction Sqlca, String Options, String ObjectType, String ObjectNo) throws Exception;
   void setCreditLine(CreditLine cl);
}