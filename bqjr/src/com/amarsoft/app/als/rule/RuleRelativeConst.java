package com.amarsoft.app.als.rule;

/**
 * 规则引擎连接统一常量定义类
 * @author zszhang
 *
 */
public class RuleRelativeConst {
	
	//默认规则服务实现类
	public static final String DEFAULT_RULE_SERVICE = "com.amarsoft.app.als.rule.impl.RuleDefaultService";
	//规则服务默认配置文件
	public static final String DEFAULT_RULE_CONFIG_FILE = "etc/engine_config.properties";
	//规则服务配置文件
	public static final String RULE_CONFIG_FILE = "etc/engine_config.properties";
	//规则引擎连接地址关键字
	public static final String RULEENGINE_URL_KEY = "AmarRuleEngine_URL";
	//webService连接方式关键字
	public static final String CONNECTION_METHOD = "Connection_Method";
	//默认连接地址
	public static final String RULEENGINE_HOST = "localhost";
	//默认连接端口
	public static final String RULEENGINE_PORT = "9000";
}
