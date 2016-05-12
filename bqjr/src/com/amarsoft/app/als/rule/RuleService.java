package com.amarsoft.app.als.rule;

import java.util.List;

import com.amarsoft.app.als.rule.data.RuleAttribute;
import com.amarsoft.app.als.rule.data.RuleModel;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ��������ͳһ���Ƚӿ�
 * @author zszhang
 *
 */
public interface RuleService {

	/**
	 * ��ʼ��ģ�ͼ�¼
	 * @param SerialNo ������ˮ��
	 * @param modelID ģ�ͱ��
	 * @param tx �ⲿ����
	 * @return String
	 */
	public String initial(String SerialNo,String modelID,JBOTransaction tx);

	/**
	 * ɾ��ģ�ͼ�¼
	 * @param recordID ģ�ͼ�¼���
	 * @param tx �ⲿ����
	 * @return String
	 */
	public String delete(String recordID,JBOTransaction tx);
	
	/**
	 * ��ȡģ����ʷ��¼
	 * @param recordID ģ�ͼ�¼���
	 * @return String
	 */
	public String getModelHistoryRecord(String recordID,String doTranStage);
	
	/**
	 * ��ȡģ�������������
	 * @param modelID ģ�ͱ��
	 * @return ģ�������������
	 */
	public RuleModel getModelObjectInfo(String modelID);
	
	/**
	 * ��ȡģ�������������
	 * @param modelID ģ�ͱ��
	 * @param objectType ģ�Ͷ���չʾ����
	 * @param objectModule ģ�Ͷ�������ģ��
	 * @return ģ�������������
	 */
	public RuleModel getModelObjectInfo(String modelID,String objectType,String objectModule);
	
	/**
	 * ��ȡģ�����ж�������
	 * @param modelID ģ�ͱ��
	 * @return ģ�����ж�������
	 */
	public List getObjects(String modelID);
	
	/**
	 * ��ȡģ���ض���������
	 * @param modelID ģ�ͱ��
	 * @param objectType ģ�Ͷ���չʾ����
	 * @param objectModule ģ�Ͷ�������ģ��
	 * @return ģ���ض���������
	 */
	public List getObjects(String modelID, String objectType, String objectModule);
	
	/**
	 * ��ȡģ��ָ������������Ŀ����
	 * @param objectID ������
	 * @return ָ������������Ŀ����
	 */
	public List getItems(String objectID);
	
	/**
	 * ��ȡģ��ָ����Ŀ��������
	 * @param subObjectID ��Ŀ���
	 * @return ָ����Ŀ��������
	 */
	public List getItemsAttributes(String subObjectID);
	
	/**
	 * ��ȡģ����Ŀָ����������
	 * @param attributeID ��Ŀ���Ա��
	 * @return ��Ŀָ����������
	 */
	public RuleAttribute getItemsSingleAttribute(String attributeID);
	
	/**
	 * ��ȡģ����������
	 * @param serialNo ��ˮ��
	 * @param recordID ģ�ͼ�¼���
	 * @param modelID ģ�ͱ��
	 * @param object �������
	 * @param doTranStage ����׶�
	 * @return ��������
	 */
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object,String doTranStage);
	
	/**
	 * ��ȡģ����������
	 * @param serialNo ��ˮ��
	 * @param recordID ģ�ͼ�¼���
	 * @param modelID ģ�ͱ��
	 * @param object �������
	 * @return ��������
	 */
	public String getResult(String serialNo,String recordID,String modelID,String ruleType,String object);
}
