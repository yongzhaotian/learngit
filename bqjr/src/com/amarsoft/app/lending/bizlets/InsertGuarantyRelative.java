package com.amarsoft.app.lending.bizlets;

/*
Author: --zywei 2006-01-12
Tester:
Describe: --申请、最终审批意见和合同中建立抵质押物与担保合同、业务合同之间的关联关系
		  --目前用于页面：ApplyImpawnInfo1、ApplyPawnInfo1、ApproveImpawnInfo1、
		  ApprovePawnInfo1、ContractImpawnInfo1、ContractPawnInfo1
Input Param:
		ObjectType：对象类型
		ObjectNo：对象编号
		ContractNo: 担保合同编号
		GuarantyID: 抵质押物编号
		Channel：数据来源（New：新增；Copy：拷贝）
Output Param:
		
HistoryLog:
*/

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InsertGuarantyRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		String sChannel = (String)this.getAttribute("Channel");
		String sType = (String)this.getAttribute("Type");
		
		//将空值转化为空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyID == null) sGuarantyID = "";	
		if(sChannel == null) sChannel = "";
		if(sType == null) sType = "";
				
		//定义变量		
		ASResultSet rs = null;//查询结果集
		String sSql = "";//Sql语句
		String sReturnFlag = "";//返回标志
		int iCount = 0;//记录数	
		SqlObject so;
		
		//验证关联关系是否已存在
		sSql = 	" select count(ObjectNo) from GUARANTY_RELATIVE "+
		" where ObjectType =:ObjectType "+
		" and ObjectNo =:ObjectNo "+
		" and ContractNo =:ContractNo "+
		" and GuarantyID =:GuarantyID ";
		so = new SqlObject(sSql);
		so.setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo)
		.setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
		rs = Sqlca.getASResultSet(so);
		if (rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		//如果不存在关联关系，则新建关联关系
		if(iCount < 1)
		{
			//建立抵质押物与担保合同、业务合同之间的管理关系
			//对象类型（合同：BusinessContract）、对象编号（合同编号）、担保合同编号、抵质押物编号、关联关系来源渠道（新增：New；拷贝：Copy）、有效标志（1：有效；2：无效）、数据来源类型（Add：新增；Import：引入）
			sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type)"+
			" values(:ObjectType,:ObjectNo,:ContractNo,:GuarantyID,:Channel,'1',:Type) ";
			so = new SqlObject(sSql);
			so.setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sContractNo)
			.setParameter("GuarantyID", sGuarantyID).setParameter("Channel", sChannel).setParameter("Type", sType);
	
			Sqlca.executeSQL(so);
			sReturnFlag = "1";//关联关系已经成功建立
		}else
		{
			sReturnFlag = "0";//关联关系已经存在，不需要再进行建立
		}
				
		return sReturnFlag;
	}		
}
