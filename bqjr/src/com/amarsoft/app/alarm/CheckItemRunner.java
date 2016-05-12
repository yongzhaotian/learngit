package com.amarsoft.app.alarm;

import java.io.Serializable;

import com.amarsoft.awe.util.Transaction;

/**
 * @author syang
 * @date 2011-6-29
 * @describe ̽��ģ��������������������ֳ�����������δ�����ϸ������չ
 */
public abstract class CheckItemRunner implements Serializable{
	private static final long serialVersionUID = 4213339734225087052L;
	ScenarioContext context = null;		//��������������
	/**
	 * ���ó�������������
	 * @param context
	 */
	public void setScenarioContext(ScenarioContext context){
		this.context = context;
	}
	/**
	 * ��ȡ��������������
	 * @return ��������������
	 */
	public ScenarioContext getScenarioContext(){
		return context;
	}
	/**
	 * ���󷽷�������ģ��
	 * @param sqlca ����ģ������
	 * @param checkItem ����ģ������
	 * @return
	 */
	public abstract Object run(Transaction sqlca,CheckItem checkItem) throws Exception;
}

