package com.amarsoft.app.alarm;

import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �����࣬��������ҵ��Ԥ���������ҵ���߼�����java�඼Ҫ�Ӵ���̳�
 * @author syang
 * @since 2009/09/11
 *
 */
public abstract class AlarmBiz{
	private Map attribute = null;
	private AlarmMessage message = new AlarmMessage();
	
	/**
	 * �������Ա����أ�������Ҫ������ų������������ص�����
	 * @param attribute
	 */
	public void setAttributePool(Map attribute) {
		this.attribute = attribute;
	}
	
	/**
	 * ��ȡ��������ֵ
	 * @param key
	 * @return
	 * @throws Exception
	 */
	public Object getAttribute(String key) throws Exception{
		return attribute.get(key);
	}
	
	/**
	 * ���ó�������ֵ
	 * @param key
	 * @return BizObject
	 * @throws Exception
	 */
	public void setBizObject(String key, BizObject biz) throws Exception{
		attribute.put(key, biz);
	}
	
	/**
	 * ��ȡ��������ֵ
	 * @param key
	 * @return BizObject
	 * @throws Exception
	 */
	public BizObject getBizObject(String key) throws Exception{
		return (BizObject)attribute.get(key);
	}
	
	/**
	 * ���ó�������ֵ
	 * @param key
	 * @param obj
	 * @throws Exception
	 */
	public void setScenarioAttribute(String key,String obj) throws Exception{
		attribute.put(key, obj);
	}
	
	/**
	 * �����Ϣ
	 * @param str
	 */
	public void putMsg(String str){
		message.put(str);
	}
	
	/**
	 * ����У���Ƿ�ͨ��
	 * @param pass
	 */
	public void setPass(boolean pass){
		message.setPass(pass);
	}
	
	/**
	 * ������Ϣ�صĴ�С
	 * @return
	 */
	public int messageSize(){
		return message.size();
	}
	
	/**
	 * ��ȡ��Ϣ����
	 * @return
	 */
	public AlarmMessage getAlarmMessage(){
		return this.message;
	}
	
	/**
	 * ���󷽷���������ʵ��
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public abstract Object run(Transaction Sqlca)  throws Exception ;
}
