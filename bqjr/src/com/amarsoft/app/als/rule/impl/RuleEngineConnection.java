package com.amarsoft.app.als.rule.impl;

import java.net.MalformedURLException;
import java.net.URL;

import com.amarsoft.app.als.rule.RuleRelativeConst;
import com.amarsoft.app.als.rule.util.ConfigProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.rule.RuleServicePortType;
import com.amarsoft.rule.RuleServices;
import com.amarsoft.rule.RuleWebServicePortType;

/**
 * �����������ӷ�����,�Ӵ����ȡ������������
 * 
 * @author zszhang
 */
public class RuleEngineConnection {
	
	/**
	 * ��java�汾��webservice���ӷ�ʽ
	 * @return RuleWebServicePortType
	 */
	public static RuleWebServicePortType lowJavaVersionConnection(){
		RuleWebServicePortType service = null;
		ConfigProvider cp = ConfigProvider.getProvider(RuleRelativeConst.RULE_CONFIG_FILE);
		String url = "";
		if(cp.isConfiged()){
			url = cp.getProperty(RuleRelativeConst.RULEENGINE_URL_KEY);
		}
		if(url == null || "".equals(url)){
			url = "http://" + RuleRelativeConst.RULEENGINE_HOST + ":" + RuleRelativeConst.RULEENGINE_PORT + "/ruleservice?wsdl";
		}
		try {
//			RuleWebServicesLocator ruleWebServicesLocator = new RuleWebServicesLocator();
//			ruleWebServicesLocator.setRuleWebServicePortEndpointAddress(url);
//			service = ruleWebServicesLocator.getRuleWebServicePort();
		} catch (Exception e) {
			ARE.getLog().debug("������������ַ����", e);
		}
		return service;
	}
	
	/**
	 * ��java�汾��webservice���ӷ�ʽ
	 * @return RuleWebServicePortType
	 */
	public static RuleServicePortType highJavaVersionConnection(){
		RuleServicePortType service = null;
		ConfigProvider cp = ConfigProvider.getProvider(RuleRelativeConst.RULE_CONFIG_FILE);
		String url = "";
		if(cp.isConfiged()){
			url = cp.getProperty(RuleRelativeConst.RULEENGINE_URL_KEY);
		}
		if(url == null || "".equals(url)){
			url = "http://" + RuleRelativeConst.RULEENGINE_HOST + ":" + RuleRelativeConst.RULEENGINE_PORT + "/ruleservice?wsdl";
		}
		try {
			URL serviceUrl = new URL(url);
			ARE.getLog().debug("serviceUrl:"+serviceUrl);
			service =new RuleServices(serviceUrl).getRuleServicePort();
		} catch (MalformedURLException e) {
			ARE.getLog().debug("������������ַ����",e);
		} 
		return service;
	}
}
