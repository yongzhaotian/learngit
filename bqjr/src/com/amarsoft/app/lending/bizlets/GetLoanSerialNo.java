package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetLoanSerialNo extends Bizlet {
		
	public Object run(Transaction Sqlca) throws Exception {
		//身份证号
		String sCertID = (String)this.getAttribute("CertID");
		//合同号
		String sContractSerialno = (String)this.getAttribute("ContractSerialno");
		//计划提前还款日
		String sScheduleDate = (String)this.getAttribute("ScheduleDate");
		//将空值转化为空字符串
		if(sCertID == null) sCertID = "";
		if(sContractSerialno == null) sContractSerialno = "";
		if(sScheduleDate == null) sScheduleDate = "";
		
		String sSql = "";
		String sSerialno = "";
		String sNextdueDate = "";	//下次还款日
		String sMaturity = "";		//贷款可执行日期
		ASResultSet rs = null;
		
		sSql =  "select serialno,NextdueDate from acct_loan al,business_contract bc where al.contractserialno=bc.serialno and al.LoanStatus in('0','1') and ContractSerialno='"+sContractSerialno+"' ";
		/*if(sContractSerialno != "" && sCertID == ""){
			sSql += " ContractSerialno='"+sContractSerialno+"' ";
		}else if(sCertID != ""){
			sSql += " contractserialno in (select serialno from business_contract where certid='"+sCertID+"') ";
		}*/
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){			
		  sSerialno = rs.getString("serialno");
		  sNextdueDate = rs.getString("NextdueDate");
		  if(sSerialno==null){
			  sSerialno = "";
		  }
		  	  
		}
			rs.getStatement().close();
		//可执行提前还款日期选择
			
		//定义变量
		
		int sDays = DateFunctions.getDays(sScheduleDate, sNextdueDate);
		if(sDays < 10){
			sMaturity = DateFunctions.getRelativeDate(sScheduleDate, DateFunctions.TERM_UNIT_MONTH, 1);
		}else{
			sMaturity=sScheduleDate;
		}
		
		return sSerialno+"@"+sMaturity;
	}

}
