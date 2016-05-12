package com.amarsoft.webservice.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

import com.amarsoft.are.ARE;
import com.amarsoft.are.io.FileTool;

public class WSConfig {

	private static final String DEFAULT_CONFIG_FILE = ARE.getProperty("APP_HOME")
			+ "/etc/yx_webservice.properties";
	private Properties prop = new Properties();
	private String ip;
	private String port;

	public void loadProperties(String FilePath) {
		String File = "";
		if("".endsWith(FilePath)||FilePath==null){
			File = DEFAULT_CONFIG_FILE;
		}else{
			File = FilePath;
		}
		
		File f = FileTool.findFile(File);
		if (f == null || !f.exists()) {
			ARE.getLog().error(
					"WebService配置文件: " + File + " 不存在");
		} else {
			try {
				InputStream is = new FileInputStream(File);
				prop.load(is);
				ip = prop.getProperty("ip");
				port = prop.getProperty("port");
			} catch (Exception e) {
				ARE.getLog().error("读取WebService配置文件异常", e);
			}
		}
	}

	/**
	 * @return the ip
	 */
	public String getIp() {
		return ip;
	}

	/**
	 * @param ip
	 *            the ip to set
	 */
	public void setIp(String ip) {
		this.ip = ip;
	}

	/**
	 * @return the port
	 */
	public String getPort() {
		return port;
	}

	/**
	 * @param port
	 *            the port to set
	 */
	public void setPort(String port) {
		this.port = port;
	}
}
