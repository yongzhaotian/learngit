package com.amarsoft.app.alarm;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * @author syang
 * @date 2011-6-29
 * @describe 场景模型分组
 */
public class ItemGroup implements Serializable {

	private static final long serialVersionUID = 4715123743456733378L;
	private Scenario scenario = null;				//场景模型
	private String groupID = "";							//分组ID
	private String groupName = "";							//分组名称
	private List<CheckItem> checkItemList = null;	//模型列表
	
	/**
	 * 建议一个分组
	 * @param scenario 场景模型
	 * @param groupID 分组号
	 * @param groupName 分组名称
	 */
	public ItemGroup(Scenario scenario,String groupID, String groupName) {
		this.scenario = scenario;
		this.groupID = groupID;
		this.groupName = groupName;
		this.checkItemList = new ArrayList<CheckItem>();
	}
	/**
	 * 获取场景模型
	 * @return场景模型
	 */
	public Scenario getScenario(){
		return scenario;
	}
	/**
	 * 返回分组号
	 * @return 分组号
	 */
	public String getGroupID() {
		return groupID;
	}
	/**
	 * 返回分组名称
	 * @return 分组名称
	 */
	public String getGroupName() {
		return groupName;
	}
	/**
	 * 获取检查项列表
	 * @return 检查项列表
	 */
	public List<CheckItem> getCheckItemList(){
		return checkItemList;
	}
	/**
	 * 添加一个检查项
	 * @param checkItem 检查项列表
	 */
	public void addCheckItem(CheckItem... checkItem){
		for(int i=0;i<checkItem.length;i++){
			checkItemList.add(checkItem[i]);
		}
	}
}

