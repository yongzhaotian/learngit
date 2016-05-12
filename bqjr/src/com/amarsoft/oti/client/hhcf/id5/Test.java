package com.amarsoft.oti.client.hhcf.id5;

import org.apache.axis.encoding.Base64;

import com.amarsoft.webclient.app.QueryValidatorServices;
import com.amarsoft.webclient.app.QueryValidatorServicesProxy;

public class Test {

	public static void main(String[] args) throws Exception {
		
		String SKEY = "12345678";
		
		QueryValidatorServicesProxy proxy = new QueryValidatorServicesProxy();
		proxy.setEndpoint(ID5Constants.WSDL_URL);
		QueryValidatorServices service = proxy.getQueryValidatorServices();
		//System.setProperty("javax.net.ssl.trustStore", "CheckID.keystore");
		//System.setProperty(ContainsBean.ID5_SSL_TRUSTSTORE,ContainsBean.ID5_CHECKID_KEYSTORE);
		String username = "baiqian2014jiekou";
		String password = "baiqian2014jiekou_H=eqdZ6A";
		String dataSource = "1A020201";
		String resultXML = "";

		String param = "Áõ¾²,210204196501015829";
		
		//resultXML = service.querySingle(username, password, dataSource, param);
		resultXML = service.querySingle(DESBASE64.encode(SKEY,username.getBytes()), DESBASE64.encode(SKEY,password.getBytes()), DESBASE64.encode(SKEY,dataSource.getBytes()), DESBASE64.encode(SKEY,param.getBytes()));
		
		byte[] brXML = Base64.decode(resultXML);
		System.out.println(new String(DESBASE64.decode(SKEY, brXML)));
	}
}