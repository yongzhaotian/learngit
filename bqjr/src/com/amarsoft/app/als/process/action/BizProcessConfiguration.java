package com.amarsoft.app.als.process.action;

/**
 * 与业务相关的流程配置接口.<br>
 * <ul>主要包括以下配置属性:
 * <li>业务流程对象JBO
 * <li>业务流程任务JBO
 * <li>业务流程意见JBO
 * <li>业务流程复合任务JBO
 * <li>该流程对应申请类型(可多个)
 * <li>该流程对应审批类型(可多个)
 * @author zshznag
 *
 */
public interface BizProcessConfiguration {

	/**
	 * 根据流程定义编号取得业务流程对象JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessObjectClaz(String processDefID);
	
	/**
	 * 根据流程定义编号取得业务流程任务JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessTaskClaz(String processDefID);
	
	/**
	 * 根据流程定义编号取得业务流程复合任务JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessMultiTaskClaz(String processDefID);
	
	/**
	 * 根据流程定义编号取得业务流程意见JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessOpinionClaz(String processDefID);
	
}
