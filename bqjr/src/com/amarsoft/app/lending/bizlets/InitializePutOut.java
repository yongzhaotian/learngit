/*
 * 		Author: zywei 2005-08-13
 * 		Tester:
 * 		Describe: 初始化放贷申请和流程
 * 		Input Param:
 * 				ObjectType: 对象类型
 * 				ObjectNo: 对象编号
 * 				ApplyType：申请类型
 * 				FlowNo：流程编号
 * 				PhaseNo：阶段编号
 * 				UserID：用户代码
 * 				OrgID：用户机构
 * 		Output Param:
 * 				SerialNo：合同流水号
 * 		HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import java.util.StringTokenizer;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitializePutOut extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//业务品种
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//汇票编号
		String sBillNo = (String)this.getAttribute("BillNo");
		//申请类型
		String sApplyType = (String)this.getAttribute("ApplyType");
		//流程编号
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//阶段编号
		String sPhaseNo = (String)this.getAttribute("PhaseNo");	
		//用户代码
		String sUserID = (String)this.getAttribute("UserID");
		//机构代码
		String sOrgID = (String)this.getAttribute("OrgID");
		//出帐流水号				
		String sSerialNo = "";
		
		//调用AddPutOutInfo.java对出账申请进行初始化				
	    Bizlet bzAddPutOut = new AddPutOutInfo();
		bzAddPutOut.setAttribute("ObjectType",sObjectType); 
		bzAddPutOut.setAttribute("ObjectNo",sObjectNo);	
		bzAddPutOut.setAttribute("BusinessType",sBusinessType);		
		bzAddPutOut.setAttribute("BillNo",sBillNo);
		bzAddPutOut.setAttribute("UserID",sUserID);
		sSerialNo = (String)bzAddPutOut.run(Sqlca);
		/*
		 * 2、调用 InitializeFlow.java对放贷申请进行流程初始化		  
		*/
		int i = 0;
		StringTokenizer st = new StringTokenizer(sSerialNo,"@");
	    String [] sPutOutSerialNo = new String[st.countTokens()];

		while (st.hasMoreTokens())
	    {			
			sPutOutSerialNo[i] = st.nextToken();
	        i ++;
	    }
		
	    for(int j = 0 ; j < sPutOutSerialNo.length ; j ++)
	    {	    	
	    	Bizlet bzInitFlow = new InitializeFlow();
			bzInitFlow.setAttribute("ObjectType",sObjectType); 
			bzInitFlow.setAttribute("ObjectNo",sPutOutSerialNo[j]); 
			bzInitFlow.setAttribute("ApplyType",sApplyType);
			bzInitFlow.setAttribute("FlowNo",sFlowNo);
			bzInitFlow.setAttribute("PhaseNo",sPhaseNo);
			bzInitFlow.setAttribute("UserID",sUserID);
			bzInitFlow.setAttribute("OrgID",sOrgID);
			bzInitFlow.run(Sqlca);			
	    }
	    
	    return sPutOutSerialNo[0];
	 }
}
