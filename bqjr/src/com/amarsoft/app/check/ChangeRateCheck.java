package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.*;

/**
 * 利率调整校验
 * @author djia
 * @since 2009/10/29
 */

public class ChangeRateCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		//定义变量：SQL语句、意见详情
		String sSql = "";
		boolean have01 = false,havee01 = false;
		sSql = "select DocumentSerialNo from ACCT_TRANSACTION where serialno = '"+sObjectNo+"' and RelativeObjectType='jbo.app.ACCT_LOAN' and DocumentType='jbo.app.ACCT_LOAN_CHANGE' ";
		String sDocumentSerialNo = DataConvert.toString(Sqlca.getString(sSql));
		
		sSql = "select RateType,BusinessRate from ACCT_RATE_SEGMENT where ObjectNo = '"+sDocumentSerialNo+"' and ObjectType = 'jbo.app.ACCT_LOAN_CHANGE' and Status <> '2' ";
		String sRateType = "";
		double sBusinessRate = 0.0d;
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		while(rs.next()){
			sRateType = DataConvert.toString(rs.getString("RateType"));
			sBusinessRate = DataConvert.toDouble(rs.getString("BusinessRate"));
			if(sBusinessRate <= 0){
				putMsg("新利率类型和新罚息利率的执行利率必须大于0");
				setPass(false);
				rs.close();
				return null;
			}
			if("01".equals(sRateType))
				have01 = true;
			else
				havee01 = true;
		}
		rs.close();
		rs.getStatement().close();
		
		if(have01 && havee01)
			setPass(true);
		else{
			putMsg("请录入新利率类型和新罚息利率。");
			setPass(false);
		}
		
		return null;
	}

}
