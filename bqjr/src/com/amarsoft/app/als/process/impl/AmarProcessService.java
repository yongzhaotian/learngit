package com.amarsoft.app.als.process.impl;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import org.apache.commons.codec.binary.Base64;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.app.als.process.AbstractProcessService;
import com.amarsoft.app.als.process.Context;
import com.amarsoft.app.als.process.data.ProcessObject;
import com.amarsoft.app.als.process.data.TaskListCatalog;
import com.amarsoft.app.als.process.util.PSUserObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.log.Log;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.core.json.JSONException;
import com.amarsoft.core.json.JSONObject;
import com.amarsoft.core.object.ResultObject;
import com.amarsoft.core.util.CommonUtil;
import com.amarsoft.core.util.StringUtil;
import com.amarsoft.flow.FlowServices;

/**
 * Amar流程引擎实现类
 * @author zszhang
 *
 */
public class AmarProcessService extends AbstractProcessService {
	
	private static final String APPID = "ALS7";//全局应用编号,标识当前应用系统
	private static final String USER_ROLE_JBO = "jbo.sys.USER_ROLE";//用户角色关联JBO
	private static final String SUCCESS_MESSAGE = "SUCCESS";
	private static final String FAILURE_MESSAGE = "FAILURE";
	
	private Transaction Sqlca = null;
	
	private JBOFactory factory = JBOFactory.getFactory();
	private BizObjectManager bom = null;
	private BizObjectQuery query = null;
	
	private Log logger = ARE.getLog();

	/**
	 * 启动流程实例
	 * @param processDefID 流程定义编号
	 * @param userID 流程发起人/ProcessInst Owner/The first activity participant
	 * @param objects 流程相关数据(流程运转过程中需要的业务数据)
	 * @return List<ProcessObject>
	 */
	public List<ProcessObject> startProcessInst(String processDefID, String userID, String objects) throws Exception {
		//设置流程相关对象
		objects = setUserInfoToRD(userID, objects);
		
		//设置当前任务参与者
		String param = "{FLOW:{NEXTOWNER:'"+ userID +"',GROUP:''}}"; 
		
		//定义结果参数
		String sResult = ""; 
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		System.out.println("APPID="+APPID+",processDefID="+processDefID+",objects="+objects+",param="+param+",sResult="+sResult);
		sResult = services.getFlowServicePort().startFlowInstance(APPID, processDefID, "Key", processDefID, "", objects, param, sResult);
		System.out.println("FlowInstance=" + sResult);
		ResultObject rObject = new ResultObject(sResult);
		if (rObject.get("STATUS", "").equals("-1")) {
			logger.error("启动流程失败：" + rObject.get("MESSAGE", ""));
			throw new Exception("启动流程失败：" + rObject.get("MESSAGE", ""));
		}
		
		/*
		 * 将创建的流程实例及流程任务信息放入结果列表
		 */
		List<ProcessObject> processObjects = new ArrayList<ProcessObject>();
		try {
			ProcessObject po = new ProcessObject();
			po.setProcessDefID(rObject.getResult("FLOW.FLOWDEFINITION.NAME", ""));//流程定义编号 eg:TransformFlow
			po.setProcessDefName(rObject.getResult("FLOW.FLOWDEFINITION.DESCRIPTION", ""));//流程定义名称 eg:放贷流程
			po.setProcessInstID(rObject.getResult("FLOW.FLOWINSTANCE.ID", ""));//流程实例编号 eg:TransformFlow.190001
			po.setActivityID(rObject.getResult("PARAMS.FLOW.STATE", ""));//当前节点编号 eg:Task0
			po.setActivityName(rObject.getResult("PARAMS.FLOW.STATENAME", ""));//当前节点名称 eg:分行信贷风险检查
			po.setTaskID(rObject.getResult("TASK.ID", ""));//任务编号 eg:190007
			po.setUserID(rObject.getResult("PARAMS.FLOW.NEXTOWNER", ""));//用户编号  eg:test11
			po.setMilestone(rObject.getResult("PARAMS.FLOW.MILESTONE", ""));//当前里程碑(阶段类型) eg:1020
			po.setObjectDescribe(rObject.getResult("FLOW.FLOWDEFINITION.ID", ""));//运行时流程定义编号 eg:TransformFlow-5
			String taskCount = rObject.getResult("TASK.TASKCOUNT", "");
			if(taskCount == null || "".equals(taskCount) || "0".equals(taskCount)){
				processObjects.add(po);
			} else {
				int count = Integer.parseInt(taskCount);
				for(int i = 0; i < count; i++){
					ProcessObject tpo = new ProcessObject();
					tpo.setAttributes(po);
					tpo.setTaskID(rObject.getResult("TASK.TASK"+i+".TASK.ID", ""));
					tpo.setUserID(rObject.getResult("TASK.TASK"+i+".TASK.ASSIGNEE", ""));
					tpo.setActivityID(rObject.getResult("TASK.TASK"+i+".TASK.NAME", ""));
					tpo.setActivityName(rObject.getResult("TASK.TASK"+i+".TASK.DESCRIPTION", ""));
					processObjects.add(tpo);
				}
			}
		} catch (JSONException e) {
			logger.debug("流程引擎启动流程:获取流程对象出错"+e.getMessage(), e);
			throw new Exception("流程引擎启动流程:获取流程对象出错"+e.getMessage(), e);
		} catch (Exception e){
			logger.debug("流程引擎启动流程:获取流程对象出错"+e.getMessage(), e);
			throw new Exception("流程引擎启动流程:获取流程对象出错"+e.getMessage(), e);
		}
		
		return processObjects;
	}
	
