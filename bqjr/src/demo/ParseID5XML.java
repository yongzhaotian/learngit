package demo;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.rmi.RemoteException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.apache.axis.encoding.Base64;
import org.w3c.dom.Attr;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.amarsoft.webclient.app.QueryValidatorServices;
import com.amarsoft.webclient.app.QueryValidatorServicesProxy;

import com.amarsoft.oti.client.hhcf.id5.DESBASE64;
import com.amarsoft.oti.client.hhcf.id5.ID5Constants;


public class ParseID5XML {
	
	public static Map<String, String> XML_MAP = new HashMap<String, String>();
	static {
		XML_MAP.put("A1000", "");
	};
	
	/**
	 * ���nodeXPath Ϊnull��մ�ʱ��ֵĬ��Ϊ"/data"
	 * @param xmlPath xml�ļ�·��
	 * @param nodeXPath xpath������
	 * @return
	 * @throws Exception
	 */
	public static List<BQNode> runParserTemp(String xmlPath, String nodeXPath) throws Exception {
		
		if (nodeXPath==null || nodeXPath.length()<=0) nodeXPath = "/data";
			
		XPathDocument xPathDoc = XPathDocument.getInstance(xmlPath);
        xPathDoc.parseNodeListByXPath(nodeXPath);
        
        return XPathDocument.bqList;
	}
	
	/**
	 * ���nodeXPath Ϊnull��մ�ʱ��ֵĬ��Ϊ"/data"
	 * @param xmlPath xml�ļ�·��
	 * @param xmlResult ��ѯ�ķ���xml�ı��ַ���
	 * @return
	 * @throws Exception
	 */
	public static List<BQNode> runParser(String xmlResult, String nodeXPath) throws Exception {
		
		if (nodeXPath==null || nodeXPath.length()<=0) nodeXPath = "/data";
		
		InputStream is = new ByteArrayInputStream(xmlResult.getBytes());
		XPathDocument xPathDoc = XPathDocument.getInstance(is);
        xPathDoc.parseNodeListByXPath(nodeXPath);
        
        return XPathDocument.bqList;
	}
	
	/**
	 * ���ı��ļ�ת��StringBuffer
	 * @param xmlPath �ļ�·��
	 * @return
	 * @throws Exception
	 */
	public static StringBuffer readXmlToResult(String xmlPath) throws Exception {
		
		StringBuffer sb = new StringBuffer();
        BufferedReader br = new BufferedReader(new FileReader(xmlPath));
        String line = null;
        
        while ((line=br.readLine()) != null) {
        	sb.append(line).append("\n");
        }
        br.close();
        
        return sb;
	}
	
	public static String runQueryData(String dataSource, String param) throws Exception {
		String resultXml = "";
		
		// �����������Ƿ���ȷ
		if (Arrays.asList("1A020201","1B010101","1B020101","1E010201","1E010202","1E010203").contains(dataSource)) {
			/*
			1A020201 �����Ϣ��֤
			1B010101 ѧ�����
			1B020101 ѧ�����
			1E010201 ��ʻ֤�ȶ�
			1E010202 ��ʻ֤��ʵ
			1E010203 ��ʻ֤�˲�ȶ�
			PARAM�� ���������֤��
			                ����,510104197509202629*/
		} else if (Arrays.asList("1C010101","1C010102").contains(dataSource)) {
			/*1C010101 ���Ź̻���Ϣ��ѯ A
			PARAM����λ�绰����λ����("")��ʡID����������
			               01088888888,����ͨ,BJ,����
			1C010102 ���Ź̻���Ϣ��ѯ B
			PARAM����ͥ�绰����ͥ��ַ("")��ʡID����������
			               01088888888,����ͨ,BJ,����*/
		} else if (Arrays.asList("1C010103").contains(dataSource)) {
			/*1C010103 ���Ź̻��ۺ�
			PARAM���绰����λ����("")����λ��ַ("")����ͥ��ַ("")��Ψһ��ʶ
			               01088888888,����ͨ,������,XX,123456789*/
		} else if (Arrays.asList("1G010101","1C1G01").contains(dataSource)) {
			/*1G010101 ��ͨ�̻���Ϣ��ѯ A
			1C1G01 �̻��ۺϲ�ѯ(����+��ͨ)
			PARAM���绰������("")����ַ("")
			               01082512114,������������,�Ƽ����޹�˾,����������*/
		} else if (Arrays.asList("1E020201","1E020202","1E020208").contains(dataSource)) {
			/*1E020201 ��ʻ֤�����˱ȶ�
			1E020202 ��ʻ֤�����˺�ʵ
			1E020208 ��ʻ֤�����˺˲�ȶ�
			PARAM�����������֤�ţ����ƺ��룬��������
			               ����,510104197509202629,�� AA8888,02*/
		} else if (Arrays.asList("1E020203","1E020204").contains(dataSource)) {
			/*1E020203 ��ʻ֤�������űȶ�
			1E020204 ��ʻ֤���ܺűȶ�
			PARAM�����ܺź���λ,���֤��,���ƺ���,��������
			               1234,510104197509202629,�� AA8888,02*/
		} else if (Arrays.asList("1E020205","1E020206","1E020207").contains(dataSource)) {
			/*1E020205 ��ʻ֤�������źͳ��ܺűȶ�
			PARAM���������ź���λ/���ܺź���λ,���֤��,���ƺ���,������
			               1234/2132,510104197509202629,�� AA8888,02
			1E020206 ��ʻ֤�������ź������˱ȶ�
			PARAM���������ź���λ/������,���֤��,���ƺ���,��������
			                1234/����,510104197509202629,�� AA8888,02
			1E020207 ��ʻ֤���ܺź������˱ȶ�
			PARAM�����ܺź���λ/������,���֤��,���ƺ���,��������
			                1234/����,510104197509202629,�� AA8888,02*/
		} else if (Arrays.asList("1Y010401","1Y010402","1Y010403").contains(dataSource)) {
			/*1Y010401 ͬ��ͬ�� A
			1Y010402 ͬ��ͬ�� B
			1Y010403 ͬ��ͬ�� C
			PARAM������,�Ա�,ʡ��������,������,������,������,����(""),����(""),����("")
			               ����,1,110000,1997,12,29,1,1,��*/
		} else if (Arrays.asList("1Y020401").contains(dataSource)) {
			/*1Y020401 ͬ��ͬ��ͬ����
			PARAM������,�Ա�,ʡ��������,������,������,������,����,����,����
			              ,,110000,1997,12,29*/
		} else if (Arrays.asList("1Y030402").contains(dataSource)) {
			/*1Y030402 ͬ��ͬ��ͬ������Ʒ A
			PARAM������,�Ա�,ʡ��������,������,������,������,����,����,����
			              ,,,1997,12,29*/
		} else if (Arrays.asList("1Y010404","1Y010405","1Y010406","1Y010407").contains(dataSource)) {
			/*1Y010404 ͬ��ͬ�� D
			1Y010405 ͬ��ͬ�� E
			1Y010406 ͬ��ͬ�� F
			1Y010407 ͬ��ͬ�� G
			PARAM������
			                ����*/
		}
		
		resultXml = bqQuerySingle(dataSource, param);
		
		return new String(DESBASE64.decode(ID5Constants.SKEY, Base64.decode(resultXml)));
	}

