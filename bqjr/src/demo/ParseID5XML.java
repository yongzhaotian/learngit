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
	 * 如果nodeXPath 为null或空串时，值默认为"/data"
	 * @param xmlPath xml文件路径
	 * @param nodeXPath xpath解析串
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
	 * 如果nodeXPath 为null或空串时，值默认为"/data"
	 * @param xmlPath xml文件路径
	 * @param xmlResult 查询的返回xml文本字符串
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
	 * 将文本文件转成StringBuffer
	 * @param xmlPath 文件路径
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
		
		// 检测参数传入是否正确
		if (Arrays.asList("1A020201","1B010101","1B020101","1E010201","1E010202","1E010203").contains(dataSource)) {
			/*
			1A020201 身份信息认证
			1B010101 学历审核
			1B020101 学籍审核
			1E010201 驾驶证比对
			1E010202 驾驶证核实
			1E010203 驾驶证核查比对
			PARAM： 姓名，身份证号
			                张三,510104197509202629*/
		} else if (Arrays.asList("1C010101","1C010102").contains(dataSource)) {
			/*1C010101 电信固话信息查询 A
			PARAM：单位电话，单位名称("")，省ID，城市名称
			               01088888888,过政通,BJ,北京
			1C010102 电信固话信息查询 B
			PARAM：家庭电话，家庭地址("")，省ID，城市名称
			               01088888888,过政通,BJ,北京*/
		} else if (Arrays.asList("1C010103").contains(dataSource)) {
			/*1C010103 电信固话综合
			PARAM：电话，单位名称("")，单位地址("")，家庭地址("")，唯一标识
			               01088888888,过政通,海淀区,XX,123456789*/
		} else if (Arrays.asList("1G010101","1C1G01").contains(dataSource)) {
			/*1G010101 联通固话信息查询 A
			1C1G01 固话综合查询(电信+联通)
			PARAM：电话，名称("")，地址("")
			               01082512114,北京华瑞网研,科技有限公司,北京海淀区*/
		} else if (Arrays.asList("1E020201","1E020202","1E020208").contains(dataSource)) {
			/*1E020201 行驶证所有人比对
			1E020202 行驶证所有人核实
			1E020208 行驶证所有人核查比对
			PARAM：姓名，身份证号，车牌号码，车辆类型
			               张三,510104197509202629,京 AA8888,02*/
		} else if (Arrays.asList("1E020203","1E020204").contains(dataSource)) {
			/*1E020203 行驶证发动机号比对
			1E020204 行驶证车架号比对
			PARAM：车架号后四位,身份证号,车牌号码,车辆类型
			               1234,510104197509202629,京 AA8888,02*/
		} else if (Arrays.asList("1E020205","1E020206","1E020207").contains(dataSource)) {
			/*1E020205 行驶证发动机号和车架号比对
			PARAM：发动机号后四位/车架号后四位,身份证号,车牌号码,车辆类
			               1234/2132,510104197509202629,京 AA8888,02
			1E020206 行驶证发动机号和所有人比对
			PARAM：发动机号后四位/所有人,身份证号,车牌号码,车辆类型
			                1234/张三,510104197509202629,京 AA8888,02
			1E020207 行驶证车架号和所有人比对
			PARAM：车架号后四位/所有人,身份证号,车牌号码,车辆类型
			                1234/张三,510104197509202629,京 AA8888,02*/
		} else if (Arrays.asList("1Y010401","1Y010402","1Y010403").contains(dataSource)) {
			/*1Y010401 同名同性 A
			1Y010402 同名同性 B
			1Y010403 同名同性 C
			PARAM：姓名,性别,省行政区号,出生年,出生月,出生日,属相(""),星座(""),姓氏("")
			               张三,1,110000,1997,12,29,1,1,张*/
		} else if (Arrays.asList("1Y020401").contains(dataSource)) {
			/*1Y020401 同年同月同日生
			PARAM：姓名,性别,省行政区号,出生年,出生月,出生日,属相,星座,姓氏
			              ,,110000,1997,12,29*/
		} else if (Arrays.asList("1Y030402").contains(dataSource)) {
			/*1Y030402 同年同月同日生产品 A
			PARAM：姓名,性别,省行政区号,出生年,出生月,出生日,属相,星座,姓氏
			              ,,,1997,12,29*/
		} else if (Arrays.asList("1Y010404","1Y010405","1Y010406","1Y010407").contains(dataSource)) {
			/*1Y010404 同名同性 D
			1Y010405 同名同性 E
			1Y010406 同名同性 F
			1Y010407 同名同性 G
			PARAM：姓名
			                张三*/
		}
		
		resultXml = bqQuerySingle(dataSource, param);
		
		return new String(DESBASE64.decode(ID5Constants.SKEY, Base64.decode(resultXml)));
	}

	/**
	 * 查询国政通web服务器
	 * @param dataSource
	 * @param param
	 * @return
	 * @throws Exception
	 * @throws RemoteException
	 */
	private static String bqQuerySingle(String dataSource, String param)
			throws Exception, RemoteException {
		String resultXml;
		// 调用webservice接口查询服务器（根据wsdl生成的客户端）
		QueryValidatorServicesProxy proxy = new QueryValidatorServicesProxy();
		proxy.setEndpoint(ID5Constants.WSDL_URL);
		QueryValidatorServices service = proxy.getQueryValidatorServices();
		//System.setProperty(ContainsBean.ID5_SSL_TRUSTSTORE,ContainsBean.ID5_CHECKID_KEYSTORE);
			
		// base64 加密查询参数
		String encryptKey = DESBASE64.encode(ID5Constants.SKEY,ID5Constants.ID5_USERNAME.getBytes());
		String encryptPasswd = DESBASE64.encode(ID5Constants.SKEY,ID5Constants.ID5_PASSWORD.getBytes());
		String encryptDatasource = DESBASE64.encode(ID5Constants.SKEY,dataSource.getBytes());
		String encryptParam = DESBASE64.encode(ID5Constants.SKEY,param.getBytes());
		resultXml = service.querySingle(encryptKey, encryptPasswd, encryptDatasource, encryptParam);
		
		return resultXml;
	}
	
	/**
	 * 保存数据到数据库
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
