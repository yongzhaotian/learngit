package com.amarsoft.app.als.process;

import com.amarsoft.app.als.process.util.ConfigProvider;
import com.amarsoft.are.ARE;

public class ProcessServiceFactory {
	//默认流程服务实现类
	private static final String DEFAULT_PROCESS_SERVICE = "com.amarsoft.app.als.process.impl.AmarProcessService";
	//流程服务配置文件
	public static final String PROCESS_CONFIG_FILE = ARE.getProperty("APP_HOME") + "/etc/engine_config.properties";
	//配置文件设置流程服务的关键字
	private static final String PROCESS_SERVICE_SOURCE_KEY = "process_service";
	
	/**
	 * 获取流程服务实例,首先从流程服务配置文件中读取,如果配置文件不存在则获取默认的流程引擎服务
	 * @return
	 */
	public static ProcessService getService(){
		ProcessService ps = null;
		ConfigProvider cp = ConfigProvider.getProvider(PROCESS_CONFIG_FILE);
		if(!cp.isConfiged()){
			ps = getDefaultService();
		}else{
			String processServiceSource = cp.getProperty(PROCESS_SERVICE_SOURCE_KEY);
			if(processServiceSource == null || "".equals(processServiceSource)){
				ARE.getLog().error("流程服务配置文件未指定服务来源");
			}
			
			try {
				ps = getService(processServiceSource);
			} catch (InstantiationException e) {
				ARE.getLog().debug("获取流程引擎服务出错",e);
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				ARE.getLog().debug("获取流程引擎服务出错",e);
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				ARE.getLog().debug("获取流程引擎服务出错",e);
				e.printStackTrace();
			}
		}
		return ps;
	}
	
	/**
	 * 取得默认的流程引擎服务
	 * @return 流程服务
	 */
	private static ProcessService getDefaultService(){
		ProcessService ps = null;
		try {
			ps = getService(DEFAULT_PROCESS_SERVICE);
		} catch (InstantiationException e) {
			ARE.getLog().debug("获取默认流程引擎服务出错",e);
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			ARE.getLog().debug("获取默认流程引擎服务出错",e);
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			ARE.getLog().debug("获取默认流程引擎服务出错",e);
			e.printStackTrace();
		}
		return ps;
	}
	
	/**
	 * 取得指定的流程服务
	 * @param processServiceSource 流程服务提供类
	 * @return 流程服务
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws ClassNotFoundException
	 */
	private static ProcessService getService(String processServiceSource) throws InstantiationException, IllegalAccessException, ClassNotFoundException{
		return (ProcessService)Class.forName(processServiceSource).newInstance();
	}
	
	public static void main(String[] args){
	}
}
