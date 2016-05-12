package com.amarsoft.app.als.process.action;

import java.util.ArrayList;
import java.util.List;

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

/**
 * 流程启动流转相关辅助操作，用于流程引擎操作前、操作后应用系统流程表记录的更新，或者获取相关记录。
 * @author zszhang
 *
 */
public class BusinessProcessActionAssistor extends BaseAssistor {
	
	private static final String SUCCESS_MESSAGE = "SUCCESS";
	private static final String FAILURE_MESSAGE = "FAILURE";
	
	private Log logger = ARE.getLog();
	
	public BusinessProcessActionAssistor() {
		super();
	}

	public BusinessProcessActionAssistor(JBOTransaction tx) {
		super(tx);
	}

	public BusinessProcessActionAssistor(BizProcessConfiguration bpConfiguration) {
		super(bpConfiguration);
	}

	public BusinessProcessActionAssistor(String bizProcessObjectClaz, String bizProcessTaskClaz, String bizProcessOpinionClaz) {
		super(bizProcessObjectClaz, bizProcessTaskClaz, bizProcessOpinionClaz);
	}
	
	/**
	 * 启动流程的前处理操作,一般为初始化相关数据
	 * @param businessObject 流程业务对象
	 * @param relativeData 流程相关对象
	 * @return String
	 * @throws Exception
	 */
	public String preStart(RelativeBusinessObject businessObject, String relativeData) throws Exception {
		return initRelativeData(businessObject, relativeData);
	}
	
	/**
	 * 启动流程的辅助操作,向Object中新增一条记录,向Task中新增一条记录（开始后直接停留在第一个流程阶段，不存在多条记录）
	 * @param processDefID 流程定义编号
	 * @param userID 用户编号
	 * @param processState 流程状态
	 * @param businessObject 与此流程相关的业务对象
	 * @param processObjects 流程引擎返回的流程对象列表
	 * @throws Exception
	 */
	public void postStart(String processDefID, String userID, String processState, RelativeBusinessObject businessObject, List<ProcessObject> processObjects) throws Exception {
		String objectSerialNo = "";
		String taskSerialNo = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObject bo;
		try {
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);

			PSUserObject curUser = PSUserObject.getUser(userID); //用户对象
			
			bo = bom.newObject();
	        bo.getAttribute("ObjectNo").setValue(businessObject.getObjectNo()); //对象编号
	        bo.getAttribute("ObjectType").setValue(businessObject.getObjectType()); //对象类型
	        bo.getAttribute("ApplyType").setValue(businessObject.getApplyType());//申请类型
	        bo.getAttribute("FlowNo").setValue(processDefID);//流程定义编号
	        bo.getAttribute("OrgID").setValue(curUser.getOrgID());//机构编号
	        bo.getAttribute("OrgName").setValue(curUser.getOrgName());//机构名称
	        bo.getAttribute("UserID").setValue(curUser.getUserID());//用户编号
	        bo.getAttribute("UserName").setValue(curUser.getUserName());//用户名称
	        bo.getAttribute("InputDate").setValue(StringFunction.getTodayNow());//输入日期
	        
	        if(processObjects == null || processObjects.size() ==0){
	        	throw new Exception("********启动流程的后处理失败，流程对象为空********");
	        } else if(processObjects.size() == 1){//有且只有一条记录
	        	ProcessObject processObject = (ProcessObject)processObjects.get(0);
	        	bo.getAttribute("FlowName").setValue(processObject.getProcessDefName());//流程定义名称
	        	bo.getAttribute("ProcessInstNo").setValue(processObject.getProcessInstID());//流程实例编号
	        	bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//流程任务编号
	            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//阶段类型
	        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//阶段编号
	            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//阶段名称
	            bo.getAttribute("OBJDESCRIBE").setValue(processObject.getObjectDescribe());//引擎中流程定义编号
	            //流程状态默认初始化为1010，可以通过外部传入修改
	            if(processState==null || "".equals(processState)){
	            	bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_APPLY);
	            }else{
	            	bo.getAttribute("FlowState").setValue(processState);
	            }
	            bo.getAttribute("ARCHIVE").setValue("0");//归档号初始化为0

	            //写入业务流程对象表，新增一条。
	            bom.saveObject(bo);
	            objectSerialNo = bo.getAttribute("ObjectNo").toString();
	            
	            //写入业务流程任务表，新增一条。
	            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
	            getTx().join(taskBom);
	            BizObject taskBo = taskBom.newObject();
	            taskBo.setAttributesValue(bo);
	            //taskBo.getAttribute("SerialNo").setNull(); //流水号主键先置空，然后再由JBO产生
	            taskBo.getAttribute("RelativeObjectNo").setValue(objectSerialNo);
	            taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());
	            taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
	            taskBom.saveObject(taskBo);
	            taskSerialNo = taskBo.getAttribute("SerialNo").toString();
	            
