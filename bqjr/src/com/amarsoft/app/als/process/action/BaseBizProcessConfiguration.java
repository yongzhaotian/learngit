package com.amarsoft.app.als.process.action;

/**
 * 本类实现基本的业务流程配置属性获取服务.默认情况下与流程相关的业务信息配置于代码表中,具体位置为:<BR>
 * CodeNo:ProcessConfiguration,ItemNo:特定的流程定义编号
 * @author zszhang
 *
 */
public class BaseBizProcessConfiguration implements BizProcessConfiguration {
	private static final String PROCESSOBJECT_DEFAULT_CLASS = "jbo.app.FLOW_OBJECT"; //业务流程对象默认JBO
	private static final String PROCESSTASK_DEFAULT_CLASS = "jbo.app.FLOW_TASK"; //业务流程任务默认JBO
	private static final String PROCESSMULTITASK_DEFAULT_CLASS = "jbo.app.FLOW_MULTITASK"; //业务流程任务默认JBO
	private static final String PROCESSOPINION_DEFAULT_CLASS = "jbo.app.FLOW_OPINION"; //业务流程意见默认JBO
	
	/**
	 * 根据流程定义编号取得业务流程对象JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessObjectClaz(String processDefID){
		return PROCESSOBJECT_DEFAULT_CLASS;
	}
	
	/**
	 * 根据流程定义编号取得业务流程任务JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessTaskClaz(String processDefID){
		return PROCESSTASK_DEFAULT_CLASS;
	}
	
	/**
	 * 根据流程定义编号取得业务流程复合任务JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessMultiTaskClaz(String processDefID){
		return PROCESSMULTITASK_DEFAULT_CLASS;
	}
	
	/**
	 * 根据流程定义编号取得业务流程意见JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessOpinionClaz(String processDefID){
		return PROCESSOPINION_DEFAULT_CLASS;
	}
	
}
