package com.amarsoft.app.als.rule.action;

import java.util.List;

import com.amarsoft.app.als.rule.RuleService;
import com.amarsoft.app.als.rule.RuleServiceFactory;
import com.amarsoft.app.als.rule.data.RuleAttribute;
import com.amarsoft.app.als.rule.data.RuleModel;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 规则模型对象获取相关操作：初始化记录，删除记录，获取历史记录，获得模型详情，模型对象详情，模型项目详情，项目属性详情等。
 * @author zszhang
 *
 */
public class RuleOpAction {
	
	private String modelID; 	 //模型编号
	private String modelType;    //模型类型
	private String objectID; 	 //模型对象编号
	private String objectType;   //模型对象展示类型
	private String objectModule; //模型对象所属模块
	private String itemID; 		 //模型项目编号
	private String attributeID;  //模型项目属性编号
	private RuleService rs; 	 //规则服务

	public RuleOpAction(String serviceType){
		rs = RuleServiceFactory.getRuleService(serviceType);//获取规则引擎服务
	}
	
	/**
	 * 初始化模型记录
	 * @param SerialNo 申请流水号
	 * @param modelID 模型编号
	 * @param tx 外部事务
	 * @return 模型记录编号
	 */
	public String init(String serialNo,String modelID,JBOTransaction tx){
		String recordID = rs.initial(serialNo,modelID,tx);
		if(!"null".equalsIgnoreCase(recordID)&&recordID!=null){
			ARE.getLog().info("-----规则模型记录初始化成功-----");
		}
		return recordID;
	}
	
	/**
	 * 删除相关模型记录
	 * @param SerialNo 模型记录编号
	 * @param tx 外部事务
	 * @return String
	 */
	public String delete(String serialNo,JBOTransaction tx){
		String result = rs.delete(serialNo,tx);
		if("SUCCESS".equals(result)){
			ARE.getLog().info("-----规则模型记录删除成功-----");
		}else{
			ARE.getLog().info("-----规则模型记录删除失败-----");
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * 获取模型历史记录
	 * @param SerialNo 模型记录编号
	 * @return 模型记录
	 */
	public String getHistoryRecord(String serialNo,String doTranStage){
		String record = rs.getModelHistoryRecord(serialNo,doTranStage);
		if(!"null".equalsIgnoreCase(record)&&record!=null&&!"".equals(record.trim())){
			ARE.getLog().info("-----获取模型记录成功-----");
		}else{
			ARE.getLog().info("-----该模型记录内容为空-----");
		}
		return record;
	}

	/**
	 * 获得模型对象详情，参数只设置模型编号获取全部模型对象详情，设置另外两项获得特定模型对象详情。
	 * @Params modelID：模型编号
	 * @Params objectType：模型对象展示类型
	 * @Params objectModule：模型对象所属模块
	 * @return List<RuleObject>
	 */
	public List getObjectInfo(String modelID,String objectType,String objectModule) {
		List ruleObjects = null;
		if (objectType == null && objectModule == null) {

			ruleObjects = rs.getObjects(modelID);
		} else {
			ruleObjects = rs.getObjects(modelID, objectType, objectModule);
		}
		return ruleObjects;
	}
	
	/**
	 * 获得模型对象详情，参数只设置模型编号获取全部模型对象及其项目详情，设置另外两项获得特定模型对象及其项目详情。
	 * @Params modelID：模型编号
	 * @Params objectType：模型对象展示类型
	 * @Params objectModule：模型对象所属模块
	 * @return List<RuleObject>
	 */
	public RuleModel getObjectAllDetial(String modelID,String displayType,String doTranStage) {
		RuleModel ruleModel = null;
		if (displayType == null && doTranStage == null) {

			ruleModel = rs.getModelObjectInfo(modelID);
		} else {
			ruleModel = rs.getModelObjectInfo(modelID, displayType, doTranStage);
		}
		return ruleModel;
	}

	/**
	 * 获得模型项目详情
	 * @Params objectID：对象编号
	 * @return List<RuleItem>
	 */
	public List getItemInfo(){
		List ruleItems = null;
		
		ruleItems = rs.getItems(objectID);
		return ruleItems;
	}

	/**
	 * 获得模型项目属性详情
	 * @Params itemID：项目编号
	 * @return List<RuleAttribute>
	 */
	public List getAttributeInfo(){	
		List ruleAttributes = null;
		
		ruleAttributes = rs.getItemsAttributes(itemID);
		return ruleAttributes;
	}
	
	/**
	 * 获得模型项目单个属性描述
	 * @Params attributeID：项目属性编号
	 * @return RuleAttribute
	 */
	public String getSingleAttributeDescribe() {
		RuleAttribute ruleAttribute = null;

		ruleAttribute = rs.getItemsSingleAttribute(attributeID);
		if (ruleAttribute != null) {
			return ruleAttribute.getDescribe();
		} else {
			return "";
		}
	}
	
	/**
	 * 获取模型运算结果集
	 * @param serialNo 流水号
	 * @param recordID 模型记录编号
	 * @param modelID 模型编号
	 * @param object 规则对象
	 * @Param doTranStage 运算阶段
	 * @return 运算结果集
	 */
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object,String doTranStage) {
		String result = rs.getResult(serialNo,recordID,modelID,ruleType,object, doTranStage);
		return result;
	}
	
	/**
	 * 获取模型运算结果集
	 * @param serialNo 流水号
	 * @param recordID 模型记录编号
	 * @param modelID 模型编号
	 * @param object 规则对象
	 * @return 运算结果集
	 */
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object) {
		String result = rs.getResult(serialNo,recordID,modelID,ruleType,object);
		return result;
	}
	public String getModelID() {
		return modelID;
	}

	public void setModelID(String modelID) {
		this.modelID = modelID;
	}

	public String getModelType() {
		return modelType;
	}

	public void setModelType(String modelType) {
		this.modelType = modelType;
	}

	public String getObjectID() {
		return objectID;
	}

	public void setObjectID(String objectID) {
		this.objectID = objectID;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getObjectModule() {
		return objectModule;
	}

	public void setObjectModule(String objectModule) {
		this.objectModule = objectModule;
	}

	public String getItemID() {
		return itemID;
	}

	public void setItemID(String itemID) {
		this.itemID = itemID;
	}

	public String getAttributeID() {
		return attributeID;
	}

	public void setAttributeID(String attributeID) {
		this.attributeID = attributeID;
	}
}
