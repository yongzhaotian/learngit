package com.amarsoft.app.alarm;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * @author syang
 * @date 2011-6-29
 * @describe �Զ�����̽�ⳡ������������
 */
public class ScenarioContext implements Serializable {

	private static final long serialVersionUID = 6610376396255766122L;
	private Map<String,Object> parameters = null;		//����������
	private Scenario scenario = null;			//����ģ��
	private CheckItemRunner checkItemRunner = null;		//�����������
	
	
	public ScenarioContext(){
		parameters = new HashMap<String,Object>();
	}
	/**
	 * ��ȡ����ģ��
	 * @return ����ģ��
	 */
	public Scenario getScenario() {
		return scenario;
	}
	/**
	 * ���ó���ģ��
	 * @param scenario ����ģ��
	 */
	public void setScenario(Scenario scenario) {
		this.scenario = scenario;
	}

	/**
	 * ����ģ�Ͳ���
	 * @param key ������
	 * @param value ���� ֵ
	 */
	public void setParameter(String name,Object value){
		parameters.put(name, value);
	}
	/**
	 * ��ȡģ�Ͳ���
	 * @param key ������
	 * @return ����ֵ
	 */
	public Serializable getParameter(String name){
		return (Serializable)parameters.get(name);
	}
	/**
	 * ��ȡģ�Ͳ����ض���
	 * @return ģ�Ͳ�������
	 */
	public Map<String,Object> getParameter(){
		return parameters;
	}
	/**
	 * ��ȡ�����������в�����
	 * @return ����������
	 */
	public String[] getParameterNames(){
		int i=0;
		String[] names = new String[parameters.size()];
		Iterator<String> iterator = parameters.keySet().iterator();
		while(iterator.hasNext())names[i++] = iterator.next();
		return names;
	}
	/**
	 * ��ȡ�����������
	 * @return �����������
	 */
	public CheckItemRunner getCheckItemRunner() {
		return checkItemRunner;
	}
	/**
	 * ���ü����������
	 * @param checkItemRunner �����������
	 */
	public void setCheckItemRunner(CheckItemRunner checkItemRunner) {
		this.checkItemRunner = checkItemRunner;
		this.checkItemRunner.setScenarioContext(this);
	}
	
}

