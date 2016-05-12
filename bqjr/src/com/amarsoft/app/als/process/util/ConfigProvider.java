package com.amarsoft.app.als.process.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

import com.amarsoft.are.ARE;
import com.amarsoft.are.io.FileTool;

public class ConfigProvider {

	private static final String DEFAULT_PROCESSENGINE_CONFIG_FILE = ARE.getProperty("APP_HOME") + "/etc/engine_config.properties";
	private static ConfigProvider configProvider = null;
	private Properties prop;
	private boolean configed;
	
	private ConfigProvider(String configFile){
		loadProperties(configFile);
	}
	
	private ConfigProvider() {
		this(DEFAULT_PROCESSENGINE_CONFIG_FILE);
	}
	
	private void loadProperties(String configFile){
		File f = FileTool.findFile(configFile);
		if(f == null || !f.exists()){
			ARE.getLog().error("流程配置文件: " + configFile + " 不存在");
			configed = false;
		}else{
			prop = new Properties();
			try {
				prop.load(new FileInputStream(f));
				configed = true;
			} catch (FileNotFoundException e) {
				ARE.getLog().debug("载入配置文件出错",e);
				e.printStackTrace();
			} catch (IOException e) {
				ARE.getLog().debug("载入配置文件出错",e);
				e.printStackTrace();
			}
		}
	}
	
	public static synchronized ConfigProvider getProvider(String configFile){
		if(configProvider == null){
			configProvider = new ConfigProvider(configFile);
		}
		return configProvider;
	}
	
	public static synchronized ConfigProvider getDefaultProvider(){
		if(configProvider == null){
			configProvider = new ConfigProvider();
		}
		return configProvider;
	}
	public String getProperty(String key){
		return prop.getProperty(key);
	}
	public String getProperty(String key, String defaultValue){
		return prop.getProperty(key, defaultValue);
	}
	public void setProperty(String key, String value){
		prop.setProperty(key, value);
	}
	public boolean isConfiged(){
		return configed;
	}
	
	public static void main(String[] args){
		ConfigProvider cp = getDefaultProvider();
		System.out.println(cp.isConfiged());
	}
}
