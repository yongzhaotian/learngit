package com.amarsoft.app.alarm;

import java.util.Vector;

/**
 * 自动风险探测消息容器
 * @author syang 2009/09/15
 *
 */

public class AlarmMessage {
	/**
	 * 是否通过
	 */
	private boolean pass = false;
	
	/**
	 * 消息容器
	 */
	private Vector message = null;
	
	/**
	 * 构造函数，执行初始化工作
	 */
	public AlarmMessage(){
		message = new Vector();
		pass = false;
	}

	/**
	 * 添加消息
	 * @param str 消息内容
	 */
	public void put(String str){
		message.add(str);
	}
	
	/**
	 * 根据索引取消息数据，如果索引值大于消息池，则返回空值
	 * @param index 索引号
	 * @return
	 */
	public String getMessage(int index){
		if(message.size() >= (index+1)){
			return (String)message.get(index);
		}else{
			return null;
		}
	}
	
	/**
	 * 返回消息池大小
	 * @return
	 */
	public int size(){
		return message.size();
	}
	/**
	 * 复位
	 */
	public void reset(){
		this.pass = false;
		this.clear();
	}
	/**
	 * 清除消息内容
	 */
	public void clear(){
		message.clear();
	}
	
	public boolean isPass() {
		return pass;
	}

	public void setPass(boolean pass) {
		this.pass = pass;
	}
}
