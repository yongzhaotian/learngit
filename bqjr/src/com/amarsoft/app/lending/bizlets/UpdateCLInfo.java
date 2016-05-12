package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateCLInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//对象类型	
	 	String sObjectType = (String)this.getAttribute("ObjectType");
		//对象编号
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//授信金额
		String sBusinessSum = (String)this.getAttribute("BusinessSum");
		//授信币种
		String sBusinessCurrency = (String)this.getAttribute("BusinessCurrency");
		//额度使用最迟日期
		String sLimitationTerm = (String)this.getAttribute("LimitationTerm");
		//额度生效日
		String sBeginDate = (String)this.getAttribute("BeginDate");
		//起始日
		String sPutOutDate = (String)this.getAttribute("PutOutDate");
		//到期日
		String sMaturity = (String)this.getAttribute("Maturity");
		//额度项下业务最迟到期日期
		String sUseTerm = (String)this.getAttribute("UseTerm");
		//额度是否循环
		String sRotative = (String)this.getAttribute("Rotative");
		
		//将空值转化为空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessSum == null || sBusinessSum.equals("")||sBusinessSum.equalsIgnoreCase("null")) sBusinessSum = "0";
	    if(sBusinessCurrency == null) sBusinessCurrency = "";
	    if(sLimitationTerm == null) sLimitationTerm = "";
	    if(sBeginDate == null) sBeginDate = "";
	    if(sPutOutDate == null) sPutOutDate = "";
	    if(sMaturity == null) sMaturity = "";
	    if(sUseTerm == null) sUseTerm = "";
	    if(sRotative == null) sRotative = "";
	    SqlObject so; //声明对象
	   	    
		//定义变量
		String sSql = "";
		
		//根据对象类型更新授信额度信息
		if(sObjectType.equals("CreditApply")){
			sSql = " update CL_INFO set LineSum1 =:LineSum1 ,Currency=:Currency ,Rotative=:Rotative"+
        	   " where ApplySerialNo =:ApplySerialNo and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
			so = new SqlObject(sSql).setParameter("LineSum1", sBusinessSum).setParameter("Currency", sBusinessCurrency).setParameter("Rotative", sRotative)
			.setParameter("ApplySerialNo", sObjectNo);
			Sqlca.executeSQL(so);
		}
		if(sObjectType.equals("ApproveApply")){
			sSql = " update CL_INFO set LineSum1 =:LineSum1,Currency=:Currency "+
        	   " where ApproveSerialNo =:ApproveSerialNo and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
			so = new SqlObject(sSql).setParameter("LineSum1", sBusinessSum).setParameter("Currency", sBusinessCurrency)
			.setParameter("ApproveSerialNo", sObjectNo);
			Sqlca.executeSQL(so);
		}
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("ReinforceContract")){//增加对补登额度的操作 jschen 20100317
			sSql = " update CL_INFO set LineSum1 =:LineSum1,Currency=:Currency, "+
        	   		" PutOutDeadLine =:PutOutDeadLine,LineEffDate =:LineEffDate, "+
        	   		" BeginDate =:BeginDate,EndDate =:EndDate,MaturityDeadLine =:MaturityDeadLine "+
        	   		" where BCSerialNo =:BCSerialNo and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
		so = new SqlObject(sSql);
		so.setParameter("LineSum1", sBusinessSum).setParameter("Currency", sBusinessCurrency).setParameter("PutOutDeadLine", sLimitationTerm)
		.setParameter("LineEffDate", sBeginDate).setParameter("BeginDate", sPutOutDate).setParameter("EndDate", sMaturity)
		.setParameter("MaturityDeadLine", sUseTerm).setParameter("BCSerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		}
	   
	    return "1";
	    
	 }

}