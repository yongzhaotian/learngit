package com.amarsoft.app.als.rule.action;

import java.util.List;

import com.amarsoft.app.als.rule.RuleService;
import com.amarsoft.app.als.rule.RuleServiceFactory;
import com.amarsoft.app.als.rule.data.RuleAttribute;
import com.amarsoft.app.als.rule.data.RuleModel;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ����ģ�Ͷ����ȡ��ز�������ʼ����¼��ɾ����¼����ȡ��ʷ��¼�����ģ�����飬ģ�Ͷ������飬ģ����Ŀ���飬��Ŀ��������ȡ�
 * @author zszhang
 *
 */
public class RuleOpAction {
	
	private String modelID; 	 //ģ�ͱ��
	private String modelType;    //ģ������
	private String objectID; 	 //ģ�Ͷ�����
	private String objectType;   //ģ�Ͷ���չʾ����
	private String objectModule; //ģ�Ͷ�������ģ��
	private String itemID; 		 //ģ����Ŀ���
	private String attributeID;  //ģ����Ŀ���Ա��
	private RuleService rs; 	 //�������

	public RuleOpAction(String serviceType){
		rs = RuleServiceFactory.getRuleService(serviceType);//��ȡ�����������
	}
	
	/**
	 * ��ʼ��ģ�ͼ�¼
	 * @param SerialNo ������ˮ��
	 * @param modelID ģ�ͱ��
	 * @param tx �ⲿ����
	 * @return ģ�ͼ�¼���
	 */
	public String init(String serialNo,String modelID,JBOTransaction tx){
		String recordID = rs.initial(serialNo,modelID,tx);
		if(!"null".equalsIgnoreCase(recordID)&&recordID!=null){
			ARE.getLog().info("-----����ģ�ͼ�¼��ʼ���ɹ�-----");
		}
		return recordID;
	}
	
	/**
	 * ɾ�����ģ�ͼ�¼
	 * @param SerialNo ģ�ͼ�¼���
	 * @param tx �ⲿ����
	 * @return String
	 */
	public String delete(String serialNo,JBOTransaction tx){
		String result = rs.delete(serialNo,tx);
		if("SUCCESS".equals(result)){
			ARE.getLog().info("-----����ģ�ͼ�¼ɾ���ɹ�-----");
		}else{
			ARE.getLog().info("-----����ģ�ͼ�¼ɾ��ʧ��-----");
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * ��ȡģ����ʷ��¼
	 * @param SerialNo ģ�ͼ�¼���
	 * @return ģ�ͼ�¼
	 */
	public String getHistoryRecord(String serialNo,String doTranStage){
		String record = rs.getModelHistoryRecord(serialNo,doTranStage);
		if(!"null".equalsIgnoreCase(record)&&record!=null&&!"".equals(record.trim())){
			ARE.getLog().info("-----��ȡģ�ͼ�¼�ɹ�-----");
		}else{
			ARE.getLog().info("-----��ģ�ͼ�¼����Ϊ��-----");
		}
		return record;
	}

	/**
	 * ���ģ�Ͷ������飬����ֻ����ģ�ͱ�Ż�ȡȫ��ģ�Ͷ������飬���������������ض�ģ�Ͷ������顣
	 * @Params modelID��ģ�ͱ��
	 * @Params objectType��ģ�Ͷ���չʾ����
	 * @Params objectModule��ģ�Ͷ�������ģ��
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
	 * ���ģ�Ͷ������飬����ֻ����ģ�ͱ�Ż�ȡȫ��ģ�Ͷ�������Ŀ���飬���������������ض�ģ�Ͷ�������Ŀ���顣
	 * @Params modelID��ģ�ͱ��
	 * @Params objectType��ģ�Ͷ���չʾ����
	 * @Params objectModule��ģ�Ͷ�������ģ��
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
	 * ���ģ����Ŀ����
	 * @Params objectID��������
	 * @return List<RuleItem>
	 */
	public List getItemInfo(){
		List ruleItems = null;
		
		ruleItems = rs.getItems(objectID);
		return ruleItems;
	}

	/**
	 * ���ģ����Ŀ��������
	 * @Params itemID����Ŀ���
	 * @return List<RuleAttribute>
	 */
	public List getAttributeInfo(){	
		List ruleAttributes = null;
		
		ruleAttributes = rs.getItemsAttributes(itemID);
		return ruleAttributes;
	}
	
	/**
	 * ���ģ����Ŀ������������
	 * @Params attributeID����Ŀ���Ա��
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
	 * ��ȡģ����������
	 * @param serialNo ��ˮ��
	 * @param recordID ģ�ͼ�¼���
	 * @param modelID ģ�ͱ��
	 * @param object �������
	 * @Param doTranStage ����׶�
	 * @return ��������
	 */
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object,String doTranStage) {
		String result = rs.getResult(serialNo,recordID,modelID,ruleType,object, doTranStage);
		return result;
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