	            //将taskSerialNo反存入业务流程对象表
	            bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
	            bom.saveObject(bo);
	        }else{
	        	throw new Exception("********启动流程的后处理失败，流程对象记录太多********");
	        }
		} catch (JBOException e) {
			logger.debug("********启动流程的后处理数据库操作失败********"+e.getMessage(), e);
			throw new Exception("********启动流程的后处理数据库操作失败********"+e.getMessage(), e);
		} catch (Exception e) {
			logger.debug("********启动流程的后处理操作失败********"+e.getMessage(), e);
			e.printStackTrace();
			throw new Exception("********启动流程的后处理操作失败********"+e.getMessage(), e);
		}
	}
	
	/**
	 * 发起再议:
	 * @param processDefID 流程定义编号
	 * @param businessObject 相关业务对象
	 * @param processState 流程状态
	 * @return
	 * @throws Exception
	 */

	public String postReConsider(String processDefID, String bizProcessTaskID, String processState) throws Exception{
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObjectQuery query;
		BizObject bo;
		try {
			//关闭当前任务
			taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(taskBom);
			query = taskBom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			BizObject curBo = query.getSingleResult(true);
			if(curBo != null){
				curBo.setAttributeValue("EndTime", StringFunction.getTodayNow());
				curBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
			}else{
				return FAILURE_MESSAGE;
			}
			
			//查询出流程发起阶段的下一阶段
			String relativeObjectNo = curBo.getAttribute("RelativeObjectNo").toString();
			query = taskBom.createQuery("RelativeObjectNo = :RelativeObjectNo order by SerialNo asc")
									.setParameter("RelativeObjectNo", relativeObjectNo);
			@SuppressWarnings("unchecked")
			List boList = query.getResultList(false);
			BizObject firstBo = (BizObject)boList.get(1);
			if(firstBo == null)return FAILURE_MESSAGE;
			
			curBo.setAttributeValue("PhaseAction", firstBo.getAttribute("PhaseNo"));
			curBo.setAttributeValue("PhaseOpinion", firstBo.getAttribute("UserID"));
			taskBom.saveObject(curBo);
			
			if (processState == null || "".equals(processState)) {
				processState = BusinessProcessConst.FLOWSTATE_RECONSIDER;
			}
			
			//新增一条记录
			BizObject taskbo = taskBom.newObject();
			taskbo.setAttributesValue(curBo);
			taskbo.getAttribute("SerialNo").setNull();
			taskbo.setAttributeValue("RelativeSerialNo", bizProcessTaskID);
			taskbo.setAttributeValue("RelativeObjectNo", relativeObjectNo);
			taskbo.getAttribute("OrgID").setValue(firstBo.getAttribute("OrgID"));//机构编号
			taskbo.getAttribute("OrgName").setValue(firstBo.getAttribute("OrgName"));//机构名称
			taskbo.getAttribute("UserID").setValue(firstBo.getAttribute("UserID"));//用户编号
			taskbo.getAttribute("UserName").setValue(firstBo.getAttribute("UserName"));//用户名称
			taskbo.setAttributeValue("PhaseNo", firstBo.getAttribute("PhaseNo"));
			taskbo.setAttributeValue("PhaseName", firstBo.getAttribute("PhaseName"));
			taskbo.setAttributeValue("PhaseType", firstBo.getAttribute("PhaseType"));
			taskbo.getAttribute("InfoArea").setValue(firstBo.getAttribute("InfoArea"));//信息区
			taskbo.getAttribute("OperateArea").setValue(firstBo.getAttribute("OperateArea"));//作业区
			taskbo.getAttribute("ButtonArea").setValue(firstBo.getAttribute("ButtonArea"));//按钮区
			taskbo.setAttributeValue("BeginTime", StringFunction.getTodayNow());
			taskbo.getAttribute("EndTime").setNull();
			taskbo.setAttributeValue("TaskState", BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
			taskbo.setAttributeValue("FlowState", processState);
			taskBom.saveObject(taskbo);
			
			String newSerialNo = taskbo.getAttribute("SerialNo").toString();
			//更新Object记录
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("ObjectNo = :SerialNo").setParameter("SerialNo", relativeObjectNo);
			bo = query.getSingleResult(true);
			bo.setAttributeValue("PhaseType", firstBo.getAttribute("PhaseType"));
			bo.setAttributeValue("PhaseNo", firstBo.getAttribute("PhaseNo"));
			bo.setAttributeValue("PhaseName", firstBo.getAttribute("PhaseName"));
			bo.setAttributeValue("FlowState", processState);
			bo.setAttributeValue("RelativeTaskNo", newSerialNo);
			bom.saveObject(bo);
			commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("发起再议操作失败", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 业务系统的删除操作:删除Object/Task相关记录
	 * @param processDefID 流程定义编号
	 * @param bizProcessObjectID 业务对象编号
	 * @return SUCCESS/FAILURE
	 * @throws Exception
	 */
	public String doDelete(String processDefID, String bizProcessObjectID) throws Exception {
		String result = FAILURE_MESSAGE;
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try{
			//删除Object相关记录
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("ObjectNo =:SerialNo").setParameter("SerialNo", bizProcessObjectID);
			bo = query.getSingleResult(true);
			if (bo != null) {
				bom.deleteObject(bo);
			} else {
				logger.error("删除流程对象记录失败，流水号为["+bizProcessObjectID+"]的记录未找到");
				rollbackTx();
				return result;
			}
			
			//删除Task相关记录
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("RelativeObjectNo =:SerialNo").setParameter("SerialNo", bizProcessObjectID);
			@SuppressWarnings("unchecked")
			List bos = query.getResultList(true);
			if(bos != null && bos.size() > 0){
				for(int i=0; i < bos.size(); i++){
					bom.deleteObject((BizObject)bos.get(i));
				}
			}else{
				logger.error("删除流程任务记录失败，关联流程对象流水号为["+bizProcessObjectID+"]的记录未找到");
				rollbackTx();
				return result;
			}
			result = SUCCESS_MESSAGE;
			logger.info("应用系统删除业务数据成功,如果外部传入事务，请在外部提交事务");
		} catch (JBOException e){
			rollbackTx();
			logger.debug("应用系统删除业务数据失败" + e.getMessage(), e);
			throw new Exception("应用系统删除业务数据失败" + e.getMessage(), e);
		}
		return result;
	}
	
	public String preCommit(RelativeBusinessObject businessObject, String relativeData) throws Exception {
		return initRelativeData(businessObject, relativeData);
	}
	
	/**
	 * 提交前辅助操作
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务流程任务编号
	 * @return 成功返回流程任务相关信息，失败返回 ""
	 */
	public String preCommitAssistant(String processDefID, String bizProcessTaskID) throws Exception {
		String returnMessage = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try {
			//查询要提交到的任务相关信息
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo =:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(false);
			if (bo != null) {
				returnMessage = bo.getAttribute("PhaseNo").toString() + "@"
						+ bo.getAttribute("UserID").toString().replace("@", "");
			}
			commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("流程提交前辅助操作失败"+e.getMessage(), e);
			throw new Exception("流程提交前辅助操作失败"+e.getMessage(), e);
		}
		return returnMessage;
	}
	
	/**
	 * 提交流程的辅助操作.更新Object/Task记录,并向Task中新增一条或多条记录
	 * @param processDefID 流程定义编号
	 * @param bizProcessObjectID 流程对象编号
	 * @param bizProcessTaskID 流程任务编号
	 * @param voteSerialNo 贷审会编号
	 * @param curUserID 流程提交人
	 * @param processAction 流程提交动作
	 * @param taskParticipants 流程处理人
	 * @param businessObject 与本流程相关的业务对象
	 * @param processObjects 流程引擎返回的流程对象列表
	 * @param processState 流程状态
	 * @param bizAssignedTaskID 指定下一阶段流程任务编号
	 * @return
	 */
	public String commitAssistant(String processDefID,
			String bizProcessObjectID, String bizProcessTaskID,
			String voteSerialNo, String curUserID, String processAction,
			String taskParticipants, RelativeBusinessObject businessObject,
			List<ProcessObject> processObjects, String processState,
			String bizAssignedTaskID) {
		String taskSerialNo = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom,mTaskBom;
		BizObjectQuery query;
		BizObject bo,taskBo;
		if(processState==null||"".equals(processState)||"null".equalsIgnoreCase(processState)){
			processState = BusinessProcessConst.FLOWSTATE_APPROVE;
		}
		try {
			
		    String multiUsers [] = taskParticipants.split(",");
			for(int k = 0 ; k < multiUsers.length ; k++){
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				
				query = bom.createQuery("ObjectNo = :ObjectNo and ObjectType = :ObjectType and PhaseNo=:PhaseNo")
										.setParameter("ObjectNo", bizProcessObjectID)
										.setParameter("ObjectType", businessObject.getObjectType())
										.setParameter("PhaseNo", businessObject.getPhaseNo());
				bo = query.getSingleResult(true);
				
				if(processObjects == null || processObjects.size() ==0){
		        	return FAILURE_MESSAGE;
		        } else if(processObjects.size() == 1){//大部分情况下为一条记录(流程的单任务模式)
		        	ProcessObject processObject = (ProcessObject)processObjects.get(0);
		            
		            //写入业务流程任务表
		            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		            getTx().join(taskBom);
		            
		            //检查是否为多个用户,去掉第一个逗号，分割成数组。
					String users = processObject.getUserID();
					String[] userID = null;
					if (users != null) {
						if (users.startsWith(","))users = users.substring(1);
						userID = users.split(",");
						userID = multiUsers[k].split(" ");
					}
					
		            //分支的聚合节点处理方式
		            if (processAction.startsWith("Join")){
		            	query = taskBom.createQuery("RelativeObjectNo=:RelativeObjectNo and TaskState=0")
		            						.setParameter("RelativeObjectNo",bizProcessObjectID);
		            	List<BizObject> bos = query.getResultList(false);
		            	
		            	
		            	//如果存在一条以上的记录未聚合，则删除该条记录，等待其他分支聚合完成。
		            	//如果是最后一条记录提交的聚合，则完成聚合，将流程提交到下个节点。
		            	if(bos!=null && bos.size()>1){
		            		//流程对象表处理
			            	query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
    											.setParameter("SerialNo",bizProcessObjectID)
    											.setParameter("PhaseNo", businessObject.getPhaseNo());
			            	bo = query.getSingleResult(true);
			            	bom.deleteObject(bo);
		            	}else{

				            //更新业务流程对象表
				            bom.saveObject(bo);
				            
				            //流程任务表处理
							taskBo = taskBom.newObject();
							taskBo.setAttributesValue(bo);
							taskBo.getAttribute("SerialNo").setNull(); // 流水号主键先置空，然后再由JBO产生
							taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);// 相关流程对象编号
							taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);// 相关流水号
							taskBo.getAttribute("PhaseType").setValue(processObject.getMilestone());//阶段类型
							taskBo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//阶段编号
							taskBo.getAttribute("PhaseName").setValue(processObject.getActivityName());//阶段名称
							taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//流程引擎任务号
							taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());//开始时间
							taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//状态设置为未提交
							taskBo.getAttribute("FlowState").setValue(processState);//流程状态
							taskBo.getAttribute("InfoArea").setValue(processObject.getInfoArea());//信息区
							taskBo.getAttribute("OperateArea").setValue(processObject.getOperateArea());//作业区
							taskBo.getAttribute("ButtonArea").setValue(processObject.getButtonArea());//按钮区
							taskBo.getAttribute("GroupID").setValue(processObject.getGroupID());//角色信息
							taskBo.getAttribute("AssignedTaskNo").setValue(bizAssignedTaskID);//指定下一阶段流程任务编号
							
			                //获取并设置用户名称、机构编号、机构名称
			                PSUserObject user = PSUserObject.getUser(processObject.getUserID());
			                taskBo.getAttribute("UserID").setValue(user.getUserID());
			                taskBo.getAttribute("UserName").setValue(user.getUserName());
			                taskBo.getAttribute("OrgID").setValue(user.getOrgID());
			                taskBo.getAttribute("OrgName").setValue(user.getOrgName());
			                taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
							taskBom.saveObject(taskBo);
							
							
		            		//流程对象表处理
			            	query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
												.setParameter("SerialNo",bizProcessObjectID)
												.setParameter("PhaseNo", businessObject.getPhaseNo());
			            	bo = query.getSingleResult(true);
				            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//阶段类型
				        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//阶段编号
				            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//阶段名称
				            bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//任务编号
				            bo.getAttribute("FlowState").setValue(processState);//流程状态
				            taskSerialNo = taskBo.getAttribute("SerialNo").toString();
				            bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);//相关最新流程任务表编号
				            bom.saveObject(bo);
		            	}
		            }
		            
		            //一般任务节点或结束节点处理方式
					if (processAction.startsWith("Task") || processAction.startsWith("End")) {
						
			            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//阶段类型
			        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//阶段编号
			            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//阶段名称
			            bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//任务编号
			            bo.getAttribute("FlowState").setValue(processState);//流程状态
						if("1000".equals(processObject.getMilestone())){
							bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_AGREE);
						}
						if("8000".equals(processObject.getMilestone())){
							bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_REJECT);
						}
			            //写入业务流程对象表
			            bom.saveObject(bo);
						
			            //获取用户名称、机构编号、机构名称
						PSUserObject user = null;
						if(userID.length==0){
							user = PSUserObject.getUser("");
						}else{
							user = PSUserObject.getUser(userID[0]);
						}
		            	query = taskBom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",bizProcessTaskID);
		            	taskBo = query.getSingleResult(false);
		            	String forkState = taskBo.getAttribute("ForkState").getString();
						
						taskBo = taskBom.newObject();
						taskBo.setAttributesValue(bo);
						taskBo.getAttribute("SerialNo").setNull(); // 流水号主键先置空，然后再由JBO产生
						taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);// 相关流程对象编号
						taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);// 相关流水号
						taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());
						taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
						taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//状态设置为未提交
						taskBo.getAttribute("FlowState").setValue(processState);//流程状态
						taskBo.getAttribute("InfoArea").setValue(processObject.getInfoArea());//信息区
						taskBo.getAttribute("OperateArea").setValue(processObject.getOperateArea());//作业区
						taskBo.getAttribute("ButtonArea").setValue(processObject.getButtonArea());//按钮区
						taskBo.getAttribute("GroupID").setValue(processObject.getGroupID());//角色信息
						taskBo.getAttribute("AssignedTaskNo").setValue(bizAssignedTaskID);//指定下一阶段流程任务编号
						if(forkState!=null){
							String forkNum = forkState.substring(1, forkState.length());
							taskBo.getAttribute("ForkState").setValue(BusinessProcessConst.FORKSTATE_MIDDLE + forkNum);//分支状态-分支中
						}
						if(voteSerialNo!=null){
							taskBo.getAttribute("RelativeVoteNo").setValue(voteSerialNo);//待审会议编号
						}
						if("1".equals(processObject.getIsSecretary())){
							taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_SECRETARY);//贷审会秘书状态
							taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_SECRETARY);//贷审会秘书状态
							bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_SECRETARY);//贷审会秘书状态
						}
			            if("1".equals(processObject.getIsPool())){
			            	taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);//任务池状态
			            	taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//任务池状态
			            	bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//任务池状态
							taskBo.getAttribute("GroupID").setValue(processObject.getUserID());
							taskBo.getAttribute("UserID").setValue("");//任务池状态用户编号置空
							taskBo.getAttribute("UserName").setValue("");//任务池状态用户名置空
							taskBo.getAttribute("OrgID").setValue("");//任务池状态机构编号置空
							taskBo.getAttribute("OrgName").setValue("");//任务池状态机构名置空
			            }else{
							taskBo.getAttribute("UserID").setValue(user.getUserID());
							taskBo.getAttribute("UserName").setValue(user.getUserName());
							taskBo.getAttribute("OrgID").setValue(user.getOrgID());
							taskBo.getAttribute("OrgName").setValue(user.getOrgName());
			            }
		
						// 如果为终审阶段,则设置结束时间
						if (processObject.getActivityID().startsWith("End")) {
							BizObject oldTaskBo = taskBom.createQuery("RelativeObjectNo =:RelativeObjectNo and userID = :UserID order by SerialNo desc")
													.setParameter("RelativeObjectNo", bizProcessObjectID)
													.setParameter("UserID", curUserID).getSingleResult(false);
							taskBo.getAttribute("UserID").setValue(oldTaskBo.getAttribute("UserID"));
							taskBo.getAttribute("UserName").setValue(oldTaskBo.getAttribute("UserName"));
							taskBo.getAttribute("OrgID").setValue(oldTaskBo.getAttribute("OrgID"));
							taskBo.getAttribute("OrgName").setValue(oldTaskBo.getAttribute("OrgName"));
							taskBo.getAttribute("EndTime").setValue(StringFunction.getTodayNow());
							taskBo.getAttribute("PhaseOpinion").setValue("AutoFinish");
							//流程终结标志
							taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_END);
							if("1000".equals(processObject.getMilestone())){
								taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_AGREE);
							}
							if("8000".equals(processObject.getMilestone())){
								taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_REJECT);
							}
						}
						taskBom.saveObject(taskBo);
						taskSerialNo = taskBo.getAttribute("SerialNo").toString();
						
			            //将taskSerialNo反存入业务流程对象表
			            bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
			            bom.saveObject(bo);
			            
			            
			            //分支中的结束处理
			            if(processAction.startsWith("End")){
				            query = taskBom.createQuery("RelativeObjectNo =:RelativeObjectNo and TaskState='0' and PhaseNo <> :PhaseNo")
				            				.setParameter("RelativeObjectNo", bizProcessObjectID).setParameter("PhaseNo", businessObject.getPhaseNo());
				            List<BizObject> bos = query.getResultList(true);
							if (bos != null) {
								for (int i = 0; i < bos.size(); i++) {
									bo = bos.get(i);
									taskBom.deleteObject(bo);
								}
							}
							
							query = bom.createQuery("ObjectNo =:SerialNo and PhaseNo not in (:PhaseNo,:NewPhaseNo)")
											.setParameter("SerialNo", bizProcessObjectID)
											.setParameter("PhaseNo", businessObject.getPhaseNo())
											.setParameter("NewPhaseNo", processObject.getActivityID());
							bos = query.getResultList(true);
							if (bos != null) {
								for (int i = 0; i < bos.size(); i++) {
									bo = bos.get(i);
									bom.deleteObject(bo);
								}
							}
			            }
		            }
		            
					//会签节点处理方式
		            if(processObject.getActivityID().startsWith("CounterSign")){
		            	
			            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//阶段类型
			        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//阶段编号
			            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//阶段名称
			            bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//任务编号
			            bo.getAttribute("FlowState").setValue(processState);//流程状态
						if("1000".equals(processObject.getMilestone())){
							bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_AGREE);
						}
						if("8000".equals(processObject.getMilestone())){
							bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_REJECT);
						}
			            //写入业务流程对象表
			            bom.saveObject(bo);
		            	
						taskBo = taskBom.newObject();
						taskBo.setAttributesValue(bo);
						taskBo.getAttribute("SerialNo").setNull(); // 流水号主键先置空，然后再由JBO产生
						taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);// 相关流程对象编号
						taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);// 相关流水号
						taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());
						
						taskBo.getAttribute("UserID").setValue("@"+users.replace(",", "@"));
						taskBo.getAttribute("UserName").setValue("");
						taskBo.getAttribute("OrgID").setValue("");
						taskBo.getAttribute("OrgName").setValue("");
						
						taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
						taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//状态设置为未提交
						taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_VOTE);//流程状态
						taskBo.getAttribute("InfoArea").setValue(processObject.getInfoArea());//信息区
						taskBo.getAttribute("OperateArea").setValue(processObject.getOperateArea());//作业区
						taskBo.getAttribute("ButtonArea").setValue(processObject.getButtonArea());//按钮区
						taskBo.getAttribute("GroupID").setValue(processObject.getGroupID());
						if(voteSerialNo!=null){
							taskBo.getAttribute("RelativeVoteNo").setValue(voteSerialNo);//待审会议编号
						}
			            if("1".equals(processObject.getIsPool())){
			            	taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);//任务池状态
			            	taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//任务池状态
			            	bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//任务池状态
							taskBo.getAttribute("GroupID").setValue(processObject.getUserID());
							taskBo.getAttribute("UserID").setValue("");//任务池状态用户编号置空
							taskBo.getAttribute("UserName").setValue("");//任务池状态用户名置空
							taskBo.getAttribute("OrgID").setValue("");//任务池状态机构编号置空
							taskBo.getAttribute("OrgName").setValue("");//任务池状态机构名置空
			            }
		
						// 如果为终审阶段,则设置结束时间
						if (processObject.getActivityID().startsWith("End")) {
							taskBo.getAttribute("EndTime").setValue(StringFunction.getTodayNow());
							taskBo.getAttribute("PhaseOpinion").setValue("AutoFinish");
							//流程终结标志
							taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_END);
							if("1000".equals(processObject.getMilestone())){
								taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_AGREE);
							}
							if("8000".equals(processObject.getMilestone())){
								taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_REJECT);
							}
						}
						taskBom.saveObject(taskBo);
						taskSerialNo = taskBo.getAttribute("SerialNo").toString();
						
			            // 将taskSerialNo反存入业务流程对象表
			            bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
			            bom.saveObject(bo);
		            	
			            // 依次写入业务流程复合任务表
	    	            mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
	    	            getTx().join(mTaskBom);
		            	for(int i = 0 ; i < userID.length ; i++){
		    	            BizObject mTaskbo = mTaskBom.newObject();
		    	            //获取用户名称、机构编号、机构名称
		    	            PSUserObject user = PSUserObject.getUser(userID[i]);
		    	            mTaskbo.getAttribute("SerialNo").setNull();
		    	            mTaskbo.setAttributeValue("RelativeTaskNo", taskSerialNo);
		    	            mTaskbo.setAttributeValue("UserID", user.getUserID());
		    	            mTaskbo.setAttributeValue("UserName", user.getUserName());
		    	            mTaskbo.setAttributeValue("OrgID", user.getOrgID());
		    	            mTaskbo.setAttributeValue("OrgName", user.getOrgName());
		    	            mTaskbo.setAttributeValue("BeginTime", StringFunction.getTodayNow());
		    	            mTaskbo.setAttributeValue("VoteState", BusinessProcessConst.UNFINISHED);
		    	            mTaskBom.saveObject(mTaskbo);
		            	}
		            }
		        } else{
		        	//多条记录，例如进入分支后。
		        	for(int i=0;i<processObjects.size();i++){
		        		ProcessObject processObject = processObjects.get(i);

		        		//流程任务表依次插入记录
		                taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		                getTx().join(taskBom);
		                
		                query = taskBom.createQuery("RelativeObjectNo=:RelativeObjectNo and ForkState is not null order by ForkState desc")
		                							.setParameter("RelativeObjectNo", bizProcessObjectID);
		                BizObject boMax = query.getSingleResult(false);
		                Integer maxForkState=10;
		                if(boMax!=null){
		                		maxForkState = boMax.getAttribute("ForkState").getInt()+1;
		                }
		                
		                taskBo = taskBom.newObject();
		                taskBo.setAttributesValue(bo);
		                taskBo.getAttribute("SerialNo").setNull(); //流水号主键先置空，然后再由JBO产生
						taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);
		                taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);//相关流水号
		                taskBo.getAttribute("PhaseType").setValue(processObject.getMilestone());//阶段类型
		                taskBo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//阶段编号
		                taskBo.getAttribute("PhaseName").setValue(processObject.getActivityName());//阶段名称
		                taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());
		                taskBo.getAttribute("UserID").setValue(processObject.getUserID());
						taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//任务状态-未提交
						taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_APPROVE);//流程状态-审批中
						taskBo.getAttribute("InfoArea").setValue(processObject.getInfoArea());//信息区
						taskBo.getAttribute("OperateArea").setValue(processObject.getOperateArea());//作业区
						taskBo.getAttribute("ButtonArea").setValue(processObject.getButtonArea());//按钮区
						taskBo.getAttribute("GroupID").setValue(processObject.getGroupID());//角色信息
						taskBo.getAttribute("ForkState").setValue(BusinessProcessConst.FORKSTATE_START+maxForkState);//分支状态-起始
	
		                //获取并设置用户名称、机构编号、机构名称
		                PSUserObject user = PSUserObject.getUser(processObject.getUserID());
		                taskBo.getAttribute("UserID").setValue(user.getUserID());
		                taskBo.getAttribute("UserName").setValue(user.getUserName());
		                taskBo.getAttribute("OrgID").setValue(user.getOrgID());
		                taskBo.getAttribute("OrgName").setValue(user.getOrgName());
		                taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
		                taskBom.saveObject(taskBo);
		                
		                //流程对象表更新或新增记录
		        		if(i==0){
			        		//更新流程对象表
				            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//阶段类型
				        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//阶段编号
				            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//阶段名称
				            bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//任务编号
				            bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_APPROVE);//流程状态
				            bo.setAttributeValue("RELATIVETASKNO", taskBo.getAttribute("SerialNo"));
			                bom.saveObject(bo);
		        		}else{
		        			BizObject boNew = bom.newObject();
			        		//流程对象表插入新记录
		        			boNew.setAttributesValue(bo);
				            boNew.getAttribute("PhaseType").setValue(processObject.getMilestone());//阶段类型
		        			boNew.getAttribute("PhaseNo").setValue(processObject.getActivityID());//阶段编号
		        			boNew.getAttribute("PhaseName").setValue(processObject.getActivityName());//阶段名称
		        			boNew.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//任务编号
		        			boNew.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_APPROVE);//流程状态
		        			boNew.setAttributeValue("RELATIVETASKNO", taskBo.getAttribute("SerialNo"));
		        			bom.saveObject(boNew);
		        		}
		        	}
		        }
				//更新业务任务表
		        bom = factory.getManager(getBizProcessTaskClaz(processDefID));
		        getTx().join(bom);
		        BizObject bizOldTaskObject = bom.createQuery("SerialNo=:SerialNo")
		        				   				.setParameter("SerialNo", bizProcessTaskID)
		        				   				.getSingleResult(true);
		        bizOldTaskObject.getAttribute("EndTime").setValue(StringFunction.getTodayNow());//设置结束时间
		        bizOldTaskObject.getAttribute("PhaseOpinion").setValue(taskParticipants);//提交动作
		        bizOldTaskObject.getAttribute("PhaseAction").setValue(processAction);//提交意见
		        bizOldTaskObject.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_FINISHED);//状态设置为已提交
		        bom.saveObject(bizOldTaskObject);
		        
		        //删除流程任务表多余记录--提交到角色而非提交到具体人员专用，不影响正常流程
		        String relativeSerialNo = bizOldTaskObject.getAttribute("RelativeSerialNo").toString();
		        BizObjectManager oldTaskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		        getTx().join(oldTaskBom);
		        List deleteBos = oldTaskBom.createQuery("RelativeSerialNo=:RelativeSerialNo and TaskState = '0' and PhaseNo =:PhaseNo")
							        					.setParameter("RelativeSerialNo", relativeSerialNo)
							        					.setParameter("PhaseNo", businessObject.getPhaseNo())
							        					.getResultList(true);
		        if(deleteBos!=null){
		        	for(int i = 0 ; i< deleteBos.size();i++){
		        		BizObject deleteBo = (BizObject)deleteBos.get(i);
		        		oldTaskBom.deleteObject(deleteBo);
		        	}
		        }
		        commitTx();
			}
		} catch (JBOException e){
			rollbackTx();
			logger.debug("提交流程辅助处理出错", e);
			return FAILURE_MESSAGE;
		} catch (Exception e) {
			rollbackTx();
			logger.debug("提交流程的辅助操作失败,实例化用户对象出错", e);
			return FAILURE_MESSAGE;
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 增加审贷会成员的辅助操作.MultiTask增加记录
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务任务编号(与应用系统任务编号对应)
	 * @param users 用户列表
	 * @return
	 */
	public String addVoteAssistant(String processDefID, String bizProcessTaskID, String users){
		//查询出TASK记录，增加审贷会成员
		//if(users.startsWith(","))users.substring(1);
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObject bo;
		String [] userID = users.split(",");
		try {
			users = users.replace(",", "@");
            //更新业务流程任务表
            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
            getTx().join(taskBom);
            BizObject taskBo = taskBom.createQuery("SerialNo =:SerialNo")
            						.setParameter("SerialNo", bizProcessTaskID).getSingleResult(true);
            String oldUsers = taskBo.getAttribute("UserID").toString();
			users = oldUsers + users + "@";
            taskBo.setAttributeValue("UserID", users);
            taskBom.saveObject(taskBo);
			
			bom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
			getTx().join(bom);
			for (int i = 0; i < userID.length; i++) {
				PSUserObject user = PSUserObject.getUser(userID[i]);
				bo = bom.newObject();
				bo.getAttribute("SerialNo").setNull();
				bo.setAttributeValue("RelativeTaskNo", bizProcessTaskID);
				bo.setAttributeValue("UserID", user.getUserID());
				bo.setAttributeValue("UserName", user.getUserName());
				bo.setAttributeValue("OrgID", user.getOrgID());
				bo.setAttributeValue("OrgName", user.getOrgName());
				bo.setAttributeValue("BeginTime", StringFunction.getTodayNow());
				bo.setAttributeValue("VoteState", BusinessProcessConst.UNFINISHED);
				bom.saveObject(bo);
			}
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("增加审贷会成员辅助处理出错", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 删除审贷会成员的辅助操作.删除MultiTask记录
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务任务编号(与应用系统任务编号对应)
	 * @param users 用户列表
	 * @return
	 */
	public String removeVoteAssistant(String processDefID, String bizProcessTaskID, String users){
		//查询出MULTITASK记录，删除审贷会成员
		//if(users.startsWith(","))users.substring(1);
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObjectQuery query;
		BizObject bo;
		String [] userID = users.split(",");
		try {
            //更新业务流程任务表
            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
            getTx().join(taskBom);
            BizObject taskBo = taskBom.createQuery("SerialNo =:SerialNo")
					.setParameter("SerialNo", bizProcessTaskID).getSingleResult(false);
            String oldUsers = taskBo.getAttribute("UserID").toString();
            
			bom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
			getTx().join(bom);
			for (int i = 0; i < userID.length; i++) {
				oldUsers = oldUsers.replace(userID[i]+"@", "");
				query = bom.createQuery("RelativeTaskNo=:RelativeTaskNo and UserID=:UserID and VoteState<>'99'")
										.setParameter("RelativeTaskNo", bizProcessTaskID)
										.setParameter("UserID", userID[i]);
				bo = query.getSingleResult(true);
				if(bo!=null){
					bo.setAttributeValue("voteState", BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
					bom.saveObject(bo);
				}
			}
			taskBo.setAttributeValue("UserID", oldUsers);
			taskBom.saveObject(taskBo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("删除审贷会成员辅助处理出错", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 提交投票流程的辅助操作.更新Object/Task记录,并向Task中新增一条或多条记录
	 * @param processDefID 流程定义编号
	 * @param bizProcessObjectID 流程对象编号
	 * @param bizProcessTaskID 流程任务编号
	 * @param voteSerialNo 贷审会议编号
	 * @param userID 流程提交人
	 * @param voteOpinion 流程提交动作
	 * @param taskParticipants 流程处理人
	 * @param businessObject 与本流程相关的业务对象
	 * @param processObject 流程引擎返回的流程对象
	 * @return
	 */
	public String commitVoteAssistant(String processDefID, String bizProcessObjectID,String bizProcessTaskID, String voteSerialNo, String userID,String voteOpinion,String taskParticipants, RelativeBusinessObject businessObject, ProcessObject processObject){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom,mTaskBom;
		BizObjectQuery query;
		BizObject bo;
		if(processObject == null )return FAILURE_MESSAGE;
		try {
			if(processObject.getActivityID()==null || "".equals(processObject.getActivityID())){
				//更新复合任务表
				mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
				getTx().join(mTaskBom);
		        BizObject mTaskBo = mTaskBom.createQuery("RelativeTaskNo=:RelativeTaskNo and UserID=:UserID")
		        					.setParameter("RelativeTaskNo", bizProcessTaskID)
		        					.setParameter("UserID", userID).getSingleResult(true);
		        if(mTaskBo != null){
		        	mTaskBo.setAttributeValue("EndTime", StringFunction.getTodayNow());
		        	mTaskBo.setAttributeValue("VoteState", BusinessProcessConst.FINISHED);
		        	mTaskBo.setAttributeValue("VoteOpinion", voteOpinion);
		        	mTaskBom.saveObject(mTaskBo);
		        }
	            //更新业务流程任务表
	            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
	            getTx().join(taskBom);
	            BizObject taskBo = taskBom.createQuery("SerialNo =:SerialNo")
    					.setParameter("SerialNo", bizProcessTaskID).getSingleResult(true);
	            //查询出以投票的用户信息
	            String RelativeUser = taskBo.getAttribute("RelativeUser").toString();
				if (RelativeUser == null) {
					RelativeUser = "@" + processObject.getUserVote() + "@";
				} else {
					RelativeUser = RelativeUser + processObject.getUserVote() + "@";
				}
	            taskBo.setAttributeValue("RelativeUser", RelativeUser);
	            taskBom.saveObject(taskBo);
			}else{
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				
				query = bom.createQuery("ObjectNo=:SerialNo").setParameter("SerialNo", bizProcessObjectID);
				bo = query.getSingleResult(true);
				
	            bo.getAttribute("PhaseType").setValue(processObject.getMilestone());//阶段类型
	        	bo.getAttribute("PhaseNo").setValue(processObject.getActivityID());//阶段编号
	            bo.getAttribute("PhaseName").setValue(processObject.getActivityName());//阶段名称
	            bo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());//任务编号
	            bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_APPROVE);//流程状态
	            //写入业务流程对象表
	            bom.saveObject(bo);
	            
	            //写入业务流程任务表
	            taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
	            getTx().join(taskBom);
	            
	            //获取用户名称、机构编号、机构名称
	            PSUserObject user = PSUserObject.getUser(processObject.getUserID());
	            
				BizObject taskBo = taskBom.newObject();
				taskBo.setAttributesValue(bo);
				taskBo.getAttribute("SerialNo").setNull(); //流水号主键先置空，然后再由JBO产生
				taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID); //相关流程对象编号
				taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID); //相关流水号
				taskBo.getAttribute("ProcessTaskNo").setValue(processObject.getTaskID());
				taskBo.getAttribute("UserID").setValue(user.getUserID());
				taskBo.getAttribute("UserName").setValue(user.getUserName());
				taskBo.getAttribute("OrgID").setValue(user.getOrgID());
				taskBo.getAttribute("OrgName").setValue(user.getOrgName());
				taskBo.getAttribute("GroupID").setValue(processObject.getGroupID());
				taskBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
				taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//状态设置为未提交
				taskBo.getAttribute("InfoArea").setValue(processObject.getInfoArea());//信息区
				taskBo.getAttribute("OperateArea").setValue(processObject.getOperateArea());//作业区
				taskBo.getAttribute("ButtonArea").setValue(processObject.getButtonArea());//按钮区
				if(voteSerialNo!=null){
					taskBo.getAttribute("RelativeVoteNo").setValue(voteSerialNo);//贷审会议编号
				}
				//判断是否是贷审会秘书
				if("1".equals(processObject.getIsSecretary())){
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_SECRETARY);//贷审会秘书状态
					taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_SECRETARY);//贷审会秘书状态
					bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_SECRETARY);//贷审会秘书状态
				}
				if("1".equals(processObject.getIsPool())){
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);//任务池状态
					taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//任务池状态
					bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_POOL);//任务池状态
				}
				if(user.getUserID().indexOf("@")>=0){
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);//未完成
					taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_VOTE);//贷审会状态
					bo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_VOTE);//贷审会状态
				}
				//如果为终审阶段,则设置结束时间
				if (processObject.getActivityID().startsWith("End")) {
					BizObject oldTaskBo = taskBom.createQuery("RelativeObjectNo =:RelativeObjectNo order by SerialNo desc")
							.setParameter("RelativeObjectNo", bizProcessObjectID).getSingleResult(true);
					taskBo.getAttribute("UserID").setValue(oldTaskBo.getAttribute("UserID"));
					taskBo.getAttribute("UserName").setValue(oldTaskBo.getAttribute("UserName"));
					taskBo.getAttribute("OrgID").setValue(oldTaskBo.getAttribute("OrgID"));
					taskBo.getAttribute("OrgName").setValue(oldTaskBo.getAttribute("OrgName"));
					taskBo.getAttribute("EndTime").setValue(StringFunction.getTodayNow());
					taskBo.getAttribute("PhaseOpinion").setValue("AutoFinish");
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_END);//状态设置为已终结
					if("1000".equals(processObject.getMilestone())){
						taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_AGREE);
					}
					if("8000".equals(processObject.getMilestone())){
						taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_REJECT);
					}
				}
				taskBom.saveObject(taskBo);
				String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
				
	            //将taskSerialNo反存入业务流程对象表
	            bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
	            bom.saveObject(bo);
	
				//更新业务任务表
		        bom = factory.getManager(getBizProcessTaskClaz(processDefID));
		        getTx().join(bom);
		        BizObject bizOldTaskObject = bom.createQuery("SerialNo=:SerialNo")
		        				   				.setParameter("SerialNo", bizProcessTaskID)
		        				   				.getSingleResult(true);
	            //查询出以投票的用户信息
	            String RelativeUser = bizOldTaskObject.getAttribute("RelativeUser").toString();
				if (RelativeUser == null) {
					RelativeUser = "@" + processObject.getUserVote() + "@";
				} else {
					RelativeUser = RelativeUser + processObject.getUserVote() + "@";
				}
				bizOldTaskObject.setAttributeValue("RelativeUser", RelativeUser);
		        bizOldTaskObject.getAttribute("EndTime").setValue(StringFunction.getTodayNow());//设置结束时间
		        bizOldTaskObject.getAttribute("PhaseOpinion").setValue(taskParticipants);//提交动作
		        bizOldTaskObject.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_FINISHED);//状态设置为已提交
		        bom.saveObject(bizOldTaskObject);
		        
				//更新复合任务表
				mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
				getTx().join(mTaskBom);
		        BizObject mTaskBo = mTaskBom.createQuery("RelativeTaskNo=:RelativeTaskNo and UserID=:UserID")
		        					.setParameter("RelativeTaskNo", bizProcessTaskID)
		        					.setParameter("UserID", userID).getSingleResult(true);
		        if(mTaskBo != null){
		        	mTaskBo.setAttributeValue("EndTime", StringFunction.getTodayNow());
		        	mTaskBo.setAttributeValue("VoteState", BusinessProcessConst.FINISHED);
		        	mTaskBo.setAttributeValue("VoteOpinion", voteOpinion);
		        	mTaskBom.saveObject(mTaskBo);
		        }
		        
		        //新增复合任务表数据
				if(user.getUserID().indexOf("@")>=0){
		            // 依次写入业务流程复合任务表
    	            mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
    	            getTx().join(mTaskBom);
    	            String users[] = user.getUserID().split("@");
	            	for(int i = 1 ; i < users.length ; i++){
	    	            BizObject mTaskbo = mTaskBom.newObject();
	    	            //获取用户名称、机构编号、机构名称
	    	            PSUserObject mUser = PSUserObject.getUser(users[i]);
	    	            mTaskbo.getAttribute("SerialNo").setNull();
	    	            mTaskbo.setAttributeValue("RelativeTaskNo", taskSerialNo);
	    	            mTaskbo.setAttributeValue("UserID", mUser.getUserID());
	    	            mTaskbo.setAttributeValue("UserName", mUser.getUserName());
	    	            mTaskbo.setAttributeValue("OrgID", mUser.getOrgID());
	    	            mTaskbo.setAttributeValue("OrgName", mUser.getOrgName());
	    	            mTaskbo.setAttributeValue("BeginTime", StringFunction.getTodayNow());
	    	            mTaskbo.setAttributeValue("VoteState", BusinessProcessConst.UNFINISHED);
	    	            mTaskBom.saveObject(mTaskbo);
	            	}
				}
			}
	        commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("提交流程辅助处理出错", e);
			return FAILURE_MESSAGE;
		} catch (Exception e) {
			rollbackTx();
			logger.debug("提交流程的辅助操作失败,实例化用户对象出错", e);
			return FAILURE_MESSAGE;
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 任务池获取任务的辅助操作.更新Task记录
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务任务编号(与应用系统任务编号对应)
	 * @param userID 获取任务用户
	 * @return
	 */
	public String takeTaskFromPoolAssistant(String processDefID, String bizProcessTaskID, String userID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//查询出TASK记录，将用户置为获取任务人编号，并将relativeUser置为任务池角色
		try {
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(true);
			PSUserObject user = PSUserObject.getUser(userID);
			bo.setAttributeValue("UserID", user.getUserID());
			bo.getAttribute("UserName").setValue(user.getUserName());
			bo.getAttribute("OrgID").setValue(user.getOrgID());
			bo.getAttribute("OrgName").setValue(user.getOrgName());
			//将任务状态置为未提交
			bo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
			bom.saveObject(bo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("获取任务池任务出错", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 任务池用户调整的辅助操作.更新Task记录
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务任务编号(与应用系统任务编号对应)
	 * @param userID 获取任务用户
	 * @return
	 */
	public String taskPoolAdjustAssistant(String processDefID, String bizProcessTaskID, String userID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//查询出TASK记录，将用户置为调整任务人编号
		try {
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(true);
			PSUserObject user = PSUserObject.getUser(userID);
			bo.setAttributeValue("UserID", user.getUserID());
			bo.setAttributeValue("UserName", user.getUserName());
			bo.getAttribute("OrgID").setValue(user.getOrgID());
			bo.getAttribute("OrgName").setValue(user.getOrgName());
			bo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
			bom.saveObject(bo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("任务池用户调整出错", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 任务退回任务池的辅助操作.更新Task记录
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务任务编号(与应用系统任务编号对应)
	 * @return
	 */
	public String returnToPoolAssistant(String processDefID, String bizProcessTaskID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//查询出TASK记录，将用户置回为任务池状态
		try {
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(true);
			
			bo.setAttributeValue("UserID","");
			bo.setAttributeValue("UserName", "");
			bo.setAttributeValue("OrgID", "");
			bo.setAttributeValue("OrgName", "");
			bo.setAttributeValue("TaskState",BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);
			bom.saveObject(bo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("获取任务池任务出错", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 获取任务池角色
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务任务编号(与应用系统任务编号对应)
	 * @return
	 */
	public String getRole(String processDefID, String bizProcessTaskID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//获取任务池角色
		String roles = "";
		try {
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(false);
			roles = bo.getAttribute("GroupID").toString();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("获取任务池角色出错", e);
			return FAILURE_MESSAGE;
		}
		return roles;
	}
	
	/**
	 * 任务归档的辅助操作.更新Task记录
	 * @param processDefID 流程定义编号
	 * @param bizProcessObjectID 流程对象编号
	 * @return
	 */
	public String taskAchive(String processDefID, String bizProcessObjectID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//查询出TASK记录，将归档标识置为1
		try {
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("ObjectNo =:SerialNo")
						.setParameter("SerialNo", bizProcessObjectID);
			bo = query.getSingleResult(true);
			bo.getAttribute("ARCHIVE").setValue("1");
			bo.getAttribute("ARCHIVETIME").setValue(StringFunction.getTodayNow());
			bom.saveObject(bo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("任务归档辅助处理出错", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 取消任务归档的辅助操作.更新Task记录
	 * @param processDefID 流程定义编号
	 * @param bizProcessObjectID 流程对象编号
	 * @return
	 */
	public String cancelAchive(String processDefID, String bizProcessObjectID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		//查询出TASK记录，将归档标识置为0
		try {
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("ObjectNo =:SerialNo")
						.setParameter("SerialNo", bizProcessObjectID);
			bo = query.getSingleResult(true);
			bo.getAttribute("ARCHIVE").setValue("0");
			bo.getAttribute("ARCHIVETIME").setValue(StringFunction.getTodayNow());
			bom.saveObject(bo);
			commitTx();
		} catch (Exception e) {
			rollbackTx();
			logger.debug("任务归档辅助处理出错", e);
			return FAILURE_MESSAGE;
		}
		
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 任务是否可收回判断,判断条件:上一步的处理人是否是当前处理人
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务流程任务编号
	 * @param userID 当前处理人编号
	 * @return true/false
	 */
	public boolean canWithdraw(String processDefID, String bizProcessTaskID, String userID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try {
			 //找出相关流水号和相关对象编号
			 bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			 String queryStr = "SerialNo=:SerialNo ";
			 query = bom.createQuery(queryStr).setParameter("SerialNo", bizProcessTaskID);
			 bo = query.getSingleResult(false);
			 String relativeSerialNo = bo.getAttribute("RelativeSerialNo").toString();
			 String relativeObjectNo = bo.getAttribute("RelativeObjectNo").toString();
			 
			 query = bom.createQuery("RelativeSerialNo=:RSerialNo and RelativeObjectNo=:RObjectNo")
			 							.setParameter("RSerialNo", relativeSerialNo)
			 							.setParameter("RObjectNo", relativeObjectNo);
			 List<BizObject> bos = query.getResultList(false);
			 for(int i = 0;i<bos.size();i++){
				 bo = bos.get(i);
				 String taskState = bo.getAttribute("TaskState").toString();
				 //找出上一步处理人
				 queryStr = "SerialNo=:SerialNo ";
				 query = bom.createQuery(queryStr).setParameter("SerialNo", relativeSerialNo);
				 bo = query.getSingleResult(false);
				 String lastUserID = bo.getAttribute("UserID").toString().replace("@", "");
				 if(!userID.equalsIgnoreCase(lastUserID) || "1".equals(taskState)){
					 return false;
				 }
			 }
		} catch (JBOException e){
			logger.debug("判断任务是否可收回失败", e);
			return false;
		}
		return true;
	}
	
	/**
	 * 收回任务,返回待提交任务编号供流程引擎调用
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务流程任务编号
	 * @return
	 */
	public String doWithdraw(String processDefID, String bizProcessTaskID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		String withdrawProp = "";
		try {
			 //取得上一步的bizProcessTaskID
			 bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			 getTx().join(bom);
			 query = bom.createQuery("SerialNo=:SerialNo")
			 			.setParameter("SerialNo", bizProcessTaskID);
			 bo = query.getSingleResult(true);
			 
			 String oldBizProcessTaskID = bo.getAttribute("RelativeSerialNo").toString();
			 String processTaskNo = bo.getAttribute("ProcessTaskNo").toString();
			 
			 query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", oldBizProcessTaskID);
			 BizObject lastTaskBo = query.getSingleResult(false);

			 withdrawProp = processTaskNo + "@" + //收回主体任务编号
	 		 				lastTaskBo.getAttribute("PhaseNo").getString() + "@" + //收回阶段
	 		 				lastTaskBo.getAttribute("UserID").getString().replace("@", "") + "@" + //收回人
	 		 				oldBizProcessTaskID + "@" +  //前一步流程任务流水号
	 		 				lastTaskBo.getAttribute("ProcessTaskNo").toString();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("任务收回出错", e);
		}
		return withdrawProp;
	}
	
	/**
	 * 收回流程任务的后处理动作:更新当前任务的流程任务编号
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务流程任务编号
	 * @param oldBizProcessTaskID 退回所在业务流程任务编号
	 * @param processObjects 流程引擎返回的流程对象列表
	 * @return
	 */
	public String postWithdraw(String processDefID, String bizProcessTaskID, String oldBizProcessTaskID, List<ProcessObject> processObjects) throws Exception {
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObjectQuery query;
		BizObject bo,taskBo;
		try {
			
			if(processObjects == null){
				return FAILURE_MESSAGE;
			}
			
			// 更新Task的任务状态为关闭
			taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(taskBom);
			query = taskBom.createQuery("RelativeSerialNo=:RelativeSerialNo").setParameter("RelativeSerialNo", oldBizProcessTaskID);
			List taskBos = query.getResultList(true);
			// 是否是分支起点标志位
			Boolean forkFlag = true;
			for (int i = 0; i < taskBos.size(); i++) {
				taskBo = (BizObject) taskBos.get(i);
				//将分支起始标志位置为假
				if(taskBo.getAttribute("ForkState").toString()==null||!taskBo.getAttribute("ForkState").toString().startsWith("0")){
					forkFlag = false;
				}
				taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
				taskBom.saveObject(taskBo);
			}
			 
			// 查询出退回所在TASK的参数
			query = taskBom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", oldBizProcessTaskID);
			bo = query.getSingleResult(true);
			// Task记录表中新增一条记录
			taskBo = taskBom.newObject();
			taskBo.setAttributesValue(bo);
			taskBo.getAttribute("SerialNo").setNull(); // 流水号主键先置空，然后再由JBO产生
			taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);
			//taskBo.getAttribute("ProcessTaskNo").setValue(processObjects.get(0).getTaskID());
			taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
			taskBo.getAttribute("EndTime").setNull();
			taskBo.getAttribute("PhaseOpinion").setNull();
			taskBo.getAttribute("PhaseAction").setNull();
			taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
			taskBo.getAttribute("FlowState").setValue(BusinessProcessConst.FLOWSTATE_WITHDRAW);
			taskBom.saveObject(taskBo);
			
			// 获得Task表的流水号
			String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
			
			// 获得Object表的流水号
			String bizProcessObjectID = taskBo.getAttribute("RelativeObjectNO").toString();
			
			// 查询当前阶段编号
			query = taskBom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			String phaseNo = query.getSingleResult(false).getAttribute("PhaseNo").toString();
			// Object记录表中更新记录
			bom = factory.getManager(getBizProcessObjectClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo").setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", phaseNo);
			bo = query.getSingleResult(true);
			bo.setAttributeValue("PhaseType", taskBo.getAttribute("PhaseType").toString());
			bo.setAttributeValue("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
			bo.setAttributeValue("PhaseName", taskBo.getAttribute("PhaseName").toString());
			bo.setAttributeValue("ProcessTaskNo", taskBo.getAttribute("ProcessTaskNo").toString());
			bo.setAttributeValue("FlowState",BusinessProcessConst.FLOWSTATE_WITHDRAW);
			bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
			bom.saveObject(bo);
			
			// 如果是分支的初始点，则删除Obejct表中多余的记录。
			if (forkFlag == true){
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo<>:PhaseNo").setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
				List bos = query.getResultList(true);
				if (bos != null && bos.size() > 0) {
					for (int i = 0; i < bos.size(); i++) {
						bo = (BizObject)bos.get(i);
						bom.deleteObject(bo);
					}
				}
			}
			commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("任务收回的后处理操作出错", e);
			throw new Exception("任务收回的后处理操作出错", e);
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 贷审会成员主动撤回流程任务的辅助处理动作
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 流程任务编号
	 * @param userID 主动撤回人用户编号
	 * @throws Exception
	 */
	public void withdrawForVoteAssistant(String processDefID, String bizProcessTaskID, String userID) throws Exception{
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager taskBom,mTaskBom;
		//更新流程任务表
		taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		getTx().join(taskBom);
		BizObject taskBo = taskBom.createQuery("SerialNo=:SerialNo")
							.setParameter("SerialNo", bizProcessTaskID)
							.getSingleResult(true);
		String relativeUser = taskBo.getAttribute("RelativeUser").toString();
		relativeUser = relativeUser.replace("@"+userID+"@", "@");
		taskBo.setAttributeValue("RelativeUser", relativeUser);
		taskBom.saveObject(taskBo);
		
		//更新复合任务表
		mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
		getTx().join(mTaskBom);
		
        BizObject mTaskBo = mTaskBom.createQuery("RelativeTaskNo=:RelativeTaskNo and UserID=:UserID and VoteState=:VoteState")
        					.setParameter("RelativeTaskNo", bizProcessTaskID)
        					.setParameter("UserID", userID)
        					.setParameter("VoteState", "1").getSingleResult(true);
        if(mTaskBo != null){
        	mTaskBo.setAttributeValue("VoteState", BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
        	mTaskBom.saveObject(mTaskBo);
        }
        
        //新插入一条记录
        BizObject newBo =  mTaskBom.newObject();
        newBo.setAttributesValue(mTaskBo);
        newBo.getAttribute("SerialNo").setNull();
        newBo.getAttribute("BeginTime").setValue(StringFunction.getTodayNow());
        newBo.getAttribute("EndTime").setNull();
        newBo.getAttribute("VoteState").setValue("0");
        newBo.getAttribute("VoteOpinion").setNull();
        mTaskBom.saveObject(newBo);
	}
	
	/**
	 * 流程退回的预处理:获取退回阶段，退回到的人
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务流程任务编号
	 * @return
	 */
	public String preTaskReturn(String processDefID, String bizProcessTaskID) throws Exception {
		String returnMessage = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try {
			//获取退回阶段，退回到的人
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo")
			   .setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(false);
			if (bo == null) {
				logger.error("没有找到需要退回的任务");
			} else {
				returnMessage = bo.getAttribute("PhaseNo").toString() + "@"
						+ bo.getAttribute("UserID").toString().replace("@", "") + "@"
						+ bo.getAttribute("ProcessTaskNo").toString();
			}
		} catch (JBOException e){
			rollbackTx();
			logger.error("流程退回的预处理操作失败"+e.getMessage(), e);
			throw new Exception("流程退回的预处理操作失败"+e.getMessage(), e);
		}
		return returnMessage;
	}
	
	/**
	 * 流程退回的后处理动作
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务流程任务编号
	 * @param bizAssignedTaskID 指定下一阶段的流程任务编号
	 * @param processState 流程状态
	 * @param processObjects 流程引擎返回的流程对象列表
	 * @param userID 当前用户编号
	 * @return
	 */
	public String postTaskReturn(String processDefID, String bizProcessTaskID,
			String bizAssignedTaskID, String processState,
			List<ProcessObject> processObjects, String userID) {
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo,taskBo;
		try {
			if(processState==null||"".equals(processState)){
				processState = BusinessProcessConst.FLOWSTATE_RETURN;
			}
			// 查询出要退回到的任务
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			BizObject backBo = query.getSingleResult(false);
			
			// 获取流程任务对象编号，查询出最新的任务的TASK编号
			String bizProcessObjectID = backBo.getAttribute("RelativeObjectNo").toString();
			String backForkState = backBo.getAttribute("ForkState").toString();
			
			// 获取当前任务
			String q = "RelativeObjectNo =:RelativeObjectNo and userID = :UserID order by SerialNo desc";
			query = bom.createQuery(q).setParameter("RelativeObjectNo", bizProcessObjectID).setParameter("UserID",userID);
			bo = query.getSingleResult(true);
			String latestBizProcessTaskID = bo.getAttribute("SerialNo").toString();
	        String relativeSerialNo = bo.getAttribute("RelativeSerialNo").toString();
	        String forkState = bo.getAttribute("ForkState").toString();
	        String phaseNo = bo.getAttribute("PhaseNo").toString();
			
	        //主干退回主干或分支退回分支
			if ((isNull(backForkState) && isNull(forkState))
					|| (!isNull(backForkState) && !isNull(forkState))){
				// 更新最新TASK记录的状态为关闭 
				bo.setAttributeValue("EndTime",StringFunction.getTodayNow());
				bo.setAttributeValue("TaskState", BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
				bom.saveObject(bo);
	
				// TASK表中新增一条记录
				taskBo = bom.newObject();
				taskBo.setAttributesValue(backBo);
				taskBo.getAttribute("SerialNo").setNull(); // 流水号主键先置空，然后再由JBO产生
				taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);
				taskBo.getAttribute("RelativeSerialNo").setValue(latestBizProcessTaskID);
				taskBo.getAttribute("ProcessTaskNo").setValue(backBo.getAttribute("ProcessTaskNo").toString());
				taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
				taskBo.getAttribute("EndTime").setNull();
				taskBo.getAttribute("PhaseOpinion").setNull();
				taskBo.getAttribute("PhaseAction").setNull();
				taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
				taskBo.getAttribute("FlowState").setValue(processState);
				if(bizAssignedTaskID != null){
					taskBo.getAttribute("AssignedTaskNo").setValue(bizAssignedTaskID);
				}
				bom.saveObject(taskBo);
				String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
	
				// 更新OBJECT表记录
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", phaseNo);
				bo = query.getSingleResult(true);
				bo.setAttributeValue("PhaseType", taskBo.getAttribute("PhaseType").toString());
				bo.setAttributeValue("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
				bo.setAttributeValue("PhaseName", taskBo.getAttribute("PhaseName").toString());
				bo.setAttributeValue("ProcessTaskNo", backBo.getAttribute("ProcessTaskNo").toString());
				bo.setAttributeValue("FlowState",processState);
				bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
				bom.saveObject(bo);
				
		        //删除流程任务表多余记录
				BizObjectManager oldTaskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
				getTx().join(oldTaskBom);
				List deleteBos = oldTaskBom.createQuery("RelativeSerialNo=:RelativeSerialNo and TaskState = '0'")
						.setParameter("RelativeSerialNo", relativeSerialNo).getResultList(true);
				if (deleteBos != null) {
					for (int i = 0; i < deleteBos.size(); i++) {
						BizObject deleteBo = (BizObject) deleteBos.get(i);
						oldTaskBom.deleteObject(deleteBo);
					}
				}
			}
	        //分支退回主干
			if(!isNull(forkState) && isNull(backForkState)){
				//获取当前所有分支
				query = bom.createQuery("TaskState = '0' and UserID =:UserID").setParameter("UserID", userID);
				List<BizObject> taskBos = query.getResultList(true);
				// 更新所有最新TASK记录的状态为关闭 
				if(taskBos!=null){
					for(int i=0;i<taskBos.size();i++){
						taskBo = taskBos.get(i);
						taskBo.setAttributeValue("EndTime",StringFunction.getTodayNow());
						taskBo.setAttributeValue("TaskState", BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
						bom.saveObject(taskBo);
					}
				}
				// TASK表中新增一条记录
				taskBo = bom.newObject();
				taskBo.setAttributesValue(backBo);
				taskBo.getAttribute("SerialNo").setNull(); // 流水号主键先置空，然后再由JBO产生
				taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);
				taskBo.getAttribute("RelativeSerialNo").setValue(latestBizProcessTaskID);
				taskBo.getAttribute("ProcessTaskNo").setValue(backBo.getAttribute("ProcessTaskNo").toString());
				taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
				taskBo.getAttribute("EndTime").setNull();
				taskBo.getAttribute("PhaseOpinion").setNull();
				taskBo.getAttribute("PhaseAction").setNull();
				taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
				taskBo.getAttribute("FlowState").setValue(processState);
				if(bizAssignedTaskID != null){
					taskBo.getAttribute("AssignedTaskNo").setValue(bizAssignedTaskID);
				}
				bom.saveObject(taskBo);
				String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
	
				// 删除OBJECT表其他分支记录
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo<>:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", phaseNo);
				List<BizObject> bos = query.getResultList(true);
				if (bos != null) {
					for (int i = 0; i < bos.size(); i++) {
						bo = bos.get(i);
						bom.deleteObject(bo);
					}
				}
				
				// 更新OBJECT表当前记录
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", phaseNo);
				bo = query.getSingleResult(true);
				bo.setAttributeValue("PhaseType", taskBo.getAttribute("PhaseType").toString());
				bo.setAttributeValue("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
				bo.setAttributeValue("PhaseName", taskBo.getAttribute("PhaseName").toString());
				bo.setAttributeValue("ProcessTaskNo", backBo.getAttribute("ProcessTaskNo").toString());
				bo.setAttributeValue("FlowState",processState);
				bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
				bom.saveObject(bo);
				
		        //删除流程任务表多余记录
				BizObjectManager oldTaskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
				getTx().join(oldTaskBom);
				List deleteBos = oldTaskBom.createQuery("RelativeSerialNo=:RelativeSerialNo and TaskState = '0'")
						.setParameter("RelativeSerialNo", relativeSerialNo).getResultList(true);
				if (deleteBos != null) {
					for (int i = 0; i < deleteBos.size(); i++) {
						BizObject deleteBo = (BizObject) deleteBos.get(i);
						oldTaskBom.deleteObject(deleteBo);
					}
				}
			}
			commitTx();
		} catch (JBOException e) {
			rollbackTx();
			logger.debug("任务收回的后处理操作出错", e);
			return FAILURE_MESSAGE;
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 任务退回前的判断：有父任务且无兄弟任务
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务流程任务编号
	 * @return SUCCESS/FAILURE/当前流程任务不存在,请核对/已提交的任务不能退回/无父任务不能退回/本阶段还有其他承办人,不能退回
	 */
	public String canTakeback(String processDefID, String bizProcessTaskID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try{
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			query = bom.createQuery("SerialNo=:SerialNo")
					   .setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(false);
			if(bo == null){
				return "当前流程任务不存在,请核对";
			} else {
				//判断当前任务是否已提交,已提交则不能退回
				if(!bo.getAttribute("EndTime").isNull()){
					return "已提交的任务不能退回";
				}
				//判断当前任务是否有父任务,有父任务不能退回
				String relativeSerialNo = bo.getAttribute("RelativeSerialNo").getString();
				if(relativeSerialNo == null || "".equals(relativeSerialNo)){
					return "无父任务不能退回";
				}
				//判断本阶段是否还有其他承办人,有则不能退回
				if(getChildTaskCount(processDefID, relativeSerialNo) > 1){
					return "本阶段还有其他承办人,不能退回";
				}
			}
		} catch (JBOException e){
			logger.debug("任务退回前的判断出错", e);
			return FAILURE_MESSAGE;
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 退回任务,返回退回提交动作字符串,供流程引擎调用
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务流程任务编号
	 * @return
	 */
	public String doTakeback(String processDefID, String bizProcessTaskID){
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		String takebackProp = "";
		try {
			 //根据当前任务流水号取得当前任务上一步的Flow_Task流水号
			 bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			 getTx().join(bom);
			 query = bom.createQuery("SerialNo=:SerialNo")
			 			.setParameter("SerialNo", bizProcessTaskID);
			 bo = query.getSingleResult(true);
			 String relativeObjectNo = bo.getAttribute("RelativeObjectNo").toString();
			 String curPhaseNo = bo.getAttribute("phaseNo").toString();
			 String forkState = bo.getAttribute("ForkState").toString();
			 if(!isNull(forkState)){
				 forkState = forkState.substring(1,3);
			 }
			 
			 //查询上一步任务的TaskState状态，如果是正常提交的1，则为需要退回到的任务。如果为关闭状态的99，则继续往前追溯。
			 BizObject lastTaskBo = null;
			 if(isNull(forkState)){
				 query = bom.createQuery("RelativeObjectNo=:RelativeObjectNo order by serialNo desc")
				 							.setParameter("RelativeObjectNo", relativeObjectNo);
			 }else{
				 query = bom.createQuery("RelativeObjectNo=:RelativeObjectNo and (ForkState like :ForkState or ForkState is null) order by serialNo desc")
											.setParameter("RelativeObjectNo", relativeObjectNo)
											.setParameter("ForkState", "%"+forkState);
			 }
			 List<BizObject> boList = query.getResultList(false);
			 for(int i = 0;i<boList.size()-1;i++){
				 if(curPhaseNo.equals(boList.get(i).getAttribute("phaseNo").toString())){
					 if("1".equals(boList.get(i+1).getAttribute("taskState").toString())){
						 lastTaskBo = boList.get(i+1);
						 String lastForkState = lastTaskBo.getAttribute("ForkState").toString();
						 if(isNull(forkState)&& !isNull(lastForkState)){
							 String msg = "前一阶段是分支，不允许退回!";
							 return msg;
						 }
						 break;
					 }else{
						 continue;
					 }
				 }else{
					 if(i==boList.size()-2){
						 String msg = "已经退到流程起点，不允许退回!";
						 return msg;
					 }
				 }
			 }

			 //构造返回字符串：流程引擎任务号@退回阶段@退回人@退回流程任务流水号
			 String userID = lastTaskBo.getAttribute("UserID").getString();//退回人
			 if(userID!=null){userID = userID.replace("@", "");}
			 if ("".equals(userID) || "null".equalsIgnoreCase(userID) || userID == null) {
				 userID = lastTaskBo.getAttribute("GroupID").getString();//退回组
				 userID = userID.replace("@", "");
			 }
			 takebackProp = bo.getAttribute("ProcessTaskNo").getString() + "@" + //退回主体任务编号
	 		 				lastTaskBo.getAttribute("PhaseNo").getString() + "@" + //退回阶段
	 		 				userID + "@" + //退回人
	 		 				lastTaskBo.getAttribute("SerialNo").getString()+ "@" + //前一步流程任务流水号
			 				lastTaskBo.getAttribute("ProcessTaskNo").toString(); //前一步流程任务编号
		} catch (JBOException e){
			rollbackTx();
			logger.debug("任务退回出错", e);
		}
		
		return takebackProp;
	}
	

	/**
	 * 退回的后处理操作
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务流程任务编号
	 * @param oldBizProcessTaskID 退回所在业务流程任务编号
	 * @param processState 流程状态
	 * @param processObjects 流程引擎返回的流程对象列表
	 * @param userID 当前用户编号
	 * @return
	 */
	public String postTakeback(String processDefID, String bizProcessTaskID, String oldBizProcessTaskID, String processState, List<ProcessObject> processObjects, String userID) throws Exception {
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom,mTaskBom;
		BizObjectQuery query;
		BizObject bo;
		try {
			
			if(isNull(processState)){
				processState = BusinessProcessConst.FLOWSTATE_RETURN;
			}
			
			if(processObjects == null){
				return FAILURE_MESSAGE;
			}
			
			// 查询出当前所在TASK的参数
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			BizObject curTaskBo = query.getSingleResult(true);
			String curForkState = curTaskBo.getAttribute("ForkState").toString();
			String curPhaseNo = curTaskBo.getAttribute("PhaseNo").toString();
			
			// 查询出退回所在TASK的参数
			query = bom.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", oldBizProcessTaskID);
			BizObject oldTaskBo = query.getSingleResult(true);
			
			// 获得Object表的流水号
			String bizProcessObjectID = oldTaskBo.getAttribute("RelativeObjectNO").toString();
			// 获得当前记录的relativeSerialNo
			String relativeSerialNo = oldTaskBo.getAttribute("SerialNo").toString();
			String lastForkState = oldTaskBo.getAttribute("ForkState").toString();
			
			//分支退回到主干
			if (!isNull(curForkState) && isNull(lastForkState)) {
				//删除流程任务表多余的记录
				taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
				getTx().join(taskBom);
				query = taskBom.createQuery("TaskState='0' and RelativeObjectNo=:RObejctNo and userID <> :UserID")
						.setParameter("RObejctNo",bizProcessObjectID)
						.setParameter("UserID", userID);
				List bos = query.getResultList(true);
				if (bos.size() != 0) {
					for(int i = 0 ; i< bos.size() ; i++ ){
						bo = (BizObject) bos.get(i);
						taskBom.deleteObject(bo);
					}
				}
				
				// 更新Task的任务状态为关闭
				curTaskBo.getAttribute("EndTime").setValue(StringFunction.getTodayNow());
				curTaskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
				bom.saveObject(curTaskBo);
				
				// Task记录表中新增一条记录
				getTx().join(bom);
				BizObject taskBo = bom.newObject();
				taskBo.setAttributesValue(oldTaskBo);
				taskBo.getAttribute("SerialNo").setNull(); // 流水号主键先置空，然后再由JBO产生
				taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);
				taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);
				taskBo.getAttribute("ProcessTaskNo").setValue(oldTaskBo.getAttribute("ProcessTaskNo").toString());
				taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
				taskBo.getAttribute("EndTime").setNull();
				taskBo.getAttribute("PhaseOpinion").setNull();
				taskBo.getAttribute("PhaseAction").setNull();
				if("1".equals(processObjects.get(0).getIsPool())){
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);
				}else{
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
				}
				taskBo.getAttribute("FlowState").setValue(processState);
				bom.saveObject(taskBo);
				String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
				
				// Object记录表中删除记录
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo<>:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", curPhaseNo);
				List<BizObject> bolist = query.getResultList(true);
				if (bolist.size() != 0) {
					for(int i = 0 ; i< bolist.size() ; i++ ){
						bo = (BizObject) bolist.get(i);
						bom.deleteObject(bo);
					}
				}
				
				// Object记录表中更新记录
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", curPhaseNo);
				bo = query.getSingleResult(true);
				bo.setAttributeValue("PhaseType", taskBo.getAttribute("PhaseType").toString());
				bo.setAttributeValue("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
				bo.setAttributeValue("PhaseName", taskBo.getAttribute("PhaseName").toString());
				bo.setAttributeValue("ProcessTaskNo", oldTaskBo.getAttribute("ProcessTaskNo").toString());
				bo.setAttributeValue("FlowState",processState);
				bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
				bom.saveObject(bo);
				
				//把原来的MultiTask里的数据关联到新生成的Task上
				if(bo.getAttribute("PhaseNo").toString().startsWith("CounterSign")){
					mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
					query = mTaskBom.createQuery("RelativeTaskNo=:RelativeTaskNo")
							.setParameter("RelativeTaskNo", oldBizProcessTaskID);
					List<BizObject> boList = query.getResultList(true);
					for (int i = 0; i < boList.size(); i++) {
						BizObject mTaskBo = boList.get(i);
						mTaskBo.setAttributeValue("RelativeTaskNo", taskSerialNo);
						mTaskBom.saveObject(mTaskBo);
					}
				}
			}
			//主干退回到主干或者分支退回到分支
			else{
			
				// 更新Task的任务状态为关闭
				curTaskBo.getAttribute("EndTime").setValue(StringFunction.getTodayNow());
				curTaskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_CLOSE);
				bom.saveObject(curTaskBo);

				// Task记录表中新增一条记录
				getTx().join(bom);
				BizObject taskBo = bom.newObject();
				taskBo.setAttributesValue(oldTaskBo);
				taskBo.getAttribute("SerialNo").setNull(); // 流水号主键先置空，然后再由JBO产生
				taskBo.getAttribute("RelativeObjectNo").setValue(bizProcessObjectID);
				taskBo.getAttribute("RelativeSerialNo").setValue(bizProcessTaskID);
				taskBo.getAttribute("ProcessTaskNo").setValue(oldTaskBo.getAttribute("ProcessTaskNo").toString());
				taskBo.getAttribute("BegInTime").setValue(StringFunction.getTodayNow());
				taskBo.getAttribute("EndTime").setNull();
				taskBo.getAttribute("PhaseOpinion").setNull();
				taskBo.getAttribute("PhaseAction").setNull();
				if("1".equals(processObjects.get(0).getIsPool())){
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_TASKPOOL);
				}else{
					taskBo.getAttribute("TaskState").setValue(BusinessProcessConst.BUSINESS_PROCESS_UNFINISH);
				}
				taskBo.getAttribute("FlowState").setValue(processState);
				bom.saveObject(taskBo);
				String taskSerialNo = taskBo.getAttribute("SerialNo").toString();
				
				// Object记录表中更新记录
				bom = factory.getManager(getBizProcessObjectClaz(processDefID));
				getTx().join(bom);
				query = bom.createQuery("ObjectNo=:SerialNo and PhaseNo=:PhaseNo")
										.setParameter("SerialNo", bizProcessObjectID)
										.setParameter("PhaseNo", curPhaseNo);
				bo = query.getSingleResult(true);
				bo.setAttributeValue("PhaseType", taskBo.getAttribute("PhaseType").toString());
				bo.setAttributeValue("PhaseNo", taskBo.getAttribute("PhaseNo").toString());
				bo.setAttributeValue("PhaseName", taskBo.getAttribute("PhaseName").toString());
				bo.setAttributeValue("ProcessTaskNo", oldTaskBo.getAttribute("ProcessTaskNo").toString());
				bo.setAttributeValue("FlowState",processState);
				bo.getAttribute("RelativeTaskNo").setValue(taskSerialNo);
				bom.saveObject(bo);
				
				//把原来的MultiTask里的数据关联到新生成的Task上
				if(bo.getAttribute("PhaseNo").toString().startsWith("CounterSign")){
					mTaskBom = factory.getManager(getBizProcessMultiTaskClaz(processDefID));
					query = mTaskBom.createQuery("RelativeTaskNo=:RelativeTaskNo")
							.setParameter("RelativeTaskNo", oldBizProcessTaskID);
					List<BizObject> boList = query.getResultList(true);
					for (int i = 0; i < boList.size(); i++) {
						BizObject mTaskBo = boList.get(i);
						mTaskBo.setAttributeValue("RelativeTaskNo", taskSerialNo);
						mTaskBom.saveObject(mTaskBo);
					}
				}
				
				//删除流程任务表多余的记录
				taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
				getTx().join(taskBom);
				query = taskBom.createQuery("relativeSerialNo=:RelativeSerialNo and userID <> :UserID and PhaseNo=:PhaseNo")
						.setParameter("RelativeSerialNo", relativeSerialNo)
						.setParameter("UserID", userID)
						.setParameter("PhaseNo", curPhaseNo);
				List bos = query.getResultList(true);
				if (bos.size() != 0) {
					for(int i = 0 ; i< bos.size() ; i++ ){
						bo = (BizObject) bos.get(i);
						taskBom.deleteObject(bo);
					}
				}
			}
			commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("退回的后处理操作出错" + e.getMessage(), e);
			throw new Exception("退回的后处理操作出错" + e.getMessage(), e);
		}
		return SUCCESS_MESSAGE;
	}
	
	/**
	 * 获取流程历史处理步骤.(phaseNo不重复,不包括任务池阶段)
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessObjectID:业务流程对象编号
	 * <li>bizProcessTaskID:业务流程任务编号
	 * @return List<HistoryTaskObject> 
	 * @throws JBOException 
	 */
	public List<HistoryTaskObject> getProcessHistory(String processDefID, String bizProcessObjectID, String bizProcessTaskID) throws JBOException{
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObjectQuery query;
		BizObject bo;
		List<HistoryTaskObject> historyTaskObjects = new ArrayList<HistoryTaskObject>();
		taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		getTx().join(taskBom);
		if(bizProcessTaskID == null ||"null".equalsIgnoreCase(bizProcessTaskID)){
			query = taskBom.createQuery("O.RelativeObjectNo=:RelativeObjectNo and TaskState = '0' Order by O.SerialNo").setParameter("RelativeObjectNo", bizProcessObjectID);
		}else{
			query = taskBom.createQuery("O.SerialNo=:SerialNo").setParameter("SerialNo", bizProcessTaskID);
		}
		BizObject taskBo = query.getSingleResult(false);
		String taskNo = taskBo.getAttribute("ProcessTaskNo").toString();
		String forkState = taskBo.getAttribute("ForkState").toString();
		BusinessProcessAction BpAction = new BusinessProcessAction();
		BpAction.setProcessTaskID(taskNo);
		BpAction.setProcessDefID(processDefID);
		BpAction.setProperty("ISSPTASK");

		bom = factory.getManager(getBizProcessTaskClaz(processDefID));
		getTx().join(bom);
		if(isNull(forkState)){
			query = bom.createQuery("O.RelativeObjectNo=:RelativeObjectNo and TaskState <> '99' and ForkState is null Order by O.SerialNo")
										.setParameter("RelativeObjectNo", bizProcessObjectID);
		}else{
			query = bom.createQuery("O.RelativeObjectNo=:RelativeObjectNo and TaskState <> '99' and (ForkState like :ForkState or ForkState is null)Order by O.SerialNo")
										.setParameter("RelativeObjectNo", bizProcessObjectID)
										.setParameter("ForkState", "%"+forkState.substring(1,3));
		}
		List<BizObject> bos = query.getResultList(false);
		String curPhaseNo = bos.get(bos.size()-1).getAttribute("PhaseNo").toString();
		String allPhaseNo = "";
		for (int i = 0; i < bos.size(); i++) {
			bo = bos.get(i);
			BpAction.setPhaseNo(bo.getAttribute("PhaseNo").toString());
			String flag = BpAction.getPhaseProperty();
			if(allPhaseNo.contains(bo.getAttribute("PhaseNo").toString()) || "1".equals(flag)){
				continue;
			}else{
				if (i > 0 && bo.getAttribute("PhaseNo").toString().equals(curPhaseNo)){
					break;
				}else{
					String userID = bo.getAttribute("UserID").toString();
					if (("".equals(userID) || userID == null || "null".equalsIgnoreCase(userID)) && bo.getAttribute("GroupID")!=null) {
						historyTaskObjects.clear();
					} else {
						HistoryTaskObject hto = new HistoryTaskObject();
						hto.setBizProcessTaskID(bo.getAttribute("SerialNo").toString());
						hto.setPhaseAction(bo.getAttribute("PhaseNo").toString());
						hto.setUseID(bo.getAttribute("UserID").toString().replace("@", ""));
						historyTaskObjects.add(hto);
						allPhaseNo = allPhaseNo + bo.getAttribute("PhaseNo").toString() + ",";
					}
				}
			}
		}
		return historyTaskObjects;
	}
	
	/**
	 * 获取流程历史处理步骤.(仅客户经理和上一步)
	 * <li>processDefID:流程定义编号
	 * <li>bizProcessObjectID:业务流程对象编号
	 * @return List<HistoryTaskObject> 
	 * @throws JBOException 
	 */
	public List<HistoryTaskObject> getPartProcessHistory(String processDefID, String bizProcessObjectID) throws JBOException{
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom,taskBom;
		BizObjectQuery query;
		BizObject bo;
		List<HistoryTaskObject> historyTaskObjects = new ArrayList<HistoryTaskObject>();
		//查询出发起阶段的任务信息
		taskBom = factory.getManager(getBizProcessTaskClaz(processDefID));
		getTx().join(taskBom);
		query = taskBom.createQuery("O.RelativeObjectNo=:RelativeObjectNo Order by O.SerialNo asc").setParameter("RelativeObjectNo", bizProcessObjectID);
		bo = query.getSingleResult(false);
		
		String phaseNo = bo.getAttribute("PhaseNo").toString();
			
		HistoryTaskObject hto = new HistoryTaskObject();
		hto.setBizProcessTaskID(bo.getAttribute("SerialNo").toString());
		hto.setPhaseAction(bo.getAttribute("PhaseNo").toString());
		hto.setUseID(bo.getAttribute("UserID").toString().replace("@", ""));
		historyTaskObjects.add(hto);
		
		//查询出上一步的任务信息
		bom = factory.getManager(getBizProcessObjectClaz(processDefID));
		getTx().join(bom);
		query = bom.createQuery("ObjectNo=:SerialNo").setParameter("SerialNo", bizProcessObjectID);
		bo = query.getSingleResult(false);
		String taskSerialNo = bo.getAttribute("RelativeTaskNo").toString();
		
		query = taskBom.createQuery("O.SerialNo=:SerialNo").setParameter("SerialNo", taskSerialNo);
		bo = query.getSingleResult(false);
		String relativeSerialNo = bo.getAttribute("RelativeSerialNo").toString();
		
		query = taskBom.createQuery("O.SerialNo=:SerialNo").setParameter("SerialNo", relativeSerialNo);
		bo = query.getSingleResult(false);
		
		if(!phaseNo.equals(bo.getAttribute("PhaseNo").toString())){
			hto = new HistoryTaskObject();
			hto.setBizProcessTaskID(bo.getAttribute("SerialNo").toString());
			hto.setPhaseAction(bo.getAttribute("PhaseNo").toString());
			hto.setUseID(bo.getAttribute("UserID").toString().replace("@", ""));
			historyTaskObjects.add(hto);
		}
		return historyTaskObjects;
	}
	
	/**
	 * 取子任务个数
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 当前任务编号
	 * @return
	 */
	public int getChildTaskCount(String processDefID, String bizProcessTaskID) throws JBOException {
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		int count = 0;
		bom = factory.getManager(getBizProcessTaskClaz(processDefID));
		query = bom.createQuery("RelativeSerialNo=:RelativeSerialNo")
				   .setParameter("RelativeSerialNo", bizProcessTaskID);
		List results = query.getResultList(false);
		if(results != null){
			count = results.size();
		}
		return count;
	}
	
	/**
	 * 转办辅助操作
	 * @param processDefID 流程定义编号
	 * @param bizProcessTaskID 业务流程任务编号
	 * @param userID 需要调整到的用户
	 * @return 成功返回流程任务相关信息，失败返回 ""
	 */
	public String changeUserAssistant(String processDefID, String bizProcessTaskID, String userID) throws Exception {
		String returnMessage = "";
		String oldUserID = "";
		String relativeUser = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bom;
		BizObjectQuery query;
		BizObject bo;
		try {
			//更改转办用户
			bom = factory.getManager(getBizProcessTaskClaz(processDefID));
			getTx().join(bom);
			query = bom.createQuery("SerialNo =:SerialNo").setParameter("SerialNo", bizProcessTaskID);
			bo = query.getSingleResult(true);
			if (bo != null) {
				oldUserID = bo.getAttribute("UserID").toString();
				relativeUser = bo.getAttribute("RelativeUser").toString();
			}
			PSUserObject curUser = PSUserObject.getUser(oldUserID.replace("@", "")); //用户对象
			if (relativeUser == null || "".equals(relativeUser)) {
				bo.setAttributeValue("RelativeUser", oldUserID);
				bo.setAttributeValue("UserID", curUser.getUserID());
				bo.setAttributeValue("UserName", curUser.getUserName());
				bo.setAttributeValue("OrgID", curUser.getOrgID());
				bo.setAttributeValue("OrgName", curUser.getOrgName());
			} else {
				bo.setAttributeValue("UserID", curUser.getUserID());
				bo.setAttributeValue("UserName", curUser.getUserName());
				bo.setAttributeValue("OrgID", curUser.getOrgID());
				bo.setAttributeValue("OrgName", curUser.getOrgName());
			}
			bom.saveObject(bo);
			commitTx();
		} catch (JBOException e){
			rollbackTx();
			logger.debug("流程转办辅助操作失败"+e.getMessage(), e);
			throw new Exception("流程转办辅助操作失败"+e.getMessage(), e);
		}
		return returnMessage;
	}
	
	private String initRelativeData(RelativeBusinessObject businessObject, String relativeData) throws Exception {
		StringBuffer newRelativeData = new StringBuffer();
		String objectNo = "";
		String applyType = "";
		if(businessObject != null){
			objectNo = (businessObject.getObjectNo() == null) ? "" : businessObject.getObjectNo();
			applyType = (businessObject.getApplyType() == null) ? "" : businessObject.getApplyType();
		}
		
		String bizObject = "\"S_BizObject\":{\"ObjectNo\":\"" + objectNo + "\",\"ApplyType\":\"" + applyType + "\"}";
		
		//修正relativeData为JSON格式:{},但并不严格检查
		if(relativeData == null || "".equals(relativeData)){//relativeData为空
			newRelativeData.append("{" + bizObject + "}");
		} else if(relativeData.startsWith("{") && relativeData.endsWith("}")){//relativeData以"{"开头且以"}"结尾
			newRelativeData.append(relativeData).insert(1, bizObject+",");
		} else {
			newRelativeData.append("{").append(bizObject).append(",").append(relativeData).append("}");
			logger.error(this.getClass().getName()+".initRelativeData: RelativeData format error." + relativeData);
			throw new Exception("RelativeData format error." + relativeData);
		}
		
		return newRelativeData.toString();
	}
	
	private Boolean isNull(String str) {
		if (str == null || "null".equalsIgnoreCase(str) || "".equals(str.trim())) {
			return true;
		} else {
			return false;
		}
	}
	

	
}
