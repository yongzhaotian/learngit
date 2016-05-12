/*
		Author: --fwang 2009-11-16
		Tester:
		Describe: --初始化最终审批意见和流程
		Input Param:
				ObjectType: 对象类型
				ObjectNo: 对象编号
				ApplyType：申请类型
				FlowNo：流程编号
				PhaseNo：阶段编号
				UserID：用户代码
				OrgID：用户机构
				ApproveType：批复类型
				DisagreeOpinion：否决意见
		Output Param:
				SerialNo：批复流水号
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitializeGreenWay extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
	    //对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//用户代码
		String sUserID = (String)this.getAttribute("UserID");
		//机构代码
		String sOrgID = (String)this.getAttribute("OrgID");
				
		String sSerialNo = "";
		
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
				
		
		/*
		 * 对最终审批意见进初始化，调用 InitializeFlow.java		  
		*/
		Bizlet bzAddContract = new GreenWay();
		bzAddContract.setAttribute("ObjectNo",sObjectNo);
		bzAddContract.setAttribute("UserID",sUserID);
		sSerialNo = (String)bzAddContract.run(Sqlca);
		  
	    return sSerialNo;
	    
	 }

}
