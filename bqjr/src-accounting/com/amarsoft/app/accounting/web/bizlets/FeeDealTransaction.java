package com.amarsoft.app.accounting.web.bizlets;
/**
 * 2013-05-06
 * xjzhao 
 * 处理“关联交易前手工一次性收取”的费用
 */

import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;

public class FeeDealTransaction extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		try
		{
			String feeSerialNo = (String)this.getAttribute("FeeSerialNo");//费用编号
			String objectType = (String)this.getAttribute("ObjectType");//费用所属对象
			String objectNo = (String)this.getAttribute("ObjectNo");//费用所属对象
			String dealReturn="";
			
			AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
			if(feeSerialNo == null || "".equals(feeSerialNo))
			{
				if(objectType==null || "".equals(objectType) || objectNo == null || "".equals(objectNo))
				{
					throw new Exception("费用编号和费用所属对象不能同时为空，请检查！");
				}
				ASValuePool as = new ASValuePool();
				as.setAttribute("ObjectType", objectType);
				as.setAttribute("ObjectNo", objectNo);
				as.setAttribute("Status", "0");
				List<BusinessObject> boList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status", as);
				if(boList.isEmpty()) return "未找到满足条件的费用，请检查！";
				for(BusinessObject bo:boList)
				{
					//关联交易前手工一次性收取\手工一次性收取
					if("02".equals(bo.getString("FeePayDateFlag")) || "03".equals(bo.getString("FeePayDateFlag")))
					{
						dealReturn+=dealFee(bo,Sqlca)+"\r\n";
					}
				}
			}
			else
			{
				BusinessObject bo = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.fee, feeSerialNo);
				if(bo == null) return "未找到满足条件的费用，请检查！";
				if("02".equals(bo.getString("FeePayDateFlag")) || "03".equals(bo.getString("FeePayDateFlag")))
					dealReturn+=dealFee(bo,Sqlca);
				else
					return "手工收取的费用才能使用该功能！";
			}
			return dealReturn;
		}catch(Exception e)
		{
			e.printStackTrace();
			ARE.getLog().debug("系统出错", e);
			return e.getMessage();
		}
	}
	
	private String dealFee(BusinessObject bo,Transaction Sqlca) throws Exception{
		String userID = (String)this.getAttribute("UserID");//操作用户
		String transactionCode = (String)this.getAttribute("TransactionCode");//交易代码
		String transactionDate = (String)this.getAttribute("TransactionDate");//交易日期
		String transactionCodeName = CodeCache.getItemName("T_Transaction_Def", transactionCode);
		CreateTransaction ct = new CreateTransaction();
		ct.setAttribute("RelativeObjectType", bo.getObjectType());
		ct.setAttribute("RelativeObjectNo", bo.getObjectNo());
		ct.setAttribute("UserID", userID);
		ct.setAttribute("TransactionCode", transactionCode);
		ct.setAttribute("TransactionDate", transactionDate);
		ct.setAttribute("FlowFlag", "2");
		String s = (String)ct.run(Sqlca);
		if(s==null || "".equals(s) || s.startsWith("false") || s.indexOf("@")<0) return "费用编号为【"+bo.getObjectNo()+"】创建交易【"+transactionCodeName+"】时出错！";
		
		String transactionSerialNo = s.split("@")[1];
		RunTransaction2 rt2=new RunTransaction2();
		rt2.setAttribute("TransactionSerialNo", transactionSerialNo);
		rt2.setAttribute("UserID", userID);
		rt2.setAttribute("Flag", "Y");
		String r=(String)rt2.run(Sqlca);
		if(r==null || "".equals(s)) return "费用编号为【"+bo.getObjectNo()+"】执行交易【"+transactionCodeName+"】时出错！";
		if(r.startsWith("false")) return r.split("@")[1];
		if(r.equals("true")) return "费用编号为【"+bo.getObjectNo()+"】执行交易【"+transactionCodeName+"】成功！";
		return "";
	}
	
}
