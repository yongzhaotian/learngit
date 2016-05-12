package com.amarsoft.app.alarm;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * @author syang
 * @date 2011-6-29
 * @describe 自动风险探测场景上下文容器
 */
public class ScenarioContext implements Serializable {

	private static final long serialVersionUID = 6610376396255766122L;
	private Map<String,Object> parameters = null;		//场景参数池
	private Scenario scenario = null;			//场景模型
	private CheckItemRunner checkItemRunner = null;		//检查项运行器
	
	
	public ScenarioContext(){
		parameters = new HashMap<String,Object>();
	}
	/**
	 * 获取场景模型
	 * @return 场景模型
	 */
	public Scenario getScenario() {
		return scenario;
	}
	/**
	 * 设置场景模型
	 * @param scenario 场景模型
	 */
	public void setScenario(Scenario scenario) {
		this.scenario = scenario;
	}

	/**
	 * 设置模型参数
	 * @param key 参数名
	 * @param value 参数 值
	 */
	public void setParameter(String name,Object value){
		parameters.put(name, value);
	}
	/**
	 * 获取模型参数
	 * @param key 参数名
	 * @return 参数值
	 */
	public Serializable getParameter(String name){
		return (Serializable)parameters.get(name);
	}
	/**
	 * 获取模型参数池对象
	 * @return 模型参数对象
	 */
	public Map<String,Object> getParameter(){
		return parameters;
	}
	/**
	 * 获取参数池中所有参数名
	 * @return 参数名数组
	 */
	public String[] getParameterNames(){
		int i=0;
		String[] names = new String[parameters.size()];
		Iterator<String> iterator = parameters.keySet().iterator();
		while(iterator.hasNext())names[i++] = iterator.next();
		return names;
	}
	/**
	 * 获取检查项运行器
	 * @return 检查项运行器
	 */
	public CheckItemRunner getCheckItemRunner() {
		return checkItemRunner;
	}
	/**
	 * 设置检查项运行器
	 * @param checkItemRunner 检查项运行器
	 */
	public void setCheckItemRunner(CheckItemRunner checkItemRunner) {
		this.checkItemRunner = checkItemRunner;
		this.checkItemRunner.setScenarioContext(this);
	}
	
}

