package com.amarsoft.app.als.process.impl;

import com.amarsoft.app.als.process.ProcessServiceFactory;
import com.amarsoft.app.als.process.util.ConfigProvider;
import com.amarsoft.are.ARE;
import com.amarsoft.trade.TradeObject;

/**
 * ��������������,�Ӵ����ȡӦ��ϵͳ�����������Socket����
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
	private String host = ""; //������������
	private String port = ""; //��������SOCKET�˿�
	
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
	 * ȡ�õ����������Socket���׶���
	 * @return
	 */
	public TradeObject getTradeObject(){
		TradeObject tradeObject = null;
		try {
			tradeObject = new TradeObject(host, Integer.parseInt(port), false, "");
		} catch (Exception e){
			ARE.getLog().debug("��ȡ�������潻�׶������",e);
		}
		return tradeObject;
	}
	
	/**
	 * ȡ������SOCKET��������ַ
	 * @return
	 */
	public String getHost(){
		return this.host;
	}
	
	/**
	 * ȡ������SOCKET�������˿�
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
