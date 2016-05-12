package com.amarsoft.app.als.rule.impl;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.rule.RuleService;
import com.amarsoft.app.als.rule.action.GetCorrelativeValue;
import com.amarsoft.app.als.rule.action.UpdateRuleRecord;
import com.amarsoft.app.als.rule.data.RuleAttribute;
import com.amarsoft.app.als.rule.data.RuleItem;
import com.amarsoft.app.als.rule.data.RuleModel;
import com.amarsoft.app.als.rule.data.RuleObject;
import com.amarsoft.app.als.rule.util.RuleOpProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.core.json.JSONObject;

/**
 * 默认应用系统与规则引擎集成的调用方法实现类
 * 
 * @author zszhang
 */
public class RuleDefaultService implements RuleService{
	public BizObjectManager bm = null;
	public BizObjectQuery bq = null;
	public BizObject bo = null;
	public List boList = null;

	
	public String getRuleID(){
		return null;
		
	}
	/**
	 * 初始化模型记录
	 * @param  SerialNo 申请流水号
	 * @param  modelID 模型编号
	 * @param  tx 外部事务
	 * @return 模型记录编号
	 */
	public String initial(String serialNo, String modelID, JBOTransaction tx) {
		String recordID = null;
		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
			tx.join(bm);
			bo = bm.newObject();
			bo.getAttribute("RULEMODRECORDID").setNull();
			bo.setAttributeValue("REFRATINGRECORDID", serialNo);
			bo.setAttributeValue("REFMODELID", modelID);
			bm.saveObject(bo);
			recordID = bo.getAttribute("RULEMODRECORDID").toString();
		} catch (JBOException e) {
			try {
				tx.rollback();
			} catch (JBOException e1) {
				ARE.getLog().error("事务回滚失败",e);
			}
			ARE.getLog().error("模型记录表新增记录失败",e);
		}
		return recordID;
	}
	
	/**
	 * 删除模型历史记录
	 * @param recordID 模型记录编号
	 * @param tx 外部事务
	 * @return 成功返回SUCCESS,失败返回FAILURE.
	 */
	public String delete(String recordID,JBOTransaction tx) {
		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
			tx.join(bm);
			bq = bm.createQuery("RULEMODRECORDID=:RecordID");
			bq.setParameter("RecordID", recordID);
			bo = bq.getSingleResult(false);
			if(bo!=null){
				bm.deleteObject(bo);
			}
			
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_RECORD");
			tx.join(bm);
			bq = bm.createQuery("RULEMODRECORDID=:RecordID");
			bq.setParameter("RecordID", recordID);
			boList = bq.getResultList(false);
			if(boList.size()!=0){
				for(int i = 0;i<boList.size();i++){
					bo = (BizObject)boList.get(i);
					bm.deleteObject(bo);
				}
			}
		} catch (JBOException e) {
			try {
				tx.rollback();
			} catch (JBOException e1) {
				ARE.getLog().error("事务回滚失败",e);
				return "FAILURE";
			}
			ARE.getLog().error("模型规则相关记录删除记录失败",e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	
	/**
	 * 获取模型历史记录
	 * @param recordID 模型记录编号
	 * @return 模型记录
	 */
	public String getModelHistoryRecord(String recordID,String doTranStage){
		String bomTextIn = "";
		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
			bq = bm.createQuery("RULEMODRECORDID=:RecordID");
			bq.setParameter("RecordID", recordID);
			bo = bq.getSingleResult(false);
			if(bo!=null){
				if("1".equals(doTranStage)){
				bomTextIn = bo.getAttribute("BomTextIn").toString();
				}else if("2".equals(doTranStage)){
					bomTextIn=bo.getAttribute("BomTextIn02").getString();
				}else {
					bomTextIn = bo.getAttribute("BomTextIn03").getString();
				}
			}
		} catch (JBOException e) {
			ARE.getLog().error("读取模型历史记录出错",e);
		}
		return bomTextIn;
	}
	
	/**
	 * 获取模型所有对象详情
	 * @param modelID 模型编号
	 * @return 模型所有对象详情
	 */
	public RuleModel getModelObjectInfo(String modelID) {
		List records, subRecords, attRecords = null;

		RuleModel ruleModel = new RuleModel();
		List ruleObjects = new ArrayList();
		List ruleItems = new ArrayList();
		List ruleAttributes = new ArrayList();
		
		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOM_INFO");
			bq = bm.createQuery("ModelID=:ModelID and BomType <> ''");
			bq.setParameter("ModelID", modelID);
			records = bq.getResultList(false);

			if (records != null) {
				for (int i = 0; i < records.size(); i++) {

					bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOMITEM");
					bq = bm.createQuery("BomID=:BomID order by BomID");
					bq.setParameter("BomID", ((BizObject) records.get(i)).getAttribute("BomID").toString());
					subRecords = bq.getResultList(false);
					if (subRecords != null) {

						for (int j = 0; j < subRecords.size(); j++) {
							bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOMITEMATT");
							bq = bm.createQuery("NodeID=:NodeID ORDER BY NODEID, ATT02");
							bq.setParameter("NodeID",((BizObject) subRecords.get(j)).getAttribute("NodeID").toString());
							attRecords = bq.getResultList(false);

							if (attRecords != null) {
								for (int k = 0; k < attRecords.size(); k++) {
									RuleAttribute ruleAttribute = new RuleAttribute();
									ruleAttribute.setAttributeID(((BizObject) attRecords.get(k)).getAttribute("AttributeID").toString());
									ruleAttribute.setAttributeName(((BizObject) attRecords.get(k)).getAttribute("AttributeName").toString());
									ruleAttribute.setRemark(((BizObject) attRecords.get(k)).getAttribute("Memo").toString());
									ruleAttributes.add(ruleAttribute);
								}
							}
							RuleItem ruleItem = new RuleItem();
							ruleItem.setItemID(((BizObject) subRecords.get(j)).getAttribute("NodeID").toString());
							ruleItem.setItemName(((BizObject) subRecords.get(j)).getAttribute("NodeName").toString());
							ruleItem.setItemRelation(((BizObject) subRecords.get(j)).getAttribute("Att05").toString());
							ruleItem.setRuleAttributes(ruleAttributes);
							ruleItems.add(ruleItem);
						}
					}
					RuleObject ruleObject = new RuleObject();
					ruleObject.setObjectID(((BizObject) records.get(i)).getAttribute("BomID").toString());
					ruleObject.setObjectName(((BizObject) records.get(i)).getAttribute("BomName").toString());
					ruleObject.setObjectType(((BizObject) records.get(i)).getAttribute("BomType").toString());
					ruleObject.setItems(ruleItems);
					ruleObjects.add(ruleObject);
				}
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		ruleModel.setModelID(modelID);
		ruleModel.setRuleObjects(ruleObjects);
		return ruleModel;
	}


	/**
	 * 获取模型特定对象详情
	 * @param modelID 模型编号
	 * @param objectType 模型对象展示类型
	 * @param  模型对象所属模块
	 * @return 模型特定对象详情
	 */
	public RuleModel getModelObjectInfo(String modelID, String objectType, String doTranStage) {
		List records, subRecords, attRecords = null;

		RuleModel ruleModel = new RuleModel();
		List ruleObjects = new ArrayList();
		List ruleItems = null;
		List ruleAttributes = null;
		
		if(modelID==null)modelID="";
		if(objectType==null)objectType="";
		if(doTranStage==null)doTranStage="";

		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOM_INFO");
			if ("".equals(doTranStage)&&!"".equals(objectType)){
				bq = bm.createQuery("ModelID=:ModelID and ATT02=:ATT02");
				bq.setParameter("ModelID", modelID);
				bq.setParameter("ATT02", objectType);
			}
			if ("".equals(objectType)&&!"".equals(doTranStage)){
				bq = bm.createQuery("ModelID=:ModelID and ATT03=:ATT03 order by att05");
				bq.setParameter("ModelID", modelID);
				bq.setParameter("ATT03",doTranStage);
			}
			if (!"".equals(objectType)&&!"".equals(doTranStage)){
				bq = bm.createQuery("ModelID=:ModelID and ATT02=:ATT02 and ATT03=:ATT03");
				bq.setParameter("ModelID", modelID);
				bq.setParameter("ATT02", objectType);
				bq.setParameter("ATT03", doTranStage);
			}
			records = bq.getResultList(false);

			if (records != null) {
				for (int i = 0; i < records.size(); i++) {

					bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOMITEM");
					bq = bm.createQuery("BomID=:BomID and att01 is not null");
					bq.setParameter("BomID", ((BizObject) records.get(i)).getAttribute("BomID").toString());
					subRecords = bq.getResultList(false);
					if (subRecords != null) {
						ruleItems = new ArrayList();
						for (int j = 0; j < subRecords.size(); j++) {
							bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOMITEMATT");
							bq = bm.createQuery("NodeID=:NodeID ORDER BY NODEID,ATTRIBUTEID");
							bq.setParameter("NodeID",((BizObject) subRecords.get(j)).getAttribute("NodeID").toString());
							attRecords = bq.getResultList(false);

							if (attRecords != null) {
								ruleAttributes = new ArrayList();
								for (int k = 0; k < attRecords.size(); k++) {
									RuleAttribute ruleAttribute = new RuleAttribute();
									ruleAttribute.setAttributeID(((BizObject) attRecords.get(k)).getAttribute("AttributeID").toString());
									ruleAttribute.setAttributeName(((BizObject) attRecords.get(k)).getAttribute("AttributeName").toString());
									ruleAttribute.setRemark(((BizObject) attRecords.get(k)).getAttribute("Memo").toString());
									ruleAttributes.add(ruleAttribute);
								}
							}
							RuleItem ruleItem = new RuleItem();
							ruleItem.setItemID(((BizObject) subRecords.get(j)).getAttribute("NodeID").toString());
							ruleItem.setItemName(((BizObject) subRecords.get(j)).getAttribute("NodeName").toString());
							ruleItem.setItemType(((BizObject) subRecords.get(j)).getAttribute("att01").toString());
							ruleItem.setItemRelation(((BizObject) subRecords.get(j)).getAttribute("Att02").toString());
							ruleItem.setItemStyle(((BizObject) subRecords.get(j)).getAttribute("att03").toString());
							ruleItem.setRuleAttributes(ruleAttributes);
							ruleItems.add(ruleItem);
						}
					}
					RuleObject ruleObject = new RuleObject();
					ruleObject.setObjectID(((BizObject) records.get(i)).getAttribute("BomID").toString());
					ruleObject.setObjectName(((BizObject) records.get(i)).getAttribute("BomName").toString());
					ruleObject.setObjectType(((BizObject) records.get(i)).getAttribute("BomType").toString());
					ruleObject.setItems(ruleItems);
					ruleObjects.add(ruleObject);
				}
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		ruleModel.setModelID(modelID);
		ruleModel.setRuleObjects(ruleObjects);
		return ruleModel;
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
		JSONObject jObject = null;
		String ruleID = null;
		String calcResult = null;

		try {
			if ("".equals(object)) {
				// 获取模型记录
				bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
				bq = bm.createQuery("RULEMODRECORDID=:RecordID");
				bq.setParameter("RecordID", recordID);
				bo = bq.getSingleResult(false);
				if (bo != null) {
					object = bo.getAttribute("BOMTEXTIN").toString();
				}
				// 对模型记录进行拼装
				jObject = RuleOpProvider.combineBomItem(modelID, object);

				// 获取应用系统中相关数据，并进行拼装
				GetCorrelativeValue gcv = new GetCorrelativeValue();
				gcv.setModelID(modelID);
				gcv.setSerialNo(serialNo);
				String params = gcv.getRatingInfo();
				String[] param = null;
				if (params != null && !"".equals(params)) {
					param = params.split(";");
					for (int i = 0; i < param.length; i++) {
						String itemName = param[i].split("=")[0];
						String itemValue = param[i].split("=")[1];
						jObject = RuleOpProvider.setNodeValue(jObject,
								itemName, itemValue);
					}
				}

				// 最终拼装完的BOM
				object = RuleOpProvider.combineBomInfo(modelID, String.valueOf(jObject));
			}
			//获取调用规则编号
			ruleID = RuleOpProvider.getRuleID(modelID, "RatingRule");
		} catch (JBOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		ARE.getLog().info("*********业务对象*********");
		ARE.getLog().info(object);

		calcResult = RuleConnectionService.callRule(modelID,ruleType,ruleID,object, "");

		ARE.getLog().info("*********测算结果*********");
		ARE.getLog().info(calcResult);
		UpdateRuleRecord urr= new UpdateRuleRecord();
		try {
			urr.update(recordID, ruleType, ruleID, object, calcResult);
		} catch (JBOException e) {
			ARE.getLog().error("更新规则记录失败",e);
		}
		return calcResult;
	}
	
	/**
	 * 有不同阶段的评级的各阶段获取结果的方法 ，未实现
	 */
	
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object,String doTranStage) {
		return "";
	}
	/**
	 * 获取模型所有对象详情
	 * @param modelID 模型编号
	 * @return 模型所有对象详情
	 */
	public List getObjects(String modelID) {
		List records = null;
		List ruleObjects = new ArrayList();
		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOM_INFO");
			bq = bm.createQuery("ModelID=:ModelID");
			bq.setParameter("ModelID", modelID);
			records = bq.getResultList(false);
			if (records != null) {
				for (int i = 0; i < records.size(); i++) {
					RuleObject ruleObject = new RuleObject();
					ruleObject.setObjectID(((BizObject) records.get(i)).getAttribute("BomID").toString());
					ruleObject.setObjectName(((BizObject) records.get(i)).getAttribute("BomName").toString());
					ruleObject.setObjectType(((BizObject) records.get(i)).getAttribute("BomType").toString());
					ruleObjects.add(ruleObject);
				}
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return ruleObjects;
	}
	
	/**
	 * 获取模型特定对象详情
	 * @param modelID 模型编号
	 * @param objectType 模型对象展示类型
	 * @param objectModule 模型对象所属模块
	 * @return 模型特定对象详情
	 */
	public List getObjects(String modelID, String objectType, String objectModule) {
		List records = null;
		List ruleObjects = new ArrayList();
		if(modelID==null)modelID="";
		if(objectType==null)objectType="";
		if(objectModule==null)objectModule="";

		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOM_INFO");
			if ("".equals(objectModule)&&!"".equals(objectType)){
				bq = bm.createQuery("ModelID=:ModelID and BomType=:BomType");
				bq.setParameter("ModelID", modelID);
				bq.setParameter("BomType", objectType);
			}
			if ("".equals(objectType)&&!"".equals(objectModule)){
				bq = bm.createQuery("ModelID=:ModelID and Att04=:BomModule");
				bq.setParameter("ModelID", modelID);
				bq.setParameter("BomModule", objectModule);
			}
			if (!"".equals(objectType)&&!"".equals(objectModule)){
				bq = bm.createQuery("ModelID=:ModelID and BomType=:BomType and BomModule=:BomModule");
				bq.setParameter("ModelID", modelID);
				bq.setParameter("BomType", objectType);
				bq.setParameter("BomModule", objectModule);
			}

			records = bq.getResultList(false);
			if (records != null) {
				for (int i = 0; i < records.size(); i++) {
					RuleObject ruleObject = new RuleObject();
					ruleObject.setObjectID(((BizObject) records.get(i)).getAttribute("BomID").toString());
					ruleObject.setObjectName(((BizObject) records.get(i)).getAttribute("BomName").toString());
					ruleObject.setObjectType(((BizObject) records.get(i)).getAttribute("BomType").toString());
					ruleObjects.add(ruleObject);
				}
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return ruleObjects;
	}
	
	/**
	 * 获取模型指定对象所有项目详情
	 * @param objectID 对象编号
	 * @return 指定对象所有项目详情
	 */
	public List getItems(String objectID) {
		List records = null;
		List ruleItems = new ArrayList();
		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOMITEM");
			bq = bm.createQuery("BomID=:BomID");
			bq.setParameter("BomID", objectID);
			records = bq.getResultList(false);
			if (records != null) {
				for (int j = 0; j < records.size(); j++) {
					RuleItem ruleItem = new RuleItem();
					ruleItem.setItemID(((BizObject)records.get(j)).getAttribute("NodeID").toString());
					ruleItem.setItemName(((BizObject)records.get(j)).getAttribute("NodeName").toString());
					ruleItem.setItemRelation(((BizObject)records.get(j)).getAttribute("Att05").toString());
					ruleItems.add(ruleItem);
				}
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return ruleItems;
	}
	
	/**
	 * 获取模型指定项目属性详情
	 * @param itemID 项目编号
	 * @return 指定项目属性详情
	 */
	public List getItemsAttributes(String itemID) {
		List records = null;
		List ruleAttributes = new ArrayList();
		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOMITEMATT");
			bq = bm.createQuery("NodeID=:NodeID");
			bq.setParameter("NodeID", itemID);
			records = bq.getResultList(false);
			if (records != null) {
				for (int j = 0; j < records.size(); j++) {
					RuleAttribute ruleAttribute = new RuleAttribute();
					ruleAttribute.setAttributeID(((BizObject) records.get(j)).getAttribute("AttributeID").toString());
					ruleAttribute.setAttributeName(((BizObject) records.get(j)).getAttribute("AttributeName").toString());
					ruleAttribute.setRemark(((BizObject) records.get(j)).getAttribute("Memo").toString());
					ruleAttribute.setDescribe(((BizObject) records.get(j)).getAttribute("Script02").toString());
					ruleAttributes.add(ruleAttribute);
				}
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return ruleAttributes;
	}
	
	/**
	 * 获取模型项目指定属性详情
	 * @param attributeID 项目属性编号
	 * @return 项目指定属性详情
	 */
	public RuleAttribute getItemsSingleAttribute(String attributeID){
		RuleAttribute ruleAttribute = new RuleAttribute();
		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.RULE_BOMITEMATT");
			bq = bm.createQuery("AttributeID=:attributeID");
			bq.setParameter("attributeID", attributeID);
			bo = bq.getSingleResult(false);
			if (bo != null) {
				ruleAttribute.setAttributeID(bo.getAttribute("AttributeID").toString());
				ruleAttribute.setAttributeName(bo.getAttribute("AttributeName").toString());
				ruleAttribute.setRemark(bo.getAttribute("Memo").toString());
				ruleAttribute.setDescribe(bo.getAttribute("Script02").toString());
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return ruleAttribute;
	}
}
