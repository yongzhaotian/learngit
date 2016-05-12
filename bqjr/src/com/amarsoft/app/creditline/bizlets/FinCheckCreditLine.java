/**
 * 
 */
package com.amarsoft.app.creditline.bizlets;

import java.util.Vector;

import com.amarsoft.amarscript.ASDate;
import com.amarsoft.app.creditline.CreditLine;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * @author jbye
 */
public class FinCheckCreditLine extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sLineID = (String)this.getAttribute("LineID");
        String sObjectType = (String)this.getAttribute("ObjectType");
        String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSql = null;
		SqlObject so = null;
        
        //错误
        Vector errors = new Vector();
        
		//初始化额度对象
		CreditLine line = new CreditLine(Sqlca,sLineID);
		double dBalance1 = line.getBalance(Sqlca,"LineSum1");
        double dBalance2 = line.getBalance(Sqlca,"LineSum2");
        
        //更新检查记录表中的额度余额值
        String sCurCheckNo = line.getCurCheckNo();
        sSql = "update CL_CHECK_LOG set " +
				"LineSum1Balance=:LineSum1Balance, " +
				"LineSum2Balance=:LineSum2Balance " +
				"where LineID=:LineID  and CheckNo=:CheckNo ";
        so = new SqlObject(sSql);
		so.setParameter("LineSum1Balance", dBalance1);
		so.setParameter("LineSum2Balance", dBalance2);
		so.setParameter("LineID", line.id());
		so.setParameter("CheckNo", sCurCheckNo);
		Sqlca.executeSQL(so);
        
        if(sObjectType==null) throw new Exception("检查额度时发生错误：未能获得参数ObjectType");
        if(sObjectNo==null) throw new Exception("检查额度时发生错误：未能获得参数sObjectNo");
        
        //初始化业务对象
        ASValuePool biz = new ASValuePool();
        if(sObjectType.equals("CreditApply")) initBizBusinessApply(Sqlca,biz,sObjectNo);
        else if(sObjectType.equals("AgreeApproveApply")) initBizBusinessApprove(Sqlca,biz,sObjectNo);
        else if(sObjectType.equals("BusinessContract")) initBizBusinessContract(Sqlca,biz,sObjectNo);
        
        
        //----------------------------授信业务金额限制判断-----------------------------
        double dBusinessSum = DataConvert.toDouble((String)biz.getAttribute("BusinessSum"));
        if(dBusinessSum > dBalance1) errors.add("ErrorType=EX_LINESUM1;MeasureColumn=LineSum1;");
        
        //----------------------------敞口金额限制判断-----------------------------
        double dBailSum = DataConvert.toDouble((String)biz.getAttribute("BailSum"));//保证金
        if(dBusinessSum-dBailSum > dBalance2) errors.add("ErrorType=EX_LINESUM2;MeasureColumn=LineSum2;");
        
        
        //----------------------------业务到期日截止日判断-----------------------------
        //取期限，并转化成日
        String sPutOutDate = (String)biz.getAttribute("PutOutDate"); 
        if(sPutOutDate==null) sPutOutDate=StringFunction.getToday();
        int iTermDays = DataConvert.toInt((String)biz.getAttribute("TermYear")) 
        				+  DataConvert.toInt((String)biz.getAttribute("TermMonth")) 
        				+ DataConvert.toInt((String)biz.getAttribute("TermDay"));
        
        //计算到期日
        ASDate putOutDate = new ASDate(sPutOutDate);
        ASDate surposedFinishDate = putOutDate.getRelativeDate(iTermDays);
        
        //取额度的到期日截止日
        String sMaturityDeadLine = (String)line.getAttribute("MaturityDeadLine");
        if(sMaturityDeadLine==null) sMaturityDeadLine=StringFunction.getToday();
        ASDate maturityDeadLine = new ASDate(sMaturityDeadLine);
        
        if(maturityDeadLine.compareTo(surposedFinishDate)<0) errors.add("ErrorType=EX_DEADLINE_MATURITY;");
        
        
        //----------------------------业务到期日截止日判断-----------------------------
        String sPutOutDeadLine = (String)line.getAttribute("PutOutDeadLine");
        if(sPutOutDeadLine==null) sPutOutDeadLine=StringFunction.getToday();
        ASDate putOutDeadLine = new ASDate(sPutOutDeadLine);
        if(putOutDeadLine.compareTo(putOutDate)<0) errors.add("ErrorType=EX_DEADLINE_MATURITY;");
        
        
        //----------------------------拼接返回串-------------------------------
        if(errors.size()<1) return "";
        else{
        	StringBuffer sbReturn = new StringBuffer("");
        	for(int i=0;i<errors.size();i++) sbReturn.append((String)errors.get(i)+"@");
        	return sbReturn.toString();
        }
        

	}
	
	private void initBizBusinessApply(Transaction Sqlca,ASValuePool biz,String sObjectNo)throws Exception{
		String sSql = "select BusinessSum,BailSum,TermYear,TermMonth,TermDay,OperateOrgID from BUSINESS_APPLY where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("SerialNo", sObjectNo);
		ASResultSet rs = Sqlca.getASResultSet(so);
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
	
	private void initBizBusinessApprove(Transaction Sqlca,ASValuePool biz,String sObjectNo)throws Exception{
		String sSql = "select BusinessSum,BailSum,TermYear,TermMonth,TermDay,OperateOrgID from BUSINESS_APPLY where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("SerialNo", sObjectNo);
		ASResultSet rs = Sqlca.getASResultSet(so);
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
	
	private void initBizBusinessContract(Transaction Sqlca,ASValuePool biz,String sObjectNo)throws Exception{
		String sSql = "select BusinessSum,BailSum,TermYear,TermMonth,TermDay,OperateOrgID from BUSINESS_APPLY where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("SerialNo", sObjectNo);
		ASResultSet rs = Sqlca.getASResultSet(so);
		
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
