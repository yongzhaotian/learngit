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
 * Amar��������ʵ����
 * @author zszhang
 *
 */
public class AmarProcessService extends AbstractProcessService {
	
	private static final String APPID = "ALS7";//ȫ��Ӧ�ñ��,��ʶ��ǰӦ��ϵͳ
	private static final String USER_ROLE_JBO = "jbo.sys.USER_ROLE";//�û���ɫ����JBO
	private static final String SUCCESS_MESSAGE = "SUCCESS";
	private static final String FAILURE_MESSAGE = "FAILURE";
	
	private Transaction Sqlca = null;
	
	private JBOFactory factory = JBOFactory.getFactory();
	private BizObjectManager bom = null;
	private BizObjectQuery query = null;
	
	private Log logger = ARE.getLog();

	/**
	 * ��������ʵ��
	 * @param processDefID ���̶�����
	 * @param userID ���̷�����/ProcessInst Owner/The first activity participant
	 * @param objects �����������(������ת��������Ҫ��ҵ������)
	 * @return List<ProcessObject>
	 */
	public List<ProcessObject> startProcessInst(String processDefID, String userID, String objects) throws Exception {
		//����������ض���
		objects = setUserInfoToRD(userID, objects);
		
		//���õ�ǰ���������
		String param = "{FLOW:{NEXTOWNER:'"+ userID +"',GROUP:''}}"; 
		
		//����������
		String sResult = ""; 
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		System.out.println("APPID="+APPID+",processDefID="+processDefID+",objects="+objects+",param="+param+",sResult="+sResult);
		sResult = services.getFlowServicePort().startFlowInstance(APPID, processDefID, "Key", processDefID, "", objects, param, sResult);
		System.out.println("FlowInstance=" + sResult);
		ResultObject rObject = new ResultObject(sResult);
		if (rObject.get("STATUS", "").equals("-1")) {
			logger.error("��������ʧ�ܣ�" + rObject.get("MESSAGE", ""));
			throw new Exception("��������ʧ�ܣ�" + rObject.get("MESSAGE", ""));
		}
		
		/*
		 * ������������ʵ��������������Ϣ�������б�
		 */
		List<ProcessObject> processObjects = new ArrayList<ProcessObject>();
		try {
			ProcessObject po = new ProcessObject();
			po.setProcessDefID(rObject.getResult("FLOW.FLOWDEFINITION.NAME", ""));//���̶����� eg:TransformFlow
			po.setProcessDefName(rObject.getResult("FLOW.FLOWDEFINITION.DESCRIPTION", ""));//���̶������� eg:�Ŵ�����
			po.setProcessInstID(rObject.getResult("FLOW.FLOWINSTANCE.ID", ""));//����ʵ����� eg:TransformFlow.190001
			po.setActivityID(rObject.getResult("PARAMS.FLOW.STATE", ""));//��ǰ�ڵ��� eg:Task0
			po.setActivityName(rObject.getResult("PARAMS.FLOW.STATENAME", ""));//��ǰ�ڵ����� eg:�����Ŵ����ռ��
			po.setTaskID(rObject.getResult("TASK.ID", ""));//������ eg:190007
			po.setUserID(rObject.getResult("PARAMS.FLOW.NEXTOWNER", ""));//�û����  eg:test11
			po.setMilestone(rObject.getResult("PARAMS.FLOW.MILESTONE", ""));//��ǰ��̱�(�׶�����) eg:1020
			po.setObjectDescribe(rObject.getResult("FLOW.FLOWDEFINITION.ID", ""));//����ʱ���̶����� eg:TransformFlow-5
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
			logger.debug("����������������:��ȡ���̶������"+e.getMessage(), e);
			throw new Exception("����������������:��ȡ���̶������"+e.getMessage(), e);
		} catch (Exception e){
			logger.debug("����������������:��ȡ���̶������"+e.getMessage(), e);
			throw new Exception("����������������:��ȡ���̶������"+e.getMessage(), e);
		}
		
		return processObjects;
	}
	
