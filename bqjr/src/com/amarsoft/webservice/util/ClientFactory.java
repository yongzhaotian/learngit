package com.amarsoft.webservice.util;

import java.net.MalformedURLException;
import java.net.URL;

import javax.xml.namespace.QName;
import javax.xml.ws.Service;

import com.amarsoft.webservice.YXWebService;

public class ClientFactory extends Service {
	private static String NAME_SPACE_URL = "http://impl.webservice.amarsoft.com/";
	private static URL WSDL_DOCUMENT_LOCATION = null;
	private static QName serviceName = new QName(NAME_SPACE_URL,
			"YXWebServiceImplService");
	private static String FilePath = null;
	static {
		try {
			WSConfig ws = new WSConfig();
			ws.loadProperties("D:/WorkSpaceADE/ALS7_YX/WebContent/WEB-INF/etc/yx_webservice.properties");
			String ip = ws.getIp();
			String port = ws.getPort();
			String address = "http://" + ip + ":" + port + "/YXWebService?wsdl";
			WSDL_DOCUMENT_LOCATION = new URL(address);
		} catch (MalformedURLException e) {
			throw new RuntimeException(e);
		}
	}
	private static ClientFactory instance = new ClientFactory(WSDL_DOCUMENT_LOCATION, serviceName);

	protected ClientFactory(URL wsdlDocumentLocation, QName serviceName) {
		super(wsdlDocumentLocation, serviceName);
	}

	public static YXWebService getWebService() {
		return instance.getPort(new QName(NAME_SPACE_URL,
				"YXWebServiceImplPort"), YXWebService.class);
	}
	
}
