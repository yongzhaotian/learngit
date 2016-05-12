package com.amarsoft.biz.workflow.action;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import com.amarsoft.amarscript.ASMethod;
import com.amarsoft.app.als.rule.impl.DefaultService;
import com.amarsoft.app.als.rule.impl.RuleConnectionService;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.workflow.FlowPhase;
import com.amarsoft.biz.workflow.FlowTask;
import com.amarsoft.biz.workflow.FlowUtil;
import com.amarsoft.core.json.JSONObject;
import com.amarsoft.proj.action.CheckBusinessContractInfo;
import com.amarsoft.proj.action.P2PCreditCommon;
import com.amarsoft.amarscript.*;


/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
/*
	Author:
	Tester:
	Content: 
	Input Param:
	Output param:
	History Log: xswang 20150427 CCS-173 新增“暂停合同”和“恢复合同”功能
 */
/*~END~*/

public class FlowAction {

	private String serialNo = null;
	private String oldPhaseNo = null;
	private String objectType = null;
	private String objectNo = null;
	private String userID = null;
	private String orgID = null;
	private String orgName = null;
	private String userName = null;
	private String flowNo = null;
	private String flowName = null;
	private String applyType = null;
	private String poolMode = "2"; //任务池模式 1:旧任务池模式，2:新任务池模式
	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	
	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getFlowName() {
		return flowName;
	}

