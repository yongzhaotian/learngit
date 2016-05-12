package com.amarsoft.app.alarm;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * @author syang
 * @date 2011-6-29
 * @describe ����ģ�ͷ���
 */
public class ItemGroup implements Serializable {

	private static final long serialVersionUID = 4715123743456733378L;
	private Scenario scenario = null;				//����ģ��
	private String groupID = "";							//����ID
	private String groupName = "";							//��������
	private List<CheckItem> checkItemList = null;	//ģ���б�
	
	/**
	 * ����һ������
	 * @param scenario ����ģ��
	 * @param groupID �����
	 * @param groupName ��������
	 */
	public ItemGroup(Scenario scenario,String groupID, String groupName) {
		this.scenario = scenario;
		this.groupID = groupID;
		this.groupName = groupName;
		this.checkItemList = new ArrayList<CheckItem>();
	}
	/**
	 * ��ȡ����ģ��
	 * @return����ģ��
	 */
	public Scenario getScenario(){
		return scenario;
	}
	/**
	 * ���ط����
	 * @return �����
	 */
	public String getGroupID() {
		return groupID;
	}
	/**
	 * ���ط�������
	 * @return ��������
	 */
	public String getGroupName() {
		return groupName;
	}
	/**
	 * ��ȡ������б�
	 * @return ������б�
	 */
	public List<CheckItem> getCheckItemList(){
		return checkItemList;
	}
	/**
	 * ���һ�������
	 * @param checkItem ������б�
	 */
	public void addCheckItem(CheckItem... checkItem){
		for(int i=0;i<checkItem.length;i++){
			checkItemList.add(checkItem[i]);
		}
	}
}