	/**
	 * 删除流程实例
	 * @param processInstID 流程实例编号
	 * @return processInstID or Success/Failure or other String
	 */
	public String deleteProcessInst(String processInstID) throws Exception{
		try{
			FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
			String peResult = services.getFlowServicePort().deleteFlowInstanceCascade("", "", processInstID, "", "", "", "");
			ResultObject rObject = new ResultObject(peResult);
			if (rObject.get("STATUS", "").equals("1")) {
				logger.info("流程引擎删除流程实例成功:[processInstID="+processInstID+"]");
			}
		}catch(Exception e){
			logger.error("流程引擎删除流程实例失败,流程实例已删除或流程实例不存在:[processInstID="+processInstID+"]", e);
			e.printStackTrace();
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 取得任务编号<br>
	 * 参与流程处理的用户在流程实例的某一特定阶段(节点)具有唯一的任务
	 * @param processInstID 流程实例编号
	 * @param processDefID 流程定义编号
	 * @param activityID 活动定义编号
	 * @param userID 任务参与者
	 * @return
	 */
	public String getUnfinishedTaskNo(String processInstID, String processDefID, String activityID, String userID) throws Exception {
		//System.out.println("com.amarsoft.app.als.process.impl.AmarProcessService.getUnfinishedTaskNo.getTaskNo:Start");
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		//sResult = services.getFlowServicePort().findUserTasks(APPID, sFlowID, "", sUserID, "", "", sPARAMS, "");
		System.out.println("processInstID="+processInstID);
		String sResult = services.getFlowServicePort().findUserTasks(APPID, "", processInstID, userID, "", "", "", "");
		//System.out.println("com.amarsoft.app.als.process.impl.AmarProcessService.getUnfinishedTaskNo.getTaskNo:Result1:" + sResult);
		try {
			ResultObject resultObject = new ResultObject(sResult);
			String taskCount = resultObject.get("TASKCOUNT", "");
			if(Integer.parseInt(taskCount) == 0) { 
				throw new Exception("Cann't find the task [ ProcessInstID:"+processInstID+", ProcessDefID:"+processDefID+", ActivityID:"+activityID+", UserID: "+userID+" ]");
			}
			//System.out.println("com.amarsoft.app.als.process.impl.AmarProcessService.getUnfinishedTaskNo.getTaskNo:TaskCount："+Integer.parseInt(taskCount) );
			boolean contains = false;
			for(int i = 0; i < Integer.parseInt(taskCount); i++){
				if (processInstID.equals(resultObject.get("TASK" + i + ".FLOW.FLOWINSTANCE.ID", ""))
						&& activityID.equals(resultObject.get("TASK" + i + ".PARAMS.FLOW.STATE", ""))) {
					contains = true;
					sResult = resultObject.get("TASK" + i + ".TASK.ID", "");
					break;
				}
			}
			if(!contains) {
				throw new Exception("Cann't find the task [ ProcessInstID:"+processInstID+", ActivityID:"+activityID+", UserID: "+userID+" ]");
			}
		} catch (Exception e){
			logger.debug("获取得任务编号出错"+e.getMessage(),e);
			throw new Exception("获取得任务编号出错"+e.getMessage(),e);
		}
		System.out.println("com.amarsoft.app.als.process.impl.AmarProcessService.getUnfinishedTaskNo.getTaskNo:End:Result=" + sResult);
		return sResult;
	}
	
	/**
	 * 取得流程任务提交时的动作列表,该动作列表不包括：退回、收回、退回上一步
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @param userID 用户编号
	 * @return Map<actionName:String,action:String>
	 */
	public Map<String,String> getTaskActions(String processDefID, String taskID, String userID) throws Exception {
		Map<String,String> actions = new LinkedHashMap<String,String>();
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		try{
			String sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getOutObject", "Task", taskID, "", "");
			System.out.println(sResult);
			ResultObject rObject = new ResultObject(sResult);
			
			int tCount = Integer.parseInt(rObject.getResult("TRANSITIONCOUNT", "0"));
			for(int i = 0; i < tCount; i++){
				String actionName = rObject.getResult("TRANSITION" + i + ".TITLE", "");
				String actionValue = rObject.getResult("TRANSITION" + i + ".TO", "");
				actions.put(actionName, actionValue);
			}
			
			int sCount = Integer.parseInt(rObject.getResult("STATECOUNT", "0"));
			for(int i = 0; i < sCount; i++){
				String actionName = rObject.getResult("STATE" + i + ".TITLE", "");
				String actionValue = rObject.getResult("STATE" + i + ".NAME", "");
				actions.put(actionName, actionValue);
			}
			System.out.println("tCount:"+tCount+"||||sCount:"+sCount);
			//如果没有定义后续流转,一般情况下为退回补充资料或审批通过/否决等特殊节点
			if(tCount + sCount == 0) {
				//判断是否为退回补充资料阶段
				sResult = services.getFlowServicePort().getFlowParams(APPID, processDefID, "Task", taskID);
				rObject = new ResultObject(sResult);
				
				//判断当前阶段是否为"需补充资料"
				if("需补充资料".equals(rObject.getResult("FLOW.STATENAME", "")) || 
				   "1030".equals(rObject.getResult("FLOW.MILESTONE", "")) ||
				   "3000".equals(rObject.getResult("FLOW.MILESTONE", ""))) {
					actions.put("补充完全", rObject.getResult("FLOW.LASTSTATE", ""));
				}
			}
			
			if(actions == null || actions.size() <= 0){
				throw new Exception("取得流程任务提交时的动作列表失败:未取得有效的提交动作");
			}
			
		} catch (Exception e){
			logger.debug("取得流程任务提交时的动作列表失败"+e.getMessage(), e);
			logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.restoreTask()][ProcessDefID="+processDefID+"][ProcessTaskID="+taskID+"]");
			this.restoreTask(processDefID, taskID);//同步流程任务状态,防止引擎阶段早于应用当前阶段
			throw new Exception("取得流程任务提交时的动作列表失败"+e.getMessage(), e);
		}
		return actions;
	}
	

	/**
	 * 取得流程任务提交时的分支动作列表。
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @param ActivityNo 活动编号
	 * @return Map<actionName:String,action:String>
	 */
	public Map<String, String> getForkActions(String processDefID, String taskID, String ActivityNo) throws Exception {
		Map<String,String> actions = new LinkedHashMap<String,String>();
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		try{
			String psResult = services.getFlowServicePort().getFlowContent(APPID, processDefID, "getOutObject", "Task", taskID, ActivityNo, "");
			System.out.println(psResult);
			ResultObject rObject = new ResultObject(psResult);
			
			int tCount = Integer.parseInt(rObject.getResult("TRANSITIONCOUNT", "0"));
			for(int i = 0; i < tCount; i++){
				String actionName = rObject.getResult("TRANSITION" + i + ".TITLE", "");
				String actionValue = rObject.getResult("TRANSITION" + i + ".TO", "");
				actions.put(actionName, actionValue);
			}
			
			int sCount = Integer.parseInt(rObject.getResult("STATECOUNT", "0"));
			for(int i = 0; i < sCount; i++){
				String actionName = rObject.getResult("STATE" + i + ".TITLE", "");
				String actionValue = rObject.getResult("STATE" + i + ".NAME", "");
				actions.put(actionName, actionValue);
			}
			System.out.println("tCount:"+tCount+"||||sCount:"+sCount);
			
			if(actions == null || actions.size() <= 0){
				throw new Exception("取得流程任务提交时的分支动作列表失败:未取得有效的提交动作");
			}
			
		} catch (Exception e){
			logger.debug("取得流程任务提交时的分支动作列表失败"+e.getMessage(), e);
			throw new Exception("取得流程任务提交时的分支动作列表失败"+e.getMessage(), e);
		}
		return actions;
	}
	
	
	/**
	 * 取得流程下一活动可选的参与者列表
	 * @param processDefID 流程定义编号
	 * @param nextAction 下一活动
	 * @param taskID 任务编号
	 * @param curUserID 当前用户编号
	 * @return
	 */
	public String[] getNextOptionalUsers(String processDefID, String nextAction, String taskID, String curUserID) throws Exception {
		String[] users = null;
		try {
			FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
			String sResult = services.getFlowServicePort().getFlowParams(APPID, "", "Task", taskID);
			ResultObject rObject = new ResultObject(sResult);
			
			//判断当前阶段是否为"需补充资料",特殊处理
			if("需补充资料".equals(rObject.getResult("FLOW.STATENAME", "")) || 
			   "1030".equals(rObject.getResult("FLOW.MILESTONE", "")) ||
			   "3000".equals(rObject.getResult("FLOW.MILESTONE", ""))) {
				users = new String[]{rObject.getResult("FLOW.LASTOWNER", "")};
				return users;
			}
			
			sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getNextTask", taskID, "", "", "{FLOW:{NEXTSTATE:'"+nextAction+"'}}");
			//System.out.println("com.amarsoft.app.als.process.impl.AmarProcessService.getNextOptionalUsers.getNextTask"+sResult);
			rObject = new ResultObject(sResult);
			String roleType = rObject.getResult("ROLETYPE", "");
			String roleScript = rObject.getResult("ROLE", "");
			System.out.println("roleType="+roleType);
			System.out.println("roleScript="+roleScript);
			if("AmarScript".equalsIgnoreCase(roleType)){
				Sqlca = getSqlca(); //从引擎服务上下文中获取Sqlca
				if(Sqlca == null)
					throw new Exception("******************* Sqlca is null. But it is needed! **********************");
				Any tmpUserList = Expression.getExpressionValue(roleScript, Sqlca);
				users = tmpUserList.toStringArray();
			} else if("Role".equalsIgnoreCase(roleType)){
				roleScript = "'" + roleScript.replace(",", "','") + "'";
				bom = factory.getManager(USER_ROLE_JBO);
				query = bom.createQuery("RoleID in ("+roleScript+") and UserID <> ' + curUserID + '");
				List<BizObject> objects = query.getResultList();
				if(objects != null){
					users = new String[objects.size()];
					for(int i = 0; i < users.length; i++){
						users[i] = objects.get(i).getAttribute("UserID").getString()+" "+objects.get(i).getAttribute("RoleID").getString();
					}
				}
			} else if("Script".equalsIgnoreCase(roleType)){
				Sqlca = getSqlca(); //从引擎服务上下文中获取Sqlca
				if(Sqlca == null)
					throw new Exception("******************* Sqlca is null. But it is needed! **********************");
				Any tmpUserList = Expression.getExpressionValue(roleScript, Sqlca);
				users = tmpUserList.toStringArray();
			} else {
				throw new Exception("Cann't support the roleType : [ "+roleType+" ]");
			}
		} catch (Exception e) {
			logger.debug("取得流程下一活动可选的参与者列表失败"+e.getMessage(), e);
			throw new Exception("取得流程下一活动可选的参与者列表失败"+e.getMessage(), e);
		} 
		return users;
	}
	
	/**
	 * 取得流程当前活动可选的参与者列表
	 * @param processDefID 流程定义编号
	 * @param nextAction 当前活动编号
	 * @param taskID 任务编号
	 * @param curUserID 当前用户编号
	 * @return
	 */
	public String[] getCurOptionalUsers(String processDefID, String nextAction, String taskID, String curUserID) throws Exception {
		String[] users = null;
		try {
			FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
			
			String sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getNextTask", taskID, "", "", "{FLOW:{NEXTSTATE:'"+nextAction+"'}}");
			//System.out.println("com.amarsoft.app.als.process.impl.AmarProcessService.getNextOptionalUsers.getNextTask"+sResult);
			ResultObject rObject = new ResultObject(sResult);
			String roleType = rObject.getResult("ROLETYPE", "");
			String roleScript = rObject.getResult("ROLE", "");
			System.out.println("roleType="+roleType);
			System.out.println("roleScript="+roleScript);
			if("AmarScript".equalsIgnoreCase(roleType)){
				Sqlca = getSqlca(); //从引擎服务上下文中获取Sqlca
				if(Sqlca == null)
					throw new Exception("******************* Sqlca is null. But it is needed! **********************");
				Any tmpUserList = Expression.getExpressionValue(roleScript, Sqlca);
				users = tmpUserList.toStringArray();
			} else if("Role".equalsIgnoreCase(roleType)){
				roleScript = "'" + roleScript.replace(",", "','") + "'";
				bom = factory.getManager(USER_ROLE_JBO);
				query = bom.createQuery("RoleID in ("+roleScript+") and UserID <> ' + curUserID + '");
				List<BizObject> objects = query.getResultList();
				if(objects != null){
					users = new String[objects.size()];
					for(int i = 0; i < users.length; i++){
						users[i] = objects.get(i).getAttribute("UserID").getString();
					}
				}
			} else if("Script".equalsIgnoreCase(roleType)){
				Sqlca = getSqlca(); //从引擎服务上下文中获取Sqlca
				if(Sqlca == null)
					throw new Exception("******************* Sqlca is null. But it is needed! **********************");
				Any tmpUserList = Expression.getExpressionValue(roleScript, Sqlca);
				users = tmpUserList.toStringArray();
			} else {
				throw new Exception("Cann't support the roleType : [ "+roleType+" ]");
			}
		} catch (Exception e) {
			logger.debug("取得流程当前活动可选的参与者列表失败"+e.getMessage(), e);
			throw new Exception("取得流程当前活动可选的参与者列表失败"+e.getMessage(), e);
		} 
		
		return users;
	}
	
	/**
	 * 取得流程下一活动任务池角色
	 * @param processDefID 流程定义编号
	 * @param nextAction 下一活动
	 * @param taskID 任务编号
	 * @param curUserID 当前用户编号
	 * @return
	 */
	public String getNextOptionalRole(String processDefID, String nextAction, String taskID) throws Exception {
		String role = null;
		try {
			FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
			String sResult = services.getFlowServicePort().getFlowParams(APPID, "", "Task", taskID);
			System.out.println("sResult1="+sResult);
			ResultObject rObject = new ResultObject(sResult);
			
			sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getNextTask", taskID, "", "", "{FLOW:{NEXTSTATE:'"+nextAction+"'}}");
			//System.out.println("com.amarsoft.app.als.process.impl.AmarProcessService.getNextOptionalUsers.getNextTask"+sResult);
			rObject = new ResultObject(sResult);
			role = rObject.getResult("ROLE", "");
		} catch (Exception e) {
			logger.debug("取得流程下一活动角色失败"+e.getMessage(), e);
			throw new Exception("取得流程下一活动角色失败"+e.getMessage(), e);
		}
		return role;
	}
	
	/**
	 * 将当前流程实例向下提交
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @param taskID 当前任务编号
	 * @param nextAction 提交动作
	 * @param nextOpinion 提交意见 
	 * @param objects 流程相关数据(流程运转过程中需要的业务数据)
	 * @return List<ProcessObject>
	 */
	public List<ProcessObject> commitProcessInst(String processDefID, String processInstID, String taskID, String nextAction, String nextOpinion, String objects) throws Exception {
		List<ProcessObject> processObjects = new ArrayList<ProcessObject>();
		//获取流程引擎服务
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		
		//如果未传入选择动作，将默认选择TRANSITION0
		if ("".equals(nextAction.trim()) || nextAction == null) {
			String sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getOutObject", "Task", taskID, "", "");
			ResultObject rObject = new ResultObject(sResult);
			nextAction = rObject.get("TRANSITION0.TO", "");
		}
		
		//是否提交到池
		String isPool = getActivityProperty(processDefID, taskID, nextAction, "ISPOOL");
		//是否贷审会秘书
		String isSecretary = getActivityProperty(processDefID, taskID, nextAction, "ISSECRETARY");
		//获取信息区属性值
		String infoArea = getActivityProperty(processDefID, taskID, nextAction, "INFOAREA");
		//获取作业区属性值
		String operateArea = getActivityProperty(processDefID, taskID, nextAction, "OPERATEAREA");
		//获取按钮区属性值
		String buttonArea = getActivityProperty(processDefID, taskID, nextAction, "BUTTONAREA");
		
		String nextUserID = "";
		if(nextOpinion == null || "".equals(nextOpinion)){//退回补充资料或终批等阶段应用不传入处理人
			if (!nextAction.startsWith("End") && !"1".equals(isPool)) {// 排除任务池阶段
				String[] nextUsers = getNextOptionalUsers(processDefID, nextAction, taskID, "");
				if(nextUsers == null || nextUsers.length == 0) nextOpinion = "als";
			}
		}else{
			if(!nextAction.startsWith("Fork")){
				//提交给多个处理人
				String [] nextUsers = nextOpinion.split(";");
				for(int i = 0; i < nextUsers.length; i++){
					nextUserID += "," + nextUsers[i].split(" ")[0];
				}
				if(!"".equals(nextUserID)) nextUserID = nextUserID.substring(1);
			}
		}
		
		// 传param参数,区分分支和汇聚以及非分支的组合方式
		ResultObject rObject = new ResultObject();
		String param = "";
		// 分支
		if(nextAction.startsWith("Fork")){
			String forkUser = "";
			String[] temp = nextOpinion.split("-");
			for(int i = 0;i<temp.length;i++){
				forkUser += ","+temp[i].split("@")[0]+":{OWNER:'"+temp[i].split("@")[1]+"'}";
			}
			param = "{"+forkUser.substring(1)+"}";
		}else{
			// 汇聚
			if (nextAction.startsWith("Join")) {
				String sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getOutObject", "Task", taskID, nextAction, "");
				rObject = new ResultObject(sResult);
				String joinAction = rObject.get("TRANSITION0.TO", "");
				param = "{"+joinAction+":{OWNER:'"+nextUserID+"'}}";
			} else {
				rObject.put("FLOW.NEXTOWNER", nextUserID);
				rObject.put("FLOW.NEXTSTATE", nextAction);
				param = rObject.toString();
			}
		}
		
		
		if(objects == null || "".equals(objects)){
			objects = services.getFlowServicePort().getFlowObjects(APPID, "", "Task", taskID);
		}

		if("1".equals(isPool)){
			nextOpinion = getNextOptionalRole(processDefID, nextAction, taskID);
			rObject = new ResultObject();
			rObject.put("FLOW.NEXTOWNER", "");
			rObject.put("FLOW.NEXTGROUP", nextOpinion);
			rObject.put("FLOW.NEXTSTATE", nextAction);
			param = rObject.toString();
			//param = "{FLOW:{NEXTOWNER:'',NEXTGROUP:'" + nextOpinion + "',NEXTSTATE:'" + nextAction + "'}}";
		}
		String groupID = getNextOptionalRole(processDefID, nextAction, taskID);
		
		//设置用户机构信息
		String newObjects = "";
		if(!"".equals(nextUserID)){
			newObjects = setUserInfoToRD(nextUserID, objects);
		}else{
			newObjects = objects;
		}
		
		//用户角色信息
		JSONObject jGroupID = null; 
		if (groupID != null) {
			//解析AmarScript，分割后第三个字符串为第一个角色，第四个为第二个角色，依此类推。
			if (groupID.startsWith("!")) {
				groupID = groupID.replace("(", "@").replace(")", "@");
				String[] groupIDArray = groupID.split("@")[1].split(",");
				jGroupID = new JSONObject();
				for (int i = 2; i < groupIDArray.length; i++) {
					JSONObject jObject = new JSONObject();
					jObject.put("ROLEID", groupIDArray[i]);
					jGroupID.append("ALS", jObject);
				}
			} 
			//解析角色列表，分割后第一个字符串为第一个角色，第二个为第二个角色，依此类推。
			else {
				String[] groupIDArray = groupID.split(",");
				jGroupID = new JSONObject();
				for (int i = 0; i < groupIDArray.length; i++) {
					JSONObject jObject = new JSONObject();
					jObject.put("ROLEID", groupIDArray[i]);
					jGroupID.append("ALS", jObject);
				}
			}
		}
		
		String nextActivityName = getNextActivityName(processDefID,processInstID,taskID,nextAction,nextOpinion);
		String nextActivityMileStone = getNextActivityMileStone(processDefID,processInstID,taskID,nextAction,nextOpinion);
		logger.info("*******************completeTask:start*******************");
		logger.info("[taskID:"+taskID+"],[objects:"+newObjects+"],[param:"+param+"]");
		String psResult = "";
		if(nextAction.startsWith("Fork")||nextAction.startsWith("Join")){
			nextAction  = "{FLOW:{NEXTSTATE='"+nextAction+"'}}";
			psResult = services.getFlowServicePort().completeTask(APPID, "", taskID, "", newObjects, nextAction, param);
		}else{
			psResult = services.getFlowServicePort().completeTask(APPID, "", taskID, "", newObjects, param, "");
		}
		logger.info("[result:"+psResult+"]");
		logger.info("********************completeTask:end********************");
		
		rObject = new ResultObject(psResult);
		if (rObject.get("STATUS", "").equals("-1")) {
			logger.error("提交流程失败：" + rObject.get("MESSAGE", ""));
			throw new Exception("提交流程失败：" + rObject.get("MESSAGE", ""));
		}
		
		try {
			if(nextAction.startsWith("End") && rObject.get("STATUS", "").equals("1")){
				ProcessObject po = new ProcessObject();
				po.setActivityID(nextAction);
				po.setActivityName(nextActivityName);
				po.setMilestone(nextActivityMileStone);
				po.setUserID("als");
				processObjects.add(po);
			}else{
				ProcessObject po = new ProcessObject();
				po.setMilestone(rObject.getResult("PARAMS.FLOW.MILESTONE", ""));
				po.setActivityID(rObject.getResult("PARAMS.FLOW.STATE", ""));
				po.setActivityName(rObject.getResult("PARAMS.FLOW.STATENAME", ""));
				//设置是否是任务池
				if ("1".equals(isPool)) {po.setIsPool("1");}
				
				po.setInfoArea(infoArea);
				po.setOperateArea(operateArea);
				po.setButtonArea(buttonArea);
				po.setIsSecretary(isSecretary);
				po.setGroupID(jGroupID.toString());
				
				String taskCount = rObject.getResult("TASK.TASKCOUNT", "");
				if(taskCount == null || "".equals(taskCount) || "0".equals(taskCount)){
					processObjects.add(po);
				} else {
					int count = Integer.parseInt(taskCount);
					for(int i = 0; i < count; i++){
						ProcessObject tpo = new ProcessObject();
						tpo.setAttributes(po);
						tpo.setTaskID(rObject.getResult("TASK.TASK"+i+".TASK.ID", ""));
						//获取当前活动的任务类型
						String taskType = getActivityProperty(processDefID, tpo.getTaskID(), po.getActivityID(), "TASKTYPE");
						tpo.setTaskType(taskType);
						String userID = rObject.getResult("TASK.TASK"+i+".TASK.ASSIGNEE", "");
						if(userID == null || "".equals(userID) || "GROUP_".equals(userID))	userID = "system";
						//任务池状态直接设置角色
						if ("1".equals(isPool)) {
							tpo.setUserID(nextOpinion);
						} else {//否则获取TASK的ASSIGNEE来设置
							tpo.setUserID(userID);
						}
						//System.out.println("assignee:"+userID);
						tpo.setActivityID(rObject.getResult("TASK.TASK"+i+".TASK.NAME", ""));
						tpo.setActivityName(rObject.getResult("TASK.TASK"+i+".TASK.DESCRIPTION", ""));
						processObjects.add(tpo);
					}
				}
			}
		} catch (Exception e) {
			logger.debug("取得提交流程返回对象失败" + e.getMessage(), e);
			throw new Exception("取得提交流程返回对象失败" + e.getMessage(), e);
		}
		return processObjects;
	}
	
	/**
	 * 提交贷审会成员意见
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @param taskID 任务编号
	 * @param usersID 用户编号
	 * @param voteOpinion 投票意见
	 * @param objects 流程相关数据(流程运转过程中需要的业务数据)
	 * @return
	 * @throws Exception 
	 */
	public ProcessObject commitVote(String processDefID, String processInstID, String taskID, String userID, String voteOpinion, String nextOpinion, String objects) throws Exception{
		String param = "";
		ProcessObject po = new ProcessObject() ;
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		//如果没有传入下一个用户，默认为Studio中脚本配置。
		if(nextOpinion==null || "".equals(nextOpinion.trim())){
			param = "";
		}else{
			param = "{FLOW:{NEXTOWNER:'" + nextOpinion + "'}}";
		}
		
		if(objects == null || "".equals(objects)){
			objects = services.getFlowServicePort().getFlowObjects(APPID, "", "Task", taskID);
		}
		
		//如果没有传入投票意见，默认为通过
		if(voteOpinion == null || "".equals(voteOpinion.trim())) voteOpinion="1";
		String sResult = services.getFlowServicePort().doFlowAction(APPID, "", "vote", taskID, userID, voteOpinion, "", param, objects, "");
		ResultObject rObject = new ResultObject(sResult);
		if (rObject.get("STATUS", "").equals("-1")) {
			logger.error("提交会签失败：" + rObject.get("MESSAGE", ""));
			throw new Exception("提交会签失败：" + rObject.get("MESSAGE", ""));
		}else{
			String taskCount = rObject.getResult("TASK.TASKCOUNT", "");
			System.out.println("taskCount:"+taskCount);
			//投票成功且提交到下个阶段
			if("1".equals(taskCount)){
				po.setActivityID(rObject.getResult("PARAMS.FLOW.STATE", ""));
				po.setActivityName(rObject.getResult("PARAMS.FLOW.STATENAME", ""));
				po.setMilestone(rObject.getResult("PARAMS.FLOW.MILESTONE", ""));
				po.setUserID(rObject.getResult("TASK.TASK0.TASK.ASSIGNEE", ""));
				po.setTaskID(rObject.getResult("TASK.TASK0.TASK.ID", ""));
				po.setUserVote(rObject.getResult("RESULTS.VOTE.USERVOTE", ""));
				po.setGroupID(rObject.getResult("PARAMS.FLOW.NEXTGROUP", ""));
				//获取当前活动的任务类型
				String taskType = getActivityProperty(processDefID, rObject.getResult("TASK.TASK0.TASK.ID", ""), po.getActivityID(), "TASKTYPE");
				//是否贷审会秘书
				String isSecretary = getActivityProperty(processDefID, rObject.getResult("TASK.TASK0.TASK.ID", ""), po.getActivityID(), "ISSECRETARY");
				//获取信息区属性值
				String infoArea = getActivityProperty(processDefID, rObject.getResult("TASK.TASK0.TASK.ID", ""), po.getActivityID(), "INFOAREA");
				//获取作业区属性值
				String operateArea = getActivityProperty(processDefID, rObject.getResult("TASK.TASK0.TASK.ID", ""), po.getActivityID(), "OPERATEAREA");
				//获取按钮区属性值
				String buttonArea = getActivityProperty(processDefID, rObject.getResult("TASK.TASK0.TASK.ID", ""), po.getActivityID(), "BUTTONAREA");
				//获取是否任务池
				String isPool = getActivityProperty(processDefID, rObject.getResult("TASK.TASK0.TASK.ID", ""), po.getActivityID(), "ISPOOL");
				po.setIsPool(isPool);
				po.setInfoArea(infoArea);
				po.setOperateArea(operateArea);
				po.setButtonArea(buttonArea);
				po.setIsSecretary(isSecretary);
				po.setTaskType(taskType);
			}
			po.setUserVote(userID);
//			try{
//				sResult = services.getFlowServicePort().getFlowResults("", "", "Task", taskID);
//				rObject = new ResultObject(sResult);
//				po.setUserVote(rObject.getResult("VOTE.USERVOTE", ""));
//			}catch (Exception e) {
//				throw new Exception("查询流程结果失败",e);
//			}
		}
		System.out.println("Vote Result:"+sResult);
		return po;
	}
	
	/**
	 * 增加贷审会成员
	 * @param processDefID 流程定义编号
	 * @param taskID 流程任务编号
	 * @param users 欲增加的成员列表 user1,user2,user3
	 * @return
	 * @throws Exception 
	 */
	public String addVote(String processDefID, String taskID, String users) throws Exception{
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = services.getFlowServicePort().doFlowAction(APPID, "", "changevote", taskID, "add", users, "", "", "", "");
		System.out.println("AddVote Result:"+sResult);
		System.out.println("AddVote Users:"+users);
		ResultObject rObject = new ResultObject(sResult);
		if (("1").equals(rObject.get("STATUS", ""))){
			return "SUCCESS";
		}else{
			logger.error("增加审贷会成员失败：" + rObject.get("MESSAGE", ""));
			throw new Exception("增加审贷会成员失败：" + rObject.get("MESSAGE", ""));
		}
	}
	
	/**
	 * 移除贷审会成员
	 * @param processDefID 流程定义编号
	 * @param taskID 流程任务编号
	 * @param users 欲移除的成员列表 user1,user2,user3
	 * @return
	 * @throws Exception 
	 */
	public String removeVote(String processDefID, String taskID, String users) throws Exception{
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = services.getFlowServicePort().doFlowAction(APPID, "", "changevote", taskID, "remove", users, "", "", "", "");
		System.out.println("RemoveVote Result:"+sResult);
		System.out.println("RemoveVote Users:"+users);
		ResultObject rObject = new ResultObject(sResult);
		if (("1").equals(rObject.get("STATUS", ""))){
			return "SUCCESS";
		}else{
			logger.error("删除审贷会成员失败：" + rObject.get("MESSAGE", ""));
			throw new Exception("删除审贷会成员失败：" + rObject.get("MESSAGE", ""));
		}
	}
	
	/**
	 * 从任务池中获取任务
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @param userID 用户编号
	 * @return
	 * @throws Exception
	 */
	public String takeTaskFromPool(String processDefID, String taskID, String userID) throws Exception{
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = services.getFlowServicePort().takeTask(APPID,  "",  taskID, userID, "", "", "", "");
		ResultObject rObject = new ResultObject(sResult);
		if (rObject.get("STATUS", "").equals("-1")) {
			logger.error("获取任务失败：" + rObject.get("MESSAGE", ""));
			throw new Exception("获取任务失败：" + rObject.get("MESSAGE", ""));
		}
		return "SUCCESS";
	}
	
	/**
	 * 取得下一活动名称--示例实现,仅返回下一活动编号
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @param taskID 当前任务编号
	 * @param nextAction 提交动作
	 * @param nextOpinion 提交意见
	 * @return
	 */
	public String getNextActivityName(String processDefID, String processInstID, String taskID, String nextAction, String nextOpinion) throws Exception {
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String activityName = "";
		if(nextAction.startsWith("End")){
			activityName = services.getFlowServicePort().getFlowContent(APPID, "", "getDefineObject", "Task", taskID, nextAction, "Title");
		}else{
			activityName = services.getFlowServicePort().getFlowContent(APPID, "", "getDefineObject", "Task", taskID, nextAction, "Title");
		}
		return activityName;
	}
	
	/**
	 * 取得下一活动里程碑
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @param taskID 当前任务编号
	 * @param nextAction 提交动作
	 * @param nextOpinion 提交意见
	 * @return
	 */
	public String getNextActivityMileStone(String processDefID, String processInstID, String taskID, String nextAction, String nextOpinion) throws Exception {
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String mileStone = "";
		if(nextAction.startsWith("End")){
			mileStone = services.getFlowServicePort().getFlowContent(APPID, "", "getDefineObject", "Task", taskID, nextAction, "MileStone");
		}else{
			mileStone = services.getFlowServicePort().getFlowContent(APPID, "", "getDefineObject", "Task", taskID, nextAction, "MileStone");
		}
		return mileStone;
	}
	
	/**
	 * 取得后续任务编号
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @param taskID 当前任务编号
	 * @param nextAction 提交动作
	 * @return
	 */
	public String getNextState(String processDefID, String processInstID, String taskID, String nextAction) throws Exception {
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getNextTask", taskID, "", "", "{FLOW:{NEXTSTATE:'"+nextAction+"'}}");
		ResultObject rObject = new ResultObject(sResult);
		String Name = rObject.getResult("NAME", "");
		return Name;
	}
	
	/**
	 * 取得用户任务列表的类别,用于审批树图展示
	 * @param userID 用户编号
	 * @param processDefID 流程定义编号
	 * @return List<TaskListCatalog>
	 */
	public List<TaskListCatalog> getUserTaskListCatalog(String userID, String processDefID){
		List<TaskListCatalog> catalogs = new ArrayList<TaskListCatalog>(); 
		String sAppID = APPID;
		String sUserID = userID;
		String sFlowID = processDefID;
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sTasks = services.getFlowServicePort().findUserTasks(sAppID, sFlowID, "", sUserID, "", "", "", "");
		JSONObject jObject;
		try {
			jObject = new JSONObject(sTasks);
			String taskCount = CommonUtil.getNodeValue(jObject, "TASKCOUNT", "");
			if(Integer.parseInt(taskCount) == 0){
				return null;
			}
			for(int i = 0; i < Integer.parseInt(taskCount); i++){
				TaskListCatalog catalog = new TaskListCatalog();
				catalog.setFinishFlag("N");//未完成工作
				catalog.setFlowNo(CommonUtil.getNodeValue(jObject, "TASK"+i+".FLOW.FLOWDEFINITION.NAME", ""));
				catalog.setPhaseType(CommonUtil.getNodeValue(jObject, "TASK"+i+".PARAMS.FLOW.MILESTONE", ""));
				catalog.setPhaseNo(CommonUtil.getNodeValue(jObject, "TASK"+i+".PARAMS.FLOW.STATE", ""));
				catalog.setPhaseName(CommonUtil.getNodeValue(jObject, "TASK"+i+".PARAMS.FLOW.STATENAME", ""));
				catalog.setItemCount("1");
				boolean contains = false;
				for(int k = 0; k < catalogs.size(); k++){
					TaskListCatalog tmp = (TaskListCatalog)catalogs.get(k);
					if(tmp.equals(catalog)){
						int newItemCount = Integer.parseInt(tmp.getItemCount()) + Integer.parseInt(catalog.getItemCount());
						tmp.setItemCount(String.valueOf(newItemCount));
						contains = true;
						break;
					}
				}
				if(!contains && catalog.getFlowNo().equals(processDefID)){
					catalogs.add(catalog);
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (Exception e){
			e.printStackTrace();
		}
		
		return catalogs;
	}
	
	/**
	 * 取得用户参与流程实例列表
	 * @param processDefID 流程定义编号
	 * @param activityID 活动定义编号
	 * @param milestone 里程碑（阶段类型）
	 * @param userID 用户编号
	 * @return 流程实例数组
	 */
	public String[] getUserProcessInstList(String processDefID, String activityID, String milestone, String userID){
		List<String> processInstList = new ArrayList<String>();
		String sAppID = APPID;
		String sUserID = userID;
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sTasks = services.getFlowServicePort().findUserTasks(sAppID, "", "", sUserID, "", "", "", "");
		JSONObject jObject;
		try {
			jObject = new JSONObject(sTasks);
			String taskCount = CommonUtil.getNodeValue(jObject, "TASKCOUNT", "");
			if(Integer.parseInt(taskCount) == 0){
				return null;
			}
			for(int i = 0; i < Integer.parseInt(taskCount); i++){
				String processInstID = CommonUtil.getNodeValue(jObject, "TASK"+i+".FLOW.FLOWINSTANCE.ID", "");
				String tmpFlowNo = CommonUtil.getNodeValue(jObject, "TASK"+i+".FLOW.FLOWDEFINITION.NAME", "");
				String tmpPhaseNo = CommonUtil.getNodeValue(jObject, "TASK"+i+".PARAMS.FLOW.STATE", "");
				String tmpPhaseType = CommonUtil.getNodeValue(jObject, "TASK"+i+".PARAMS.FLOW.MILESTONE", "");
				if(processDefID.equals(tmpFlowNo) && activityID.equals(tmpPhaseNo) && milestone.equals(tmpPhaseType)){
					processInstList.add(processInstID);
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (Exception e){
			e.printStackTrace();
		} 
		return (String[])processInstList.toArray(new String[processInstList.size()]);
	}
	
	/**
	 * 收回流程
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @param currentTaskID 当前任务编号
	 * @param arriveTaskID 目标任务编号
	 * @param nextOpinion 提交意见
	 * @param objects 流程相关数据(流程运转过程中需要的业务数据)
	 * @param userID 用户编号
	 * @return List<ProcessObject>
	 */
	public List<ProcessObject> withdrawProcessInst(String processDefID, String processInstID, String currentTaskID, String arriveTaskID, 
												   String nextAction, String nextOpinion, String objects, String userID) throws Exception {
		List<ProcessObject> processObjects = new ArrayList<ProcessObject>();
		// 从参数nextAction中解析nextAction/nextOpinion/taskID.此处为临时实现,实际应为流程引擎在收回时自动处理
		String withdrawTaskID = nextAction.split("@")[0];
		String nextState = nextAction.split("@")[1];
		String nextOwner = nextAction.split("@")[2];
		if (withdrawTaskID == null || "".equals(withdrawTaskID)
				|| nextState == null || "".equals(nextState)
				|| nextOwner == null || "".equals(nextOwner)) {
			logger.error("Withdraw error. WithdrawTaskID[" + withdrawTaskID + "] or NextAction[" + nextState + "] or NextOpinion["	+ nextOwner + "] illegal.");
			throw new Exception("Withdraw error. WithdrawTaskID[" + withdrawTaskID + "] or NextAction[" + nextState + "] or NextOpinion[" + nextOwner + "] illegal.");
		}
		String param = "{FLOW:{NEXTOWNER:'"+nextOwner+"',NEXTSTATE='"+nextState+"'}}";
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = "";
		
		//设置相关数据:此处为临时实现,实际处理中应由流程引擎在退回时自动将相关数据恢复到退回节点时的状态
		if(objects == null || "".equals(objects)){//应用并未传入相关数据
			//取当前任务的相关数据
			sResult = services.getFlowServicePort().getFlowObjects(APPID, "", "Task", withdrawTaskID);
			objects = setUserInfoToRD(nextOwner, sResult);//重新设置系统数据：S_UserInfo
		}
		//sResult = services.getFlowServicePort().completeTask(APPID, "", withdrawTaskID, "", objects, param, "");
		sResult = services.getFlowServicePort().doFlowAction(APPID, "", "RollbackTask", arriveTaskID, "", "", "", "", "", "");
		ResultObject rObject = new ResultObject(sResult);
		if (rObject.get("STATUS", "").equals("-1")) {
			logger.error("收回流程失败：" + rObject.get("MESSAGE", ""));
			throw new Exception("收回流程失败：" + rObject.get("MESSAGE", ""));
		}
		
		try {
			ProcessObject po = new ProcessObject();
			po.setMilestone(rObject.getResult("PARAMS.FLOW.MILESTONE", ""));
			po.setActivityID(rObject.getResult("PARAMS.FLOW.STATE", ""));
			po.setActivityName(rObject.getResult("PARAMS.FLOW.STATENAME", ""));
			//po.setActivityAction(actionName);
			
			String taskCount = rObject.getResult("TASK.TASKCOUNT", "");
			if(taskCount == null || "".equals(taskCount) || "0".equals(taskCount)){
				processObjects.add(po);
			} else {
				int count = Integer.parseInt(taskCount);
				for(int i = 0; i < count; i++){
					ProcessObject tpo = new ProcessObject();
					tpo.setAttributes(po);
					tpo.setTaskID(rObject.getResult("TASK.TASK"+i+".TASK.ID", ""));
					
					userID = rObject.getResult("TASK.TASK"+i+".TASK.ASSIGNEE", "");
					if(userID == null || "".equals(userID) || "GROUP_".equals(userID))	userID = "system";
					tpo.setUserID(userID);
					//System.out.println("assignee:"+userID);
					tpo.setActivityID(rObject.getResult("TASK.TASK"+i+".TASK.ACTIVITYNAME", ""));
					processObjects.add(tpo);
				}
			}
		} catch (Exception e) {
			logger.debug("取得收回流程返回对象失败" + e.getMessage(), e);
			throw new Exception("取得收回流程返回对象失败" + e.getMessage(), e);
		}
		
		return processObjects;
	}
	
	/**
	 * 
	 * 退回流程
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @param currentTaskID 当前任务编号
	 * @param arriveTaskID 目标任务编号
	 * @param nextAction 提交动作
	 * @param nextOpinion 提交意见
	 * @param objects 流程相关数据(流程运转过程中需要的业务数据)
	 * @param userID 用户编号
	 * @return List<ProcessObject>
	 */
	public List<ProcessObject> returnProcessInst(String processDefID, String processInstID, String currentTaskID, String arriveTaskID, 
												 String nextAction, String nextOpinion, String objects, String userID) throws Exception {
		List<ProcessObject> processObjects = new ArrayList<ProcessObject>();
		//查询退回的上一步是否是任务池
		String isPool = getActivityProperty(processDefID, currentTaskID, nextAction, "ISPOOL");
		String param = "{FLOW:{NEXTOWNER:'"+nextOpinion+"',NEXTSTATE='"+nextAction+"'}}";
		if("1".equals(isPool)){
			param = "{FLOW:{NEXTOWNER:'',NEXTGROUP:'" + nextOpinion + "',NEXTSTATE='" + nextAction + "'}}";
		}
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = "";
		//设置相关数据:此处为临时实现,实际处理中应由流程引擎在退回时自动将相关数据恢复到退回节点时的状态
		if(objects == null || "".equals(objects)){//应用并未传入相关数据
			//取当前任务的相关数据
			sResult = services.getFlowServicePort().getFlowObjects(APPID, "", "Task", currentTaskID);
			objects = setUserInfoToRD(nextOpinion, sResult);//重新设置系统数据：S_UserInfo
		}
		//sResult = services.getFlowServicePort().completeTask(APPID, "", taskID, "", objects, param, "");
		sResult = services.getFlowServicePort().doFlowAction(APPID, "", "RollbackTask", arriveTaskID, "", "", "", "", "", "");
		ResultObject rObject = new ResultObject(sResult);
		if (rObject.get("STATUS", "").equals("-1")) {
			logger.error("退回流程失败：" + rObject.get("MESSAGE", ""));
			throw new Exception("退回流程失败：" + rObject.get("MESSAGE", ""));
		}
		try {
			ProcessObject po = new ProcessObject();
			po.setMilestone(rObject.getResult("PARAMS.FLOW.MILESTONE", ""));
			po.setActivityID(rObject.getResult("PARAMS.FLOW.STATE", ""));
			po.setActivityName(rObject.getResult("PARAMS.FLOW.STATENAME", ""));
			po.setIsPool(isPool);
			//po.setActivityAction(actionName);
			
			String taskCount = rObject.getResult("TASK.TASKCOUNT", "");
			if(taskCount == null || "".equals(taskCount) || "0".equals(taskCount)){
				processObjects.add(po);
			} else {
				int count = Integer.parseInt(taskCount);
				for(int i = 0; i < count; i++){
					ProcessObject tpo = new ProcessObject();
					tpo.setAttributes(po);
					tpo.setTaskID(rObject.getResult("TASK.TASK"+i+".TASK.ID", ""));
					
					userID = rObject.getResult("TASK.TASK"+i+".TASK.ASSIGNEE", "");
					if(userID == null || "".equals(userID) || "GROUP_".equals(userID))	userID = "system";
					tpo.setUserID(userID);
					//System.out.println("assignee:"+userID);
					tpo.setActivityID(rObject.getResult("TASK.TASK"+i+".TASK.ACTIVITYNAME", ""));
					processObjects.add(tpo);
				}
			}
		} catch (Exception e) {
			logger.debug("取得退回流程返回对象失败" + e.getMessage(), e);
			throw new Exception("取得退回流程返回对象失败" + e.getMessage(), e);
		}
		return processObjects;
	}
	
	/**
	 * 根据流程定义取得活动坐标，用于生成流程图
	 * @param processDefID 流程定义编号, 如CBPutOutFlow
	 * @param taskID 任务编号
	 * @return String[] 坐标值数组
	 * @throws Exception
	 */
	public String[] getCoordinatesByDef(String processDefID, String taskID) throws Exception {
		String sAppID = APPID;
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = services.getFlowServicePort().getFlowContent(sAppID, "", "getTask", "", taskID, "", "");
		ResultObject rObject = new ResultObject(sResult);
		String definitionID = rObject.getResult("FLOW.FLOWDEFINITION.ID", "");
		String taskName = rObject.getResult("TASK.NAME", "");
		sResult = services.getFlowServicePort().getActivityCoordinates(sAppID, "", definitionID, taskName);
		String[] aPosition = StringUtil.split(sResult, ",");
		return aPosition;
	}
	
	/**
	 * 获取流程图
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @return String
	 * @throws Exception
	 */
	public String getFlowImage(String processDefID, String taskID) throws Exception {
		String sAppID = APPID;
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = services.getFlowServicePort().getFlowContent(sAppID, "", "getFlowImage", "Task", taskID, "", "");
		return sResult;
	}

	/**
	 * 根据阶段定义取得阶段属性值
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @param statePropertyId 阶段属性编号
	 * @return String 阶段属性值
	 * @throws Exception
	 */
	public String getFlowProperty(String processDefID, String taskID,String statePropertyId) throws Exception{
		return null;
	}
	
	/**
	 * 取得流程指定编号任务参数
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @return String 查询结果
	 */
	public String getTask(String processDefID,String taskID){
		String sResult = "";
		String sAppID = APPID;
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		sResult = services.getFlowServicePort().getFlowContent(sAppID, "", "getTask", "", taskID, "", "");
		return sResult;
	}

	/**
	 * 取得流程定义中某活动的属性
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @param activityID 活动定义编号
	 * @param property 属性编号
	 * @return String 属性值
	 */
	public String getActivityProperty(String processDefID, String taskID, String activityID, String property) {
		String sResult = "";
		String sAppID = APPID;
//		System.out.println("*********************");
//		System.out.println("processDefID="+processDefID);
//		System.out.println("taskID="+taskID);
//		System.out.println("activityID="+activityID);
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		try {
			sResult = services.getFlowServicePort().getFlowContent(sAppID,"", "getStateProperty","Task", taskID, "",activityID);
			System.out.println("==="+sResult);
			ResultObject rObject = new ResultObject(sResult);
			sResult = rObject.getResult(property, "");
		} catch (Exception e) {
			logger.debug(e.getMessage(), e);
			sResult = "";
		}
		return sResult;
	}
	
	/**
	 * 取得流程节点的上一个节点
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @param activityID 指定节点编号，为空为当前任务节点
	 * @return String 
	 */
	public String getPreActivity(String processDefID, String taskID, String activityID) throws Exception {
		if(activityID==null)activityID="";
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getPreActivity", "Task", taskID, activityID, "");
		return sResult;
	}
	
	/**
	 * 获取流程图
	 * @param processDefID 流程定义编号
	 * @param taskID 流程任务编号
	 * @return BufferedImage
	 * @throws Exception
	 */
	public BufferedImage getFlowGraph(String processDefID, String taskID) throws Exception {
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		//获取流程发布编号
		String sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getTask", "", taskID, "", "");
		ResultObject rObject = new ResultObject(sResult);
//		String deploymentID = rObject.getResult("FLOW.FLOWDEFINITION.DEPLOYMENTID", "");
		
		//获取流程图
		String sImage = services.getFlowServicePort().getFlowContent(APPID, "", "getFlowImage", "Task", taskID, "", "");
		byte[] bt = sImage.getBytes();
	    bt = Base64.decodeBase64(bt);
	    InputStream is = new ByteArrayInputStream(bt);
	    BufferedImage image = ImageIO.read(is);
	    Graphics2D graph = image.createGraphics();
	    
	    //取得当前坐标点
	    sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getTask","", taskID,"","");
		rObject = new ResultObject(sResult);
		sResult = services.getFlowServicePort().getActivityCoordinates(APPID, "", rObject.getResult("FLOW.FLOWDEFINITION.ID",""), rObject.getResult("TASK.NAME",""));
		String[] aPosition = StringUtil.split(sResult,",");
		
		//绘制当前坐标矩形
		graph.setColor(Color.red);
		graph.setStroke(new BasicStroke(3));
		graph.drawRect(Integer.parseInt(aPosition[0]), Integer.parseInt(aPosition[1]), Integer.parseInt(aPosition[2]), Integer.parseInt(aPosition[3]));
		return image;
	}
	
	/**
	 * 重置流程任务：将当前流程任务同步到指定任务状态<br>
	 * 如果原本状态已同步则流程引擎不做处理
	 * @param processDefID 流程定义编号
	 * @param taskID 需要同步到的流程任务编号
	 * @return
	 * @throws Exception
	 */
	public String restoreTask(String processDefID, String taskID) throws Exception {
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String result = services.getFlowServicePort().doFlowAction(APPID, processDefID, "RollbackTask", taskID, "", "", "", "", "", "");
		logger.info(result);
		ResultObject rObject = new ResultObject(result);
		String status = rObject.getResult("STATUS", "");
		if("1".equals(status)){
			return "SUCCESS";
		}else{
			return "FAILURE";
		}
	}
	
	/**
	 * 流程结束后恢复到结束前的阶段
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @return
	 * @throws Exception
	 */
	public String restoreInstance(String processDefID, String processInstID) throws Exception {
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		if(processInstID!=null && processInstID.split("\\.").length == 2){
			processInstID = processInstID.split("\\.")[1];
		}else{
			logger.error("流程实例编号格式错误：processInstID = "+processInstID+"!");
			return "FAILURE";
		}
		String result = services.getFlowServicePort().doFlowAction(APPID, processDefID, "RestoreInstance", processInstID, "", "", "", "", "", "");
		logger.info(result);
		ResultObject rObject = new ResultObject(result);
		String status = rObject.getResult("STATUS", "");
		if("1".equals(status)){
			return "SUCCESS";
		}else{
			return "FAILURE";
		}
	}
	
	/**
	 * 设置流程对象
	 * @param taskID 流程任务编号
	 * @param ObjectName 对象编号，eg:UserInfo.UserID
	 * @param ObjectValue 对象值
	 * @return String
	 * @throws Exception
	 */
	public String setProcessObject(String taskID, String ObjectName, String ObjectValue) throws Exception{
 		String sResult = "";
		try {
			if(taskID!=null) {
				FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
				sResult = services.getFlowServicePort().setFlowObject(APPID, "", "Task", taskID, ObjectName, ObjectValue);
				ResultObject rObject = new ResultObject(sResult);
				sResult = rObject.getResult("STATUS", "");
				if("1".equals(sResult)){
					return "SUCCESS";
				}
			}
		}catch (Exception e){
			throw new Exception("设置流程对象失败",e);
		}
		return "FAILURE";
	}
	
	
	/**
	 * 将用户信息设置到相关数据中
	 * @param userID 用户编号
	 * @param relativeData 相关数据
	 * @return 新的相关数据
	 */
	public String setUserInfoToRD(String userID, String relativeData) throws Exception {
		StringBuffer tempObject = new StringBuffer();
		PSUserObject user = PSUserObject.getUser(userID);
		String orgID = (user.getOrgID() == null) ? "" : user.getOrgID().replace("@", "");
		String userInfo = "\"S_UserInfo\":{\"UserID\":\"" + userID + "\",\"OrgID\":\"" + orgID + "\"}";
		if(relativeData == null || "".equals(relativeData)){//relativeData为空
			tempObject.append("{" + userInfo + "}");
		} else if(relativeData.startsWith("{") && relativeData.endsWith("}")){//relativeData以"{"开头且以"}"结尾
			ResultObject rObject = new ResultObject(relativeData);
			String S_UserInfo = rObject.getResult("S_UserInfo", "");
			if(!"".equals(S_UserInfo)){
				int begin = relativeData.indexOf("\"S_UserInfo\"");
				int end = relativeData.indexOf("}", begin);
				tempObject.append(relativeData)
						  .deleteCharAt(end)
						  .delete(begin, end)
						  .insert(begin,userInfo);
			} else
				tempObject.append(relativeData).insert(1, userInfo+",");
		} else {
			tempObject.append("{").append(userInfo).append(",").append(relativeData).append("}");
			logger.error("com.amarsoft.app.als.process.impl.AmarProcessService.startProcessInst: RelativeData format error." + relativeData);
			throw new Exception("RelativeData format error." + relativeData);
		}
		return tempObject.toString();
	}
	
	/**************************************
	 * getters and setters
	 **************************************/
	
	public Transaction getSqlca() {
		if(Sqlca == null)
			Sqlca = (Transaction)get(Context.CONTEXTNAME_SQLCA);
		return Sqlca;
	}
	
	public void setSqlca(Transaction sqlca) throws Exception {
		set(Context.CONTEXTNAME_SQLCA, sqlca);
		this.Sqlca = sqlca;
	}
	

	public static void main(String[] args) throws Exception {
		AmarProcessService cps = new AmarProcessService();
		System.out.println("--start--");
		cps.deleteProcessInst("CreditSingleFLow.10000");
		//启动流程
		//List<ProcessObject> pos = cps.startProcessInst("CreditFlow", "test11", "");
//		System.out.println(pos.size());
//		for(int i = 0; i < pos.size(); i++){
//			System.out.println(i + " item: " + 
//					"ActivityID:"+pos.get(i).getActivityID()+
//					", ActivityName:"+pos.get(i).getActivityName()+
//					", MileStone:"+pos.get(i).getMilestone()+
//					", FlowNo:"+pos.get(i).getProcessDefID()+
//					", FlowName:"+pos.get(i).getProcessDefName()+
//					", InstID"+pos.get(i).getProcessInstID()+
//					", TaskID"+pos.get(i).getTaskID());
//		}
		//删除流程实例
//		String s = cps.deleteProcessInst("CreditFlow.93");
//		System.out.println("@"+s+"@");
		
		//取得当前任务编号
//		String unfinishedTaskID = cps.getUnfinishedTaskNo("CreditFlow.11", "CreditFlow", "Task0", "test11");
//		System.out.println("@"+unfinishedTaskID+"@");
		
		//取得提交动作列表
//		Map<String,String> actions = cps.getTaskActions("CreditFlow", "289", "test11");
//		Set<Entry<String,String>> es = actions.entrySet();
//		Iterator<Entry<String,String>> it = es.iterator();
//		while(it.hasNext()){
//			Entry<String,String> e = it.next();
//			System.out.println(e.getKey() + " : " + e.getValue());
//		}
		
		//取得下阶段处理人
		//String[] users = cps.getNextOptionalUsers("CreditFlow", "Task6", "299", "test11");
		
		//提交流程
		//List<ProcessObject> pos = cps.commitProcessInst("CreditFlow", "CreditFlow.177", "183", "Task1", "test25", "");
		
		//取得阶段名称
		//String name = cps.getNexActivityName("CreditFlow", "", "", "Task2", "");
		//System.out.println("@"+name+"@");
		
		//取得阶段属性
		//String value = cps.getActivityProperty("CreditFlow", "Task1", "UnfinishedTaskButton");
		//System.out.println("--@"+value+"@");
		
		//cps.getRD("CreditFlow","135");
		
		//String s = cps.setUserInfoToRD("test12", "{\"S_BizObject\":{\"ObjectNo\":2011031000000008,\"ObjectType\":\"CreditApply\",\"ApplyType\":\"IndependentApply\"},\"S_UserInfo\":{\"OrgID\":11010090,\"UserID\":\"test12\"}}");
		
		//String sClass = cps.getClass().getName();
		//System.out.println(cps.getClass());
		
	}

}
