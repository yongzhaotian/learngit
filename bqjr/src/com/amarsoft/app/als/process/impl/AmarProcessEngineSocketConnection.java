package com.amarsoft.app.als.process.impl;

import com.amarsoft.app.als.process.ProcessServiceFactory;
import com.amarsoft.app.als.process.util.ConfigProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.trade.TradeObject;

/**
 * 流程引擎连接类,从此类获取应用系统到流程引擎的Socket连接
 * @author zszhang
 *
 */
public class AmarProcessEngineSocketConnection {

	private static final String PROCESSENGINE_CONFIG_FILE = ProcessServiceFactory.PROCESS_CONFIG_FILE;
	private static final String PROCESSENGINE_SOCKETHOST_KEY = "amarprocessengine_sockethost";
	private static final String PROCESSENGINE_SOCKETPORT_KEY = "amarprocessengine_socketport";
	private static final String PROCESSENGINE_HOST = "localhost";
	private static final String PROCESSENGINE_SOCKET_PORT = "7999";
	
	private static AmarProcessEngineSocketConnection amarPEConn = null;
	private String host = ""; //流程引擎主机
	private String port = ""; //流程引擎SOCKET端口
	
	private AmarProcessEngineSocketConnection(){
		ConfigProvider cp = ConfigProvider.getProvider(PROCESSENGINE_CONFIG_FILE);
		if (cp.isConfiged()) {
			host = cp.getProperty(PROCESSENGINE_SOCKETHOST_KEY);
			port = cp.getProperty(PROCESSENGINE_SOCKETPORT_KEY);
		} else {
			host = PROCESSENGINE_HOST;
			port = PROCESSENGINE_SOCKET_PORT;
		}
	}
	
	public static synchronized AmarProcessEngineSocketConnection getPEConn(){
		if(amarPEConn == null){
			amarPEConn = new AmarProcessEngineSocketConnection();
		}
		return amarPEConn;
	}
	
	/**
	 * 取得到流程引擎的Socket交易对象
	 * @return
	 */
	public TradeObject getTradeObject(){
		TradeObject tradeObject = null;
		try {
			tradeObject = new TradeObject(host, Integer.parseInt(port), false, "");
		} catch (Exception e){
			ARE.getLog().debug("获取流程引擎交易对象出错：",e);
		}
		return tradeObject;
	}
	
	/**
	 * 取得引擎SOCKET服务器地址
	 * @return
	 */
	public String getHost(){
		return this.host;
	}
	
	/**
	 * 取得引擎SOCKET服务器端口
	 * @return
	 */
	public String getPort(){
		return this.port;
	}
	
	public static void main(String[] args) throws Exception {
		AmarProcessEngineSocketConnection ac = AmarProcessEngineSocketConnection.getPEConn();
		TradeObject to = ac.getTradeObject();
		System.out.println(to.IP + ":" + to.Port);
	}
}
