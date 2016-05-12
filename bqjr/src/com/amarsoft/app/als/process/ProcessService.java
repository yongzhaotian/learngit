package com.amarsoft.app.als.process;

import java.awt.image.BufferedImage;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.process.data.ProcessObject;
import com.amarsoft.app.als.process.data.TaskListCatalog;

/**
 * 流程服务的统一调度接口，流程引擎提供的标准服务在该接口中定义
 * @author zszhang
 *
 */
public interface ProcessService extends Context, ExtendProcessService {
	
	/**
	 * 启动流程实例
	 * @param processDefID 流程定义编号
	 * @param userID 流程发起人/ProcessInst Owner/The first activity participant
	 * @param objects 流程相关数据(流程运转过程中需要的业务数据)
	 * @return List<ProcessObject> 
	 */
	public List<ProcessObject> startProcessInst(String processDefID, String userID, String objects) throws Exception ;
	
	/**
	 * 删除流程实例
	 * @param processInstID 流程实例编号
	 * @return processInstID or Success/Failure or other String
	 */
	public String deleteProcessInst(String processInstID) throws Exception ;
	
	/**
	 * 取得流程任务提交时的动作列表,不包括退回上一阶段\收回\退回前一处理人
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @param userID 用户编号
	 * @return Map<actionName:String,action:String>
	 */
	public Map<String,String> getTaskActions(String processDefID, String taskID, String userID) throws Exception ;
	
	/**
	 * 取得流程任务提交时的分支动作列表。
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @param  ActivityNo 活动编号
	 * @return Map<actionName:String,action:String>
	 */
	public Map<String,String> getForkActions(String processDefID, String taskID, String ActivityNo) throws Exception ;

	
	/**
	 * 取得流程下一活动可选的参与者列表
	 * @param processDefID 流程定义编号
	 * @param nextAction 下一活动
	 * @param taskID 任务编号
	 * @param curUserID 当前用户编号
	 * @return
	 */
	public String[] getNextOptionalUsers(String processDefID, String nextAction, String taskID, String curUserID) throws Exception ;

	/**
	 * 取得流程当前活动可选的参与者列表
	 * @param processDefID 流程定义编号
	 * @param nextAction 当前活动编号
	 * @param taskID 任务编号
	 * @param curUserID 当前用户编号
	 * @return
	 */
	public String[] getCurOptionalUsers(String processDefID, String nextAction, String taskID, String curUserID) throws Exception ;

	/**
	 * 取得任务编号
	 * @param processInstID 流程实例编号
	 * @param processDefID 流程定义编号
	 * @param activityID 活动定义编号
	 * @param userID 任务参与者
	 * @return
	 */
	public String getUnfinishedTaskNo(String processInstID, String processDefID, String activityID, String userID) throws Exception ;
		
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
	public List<ProcessObject> commitProcessInst(String processDefID, String processInstID, String taskID, String nextAction, String nextOpinion, String objects) throws Exception ;
	
	/**
	 * 提交贷审会成员意见
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @param taskID 任务编号
	 * @param userID 用户编号
	 * @param voteOpinion 投票意见
	 * @param nextOpinion 提交意见 
	 * @param objects 流程相关数据(流程运转过程中需要的业务数据)
	 * @return ProcessObject
	 * @throws Exception 
	 */
	public ProcessObject commitVote(String processDefID, String processInstID, String taskID, String userID, String voteOpinion ,String nextOpinion, String objects) throws Exception;
	
	/**
	 * 取得下一活动名称
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @param taskID 当前任务编号
	 * @param nextAction 提交动作
	 * @param nextOpinion 提交意见
	 * @return
	 */
	public String getNextActivityName(String processDefID, String processInstID, String taskID, String nextAction, String nextOpinion) throws Exception ;

	/**
	 * 取得下一活动名称
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @param taskID 当前任务编号
	 * @param nextAction 提交动作
	 * @return
	 */
	public String getNextState(String processDefID, String processInstID, String taskID, String nextAction) throws Exception ;
	
	/**
	 * 取得用户任务列表的类别,用于审批树图展示
	 * @param userID 用户编号
	 * @param processDefID 流程定义编号
	 * @return List<TaskListCatalog>
	 */
	public List<TaskListCatalog> getUserTaskListCatalog(String userID, String processDefID);
	
