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
	 * ��������
	 * @param sDeployType 	�������ͣ����趨Ϊdeploy����update
	 * @param sModelID    	���õĹ���ģ��
	 * @param sRuleType		��������
	 * @param sRuleID		������
	 * @param sPatch		�ļ���ַ
	 * @param sVersion		�汾���
	 * @throws Exception
	 */
	public String getRoleDeploy(String sDeployType,String sModelID,String sPatch,String sVersion) throws Exception {
		// ������ر���
		String sAPP = "A001";// Ӧ�ñ�ţ�Ŀǰ���������
		String sUser = "ruleservice";// ���ù�����û���Ŀǰ���������
		String sPassword = "ruleservice";// ���ù�����û����룬Ŀǰ���������
		//String sVersion = "1";// ����汾���
		String sParam = "";// ������ò���
		String sProperty = "";// ����
		String sRemark = "";// ��ע
		String sFileString = "";//�ļ����ַ�������
		
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
		// �����ļ����ַ���
		File file = new File(sPatch);
		sFileString = FileUtil.file2String(file);
		// ���ù������淢������
		String sResult = service.deploy(sUser, sPassword, sAPP, "", sDeployType, "", sFileString,
				sProperty, sRemark);
		System.out.println(sResult);
		ResultObject resultObject = new ResultObject(sResult);
		System.out.println("����ѡ��:" + resultObject.getResult("STATUS", ""));
		
		return resultObject.getResult("STATUS", "");
	}
}