	/**
	 * ��ѯ����ͨweb������
	 * @param dataSource
	 * @param param
	 * @return
	 * @throws Exception
	 * @throws RemoteException
	 */
	private static String bqQuerySingle(String dataSource, String param)
			throws Exception, RemoteException {
		String resultXml;
		// ����webservice�ӿڲ�ѯ������������wsdl���ɵĿͻ��ˣ�
		QueryValidatorServicesProxy proxy = new QueryValidatorServicesProxy();
		proxy.setEndpoint(ID5Constants.WSDL_URL);
		QueryValidatorServices service = proxy.getQueryValidatorServices();
		//System.setProperty(ContainsBean.ID5_SSL_TRUSTSTORE,ContainsBean.ID5_CHECKID_KEYSTORE);
			
		// base64 ���ܲ�ѯ����
		String encryptKey = DESBASE64.encode(ID5Constants.SKEY,ID5Constants.ID5_USERNAME.getBytes());
		String encryptPasswd = DESBASE64.encode(ID5Constants.SKEY,ID5Constants.ID5_PASSWORD.getBytes());
		String encryptDatasource = DESBASE64.encode(ID5Constants.SKEY,dataSource.getBytes());
		String encryptParam = DESBASE64.encode(ID5Constants.SKEY,param.getBytes());
		resultXml = service.querySingle(encryptKey, encryptPasswd, encryptDatasource, encryptParam);
		
		return resultXml;
	}
	
	/**
	 * �������ݵ����ݿ�
	 * @param dataSource
	 */
	public static void saveQueyData(String dataSource) {
		
	}
	
	public static void main(String[] args) throws Exception {
		
		String xmlPath = "a1000telphone/a1000phone.xml";
		//xmlPath = "idquery.xml";
		List<BQNode> bqNodeList = null;
		/*bqNodeList = runParserTemp(xmlPath, null);
		
        for (BQNode bqNode: bqNodeList) {
        	System.out.println(bqNode);
        }
        
        
        xmlPath = "namesexsame/enamesexsame.xml";*/
        //xmlPath = "a1000telphone/successbunodata.xml";
        
        bqNodeList = runParser(readXmlToResult(xmlPath).toString(), null);
        for (BQNode bqNode: bqNodeList) {
        	System.out.println(bqNode);
        }
        
        /*XPath xpath = XPathFactory.newInstance().newXPath();
        XPathExpression xpathExp = xpath.compile("/data/telecomInfos/telecomInfo");
        NodeList nodeList = (NodeList) xpathExp.evaluate(new InputSource(new FileReader(xmlPath)), XPathConstants.NODESET);
        
        for (int i=0; i<nodeList.getLength(); i++) {
        	Node node = nodeList.item(i);
        	NamedNodeMap attrMap = node.getAttributes();
        	for (int id=0; id<attrMap.getLength(); id++) {
        		Attr attr = (Attr) attrMap.item(id);
        		System.out.println(attr.getName() + ": " + attr.getValue());
        	}
        }*/
	}
	
}
