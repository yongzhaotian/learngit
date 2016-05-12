package com.amarsoft.app.lending.bizlets;

/**
 * 流程初始化类
 * @history fhuang 2007.01.08 增加中小企业流程选择
 * 			syang 2009/10/26 更正注释
 */
import com.amarsoft.app.als.process.action.BusinessProcessAction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class InitializeFlowNew extends Bizlet 
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
        SqlObject so; //声明对象	
		//定义变量:用户名称、机构名称、流程名称、阶段名称、阶段类型、开始时间、任务流水号、SQL
		String sUserName = "";
		String sOrgName = "";
		String sFlowName = "";
		String sPhaseName = "";	
		String sPhaseType = "";
		String sSql = "";
		//定义变量：查询结果集
		ASResultSet rs=null;
		
		if(sObjectType == null) sObjectType = "";
				
		//获取的用户名称
		sSql = " select UserName from USER_INFO where UserID =:UserID ";
		so = new SqlObject(sSql).setParameter("UserID", sUserID);
		sUserName = Sqlca.getString(so);
	    //取得机构名称
		sSql = " select OrgName from ORG_INFO where OrgID =:OrgID ";
		so = new SqlObject(sSql).setParameter("OrgID", sOrgID);
		sOrgName = Sqlca.getString(so);
        //取得流程名称
		sSql = " select FlowName from FLOW_CATALOG where FlowNo =:FlowNo ";
		so = new SqlObject(sSql).setParameter("FlowNo", sFlowNo);
		sFlowName = Sqlca.getString(so);
        //取得阶段名称
		sSql = " select PhaseName,PhaseType from FLOW_MODEL where FlowNo =:FlowNo and PhaseNo =:PhaseNo ";
		so = new SqlObject(sSql).setParameter("FlowNo", sFlowNo).setParameter("PhaseNo", sPhaseNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{ 
			sPhaseName = rs.getString("PhaseName");
			sPhaseType = rs.getString("PhaseType");
			
			//将空值转化成空字符串
			if(sPhaseName == null) sPhaseName = "";
			if(sPhaseType == null) sPhaseType = "";
		}
		rs.getStatement().close(); 
	    
	    //将空值转化成空字符串
	    if(sObjectType == null) sObjectType = "";
	    if(sObjectNo == null) sObjectNo = "";
	    if(sPhaseType == null) sPhaseType = "";
	    if(sApplyType == null) sApplyType = "";
	    if(sFlowNo == null) sFlowNo = "";
	    if(sFlowName == null) sFlowName = "";
	    if(sPhaseNo == null) sPhaseNo = "";
	    if(sPhaseName == null) sPhaseName = "";
	    if(sUserID == null) sUserID = "";
	    if(sUserName == null) sUserName = "";
	    if(sOrgID == null) sOrgID = "";
	    if(sOrgName == null) sOrgName = "";
	    
	    BusinessProcessAction bpAction = new BusinessProcessAction();
	    bpAction.setObjectNo(sObjectNo);
	    bpAction.setObjectType(sObjectType);
	    bpAction.setApplyType(sApplyType);
	    bpAction.setProcessDefID(sFlowNo);
	    bpAction.setUserID(sUserID);
	    bpAction.start();
	    return "1";
	    
	 }

}
