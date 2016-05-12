package com.amarsoft.webservice.servlet;

import com.amarsoft.webservice.impl.YXWebServiceImpl;
import com.sun.xml.internal.ws.transport.http.server.EndpointImpl;

public class JDKServerMain {
	public static void main(String[] args) {
		EndpointImpl.publish("http://localhost:8888/YXWebService",new YXWebServiceImpl());
		System.out.println("服务启动,正在监听...");
	}
}