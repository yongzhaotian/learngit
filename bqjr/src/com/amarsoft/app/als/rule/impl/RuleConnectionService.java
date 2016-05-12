package com.amarsoft.app.als.rule.impl;

import java.rmi.RemoteException;

import com.amarsoft.app.als.rule.RuleRelativeConst;
import com.amarsoft.app.als.rule.util.ConfigProvider;
import com.amarsoft.are.ARE;

/**
 * �����������ӷ�����,�Ӵ����ȡ�������������
 * 
 * @author zszhang
 * 
 */
public class RuleConnectionService {
	
	/**
	 * ���ù���
	 * 
	 * @param modelID  ģ�ͱ��
	 * @param ruleType ��������
	 * @param ruleID   ������
	 * @param objects  �������
	 * @param params   �������
	 * @return ���������
	 */
	public static String callRule(String modelID, String ruleType, String ruleID,String objects, String params) {
		String result = null;

		ConfigProvider cp = ConfigProvider.getProvider(RuleRelativeConst.RULE_CONFIG_FILE);
		if (!cp.isConfiged()) {
			ARE.getLog().error("������������ļ�δ�ҵ�");
		} else {
			String connectMethod = cp.getProperty(RuleRelativeConst.CONNECTION_METHOD);
			if(connectMethod == null || "".equals(connectMethod)){
				ARE.getLog().error("������������ļ�δָ��������Դ");
			}
			try {
				if ("JDK1.6".equalsIgnoreCase(connectMethod)) {
					ARE.getLog().info("---WebServiceΪJDK1.6�Դ��汾---");
					result = RuleEngineConnection.highJavaVersionConnection()
							.callObject("", "", "0001", modelID, ruleType, ruleID,objects, params);
				} else {
					if ("JDK1.5".equalsIgnoreCase(connectMethod)) {
						ARE.getLog().info("---WebServiceΪAxis�汾---");
						result = RuleEngineConnection.lowJavaVersionConnection().
								callObject("", "","0001", modelID, ruleType, ruleID,objects, params);
					} else {
						ARE.getLog().debug("���ӷ�ʽ���ô���");
					}
				}
			} catch (RemoteException e) {
				ARE.getLog().debug("��ȡ��������������",e);
				e.printStackTrace();
			}
		}
		return result;
	}
}
