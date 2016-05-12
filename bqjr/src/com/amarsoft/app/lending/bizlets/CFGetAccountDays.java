package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * @author qfang 2011-6-15
 * @describe: ��ȡ����·�����Ӧ������
 * @input param:
 *			AccountMonth:����·�
 * @output param:
 * 			daysTotal:����
 * 			 			
 */
public class CFGetAccountDays extends Bizlet{

	public Object run(Transaction Sqlca)throws Exception{
		//��ȡ����·�
		String accountMonth = (String)this.getAttribute("AccountMonth");
		if(accountMonth.charAt(5) == '0'){
			accountMonth = accountMonth.substring(6);
		}else{
			accountMonth = accountMonth.substring(5, accountMonth.length()-1);
		}
		
		//�������
		int daysTotal = Integer.parseInt(accountMonth)*30;
		
		return String.valueOf(daysTotal);
	}

}
