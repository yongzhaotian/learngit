package com.amarsoft.app.als.rule;

import java.util.List;

import com.amarsoft.app.als.rule.data.RuleAttribute;
import com.amarsoft.app.als.rule.data.RuleModel;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 规则服务的统一调度接口
 * @author zszhang
 *
 */
public interface RuleService {

	/**
	 * 初始化模型记录
	 * @param SerialNo 申请流水号
	 * @param modelID 模型编号
	 * @param tx 外部事务
	 * @return String
	 */
	public String initial(String SerialNo,String modelID,JBOTransaction tx);

	/**
	 * 删除模型记录
	 * @param recordID 模型记录编号
	 * @param tx 外部事务
	 * @return String
	 */
	public String delete(String recordID,JBOTransaction tx);
	
	/**
	 * 获取模型历史记录
	 * @param recordID 模型记录编号
	 * @return String
	 */
	public String getModelHistoryRecord(String recordID,String doTranStage);
	
	/**
	 * 获取模型整体对象详情
	 * @param modelID 模型编号
	 * @return 模型整体对象详情
	 */
	public RuleModel getModelObjectInfo(String modelID);
	
	/**
	 * 获取模型整体对象详情
	 * @param modelID 模型编号
	 * @param objectType 模型对象展示类型
	 * @param objectModule 模型对象所属模块
	 * @return 模型整体对象详情
	 */
	public RuleModel getModelObjectInfo(String modelID,String objectType,String objectModule);
	
	/**
	 * 获取模型所有对象详情
	 * @param modelID 模型编号
	 * @return 模型所有对象详情
	 */
	public List getObjects(String modelID);
	
	/**
	 * 获取模型特定对象详情
	 * @param modelID 模型编号
	 * @param objectType 模型对象展示类型
	 * @param objectModule 模型对象所属模块
	 * @return 模型特定对象详情
	 */
	public List getObjects(String modelID, String objectType, String objectModule);
	
	/**
	 * 获取模型指定对象所有项目详情
	 * @param objectID 对象编号
	 * @return 指定对象所有项目详情
	 */
	public List getItems(String objectID);
	
	/**
	 * 获取模型指定项目属性详情
	 * @param subObjectID 项目编号
	 * @return 指定项目属性详情
	 */
	public List getItemsAttributes(String subObjectID);
	
	/**
	 * 获取模型项目指定属性详情
	 * @param attributeID 项目属性编号
	 * @return 项目指定属性详情
	 */
	public RuleAttribute getItemsSingleAttribute(String attributeID);
	
	/**
	 * 获取模型运算结果集
	 * @param serialNo 流水号
	 * @param recordID 模型记录编号
	 * @param modelID 模型编号
	 * @param object 规则对象
	 * @param doTranStage 测算阶段
	 * @return 运算结果集
	 */
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object,String doTranStage);
	
	/**
	 * 获取模型运算结果集
	 * @param serialNo 流水号
	 * @param recordID 模型记录编号
	 * @param modelID 模型编号
	 * @param object 规则对象
	 * @return 运算结果集
	 */
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object);
}
