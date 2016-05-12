package com.amarsoft.app.billions;

/**
 * 
 * @author qulianmao
 *
 */
public class UpdateMinanUtilXML {
	
	public static final String INIT_CUSTOMERID = "10000000";

	
	/**
	 * 连接民安接口  发送数据给民安，民安实时返回退保信息
	 * 
	 */
	public static String httpPostTuiBao(BatchMingAninsuranceVo vo) throws Exception {
		//拼装数据xml 
		String xmldata="<?xml version='1.0' encoding='utf-8'?>"+
		 " <persons>"+
		  " <person>"+
		  "  <plyAppNo>"+vo.getContractNo()+"_0</plyAppNo>"+
		  "  <orgPolicyNo>"+vo.getPolicyNo()+"</orgPolicyNo> "+
		  "  <insrntCname>"+vo.getCustomerName()+"</insrntCname>"+
		  "  <insrntCertType>01</insrntCertType>"+
		  "  <insrntCertNo>"+vo.getCertid()+"</insrntCertNo>"+
		  "  </person>"+
		  "</persons>";
		
		return xmldata;
	}
	
	
	
}