	/**
	 * ɾ������ʵ��
	 * @param processInstID ����ʵ�����
	 * @return processInstID or Success/Failure or other String
	 */
	public String deleteProcessInst(String processInstID) throws Exception{
		try{
			FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
			String peResult = services.getFlowServicePort().deleteFlowInstanceCascade("", "", processInstID, "", "", "", "");
			ResultObject rObject = new ResultObject(peResult);
			if (rObject.get("STATUS", "").equals("1")) {
				logger.info("��������ɾ������ʵ���ɹ�:[processInstID="+processInstID+"]");
			}
		}catch(Exception e){
			logger.error("��������ɾ������ʵ��ʧ��,����ʵ����ɾ��������ʵ��������:[processInstID="+processInstID+"]", e);
			e.printStackTrace();
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * ȡ��������<br>
	 * �������̴�����û�������ʵ����ĳһ�ض��׶�(�ڵ�)����Ψһ������
	 * @param processInstID ����ʵ�����
	 * @param processDefID ���̶�����
	 * @param activityID �������
	 * @param userID ���������
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
			//System.out.println("com.amarsoft.app.als.process.impl.AmarProcessService.getUnfinishedTaskNo.getTaskNo:TaskCount��"+Integer.parseInt(taskCount) );
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
			logger.debug("��ȡ�������ų���"+e.getMessage(),e);
			throw new Exception("��ȡ�������ų���"+e.getMessage(),e);
		}
		System.out.println("com.amarsoft.app.als.process.impl.AmarProcessService.getUnfinishedTaskNo.getTaskNo:End:Result=" + sResult);
		return sResult;
	}
	
	/**
	 * ȡ�����������ύʱ�Ķ����б�,�ö����б��������˻ء��ջء��˻���һ��
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @param userID �û����
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
			//���û�ж��������ת,һ�������Ϊ�˻ز������ϻ�����ͨ��/���������ڵ�
			if(tCount + sCount == 0) {
				//�ж��Ƿ�Ϊ�˻ز������Ͻ׶�
				sResult = services.getFlowServicePort().getFlowParams(APPID, processDefID, "Task", taskID);
				rObject = new ResultObject(sResult);
				
				//�жϵ�ǰ�׶��Ƿ�Ϊ"�貹������"
				if("�貹������".equals(rObject.getResult("FLOW.STATENAME", "")) || 
				   "1030".equals(rObject.getResult("FLOW.MILESTONE", "")) ||
				   "3000".equals(rObject.getResult("FLOW.MILESTONE", ""))) {
					actions.put("������ȫ", rObject.getResult("FLOW.LASTSTATE", ""));
				}
			}
			
			if(actions == null || actions.size() <= 0){
				throw new Exception("ȡ�����������ύʱ�Ķ����б�ʧ��:δȡ����Ч���ύ����");
			}
			
		} catch (Exception e){
			logger.debug("ȡ�����������ύʱ�Ķ����б�ʧ��"+e.getMessage(), e);
			logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.restoreTask()][ProcessDefID="+processDefID+"][ProcessTaskID="+taskID+"]");
			this.restoreTask(processDefID, taskID);//ͬ����������״̬,��ֹ����׶�����Ӧ�õ�ǰ�׶�
			throw new Exception("ȡ�����������ύʱ�Ķ����б�ʧ��"+e.getMessage(), e);
		}
		return actions;
	}
	

	/**
	 * ȡ�����������ύʱ�ķ�֧�����б�
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @param ActivityNo ����
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
				throw new Exception("ȡ�����������ύʱ�ķ�֧�����б�ʧ��:δȡ����Ч���ύ����");
			}
			
		} catch (Exception e){
			logger.debug("ȡ�����������ύʱ�ķ�֧�����б�ʧ��"+e.getMessage(), e);
			throw new Exception("ȡ�����������ύʱ�ķ�֧�����б�ʧ��"+e.getMessage(), e);
		}
		return actions;
	}
	
	
	/**
	 * ȡ��������һ���ѡ�Ĳ������б�
	 * @param processDefID ���̶�����
	 * @param nextAction ��һ�
	 * @param taskID ������
	 * @param curUserID ��ǰ�û����
	 * @return
	 */
	public String[] getNextOptionalUsers(String processDefID, String nextAction, String taskID, String curUserID) throws Exception {
		String[] users = null;
		try {
			FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
			String sResult = services.getFlowServicePort().getFlowParams(APPID, "", "Task", taskID);
			ResultObject rObject = new ResultObject(sResult);
			
			//�жϵ�ǰ�׶��Ƿ�Ϊ"�貹������",���⴦��
			if("�貹������".equals(rObject.getResult("FLOW.STATENAME", "")) || 
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
				Sqlca = getSqlca(); //����������������л�ȡSqlca
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
				Sqlca = getSqlca(); //����������������л�ȡSqlca
				if(Sqlca == null)
					throw new Exception("******************* Sqlca is null. But it is needed! **********************");
				Any tmpUserList = Expression.getExpressionValue(roleScript, Sqlca);
				users = tmpUserList.toStringArray();
			} else {
				throw new Exception("Cann't support the roleType : [ "+roleType+" ]");
			}
		} catch (Exception e) {
			logger.debug("ȡ��������һ���ѡ�Ĳ������б�ʧ��"+e.getMessage(), e);
			throw new Exception("ȡ��������һ���ѡ�Ĳ������б�ʧ��"+e.getMessage(), e);
		} 
		return users;
	}
	
