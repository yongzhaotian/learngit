package com.amarsoft.app.lending.bizlets;

/**
 * 流程初始化类
 * @history fhuang 2007.01.08 增加中小企业流程选择
 * 			syang 2009/10/26 更正注释
 */
import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class InitializePutOutFlow extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
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
		System.err.println("sObjectType="+sObjectType+",sApplyType="+sApplyType+",sFlowNo="+sFlowNo+",sUserID="+sUserID+",sOrgID="+sOrgID);
        		
		//定义变量:用户名称、机构名称、流程名称、阶段名称、阶段类型、开始时间、任务流水号、SQL
		String sUserName = "";
		String sOrgName = "";
		String sFlowName = "";
		String sPhaseName = "";	
		String sPhaseType = "";
		String sBeginTime = "";
		String sSerialNo = "";
		String sSql = "";
		String sObjectNo="";
		//定义变量：查询结果集
		ASResultSet rs=null;
		SqlObject so;
		// add by fhuang  如果客户类型是中小企业的使用流程模型 SMECreditFlow
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
		
		//获得开始日期
	    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();	 
		System.out.println("sPhaseName="+sPhaseName+",sPhaseType="+sPhaseType);

	    //将空值转化成空字符串
	    if(sObjectType == null) sObjectType = "";
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
	    sSql="select serialno from business_contract where CreditAttribute = '0001'";  
	    rs = Sqlca.getASResultSet(sSql);
	    while(rs.next()){
	    	sObjectNo=rs.getString("serialno");
	    	sSql="select count(ObjectNo) from FLOW_OBJECT where ObjectNo=:ObjectNo and ObjectType =:ObjectType "; 
	    	so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
	    	String count = Sqlca.getString(so);
	    	SqlObject so1=null;
	    	if(count!=null &&count.equals("0")){
		    	 //在流程对象表FLOW_OBJECT中新增一笔信息
			    String sSql1 =  " Insert into FLOW_OBJECT(ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName,PhaseNo, " +
			    " PhaseName,OrgID,OrgName,UserID,UserName,InputDate) " +
		        " values (:ObjectType,:ObjectNo,:PhaseType,:ApplyType,:FlowNo, " +
		        " :FlowName,:PhaseNo,:PhaseName,:OrgID,:OrgName,:UserID, "+
		        " :UserName,:InputDate) ";
			    so1 = new SqlObject(sSql1);
			    so1.setParameter("ObjectType", sObjectType).setParameter("ObjectNo",sObjectNo ).setParameter("PhaseType", sPhaseType).setParameter("ApplyType", sApplyType)
			    .setParameter("FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("PhaseNo", sPhaseNo).setParameter("PhaseName", sPhaseName).setParameter("OrgID", sOrgID)
			    .setParameter("OrgName", sOrgName).setParameter("UserID", sUserID).setParameter("UserName", sUserName).setParameter("InputDate", StringFunction.getToday());
			    //执行插入语句
			    Sqlca.executeSQL(so1);
	    	}
	    	
	    	sSql="select count(ObjectNo) from FLOW_TASK where ObjectNo=:ObjectNo and ObjectType =:ObjectType and FlowNo=:FlowNo"; 
	    	so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType).setParameter("FlowNo", sFlowNo);
	    	count = Sqlca.getString(so);
	    	SqlObject so2=null;
	    	if(count!=null &&count.equals("0")){
	    		//在流程任务表FLOW_TASK中新增一笔信息
	    		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
	    		sSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK","SerialNo",Sqlca);*/
	    		sSerialNo = DBKeyHelp.getWorkNo();
	    		/** --end --*/
			    
			    String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
					" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime) "+
					" values (:SerialNo,:ObjectType,:ObjectNo,:PhaseType,:ApplyType, " + 
					" :FlowNo,:FlowName,:PhaseNo,:PhaseName,:OrgID,:UserID, " +
					" :UserName,:OrgName,:BeginTime )";
			    so2= new SqlObject(sSql2);
			    so2.setParameter("SerialNo", sSerialNo).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("PhaseType", sPhaseType)
			    .setParameter("ApplyType", sApplyType).setParameter("FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("PhaseNo", sPhaseNo)
			    .setParameter("PhaseName", sPhaseName).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("UserName", sUserName)
			    .setParameter("OrgName", sOrgName).setParameter("BeginTime", sBeginTime);
			    Sqlca.executeSQL(so2);
	    	}
		   
	    }	   
	    return "1";    
	 }
}
