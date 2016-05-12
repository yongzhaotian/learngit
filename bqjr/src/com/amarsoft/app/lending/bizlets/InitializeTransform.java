/*
		Author: --ccxie 2010/03/18
		Tester:
		Describe: --初始化担保变更合同
		Input Param:
				SerialNo: 合同流水号
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitializeTransform extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//合同流水号
		String sSerialNo = (String)this.getAttribute("SerialNo");
		//流程编号
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//阶段编号
		String sPhaseNo = (String)this.getAttribute("PhaseNo");	
		//用户代码
		String sUserID = (String)this.getAttribute("UserID");
		//机构代码
		String sOrgID = (String)this.getAttribute("OrgID");
		//对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//申请类型
		String sApplyType = (String)this.getAttribute("ApplyType");
		//将空值转化为空字符串
		if(sSerialNo == null) sSerialNo = "";
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		if(sObjectType == null) sObjectType = "";
		if(sApplyType == null) sApplyType = "";
		String sNewSerialNo = "";
		
		//拷贝担保合同变更的相关信息
		Bizlet addTransformInfo = new AddTransformInfo();
		addTransformInfo.setAttribute("SerialNo",sSerialNo);
		sNewSerialNo = (String) addTransformInfo.run(Sqlca);
		
		//初始化流程信息
		Bizlet bzInitFlow = new InitializeFlow();
		bzInitFlow.setAttribute("ObjectType",sObjectType); 
		bzInitFlow.setAttribute("ObjectNo",sNewSerialNo); 
		bzInitFlow.setAttribute("ApplyType",sApplyType); 
		bzInitFlow.setAttribute("UserID",sUserID); 
		bzInitFlow.setAttribute("OrgID",sOrgID); 
		bzInitFlow.setAttribute("FlowNo",sFlowNo); 
		bzInitFlow.setAttribute("PhaseNo",sPhaseNo); 
		bzInitFlow.run(Sqlca);
	   
		return sNewSerialNo;
	 }

}
