package com.amarsoft.webservice.servlet;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import com.amarsoft.are.ARE;
import com.amarsoft.webservice.impl.YXWebServiceImpl;
import com.amarsoft.webservice.util.WSConfig;
import com.sun.xml.internal.ws.transport.http.server.EndpointImpl;


/**
 * ����WebService�����
 * @version 1.0
 * @author Fmwu
 */
public class InitWebServiceServlet extends HttpServlet implements Servlet{
	private static final long serialVersionUID = 1L;

	/**
	 * ��ʼ��Servlet 
	 * @see javax.servlet.GenericServlet#init()
	 */
	public void init() throws ServletException {
		super.init();

		ARE.getLog().info("[AWE] **********************************InitWebService Start*********************************");
		try {
			
			WSConfig ws = new WSConfig();
			ws.loadProperties("");
			String ip = ws.getIp();
			String port = ws.getPort();
			String address = "http://"+ip+":"+port+"/YXWebService";
			EndpointImpl.publish(address,new YXWebServiceImpl());
			ARE.getLog().info("[WebService]********"+address+"?wsdl*********��������,���ڼ���*********");

		} catch (Exception e) {
			ARE.getLog().error("InitWebService Config:error",e);
			e.printStackTrace();
		}
		
		ARE.getLog().info("[AWE] **********************************InitWebService Success*********************************");
		ARE.getLog().info("");
	}

	public void destroy() {
		super.destroy();
	}
}
