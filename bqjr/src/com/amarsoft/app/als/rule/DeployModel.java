package com.amarsoft.app.als.rule;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;

import com.amarsoft.app.als.rule.impl.RuleConnectionService;
import com.amarsoft.app.als.rule.impl.RuleEngineConnection;
import com.amarsoft.app.als.rule.util.ConfigProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.core.object.ResultObject;
import com.amarsoft.core.util.FileUtil;
import com.amarsoft.rule.RuleServicePortType;
import com.amarsoft.rule.RuleServices;

public class DeployModel {

	/**
	 * 发布规则
	 * @param sDeployType 	发布类型，可设定为deploy或者update
	 * @param sModelID    	调用的规则模型
	 * @param sRuleType		规则类型
	 * @param sRuleID		规则编号
	 * @param sPatch		文件地址
	 * @param sVersion		版本编号
	 * @throws Exception
	 */
	public String getRoleDeploy(String sDeployType,String sModelID,String sPatch,String sVersion) throws Exception {
		// 定义相关变量
		String sAPP = "A001";// 应用编号，目前可随便设置
		String sUser = "ruleservice";// 调用规则的用户，目前可随便设置
		String sPassword = "ruleservice";// 调用规则的用户密码，目前可随便设置
		//String sVersion = "1";// 规则版本编号
		String sParam = "";// 规则调用参数
		String sProperty = "";// 属性
		String sRemark = "";// 备注
		String sFileString = "";//文件的字符串内容
		
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
			ARE.getLog().debug("解析引擎服务地址出错",e);
		} 
		// 读入文件到字符串
		File file = new File(sPatch);
		sFileString = FileUtil.file2String(file);
		// 调用规则引擎发布功能
		String sResult = service.deploy(sUser, sPassword, sAPP, "", sDeployType, "", sFileString,
				sProperty, sRemark);
		System.out.println(sResult);
		ResultObject resultObject = new ResultObject(sResult);
		System.out.println("流程选择:" + resultObject.getResult("STATUS", ""));
		
		return resultObject.getResult("STATUS", "");
	}
}
