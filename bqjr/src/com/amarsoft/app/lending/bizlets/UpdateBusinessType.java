/*
		Author: --wqchen 2010-03-22
		Tester:
		Describe: --合同补登数据处理
		Input Param:
				ObjectNo: 合同编号
				BusinessType: 业务类型
		Output Param:
		
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateBusinessType extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//获得合同号
		String sObjectNo = (String)this.getAttribute("ObjectNo");//合同编号
		//
		String sBusinessType = (String)this.getAttribute("BusinessType");
		
		SqlObject so; //声明对象
		//将空值转化成空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		
		//定义变量
		String sSql = "";
		sSql = "update BUSINESS_CONTRACT set BusinessType =:BusinessType, " +
			   "InputDate =:InputDate," +
			   "UpdateDate =:UpdateDate," +
			   "PigeonholeDate =:PigeonholeDate " +
			   "where SerialNo =:SerialNo ";
		so = new SqlObject(sSql).setParameter("BusinessType", sBusinessType).setParameter("InputDate", StringFunction.getToday())
		.setParameter("UpdateDate", StringFunction.getToday()).setParameter("PigeonholeDate", StringFunction.getToday())
		.setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		
		//修改业务品种以后,更新BC的暂存标志为'1',防止出现业务品种和合同基本信息要素不一致的情况
		String sSql1 = "";
		sSql1 = "update BUSINESS_CONTRACT set TempSaveFlag = '1' "+   
				"where SerialNo =:SerialNo ";	
		so = new SqlObject(sSql1).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		return "Success";
	}

}
