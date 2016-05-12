package com.amarsoft.app.creditline;

import java.util.Vector;

import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;

public class SecondTierLineChecker {

	public static ASValuePool check(Transaction Sqlca,String sLevel1LineID,String sLevel2LineID,String sObjectType,String sObjectNo) throws Exception{
		ASValuePool vpReturn = new ASValuePool();
		Vector errors1 = null;
		Vector errors2 = null;
		
		//��һ���������һ���ȵĺϷ���============================================
		
		CreditLine line1 = new CreditLine(Sqlca,sLevel2LineID);
		try
		{		
			//������ģʽ
			line1.enterCheckMode(Sqlca);
			//��ʼ���м��
			errors1 = line1.check(Sqlca,"LOG=Y",sObjectType,sObjectNo);
			if(errors1.size()>0) vpReturn.setAttribute("Level1Errors",errors1);

		}finally
		{
			//������ģʽ
			line1.exitCheckMode(Sqlca);
		}

		
		
		//�ڶ���������ڶ����ȵĺϷ���============================================
		
		CreditLine line2 = new CreditLine(Sqlca,sLevel2LineID);
		try
		{		
			//������ģʽ
			line2.enterCheckMode(Sqlca);
			//��ʼ���м��
			errors2 = line2.check(Sqlca,"LOG=Y",sObjectType,sObjectNo);
			if(errors2.size()>0) vpReturn.setAttribute("Level2Errors",errors2);
		    
		    
		}finally
		{
			//������ģʽ
			line2.exitCheckMode(Sqlca);
		}

		
		//����������¼��� ============================================
		
		//���û�д�������vpReturn��д��"PASS"������д��"FAIL"
		if(errors1.size()>0 && errors2.size()>0){
			vpReturn.setAttribute("OutCome","PASS");
		}else{
			vpReturn.setAttribute("OutCome","FAIL");
		}
		
		return vpReturn;
	}
}
