package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * @author qfang 2011-6-15
 * @describe: 获取会计月份所对应的天数
 * @input param:
 *			AccountMonth:会计月份
 * @output param:
 * 			daysTotal:天数
 * 			 			
 */
public class CFGetAccountDays extends Bizlet{

	public Object run(Transaction Sqlca)throws Exception{
		//获取会计月份
		String accountMonth = (String)this.getAttribute("AccountMonth");
		if(accountMonth.charAt(5) == '0'){
			accountMonth = accountMonth.substring(6);
		}else{
			accountMonth = accountMonth.substring(5, accountMonth.length()-1);
		}
		
		//定义变量
		int daysTotal = Integer.parseInt(accountMonth)*30;
		
		return String.valueOf(daysTotal);
	}

}
