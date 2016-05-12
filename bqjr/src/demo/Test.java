package demo;

import java.io.File;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;

public class Test {

	public static void main(String[] args) throws Exception {
		
		XPath xpath = XPathFactory.newInstance().newXPath();
		String xmlPath = "a1000telphone/a1000phone.xml";
		XPathDocument xPathDoc = XPathDocument.getInstance(xmlPath);
        
        
        
        //String pXmlPath = "/data/message";
        //String[] msgNodeTags = {"status", "value"};
		String pXmlPath = "/data/telecomInfos/telecomInfo";
        String[] msgNodeTags = {"corpTel","corpName","provinceId","z_corpName","z_corpAddress","f_corpTel","f_corpAddress"};

        
        
        List<BQNode> msgBqList = xPathDoc.parseXMLByXPath(pXmlPath, msgNodeTags);
        
        for (BQNode bqNode: msgBqList) {
        	//System.out.println(bqNode);
        }
        
        String sXmlPath = "/data";
        xPathDoc.parseNodeListByXPath(sXmlPath);
        
        for (BQNode bqNode: XPathDocument.bqList) {
        	System.out.println(bqNode);
        }
	}
	
	
}