	public void setFlowName(String flowName) {
		this.flowName = flowName;
	}

	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}


	//调用规则引擎后得到新的流程号后提交给下一步
	public String AutoCommitWithRule(Transaction Sqlca) throws Exception {
		String sRet = "Success";

		ARE.getLog().info("流程执行开始，ObjectNo="+objectNo+",ObjectType="+objectType);
		
		//起线程
		DefaultService ruleService = new DefaultService();
		ruleService.setObjectNo(objectNo);
		ruleService.setObjectType(objectType);
		
		// 是否已经调用了规则引擎
		String  flowCode =ruleService.getResultJs(Sqlca);
		
//		String flowCode = "WF_MEDIUM";//WF_HARD02  WF_MEDIUM02 WF_EASY02  WF_MEDIUM02
		ARE.getLog().info("返回流程编号："+flowCode);
		// 定义变量：流程编号、阶段编号、对象编号
		String sFlowNo = "", sPhaseNo = "", sFlowName = "",sObjectNo ="",sObjectType="";
				
		String sFlowNo1 = "";

		// 定义变量：动作、动作列表、阶段的类型、动作提示、阶段的属性
		String sSql = "";
		ASResultSet rsTemp = null;

		sSql = "select FlowNo,PhaseNo,ObjectNo,ObjectType from FLOW_TASK where SerialNo = :SerialNo ";
		rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "SerialNo", serialNo));
		if (rsTemp.next()) {
			sFlowNo = DataConvert.toString(rsTemp.getString("FlowNo"));
			sPhaseNo = DataConvert.toString(rsTemp.getString("PhaseNo"));
			sObjectNo = DataConvert.toString(rsTemp.getString("ObjectNo"));
			sObjectType = DataConvert.toString(rsTemp.getString("ObjectType"));
			sFlowNo1 = DataConvert.toString(rsTemp.getString("FlowNo"));

			// 将空值转化成空字符串
			if (sFlowNo == null) sFlowNo = "";
			if (sPhaseNo == null) sPhaseNo = "";
		}
		rsTemp.getStatement().close();
		
		sFlowNo = flowCode;
		
		//规则引擎返回否决
		if(flowCode.equals("REJECT15")){
			sFlowNo = sFlowNo1;
		}
		//规则引擎返回批准
		if(flowCode.equals("APPROVE15")){
			sFlowNo = sFlowNo1;
		}
		if(flowCode == null || flowCode.trim().length() <= 0){
			
			return "RuleError";
			
			//sFlowNo = "WF_MEDIUM";
		}
		
		sSql = "select FlowName from FLOW_Catalog where FlowNo = :FlowNo ";
		rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "FlowNo", sFlowNo));
		if (rsTemp.next()) {
			sFlowName = DataConvert.toString(rsTemp.getString("FlowName"));
			// 将空值转化成空字符串
			if (sFlowName == null) sFlowName = "";
		}
		rsTemp.getStatement().close();
		
		sSql = "update FLOW_TASK set FlowNo=:FlowNo,FlowName=:FlowName  where SerialNo = :SerialNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter(
				"FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("SerialNo", serialNo));
		sSql = "update FLOW_OBJECT set FlowNo=:FlowNo,FlowName=:FlowName  where ObjectNo = :ObjectNo and ObjectType=:ObjectType";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter(
				"FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType));
		//是否自动提交
		boolean isAuto = false;
		try{
			FlowPhase flowPhase = _commit(sFlowNo, sPhaseNo, Sqlca);
			if( ! StringX.isEmpty(flowPhase.PhaseDescribe)){
				String[] strArr = StringX.parseArray(flowPhase.PhaseDescribe);
				if(strArr!=null && strArr.length>0){
					for(String str : strArr){
						String tempStr = str.replace(" ", "");
						if(tempStr.substring(0, 4).equalsIgnoreCase("AUTO")){
							isAuto = StringX.parseBoolean(tempStr.substring(5));
							break;
						}
						continue;
					}
					while(isAuto){
						//查最新的flow_task流水号
						serialNo = Sqlca.getString(new SqlObject("select serialNo from flow_task ft where ft.objectType=:objectType and ft.objectNo=:objectNo order by serialNo desc")
							.setParameter("objectType", objectType).setParameter("objectNo", objectNo));
						userID = "system";
						rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "SerialNo", serialNo));
						if (rsTemp.next()) {
							sFlowNo = DataConvert.toString(rsTemp.getString("FlowNo"));
							sPhaseNo = DataConvert.toString(rsTemp.getString("PhaseNo"));
							// 将空值转化成空字符串
							if (sFlowNo == null) sFlowNo = "";
							if (sPhaseNo == null) sPhaseNo = "";
						}
						flowPhase = _commit(sFlowNo, sPhaseNo, Sqlca);
						if(! StringX.isEmpty(flowPhase.PhaseDescribe) ){
							strArr = StringX.parseArray(flowPhase.PhaseDescribe);
							if(strArr!=null && strArr.length>0){
								for(String str : strArr){
									String tempStr = str.replace(" ", "");
									if(tempStr.substring(0, 4).equalsIgnoreCase("AUTO")){
										isAuto = StringX.parseBoolean(tempStr.substring(5));
										break;
									}
									continue;
								}
							}else{
								isAuto = false;
							}
						}else{
							isAuto = false;
						}
					}
				}else{
					isAuto = false;
				}
			}else{
				isAuto = false;
			}
			ARE.getLog().info("流程执行结束，ObjectNo="+objectNo+",ObjectType="+objectType);
		}catch(Exception e){
			Sqlca.rollback();
			
			String msg = e.getMessage();
			if("Working".equals(msg)) 
				sRet = "Working";
			else
				sRet = "Failure";
			ARE.getLog().error("任务提交出错!", e);
		}

		//Sqlca.executeSQL(new SqlObject("update business_contract set contractStatus='070' where serialno=:serialno").setParameter("serialno", sObjectNo));
		
		//判断P2P占用
		P2PCreditCommon p2p = new P2PCreditCommon(objectNo, Sqlca);
		boolean b = p2p.isUseP2P();
		ARE.getLog().debug("P2P判断结束,合同"+objectNo+"是否为P2P合同"+b+"，结束时间为："+StringFunction.getNow());
		
		//判断合同的销售经理或城市经理是否为空。
		CheckBusinessContractInfo checkBC = new CheckBusinessContractInfo();
		checkBC.checkBCManager(Sqlca, objectNo);
		
		return sRet;
	}
	
	/**
	 * 专家审核提交
	 * @param sFlowNo
	 * @param sPhaseNo
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String AutoCommitWithRuleEnd(Transaction Sqlca) throws Exception {
		//起线程
		DefaultService ruleService = new DefaultService();
		ruleService.setObjectNo(objectNo);
		ruleService.setObjectType(objectType);
		String flowCode = ruleService.getResultHq(Sqlca);
		//String flowCode = "WF_MEDIUM02";//WF_HARD02  WF_MEDIUM02 WF_EASY02
		System.out.println("返回流程编号："+flowCode);

		System.out.println("===================================================合同编号："+objectNo);
		
		//add CCS-488 PRM-185 消费贷后期决策引擎无法调动，导致post_data表中无数据 by rqiao 20150415
		//根据产品类型查询后期规则返回结果存储表表名
		ASResultSet rs = null;
		String sProductID = "";//产品类型
		String sAfterCallRulesNumber = "0";//后期调用规则引擎次数
		String sColumnName = "Attribute1";//规则返回结果存储表名维护字段，默认字段名为Attribute1
		rs = Sqlca.getASResultSet(new SqlObject("select ProductID,AfterCallRulesNumber from Business_Contract where SerialNo = :objectNo").setParameter("objectNo", objectNo));
		if(rs.next())
		{
			sProductID = rs.getString("ProductID");
			if(null == sProductID) sProductID = "";
			sAfterCallRulesNumber = rs.getString("AfterCallRulesNumber");
			if(null == sAfterCallRulesNumber) sAfterCallRulesNumber = "0";
		}
		rs.getStatement().close();
		//如果为现金贷，则取值字段为Attribute2
		if("020".equals(sProductID))
		{
			sColumnName = "Attribute2";
		}
		//规则返回结果存储表表名
		String sResultTable = Sqlca.getString(new SqlObject("select "+sColumnName+" from Code_Library where CodeNo = 'RuleDataType' and ItemNo = '03'").setParameter("objectNo", objectNo));
		if(null == sResultTable) sResultTable = "";
		//查询后期规则返回结果存储表中有无记录
		String sCount = Sqlca.getString(new SqlObject("select count(*) from "+sResultTable+" where ApplyNo = :objectNo").setParameter("objectNo", objectNo));
		//没有成功保存规则返回信息且重复调用规则
		if(Integer.parseInt(sCount)<1 && Integer.parseInt(sAfterCallRulesNumber)<3) 
		{
			Sqlca.executeSQL(new SqlObject("Update Business_Contract set AfterCallRulesNumber = "+sAfterCallRulesNumber+"+1 where SerialNo = :ObjectNo").setParameter("ObjectNo", objectNo));
			return "Failure";
		}
		//end

		return this.AutoCommit(Sqlca);
	}
	
	private FlowPhase _commit(String sFlowNo, String sPhaseNo, Transaction Sqlca) throws Exception{
		String sSelectStyle = "", sPhaseAttribute = "", sPhaseOpinion1[], 
				minTime = null, maxTime = null, sPhaseAction = null,returnValue;
		
		int uNum = Sqlca.executeSQL(new SqlObject("update FLOW_TASK set EndTime=EndTime where SerialNo=:SerialNo and (EndTime is null or EndTime = '') ").setParameter("SerialNo", serialNo));
		if(uNum<=0) throw new Exception("Working");
		
		FlowPhase flowphase = null;
		ASResultSet rsTemp = null;
		// 从流程模型表FLOW_MODEL中查询出阶段属性、阶段描述
				String sSql = "select PhaseAttribute,ActionDescribe,StandardTime1,StandardTime2 from FLOW_MODEL where FlowNo = :FlowNo and PhaseNo = :PhaseNo";
				rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter(
						"FlowNo", sFlowNo).setParameter("PhaseNo", sPhaseNo));
				if (rsTemp.next()) {
					sPhaseAttribute = DataConvert.toString(rsTemp.getString("PhaseAttribute"));
					// 将空值转化成空字符串
					if (sPhaseAttribute == null) sPhaseAttribute = "";
					
					sSelectStyle = StringFunction.getProfileString(sPhaseAttribute,"ActionStyle");
					if (sSelectStyle == null) sSelectStyle = "";
					
					minTime = DataConvert.toString(rsTemp.getString("StandardTime1"));
					maxTime = DataConvert.toString(rsTemp.getString("StandardTime2"));
				}
				rsTemp.getStatement().close();
				rsTemp = null;

				// 初始化任务对象
				FlowTask ftBusiness = new FlowTask(serialNo, Sqlca);
				
				sPhaseOpinion1 = ftBusiness.getChoiceList();
				if (sPhaseOpinion1 == null) {
					sPhaseOpinion1 = new String[1];
					sPhaseOpinion1[0] = "";
				}

				String sPhaseInfo = "", sNextPhaseName = "", sNextPhaseNo = "", sNextPhaseNameStr = "";

				// 检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）。
				ASMethod asm = new ASMethod("WorkFlowEngine", "GetEndTime", Sqlca);
				Any anyValue = asm.execute(serialNo);
				String endTime = anyValue.toString();

				/*FlowUtil fu = new FlowUtil();
				fu.setSerialNo(serialNo);
				fu.setPhaseOpinion(sPhaseOpinion1[0]);
				fu.setFlowNo(sFlowNo);
				fu.setPhaseNo(sPhaseNo);
				String roleSubmit = fu.isRoleSubmit(Sqlca);
				String roleUsers = fu.getRoleSubmitUsers(Sqlca);*/
				String roleUsers = "";
				String[] actionArr = ftBusiness.getActionList(sPhaseOpinion1[0]);
				for(String action : actionArr){
					roleUsers = roleUsers + action.split(" ")[0]+",";
				}
				if(roleUsers.length()>0){
					roleUsers = roleUsers.substring(0, roleUsers.length()-1);
				}
				ARE.getLog().info("角色用户roleUsers: "+roleUsers);
				if(roleUsers.contains(userID)){
					sPhaseAction = userID;
				}else{
					sPhaseAction = roleUsers;
					if("2".equals(poolMode)){
						sPhaseAction = "";
					}
				}
				/*if ("1".equals(roleSubmit)) {
					sPhaseAction = roleUsers;
				} else {
					sPhaseAction = roleUsers.split(",")[0];
				}*/

				if (endTime.length() > 0) {
					throw new Exception("Working");// 该放贷申请已经提交了，不能再次提交！
				} else {
					// 执行提交操作
					FlowPhase[] fpFlow = ftBusiness.commitAction(sPhaseAction, sPhaseOpinion1[0]);

					for (int i = 0; i < fpFlow.length; i++) {
						flowphase = fpFlow[i];
						// 获取下一阶段的阶段名称
						sNextPhaseName = flowphase.PhaseName;
						sNextPhaseNo = flowphase.PhaseNo;
						sNextPhaseNameStr += sNextPhaseName + ";";
					}

					// 拼出提示信息
					sPhaseInfo = "下一阶段:";
					sPhaseInfo = sPhaseInfo + " " + sNextPhaseNameStr;
					if (sPhaseInfo != null && sPhaseInfo.trim().length() > 0) {
						returnValue = "Success";
					} else {
						throw new Exception("Failure");
					}
				}
				String now = StringFunction.getTodayNow();
				String EndTime = now;
				
				if(!StringX.isEmpty(maxTime) && !StringX.isEmpty(minTime) && !userID.equals(roleUsers)){
					Random rand = new Random();
					int maxInt = Integer.valueOf(maxTime);
					int minInt = Integer.valueOf(minTime);
					if(maxInt>0 && minInt>=0 && maxInt>minInt){
						int a = maxInt-minInt+1;
						int x = rand.nextInt(a)+Integer.valueOf(minTime);
						Date cDate = new Date();
						int minutes=cDate.getMinutes();
						minutes=minutes+x;
						cDate.setMinutes(minutes);
						EndTime = sdf.format(cDate);
					}
				}
				
				EndTime = now;
				//更新提交之前的任务，设置endTime(可能有延时的结束时间), phaseOpinion4(真正的结束时间)
				sSql = "update FLOW_TASK set EndTime = :EndTime, phaseOpinion4=:now where SerialNo =:SerialNo";
				Sqlca.executeSQL(new SqlObject(sSql)
					.setParameter("EndTime", EndTime)
					.setParameter("Now", now)
					.setParameter("SerialNo", serialNo));
				//更新最新的任务，设置beginTime(可能有延时的),
				sSql = "update FLOW_TASK set BeginTime = :BeginTime where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
				Sqlca.executeSQL(new SqlObject(sSql)
						.setParameter("BeginTime", EndTime)
						.setParameter("ObjectNo", objectNo)
						.setParameter("ObjectType", objectType)
						.setParameter("PhaseNo", sNextPhaseNo));
	
				if("2".equals(poolMode)){
					sSql = "update FLOW_TASK set GroupInfo=:GroupInfo where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
					Sqlca.executeSQL(new SqlObject(sSql)
							.setParameter("GroupInfo", roleUsers)
							.setParameter("ObjectNo", objectNo)
							.setParameter("ObjectType", objectType)
							.setParameter("PhaseNo", sNextPhaseNo));
				}
				//
				//如果提交到的人员包括当前用户，则把任务分配到当前用户, 并把真正的开始时间设置到phaseOpinion3
				//如果是汽车贷款第一阶段不更新TaskState
				if(sFlowNo.startsWith("CarFlow") &&"0010".equals(oldPhaseNo) && "0020".equals(sNextPhaseNo)){
					sSql = "update FLOW_TASK set  phaseOpinion3=:now where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and UserID=:UserID";
				}else{
					if(sFlowNo.startsWith("NCIIC_AUTO15") && sNextPhaseNo.equals("0077") ){
						System.out.println("------------------------------");
					     sSql="update FLOW_TASK set TaskState = '1', phaseOpinion3=:now where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
					}else{
						sSql="update FLOW_TASK set TaskState = '1', phaseOpinion3=:now where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and UserID=:UserID";	

					}
				}
				Sqlca.executeSQL(new SqlObject(sSql)
						.setParameter("now", now)
						.setParameter("ObjectNo", objectNo)
						.setParameter("ObjectType", objectType)
						.setParameter("UserID", userID)
						.setParameter("PhaseNo", sNextPhaseNo));
			    
				/*if (userID != null && roleUsers.contains(userID)) {
					sSql = "update FLOW_TASK set TaskState = '0' where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
					Sqlca.executeSQL(new SqlObject(sSql)
							.setParameter("ObjectNo", objectNo)
							.setParameter("ObjectType", objectType)
							.setParameter("PhaseNo", sNextPhaseNo));
					sSql = "update FLOW_TASK set TaskState = '1' where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and UserID=:UserID";
					Sqlca.executeSQL(new SqlObject(sSql)
							.setParameter("ObjectNo", objectNo)
							.setParameter("ObjectType", objectType)
							.setParameter("UserID", userID)
							.setParameter("PhaseNo", sNextPhaseNo));
				}*/
				
				
				//下阶段为批准、附条件批准，更新合同状态
				//if(sNextPhaseNo.equals("1000") || sNextPhaseNo.equals("2000")){//已批准 080
				//	sSql = "update business_contract set contractstatus = '080' where SerialNo = :Serialno";
				//}else if(sNextPhaseNo.equals("8000")){//已否决 010
				//	sSql = "update business_contract set contractstatus = '010' where SerialNo = :Serialno";
				//}else if(sNextPhaseNo.equals("9000")){//已取消
				//	sSql = "update business_contract set contractstatus = '100' where SerialNo = :Serialno";
				//}else{//新发生
				//	if (!sNextPhaseNo.equals("0010")) {
				//		sSql = "update business_contract set contractstatus = '070' where SerialNo = :Serialno";
				//	} else {
				//		sSql = "update business_contract set contractstatus = '060' where SerialNo = :Serialno";
				//	}
				//}
				//Sqlca.executeSQL(new SqlObject(sSql).setParameter("Serialno", objectNo));
			
				
				
				
				return flowphase;
	}
	
	//判断当前流程是否为增加主观判断
	public String AutoFlagCommint(Transaction Sqlca){
		String sSql = "";
		String sFlowNo = "",sPhaseNo = "",sPhaseName = "";
		String sRet = "";
		ASResultSet rsTemp = null;
		try {
			sSql = "select FlowNO,PhaseNo,PhaseName from Flow_Task where SerialNo =:SerialNo";
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "SerialNo", serialNo));
			if(rsTemp.next()){
				sFlowNo = DataConvert.toString(rsTemp.getString("FlowNo"));
				sPhaseNo = DataConvert.toString(rsTemp.getString("PhaseNo"));
				sPhaseName = DataConvert.toString(rsTemp.getString("PhaseName"));
				
				// 将空值转化成空字符串
				if (sFlowNo == null) sFlowNo = "";
				if (sPhaseNo == null) sPhaseNo = "";
				if (sPhaseName == null) sPhaseName = "";
			}
			rsTemp.getStatement().close();
			//获取阶段中文名
			//update CCS-749 PRM-368 消费贷NCIIC_AUTO15流程部分合同后期决策引擎无法调动，导致post_data表中无数据  by rqiao 20150507
			//if((sPhaseName.startsWith("增加") || sPhaseName.startsWith("主观判断")) && !sFlowNo.startsWith("NCIIC_AUTO15")){
			if((sPhaseName.startsWith("增加") || sPhaseName.startsWith("主观判断"))){
			//end
				try { 
					//sRet = this.AutoCommitWithRuleEnd(Sqlca);
					InsertAutoRuleAction insertAutoRuleAction=new InsertAutoRuleAction();
					sRet=insertAutoRuleAction.addData(serialNo,objectType,objectNo,oldPhaseNo,userID,Sqlca);
					//更改任务属性 刷新后看不到当前任务
 				    sSql = "update FLOW_TASK set subFlag = '1'  where SerialNo =:SerialNo ";
 					    Sqlca.executeSQL(new SqlObject(sSql)
 							.setParameter("SerialNo", serialNo));
 					    
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else{
				sRet = this.AutoCommit(Sqlca);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return sRet;
	}

	// 自动提交程序 默认提交到第一个选择的第一个人
	public String AutoCommit(Transaction Sqlca)   {
		
		ARE.getLog().info("流程执行开始，ObjectNo="+objectNo+",ObjectType="+objectType);
		// 定义变量：流程编号、阶段编号、对象编号
		String sFlowNo = "", sPhaseNo = "", sRet = "Success";

		// 定义变量：动作、动作列表、阶段的类型、动作提示、阶段的属性
		String sSql = "";
		ASResultSet rsTemp = null;

		sSql = "select FlowNo,PhaseNo from FLOW_TASK where SerialNo = :SerialNo ";
		try{
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "SerialNo", serialNo));
			if (rsTemp.next()) {
				sFlowNo = DataConvert.toString(rsTemp.getString("FlowNo"));
				sPhaseNo = DataConvert.toString(rsTemp.getString("PhaseNo"));
				// 将空值转化成空字符串
				if (sFlowNo == null) sFlowNo = "";
				if (sPhaseNo == null) sPhaseNo = "";
			}
			rsTemp.getStatement().close();
		}catch(Exception e){
			ARE.getLog().error("获取flowno,phaseno 出错!", e);
		}

		boolean isAuto = false;
		try{
			FlowPhase flowPhase = _commit(sFlowNo, sPhaseNo, Sqlca);
			
			if( ! StringX.isEmpty(flowPhase.PhaseDescribe)){
				String[] strArr = StringX.parseArray(flowPhase.PhaseDescribe);
				if(strArr!=null && strArr.length>0){
					for(String str : strArr){
						String tempStr = str.replace(" ", "");
						if(tempStr.substring(0, 4).equalsIgnoreCase("AUTO")){
							isAuto = StringX.parseBoolean(tempStr.substring(5));
							break;
						}
						continue;
					}
					while(isAuto){
						//查最新的flow_task流水号
						serialNo = Sqlca.getString(new SqlObject("select serialNo from flow_task ft where ft.objectType=:objectType and ft.objectNo=:objectNo order by serialNo desc")
							.setParameter("objectType", objectType).setParameter("objectNo", objectNo));
						userID = "system";
						rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "SerialNo", serialNo));
						if (rsTemp.next()) {
							sFlowNo = DataConvert.toString(rsTemp.getString("FlowNo"));
							sPhaseNo = DataConvert.toString(rsTemp.getString("PhaseNo"));
							// 将空值转化成空字符串
							if (sFlowNo == null) sFlowNo = "";
							if (sPhaseNo == null) sPhaseNo = "";
						}
						rsTemp.getStatement().close();
						flowPhase = _commit(sFlowNo, sPhaseNo, Sqlca);
						if(! StringX.isEmpty(flowPhase.PhaseDescribe) ){
							strArr = StringX.parseArray(flowPhase.PhaseDescribe);
							if(strArr!=null && strArr.length>0){
								for(String str : strArr){
									String tempStr = str.replace(" ", "");
									if(tempStr.substring(0, 4).equalsIgnoreCase("AUTO")){
										isAuto = StringX.parseBoolean(tempStr.substring(5));
										break;
									}
									continue;
								}
							}else{
								isAuto = false;
							}
						}else{
							isAuto = false;
						}
					}
				}else{
					isAuto = false;
				}
			}else{
				isAuto = false;
			}
			ARE.getLog().info("流程执行结束，ObjectNo="+objectNo+",ObjectType="+objectType);
		}catch(Exception e){
			try{
				Sqlca.rollback();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			sRet = "Failure";
			ARE.getLog().error("任务提交出错!", e);
		}
		return sRet;
	}
	
	// 点击"否决申请"按钮进入否决阶段 PRM-477 销售经理可以否决审核中的申请 add by huanghui 20150722
	@SuppressWarnings("deprecation")
	public String vetoApply(Transaction Sqlca) throws Exception {
		String returnValue;
		try{
			// 检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）。
			ASMethod asm = new ASMethod("WorkFlowEngine", "GetEndTime", Sqlca);
			Any anyValue = asm.execute(serialNo);
			String endTime = anyValue.toString();
			
			String sSql="delete from  FLOW_TASK where ObjectType = :ObjectType and ObjectNo= :ObjectNo and FlowNo = :FlowNo and PhaseNo = :PhaseNo and UserID <> :UserID and (EndTime is null or EndTime = '') ";						  
			Sqlca.executeSQL(new SqlObject(sSql)
			.setParameter("ObjectNo", objectNo)
			.setParameter("ObjectType", objectType)
			.setParameter("PhaseNo", oldPhaseNo)
			.setParameter("FlowNo", flowNo)
			.setParameter("UserID", userID)
					);
			
			if (endTime.length() > 0) {
				returnValue = "Working";// 该放贷申请已经提交了，不能再次提交！
			} else {
				// 执行提交操作
				SqlObject so;
				//获得开始日期、结束日期
				String sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();
				String sEndTime = StringFunction.getToday()+" "+StringFunction.getNow();
				//在流程任务表FLOW_TASK中更新上一个阶段的结束时间即否决时间
				String sSql3 =  " update FLOW_TASK set EndTime=:EndTime  " +
						" where SerialNo = :SerialNo ";
				SqlObject so2 = new SqlObject(sSql3);
				so2.setParameter("EndTime", sEndTime).setParameter("SerialNo", serialNo);
				
				//在流程对象表FLOW_OBJECT中新增一笔否决信息
				String sSql1 =  " update FLOW_OBJECT set PhaseNo=:PhaseNo ,PhaseType =:PhaseType ,PhaseName=:PhaseName " +
		        " where ObjectNo = :ObjectNo and ObjectType=:ObjectType ";
			    so = new SqlObject(sSql1);
			    so.setParameter("ObjectType", objectType).setParameter("ObjectNo", objectNo).setParameter("PhaseType", "1050")
			    .setParameter("PhaseNo", "8000").setParameter("PhaseName", "已否决");
			    //在流程任务表FLOW_TASK中新增一笔否决信息
			    String sSerialNo = DBKeyHelp.getWorkNo();
			    String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
					" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime,EndTime,RELATIVESERIALNO,PHASEOPINION1) "+
					" values (:SerialNo,:ObjectType,:ObjectNo,:PhaseType,:ApplyType, " + 
					" :FlowNo,:FlowName,:PhaseNo,:PhaseName,:OrgID,:UserID, " +
					" :UserName,:OrgName,:BeginTime,:EndTime,:RELATIVESERIALNO,:PHASEOPINION1 )";
			    SqlObject so1 = new SqlObject(sSql2);
			    so1.setParameter("SerialNo", sSerialNo).setParameter("ObjectType", objectType).setParameter("ObjectNo", objectNo).setParameter("PhaseType", "1050")
			    .setParameter("ApplyType", applyType).setParameter("FlowNo", flowNo).setParameter("FlowName", flowName).setParameter("PhaseNo", "8000")
			    .setParameter("PhaseName", "已否决").setParameter("OrgID", orgID).setParameter("UserID", userID).setParameter("UserName", userName)
			    .setParameter("OrgName", orgName).setParameter("BeginTime", sBeginTime).setParameter("EndTime", sEndTime).setParameter("RELATIVESERIALNO", serialNo).setParameter("PHASEOPINION1", "否决");
			   
			    //执行插入语句
			    Sqlca.executeSQL(so);
			    Sqlca.executeSQL(so1);
			    Sqlca.executeSQL(so2);
			    
				returnValue = "Success";
			}
		
//		 更新合同'能否原地复活 值为2，1=可以，2=不可以';
		sSql = "update business_contract set AllowReconsider = '2' where SerialNo = :Serialno";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("Serialno", objectNo));
		}catch(Exception e){
			returnValue = "Failure";
		}
		return returnValue;
	}
	
	// 点击"取消"按钮进入取消阶段
	public String CancelTask(Transaction Sqlca) throws Exception {

		String returnValue;

		// 初始化任务对象
		FlowTask ftBusiness = new FlowTask(serialNo, Sqlca);

		String sPhaseInfo = "", sNextPhaseName = "", sNextPhaseNameStr = "";

		// 检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）。
		ASMethod asm = new ASMethod("WorkFlowEngine", "GetEndTime", Sqlca);
		Any anyValue = asm.execute(serialNo);
		String endTime = anyValue.toString();

		String sSql="delete from  FLOW_TASK where ObjectType = :ObjectType and ObjectNo= :ObjectNo and FlowNo = :FlowNo and PhaseNo = :PhaseNo and UserID <> :UserID and (EndTime is null or EndTime = '') ";						  
		Sqlca.executeSQL(new SqlObject(sSql)
						.setParameter("ObjectNo", objectNo)
						.setParameter("ObjectType", objectType)
						.setParameter("PhaseNo", oldPhaseNo)
						.setParameter("FlowNo", flowNo)
						.setParameter("UserID", userID)
						);


		if (endTime.length() > 0) {
			returnValue = "Working";// 该放贷申请已经提交了，不能再次提交！
		} else {
			// 执行提交操作
			FlowPhase flowphase = null;
			FlowPhase[] fpFlow = ftBusiness.commitAction("","取消");

			for (int i = 0; i < fpFlow.length; i++) {
				flowphase = fpFlow[i];
				// 获取下一阶段的阶段名称
				sNextPhaseName = flowphase.PhaseName;
				sNextPhaseNameStr += sNextPhaseName + ";";
			}

			// 拼出提示信息
			sPhaseInfo = "下一阶段:";
			sPhaseInfo = sPhaseInfo + " " + sNextPhaseNameStr;
			if (sPhaseInfo != null && sPhaseInfo.trim().length() > 0) {
				returnValue = "Success";
			} else {
				returnValue = "Failure";
			}
		}
		// 更新合同状态取消100 add by tbzeng 2014/06/26
		//sSql = "update business_contract set contractstatus = '100' where SerialNo = :Serialno";
		//Sqlca.executeSQL(new SqlObject(sSql).setParameter("Serialno", objectNo));
		
		return returnValue;
	}
	
	

	// 任务池获取任务
	public String getTask(Transaction Sqlca) throws Exception {
		String serialNo = "",objectNo = "",objectType = "", beginTime ="",sSql = "";
		ASResultSet rsTemp;
		flowNo = flowNo.replace("@", ",");
		if("2".equals(poolMode)){
			// edit by xswang 20150519 CCS-173 新增“暂停合同”和“恢复合同”功能
			// 增加一个判断条件，被暂停的合同不在获取范围内
			sSql = " select ft.SerialNo,ft.ObjectNo,ft.ObjectType,ft.BeginTime,FTOld.PriBeginTime from FLOW_TASK ft,BUSINESS_CONTRACT bc,Flow_Task FTOld where "+
					" ft.objectno=bc.serialno "+
					" and (bc.cancelstatus is null or bc.cancelstatus <> '1') "+
					" and ft.flowNo in"+flowNo+" and ft.GroupInfo like :UserID "+
					//"and (ft.EndTime is null or ft.EndTime = '') and  (ft.TaskState is null or ft.TaskState = '') order by ft.beginTime ";
					// add by xswang 20150722 CCS-811 优先审核时间配置:按新字段排序获取任务
					" and (ft.EndTime is null or ft.EndTime = '') and  (ft.TaskState is null or ft.TaskState = '') " +
					" and FTOld.ObjectNo = ft.objectno and FTOld.ObjectType =ft.ObjectType and FTOld.PhaseName = 'NCIIC信息自动检查' "+
					"  order by FTOld.PriBeginTime ";
					// end 
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", "%"+userID+"%"));
		}else{
			sSql = " select ft.SerialNo,ft.ObjectNo,ft.ObjectType,ft.BeginTime,FTOld.PriBeginTime from FLOW_TASK ft,BUSINESS_CONTRACT bc,Flow_Task FTOld where "+
					" ft.objectno=bc.serialno "+
					" and (bc.cancelstatus is null or bc.cancelstatus <> '1') "+
					" and ft.flowNo in"+flowNo+" and ft.UserID =:UserID "+
					//"and (ft.EndTime is null or ft.EndTime = '') and  (ft.TaskState is null or ft.TaskState = '') order by ft.beginTime ";
					// add by xswang 20150722 CCS-811 优先审核时间配置:按新字段排序获取任务
					" and (ft.EndTime is null or ft.EndTime = '') and  (ft.TaskState is null or ft.TaskState = '') " +
					" and FTOld.ObjectNo = ft.objectno and FTOld.ObjectType =ft.ObjectType and FTOld.PhaseName = 'NCIIC信息自动检查' "+
					" order by ft.PriBeginTime ";
					// end
			// end by xswang 20150519
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", userID));
		}
		if (rsTemp.next()) {
			serialNo = rsTemp.getString("SerialNo");
			objectNo = rsTemp.getString("objectNo");
			objectType = rsTemp.getString("objectType");
			beginTime = rsTemp.getString("BeginTime");
			long lBeginTime = Long.valueOf(beginTime.replace("/", "").replace(" ", "").replace(":", ""));
			long cTime = Long.valueOf(StringFunction.getTodayNow().replace("/", "").replace(" ", "").replace(":", ""));
			ARE.getLog().trace("beginTime:"+lBeginTime+"; 当前时间："+cTime);
			/*if(lBeginTime>=cTime){
				continue;
			}*/
			
			//判断当前用户是否有待审任务
			ASResultSet rsuser = null;
			sSql = "select count(1) as iCount from Flow_Task where UserId = :UserID and (EndTime is null or EndTime = '') and TaskState = '1' and (subFlag is null or subFlag ='') ";
			rsuser = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", userID));
			if(rsuser.next()){
				int icount = rsuser.getInt("iCount");
				if(icount > 0) return "FailError";
			}
			rsuser.getStatement().close();
			
			// add by xswang 20150427 CCS-173 新增“暂停合同”和“恢复合同”功能
			ASResultSet rs1 = null;
			//从合同表中取当前合同的“cancelstatus”标识
			sSql = "select cancelstatus from business_contract where serialno = :ObjectNo ";
			rs1 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo", objectNo));
			if(rs1.next()){
				String Cancel = rs1.getString("cancelstatus");
				if("1".equals(Cancel)){// 为“1”表示该合同已经被暂停
					return "CancelError";
				}
			}
			rs1.getStatement().close();
			// end by xswang 20150427
			
			sSql = "update FLOW_TASK set TaskState = '0' where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
			Sqlca.executeSQL(new SqlObject(sSql)
					.setParameter("ObjectNo", objectNo)
					.setParameter("ObjectType", objectType)
					.setParameter("PhaseNo", oldPhaseNo));
			
			sSql = "update FLOW_TASK set TaskState = TaskState where ObjectNo =:ObjectNo and ObjectType=:ObjectType";
			Sqlca.executeSQL(new SqlObject(sSql)
			.setParameter("ObjectNo", objectNo)
			.setParameter("ObjectType", objectType));
			
			sSql = "update FLOW_TASK set TaskState = '1'"
					+ ", phaseOpinion3=:Now " //把任务获取时间设置到phaseOpinion3上
					+ "where SerialNo = :SerialNo";
			int i = Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo",serialNo)
					.setParameter("Now", StringFunction.getTodayNow()));
			if(i <= 0) {
				rsTemp.getStatement().close();
				rsTemp = null;
				return "Failure";
			}
			String UserName = "",OrgID="",OrgName="";
			if("2".equals(poolMode)){
				sSql = "select ui.userName,oi.orgid,oi.orgname from user_info ui ,org_info oi where UserID = :UserID and ui.belongorg = oi.orgid";
				rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", userID));
				while (rsTemp.next()) {
					UserName = rsTemp.getString("UserName");
					OrgID = rsTemp.getString("OrgID");
					OrgName = rsTemp.getString("OrgName");
				}
				
				sSql = "update FLOW_TASK set UserID = :UserID ,UserName=:UserName,OrgID=:OrgID,OrgName=:OrgName "
						+ "where SerialNo = :SerialNo";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo",serialNo)
						.setParameter("UserID", userID)
						.setParameter("UserName", UserName)
						.setParameter("OrgID", OrgID)
						.setParameter("OrgName", OrgName));
			}
			
			String sPhaseNo = Sqlca.getString(new SqlObject("select phaseno from flow_task where serialno =:serialno").setParameter("serialno", serialNo));
			
			Sqlca.executeSQL(new SqlObject("delete from FLOW_TASK where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and serialno <> '"+serialNo+"'")
							.setParameter("ObjectNo", objectNo)
							.setParameter("ObjectType", objectType)
							.setParameter("PhaseNo", sPhaseNo));
			rsTemp.getStatement().close();
			rsTemp = null;
			return objectNo+"@"+objectType;
		} 
		rsTemp.getStatement().close();
		rsTemp = null;
		return "Failure";
	}
	
	
	// 任务池获取任务
		public String getTaskCar(Transaction Sqlca) throws Exception {
			String serialNo = "",objectNo = "",objectType = "", beginTime ="",sSql="";
			ASResultSet rsTemp;
			
			if("2".equals(poolMode)){
				sSql = "select SerialNo,ObjectNo,ObjectType,BeginTime from FLOW_TASK where flowNo=:flowNo and  PhaseNo = :PhaseNo and " +
						"GroupInfo like :UserID and (EndTime is null or EndTime = '') and  (TaskState is null or TaskState = '') order by beginTime ";
				rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
								.setParameter("flowNo", flowNo).setParameter("PhaseNo", oldPhaseNo)
								.setParameter("UserID", "%"+userID+"%"));
			}else{
				sSql = "select SerialNo,ObjectNo,ObjectType,BeginTime from FLOW_TASK where flowNo=:flowNo and  PhaseNo = :PhaseNo and " +
						"UserID = :UserID and (EndTime is null or EndTime = '') and  (TaskState is null or TaskState = '') order by beginTime ";
				rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
						.setParameter("flowNo", flowNo).setParameter("PhaseNo", oldPhaseNo)
						.setParameter("UserID", userID));
			}
			while (rsTemp.next()) {
				serialNo = rsTemp.getString("SerialNo");
				objectNo = rsTemp.getString("objectNo");
				objectType = rsTemp.getString("objectType");
				beginTime = rsTemp.getString("BeginTime");
				long lBeginTime = Long.valueOf(beginTime.replace("/", "").replace(" ", "").replace(":", ""));
				long cTime = Long.valueOf(StringFunction.getTodayNow().replace("/", "").replace(" ", "").replace(":", ""));
				ARE.getLog().trace("beginTime:"+lBeginTime+"; 当前时间："+cTime);
				if(lBeginTime>=cTime){
					continue;
				}
				sSql = "update FLOW_TASK set TaskState = '0' where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
				Sqlca.executeSQL(new SqlObject(sSql)
						.setParameter("ObjectNo", objectNo)
						.setParameter("ObjectType", objectType)
						.setParameter("PhaseNo", oldPhaseNo));
				sSql = "update FLOW_TASK set TaskState = '1'"
						+ ", phaseOpinion3=:Now " //把任务获取时间设置到phaseOpinion3上
						+ "where SerialNo = :SerialNo";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo",serialNo)
						.setParameter("Now", StringFunction.getTodayNow()));
				
				String UserName = "",OrgID="",OrgName="";
				if("2".equals(poolMode)){
					sSql = "select ui.userName,oi.orgid,oi.orgname from user_info ui ,org_info oi where UserID = :UserID and ui.belongorg = oi.orgid";
					rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", userID));
					while (rsTemp.next()) {
						UserName = rsTemp.getString("UserName");
						OrgID = rsTemp.getString("OrgID");
						OrgName = rsTemp.getString("OrgName");
					}
					sSql = "update FLOW_TASK set UserID = :UserID ,UserName=:UserName,OrgID=:OrgID,OrgName=:OrgName "
							+ "where SerialNo = :SerialNo";
					Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo",serialNo)
							.setParameter("UserID", userID)
							.setParameter("UserName", UserName)
							.setParameter("OrgID", OrgID)
							.setParameter("OrgName", OrgName));
				}
				return "Success";
			} 
			rsTemp.getStatement().close();
			rsTemp = null;
			return "Failure";
		}
	
	//获取到任务之后，点击审核按钮，则设置标志----暂设置到groupId上(Y:表示点击过审核按钮)
	public String setClicked(Transaction Sqlca){
		String sRet = "Success";
		try {
			Sqlca.executeSQL(new SqlObject("update FLOW_TASK set groupId =:clicked where ObjectNo=:ObjectNo and ObjectType=:ObjectType and SerialNo=:SerialNo ")
				.setParameter("clicked", "Y").setParameter("ObjectNo", objectNo)
				.setParameter("ObjectType", objectType).setParameter("SerialNo", serialNo));
		} catch (Exception e) {
			try{
				Sqlca.rollback();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			ARE.getLog().error("设置获取到的任务状态为'审核中'时,出错!", e);
			sRet = "Failure";
		}
		return sRet;
	}

	// 将任务退回任务池
	public String returnToPool(Transaction Sqlca) throws Exception {
		String sSql ="",sPhaseno="";
		//查询
		sSql = "select ft.phaseno from flow_task ft where  ft.serialno=(select min(serialno) from flow_task where phasetype='1020' and objectno=:ObjectNo)";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo", objectNo));
		if (rs.next()) {
			sPhaseno = DataConvert.toString(rs.getString("phaseno"));
		}
		rs.getStatement().close();
		//删除数据
		sSql ="delete from flow_task  where serialno not in (select serialno from flow_task ft where ft.serialno=(select min(serialno) from flow_task where phasetype='1020' and objectno=:ObjectNo) or (ft.serialno=(select serialno from flow_task where phasetype='1010' and objectno=:ObjectNo))) and objectno=:ObjectNo";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("ObjectNo", objectNo));
		//更新
		sSql = "update FLOW_TASK set TaskState = null, endTime=null, phaseOpinion3=null,phaseOpinion4=null where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("ObjectNo", objectNo)
				.setParameter("ObjectType", objectType)
				.setParameter("PhaseNo", sPhaseno));
		if("2".equals(poolMode)){
			sSql = "update FLOW_TASK set userID = null, userName=null, orgID=null,orgName=null where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("ObjectNo", objectNo)
					.setParameter("ObjectType", objectType)
					.setParameter("PhaseNo", sPhaseno));
		}
		return "Success";
	}

	// 任务退回检查
	public String cancelCheck(Transaction Sqlca) throws Exception {
		String relativeSerialno = "";
		String lastUserId = "";
		String sSql = "select relativeSerialno from  FLOW_TASK where SerialNo =:SerialNo";
		ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
				.setParameter("SerialNo", serialNo));
		if (rsTemp.next()) {
			relativeSerialno = DataConvert.toString(rsTemp.getString("relativeSerialno"));
		}
		if(rsTemp!=null) rsTemp.getStatement().close();
		sSql = "select userId from  FLOW_TASK where SerialNo =:SerialNo";
		rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", relativeSerialno));
		if (rsTemp.next()) {
			lastUserId = DataConvert.toString(rsTemp.getString("userID"));
		}

		if(rsTemp!=null) rsTemp.getStatement().close();
		rsTemp = null;
		if (lastUserId.equals(userID)) {
			return "Success";
		} else {
			return "Failure";
		}
	}
	//退回上一步
	public String goBack(Transaction Sqlca) {
		String sRet = "Success";
		String objectNo = "", objectType = "", phaseNo = "", relativeSerialno="";
		String sSql = "select relativeSerialno,objectNo,objectType,phaseNo,userID from flow_task where SerialNo =:SerialNo ";
		ASResultSet rsTemp = null;
		try{
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", serialNo));
			if(rsTemp.next()){
				relativeSerialno = rsTemp.getString("relativeSerialno");
				objectNo = rsTemp.getString("objectNo");
				objectType = rsTemp.getString("objectType");
				phaseNo = rsTemp.getString("phaseNo");
			}
			rsTemp.getStatement().close();
			//删除当前阶段的任务
			sSql = "delete from  Flow_Task where ObjectNo=:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and (EndTime is null or EndTime = '')";
			int i = Sqlca.executeSQL(new SqlObject(sSql)
			.setParameter("ObjectNo", objectNo)
			.setParameter("ObjectType", objectType)
			.setParameter("PhaseNo", phaseNo));
			if(i <= 0){
				return "Failure";
			}
			//设置前一步任务的endTime和phaseOpinion4为null
			sSql = "update FLOW_TASK set endTime=null,phaseOpinion4=null where SerialNo=:SerialNo";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo", relativeSerialno));
		}catch(Exception e){
			try{
			Sqlca.rollback();}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
			sRet = "Failure";
		}
		return sRet;
	}

	// 退回上一步特殊处理，只有上一步也是当前用户操作的才能退回
	public void preCancel(Transaction Sqlca) throws Exception {
		String objectNo = "";
		String objectType = "";
		String phaseNo = "";
		String userID = "";
		String sSql = "select objectNo,objectType,phaseNo,userID from  FLOW_TASK where SerialNo =:SerialNo";
		ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
				.setParameter("SerialNo", serialNo));
		if (rsTemp.next()) {
			objectNo = DataConvert.toString(rsTemp.getString("objectNo"));
			objectType = DataConvert.toString(rsTemp.getString("objectType"));
			phaseNo = DataConvert.toString(rsTemp.getString("phaseNo"));
			userID = DataConvert.toString(rsTemp.getString("userID"));
		}
		rsTemp.getStatement().close();
		sSql = "delete from  Flow_Task where ObjectNo=:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and UserID<>:UserID";
		Sqlca.executeSQL(new SqlObject(sSql)
				.setParameter("ObjectNo", objectNo)
				.setParameter("ObjectType", objectType)
				.setParameter("PhaseNo", phaseNo)
				.setParameter("UserID", userID));
	}
	
	public String getSerialNo(Transaction Sqlca) throws Exception {
		String serialNo="";
		String sSql = "select serialNo from  FLOW_TASK where ObjectNo =:ObjectNo and ObjectType=:ObjectType order by serialNo desc";
		ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
				.setParameter("ObjectNo", objectNo)
				.setParameter("ObjectType", objectType));
		if (rsTemp.next()) {
			serialNo = DataConvert.toString(rsTemp.getString("serialNo"));
		}
		rsTemp.getStatement().close();
		return serialNo;
	}

	public String getPhaseNo(Transaction Sqlca) throws Exception {
		String phaseNo="";
		String sSql = "select phaseNo from  FLOW_TASK where ObjectNo =:ObjectNo and ObjectType=:ObjectType order by serialNo desc";
		ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
				.setParameter("ObjectNo", objectNo)
				.setParameter("ObjectType", objectType));
		if (rsTemp.next()) {
			phaseNo = DataConvert.toString(rsTemp.getString("phaseNo"));
		}
		rsTemp.getStatement().close();
		return phaseNo;
	}
	
	public String getPhaseName(Transaction Sqlca) throws Exception {
		String phaseName="";
		String sSql = "select phaseName from  FLOW_TASK where SerialNo =:SerialNo";
		ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
				.setParameter("SerialNo", serialNo));
		if (rsTemp.next()) {
			phaseName = DataConvert.toString(rsTemp.getString("phaseName"));
		}
		rsTemp.getStatement().close();
		return phaseName;
	}
	
	//是否是自己提交给自己
	public String sameUser(Transaction Sqlca) {
		String str = "No";
		String sql = "select ft.serialNo from FLOW_TASK ft where ft.objectType=:objectType and ft.objectNo=:objectNo and ft.userID=:userID "
				+ " and ft.serialNo=(select max(ft2.serialNo) from FLOW_TASK ft2 where ft2.objectType=:objectType and ft2.objectNo=:objectNo ) ";
		try{
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql)
			.setParameter("objectType", objectType).setParameter("objectNo", objectNo)
			.setParameter("userID", userID));
			if(rs.next()){
				str = "Yes";
			}
			rs.getStatement().close();
		}catch(Exception e){
			ARE.getLog().error("判断'是否自己提交自己'时出错!",e);
		}
		ARE.getLog().trace("***********************"+str);
		return str;
	}
	
	//调用规则计算申请等级，并设置到相应字段
	public String getGrade(Transaction Sqlca){
		String sRet = "Success";
		String sql = "update BUSINESS_CONTRACT set Flag5=:grade where serialNo =:serialNo ";
		try{
			//暂时默认为1
			String grade = "1";
			//TODO 调用规则计算申请等级
			/*JSONObject jObject = null;
			String calcResult = RuleConnectionService.callRule("CFSS_JCMAIN", "RuleFlow", "RF001", jObject.toString(), "{}");*/
			
			Sqlca.executeSQL(new SqlObject(sql).setParameter("serialNo", objectNo)
					.setParameter("grade", grade));
		}catch(Exception e){
			try{
				Sqlca.rollback();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			sRet = "Failure";
			ARE.getLog().error("计算申请等级，或设置字段出错!",e);
		}
		return sRet;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getOldPhaseNo() {
		return oldPhaseNo;
	}

	public void setOldPhaseNo(String oldPhaseNo) {
		this.oldPhaseNo = oldPhaseNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getFlowNo() {
		return flowNo;
	}

	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}

}
