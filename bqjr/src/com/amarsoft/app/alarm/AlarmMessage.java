package com.amarsoft.app.alarm;

import java.util.Vector;

/**
 * �Զ�����̽����Ϣ����
 * @author syang 2009/09/15
 *
 */

public class AlarmMessage {
	/**
	 * �Ƿ�ͨ��
	 */
	private boolean pass = false;
	
	/**
	 * ��Ϣ����
	 */
	private Vector message = null;
	
	/**
	 * ���캯����ִ�г�ʼ������
	 */
	public AlarmMessage(){
		message = new Vector();
		pass = false;
	}

	/**
	 * �����Ϣ
	 * @param str ��Ϣ����
	 */
	public void put(String str){
		message.add(str);
	}
	
	/**
	 * ��������ȡ��Ϣ���ݣ��������ֵ������Ϣ�أ��򷵻ؿ�ֵ
	 * @param index ������
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
	 * ������Ϣ�ش�С
	 * @return
	 */
	public int size(){
		return message.size();
	}
	/**
	 * ��λ
	 */
	public void reset(){
		this.pass = false;
		this.clear();
	}
	/**
	 * �����Ϣ����
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
