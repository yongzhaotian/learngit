package com.amarsoft.app.als.rule;

import com.amarsoft.app.als.rule.util.ConfigProvider;
import com.amarsoft.are.ARE;

public class RuleServiceFactory {
	
	/**
	 * ��ȡ�������ʵ��,���ȴӹ�����������ļ��ж�ȡ,��������ļ����������ȡĬ�ϵĹ����������
	 * @return
	 */
	public static RuleService getRuleService(String ID){
		RuleService rs = null;
		ConfigProvider cp = ConfigProvider.getProvider(RuleRelativeConst.RULE_CONFIG_FILE);
		if(!cp.isConfiged()){
			rs = getDefaultService();
		}else{
			String ruleServiceSource = cp.getProperty(ID);
			try {
				if (ruleServiceSource == null || "".equals(ruleServiceSource)) {
					ARE.getLog().warn("������������ļ�δָ��������Դ,����Ĭ�Ϸ���:["+RuleRelativeConst.DEFAULT_RULE_SERVICE+"]");
					rs = getDefaultService();
				}else{
					ARE.getLog().info("���÷���:["+ruleServiceSource+"]");
					rs = getService(ruleServiceSource);
				}
			} catch (InstantiationException e) {
				ARE.getLog().debug("��ȡ��������������", e);
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				ARE.getLog().debug("��ȡ��������������", e);
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				ARE.getLog().debug("��ȡ��������������", e);
				e.printStackTrace();
			}
		}
		return rs;
	}
	
	/**
	 * ȡ��Ĭ�ϵĹ����������
	 * @return �������
	 */
	private static RuleService getDefaultService(){
		RuleService rs = null;
		try {
			rs = getService(RuleRelativeConst.DEFAULT_RULE_SERVICE);
		} catch (InstantiationException e) {
			ARE.getLog().debug("��ȡĬ�Ϲ�������������",e);
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			ARE.getLog().debug("��ȡĬ�Ϲ�������������",e);
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			ARE.getLog().debug("��ȡĬ�Ϲ�������������",e);
			e.printStackTrace();
		}
		return rs;
	}
	
	/**
	 * ȡ��ָ���Ĺ������
	 * @param  ruleServiceSource ��������ṩ��
	 * @return �������
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws ClassNotFoundException
	 */
	private static RuleService getService(String ruleServiceSource) throws InstantiationException, IllegalAccessException, ClassNotFoundException{
		return (RuleService)Class.forName(ruleServiceSource).newInstance();
	}
	
	public static void main(String[] args){
	}
}
