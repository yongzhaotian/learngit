/**
 * 
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * @author jbye
 * 该控制主要用于房地产按揭额度、汽车按揭额度等的控制，浙商银行暂时不进行控制，因此默认都是 pass
 *
 */
public class IndCheckCreditLine extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
		//默认返回 空
		return "";
	}
	
	protected void initBizBusinessApply(Transaction Sqlca,ASValuePool biz,String sObjectNo)throws Exception{
		String sSql = "select BusinessSum,BailSum,TermYear,TermMonth,TermDay,OperateOrgID from BUSINESS_APPLY where SerialNo=:SerialNo";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
		if(rs.next()){
			biz.setAttribute("PutOutDate",StringFunction.getToday());//对于业务申请，假设当天为发放日
			biz.setAttribute("BusinessSum",rs.getString("BusinessSum"));
			biz.setAttribute("BailSum",rs.getString("BailSum"));
			biz.setAttribute("TermYear",rs.getString("TermYear"));
			biz.setAttribute("TermMonth",rs.getString("TermYear"));
			biz.setAttribute("TermDay",rs.getString("TermDay"));
			biz.setAttribute("OrgID",rs.getString("OperateOrgID"));
		}
		rs.getStatement().close();
	}
	
	protected void initBizBusinessApprove(Transaction Sqlca,ASValuePool biz,String sObjectNo)throws Exception{
		String sSql = "select BusinessSum,BailSum,TermYear,TermMonth,TermDay,OperateOrgID from BUSINESS_APPLY where SerialNo=:SerialNo";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
		if(rs.next()){
			biz.setAttribute("PutOutDate",StringFunction.getToday());//对于批复，假设当天为发放日
			biz.setAttribute("BusinessSum",rs.getString("BusinessSum"));
			biz.setAttribute("BailSum",rs.getString("BailSum"));
			biz.setAttribute("TermYear",rs.getString("TermYear"));
			biz.setAttribute("TermMonth",rs.getString("TermYear"));
			biz.setAttribute("TermDay",rs.getString("TermDay"));
			biz.setAttribute("OrgID",rs.getString("OperateOrgID"));
		}
		rs.getStatement().close();
	}
	
	protected void initBizBusinessContract(Transaction Sqlca,ASValuePool biz,String sObjectNo)throws Exception{
		String sSql = "select BusinessSum,BailSum,TermYear,TermMonth,TermDay,OperateOrgID from BUSINESS_APPLY where SerialNo=:SerialNo";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
		if(rs.next()){
			biz.setAttribute("PutOutDate",rs.getString("PutOutDate"));
			biz.setAttribute("BusinessSum",rs.getString("BusinessSum"));
			biz.setAttribute("BailSum",rs.getString("BailSum"));
			biz.setAttribute("TermYear",rs.getString("TermYear"));
			biz.setAttribute("TermMonth",rs.getString("TermYear"));
			biz.setAttribute("TermDay",rs.getString("TermDay"));
			biz.setAttribute("OrgID",rs.getString("OperateOrgID"));
		}
		rs.getStatement().close();
	}
}
