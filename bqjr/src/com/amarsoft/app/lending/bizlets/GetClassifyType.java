/*
 *	Author: jgao1 2009-10-26
 *	Tester:
 *	Describe: 根据五级分类参数表PARA_CONFIGURE取得五级分类的划分方式
 *	Input Param:
 *	Output Param:
 *			sClassifyType：五级分类划分方式
 *	HistoryLog:
 *
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetClassifyType extends Bizlet {
	public Object run(Transaction Sqlca) throws Exception {
		String sSql = "";
		String sClassifyType = "";
		//查询配置表中配置的五级分类是用借据还是合同，默认是用借据。
		sSql = " select para1 from PARA_CONFIGURE where ObjectType='Classify' and ObjectNo='100'"; 
		sClassifyType = Sqlca.getString(sSql);
		if(!sClassifyType.equals("BusinessDueBill") && !sClassifyType.equals("BusinessContract")){
			sClassifyType = "BusinessDueBill";
        }	
		return sClassifyType;
	}
}