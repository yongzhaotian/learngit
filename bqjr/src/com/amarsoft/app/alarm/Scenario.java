package com.amarsoft.app.alarm;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * @author syang
 * @date 2011-6-29
 * @describe �Զ�����̽�ⳡ��ģ��
 */
public class Scenario implements Serializable {

	private static final long serialVersionUID = -5493729351465235147L;
	
	private String scenarioID = "";			//�������
	private String scenarioName = "";		//��������
	private String scenarioDescibe = "";	//��������
	private String initiateClass = "";		//��ʼ����
	private String initParameter = "";		//��ʼ�����ز���
	
	
	private List<ItemGroup> groupList = null;	//�����б�
	
	public Scenario(){
		groupList = new ArrayList<ItemGroup>();
	}
	/**
	 * ��ȡһ������
	 * @param groupID �����
	 * @return
	 */
	public ItemGroup getItemGroup(String groupID){
		for(ItemGroup group:groupList){
			if(groupID.equals(group.getGroupID())){
				return group;
			}
		}
		return null;
	}
	/**
	 * ���ݷ���ţ�����ҵ�һ����������
	 * @param groupID
	 * @param itemID
	 */
	public CheckItem getCheckItem(String groupID,String itemID){
		ItemGroup group=getItemGroup(groupID);
		if(group!=null){
			List<CheckItem> cList = group.getCheckItemList();
			for(CheckItem item:cList){
				if(itemID.equals(item.getItemID())){
					return item;
				}
			}
		}
		return null;
	}
	/**
	 * ���ó������
	 * @return �������
	 */
	public String getScenarioID() {
		return scenarioID;
	}
	/**
	 * ��ȡ��������
	 * @param scenarioID �������
	 */
	public void setScenarioID(String scenarioID) {
		this.scenarioID = scenarioID;
	}
	/**
	 * ��ȡ��������
	 * @return ��������
	 */
	public String getScenarioName() {
		return scenarioName;
	}
	/**
	 * ���ó�������
	 * @param scenarioName ��������
	 */
	public void setScenarioName(String scenarioName) {
		this.scenarioName = scenarioName;
	}
	/**
	 * ��ȡ��������
	 * @return ��������
	 */
	public String getScenarioDescibe() {
		return scenarioDescibe;
	}
	/**
	 * ���ó�������
	 * @param scenarioDescibe ��������
	 */
	public void setScenarioDescibe(String scenarioDescibe) {
		this.scenarioDescibe = scenarioDescibe;
	}
	/**
	 * ��ȡ��ʼ����
	 * @return ��ʼ����
	 */
	public String getInitiateClass() {
		return initiateClass;
	}
	/**
	 * ���ó�ʼ����
	 * @param initiateClass ��ʼ����
	 */
	public void setInitiateClass(String initiateClass) {
		this.initiateClass = initiateClass;
	}
	/**
	 * ��ȡ��ʼ�����ز���
	 * @return ��ʼ�����ز���
	 */
	public String getInitParameter() {
		return initParameter;
	}
	/**
	 * ���ó�ʼ�����ز���
	 * @param initParameter ��ʼ�����ز���
	 */
	public void setInitParameter(String initParameter) {
		this.initParameter = initParameter;
	}
	/**
	 * ��ȡ����ģ���б�
	 * @return ����ģ���б�
	 */
	public List<ItemGroup> getGroupList() {
		return groupList;
	}
	/**
	 * ���һ������ģ��
	 * @param itemGroup ����ģ�Ͷ���
	 */
	public void addItemGroup(ItemGroup... itemGroup){
		for(int i=0;i<itemGroup.length;i++){
			groupList.add(itemGroup[i]);
		}
	}
	/**
	 * �Ƴ�һ������ģ��
	 * @param groupID
	 */
	public void removeItemGroup(String groupID){
		for(int i=0;i<groupList.size();i++){
			ItemGroup itemGroup = groupList.get(i);
			if(groupID.equals(itemGroup.getGroupID())){
				groupList.remove(itemGroup);
				break;
			}
		}
	}

}

