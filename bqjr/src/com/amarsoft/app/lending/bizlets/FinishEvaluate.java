/*
Author:   bwang
Tester:
Describe: 信用等级认定后需要对信用等级记录进行更新
Input Param:
		ObjectNo: 对象编号
		sObjectType:对象类型
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishEvaluate extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//对象编号
		String sObjectNo = (String)this.getAttribute("sObjectNo");
		String sObjectType = (String)this.getAttribute("sObjectType");

		String sFOSerialNo ="";//最后的意见流水编号
		double dUserScore=0;//人工认定分数
		String sUserResult="";//人工认定结果
		String sCognReason="";//人工认定理由
		String sInputTime="";//人工认定日期
		String sInputUser="";//人工认定人
		String sInputOrg="";//人工认定机构
		String sCustomerID="";//认定客户编号

		String sSql = "";
		ASResultSet rs=null;
		SqlObject so=null;
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		//查询认定完成后，最终认定人的审批流程任务编号
		sSql = 	" select MAX(OpinionNo) as OpinionNo from Flow_Opinion"+
		" where ObjectType=:ObjectType "+
		" and ObjectNo=:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			sFOSerialNo=rs.getString("OpinionNo");
		}
		if(sFOSerialNo==null)sFOSerialNo="";
		rs.getStatement().close();

		//取最终认定人意见
		sSql = 	" select BailSum as CognScore,PhaseOpinion2 as CognResult,"+//人工分数，结果
		" InputTime,InputUser,InputOrg,"+//人工认定日期,认定人 ，认定机构
		" PhaseOpinion as CognReason"+
		" from Flow_Opinion"+
		" where OpinionNo=:OpinionNo";
		so = new SqlObject(sSql).setParameter("OpinionNo", sFOSerialNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			dUserScore =rs.getDouble("CognScore");//人工认定分数
			sUserResult=rs.getString("CognResult");//人工认定结果
			sCognReason=rs.getString("CognReason");//人工认定理由
			sInputTime =rs.getString("InputTime");//人工认定日期
			sInputUser =rs.getString("InputUser");//人工认定人
			sInputOrg  =rs.getString("InputOrg");//人工认定机构
		}
		if(sUserResult==null)sUserResult="";
		if(sCognReason==null)sCognReason="";
		if(sInputTime==null)sInputTime="";
		if(sInputUser==null)sInputUser="";
		if(sInputOrg==null)sInputOrg="";
		rs.getStatement().close();

		//更新信用等级记录表
		sSql=" UPDATE EVALUATE_RECORD SET CognDate=:CognDate,"+
		" CognScore=:CognScore,CognResult=:CognResult,"+
		" CognReason=:CognReason,"+
		" FinishDate=:FinishDate,"+
		" CognOrgID=:CognOrgID,CognUserID=:CognUserID "+
		" WHERE SerialNo=:SerialNo AND ObjectType=:ObjectType ";
		so = new SqlObject(sSql);
		so.setParameter("CognDate", sInputTime).setParameter("CognScore", dUserScore).setParameter("CognResult", sUserResult)
		.setParameter("CognReason", sCognReason).setParameter("FinishDate", sInputTime).setParameter("CognOrgID", sInputOrg)
		.setParameter("CognUserID", sInputUser).setParameter("SerialNo", sObjectNo).setParameter("ObjectType", sObjectType);
		Sqlca.executeSQL(so);
		
		//查询认定客户CustomerID
		sSql = 	" select ObjectNo from EVALUATE_RECORD where ObjectType=:ObjectType and SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){	
			sCustomerID=rs.getString("ObjectNo");
		}
		if(sCustomerID==null)sCustomerID="";
		rs.getStatement().close();
		
		//更新信用等级最终记录
		sSql=" UPDATE ENT_INFO SET EvaluateDate=:EvaluateDate,CreditLevel=:CreditLevel "+
		 " WHERE CustomerID=:CustomerID ";
		so = new SqlObject(sSql);
		so.setParameter("EvaluateDate", sInputTime).setParameter("CreditLevel", sUserResult).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
		
		//更新信用等级最终记录
		sSql=" UPDATE IND_INFO SET EvaluateDate=:EvaluateDate,CreditLevel=:CreditLevel "+
		 " WHERE CustomerID=:CustomerID ";
		so = new SqlObject(sSql).setParameter("EvaluateDate", sInputTime).setParameter("CreditLevel", sUserResult).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
		
		return "1";

	}

}