	/**
	 * 取得用户参与流程实例列表
	 * @param processDefID 流程定义编号
	 * @param activityID 活动定义编号
	 * @param milestone 里程碑（阶段类型）
	 * @param userID 用户编号
	 * @return 流程实例数组
	 */
	public String[] getUserProcessInstList(String processDefID, String activityID, String milestone, String userID);
	
	/**
	 * 收回流程
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
	public List<ProcessObject> withdrawProcessInst(String processDefID, String processInstID, String currentTaskID, String arriveTaskID,
										String nextAction, String nextOpinion, String objects, String userID) throws Exception;
	
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
										String nextAction, String nextOpinion, String objects, String userID) throws Exception;

	/**
	 * 取得流程定义中某活动的属性
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号,可用于区分不同的流程发布版本
	 * @param activityID 活动定义编号
	 * @param property 属性编号
	 * @return String 属性值
	 */
	public String getActivityProperty(String processDefID, String taskID, String activityID, String property);
	
	/**
	 * 获取流程图
	 * @param processDefID 流程定义编号
	 * @param taskID 流程任务编号
	 * @return BufferedImage
	 * @throws Exception
	 */
	public BufferedImage getFlowGraph(String processDefID, String taskID) throws Exception;
	
	/**
	 * 增加贷审会成员
	 * @param processDefID 流程定义编号
	 * @param taskID 流程任务编号
	 * @param users 欲增加的成员列表 user1,user2,user3
	 * @return
	 * @throws Exception 
	 */
	public String addVote(String processDefID, String taskID, String users) throws Exception;
	
	/**
	 * 移除贷审会成员
	 * @param processDefID 流程定义编号
	 * @param taskID 流程任务编号
	 * @param users 欲移除的成员列表 user1,user2,user3
	 * @return
	 * @throws Exception 
	 */
	public String removeVote(String processDefID, String taskID, String users) throws Exception;
	
	/**
	 * 取得流程指定编号任务参数
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @return String 查询结果
	 */
	public String getTask(String processDefID,String taskID);
	
	
	/**
	 * 从任务池中获取任务
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @param userID 用户编号
	 * @return
	 * @throws Exception
	 */
	public String takeTaskFromPool(String processDefID, String taskID, String userID) throws Exception;
	
	/**
	 * 设置流程对象
	 * @param taskID 流程任务编号
	 * @param ObjectName 对象编号，eg:UserInfo.UserID
	 * @param ObjectValue 对象值
	 * @return String
	 * @throws Exception
	 */
	public String setProcessObject(String taskID, String ObjectName, String ObjectValue) throws Exception;
	
	/**
	 * 取得流程下一阶段角色
	 * @param processDefID 流程定义编号
	 * @param nextAction 下一活动
	 * @param taskID 任务编号
	 * @param curUserID 当前用户编号
	 * @return
	 */
	public String getNextOptionalRole(String processDefID, String nextAction, String taskID) throws Exception;
	
	/**
	 * 取得流程节点的上一个节点
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @param activityID 指定节点编号，为空为当前任务节点
	 * @return String 
	 */
	public String getPreActivity(String processDefID, String taskID, String activityID) throws Exception;
	
	/**
	 * 根据流程定义取得活动坐标，用于生成流程图
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @return String[] 坐标值数组
	 * @throws Exception
	 */
	public String[] getCoordinatesByDef(String processDefID, String taskID) throws Exception;
	
	/**
	 * 获取流程图
	 * @param processDefID 流程定义编号
	 * @param taskID 任务编号
	 * @return String
	 * @throws Exception
	 */
	public String getFlowImage(String processDefID, String taskID) throws Exception;
	
	/**
	 * 重置流程任务：将当前流程任务同步到指定任务状态
	 * @param processDefID 流程定义编号
	 * @param taskID 流程任务编号
	 * @return
	 * @throws Exception
	 */
	public String restoreTask(String processDefID, String taskID) throws Exception;
	
	/**
	 * 流程结束后恢复到结束前的阶段
	 * @param processDefID 流程定义编号
	 * @param processInstID 流程实例编号
	 * @return
	 * @throws Exception
	 */
	public String restoreInstance(String processDefID, String processInstID) throws Exception;

}
