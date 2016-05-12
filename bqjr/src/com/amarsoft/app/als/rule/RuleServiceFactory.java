package com.amarsoft.app.als.rule;

import com.amarsoft.app.als.rule.util.ConfigProvider;
import com.amarsoft.are.ARE;

public class RuleServiceFactory {
	
	/**
	 * 获取规则服务实例,首先从规则服务配置文件中读取,如果配置文件不存在则获取默认的规则引擎服务
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
					ARE.getLog().warn("规则服务配置文件未指定服务来源,启用默认服务:["+RuleRelativeConst.DEFAULT_RULE_SERVICE+"]");
					rs = getDefaultService();
				}else{
					ARE.getLog().info("启用服务:["+ruleServiceSource+"]");
					rs = getService(ruleServiceSource);
				}
			} catch (InstantiationException e) {
				ARE.getLog().debug("获取规则引擎服务出错", e);
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				ARE.getLog().debug("获取规则引擎服务出错", e);
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				ARE.getLog().debug("获取规则引擎服务出错", e);
				e.printStackTrace();
			}
		}
		return rs;
	}
	
	/**
	 * 取得默认的规则引擎服务
	 * @return 规则服务
	 */
	private static RuleService getDefaultService(){
		RuleService rs = null;
		try {
			rs = getService(RuleRelativeConst.DEFAULT_RULE_SERVICE);
		} catch (InstantiationException e) {
			ARE.getLog().debug("获取默认规则引擎服务出错",e);
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			ARE.getLog().debug("获取默认规则引擎服务出错",e);
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			ARE.getLog().debug("获取默认规则引擎服务出错",e);
			e.printStackTrace();
		}
		return rs;
	}
	
	/**
	 * 取得指定的规则服务
	 * @param  ruleServiceSource 规则服务提供类
	 * @return 规则服务
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
