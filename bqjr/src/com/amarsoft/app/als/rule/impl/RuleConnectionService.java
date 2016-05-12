package com.amarsoft.app.als.rule.impl;

import java.rmi.RemoteException;

import com.amarsoft.app.als.rule.RuleRelativeConst;
import com.amarsoft.app.als.rule.util.ConfigProvider;
import com.amarsoft.are.ARE;

/**
 * 规则引擎连接服务类,从此类获取规则引擎计算结果
 * 
 * @author zszhang
 * 
 */
public class RuleConnectionService {
	
	/**
	 * 调用规则
	 * 
	 * @param modelID  模型编号
	 * @param ruleType 规则类型
	 * @param ruleID   规则编号
	 * @param objects  规则对象
	 * @param params   规则参数
	 * @return 规则计算结果
	 */
	public static String callRule(String modelID, String ruleType, String ruleID,String objects, String params) {
		String result = null;

		ConfigProvider cp = ConfigProvider.getProvider(RuleRelativeConst.RULE_CONFIG_FILE);
		if (!cp.isConfiged()) {
			ARE.getLog().error("规则服务配置文件未找到");
		} else {
			String connectMethod = cp.getProperty(RuleRelativeConst.CONNECTION_METHOD);
			if(connectMethod == null || "".equals(connectMethod)){
				ARE.getLog().error("规则服务配置文件未指定服务来源");
			}
			try {
				if ("JDK1.6".equalsIgnoreCase(connectMethod)) {
					ARE.getLog().info("---WebService为JDK1.6自带版本---");
					result = RuleEngineConnection.highJavaVersionConnection()
							.callObject("", "", "0001", modelID, ruleType, ruleID,objects, params);
				} else {
					if ("JDK1.5".equalsIgnoreCase(connectMethod)) {
						ARE.getLog().info("---WebService为Axis版本---");
						result = RuleEngineConnection.lowJavaVersionConnection().
								callObject("", "","0001", modelID, ruleType, ruleID,objects, params);
					} else {
						ARE.getLog().debug("连接方式配置错误");
					}
				}
			} catch (RemoteException e) {
				ARE.getLog().debug("获取规则引擎服务出错",e);
				e.printStackTrace();
			}
		}
		return result;
	}
}
