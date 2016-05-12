package com.amarsoft.app.als.process.action;

import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.process.Context;
import com.amarsoft.app.als.process.ProcessService;
import com.amarsoft.app.als.process.ProcessServiceFactory;
import com.amarsoft.app.als.process.data.HistoryTaskObject;
import com.amarsoft.app.als.process.data.ProcessObject;
import com.amarsoft.app.als.process.data.RelativeBusinessObject;
import com.amarsoft.app.als.process.util.PSUserObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.core.object.ResultObject;

/**
 * 业务流程动作处理.主要处理提交/退回/收回/退回前一处理人/退回补充资料  等流程动作
 * @author zszhang
 *
 */
public class BusinessProcessAction {
	private static final String SUCCESS_MESSAGE = "SUCCESS";
	private static final String FAILURE_MESSAGE = "FAILURE";
	
	private Transaction Sqlca;        //应用层数据库事务
	private JBOTransaction tx;        //JBO事务
	private boolean isNewTX = false;  //本类中使用事务是否为新创建
	
	private String userID;            //用户编号
	private String orgID;             //机构编号
	private String objectNo;          //对象编号
	private String objectType;		  //对象类型
	private String applyType;         //申请类型
	private String processDefID;      //流程定义编号
	private String processInstID;     //流程实例编号
	private String processTaskID;     //流程任务编号(与流程引擎任务编号对应)
	private String bizProcessObjectID;//业务对象编号(与应用系统流程对象编号对应)
	private String bizProcessTaskID;  //业务任务编号(与应用系统流程任务编号对应)
	private String phaseNo;           //当前阶段编号(与流程引擎里活动编号对应)
	private String phaseType;         //当前阶段类型(与流程引擎里程碑对应)
	private String property;		  //流程阶段属性
	private String processAction;     //流程提交动作
	private String taskParticipants;  //流程任务参与人
	private String relativeData;      //流程相关数据
	private String processState;      //流程状态
	private String bizAssignedTaskID; //指定下一阶段流程任务编号
	private String voteSerialNo;      //贷审会议编号

	
	private ProcessService ps = ProcessServiceFactory.getService();   //流程引擎服务
	private BusinessProcessActionAssistor bpActionAssistor;           //业务流程操作辅助类
	
	Log logger = ARE.getLog();
	
	/**
	 * 默认构造函数
	 */
	public BusinessProcessAction(){
		this.bpActionAssistor = new BusinessProcessActionAssistor(getTx());
		this.bpActionAssistor.setNewTX(isNewTX);
	}
	
	/**
	 * 传入外部事务的构造函数
	 * @param tx
	 */
	public BusinessProcessAction(JBOTransaction tx){
		this.tx = tx;
		this.bpActionAssistor = new BusinessProcessActionAssistor(tx);
	}
	
