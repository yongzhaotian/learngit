package com.amarsoft.app.als.process.action;

/**
 * ����ʵ�ֻ�����ҵ�������������Ի�ȡ����.Ĭ���������������ص�ҵ����Ϣ�����ڴ������,����λ��Ϊ:<BR>
 * CodeNo:ProcessConfiguration,ItemNo:�ض������̶�����
 * @author zszhang
 *
 */
public class BaseBizProcessConfiguration implements BizProcessConfiguration {
	private static final String PROCESSOBJECT_DEFAULT_CLASS = "jbo.app.FLOW_OBJECT"; //ҵ�����̶���Ĭ��JBO
	private static final String PROCESSTASK_DEFAULT_CLASS = "jbo.app.FLOW_TASK"; //ҵ����������Ĭ��JBO
	private static final String PROCESSMULTITASK_DEFAULT_CLASS = "jbo.app.FLOW_MULTITASK"; //ҵ����������Ĭ��JBO
	private static final String PROCESSOPINION_DEFAULT_CLASS = "jbo.app.FLOW_OPINION"; //ҵ���������Ĭ��JBO
	
	/**
	 * �������̶�����ȡ��ҵ�����̶���JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessObjectClaz(String processDefID){
		return PROCESSOBJECT_DEFAULT_CLASS;
	}
	
	/**
	 * �������̶�����ȡ��ҵ����������JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessTaskClaz(String processDefID){
		return PROCESSTASK_DEFAULT_CLASS;
	}
	
	/**
	 * �������̶�����ȡ��ҵ�����̸�������JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessMultiTaskClaz(String processDefID){
		return PROCESSMULTITASK_DEFAULT_CLASS;
	}
	
	/**
	 * �������̶�����ȡ��ҵ���������JBO
	 * @param processDefID
	 * @return
	 */
	public String getBizProcessOpinionClaz(String processDefID){
		return PROCESSOPINION_DEFAULT_CLASS;
	}
	
}
