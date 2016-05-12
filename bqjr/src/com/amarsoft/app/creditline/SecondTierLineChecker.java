package com.amarsoft.app.creditline;

import java.util.Vector;

import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;

public class SecondTierLineChecker {

	public static ASValuePool check(Transaction Sqlca,String sLevel1LineID,String sLevel2LineID,String sObjectType,String sObjectNo) throws Exception{
		ASValuePool vpReturn = new ASValuePool();
		Vector errors1 = null;
		Vector errors2 = null;
		
		//第一步：计算第一层额度的合法性============================================
		
		CreditLine line1 = new CreditLine(Sqlca,sLevel2LineID);
		try
		{		
			//进入检查模式
			line1.enterCheckMode(Sqlca);
			//开始进行检查
			errors1 = line1.check(Sqlca,"LOG=Y",sObjectType,sObjectNo);
			if(errors1.size()>0) vpReturn.setAttribute("Level1Errors",errors1);

		}finally
		{
			//解除检查模式
			line1.exitCheckMode(Sqlca);
		}

		
		
		//第二步：计算第二层额度的合法性============================================
		
		CreditLine line2 = new CreditLine(Sqlca,sLevel2LineID);
		try
		{		
			//进入检查模式
			line2.enterCheckMode(Sqlca);
			//开始进行检查
			errors2 = line2.check(Sqlca,"LOG=Y",sObjectType,sObjectNo);
			if(errors2.size()>0) vpReturn.setAttribute("Level2Errors",errors2);
		    
		    
		}finally
		{
			//解除检查模式
			line2.exitCheckMode(Sqlca);
		}

		
		//第三步：记录结果 ============================================
		
		//如果没有错误，则在vpReturn中写入"PASS"，否则写入"FAIL"
		if(errors1.size()>0 && errors2.size()>0){
			vpReturn.setAttribute("OutCome","PASS");
		}else{
			vpReturn.setAttribute("OutCome","FAIL");
		}
		
		return vpReturn;
	}
}