	/**
	 * 启动流程
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>userID:流程发起人编号(用户编号)
	 * <li>objectNo:对象编号
	 * <li>objectType:对象类型
	 * <li>applyType:申请类型
	 * </ul>
	 * <ul>可选参数:
	 * <li>processState:流程状态（如果不传，默认为1010）
	 * <li>relativeData:流程相关数据
	 * <li>tx:本类中使用的事务
	 * </ul>
	 * @return SUCCESS
	 * @throws Exception
	 */
	public String start() throws Exception {
		
		List<ProcessObject> processObjects = null;//定义提交操作返回流程对象
		RelativeBusinessObject businessObject = initBusinessObject(); //初始化默认业务对象,传递业务参数
		
		try{
			//启动流程的预处理,初始化流程相关数据
			relativeData = bpActionAssistor.preStart(businessObject, relativeData);
		
        	logger.info("********PE_ACTION_START_BEGIN:" + this.getClass().getName() + ".start:"+processDefID);
        	initPSContext();//初始化流程引擎服务上下文
        	processObjects = ps.startProcessInst(processDefID, userID, relativeData); //启动流程
        	logger.info("********PE_ACTION_START_END:" + this.getClass().getName() + ".start:"+processDefID);
        	
        	//启动流程的后处理,生成业务流程数据
        	bpActionAssistor.postStart(processDefID, userID, processState, businessObject, processObjects);
        	commitTx();
        } catch (Exception e){
        	logger.debug("ProcessEngine start process instance["+processDefID+"] error."+e.getMessage(), e);
        	rollbackTx();
        	throw new Exception("ProcessEngine start process instance["+processDefID+"] error."+e.getMessage(), e);
        }
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 复制流程.复制流程相当于重新发起一笔,需要注意的是复制流程前应先复制业务信息
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>userID:流程发起人编号(用户编号)
	 * <li>objectNo:业务申请编号,此处的对象编号应为新的业务编号
	 * <li>applyType:业务申请类型
	 *  </ul>
	 * <ul>可选参数:
	 * <li>relativeData:流程相关数据
	 * <li>tx:本类中使用的事务
	 * </ul>
	 * @return SUCCESS/FAILURE
	 * @throws Exception
	 */
	public String copy() throws Exception {
		return start();
	}

	/**
	 * 发起再议.<br>
	 * Modify:在再议阶段可以发起再议,默认提交到客户经理的下一个阶段
	 * <ul>具体操作为:
	 * <li>关闭当前再议任务
	 * <li>Task新增一条发起再议
	 * <li>更新Object相关记录
	 * </ul>
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessTaskID:流程任务编号
	 *  </ul>
	 * <ul>可选参数:
	 * <li>processState:流程状态，如果不传，则默认为阶段名称
	 * <li>tx:本类中使用的事务
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String reConsider() throws Exception {
		String result = "";
		try{
			result = bpActionAssistor.postReConsider(processDefID, bizProcessTaskID, processState);
			if(SUCCESS_MESSAGE.equals(result)){
	        	commitTx();
	        } else {
	        	rollbackTx();
	        }
		} catch (Exception e) {
			logger.debug("ProcessEngine reConsider process ["+processDefID+"] error."+e.getMessage(), e);
			rollbackTx();
			throw new Exception("ProcessEngine reConsider process ["+processDefID+"] error."+e.getMessage(), e);
		}
		return result;
	}
	
	/**
	 * 取消流程<br>
	 * 取消流程做以下处理：<br>
	 * 1.应用系统删除Object/Task<br>
	 * 2.流程引擎删除流程实例<br>
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>processInstID:流程实例编号
	 * <li>bizProcessObjectID:业务流程对象编号
	 * </ul>
	 * <ul>可选参数:
	 * <li>tx:本类中使用的事务
	 * </ul>
	 * @return SUCCESS/FAILURE
	 * @throws Exception
	 */
	public String delete() throws Exception {
		String result = FAILURE_MESSAGE;
		try{
			//应用系统删除业务数据
			result = bpActionAssistor.doDelete(processDefID, bizProcessObjectID);
			if(!SUCCESS_MESSAGE.equals(result)){
				throw new Exception("应用系统删除业务数据失败:[bizProcessObjectID="+bizProcessObjectID+"]");
			}
			
			//流程引擎删除流程实例
			logger.info("PE_ACTION_DELETE_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.delete:"+processDefID);
			initPSContext();//初始化流程引擎服务上下文
	        ps.deleteProcessInst(processInstID); //删除流程实例
	        logger.info("PE_ACTION_DELETE_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.delete:"+processDefID);
	        if(SUCCESS_MESSAGE.equals(result)){
	        	commitTx();
	        }else{
	        	rollbackTx();
	        }
	        
		} catch (Exception e) {
			logger.debug("ProcessEngine delete process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
			rollbackTx();
			throw new Exception("ProcessEngine delete process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
		}
		
		return result;
	}
	
	/**
	 * 取得流程提交时的下一阶段动作列表
	 * @param processDefID 流程定义编号
	 * @param processTaskID 当前任务编号
	 * @param userID 用户编号(非必须)
	 * @param Sqlca Transaction
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> getTaskActions(String processDefID,String processTaskID,String userID, Transaction Sqlca) throws Exception {
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		return ps.getTaskActions(processDefID, processTaskID, userID);
	}
	
	/**
	 * 取得流程提交时的下一阶段分支动作列表
	 * @param processDefID 流程定义编号
	 * @param processTaskID 当前任务编号
	 * @param phaseNo 阶段编号
	 * @param Sqlca Transaction
	 * @return
	 * @throws Exception
	 */
	public String getForkActions(Transaction Sqlca) throws Exception {
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		Map<String,String> actions = new LinkedHashMap<String,String>();
		actions = ps.getForkActions(processDefID, processTaskID, phaseNo);
		
		String options = "";
		//生成JSON
		for(int i=0;i<actions.size();i++){
			options += ("[\""+actions.keySet().toArray()[i]+"\"],[\""+actions.values().toArray()[i]+"\"],");
		}
		if(options.length() > 0){
			options = options.substring(0,options.length()-1);
		}
		return options;
	}
	
	/**
	 * 取得流程引擎中用户参与处理的某节点的任务编号
	 * <ul>必须参数：
	 * <li>processInstID:流程实例编号
	 * <li>processDefID:流程定义编号
	 * <li>phaseNo:活动编号
	 * <li>userID:用户编号
	 * </ul>
	 * @return
	 */
	public String getUnfinishedPETaskID() throws Exception {
		return ps.getUnfinishedTaskNo(processInstID, processDefID, phaseNo, userID);
	}
	
	/**
	 * 取得应用系统当前流程实例最新的任务编号
	 * <ul>必须参数：
	 * <li>bizProcessObjectID:业务流程对象编号
	 * <li>processDefID:流程定义编号
	 * </ul>
	 * <ul>可选参数：
	 * <li>userID:申请编号
	 * </ul>
	 * @return
	 */
	public String getUnfinishedBusinessTaskID(){
		String serialNo = "";
		BizObjectQuery q = null;
		try{
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
			
			if("".equals(userID.trim()) || userID == null){
				String query = "RelativeObjectNo =:RelativeObjectNo and TaskState <> '1' and TaskState <> '2' and TaskState <> '99'";
				q = bom.createQuery(query).setParameter("RelativeObjectNo", bizProcessObjectID);
				
			}else{
				String query = "RelativeObjectNo =:RelativeObjectNo and UserID = :UserID and TaskState <> '1' and TaskState <> '2' and TaskState <> '99'";
				q = bom.createQuery(query).setParameter("RelativeObjectNo", bizProcessObjectID)
									  .setParameter("UserID", userID);
			}
			BizObject o = q.getSingleResult(false);
			if(o != null) serialNo = o.getAttribute("SerialNo").getString();
			else
				ARE.getLog().error("com.amarsoft.app.als.process.action.BusinessTaskAction.getUnfinishedBusinessTaskID: Can't find this task!");
		} catch(JBOException e){
			ARE.getLog().debug("获取应用系统业务任务编号出错",e);
		}
		return serialNo;
	}
	
	/**
	 * 提交流程
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>processInstID:流程实例编号
	 * <li>processTaskID:流程任务编号
	 * <li>processAction:流程提交动作
	 * <li>userID:流程提交人
	 * <li>taskParticipants:流程处理人
	 * <li>bizProcessObjectID:业务流程对象编号
	 * <li>bizProcessTaskID:业务流程任务编号
	 * </ul>
	 * <ul>可选参数:
	 * <li>processState:流程状态（如果不传，默认为1020）
	 * <li>relativeData:流程相关数据
	 * <li>VoteSerialNo:贷审会议编号
	 * <li>bizAssignedTaskID:指定下面阶段流程任务编号，多步用逗号分隔。
	 * <li>tx:本类中使用的事务
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String commit(Transaction Sqlca) throws Exception {
		//判断当前任务是否已提交
		if(this.isCommited(bizProcessTaskID)) return FAILURE_MESSAGE;
		
		String result = "";
		//设置Sqlca
		this.Sqlca = Sqlca;
		//初始化业务对象,传递业务参数
		RelativeBusinessObject businessObject = initBusinessObject(); 
		//初始化流程引擎服务上下文
		initPSContext();
		
		try {
			//会签提交
			if(businessObject.getPhaseNo().startsWith("CounterSign")){
				//提交流程的预处理,初始化流程相关数据
				relativeData = bpActionAssistor.preCommit(businessObject, relativeData);
				//流程引擎中提交流程
				logger.info("PE_ACTION_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
				
				//如果未传入会签意见，默认为通过
				if(processAction == null || "".equals(processAction)) processAction = "1";
				//会签提交
		        ProcessObject processObject = ps.commitVote(processDefID, processInstID, processTaskID, userID, processAction, taskParticipants, relativeData);
		        logger.info("PE_ACTION_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
		        
		        result = bpActionAssistor.commitVoteAssistant(processDefID, bizProcessObjectID, bizProcessTaskID, voteSerialNo, userID, processAction, taskParticipants, businessObject, processObject);
		        
		        if(SUCCESS_MESSAGE.equals(result)) {
		        	commitTx();
		        } else {
		        	rollbackTx();
		        	//logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.commit()][ProcessDefID="+processDefID+"][ProcessTaskID="+processTaskID+"]");
		        	//ps.restoreTask(processDefID, processTaskID);//流程引擎回滚提交
		        }
			}else{
				//提交流程的预处理,初始化流程相关数据
				relativeData = bpActionAssistor.preCommit(businessObject, relativeData);
				//流程引擎中提交流程
				logger.info("PE_ACTION_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
				//提交流程
				String[] users = ps.getNextOptionalUsers(processDefID, processAction, processTaskID, userID);
				
		        List<ProcessObject> processObjects = ps.commitProcessInst(processDefID, processInstID, processTaskID, processAction, taskParticipants, relativeData);
		        logger.info("PE_ACTION_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
		        
		        //只提交到角色不提交到具体人员的情况下，获取所有能提交的人员列表
				if (taskParticipants == null) {
					taskParticipants = "";
					if (users != null) {
						for (int i = 0; i < users.length; i++) {
							taskParticipants = taskParticipants + users[i] + ",";
						}
					}
					if (!"".equals(taskParticipants))
						taskParticipants = taskParticipants.substring(0,
								taskParticipants.length() - 1);
				}
				
		        result = bpActionAssistor.commitAssistant(processDefID, bizProcessObjectID, bizProcessTaskID, voteSerialNo, userID, processAction, taskParticipants, businessObject, processObjects, processState, bizAssignedTaskID);
		        if(SUCCESS_MESSAGE.equals(result)) {
		        	commitTx();
		        } else {
		        	rollbackTx();
		        	//logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.commit()][ProcessDefID="+processDefID+"][ProcessTaskID="+processTaskID+"]");
		        	//ps.restoreTask(processDefID, processTaskID);//流程引擎回滚提交
		        }
			}
		} catch (Exception e){
			logger.debug("ProcessEngine commit process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
			rollbackTx();
			//logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.commit()][ProcessDefID="+processDefID+"][ProcessTaskID="+processTaskID+"]");
			//ps.restoreTask(processDefID, processTaskID);//流程引擎回滚提交
			throw new Exception("ProcessEngine commit process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
		}
		
		return result;
	}
	
	/**
	 * 提交流程到指定阶段（该阶段为流程曾经流转过的阶段）
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>processInstID:流程实例编号
	 * <li>processTaskID:流程任务编号
	 * <li>bizProcessObjectID:业务流程对象编号
	 * <li>bizProcessTaskID:业务流程任务编号
	 * <li>bizAssignedTaskID:指定阶段流程任务编号
	 * </ul>
	 * <ul>可选参数:
	 * <li>processState:流程状态（如果不传，默认为1020）
	 * <li>relativeData:流程相关数据
	 * <li>tx:本类中使用的事务
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String commitToAssignedTask(Transaction Sqlca) throws Exception {
		String result = "";
		//设置Sqlca
		this.Sqlca = Sqlca;
		//初始化业务对象,传递业务参数
		RelativeBusinessObject businessObject = initBusinessObject(); 
		//初始化流程引擎服务上下文
		initPSContext();
		
		try {
			//提交流程的预处理,初始化流程相关数据
			relativeData = bpActionAssistor.preCommit(businessObject, relativeData);
			//流程引擎中提交流程
			logger.info("PE_ACTION_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
			
			//提交前辅助操作
			String returnMsessage = bpActionAssistor.preCommitAssistant(processDefID, bizAssignedTaskID);
			processAction = returnMsessage.split("@")[0];
			taskParticipants = returnMsessage.split("@")[1];
			if("".equals(processAction) || processAction ==null || "".equals(taskParticipants) || taskParticipants == null){
				logger.error("preCommitAssistant error. processAction["+processAction+"] or taskParticipants["+taskParticipants+"] illegal.");
				throw new Exception("preCommitAssistant error. processAction["+processAction+"] or taskParticipants["+taskParticipants+"] illegal.");
			}
			//提交流程
	        List<ProcessObject> processObjects = ps.commitProcessInst(processDefID, processInstID, processTaskID, processAction, taskParticipants, relativeData);
	        logger.info("PE_ACTION_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.commit:"+processDefID);
	        
	        result = bpActionAssistor.commitAssistant(processDefID, bizProcessObjectID, bizProcessTaskID, voteSerialNo, userID, processAction, taskParticipants, businessObject, processObjects, processState, "");
	        
	        if(SUCCESS_MESSAGE.equals(result)) {
	        	commitTx();
	        } else {
	        	rollbackTx();
	        	//logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.commitToAssignedTask()][ProcessDefID="+processDefID+"][ProcessTaskID="+processTaskID+"]");
	        	//ps.restoreTask(processDefID, processTaskID);//流程引擎回滚提交
	        }
		} catch (Exception e){
			logger.debug("ProcessEngine commit process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
			rollbackTx();
			//logger.debug("[PROCESS ENGINE][RESOTRETASK][Method=com.amarsoft.app.als.process.action.BusinessProcessAction.commitToAssignedTask()][ProcessDefID="+processDefID+"][ProcessTaskID="+processTaskID+"]");
			//ps.restoreTask(processDefID, processTaskID);//流程引擎回滚提交
			throw new Exception("ProcessEngine commit process instance["+processDefID+":"+processInstID+"] error."+e.getMessage(), e);
		}
		
		return result;
	}
	
	
	/**
	 * 增加贷审会成员
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessTaskID:业务任务编号(与应用系统任务编号对应)
	 * <li>processTaskID:任务编号
	 * <li>userID:欲增加的成员,可以是单个用户user1，也可以是列表 user1@user2@user3
	 * </ul>
	 * @return SUCCESS/FAILURE/USERID 如果增加的用户已在会签列表里，则返回重复的用户编号
	 */
	public String addVote() {
		String result = "";
		userID = userID.replace("@", ",");
		try {
			// 取得当前任务用户列表
			result = ps.getTask(processDefID, processTaskID);
			ResultObject rObject = new ResultObject(result);
			String users = rObject.getResult("TASK.ASSIGNEE", "");
			String user[] = userID.split(",");
			for (int i = 0; i < user.length; i++) {
				if(users.indexOf(user[i])>0){
					//logger.info("待审会成员"+user[i]+"已存在！");
					return user[i];
				}
			}
			result = ps.addVote(processDefID, processTaskID, userID);
			if("SUCCESS".equals(result)){
				result = bpActionAssistor.addVoteAssistant(processDefID, bizProcessTaskID, userID);
			}
	        
		} catch (Exception e) {
			logger.error("增加审贷会成员失败", e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * 删除贷审会成员
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessTaskID:业务任务编号(与应用系统任务编号对应)
	 * <li>processTaskID:任务编号
	 * <li>userID:欲删除的成员,可以是单个用户user1，也可以是列表 user1@user2@user3
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String removeVote(){
		String result = "";
		userID = userID.replace("@", ",");
		try {
			result = ps.removeVote(processDefID, processTaskID, userID);
			if("SUCCESS".equals(result)){
				result = bpActionAssistor.removeVoteAssistant(processDefID, bizProcessTaskID, userID);
			}
		} catch (Exception e) {
			logger.error("删除审贷会成员失败", e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * 从任务池中获取任务
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessTaskID:业务任务编号(与应用系统任务编号对应)
	 * <li>processTaskID:任务编号
	 * <li>userID:获取任务的用户
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String takeTaskFromPool(){
		String result = "";
		try {
			result = ps.takeTaskFromPool(processDefID, processTaskID, userID);
			if("SUCCESS".equals(result)){
				result = bpActionAssistor.takeTaskFromPoolAssistant(processDefID, bizProcessTaskID, userID);
			}
		} catch (Exception e) {
			logger.error("从任务池中获取任务失败", e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * 任务池任务调整
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessTaskID:业务任务编号(与应用系统任务编号对应)
	 * <li>processTaskID:任务编号
	 * <li>phaseNo:阶段编号
	 * <li>userID:需要调整到的用户
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String taskPoolAdjust(){
		String result = "";
		try {
			List<ProcessObject> processObjects = ps.commitProcessInst(processDefID, "", processTaskID, phaseNo, userID, "");
			if(processObjects == null || processObjects.size() ==0){
	        	return FAILURE_MESSAGE;
			}else{
				result = bpActionAssistor.taskPoolAdjustAssistant(processDefID, bizProcessTaskID, userID);
			}
		} catch (Exception e) {
			logger.error("任务池任务调整失败:[bizProcessTaskID="+bizProcessTaskID+"]", e);
			return FAILURE_MESSAGE;
		}
		return result;
	}
	
	/**
	 * 将任务退回任务池
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessTaskID:业务任务编号(与应用系统任务编号对应)
	 * <li>phaseNo:当前阶段编号
	 * <li>processTaskID:当前任务编号
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String returnToPool(){
		String role = "";
		try {
			role = bpActionAssistor.getRole(processDefID,bizProcessTaskID);
			//提交给本身阶段，从而改变用户
			ps.commitProcessInst(processDefID, processInstID, processTaskID, phaseNo, role, "");
			
			bpActionAssistor.returnToPoolAssistant(processDefID, bizProcessTaskID);
			
		} catch (Exception e) {
			logger.error("退回任务池失败", e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	

	/**
	 * 退回上一阶段.
	 * 退回之前必须进行如下逻辑判断:<br>
	 * 1.该任务是否已签署意见,若已签署则不能退回<br>
	 * 本类中的该方法假设上述判断已通过,可以进行退回操作<br>
	 * <ul>必须参数
	 * <li>processDefID:流程定义编号
	 * <li>processInstID:流程实例编号
	 * <li>bizProcessTaskID:业务流程任务编号
	 * <li>processTaskID:流程任务编号
	 * <li>userID:用户编号
	 * </ul>
	 * <ul>可选参数:
	 * <li>processState:流程状态（如果不传，默认为退回）
	 * <li>relativeData:流程相关数据
	 * <li>tx:本类中使用的事务
	 * </ul>
	 * @return
	 */
	public String takeback(Transaction Sqlca) throws Exception {
		String returnMessage = "";
		this.Sqlca = Sqlca;

		try {
			//应用系统中查询出要退回的阶段
			String doTakebackMessage = bpActionAssistor.doTakeback(processDefID, bizProcessTaskID);
			if(doTakebackMessage.indexOf("@") > 0){
				String taskID = doTakebackMessage.split("@")[0];
				String nextAction = doTakebackMessage.split("@")[1];
				String nextOpinion = doTakebackMessage.split("@")[2];
				String oldBizProcessTaskID = doTakebackMessage.split("@")[3];
				String backTaskID = doTakebackMessage.split("@")[4];
				
				if(nextAction == null || "".equals(nextAction) || nextOpinion == null || "".equals(nextOpinion) ||
						taskID == null || "".equals(taskID) || oldBizProcessTaskID == null || "".equals(oldBizProcessTaskID)){
					rollbackTx();
					logger.error("Takeback error. NextAction["+nextAction+"] or NextOpinion["+nextOpinion+"] or TaskID["+taskID+"] or oldBizProcessTaskID["+oldBizProcessTaskID+"] illegal.");
					throw new Exception("Takeback error. NextAction["+nextAction+"] or NextOpinion["+nextOpinion+"] or TaskID["+taskID+"] or oldBizProcessTaskID["+oldBizProcessTaskID+"] illegal.");
				} else {
					//流程引擎中将流程退回到相应阶段
					logger.info("PE_ACTION_TAKEBACK_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.takeback:"+processDefID);
					initPSContext();//初始化流程引擎服务上下文
			        List<ProcessObject> processObjects = ps.returnProcessInst(processDefID, processInstID, taskID, backTaskID, nextAction, nextOpinion, relativeData, userID);
			        logger.info("PE_ACTION_TAKEBACK_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.takeback:"+processDefID);
					//Task新增记录，Object更新记录
			        returnMessage = bpActionAssistor.postTakeback(processDefID, bizProcessTaskID, oldBizProcessTaskID, processState, processObjects, userID);
			        
			        if(SUCCESS_MESSAGE.equals(returnMessage)){
			        	commitTx();
			        } else {
			        	rollbackTx();
			        }
				}
			} else {
				rollbackTx();
				logger.warn(doTakebackMessage);
				returnMessage = FAILURE_MESSAGE;
			}
		} catch (Exception e) {
			logger.error("退回回任务出错："+e.getMessage(), e);
			rollbackTx();
			throw new Exception("退回任务出错："+e.getMessage(), e);
		}
		
		return returnMessage;
	}
	
	/**
	 * 获取流程历史处理步骤.(phaseNo不重复,不包括任务池阶段)
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessObjectID:业务流程对象编号
	 * <li>bizProcessTaskID:业务流程任务编号
	 * @return List<HistoryTaskObject> 
	 * @throws Exception 
	 */
	public List<HistoryTaskObject> getProcessHistory() throws Exception{
		List<HistoryTaskObject> historyTaskObjects = new ArrayList<HistoryTaskObject>();
		try {
			historyTaskObjects = bpActionAssistor.getProcessHistory(processDefID, bizProcessObjectID ,bizProcessTaskID);
			if(historyTaskObjects == null){
				throw new Exception("查询流程历史记录出错, 查询记录为空");
			}
		} catch (JBOException e) {
			logger.error("查询流程历史记录出错:[ProcessDefID="+processDefID+"]"+",[BizObjectObjectID="+bizProcessObjectID+"]",e);
		}
		return historyTaskObjects;
	}
	
	/**
	 * 获取流程历史处理步骤.(仅客户经理和上一步)
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessObjectID:业务流程对象编号
	 * @return List<HistoryTaskObject> 
	 * @throws Exception 
	 */
	public List<HistoryTaskObject> getPartProcessHistory() throws Exception{
		List<HistoryTaskObject> historyTaskObjects = new ArrayList<HistoryTaskObject>();
		try {
			historyTaskObjects = bpActionAssistor.getPartProcessHistory(processDefID, bizProcessObjectID);
			if(historyTaskObjects == null){
				rollbackTx();
				throw new Exception("查询流程历史记录出错, 查询记录为空");
			}else{
				commitTx();
				logger.info("查询流程历史记录成功，查出记录"+historyTaskObjects.size()+"条");
			}
		} catch (JBOException e) {
			rollbackTx();
			logger.error("查询流程历史记录出错:[ProcessDefID="+processDefID+"]"+",[BizObjectObjectID="+bizProcessObjectID+"]",e);
		}
		return historyTaskObjects;
	}
	
	/**
	 * 退回任意阶段.
	 * <ul>必须参数
	 * <li>processDefID:流程定义编号
	 * <li>processInstID:流程实例编号
	 * <li>userID:当前用户编号
	 * <li>bizProcessTaskID:要退回到的业务流程任务编号
	 * <li>processTaskID:流程任务编号
	 * </ul>
	 * <ul>可选参数:
	 * <li>processState:流程状态（如果不传，默认为退回）
	 * <li>bizAssignedTaskID:指定下一阶段的流程任务编号（如果不传，默认为空）
	 * <li>relativeData:流程相关数据
	 * <li>tx:本类中使用的事务
	 * </ul>
	 * @return
	 */
	public String taskReturn() throws Exception {
		String returnMessage = FAILURE_MESSAGE;
		try {
			returnMessage = bpActionAssistor.preTaskReturn(processDefID,bizProcessTaskID);
			String nextAction = returnMessage.split("@")[0];
			String nextOpinion = returnMessage.split("@")[1];
			String backTaskID = returnMessage.split("@")[2];
			if (nextAction == null || "".equals(nextAction)
					|| nextOpinion == null || "".equals(nextOpinion)) {
				logger.error("Takeback error. NextAction[" + nextAction
						+ "] or NextOpinion[" + nextOpinion + "] illegal.");
				throw new Exception("Takeback error. NextAction[" + nextAction
						+ "] or NextOpinion[" + nextOpinion + "] illegal.");
			} else {
				// 流程引擎中将流程退回到相应阶段
				logger.info("PE_ACTION_TAKEBACK_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.takeback:" + processDefID);
				initPSContext();// 初始化流程引擎服务上下文
				List<ProcessObject> processObjects = ps.returnProcessInst(processDefID, processInstID, processTaskID, backTaskID, nextAction, nextOpinion, relativeData, userID);
				logger.info("PE_ACTION_TAKEBACK_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.takeback:" + processDefID);
				// Task中更新ProcessTaskNo
				returnMessage = bpActionAssistor.postTaskReturn(processDefID, bizProcessTaskID, bizAssignedTaskID, processState, processObjects, userID);

				if (SUCCESS_MESSAGE.equals(returnMessage)) {
					commitTx();
				} else {
					rollbackTx();
					returnMessage = FAILURE_MESSAGE;
				}
			}
		} catch (Exception e) {
			logger.error("退回任意阶段"+e.getMessage(), e);
			rollbackTx();
			throw new Exception("退回任意阶段"+e.getMessage(), e);
		}
		
		return returnMessage;
	}
	
	/**
	 * 转办
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessTaskID:业务任务编号(与应用系统任务编号对应)
	 * <li>processTaskID:任务编号
	 * <li>userID:需要调整到的用户
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String changeUser(){
		String result = "";
		try {
			result = ps.takeTaskFromPool(processDefID, processTaskID, userID);
			if("SUCCESS".equals(result)){
				result = bpActionAssistor.changeUserAssistant(processDefID, bizProcessTaskID, userID);
			}
		} catch (Exception e) {
			logger.error("流程转办失败", e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * 任务是否可收回判断<br>
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessTaskID:业务流程任务编号
	 * <li>userID:当前处理人编号
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String canWithdraw() throws Exception {
		//判断任务是否可收回
		if(bpActionAssistor.canWithdraw(processDefID, bizProcessTaskID, userID)==true){
			return SUCCESS_MESSAGE;
		}
		return FAILURE_MESSAGE;
	}
	
	/**
	 * 任务归档
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessObjectID 业务流程对象编号
	 * </ul>
	 * <ul>可选参数:
	 * <li>tx:本类中使用的事务
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String taskArchive(){
		String returnMessage = "";
		try {
			returnMessage = bpActionAssistor.taskAchive(processDefID,bizProcessObjectID);
		} catch (Exception e) {
			logger.error("归档失败", e);
			return "FAILURE";
		}
		return returnMessage;
	}
	
	/**
	 * 取消归档
	 * <ul>必须参数:
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessObjectID 业务流程对象编号
	 * </ul>
	 * <ul>可选参数:
	 * <li>tx:本类中使用的事务
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String cancelArchive(){
		String returnMessage = "";
		try {
			returnMessage = bpActionAssistor.cancelAchive(processDefID,bizProcessObjectID);
		} catch (Exception e) {
			logger.error("取消归档失败", e);
			return "FAILURE";
		}
		return returnMessage;
	}
	
	/**
	 * 设置流程对象
	 * <ul>必须参数:
	 * <li>processTaskID:流程任务编号
	 * <li>relativeData: 流程相关业务数据,@分隔,eg:OrgInfo.OrgID=1@OrgInfo.OrgName=2
	 * </ul>
	 * @return SUCCESS/FAILURE
	 * @throws Exception 
	 */
	public String setProcessObject() throws Exception{
		String ObjectName="";
		String ObjectValue="";
		try {
			String processData[] = relativeData.split("@");
			for(int i = 0;i<processData.length;i++){
				ObjectName = processData[i].split("=")[0];
				if(processData[i].split("=").length<=1){
					ObjectValue = "";
				}else{
					ObjectValue = processData[i].split("=")[1];
				}
				try {
					ps.setProcessObject(processTaskID, ObjectName, ObjectValue);
				} catch (Exception e) {
					throw new Exception("设置流程对象失败,KEY=["+ObjectName+"],VALUE=["+ObjectValue+"]", e);
				}
			}
		}catch (Exception ex){
			throw new Exception("设置流程对象失败,processTaskID=["+processTaskID+"],relativeData=["+relativeData+"]",ex);
		}
		return "SUCCESS";
	}
	
	/**
	 * 流程结束后恢复到结束前的阶段
	 * <ul>必须参数:
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * </ul>
	 * @return SUCCESS/FAILURE
	 * @throws Exception 
	 */
	public String restoreInstance() throws Exception{
			String result = "";
		try {
        	result = ps.restoreInstance(processDefID, processInstID);
        	if("SUCCESS".equals(result)){
        		logger.info("恢复流程成功，流程已恢复到结束的前一阶段");
        	}else{
        		logger.info("恢复流程失败");
        	}
		}catch (Exception ex){
			throw new Exception("流程恢复失败,processDefID=["+processDefID+"],processInstID=["+processInstID+"]",ex);
		}
		return result;
	}
	
	/**
	 * 查看流程图
	 * <ul>必须参数：
	 * <li>processDefID:流程定义编号
	 * <li>ProcessTaskID:流程任务编号
	 * </ul>
	 * @return
	 */
	public BufferedImage getFlowGraph(String processDefID, String processTaskNo) throws Exception {
		BufferedImage image = null;
		try {
			image = ps.getFlowGraph(processDefID, processTaskNo);
		} catch (Exception e) {
			logger.error("获取流程图失败", e);
		}
		return image;
	}
	
	
	/**
	 * 收回任务.本方法暂只支持流程的单任务模式
	 * 收回之前必须进行如下逻辑判断:<br>
	 * 1. 申请收回时必须判断该申请是否已经登记了最终审批意见，如果是则不能收回<br>
	 * 2. 最终审批意见的收回操作必须判断该笔最终审批意见是否已经签署了合同，如果是则不能收回<br>
	 * 本类中的该方法假设上述判断已通过,可以进行收回操作.<br>
	 * <ul>必须参数
	 * <li>processDefID:流程定义编号
	 * <li>processInstID:流程实例编号
	 * <li>bizProcessTaskID:业务流程任务编号(未提交的那条任务编号)
	 * <li>processTaskID:流程任务编号
	 * <li>userID:用户编号
	 * </ul>
	 * <ul>可选参数:
	 * <li>relativeData:流程相关数据
	 * <li>tx:本类中使用的事务
	 * </ul>
	 * @return SUCCESS/FAILURE/下阶段任务已提交或已签署意见,不能收回
	 */
	public String withdraw(Transaction Sqlca) throws Exception {
		String returnMessage = "";
		this.Sqlca = Sqlca;
		try {
			//应用系统中查询出要撤回的阶段
			String doWithdrawMessage = bpActionAssistor.doWithdraw(processDefID, bizProcessTaskID);
			if(doWithdrawMessage.indexOf("@") > 0){
				String currentTaskID = doWithdrawMessage.split("@")[0];
				String nextAction = doWithdrawMessage.split("@")[1];
				String nextOpinion = doWithdrawMessage.split("@")[2];
				String oldBizProcessTaskID = doWithdrawMessage.split("@")[3];
				String arriveTaskID = doWithdrawMessage.split("@")[4];
				if (currentTaskID == null || "".equals(currentTaskID)
						|| nextAction == null || "".equals(nextAction)
						|| nextOpinion == null || "".equals(nextOpinion)
						|| bizProcessTaskID == null || "".equals(bizProcessTaskID)) {
					rollbackTx();
					logger.error("Withdraw error. WithdrawTaskID["+currentTaskID+"] or NextAction["+nextAction+"] or NextOpinion["+nextOpinion+"] illegal.");
					throw new Exception("Withdraw error. WithdrawTaskID["+currentTaskID+"] or NextAction["+nextAction+"] or NextOpinion["+nextOpinion+"] illegal.");
				}
				//流程引擎中将流程提交到相应阶段
				logger.info("PE_ACTION_WITHDRAW_COMMIT_BEGIN:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.withdraw:"+processDefID);
				initPSContext();//初始化流程引擎服务上下文
		        List<ProcessObject> processObjects = ps.withdrawProcessInst(processDefID, processInstID, currentTaskID, arriveTaskID, doWithdrawMessage, "", "", userID);
		        logger.info("PE_ACTION_WITHDRAW_COMMIT_END:" + "com.amarsoft.app.lending.process.action.BusinessProcessAction.withdraw:"+processDefID);
		        
				//Task新增记录，Object更新记录
		        returnMessage = bpActionAssistor.postWithdraw(processDefID, bizProcessTaskID, oldBizProcessTaskID, processObjects);
		        
		        if(SUCCESS_MESSAGE.equals(returnMessage)){
		        	commitTx();
		        } else {
		        	rollbackTx();
		        }
			} else {
				rollbackTx();
				returnMessage = FAILURE_MESSAGE;
			}
		} catch (Exception e) {
			logger.error("收回任务出错："+e.getMessage(), e);
			rollbackTx();
			throw new Exception("收回任务出错："+e.getMessage(), e);
		}
		
		return returnMessage;
	}
	
	/**
	 * 主动撤回（贷审会成员主动撤回）
	 * <ul>必须参数：
	 * <li>processDefID:流程定义编号
	 * <li>processTaskID:流程任务编号
	 * <li>userID:主动撤回人用户编号
	 * </ul>
	 * @return
	 */
	public String withdrawForVote() throws Exception{
		
		//流程引擎端处理
		try {
			ps.removeVote(processDefID, processTaskID, userID);
			ps.addVote(processDefID, processTaskID, userID);
		}catch (Exception ex){
			throw new Exception("流程引擎主动撤回失败,ProcessTaskID["+processTaskID+"]"+",userID["+userID+"]",ex);
		}
		//应用系统端处理
		try {
			bpActionAssistor.withdrawForVoteAssistant(processDefID, bizProcessTaskID, userID);
		} catch (Exception e) {
			throw new Exception("审贷会成员主动撤回辅助处理失败,ProcessTaskID["+processTaskID+"]"+",userID["+userID+"]", e);
		}
		return "SUCCESS";
	}

	private void initPSContext() throws Exception {
		ps.set(Context.CONTEXTNAME_SQLCA, getSqlca());
		ps.set(Context.CONTEXTNAME_TRANSACTION, getTx());
	}
	
	//初始化相关业务对象，并将该对象置入流程
	private RelativeBusinessObject initBusinessObject() throws JBOException{
		RelativeBusinessObject businessObject = new RelativeBusinessObject();
		
		if(bizProcessTaskID!=null){
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
			BizObjectQuery bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			BizObject bo = bq.getSingleResult(false);
			String phaseNo = bo.getAttribute("PhaseNo").toString();
			String phaseType = bo.getAttribute("phaseType").toString();
			businessObject.setPhaseNo(phaseNo);
			businessObject.setPhaseType(phaseType);
		}
		
		PSUserObject user = null;
		businessObject.setObjectNo(objectNo);
		businessObject.setObjectType(objectType);
		businessObject.setApplyType(applyType);
		businessObject.setProcessDefID(processDefID);

		if(userID != null && !"".equals(userID)){
			businessObject.setUserID(userID);
			try {
				user = PSUserObject.getUser(userID);
				if(user != null){
					businessObject.setOrgID(user.getOrgID());
					businessObject.setOrgName(user.getOrgName());
					businessObject.setUserName(user.getUserName());
				}
			} catch (Exception e) {
				logger.debug(e.getMessage(), e);
			}
		}
		try {
			//将objectNo,objectType,applyType,userID,OrgID置入流程
			if(objectNo != null && !"".equals(objectNo)){ps.setProcessObject(processTaskID, "S_BizObject.ObjectNo", objectNo);}
			if(objectType != null && !"".equals(objectType)){ps.setProcessObject(processTaskID, "S_BizObject.objectType", objectType);}
			if(applyType != null && !"".equals(applyType)){ps.setProcessObject(processTaskID, "S_BizObject.ApplyType", applyType);}
			ps.setProcessObject(processTaskID, "S_UserInfo.UserID", userID);
			ps.setProcessObject(processTaskID, "S_UserInfo.OrgID", user.getOrgID());
		} catch (Exception e) {
			logger.error("设置流程参数出错",e);
		}
		return businessObject;
	}
	
	/**
	 * 判断当前任务是否已经提交
	 * @return
	 */
	public boolean isCommited(String bizProcessTaskID) throws JBOException {
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		BizObjectQuery bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
		BizObject bo = bq.getSingleResult(false);
		if(bo == null) return true;
		return false;
	}
	
	/**
	 * 判断流程是否结束
	 * <p>
	 * 在任务提交后调用，用来判断是否是终止节点，以便做后续操作。
	 * </p>
	 * <ul>必须参数：
	 * <li>bizProcessTaskID:业务任务编号(与应用系统任务编号对应)
	 * </ul>
	 * @return String 成功返回<String>ture</String> 失败返回<String>false</String>
	 */
	public String isFinishedFlow(){
		try {
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
			String query = "SerialNo=:BizProcessTaskID";
			BizObjectQuery q = bom.createQuery(query).setParameter("BizProcessTaskID", bizProcessTaskID);
			BizObject bo = q.getSingleResult(false);
			if(bo == null){
				ARE.getLog().debug("com.amarsoft.app.als.process.action.BusinessTaskAction.isFinishedFlow: 查询起始任务出错!");
			} else {
				if("2".equals(bo.getAttribute("SerialNo").getString()))return "true";
			}
		} catch(JBOException e){
			ARE.getLog().debug("获取流程是否结束状态出错"+e.getMessage(),e);
		}
		return "false";
	}
	
	/**
	 * 关闭流程
	 * <p>
	 * 关闭流程（逻辑删除，可恢复）
	 * </p>
	 * <ul>必须参数：
	 * <li>processDefID:流程定义编号(与应用系统流程编号对应)
	 * <li>bizProcessTaskID:业务任务编号(与应用系统任务编号对应)
	 * </ul>
	 * <ul>可选参数：
	 * <li>tx:外部事务
	 * </ul>
	 * @return String 成功返回<String>SUCCESS</String>
	 * @throws Exception
	 */
	public String closeProcess() throws Exception{
		try {
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
			getTx().join(bom);
			String query = "SerialNo=:BizProcessTaskID";
			BizObjectQuery q = bom.createQuery(query).setParameter("BizProcessTaskID", bizProcessTaskID);
			BizObject bo = q.getSingleResult(true);
			if(bo == null){
				ARE.getLog().debug("com.amarsoft.app.als.process.action.BusinessTaskAction.closeProcess: 需要关闭的任务不存在!");
				throw new Exception("需要关闭的任务不存在:[bizProcessTaskID="+bizProcessTaskID+"]");
			} else {
				bo.setAttributeValue("TaskState", BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
			}
			bom.saveObject(bo);
			commitTx();
		} catch(JBOException e){
			rollbackTx();
			ARE.getLog().debug("关闭流程出错"+e.getMessage(),e);
			throw new Exception("关闭流程出错",e);
		}
		return "SUCCESS";
	}
	
	/**
	 * 打开流程
	 * <p>
	 * 打开流程（只对应被关闭的流程，其他状态不可用）
	 * </p>
	 * <ul>必须参数：
	 * <li>processDefID:流程定义编号(与应用系统流程编号对应)
	 * <li>bizProcessTaskID:业务任务编号(与应用系统任务编号对应)
	 * </ul>
	 * <ul>可选参数：
	 * <li>tx:外部事务
	 * </ul>
	 * @return String 成功返回SUCCESS 失败返回FAILURE
	 * @throws Exception
	 */
	public String openProcess() throws Exception{
		try {
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
			getTx().join(bom);
			String query = "SerialNo=:BizProcessTaskID and TaskState=:TaskState";
			BizObjectQuery q = bom.createQuery(query)
					.setParameter("BizProcessTaskID", bizProcessTaskID)
					.setParameter("TaskState",BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
			BizObject bo = q.getSingleResult(true);
			if(bo == null){
				ARE.getLog().debug("com.amarsoft.app.als.process.action.BusinessTaskAction.closeProcess: 需要关闭的任务不存在或任务为非关闭状态!");
				throw new Exception("需要关闭的任务不存在或任务为非关闭状态:[bizProcessTaskID="+bizProcessTaskID+"]");
			} else {
				bo.setAttributeValue("TaskState", BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
			}
			bom.saveObject(bo);
			commitTx();
		} catch(JBOException e){
			rollbackTx();
			ARE.getLog().debug("打开流程出错"+e.getMessage(),e);
			throw new JBOException("打开流程出错");
		}
		return "SUCCESS";
	}
	
	/**
	 * 取得审查审批中申请执行收回操作的任务编号(业务任务编号)
	 * <p>
	 * 该操作一般用在某用户发起的业务申请,进行到审查审批阶段时,该用户从申请列表中收回该笔业务,重新掌握控制权
	 * </p>
	 * <p>
	 * 因此在执行该操作时,必须保证该业务是由当前用户发起
	 * </p>
	 * <ul>必须参数：
	 * <li>bizProcessObjectID:业务流程对象编号
	 * <li>processDefID:流程定义编号
	 * <li>userID:用户编号
	 * </ul>
	 * @return
	 */
	public String getWithdrawTaskID(){
		String withdrawTaskID = "";
		try {
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
			String query = "RelativeObjectNo =:RelativeObjectNo order by SerialNo";
			BizObjectQuery q = bom.createQuery(query)
								  .setParameter("RelativeObjectNo", bizProcessObjectID);
			BizObject bo = q.getSingleResult(false);//仅获取第一条记录
			if(bo == null){
				ARE.getLog().debug("com.amarsoft.app.als.process.action.BusinessTaskAction.getWithdrawTaskID: 查询起始任务出错!");
			} else {
				if(userID.equals(bo.getAttribute("UserID").getString())){//首笔任务由当前用户发起
					withdrawTaskID = bo.getAttribute("SerialNo").getString();
				}
			}
		} catch(JBOException e){
			ARE.getLog().debug("取得审查审批中申请执行收回操作的任务编号"+e.getMessage(),e);
		}
		return withdrawTaskID;
	}
	
	/**
	 * 取得流程定义中指定节点的上一个节点
	 * <ul>必须参数：
	 * <li>processDefID:流程定义编号
	 * <li>processTaskID:流程任务编号
	 * </ul>
	 * <ul>可选参数：
	 * <li>phaseNo:指定节点编号，为空为当前任务节点
	 * </ul>
	 * @return String 成功返回角色列表
	 */
	public String getPreActivityID() throws Exception {
		String preActivityID = "";
		try{
			//流程引擎中取得流程节点的上一个节点
			preActivityID = ps.getPreActivity(processDefID, processTaskID, phaseNo);
			if("".equals(preActivityID)){
				throw new Exception("流程上一节点不唯一，请检查流程。processTaskID["+processTaskID+"],phaseNo["+phaseNo+"]");
			}
		}catch (Exception e){
			throw new Exception("获取流程上一节点失败。processTaskID["+processTaskID+"],phaseNo["+phaseNo+"]",e);
		}
		return preActivityID;
	}
	
	/**
	 * 获取下一阶段角色列表
	 * <ul>必须参数：
	 * <li>processAction:流程提交动作
	 * <li>processDefID:流程定义编号
	 * <li>processTaskID:流程任务编号
	 * </ul>
	 * @return String 成功返回角色列表
	 */
	public String getNextTaskRole() throws Exception {
		String sRole = "";
		//流程引擎中取得定义的角色列表
		sRole = ps.getNextOptionalRole(processDefID, processAction, processTaskID);
		return sRole;
	}
	
	/**
	 * 获取下一阶段参与人列表
	 * <ul>必须参数：
	 * <li>processAction:流程提交动作
	 * <li>userID:当前用户编号
	 * <li>processDefID:流程定义编号
	 * <li>processTaskID:流程任务编号
	 * </ul>
	 * @return
	 */
	public String getTaskParticipants(Transaction Sqlca) throws Exception {
		String sReturn = "";
		
		//流程引擎中取得定义的参与人列表
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		PSUserObject user = PSUserObject.getUser(userID);
		ps.setProcessObject(processTaskID, "S_UserInfo.UserID", userID);
		ps.setProcessObject(processTaskID, "S_UserInfo.OrgID", user.getOrgID());
		String[] users = ps.getNextOptionalUsers(processDefID, processAction, processTaskID, userID);
		
		if(users == null || users.length == 0) { 
			users = new String[1];
			users[0] = "";
		}
		
		String sUserValue[] = new String[users.length];

		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bom = f.getManager("jbo.sys.USER_INFO");

		for(int i=0; i<users.length; i++){
			System.out.println("i===="+users[i]);
			if(users[i] != null && users[i].split(" ").length >= 1){
				String sql = "select \"O.*\",RI.RoleID,RI.RoleName from "
						+ " O,jbo.sys.USER_ROLE UR,jbo.sys.ROLE_INFO RI "
						+ " where O.UserID = UR.UserID "
						+ " and UR.RoleID = RI.RoleID "
						+ " and O.UserID='"
						+ users[i].split(" ")[0] + "'"
						+ " and O.Status='1'";
				if(users[i].split(" ").length >=2)
					sql +=" and UR.RoleID='"+users[i].split(" ")[1]+"'";
				BizObjectQuery query = bom.createQuery(sql);
				BizObject bo = query.getSingleResult(false);
				if(bo!=null){
					sUserValue[i] = bo.getAttribute("UserID").toString()
							+ " " + bo.getAttribute("UserName").toString()
							+ " " + bo.getAttribute("RoleID").toString()
							+ " " + bo.getAttribute("RoleName").toString();
				}
			}
		}
		
		if(sUserValue[0] == null){
			sUserValue = users;
		}
		
		//生成JSON
		for(int i=0;i<sUserValue.length;i++){
			sReturn += ("[\""+sUserValue[i]+"\"],");
		}
		if(sReturn.length() > 0){
			sReturn = sReturn.substring(0,sReturn.length()-1);
		}
		return sReturn;
	}
	
	/**
	 * 获取当前参与人列表
	 * <ul>必须参数：
	 * <li>processAction:流程提交动作
	 * <li>userID:当前用户编号
	 * <li>processDefID:流程定义编号
	 * <li>processTaskID:流程任务编号
	 * </ul>
	 * @return
	 */
	public String getCurTaskParticipants(Transaction Sqlca) throws Exception {
		String sReturn = "";
		
		//流程引擎中取得定义的参与人列表
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		String[] users = ps.getCurOptionalUsers(processDefID, processAction, processTaskID, userID);
		
		if(users == null || users.length == 0) { 
			users = new String[1];
			users[0] = "";
		}
		
		String sUserValue[] = new String[users.length];
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bom = f.getManager("jbo.sys.USER_INFO");

		for(int i=0; i<users.length; i++){
			if(users[i] != null && users[i].split(" ").length >= 1){
				String sql = "select O.*,RI.RoleID,RI.RoleName from "
						+ " O,jbo.sys.USER_ROLE UR,jbo.awe.AWE_ROLE_INFO RI "
						+ " where O.UserID = UR.UserID "
						+ " and UR.RoleID = RI.RoleID "
						+ " and O.UserID='"
						+ users[i].split(" ")[0] + "'";
				BizObjectQuery query = bom.createQuery(sql);
				BizObject bo = query.getSingleResult(false);
				if(bo!=null){
					sUserValue[i] = bo.getAttribute("UserID").toString()
							+ " " + bo.getAttribute("UserName").toString()
							+ " " + bo.getAttribute("RoleID").toString()
							+ " " + bo.getAttribute("RoleName").toString();
				}
			}
		}
		
		if(sUserValue[0] == null){
			sUserValue = users;
		}
		
		//生成JSON
		for(int i=0;i<sUserValue.length;i++){
			sReturn += ("[\""+sUserValue[i]+"\"],");
		}
		if(sReturn.length() > 0){
			sReturn = sReturn.substring(0,sReturn.length()-1);
		}
		return sReturn;
	}
	
	/**
	 * 同上一方法,结果并不拼成JSON返回
	 * @param processDefID
	 * @param processAction
	 * @param processTaskID
	 * @param userID
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String[] getTaskParticipants(String processDefID, String processAction, String processTaskID, String userID, Transaction Sqlca) throws Exception {
		
		//流程引擎中取得定义的参与人列表
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		PSUserObject user = PSUserObject.getUser(userID);
		ps.setProcessObject(processTaskID, "S_UserInfo.UserID", userID);
		ps.setProcessObject(processTaskID, "S_UserInfo.OrgID", user.getOrgID());
		String[] users = ps.getNextOptionalUsers(processDefID, processAction, processTaskID, userID);
		
		if(users == null || users.length == 0) { 
			users = new String[1];
			users[0] = "";
		}
		
		String sUserValue[] = new String[users.length];

		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bom = f.getManager("jbo.sys.USER_INFO");
		
		for(int i=0; i<users.length; i++){
			if(users[i] != null && users[i].split(" ").length >= 1){
				String sql = "select O.*,RI.RoleID,RI.RoleName from "
						+ " O,jbo.sys.USER_ROLE UR,jbo.awe.AWE_ROLE_INFO RI "
						+ " where O.UserID = UR.UserID "
						+ " and UR.RoleID = RI.RoleID "
						+ " and O.UserID='"
						+ users[i].split(" ")[0] + "'";
				BizObjectQuery query = bom.createQuery(sql);
				BizObject bo = query.getSingleResult(false);
				if(bo!=null){
					sUserValue[i] = bo.getAttribute("UserID").toString()
							+ " " + bo.getAttribute("UserName").toString()
							+ " " + bo.getAttribute("RoleID").toString()
							+ " " + bo.getAttribute("RoleName").toString();
				}
			}
		}
		
		if(sUserValue[0] == null){
			sUserValue = users;
		}
		
		return sUserValue;
	}

	/**
	 * 取得下一节点名称
	 * <ul>必须参数：
	 * <li>processAction:流程提交动作
	 * </ul>
	 * <ul>可选参数：
	 * <li>processDefID:流程定义编号
	 * <li>processInstID:流程实例编号
	 * <li>processTaskID:流程任务编号
	 * <li>taskParticipants:流程提交意见
	 * </ul>
	 * @return
	 */
	public String getNextActivityName(Transaction Sqlca) throws Exception {
		String sNextPhaseName="";//返回阶段信息、阶段名称
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		sNextPhaseName = ps.getNextActivityName(processDefID, processInstID, processTaskID, processAction, taskParticipants);
		return sNextPhaseName;
	}
	
	/**
	 * 取得下一节点提示信息
	 * <ul>必须参数：
	 * <li>processAction:流程提交动作
	 * </ul>
	 * <ul>可选参数：
	 * <li>processDefID:流程定义编号
	 * <li>processInstID:流程实例编号
	 * <li>processTaskID:流程任务编号
	 * <li>processOpinion:流程提交意见
	 * </ul>
	 * @return
	 */
	public String getNextActivityInfo(Transaction Sqlca) throws Exception {
		String sPhaseInfo = "下一阶段:";
		String sNextPhaseName = getNextActivityName(Sqlca);
		sPhaseInfo = sPhaseInfo + " " + sNextPhaseName;//拼出提示信息
		return sPhaseInfo;
	}
	
	/**
	 * 取得后续任务编号
	 * <ul>必须参数：
	 * <li>processAction:流程提交动作
	 * </ul>
	 * <ul>可选参数：
	 * <li>processDefID:流程定义编号
	 * <li>processInstID:流程实例编号
	 * <li>processTaskID:流程任务编号
	 * </ul>
	 * @return
	 */
	public String getNextState(Transaction Sqlca) throws Exception {
		String TaskName="";//返回任务编号
		ps.set(Context.CONTEXTNAME_SQLCA, Sqlca);
		TaskName = ps.getNextState(processDefID, processInstID, processTaskID, processAction);
		if(TaskName.startsWith("CounterSign")){
			return "CounterSign";
		}else{
			return "Task";
		}
	}
	
	/**
	 * 判断某一阶段是否是任务池
	 * <ul>必须参数：
	 * <li>processDefID:当前流程定义编号
	 * <li>bizProcessTaskID:需要判断的业务流程任务编号
	 * <li>processTaskID:当前流程任务编号
	 * <li>phaseNo:需要判断的阶段号
	 * </ul>
	 * @return TRUE/FALSE
	 */
	public String isTaskPool() throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bom = f.getManager("jbo.app.Flow_Task");
		BizObjectQuery query = bom.createQuery("SerialNo =:SerialNo").setParameter("SerialNo", bizProcessTaskID);
		BizObject bo = query.getSingleResult(false);
		if(bo!=null){
			phaseNo = bo.getAttribute("PhaseNo").toString(); 
		}else{
			ARE.getLog().error("获取应用系统阶段编号出错");
		}
		
		String isPool = ps.getActivityProperty(processDefID, processTaskID, phaseNo, "ISPOOL");
		if ("".equals(isPool) || isPool == null) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}
	
	/**
	 * 判断某一阶段是并行流程节点
	 * <ul>必须参数：
	 * <li>processDefID:当前流程定义编号
	 * <li>phaseNo:需要判断的阶段编号
	 * <li>processTaskID:当前流程任务编号
	 * </ul>
	 * @return TRUE/FALSE
	 */
	public String isFork() throws Exception {
		String isFork = ps.getActivityProperty(processDefID, processTaskID, phaseNo, "ISFORK");
		if ("".equals(isFork) || isFork == null) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}
	
	/**
	 * 判断当前任务类型
	 * <ul>必须参数：
	 * <li>phaseNo:流程阶段编号
	 * </ul>
	 * @return
	 */
	public String getCurrentState() throws Exception {
		if(phaseNo.startsWith("CounterSign")){
			return "CounterSign";
		}
		if(phaseNo.startsWith("Task")){
			return "Task";
		}
		if(phaseNo.startsWith("End")){
			return "End";
		}
		if(phaseNo.startsWith("Fork")){
			return "Fork";
		}
		return "Task";
	}
	
	/**
	 * 检查待提交的阶段编号是否与Object记录的当前阶段匹配,一般用于检查是否重复提交
	 * <ul>必须参数：
	 * <li>bizProcessObjectID:业务流程对象编号
	 * <li>processDefID:流程定义编号
	 * <li>phaseNo:活动定义编号
	 * </ul>
	 * @return SUCCESS/FAILURE
	 */
	public String checkActivityID(){
		String curPhaseNo = "";
		
		try {
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bom = f.getManager("jbo.app.Flow_Object");
			BizObjectQuery query = bom.createQuery("SerialNo = :SerialNo").setParameter("SerialNo", bizProcessObjectID);
			BizObject bo = query.getSingleResult(false);
			curPhaseNo = bo.getAttribute("PhaseNo").getString();
		} catch(JBOException e){
			ARE.getLog().debug("获取应用系统阶段编号出错",e);
		}
		
		String[] phaseNos = StringFunction.toStringArray(curPhaseNo, ",");
		boolean flag = false;
		for(int i = 0; i < phaseNos.length; i++){
			if(phaseNo.equals(phaseNos[i])){
				flag = true;
				break;
			}
		}
		
		if(flag) return "SUCCESS";
		
		return "FAILURE";
	}
	
	/**
	 * 取得阶段定义的属性
	 * <ul>必须参数：
	 * <li>processDefID:流程定义编号
	 * <li>processTaskID:流程任务编号
	 * <li>phaseNo:活动定义编号
	 * <li>property:属性名称
	 * </ul>
	 * @return
	 * @throws JBOException 
	 */
	public String getPhaseProperty() throws JBOException{
		if(bizProcessTaskID == null || bizProcessTaskID.equals("") || !isCommited(bizProcessTaskID)) {
			ProcessService ps = ProcessServiceFactory.getService();
			String propertyValue = ps.getActivityProperty(processDefID, processTaskID, phaseNo, property);
			return propertyValue;
		}
		else
			return ""; 
	}
	
	
	/**
	 * 事务提交
	 */
	private void commitTx(){
		if(tx != null && isNewTX){
			try {
				tx.commit();
			} catch (JBOException e){
				try {
					logger.debug("com.amarsoft.app.lending.process.action.BusinessProcessAction.commitTx:事务提交异常", e);
					tx.rollback();
				} catch (JBOException je) {
					logger.debug("com.amarsoft.app.lending.process.action.BusinessProcessAction.commitTx:事务回滚异常", je);
				}
			}
		}
	}
	
	/**
	 * 回滚事务
	 */
	private void rollbackTx(){
		if(isNewTX && tx != null){
			try{
				tx.rollback();
			} catch (JBOException je) {
				logger.debug("com.amarsoft.app.lending.process.action.BusinessProcessAction.rollbackTx:事务回滚异常", je);
			}
		}
	}

	/**************************************
	 * getters and setters
	 **************************************/

	public Transaction getSqlca() {
		return Sqlca;
	}

	public void setSqlca(Transaction sqlca) {
		Sqlca = sqlca;
	}
	
	public JBOTransaction getTx() {
		if(tx == null){
			try {
				tx = JBOFactory.createJBOTransaction();
			} catch (JBOException e) {
				e.printStackTrace();
				logger.error("创建事务失败",e);
			}
			isNewTX = true;
		}
		return tx;
	}

	public void setTx(JBOTransaction tx) {
		if(tx == null){
			try {
				tx = JBOFactory.createJBOTransaction();
			} catch (JBOException e) {
				e.printStackTrace();
				logger.error("创建事务失败",e);
			}
			isNewTX = true;//标识为新创建事务
		}else{
			isNewTX = false;//标识为非新创建事务
		}
		this.tx = tx;//添加事务
		this.bpActionAssistor.setTx(tx);//为辅助处理器添加事务
		this.bpActionAssistor.setNewTX(isNewTX);//辅助处理器标识是否新创建事务
	}

	public void setNewTX(boolean isNewTX) {
		this.isNewTX = isNewTX;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}
	
	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}

	public void setProcessDefID(String processDefID) {
		this.processDefID = processDefID;
	}

	public void setProcessInstID(String processInstID) {
		this.processInstID = processInstID;
	}

	public void setProcessTaskID(String processTaskID) {
		this.processTaskID = processTaskID;
	}

	public void setBizProcessObjectID(String bizProcessObjectID) {
		this.bizProcessObjectID = bizProcessObjectID;
	}

	public void setBizProcessTaskID(String bizProcessTaskID) {
		this.bizProcessTaskID = bizProcessTaskID;
	}

	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}

	public void setPhaseType(String phaseType) {
		this.phaseType = phaseType;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public void setProcessAction(String processAction) {
		this.processAction = processAction;
	}

	public void setTaskParticipants(String taskParticipants) {
		this.taskParticipants = taskParticipants;
	}

	public void setRelativeData(String relativeData) {
		this.relativeData = relativeData;
	}

	public void setProcessState(String processState) {
		this.processState = processState;
	}

	public void setBizAssignedTaskID(String bizAssignedTaskID) {
		this.bizAssignedTaskID = bizAssignedTaskID;
	}

	public void setVoteSerialNo(String voteSerialNo) {
		this.voteSerialNo = voteSerialNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

}
