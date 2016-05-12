package com.amarsoft.app.alarm;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * @author syang
 * @date 2011-6-29
 * @describe 自动风险探测场景模型
 */
public class Scenario implements Serializable {

	private static final long serialVersionUID = -5493729351465235147L;
	
	private String scenarioID = "";			//场景编号
	private String scenarioName = "";		//场景名称
	private String scenarioDescibe = "";	//场景描述
	private String initiateClass = "";		//初始化类
	private String initParameter = "";		//初始化加载参数
	
	
	private List<ItemGroup> groupList = null;	//分组列表
	
	public Scenario(){
		groupList = new ArrayList<ItemGroup>();
	}
	/**
	 * 获取一个分组
	 * @param groupID 分组号
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
	 * 根据分组号，序号找到一个检查项对象
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
	 * 设置场景编号
	 * @return 场景编号
	 */
	public String getScenarioID() {
		return scenarioID;
	}
	/**
	 * 获取场景名称
	 * @param scenarioID 场景编号
	 */
	public void setScenarioID(String scenarioID) {
		this.scenarioID = scenarioID;
	}
	/**
	 * 获取场景名称
	 * @return 场景名称
	 */
	public String getScenarioName() {
		return scenarioName;
	}
	/**
	 * 设置场景名称
	 * @param scenarioName 场景名称
	 */
	public void setScenarioName(String scenarioName) {
		this.scenarioName = scenarioName;
	}
	/**
	 * 获取场景描述
	 * @return 场景描述
	 */
	public String getScenarioDescibe() {
		return scenarioDescibe;
	}
	/**
	 * 设置场景描述
	 * @param scenarioDescibe 场景描述
	 */
	public void setScenarioDescibe(String scenarioDescibe) {
		this.scenarioDescibe = scenarioDescibe;
	}
	/**
	 * 获取初始化类
	 * @return 初始化类
	 */
	public String getInitiateClass() {
		return initiateClass;
	}
	/**
	 * 设置初始化类
	 * @param initiateClass 初始化类
	 */
	public void setInitiateClass(String initiateClass) {
		this.initiateClass = initiateClass;
	}
	/**
	 * 获取初始化加载参数
	 * @return 初始化加载参数
	 */
	public String getInitParameter() {
		return initParameter;
	}
	/**
	 * 设置初始化加载参数
	 * @param initParameter 初始化加载参数
	 */
	public void setInitParameter(String initParameter) {
		this.initParameter = initParameter;
	}
	/**
	 * 获取分组模型列表
	 * @return 分组模型列表
	 */
	public List<ItemGroup> getGroupList() {
		return groupList;
	}
	/**
	 * 添加一个分组模型
	 * @param itemGroup 分组模型对象
	 */
	public void addItemGroup(ItemGroup... itemGroup){
		for(int i=0;i<itemGroup.length;i++){
			groupList.add(itemGroup[i]);
		}
	}
	/**
	 * 移除一个分组模型
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

