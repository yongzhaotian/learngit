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
 * Ĭ��Ӧ��ϵͳ��������漯�ɵĵ��÷���ʵ����
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
	 * ��ʼ��ģ�ͼ�¼
	 * @param  SerialNo ������ˮ��
	 * @param  modelID ģ�ͱ��
	 * @param  tx �ⲿ����
	 * @return ģ�ͼ�¼���
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
				ARE.getLog().error("����ع�ʧ��",e);
			}
			ARE.getLog().error("ģ�ͼ�¼��������¼ʧ��",e);
		}
		return recordID;
	}
	
	/**
	 * ɾ��ģ����ʷ��¼
	 * @param recordID ģ�ͼ�¼���
	 * @param tx �ⲿ����
	 * @return �ɹ�����SUCCESS,ʧ�ܷ���FAILURE.
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
				ARE.getLog().error("����ع�ʧ��",e);
				return "FAILURE";
			}
			ARE.getLog().error("ģ�͹�����ؼ�¼ɾ����¼ʧ��",e);
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	
	/**
	 * ��ȡģ����ʷ��¼
	 * @param recordID ģ�ͼ�¼���
	 * @return ģ�ͼ�¼
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
			ARE.getLog().error("��ȡģ����ʷ��¼����",e);
		}
		return bomTextIn;
	}
	
	/**
	 * ��ȡģ�����ж�������
	 * @param modelID ģ�ͱ��
	 * @return ģ�����ж�������
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
	 * ��ȡģ���ض���������
	 * @param modelID ģ�ͱ��
	 * @param objectType ģ�Ͷ���չʾ����
	 * @param  ģ�Ͷ�������ģ��
	 * @return ģ���ض���������
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
	 * ��ȡģ����������
	 * @param serialNo ��ˮ��
	 * @param recordID ģ�ͼ�¼���
	 * @param modelID ģ�ͱ��
	 * @param object �������
	 * @return ��������
	 */
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object) {
		JSONObject jObject = null;
		String ruleID = null;
		String calcResult = null;

		try {
			if ("".equals(object)) {
				// ��ȡģ�ͼ�¼
				bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
				bq = bm.createQuery("RULEMODRECORDID=:RecordID");
				bq.setParameter("RecordID", recordID);
				bo = bq.getSingleResult(false);
				if (bo != null) {
					object = bo.getAttribute("BOMTEXTIN").toString();
				}
				// ��ģ�ͼ�¼����ƴװ
				jObject = RuleOpProvider.combineBomItem(modelID, object);

				// ��ȡӦ��ϵͳ��������ݣ�������ƴװ
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

				// ����ƴװ���BOM
				object = RuleOpProvider.combineBomInfo(modelID, String.valueOf(jObject));
			}
			//��ȡ���ù�����
			ruleID = RuleOpProvider.getRuleID(modelID, "RatingRule");
		} catch (JBOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		ARE.getLog().info("*********ҵ�����*********");
		ARE.getLog().info(object);

		calcResult = RuleConnectionService.callRule(modelID,ruleType,ruleID,object, "");

		ARE.getLog().info("*********������*********");
		ARE.getLog().info(calcResult);
		UpdateRuleRecord urr= new UpdateRuleRecord();
		try {
			urr.update(recordID, ruleType, ruleID, object, calcResult);
		} catch (JBOException e) {
			ARE.getLog().error("���¹����¼ʧ��",e);
		}
		return calcResult;
	}
	
	/**
	 * �в�ͬ�׶ε������ĸ��׶λ�ȡ����ķ��� ��δʵ��
	 */
	
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object,String doTranStage) {
		return "";
	}
	/**
	 * ��ȡģ�����ж�������
	 * @param modelID ģ�ͱ��
	 * @return ģ�����ж�������
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
	 * ��ȡģ���ض���������
	 * @param modelID ģ�ͱ��
	 * @param objectType ģ�Ͷ���չʾ����
	 * @param objectModule ģ�Ͷ�������ģ��
	 * @return ģ���ض���������
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
	 * ��ȡģ��ָ������������Ŀ����
	 * @param objectID ������
	 * @return ָ������������Ŀ����
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
	 * ��ȡģ��ָ����Ŀ��������
	 * @param itemID ��Ŀ���
	 * @return ָ����Ŀ��������
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
	 * ��ȡģ����Ŀָ����������
	 * @param attributeID ��Ŀ���Ա��
	 * @return ��Ŀָ����������
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
