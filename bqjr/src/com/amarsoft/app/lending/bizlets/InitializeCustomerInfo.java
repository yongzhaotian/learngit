/*
		Author: --zywei 2005-08-09
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
				pwang  2009-10-27    此类只在中小企业资格认定中 做流程初始化用,而认定过程并不做新建客户,将删除客户的逻辑去除.
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitializeCustomerInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
 {			
		//对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
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

		//获得新增客户信息参数：客户类型、客户名称、证件类型、证件编号、返回状态、客户编号
		String sCustomerType = (String)this.getAttribute("CustomerType");
		String sCustomerName = (String)this.getAttribute("CustomerName");	
		String sCertType = (String)this.getAttribute("CertType");
		String sCertID = (String)this.getAttribute("CertID");	
		String sReturnStatus = (String)this.getAttribute("Status");
		String sCustomerID = (String)this.getAttribute("CustomerID");	
		String sCustomerScale = (String)this.getAttribute("CustomerScale");	

		String sSerialNo = "";	
		String sSql = "";
		SqlObject so=null; 
		//将空值转化为空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sApplyType == null) sApplyType = "";
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		
		if(sCustomerType == null) sCustomerType = "";
		if(sCustomerName == null) sCustomerName = "";	
		if(sCertType == null) sCertType = "";
		if(sCertID == null) sCertID = "";	
		if(sReturnStatus == null) sReturnStatus = "";
		if(sCustomerID == null) sCustomerID = "";	
		if(sCustomerScale == null) sCustomerScale = "";	
		sSql = "select count(*) as ReturnValue from flow_object where objectType=:objectType and objectNo =:objectNo";
		so = new SqlObject(sSql).setParameter("objectType", sObjectType).setParameter("objectNo", sCustomerID);
		String returnValue = Sqlca.getString(so);
		if (returnValue.equals("0"))
		{
			/*
			 * 3、调用 InitializeFlow.java对最终审批意见进行流程初始化		  
			*/
			Bizlet bzInitFlow = new InitializeFlow();
			bzInitFlow.setAttribute("ObjectType",sObjectType); 
			bzInitFlow.setAttribute("ObjectNo",sCustomerID); 
			bzInitFlow.setAttribute("ApplyType",sApplyType);
			bzInitFlow.setAttribute("FlowNo",sFlowNo);
			bzInitFlow.setAttribute("PhaseNo",sPhaseNo);
			bzInitFlow.setAttribute("UserID",sUserID);
			bzInitFlow.setAttribute("OrgID",sOrgID);
			bzInitFlow.run(Sqlca);
			  
		    return sSerialNo;
		}
		else 
			return null;	    
	 }

}
