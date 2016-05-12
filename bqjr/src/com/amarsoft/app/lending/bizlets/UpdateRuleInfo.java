package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateRuleInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String st1 = (String)this.getAttribute("SerialNo");//流水号
		String st2 = (String)this.getAttribute("ModelID");//规则模型
		String st3 = (String)this.getAttribute("RuleType");//规则类型
		String st4 = (String)this.getAttribute("RuleID");//规则编号
		String st5 = (String)this.getAttribute("FileName");//文件名
		String st6 = (String)this.getAttribute("InputUserID");//登记人
		String st7 = (String)this.getAttribute("InputOrgID");//登记机构
		String st8 = (String)this.getAttribute("InputDate");//登记日期

	
		//将空值转化为空字符串
		if(st1 == null) st1 = "";
		if(st2 == null) st2 = "";
		if(st3 == null) st3 = "";
		if(st4 == null) st4 = "";
		if(st5 == null) st5 = "";
		if(st6 == null) st6 = "";
		if(st7 == null) st7 = "";
		if(st8 == null) st8 = "";

		
		String sSql = "";
		ASResultSet rs = null;
		SqlObject so;
		//
		sSql = "select serialno from rule_engine_Info where ModelID=:ModelID and RuleType=:RuleType and RuleID=:RuleID and FileName=:FileName and InputUserID=:InputUserID and InputOrgID=:InputOrgID and InputDate=:InputDate ";
		so = new SqlObject(sSql).setParameter("ModelID", st2).setParameter("RuleType", st3).setParameter("RuleID", st4).setParameter("FileName", st5).setParameter("InputUserID", st6).setParameter("InputOrgID", st7).setParameter("InputDate", st8);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()) 
		{
			String serialno=rs.getString("serialno");
			if(serialno == null) serialno = "";
			
            //如果存在数据，更新
			sSql="update rule_engine_Info set ModelID=:ModelID,RuleType=:RuleType,RuleID=:RuleID,FileName=:FileName,InputUserID=:InputUserID,InputOrgID=:InputOrgID,InputDate=:InputDate where serialno=:serialno ";
			so = new SqlObject(sSql);
			so.setParameter("ModelID", st2).setParameter("RuleType", st3).setParameter("RuleID", st4).setParameter("FileName", st5)
			.setParameter("InputUserID", st6).setParameter("InputOrgID", st7).setParameter("InputDate", st8).setParameter("serialno", serialno);
			Sqlca.executeSQL(so);
		}else{//不存在，插入数据
			sSql = "insert into rule_engine_Info(SerialNo,ModelID,RuleType,RuleID,FileName,InputUserID,InputOrgID,InputDate) values(:SerialNo,:ModelID,:RuleType,:RuleID,:FileName,:InputUserID,:InputOrgID,:InputDate)";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", st1).setParameter("ModelID", st2).setParameter("RuleType", st3).setParameter("RuleID", st4).setParameter("FileName", st5).setParameter("InputUserID", st6).setParameter("InputOrgID", st7).setParameter("InputDate", st8);
			Sqlca.executeSQL(so);	
		}
		rs.getStatement().close();

		return "1";
	}	

}
