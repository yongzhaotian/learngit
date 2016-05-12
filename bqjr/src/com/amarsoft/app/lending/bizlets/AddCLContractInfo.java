/*
 *		Author: jgao1 2009-10-27
 *		Tester:
 *		Describe: 额度调整时，更新CL_INFO
 *		Input Param:
 *		updatesuer:yhshan
 *      updatedate:2012/09/12
 *		HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class AddCLContractInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		//合同流水号
		String sBCSerialNo = (String)this.getAttribute("SerialNo");	
		//授信金额
		String sBusinessSum = (String)this.getAttribute("BusinessSum");
		//币种
		String sCurrency = (String)this.getAttribute("BusinessCurrency");
		//额度生效日
		String sBeginDate = (String)this.getAttribute("BeginDate");
		//额度起始日
		String sPutOutDate = (String)this.getAttribute("PutOutDate");
		//额度到期日
		String sMaturity = (String)this.getAttribute("Maturity");
		//额度使用最迟日期
		String sLimitationTerm = (String)this.getAttribute("LimitationTerm");
		//额度项下业务最迟到期日期
		String sUseTerm = (String)this.getAttribute("UseTerm");
		//登记人
		String sInputUser = (String)this.getAttribute("InputUser");
		
		//将空值转化为空字符串
		if(sBCSerialNo == null) sBCSerialNo = "";		
		if(sBusinessSum == null) sBusinessSum = "";
		if(sCurrency == null) sCurrency = "";
		if(sPutOutDate == null) sPutOutDate = "";
		if(sMaturity == null) sMaturity = "";
		if(sLimitationTerm == null) sLimitationTerm = "";
		if(sUseTerm == null) sUseTerm = "";
		if(sBeginDate == null) sBeginDate = "";
		if(sInputUser == null) sInputUser = "";
		
		double dBusinessSum = DataConvert.toDouble(sBusinessSum);
		
		//获得当前时间
	    String sCurDate = StringFunction.getToday();
	    //获取用户实例
	    ASUser CurUser = ASUser.getUser(sInputUser,Sqlca);
	    String sSql = " update CL_INFO set LineSum1 =:LineSum1, "+
		  " Currency =:Currency,LineEffDate =:LineEffDate, "+
		  " BeginDate =:BeginDate,PutOutDeadLine =:PutOutDeadLine, "+
		  " MaturityDeadLine =:MaturityDeadLine,EndDate =:EndDate, "+
		  " InputOrg =:InputOrg,InputUser =:InputUser, "+
		  " InputTime =:InputTime,UpdateTime =:UpdateTime "+
		  " where BCSerialNo =:BCSerialNo  and ParentLineID is null or ParentLineID='' or ParentLineID=' ' ";
	    SqlObject so = new SqlObject(sSql).setParameter("LineSum1", dBusinessSum).setParameter("Currency", sCurrency).setParameter("LineEffDate", sBeginDate)
	    .setParameter("BeginDate", sPutOutDate).setParameter("PutOutDeadLine", sLimitationTerm).setParameter("MaturityDeadLine", sUseTerm).setParameter("EndDate", sMaturity)
	    .setParameter("InputOrg", CurUser.getOrgID()).setParameter("InputUser", CurUser.getUserID()).setParameter("InputTime", sCurDate).setParameter("UpdateTime", sCurDate)
	    .setParameter("BCSerialNo", sBCSerialNo);
	    Sqlca.executeSQL(so);

		
		return "1";			
	}	
}
