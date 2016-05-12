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


public class InitializeFlow extends Bizlet 
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
        		
		//定义变量:用户名称、机构名称、流程名称、阶段名称、阶段类型、开始时间、任务流水号、SQL
		String sUserName = "";
		String sOrgName = "";
		String sFlowName = "";
		String sPhaseName = "";	
		String sPhaseType = "";
		String sBeginTime = "";
		String sSerialNo = "";
		String sSql = "";
		//定义变量：查询结果集
		ASResultSet rs=null;
		SqlObject so;
		// add by fhuang  如果客户类型是中小企业的使用流程模型 SMECreditFlow
		if(sObjectType == null) sObjectType = "";
	
		if(sObjectType.equals("CreditApply")){
			//找出CustomerID
			String[] sFlowNoArray = sFlowNo.split("@");
			sSql = "select CustomerID from Business_Contract where SerialNo=:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			String sCustomerID = Sqlca.getString(so);
			if(sCustomerID == null) sCustomerID = "";
			sSql = "select CustomerType from Customer_Info where CustomerID=:CustomerID ";
			so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			String sCustomerType = Sqlca.getString(so);
			if(sCustomerType == null) sCustomerType = "";
			//0120 中小型企业,使用配置靠后的流程号
			
			//FlowNo格式：CreditFlow@SMEStandardFlow，第1位表示大型企业使用流程，第2位表示中小企业使用流程
			if(sCustomerType.equals("0120")){
				if(sFlowNoArray.length >= 2){
					sFlowNo = sFlowNoArray[1];
				}else{
					sFlowNo = sFlowNoArray[0];
				}
			}else{
				sFlowNo = sFlowNoArray[0];
			}
			
			//获取初始化阶段
			sSql = "select InitPhase from FLOW_CATALOG where FlowNo =:FlowNo ";
			so = new SqlObject(sSql).setParameter("FlowNo", sFlowNo);
			sPhaseNo = Sqlca.getString(so);
			//如果没有初始阶段编号，抛出提示信息
			if(sPhaseNo==null||sPhaseNo.trim().equals(""))
				throw new Exception("审批流程"+sFlowNo+"没有初始化阶段编号！");
		}
		
		//如果申请一笔新发生的业务或只是申请额度，且在BUSINESS_TYPE中指定了审批流程,则从之中取得审批流程编号和初始阶段编号，并覆盖掉已经取得的默认值；
		//add by wlu 2009-02-20
		if(sObjectType.equals("CreditApply"))
		{
			String sOccurtype="";
			if(sApplyType==null)sApplyType="";
			if(!sApplyType.equals("CreditLineApply")){
				so = new SqlObject("select Occurtype from Business_Contract where SerialNo=:SerialNo").setParameter("SerialNo", sObjectNo);
				sOccurtype = Sqlca.getString(so);
				if(sOccurtype==null)sOccurtype="";
			}
			//发生类型010，新发生的业务或申请申请额度
			if(sApplyType.equals("CreditLineApply")||sOccurtype.equals("010")){
				//从业务表中查询审批流程编号
				sSql = " select Attribute9 from Business_Type where TypeNo= "+
				   " (select businesstype from Business_Contract where serialno=:serialno) ";
				so = new SqlObject(sSql).setParameter("serialno", sObjectNo);
				String sFlowNo1 = Sqlca.getString(so);
				
				if(sFlowNo1 == null) sFlowNo1 = "";
				
				//如果存在审批流程编号则查询初始阶段编号
				if(!sFlowNo1.equals("")||sFlowNo1.trim().length()>0)			
				{
					sFlowNo = sFlowNo1;
					//获取初始化阶段
					sSql = "select InitPhase from FLOW_CATALOG where FlowNo =:FlowNo";
					so = new SqlObject(sSql).setParameter("FlowNo", sFlowNo);
					sPhaseNo = Sqlca.getString(so);
					//如果没有初始阶段编号，抛出提示信息
					if(sPhaseNo==null||sPhaseNo.trim().equals("")) {
						ARE.getLog().error("审批流程"+sFlowNo1+"没有初始化阶段编号");
						throw new Exception("审批流程"+sFlowNo1+"没有初始化阶段编号！");
					}
				}
			}
												
		}
				
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
	   	    
	    //在流程对象表FLOW_OBJECT中新增一笔信息
	    String sSql1 =  " Insert into FLOW_OBJECT(ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName,PhaseNo, " +
	    " PhaseName,OrgID,OrgName,UserID,UserName,InputDate) " +
        " values (:ObjectType,:ObjectNo,:PhaseType,:ApplyType,:FlowNo, " +
        " :FlowName,:PhaseNo,:PhaseName,:OrgID,:OrgName,:UserID, "+
        " :UserName,:InputDate) ";
	    so = new SqlObject(sSql1);
	    so.setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("PhaseType", sPhaseType).setParameter("ApplyType", sApplyType)
	    .setParameter("FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("PhaseNo", sPhaseNo).setParameter("PhaseName", sPhaseName).setParameter("OrgID", sOrgID)
	    .setParameter("OrgName", sOrgName).setParameter("UserID", sUserID).setParameter("UserName", sUserName).setParameter("InputDate", StringFunction.getToday());
	    //在流程任务表FLOW_TASK中新增一笔信息
	    /** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
	    sSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK","SerialNo",Sqlca); */
	    sSerialNo = DBKeyHelp.getWorkNo(); 
	    /** --end --*/
	    
	    String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
			" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime) "+
			" values (:SerialNo,:ObjectType,:ObjectNo,:PhaseType,:ApplyType, " + 
			" :FlowNo,:FlowName,:PhaseNo,:PhaseName,:OrgID,:UserID, " +
			" :UserName,:OrgName,:BeginTime )";
	    SqlObject so1 = new SqlObject(sSql2);
	    so1.setParameter("SerialNo", sSerialNo).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("PhaseType", sPhaseType)
	    .setParameter("ApplyType", sApplyType).setParameter("FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("PhaseNo", sPhaseNo)
	    .setParameter("PhaseName", sPhaseName).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("UserName", sUserName)
	    .setParameter("OrgName", sOrgName).setParameter("BeginTime", sBeginTime);
	   
	    //执行插入语句
	    Sqlca.executeSQL(so);
	    Sqlca.executeSQL(so1);
	    	    
	    return "1";
	    
	 }

}
