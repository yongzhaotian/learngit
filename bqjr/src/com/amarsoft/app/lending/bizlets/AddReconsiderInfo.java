/*
		Author: rqiao
		describe:CCS-574 PRM-256 原地复活计划安硕系统需求
		modify:20150401
 */
package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;


import com.amarsoft.app.billions.GenerateSerialNo;
import com.amarsoft.are.util.StringFunction;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class AddReconsiderInfo {

	String serialNo ;
	String nextFlowNo ;
	String flowName ;
	String userName ;
	String orgName ;
	String ObjectType;//合同类型
	String ObjectNo;//合同编号
	String ApplyType;//Apply类型
	String FlowNo;//流程编号
	String PhaseNo;//流程阶段编号
	String UserID;//用户ID
	String OrgID;//用户所属机构
	String InputTime;//新增时间
	String sReturn = "Faile";//返回信息
	String ResurrectionReason ;//对应Code: ResurrectionReason  
	String ResurrectionReasonRemark ;//当下拉选择'其他'时  填写的其他备注 
	
	public String getResurrectionReason() {
		return ResurrectionReason;
	}

	public void setResurrectionReason(String resurrectionReason) {
		ResurrectionReason = resurrectionReason;
	}

	public String getResurrectionReasonRemark() {
		return ResurrectionReasonRemark;
	}

	public void setResurrectionReasonRemark(String resurrectionReasonRemark) {
		ResurrectionReasonRemark = resurrectionReasonRemark;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getNextFlowNo() {
		return nextFlowNo;
	}

	public void setNextFlowNo(String nextFlowNo) {
		this.nextFlowNo = nextFlowNo;
	}

	public String getFlowName() {
		return flowName;
	}

	public void setFlowName(String flowName) {
		this.flowName = flowName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getApplyType() {
		return ApplyType;
	}

	public void setApplyType(String applyType) {
		ApplyType = applyType;
	}

	public String getFlowNo() {
		return FlowNo;
	}

	public void setFlowNo(String flowNo) {
		FlowNo = flowNo;
	}

	public String getPhaseNo() {
		return PhaseNo;
	}

	public void setPhaseNo(String phaseNo) {
		PhaseNo = phaseNo;
	}
	
	public String getOrgID() {
		return OrgID;
	}

	public void setOrgID(String orgID) {
		OrgID = orgID;
	}
	
	public String getObjectType() {
		return ObjectType;
	}

	public void setObjectType(String objectType) {
		ObjectType = objectType;
	}

	public String getObjectNo() {
		return ObjectNo;
	}
	
	public void setObjectNo(String objectNo) {
		ObjectNo = objectNo;
	}

	public String getUserID() {
		return UserID;
	}

	public void setUserID(String userID) {
		UserID = userID;
	}

	public String getInputTime() {
		return InputTime;
	}

	public void setInputTime(String inputTime) {
		InputTime = inputTime;
	}
	
	public String getsReturn() {
		return sReturn;
	}

	public void setsReturn(String sReturn) {
		this.sReturn = sReturn;
	}

	/*  1)	在72小时之内拒绝的合同（以系统拒绝时间为准）；
		2)	具有原地复活权限的销售代表；
		3)	规定时间段内（当月）仍然具有复活的名额； 
		4)	只可以自己复活自己的合同。
		以上条件均为“且“的关系，必须同时满足方可复活申请。
	*/
	//满足条件的复活名额记录流水号
	private String Record_SerialNo = "";
	public String CheckReconsiderRule(Transaction Sqlca) throws Exception
	{
		try {
			//是否为自己申请的合同
			String sCount = Sqlca.getString(new SqlObject("select count(*) from Business_Contract Where SerialNo = :ObjectNo and InputUserID = :UserID").setParameter("ObjectNo", this.ObjectNo).setParameter("UserID", UserID));
			if(Integer.parseInt(sCount)>0)//如果为是，继续校验
			{
				//否决时间
				String sVetoTime = Sqlca.getString(new SqlObject("select BeginTime from Flow_Task where ObjectNo = :ObjectNo and SerialNo = (select Max(SerialNo) from Flow_Task where ObjectNo = :ObjectNo)").setParameter("ObjectNo", this.ObjectNo));
				if(null == sVetoTime) sVetoTime = "";
				//满足条件的复活名额记录
				Record_SerialNo = Sqlca.getString("select min(serialno) from Reconsider_Quota_Record where SaleID = '"+UserID+"' and RemainingQuota >=1 and to_date(substr('"+sVetoTime+"',0,10),'yyyy/mm/dd') between to_date(BeginTime,'yyyy/mm/dd') and to_date(EndTime,'yyyy/mm/dd') and ROUND(TO_NUMBER(sysdate - to_date('"+sVetoTime+"','yyyy/mm/dd hh24:mi:ss'))*24*60*60) <= 72*60*60");
				if(null == Record_SerialNo) Record_SerialNo = "";
				if(!"".equals(Record_SerialNo))//存在满足条件的复活名额记录，则允许复活，否则提示无权限
				{
					sReturn = "Success";
				}else
				{
					sReturn = "Faile";
				}
			}else//如果为否，返回校验不通过
			{
				sReturn = "Faile";
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sReturn;
	}
	
	//组装表字段
	private static ArrayList<String> ColNameList = new ArrayList<String>();
	public static ArrayList<String> InitColumns(String TableName,Transaction Sqlca) throws Exception
	{
		ASResultSet RS_COLUMNS = Sqlca.getResultSet(new SqlObject("SELECT COLUMN_NAME FROM USER_COL_COMMENTS WHERE TABLE_NAME = :TABLENAME").setParameter("TABLENAME", TableName));
		while(RS_COLUMNS.next())
		{
			ColNameList.add(RS_COLUMNS.getString("COLUMN_NAME"));
		}
		RS_COLUMNS.getStatement().close();
		
		return ColNameList;
	}
	
	//组装需要重新赋值的字段及字段值
	private static HashMap<String,String> ChangeColNameList = new HashMap<String, String>();
	public static void setValue(String name,String value) throws Exception
	{
		ChangeColNameList.put(name, value);
	}
	
	//组装SQL语句
	private static HashMap<String,String> ColumnsList = new HashMap<String,String>();
	public static void MatchColumns(String TableName,String SerialNo,Transaction Sqlca) throws Exception
	{
			ASResultSet RS_COLNAME = Sqlca.getASResultSet(new SqlObject("SELECT * FROM "+TableName+" WHERE SERIALNO = :SERIALNO").setParameter("SERIALNO", SerialNo)) ;
			if(RS_COLNAME.next())
			{
				for(int i = 0;i<ColNameList.size();i++)
				{
				  String ColValues = RS_COLNAME.getString(ColNameList.get(i));
				  if(null == ColValues) ColValues = "";
				  ColumnsList.put(ColNameList.get(i),ColValues);
				  for(Iterator itervalue = ChangeColNameList.keySet().iterator();itervalue.hasNext();)
				  {
					  String key_column = (String) itervalue.next();
					  if(key_column.equals(ColNameList.get(i)))
					  {
						  ColumnsList.remove(ColNameList.get(i)) ;
						  ColumnsList.put(key_column,ChangeColNameList.get(key_column));
					  }
				  }
				  
			    }
			}
			RS_COLNAME.getStatement().close();
			
			String InsertSQL = "INSERT INTO "+TableName+"";
			String columnClause = "";
			String valueClause = "";
			for (Iterator iter = ColumnsList.keySet().iterator(); iter.hasNext();) {
				String key = (String) iter.next();
				if(ColumnsList.get(key).length()>0)
				{
					columnClause += ","+key;
					valueClause +=  ",'"+ColumnsList.get(key)+"'";
				}
			}
			if(columnClause.length()>0) columnClause = columnClause.substring(1);
			if(valueClause.length()>0) valueClause = valueClause.substring(1);
			InsertSQL += " ( "+columnClause+") values ("+valueClause+")";
			System.out.println("InsertSQL================"+InsertSQL);
			
			Sqlca.executeSQL(InsertSQL);
	}
	
	
	//Copy原合同信息
	public String CopyContractInfo(Transaction Sqlca) throws Exception
	{
		sReturn = CheckReconsiderRule(Sqlca);
		if("Success".equals(sReturn))
		{
			try {
				//客户编号
				String sCustomerID = Sqlca.getString(new SqlObject("select CustomerID from Business_Contract Where SerialNo = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
				if(null == sCustomerID) sCustomerID = "";
				GenerateSerialNo GS = new GenerateSerialNo();
				GS.setSerialNo(sCustomerID);
				//新产生的合同编号，复活后的合同编号
				String bc_SerialNo = GS.getContractId(Sqlca);
				//新产生的申请编号
				String ba_SerialNo = DBKeyHelp.getSerialNo("Business_Contract", "SerialNo");
				setValue("SERIALNO",bc_SerialNo);//复活后的合同编号
				setValue("APPLYSERIALNO",ba_SerialNo);//申请编号
				setValue("RELATIVESERIALNO",this.ObjectNo);//原合同编号
				setValue("ISRECONSIDER","1");//是否复活合同标识（1：是）
				setValue("OCCUPYPLACESSERIALNO",Record_SerialNo);//被占用的复活名额流水号
				setValue("CONTRACTSTATUS","060");//合同状态
				setValue("INPUTUSERID",UserID);
				setValue("INPUTDATE",StringFunction.getTodayNow());
				setValue("UPDATEDATE",InputTime.substring(0, 10));
				setValue("OPERATEDATE",InputTime.substring(0, 10));
				setValue("UPLOADFLAG","");//上传标识
				setValue("UPLOADTIME","");//上次时间
				setValue("DAYRANGE","");//上次间隔时间
				setValue("FIRSTDRAWINGDATE","");
				setValue("PUTOUTDATE","");
				setValue("MATURITY","");
				setValue("LOANRATETERMID","");
				setValue("RPTTERMID","");
				setValue("MONTHREPAYMENT","");
				setValue("ORIGINALPUTOUTDATE","");

				//组装表字段
				InitColumns("BUSINESS_CONTRACT",Sqlca);
				//组装SQL语句
				MatchColumns("BUSINESS_CONTRACT",this.ObjectNo,Sqlca);
				
				//初始化流程数据
				InitializeFlow initFlow = new InitializeFlow();
				initFlow.setAttribute("ObjectType",this.ObjectType);
				initFlow.setAttribute("ObjectNo", bc_SerialNo);
				initFlow.setAttribute("ApplyType", this.ApplyType);
				initFlow.setAttribute("FlowNo", this.FlowNo);
				initFlow.setAttribute("PhaseNo", this.PhaseNo);
				initFlow.setAttribute("UserID", this.UserID);
				initFlow.setAttribute("OrgID", this.OrgID);
				initFlow.run(Sqlca);
				
				//copy合同数据
				CopyCustomerRecord ccr = new CopyCustomerRecord();
				ccr.setAttribute("SerialNo", bc_SerialNo);
				ccr.setAttribute("CustomerID", sCustomerID);
				ccr.run(Sqlca);
				
				//更新复活名额记录中的剩余名额
				Sqlca.executeSQL(new SqlObject("update Reconsider_Quota_Record set RemainingQuota = (RemainingQuota-1) where serialno = :SerialNo").setParameter("SerialNo", Record_SerialNo));
				
				sReturn = sReturn+"@"+bc_SerialNo;//如果数据处理成功，则返回新产生的合同流水号做后续核算数据的处理
				
			} catch (Exception e) {
				Sqlca.rollback();
				// TODO Auto-generated catch block
				e.printStackTrace();
			};
			
		}
		return sReturn;
	}
	
	//生成原地复活合同信息
	public String GenerateReconsiderContractInfo(Transaction Sqlca) throws Exception
	{
		sReturn = CheckReconsiderRule(Sqlca);
		if("Success".equals(sReturn))
		{
			try {
				// 执行提交操作
				SqlObject so;
				//获得开始日期、结束日期
				String sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();
				
				//在流程对象表FLOW_OBJECT中更新成一笔“新发生“的记录
				String sSql1 =  " update FLOW_OBJECT set PhaseNo=:PhaseNo ,PhaseType =:PhaseType ,PhaseName=:PhaseName,FlowNo=:FlowNo,FlowName=:FlowName " +
		        " where ObjectNo = :ObjectNo and ObjectType=:ObjectType ";
			    so = new SqlObject(sSql1);
			    so.setParameter("ObjectType", ObjectType).setParameter("ObjectNo", ObjectNo).setParameter("PhaseType", "1010")
			    .setParameter("PhaseNo", "0010").setParameter("PhaseName", "调查阶段").setParameter("FlowNo", "CreditFlow").setParameter("FlowName", "授信业务流程");
			    
			    //在流程任务表FLOW_TASK中新增一笔“新发生“的记录
			    //String sSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK","SerialNo",Sqlca);
			    String sSerialNo = DBKeyHelp.getWorkNo();
			    String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
					" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime,RELATIVESERIALNO,PHASEOPINION1) "+
					" values (:SerialNo,:ObjectType,:ObjectNo,:PhaseType,:ApplyType, " + 
					" :FlowNo,:FlowName,:PhaseNo,:PhaseName,:OrgID,:UserID, " +
					" :UserName,:OrgName,:BeginTime,:RELATIVESERIALNO,:PHASEOPINION1 )";
			    SqlObject so1 = new SqlObject(sSql2);
			    so1.setParameter("SerialNo", sSerialNo).setParameter("ObjectType", ObjectType).setParameter("ObjectNo", ObjectNo).setParameter("PhaseType", "1010")
			    .setParameter("ApplyType", ApplyType).setParameter("FlowNo", "CreditFlow").setParameter("FlowName", "授信业务流程").setParameter("PhaseNo", "0010")
			    .setParameter("PhaseName", "调查阶段").setParameter("OrgID", OrgID).setParameter("UserID", UserID).setParameter("UserName", userName)
			    .setParameter("OrgName", orgName).setParameter("BeginTime", sBeginTime).setParameter("RELATIVESERIALNO", serialNo).setParameter("PHASEOPINION1", "原地复活");
			   
//				        只修改原有合同Business_Contract的相关信息，不再去COPY一份，会更新合同状态等必要字段为“新发生“。
			    String sSql = "update BUSINESS_CONTRACT set RELATIVESERIALNO=:RELATIVESERIALNO ,ISRECONSIDER ='1' ,CONTRACTSTATUS='060',UPDATEDATE=:UPDATEDATE,OPERATEDATE=:OPERATEDATE,ResurrectionReason=:ResurrectionReason,ResurrectionReasonRemark=:ResurrectionReasonRemark " +
		        " where SerialNo = :SerialNo ";
			    SqlObject so3 = new SqlObject(sSql);
			    so3.setParameter("SerialNo", ObjectNo).setParameter("RELATIVESERIALNO", ObjectNo)
			    .setParameter("UPDATEDATE", InputTime.substring(0, 10)).setParameter("OPERATEDATE", InputTime.substring(0, 10))
			    .setParameter("ResurrectionReason", ResurrectionReason).setParameter("ResurrectionReasonRemark", ResurrectionReasonRemark);
			    
			    //执行插入和更新语句
			    Sqlca.executeSQL(so);
			    Sqlca.executeSQL(so1);
			    Sqlca.executeSQL(so3);
			    
			    //更新复活名额记录中的剩余名额
			    Sqlca.executeSQL(new SqlObject("update Reconsider_Quota_Record set RemainingQuota = (RemainingQuota-1) where serialno = :SerialNo").setParameter("SerialNo", Record_SerialNo));
				
			    //删除此复活合同在批量提单数据准备表中原有的一条记录，因为在新增的合同第一次提交时会插入一条记录
			    Sqlca.executeSQL(new SqlObject("DELETE FROM batch_bc_engine where CONTRACTNO = :SerialNo ").setParameter("SerialNo", ObjectNo));
			    
			    //删除旧合同模板数据
			    Sqlca.executeSQL(new SqlObject("DELETE FROM formatdoc_record where ObjectNo = :SerialNo ").setParameter("SerialNo", ObjectNo));
				
				sReturn = "Success";
				sReturn = sReturn+"@";//如果数据处理成功，则返回成功
				
			} catch (Exception e) {
				Sqlca.rollback();
				// TODO Auto-generated catch block
				e.printStackTrace();
			};
			
		}
		return sReturn;
	}
	
	//回滚数据（复活数据处理不成功，删除已经生成的主要数据）
	public String RollbackContractInfo(Transaction Sqlca) throws Exception 
	{
		//贷款-组合还款区段表
		Sqlca.executeSQL(new SqlObject("delete from acct_rpt_segment where objectno = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
		
		//贷款-利率区段表
		Sqlca.executeSQL(new SqlObject("delete from acct_rate_segment where objectno = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
		
		//存款账号表贷款、费用，一对多关系
		Sqlca.executeSQL(new SqlObject("delete from acct_deposit_accounts where objectno = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
		
		//复活名额记录表
		Sqlca.executeSQL(new SqlObject("update Reconsider_Quota_Record set RemainingQuota = (RemainingQuota+1) where serialno = (select OccupyPlacesSerialNo from Business_Contract where SerialNo = :ObjectNo)").setParameter("ObjectNo", this.ObjectNo));

		//合同表
		Sqlca.executeSQL(new SqlObject("delete from business_contract where serialno = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
		
		//流程记录表
		Sqlca.executeSQL(new SqlObject("delete from flow_task where objectno = :ObjectNo and ObjectType = :ObjectType").setParameter("ObjectNo", this.ObjectNo).setParameter("ObjectType", this.ObjectType));
		Sqlca.executeSQL(new SqlObject("delete from flow_object where objectno = :ObjectNo and ObjectType = :ObjectType").setParameter("ObjectNo", this.ObjectNo).setParameter("ObjectType", this.ObjectType));
		
		//费用减免信息表
		Sqlca.executeSQL(new SqlObject("delete from acct_fee_waive where objectno in(select serialno from acct_fee where objectno = :ObjectNo)").setParameter("ObjectNo", this.ObjectNo));
		
		//费用方案表
		Sqlca.executeSQL(new SqlObject("delete from acct_fee where objectno = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
		
		return "Success";
	}
}