	/**
	 * ȡ�����̵�ǰ���ѡ�Ĳ������б�
	 * @param processDefID ���̶�����
	 * @param nextAction ��ǰ����
	 * @param taskID ������
	 * @param curUserID ��ǰ�û����
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
				Sqlca = getSqlca(); //����������������л�ȡSqlca
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
				Sqlca = getSqlca(); //����������������л�ȡSqlca
				if(Sqlca == null)
					throw new Exception("******************* Sqlca is null. But it is needed! **********************");
				Any tmpUserList = Expression.getExpressionValue(roleScript, Sqlca);
				users = tmpUserList.toStringArray();
			} else {
				throw new Exception("Cann't support the roleType : [ "+roleType+" ]");
			}
		} catch (Exception e) {
			logger.debug("ȡ�����̵�ǰ���ѡ�Ĳ������б�ʧ��"+e.getMessage(), e);
			throw new Exception("ȡ�����̵�ǰ���ѡ�Ĳ������б�ʧ��"+e.getMessage(), e);
		} 
		
		return users;
	}
	
	/**
	 * ȡ��������һ�����ؽ�ɫ
	 * @param processDefID ���̶�����
	 * @param nextAction ��һ�
	 * @param taskID ������
	 * @param curUserID ��ǰ�û����
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
			logger.debug("ȡ��������һ���ɫʧ��"+e.getMessage(), e);
			throw new Exception("ȡ��������һ���ɫʧ��"+e.getMessage(), e);
		}
		return role;
	}
	
	/**
	 * ����ǰ����ʵ�������ύ
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param taskID ��ǰ������
	 * @param nextAction �ύ����
	 * @param nextOpinion �ύ��� 
	 * @param objects �����������(������ת��������Ҫ��ҵ������)
	 * @return List<ProcessObject>
	 */
	public List<ProcessObject> commitProcessInst(String processDefID, String processInstID, String taskID, String nextAction, String nextOpinion, String objects) throws Exception {
		List<ProcessObject> processObjects = new ArrayList<ProcessObject>();
		//��ȡ�����������
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		
		//���δ����ѡ��������Ĭ��ѡ��TRANSITION0
		if ("".equals(nextAction.trim()) || nextAction == null) {
			String sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getOutObject", "Task", taskID, "", "");
			ResultObject rObject = new ResultObject(sResult);
			nextAction = rObject.get("TRANSITION0.TO", "");
		}
		
		//�Ƿ��ύ����
		String isPool = getActivityProperty(processDefID, taskID, nextAction, "ISPOOL");
		//�Ƿ���������
		String isSecretary = getActivityProperty(processDefID, taskID, nextAction, "ISSECRETARY");
		//��ȡ��Ϣ������ֵ
		String infoArea = getActivityProperty(processDefID, taskID, nextAction, "INFOAREA");
		//��ȡ��ҵ������ֵ
		String operateArea = getActivityProperty(processDefID, taskID, nextAction, "OPERATEAREA");
		//��ȡ��ť������ֵ
		String buttonArea = getActivityProperty(processDefID, taskID, nextAction, "BUTTONAREA");
		
		String nextUserID = "";
		if(nextOpinion == null || "".equals(nextOpinion)){//�˻ز������ϻ������Ƚ׶�Ӧ�ò����봦����
			if (!nextAction.startsWith("End") && !"1".equals(isPool)) {// �ų�����ؽ׶�
				String[] nextUsers = getNextOptionalUsers(processDefID, nextAction, taskID, "");
				if(nextUsers == null || nextUsers.length == 0) nextOpinion = "als";
			}
		}else{
			if(!nextAction.startsWith("Fork")){
				//�ύ�����������
				String [] nextUsers = nextOpinion.split(";");
				for(int i = 0; i < nextUsers.length; i++){
					nextUserID += "," + nextUsers[i].split(" ")[0];
				}
				if(!"".equals(nextUserID)) nextUserID = nextUserID.substring(1);
			}
		}
		
		// ��param����,���ַ�֧�ͻ���Լ��Ƿ�֧����Ϸ�ʽ
		ResultObject rObject = new ResultObject();
		String param = "";
		// ��֧
		if(nextAction.startsWith("Fork")){
			String forkUser = "";
			String[] temp = nextOpinion.split("-");
			for(int i = 0;i<temp.length;i++){
				forkUser += ","+temp[i].split("@")[0]+":{OWNER:'"+temp[i].split("@")[1]+"'}";
			}
			param = "{"+forkUser.substring(1)+"}";
		}else{
			// ���
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
		
		//�����û�������Ϣ
		String newObjects = "";
		if(!"".equals(nextUserID)){
			newObjects = setUserInfoToRD(nextUserID, objects);
		}else{
			newObjects = objects;
		}
		
		//�û���ɫ��Ϣ
		JSONObject jGroupID = null; 
		if (groupID != null) {
			//����AmarScript���ָ��������ַ���Ϊ��һ����ɫ�����ĸ�Ϊ�ڶ�����ɫ���������ơ�
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
			//������ɫ�б��ָ���һ���ַ���Ϊ��һ����ɫ���ڶ���Ϊ�ڶ�����ɫ���������ơ�
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
			logger.error("�ύ����ʧ�ܣ�" + rObject.get("MESSAGE", ""));
			throw new Exception("�ύ����ʧ�ܣ�" + rObject.get("MESSAGE", ""));
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
				//�����Ƿ��������
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
						//��ȡ��ǰ�����������
						String taskType = getActivityProperty(processDefID, tpo.getTaskID(), po.getActivityID(), "TASKTYPE");
						tpo.setTaskType(taskType);
						String userID = rObject.getResult("TASK.TASK"+i+".TASK.ASSIGNEE", "");
						if(userID == null || "".equals(userID) || "GROUP_".equals(userID))	userID = "system";
						//�����״ֱ̬�����ý�ɫ
						if ("1".equals(isPool)) {
							tpo.setUserID(nextOpinion);
						} else {//�����ȡTASK��ASSIGNEE������
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
			logger.debug("ȡ���ύ���̷��ض���ʧ��" + e.getMessage(), e);
			throw new Exception("ȡ���ύ���̷��ض���ʧ��" + e.getMessage(), e);
		}
		return processObjects;
	}
	
	/**
	 * �ύ������Ա���
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param taskID ������
	 * @param usersID �û����
	 * @param voteOpinion ͶƱ���
	 * @param objects �����������(������ת��������Ҫ��ҵ������)
	 * @return
	 * @throws Exception 
	 */
	public ProcessObject commitVote(String processDefID, String processInstID, String taskID, String userID, String voteOpinion, String nextOpinion, String objects) throws Exception{
		String param = "";
		ProcessObject po = new ProcessObject() ;
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		//���û�д�����һ���û���Ĭ��ΪStudio�нű����á�
		if(nextOpinion==null || "".equals(nextOpinion.trim())){
			param = "";
		}else{
			param = "{FLOW:{NEXTOWNER:'" + nextOpinion + "'}}";
		}
		
		if(objects == null || "".equals(objects)){
			objects = services.getFlowServicePort().getFlowObjects(APPID, "", "Task", taskID);
		}
		
		//���û�д���ͶƱ�����Ĭ��Ϊͨ��
		if(voteOpinion == null || "".equals(voteOpinion.trim())) voteOpinion="1";
		String sResult = services.getFlowServicePort().doFlowAction(APPID, "", "vote", taskID, userID, voteOpinion, "", param, objects, "");
		ResultObject rObject = new ResultObject(sResult);
		if (rObject.get("STATUS", "").equals("-1")) {
			logger.error("�ύ��ǩʧ�ܣ�" + rObject.get("MESSAGE", ""));
			throw new Exception("�ύ��ǩʧ�ܣ�" + rObject.get("MESSAGE", ""));
		}else{
			String taskCount = rObject.getResult("TASK.TASKCOUNT", "");
			System.out.println("taskCount:"+taskCount);
			//ͶƱ�ɹ����ύ���¸��׶�
			if("1".equals(taskCount)){
				po.setActivityID(rObject.getResult("PARAMS.FLOW.STATE", ""));
				po.setActivityName(rObject.getResult("PARAMS.FLOW.STATENAME", ""));
				po.setMilestone(rObject.getResult("PARAMS.FLOW.MILESTONE", ""));
				po.setUserID(rObject.getResult("TASK.TASK0.TASK.ASSIGNEE", ""));
				po.setTaskID(rObject.getResult("TASK.TASK0.TASK.ID", ""));
				po.setUserVote(rObject.getResult("RESULTS.VOTE.USERVOTE", ""));
				po.setGroupID(rObject.getResult("PARAMS.FLOW.NEXTGROUP", ""));
				//��ȡ��ǰ�����������
				String taskType = getActivityProperty(processDefID, rObject.getResult("TASK.TASK0.TASK.ID", ""), po.getActivityID(), "TASKTYPE");
				//�Ƿ���������
				String isSecretary = getActivityProperty(processDefID, rObject.getResult("TASK.TASK0.TASK.ID", ""), po.getActivityID(), "ISSECRETARY");
				//��ȡ��Ϣ������ֵ
				String infoArea = getActivityProperty(processDefID, rObject.getResult("TASK.TASK0.TASK.ID", ""), po.getActivityID(), "INFOAREA");
				//��ȡ��ҵ������ֵ
				String operateArea = getActivityProperty(processDefID, rObject.getResult("TASK.TASK0.TASK.ID", ""), po.getActivityID(), "OPERATEAREA");
				//��ȡ��ť������ֵ
				String buttonArea = getActivityProperty(processDefID, rObject.getResult("TASK.TASK0.TASK.ID", ""), po.getActivityID(), "BUTTONAREA");
				//��ȡ�Ƿ������
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
//				throw new Exception("��ѯ���̽��ʧ��",e);
//			}
		}
		System.out.println("Vote Result:"+sResult);
		return po;
	}
	
	/**
	 * ���Ӵ�����Ա
	 * @param processDefID ���̶�����
	 * @param taskID ����������
	 * @param users �����ӵĳ�Ա�б� user1,user2,user3
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
			logger.error("����������Աʧ�ܣ�" + rObject.get("MESSAGE", ""));
			throw new Exception("����������Աʧ�ܣ�" + rObject.get("MESSAGE", ""));
		}
	}
	
	/**
	 * �Ƴ�������Ա
	 * @param processDefID ���̶�����
	 * @param taskID ����������
	 * @param users ���Ƴ��ĳ�Ա�б� user1,user2,user3
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
			logger.error("ɾ��������Աʧ�ܣ�" + rObject.get("MESSAGE", ""));
			throw new Exception("ɾ��������Աʧ�ܣ�" + rObject.get("MESSAGE", ""));
		}
	}
	
	/**
	 * ��������л�ȡ����
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @param userID �û����
	 * @return
	 * @throws Exception
	 */
	public String takeTaskFromPool(String processDefID, String taskID, String userID) throws Exception{
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = services.getFlowServicePort().takeTask(APPID,  "",  taskID, userID, "", "", "", "");
		ResultObject rObject = new ResultObject(sResult);
		if (rObject.get("STATUS", "").equals("-1")) {
			logger.error("��ȡ����ʧ�ܣ�" + rObject.get("MESSAGE", ""));
			throw new Exception("��ȡ����ʧ�ܣ�" + rObject.get("MESSAGE", ""));
		}
		return "SUCCESS";
	}
	
	/**
	 * ȡ����һ�����--ʾ��ʵ��,��������һ����
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param taskID ��ǰ������
	 * @param nextAction �ύ����
	 * @param nextOpinion �ύ���
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
	 * ȡ����һ���̱�
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param taskID ��ǰ������
	 * @param nextAction �ύ����
	 * @param nextOpinion �ύ���
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
	 * ȡ�ú���������
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param taskID ��ǰ������
	 * @param nextAction �ύ����
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
	 * ȡ���û������б�����,����������ͼչʾ
	 * @param userID �û����
	 * @param processDefID ���̶�����
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
				catalog.setFinishFlag("N");//δ��ɹ���
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
	 * ȡ���û���������ʵ���б�
	 * @param processDefID ���̶�����
	 * @param activityID �������
	 * @param milestone ��̱����׶����ͣ�
	 * @param userID �û����
	 * @return ����ʵ������
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
	 * �ջ�����
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param currentTaskID ��ǰ������
	 * @param arriveTaskID Ŀ��������
	 * @param nextOpinion �ύ���
	 * @param objects �����������(������ת��������Ҫ��ҵ������)
	 * @param userID �û����
	 * @return List<ProcessObject>
	 */
	public List<ProcessObject> withdrawProcessInst(String processDefID, String processInstID, String currentTaskID, String arriveTaskID, 
												   String nextAction, String nextOpinion, String objects, String userID) throws Exception {
		List<ProcessObject> processObjects = new ArrayList<ProcessObject>();
		// �Ӳ���nextAction�н���nextAction/nextOpinion/taskID.�˴�Ϊ��ʱʵ��,ʵ��ӦΪ�����������ջ�ʱ�Զ�����
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
		
		//�����������:�˴�Ϊ��ʱʵ��,ʵ�ʴ�����Ӧ�������������˻�ʱ�Զ���������ݻָ����˻ؽڵ�ʱ��״̬
		if(objects == null || "".equals(objects)){//Ӧ�ò�δ�����������
			//ȡ��ǰ������������
			sResult = services.getFlowServicePort().getFlowObjects(APPID, "", "Task", withdrawTaskID);
			objects = setUserInfoToRD(nextOwner, sResult);//��������ϵͳ���ݣ�S_UserInfo
		}
		//sResult = services.getFlowServicePort().completeTask(APPID, "", withdrawTaskID, "", objects, param, "");
		sResult = services.getFlowServicePort().doFlowAction(APPID, "", "RollbackTask", arriveTaskID, "", "", "", "", "", "");
		ResultObject rObject = new ResultObject(sResult);
		if (rObject.get("STATUS", "").equals("-1")) {
			logger.error("�ջ�����ʧ�ܣ�" + rObject.get("MESSAGE", ""));
			throw new Exception("�ջ�����ʧ�ܣ�" + rObject.get("MESSAGE", ""));
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
			logger.debug("ȡ���ջ����̷��ض���ʧ��" + e.getMessage(), e);
			throw new Exception("ȡ���ջ����̷��ض���ʧ��" + e.getMessage(), e);
		}
		
		return processObjects;
	}
	
	/**
	 * 
	 * �˻�����
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @param currentTaskID ��ǰ������
	 * @param arriveTaskID Ŀ��������
	 * @param nextAction �ύ����
	 * @param nextOpinion �ύ���
	 * @param objects �����������(������ת��������Ҫ��ҵ������)
	 * @param userID �û����
	 * @return List<ProcessObject>
	 */
	public List<ProcessObject> returnProcessInst(String processDefID, String processInstID, String currentTaskID, String arriveTaskID, 
												 String nextAction, String nextOpinion, String objects, String userID) throws Exception {
		List<ProcessObject> processObjects = new ArrayList<ProcessObject>();
		//��ѯ�˻ص���һ���Ƿ��������
		String isPool = getActivityProperty(processDefID, currentTaskID, nextAction, "ISPOOL");
		String param = "{FLOW:{NEXTOWNER:'"+nextOpinion+"',NEXTSTATE='"+nextAction+"'}}";
		if("1".equals(isPool)){
			param = "{FLOW:{NEXTOWNER:'',NEXTGROUP:'" + nextOpinion + "',NEXTSTATE='" + nextAction + "'}}";
		}
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = "";
		//�����������:�˴�Ϊ��ʱʵ��,ʵ�ʴ�����Ӧ�������������˻�ʱ�Զ���������ݻָ����˻ؽڵ�ʱ��״̬
		if(objects == null || "".equals(objects)){//Ӧ�ò�δ�����������
			//ȡ��ǰ������������
			sResult = services.getFlowServicePort().getFlowObjects(APPID, "", "Task", currentTaskID);
			objects = setUserInfoToRD(nextOpinion, sResult);//��������ϵͳ���ݣ�S_UserInfo
		}
		//sResult = services.getFlowServicePort().completeTask(APPID, "", taskID, "", objects, param, "");
		sResult = services.getFlowServicePort().doFlowAction(APPID, "", "RollbackTask", arriveTaskID, "", "", "", "", "", "");
		ResultObject rObject = new ResultObject(sResult);
		if (rObject.get("STATUS", "").equals("-1")) {
			logger.error("�˻�����ʧ�ܣ�" + rObject.get("MESSAGE", ""));
			throw new Exception("�˻�����ʧ�ܣ�" + rObject.get("MESSAGE", ""));
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
			logger.debug("ȡ���˻����̷��ض���ʧ��" + e.getMessage(), e);
			throw new Exception("ȡ���˻����̷��ض���ʧ��" + e.getMessage(), e);
		}
		return processObjects;
	}
	
	/**
	 * �������̶���ȡ�û���꣬������������ͼ
	 * @param processDefID ���̶�����, ��CBPutOutFlow
	 * @param taskID ������
	 * @return String[] ����ֵ����
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
	 * ��ȡ����ͼ
	 * @param processDefID ���̶�����
	 * @param taskID ������
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
	 * ���ݽ׶ζ���ȡ�ý׶�����ֵ
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @param statePropertyId �׶����Ա��
	 * @return String �׶�����ֵ
	 * @throws Exception
	 */
	public String getFlowProperty(String processDefID, String taskID,String statePropertyId) throws Exception{
		return null;
	}
	
	/**
	 * ȡ������ָ������������
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @return String ��ѯ���
	 */
	public String getTask(String processDefID,String taskID){
		String sResult = "";
		String sAppID = APPID;
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		sResult = services.getFlowServicePort().getFlowContent(sAppID, "", "getTask", "", taskID, "", "");
		return sResult;
	}

	/**
	 * ȡ�����̶�����ĳ�������
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @param activityID �������
	 * @param property ���Ա��
	 * @return String ����ֵ
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
	 * ȡ�����̽ڵ����һ���ڵ�
	 * @param processDefID ���̶�����
	 * @param taskID ������
	 * @param activityID ָ���ڵ��ţ�Ϊ��Ϊ��ǰ����ڵ�
	 * @return String 
	 */
	public String getPreActivity(String processDefID, String taskID, String activityID) throws Exception {
		if(activityID==null)activityID="";
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		String sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getPreActivity", "Task", taskID, activityID, "");
		return sResult;
	}
	
	/**
	 * ��ȡ����ͼ
	 * @param processDefID ���̶�����
	 * @param taskID ����������
	 * @return BufferedImage
	 * @throws Exception
	 */
	public BufferedImage getFlowGraph(String processDefID, String taskID) throws Exception {
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		//��ȡ���̷������
		String sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getTask", "", taskID, "", "");
		ResultObject rObject = new ResultObject(sResult);
//		String deploymentID = rObject.getResult("FLOW.FLOWDEFINITION.DEPLOYMENTID", "");
		
		//��ȡ����ͼ
		String sImage = services.getFlowServicePort().getFlowContent(APPID, "", "getFlowImage", "Task", taskID, "", "");
		byte[] bt = sImage.getBytes();
	    bt = Base64.decodeBase64(bt);
	    InputStream is = new ByteArrayInputStream(bt);
	    BufferedImage image = ImageIO.read(is);
	    Graphics2D graph = image.createGraphics();
	    
	    //ȡ�õ�ǰ�����
	    sResult = services.getFlowServicePort().getFlowContent(APPID, "", "getTask","", taskID,"","");
		rObject = new ResultObject(sResult);
		sResult = services.getFlowServicePort().getActivityCoordinates(APPID, "", rObject.getResult("FLOW.FLOWDEFINITION.ID",""), rObject.getResult("TASK.NAME",""));
		String[] aPosition = StringUtil.split(sResult,",");
		
		//���Ƶ�ǰ�������
		graph.setColor(Color.red);
		graph.setStroke(new BasicStroke(3));
		graph.drawRect(Integer.parseInt(aPosition[0]), Integer.parseInt(aPosition[1]), Integer.parseInt(aPosition[2]), Integer.parseInt(aPosition[3]));
		return image;
	}
	
	/**
	 * �����������񣺽���ǰ��������ͬ����ָ������״̬<br>
	 * ���ԭ��״̬��ͬ�����������治������
	 * @param processDefID ���̶�����
	 * @param taskID ��Ҫͬ����������������
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
	 * ���̽�����ָ�������ǰ�Ľ׶�
	 * @param processDefID ���̶�����
	 * @param processInstID ����ʵ�����
	 * @return
	 * @throws Exception
	 */
	public String restoreInstance(String processDefID, String processInstID) throws Exception {
		FlowServices services = AmarProcessEngineConnection.getPEConn().getFlowService();
		if(processInstID!=null && processInstID.split("\\.").length == 2){
			processInstID = processInstID.split("\\.")[1];
		}else{
			logger.error("����ʵ����Ÿ�ʽ����processInstID = "+processInstID+"!");
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
	 * �������̶���
	 * @param taskID ����������
	 * @param ObjectName �����ţ�eg:UserInfo.UserID
	 * @param ObjectValue ����ֵ
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
			throw new Exception("�������̶���ʧ��",e);
		}
		return "FAILURE";
	}
	
	
	/**
	 * ���û���Ϣ���õ����������
	 * @param userID �û����
	 * @param relativeData �������
	 * @return �µ��������
	 */
	public String setUserInfoToRD(String userID, String relativeData) throws Exception {
		StringBuffer tempObject = new StringBuffer();
		PSUserObject user = PSUserObject.getUser(userID);
		String orgID = (user.getOrgID() == null) ? "" : user.getOrgID().replace("@", "");
		String userInfo = "\"S_UserInfo\":{\"UserID\":\"" + userID + "\",\"OrgID\":\"" + orgID + "\"}";
		if(relativeData == null || "".equals(relativeData)){//relativeDataΪ��
			tempObject.append("{" + userInfo + "}");
		} else if(relativeData.startsWith("{") && relativeData.endsWith("}")){//relativeData��"{"��ͷ����"}"��β
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
		//��������
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
		//ɾ������ʵ��
//		String s = cps.deleteProcessInst("CreditFlow.93");
//		System.out.println("@"+s+"@");
		
		//ȡ�õ�ǰ������
//		String unfinishedTaskID = cps.getUnfinishedTaskNo("CreditFlow.11", "CreditFlow", "Task0", "test11");
//		System.out.println("@"+unfinishedTaskID+"@");
		
		//ȡ���ύ�����б�
//		Map<String,String> actions = cps.getTaskActions("CreditFlow", "289", "test11");
//		Set<Entry<String,String>> es = actions.entrySet();
//		Iterator<Entry<String,String>> it = es.iterator();
//		while(it.hasNext()){
//			Entry<String,String> e = it.next();
//			System.out.println(e.getKey() + " : " + e.getValue());
//		}
		
		//ȡ���½׶δ�����
		//String[] users = cps.getNextOptionalUsers("CreditFlow", "Task6", "299", "test11");
		
		//�ύ����
		//List<ProcessObject> pos = cps.commitProcessInst("CreditFlow", "CreditFlow.177", "183", "Task1", "test25", "");
		
		//ȡ�ý׶�����
		//String name = cps.getNexActivityName("CreditFlow", "", "", "Task2", "");
		//System.out.println("@"+name+"@");
		
		//ȡ�ý׶�����
		//String value = cps.getActivityProperty("CreditFlow", "Task1", "UnfinishedTaskButton");
		//System.out.println("--@"+value+"@");
		
		//cps.getRD("CreditFlow","135");
		
		//String s = cps.setUserInfoToRD("test12", "{\"S_BizObject\":{\"ObjectNo\":2011031000000008,\"ObjectType\":\"CreditApply\",\"ApplyType\":\"IndependentApply\"},\"S_UserInfo\":{\"OrgID\":11010090,\"UserID\":\"test12\"}}");
		
		//String sClass = cps.getClass().getName();
		//System.out.println(cps.getClass());
		
	}

}
