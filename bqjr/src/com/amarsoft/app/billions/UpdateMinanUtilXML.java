package com.amarsoft.app.billions;

/**
 * 
 * @author qulianmao
 *
 */
public class UpdateMinanUtilXML {
	
	public static final String INIT_CUSTOMERID = "10000000";

	
	/**
	 * �����񰲽ӿ�  �������ݸ��񰲣���ʵʱ�����˱���Ϣ
	 * 
	 */
	public static String httpPostTuiBao(BatchMingAninsuranceVo vo) throws Exception {
		//ƴװ����xml 
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
