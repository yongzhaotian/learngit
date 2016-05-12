package demo;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class XPathDocument {

	
    private XPath xpath;
    private Document doc;
    private static XPathDocument xPathDoc = null;
    public static List<BQNode> bqList = new ArrayList<BQNode>();
    
    public XPathDocument(String xmlPath) {
    	
    	try {
    		
    		xpath = XPathFactory.newInstance().newXPath();
    		
	    	DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();  
		    DocumentBuilder db = dbf.newDocumentBuilder();  
		    doc = db.parse(new File(xmlPath));
		    
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }
    
    public XPathDocument(InputStream is) {
    	
    	try {
    		
    		xpath = XPathFactory.newInstance().newXPath();
    		
	    	DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();  
		    DocumentBuilder db = dbf.newDocumentBuilder();  
		    doc = db.parse(is);
		    
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }
    
    /**
     * α����
     * @param xmlPath
     * @return
     */
    public static XPathDocument getInstance(String xmlPath) {
    	
    	xPathDoc = new XPathDocument(xmlPath);
    	bqList.clear();
    	
    	return xPathDoc;
    }
    
    /**
     * α����
     * @param xmlPath
     * @return
     */
    public static XPathDocument getInstance(InputStream is) {
    	
    	xPathDoc = new XPathDocument(is);
    	bqList.clear();
    	
    	return xPathDoc;
    }
	
	
	/**
	 * ���ݽڵ㼰���ӽڵ����Ƶõ��ӽڵ���Ϣ
	 * @param node 
	 * @param childNodeName
	 * @return
	 */
	public BQNode parseOneNode(Node node, String childNodeName) {
		
		BQNode bqNode = new BQNode();
		
		try {
			XPathExpression nodeExp = xpath.compile("./"+childNodeName);
			Node childNode = (Node) nodeExp.evaluate(node, XPathConstants.NODE);
			NamedNodeMap attrMap = childNode.getAttributes();

			if (attrMap != null && attrMap.getLength()>0) {
				Map<String, String> bqAttrMap = new TreeMap<String, String>();
				for (int idx=0; idx<attrMap.getLength(); idx++) {
					Attr attr = (Attr) attrMap.item(idx);
					bqAttrMap.put(attr.getName(), attr.getValue());
				}
				bqNode.setAttrMap(bqAttrMap);
			}
			
			bqNode.setNodeName(childNodeName);
			bqNode.setNodeValue(nodeExp.evaluate(node));
		
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}
		
		return bqNode;
	}
	
	/**
	 * ����xpath�����ӽڵ����ƻ�ȡ�ڵ���Ϣ
	 * @param pXpath  /data/message
	 * @param childNodeTags {"status","value"}
	 * @return
	 * @throws Exception
	 */
	public List<BQNode> parseXMLByXPath(String pXpath, String[] childNodeTags) throws Exception  {
		
		List<BQNode> bqNodeList = new ArrayList<BQNode>();
		
		XPathExpression msgXpathExpr = xpath.compile(pXpath);
        
        NodeList nodeList = (NodeList) msgXpathExpr.evaluate(doc, XPathConstants.NODESET);
        
        for (int idx=0; idx<nodeList.getLength(); idx++) {
	        
        	Node node = nodeList.item(idx);
        	for (int id=0; id<childNodeTags.length; id++) {
	        	
	        	BQNode bqNode = parseOneNode(node, childNodeTags[id]);
	        	bqNodeList.add(bqNode);
	        }
        }
		
		return bqNodeList;
	}
	
	/**
	 * 
	 * @param xpath
	 * @return
	 * @throws Exception 
	 */
	public List<BQNode> parseNodeListByXPath(String xPath) throws Exception {
		
		List<BQNode> bqNodeList = new ArrayList<BQNode>();
		XPathExpression xpathExpr = xpath.compile(xPath);
		
		NodeList nodeList = (NodeList) xpathExpr.evaluate(doc, XPathConstants.NODESET);
		
		for (int idx=0; idx<nodeList.getLength(); idx++) {
			
			Node node = nodeList.item(idx);
			NamedNodeMap attrMap = node.getAttributes();
			BQNode bqNode = new BQNode();
			if (attrMap != null && attrMap.getLength()>0) {
				Map<String, String> bqAttrMap = new TreeMap<String, String>();
				for (int id=0; id<attrMap.getLength(); id++) {
					Attr attr = (Attr) attrMap.item(id);
					bqAttrMap.put(attr.getName(), attr.getValue());
				}
				bqNode.setAttrMap(bqAttrMap);
			}
			
			bqNode.setNodeName(node.getNodeName());
			if (node.hasChildNodes()) {
				bqNode.setNodeValue(node.getChildNodes().item(0).getNodeValue());
			}
			
			bqNodeList.add(bqNode);
			
			//System.out.println(bqNode);
			parseElement((Element)node);
		}
		
		return bqNodeList;
	}
	
	/**
	 * 
	 * @param element
	 */
	public void parseElement(Element element) {
		
        String tagName = element.getNodeName();  
        
        BQNode bqNode = new BQNode();
        bqNode.setNodeName(tagName);
        
        // ��ȡ�ӽڵ㼰������
        NodeList children = element.getChildNodes();  
        NamedNodeMap map = element.getAttributes();  
          
        if(null != map) {  
        	
        	Map<String, String> attrMap = new TreeMap<String, String>();
            for(int i = 0; i < map.getLength(); i++) {
            	
                Attr attr = (Attr)map.item(i);  
                String attrName = attr.getName();  
                String attrValue = attr.getValue();  
                attrMap.put(attrName, attrValue);
                  
            }
            bqNode.setAttrMap(attrMap);
        }
        
        // ֱ���Ա����Ž������ӽڵ�Ľڵ�<xx att1=""/>��ֱ����ӵ���ջ��
        if (!element.hasChildNodes()) {	
        	bqNode.setNodeName(element.getNodeName());
        	bqList.add(bqNode);
        }
          
          
        for(int i = 0; i < children.getLength(); i++) {  
            
        	Node node = children.item(i);  
            short nodeType = node.getNodeType();  
              
            if(nodeType == Node.ELEMENT_NODE) {
            	
            	// �ڵ�����ֽڵ㵫���ı��ڵ�ʱ�������������Է�װֵ����ջ��
            	if (element.getAttributes()!=null && element.getAttributes().getLength()>0
            			&& bqNode.getAttrMap()!=null && bqNode.getAttrMap().size()>0 
            			&&!bqList.contains(bqNode)) {
            		
	            		if (bqNode.getAttrMap().size()>1) {
	            			bqNode.setbInputNode(true);
	            		}
            			bqList.add(bqNode);
            			
            	}
            	parseElement((Element)node);  
            } else if(nodeType == Node.TEXT_NODE) {
            	
            	// �ǿ��ı��ڵ㼴�ڵ�ֵ
                if (node.getNodeValue().trim().length()>0) {
                	bqNode.setNodeValue(node.getNodeValue().trim());
                	bqList.add(bqNode);
                }
            } else if(nodeType == Node.COMMENT_NODE) {
            	
                //Comment comment = (Comment)node;  
                //String data = comment.getData();  
            }  
        }  

	}
}
