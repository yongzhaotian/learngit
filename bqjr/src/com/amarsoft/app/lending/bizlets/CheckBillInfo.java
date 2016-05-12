/*
		Author: --jgao 2008-10-24
		Tester:
		Describe: --检查贴现业务是否有票据
		Input Param:
				ObjectNo:合同流水号
				BusinessType：业务品种
		Output Param:
				"00":表示没有票据
				"01":表示存在票据
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckBillInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{

		//获得合同流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//获得业务品种
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//将空值转化成空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";

		//定义变量：Sql语句
		String sSql = "";
		//定义变量：查询结果集
		ASResultSet rs = null;
		//定义返回变量
		String flag = "00";//"00"代表BILL_INFO里不存在这样的票据
	
		//当业务品种为银行承兑汇票贴现、商业承兑汇票贴现、协议付息票据贴现
		if(sBusinessType.equals("1020010") || sBusinessType.equals("1020020") || sBusinessType.equals("1020030"))
		{
			//贴现合同项下存在汇票信息
			sSql = 	" select * from BILL_INFO "+
					" where ObjectType = 'BusinessContract' "+
					" and ObjectNo = :ObjectNo "+
					" and BillNo not in "+
					" (select BillNo from BUSINESS_PUTOUT "+
					" where ContractSerialNo = :ContractSerialNo)";	
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ContractSerialNo", sObjectNo));
			if(rs.next()) flag = "01";//"01"代表BILL_INFO里存在这样的票据
			rs.getStatement().close();
		}
		return flag;
	}
		
}
