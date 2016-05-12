package com.amarsoft.oti.client.hhcf.id5;

import java.rmi.RemoteException;
import java.util.List;

import com.amarsoft.webclient.app.QueryValidatorServices;
import com.amarsoft.webclient.app.QueryValidatorServicesProxy;

public class ID5Client {
	private static ID5Client ID5CLIENT = null;
	
	
	
	private ID5Client(){
		ID5CLIENT = new ID5Client();
	}
	
	
	/**
	 * @return ID5CLIENT
	 */
	public synchronized static ID5Client getID5Instace(){
		if(ID5CLIENT == null)	new ID5Client();
		return ID5CLIENT;
	}
	
	
	/**
	 * @param userName
	 * @param certCard
	 * @return boolean
	 * @throws RemoteException 
	 */
	public boolean chetcked(List UserNames,List CertCardIDs) throws RemoteException{
		//CheckID.keystore
		//System.setProperty(ID5Constants.ID5_SSL_TRUSTSTORE,ID5Constants.ID5_CHECKID_KEYSTORE);
		QueryValidatorServicesProxy proxy = new QueryValidatorServicesProxy();
		proxy.setEndpoint(ID5Constants.WSDL_URL);
		QueryValidatorServices service = proxy.getQueryValidatorServices();
		System.setProperty("javax.net.ssl.trustStore", "CheckID.keystore");
		//System.setProperty(ID5Constants.ID5_SSL_TRUSTSTORE,ID5Constants.ID5_CHECKID_KEYSTORE);
		String resultXML = "";
		if(UserNames.size() != CertCardIDs.size()){
			
		}
		
		String param = "Áõ¾²,210204196501015829";

		return true;
	}
	
	
}