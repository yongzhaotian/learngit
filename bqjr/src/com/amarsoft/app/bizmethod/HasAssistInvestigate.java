//CCS-381-PRM-95 安硕系统申请详情增加协审详情页面
//判断合同是否需要协审    add by awang 2015/02/26
package com.amarsoft.app.bizmethod;

import com.amarsoft.app.lending.bizlets.InitializeFlow;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class HasAssistInvestigate extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception
	 {			
			  return "true";
	 }
}
