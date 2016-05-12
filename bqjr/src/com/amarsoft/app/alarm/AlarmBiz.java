package com.amarsoft.app.alarm;

import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 抽象类，用于所有业务预警对象相关业务逻辑处理java类都要从此类继承
 * @author syang
 * @since 2009/09/11
 *
 */
public abstract class AlarmBiz{
	private Map attribute = null;
	private AlarmMessage message = new AlarmMessage();
	
	/**
	 * 设置属性变量池，这里主要用来存放场景参数变量池的引用
	 * @param attribute
	 */
	public void setAttributePool(Map attribute) {
		this.attribute = attribute;
	}
	
	/**
	 * 获取场景属性值
	 * @param key
	 * @return
	 * @throws Exception
	 */
	public Object getAttribute(String key) throws Exception{
		return attribute.get(key);
	}
	
	/**
	 * 设置场景属性值
	 * @param key
	 * @return BizObject
	 * @throws Exception
	 */
	public void setBizObject(String key, BizObject biz) throws Exception{
		attribute.put(key, biz);
	}
	
	/**
	 * 获取场景属性值
	 * @param key
	 * @return BizObject
	 * @throws Exception
	 */
	public BizObject getBizObject(String key) throws Exception{
		return (BizObject)attribute.get(key);
	}
	
	/**
	 * 设置场景属性值
	 * @param key
	 * @param obj
	 * @throws Exception
	 */
	public void setScenarioAttribute(String key,String obj) throws Exception{
		attribute.put(key, obj);
	}
	
	/**
	 * 添加消息
	 * @param str
	 */
	public void putMsg(String str){
		message.put(str);
	}
	
	/**
	 * 设置校验是否通过
	 * @param pass
	 */
	public void setPass(boolean pass){
		message.setPass(pass);
	}
	
	/**
	 * 返回消息池的大小
	 * @return
	 */
	public int messageSize(){
		return message.size();
	}
	
	/**
	 * 获取消息对象
	 * @return
	 */
	public AlarmMessage getAlarmMessage(){
		return this.message;
	}
	
	/**
	 * 抽象方法，到子类实现
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public abstract Object run(Transaction Sqlca)  throws Exception ;
}
