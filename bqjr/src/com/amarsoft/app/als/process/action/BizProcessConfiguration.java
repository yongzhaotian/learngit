package com.amarsoft.app.als.process.action;

/**
 * ��ҵ����ص��������ýӿ�.<br>
 * <ul>��Ҫ����������������:
 * <li>ҵ�����̶���JBO
 * <li>ҵ����������JBO
 * <li>ҵ���������JBO
 * <li>ҵ�����̸�������JBO
 * <li>�����̶�Ӧ��������(�ɶ��)
 * <li>�����̶�Ӧ��������(�ɶ��)
 * @author zshznag
 *
 */
public interface BizProcessConfiguration {

	/**
	 * �������̶�����ȡ��ҵ�����̶���JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessObjectClaz(String processDefID);
	
	/**
	 * �������̶�����ȡ��ҵ����������JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessTaskClaz(String processDefID);
	
	/**
	 * �������̶�����ȡ��ҵ�����̸�������JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessMultiTaskClaz(String processDefID);
	
	/**
	 * �������̶�����ȡ��ҵ���������JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessOpinionClaz(String processDefID);
	
}
