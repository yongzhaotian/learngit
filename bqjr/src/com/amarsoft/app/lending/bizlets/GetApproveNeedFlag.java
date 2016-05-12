/*
		Author: --wqchen 2010/03/24
		Tester:
		Describe: --判断是否显示最终审批意见Tab页面
		Input Param:
					
		Output Param:
					sReturn  
		HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetApproveNeedFlag extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		String sReturn = "";
		//获取配置文件的参数
		Configure CurConfig = Configure.getInstance();
		String sApproveNeed = (String)CurConfig.getConfigure("ApproveNeed");
		if(sApproveNeed.equals("true")){
			sReturn = "true"; 
		}else{
			sReturn = "false";
		}
		return sReturn;
	}
}
