package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class CheckSaveFlag extends AlarmBiz
{
	public Object  run(Transaction Sqlca) throws Exception
	{		 
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//定义变量：提示信息、SQL语句、产品类型、客户类型
		String sSql = "";
		//定义变量：主要担保方式、客户代码、主体表名、关联表名
		String sTableName = "";
		//定义变量：暂存标志,是否低风险
		String sTempSaveFlag = "";
		//定义变量：发生类型、申请类型、担保人代码
		//定义变量：查询结果集
		ASResultSet rs = null;			
		
		//不同阶段在不同表中查询CustomerID
		if(sObjectType.equalsIgnoreCase("BusinessContract"))
		{
			sTableName = "BUSINESS_CONTRACT";
		}else if(sObjectType.equalsIgnoreCase("ApproveApply"))
		{
			sTableName = "BUSINESS_APPROVE";
		}else if(sObjectType.equalsIgnoreCase("CreditApply"))
		{
			sTableName = "BUSINESS_APPLY";
		}
		
		if (!sTableName.equals("")) {
			//--------------检查最终审批意见详情是否全部输入---------------
			//从相应的对象主体表中获取金额、产品类型、票据张数、担保类型
			sSql = 	" select TempSaveFlag from "+sTableName+" where SerialNo = :sObjectNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	 
				//将空值转化成空字符串
				if (!"2".equals(sTempSaveFlag)) {			
					putMsg("信息详情为暂存状态,请先填写完信息详情并点击保存按钮!");
				}
			}
			rs.getStatement().close();
		} 
		/* 返回结果处理  */
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
		

}
