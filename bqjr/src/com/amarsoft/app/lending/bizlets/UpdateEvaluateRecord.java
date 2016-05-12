package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateEvaluateRecord extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sObjectNo = (String)this.getAttribute("sObjectNo");
		String sCognResult = (String)this.getAttribute("sCognResult");
		String sCognreason = (String)this.getAttribute("sPhaseOpinion");
		String sUserID = (String)this.getAttribute("sUserId");
		String sPhaseNo = (String)this.getAttribute("sPhaseNo");
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sCognResult == null) sCognResult = "" ;
		if(sCognreason == null) sCognreason = "" ;
		if(sUserID == null) sUserID ="";
		if(sPhaseNo == null) sPhaseNo="";
		
		String sSql = "";
		
		sSql="update EVALUATE_RECORD set CognUserId  =:CognUserId,CognResult =:CognResult,Cognreason=:Cognreason where SerialNo =:SerialNo";	
		SqlObject so = new SqlObject(sSql).setParameter("CognUserId", sUserID).setParameter("CognResult", sCognResult)
		.setParameter("Cognreason", sCognreason).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		return "1";
	}	

}
