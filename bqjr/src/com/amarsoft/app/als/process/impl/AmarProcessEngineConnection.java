package com.amarsoft.app.als.process.impl;

import java.net.MalformedURLException;
import java.net.URL;

import com.amarsoft.app.als.process.ProcessServiceFactory;
import com.amarsoft.app.als.process.util.ConfigProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.flow.FlowServices;

/**
 * 流程引擎连接类,从此类获取应用系统到流程引擎的webService连接
 * @author zszhang
 *
 */
public class AmarProcessEngineConnection {

	private static final String PROCESSENGINE_CONFIG_FILE = ProcessServiceFactory.PROCESS_CONFIG_FILE;
	private static final String PROCESSENGINE_URL_KEY = "amarprocessengine_url";
	private static final String PROCESSENGINE_HOST = "localhost";//192.168.5.53
	private static final String PROCESSENGINE_PORT = "8000";
	
	private static AmarProcessEngineConnection amarPEConn = null;
	private FlowServices services = null;
	
	private AmarProcessEngineConnection(){
		ConfigProvider cp = ConfigProvider.getProvider(PROCESSENGINE_CONFIG_FILE);
		String url = "";
		if(cp.isConfiged()){
			url = cp.getProperty(PROCESSENGINE_URL_KEY);
		}
		if(url == null || "".equals(url)){
			url = "http://" + PROCESSENGINE_HOST + ":" + PROCESSENGINE_PORT + "/flowservice?wsdl";
		}
		try {
			URL serviceUrl = new URL(url);
			services = new FlowServices(serviceUrl);
		} catch (MalformedURLException e) {
			ARE.getLog().debug("解析引擎服务地址出错",e);
		} 
	}
	
	public static synchronized AmarProcessEngineConnection getPEConn(){
		if(amarPEConn == null){
			amarPEConn = new AmarProcessEngineConnection();
		}
		return amarPEConn;
	}
	
	public FlowServices getFlowService(){
		return this.services;
	}
	
	public static void main(String[] args) throws Exception {
	}
}
