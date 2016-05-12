package demo;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileReader;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class MyTest {

	public static Map<String, String> nodeNameMap = new HashMap<String, String>();
	public static Map<String, String> nodeNameAttr = new HashMap<String, String>();
	
	public static List<String> xmlList = Arrays.asList("idquery.xml",
							"carcarriagecmp/carcarriagecmpnoconsy.xml",
							"carcarriagecmp/carcarriagecmpconsy.xml",
							"schoolroll/schoolroll.xml",
							"schoolroll/SuccessButNoData.xml",
							"namesexsame/dnamesexsame.xml",
							"namesexsame/gnamesexsame.xml",
							"namesexsame/cnamesexsame.xml",
							"namesexsame/anamesexsame.xml",
							"namesexsame/enamesexsame.xml",
							"namesexsame/bnamesexsame.xml",
							"namesexsame/fnamesexsame.xml",
							"drivercertownercheck/drivercertownercheckconsy.xml",
							"drivercertownercheck/drivercertownerchecknoconsy.xml",
							"b1000telphone/b1000phone.xml",
							"b1000telphone/successbunodata.xml",
							"a1000telphone/a1000phone.xml",
							"a1000telphone/successbunodata.xml",
							"drivercertcmp/drivercertcmpnoconsy.xml",
							"drivercertcmp/drivercertcmpconsy.xml",
							"all1000telephone/all1000phone.xml",
							"all1000telephone/successbunodata.xml",
							"sameyearmonthday/sameyearmonthday.xml",
							"sameyearmonthday/asameyearmonthday.xml",
							"auniontelephone/unionphone.xml",
							"auniontelephone/successbunodata.xml",
							"drivercertcheck/drivercertconsy.xml",
							"drivercertcheck/drivercertnoconsy.xml",
							"bin/QueryValidatorServices.xml",
							"drivercheck/infoconsy.xml",
							"drivercheck/infonoconsy.xml",
							"drivingcertownercheck/drivingcertownerchecknoconsy.xml",
							"drivingcertownercheck/drivingcertownercheckconsy.xml",
							"carriageownercmp/carriageownercmpconsy.xml",
							"carriageownercmp/carriageownercmpnoconsy.xml",
							"src/QueryValidatorServices.xml",
							"allphone/allphone.xml",
							"allphone/successbunodata.xml",
							"idcard/IdConsyxml.xml",
							"idcard/DbNoNum.xml",
							"idcard/IdNoConsyxml.xml",
							"engincarriagecmp/engincarriagecmpconsy.xml",
							"engincarriagecmp/engincarriagecmpnoconsy.xml",
							"educate/SuccessBuNoData.xml",
							"educate/educate.xml",
							"enginownercmp/enginownercmpnoconsy.xml",
							"enginownercmp/enginownercmpconsy.xml",
							"certengincheck/certenginchecknoconsy.xml",
							"certengincheck/certengincheckconsy.xml",
							"drivercertowner/drivercertownerconsy.xml",
							"drivercertowner/drivercertownernoconsy.xml");
	
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
	
	
	public static void printFilePath(String targetDir, String suffix) {
		
		File file = new File(targetDir);
		if (file.isFile() && file.getName().substring(file.getName().indexOf(".")+1).equals(suffix)) {
			System.out.println(file.getPath());
		}
		if (file.isDirectory()) {
			File[] files = file.listFiles();
			for (File f: files) {
				if (f.isDirectory()) {
					printFilePath(f.getAbsolutePath(), suffix);
				} else {
					if (f.getName().substring(f.getName().indexOf(".")+1).equals(suffix))
					System.out.println(f.getPath());
				}
			}
		} else {
			System.out.println(file.getPath());
		}
	}
	
	public static void main(String[] args) throws Exception {
	
		String dirPath = "xml";
		//printFilePath(dirPath, "xml");
		
		String xmlPath = "a1000telphone/a1000phone.xml";
		//xmlPath = "idquery.xml";
		List<BQNode> bqNodeList = null;
		/*bqNodeList = runParserTemp(xmlPath, null);
		
        for (BQNode bqNode: bqNodeList) {
        	System.out.println(bqNode);
        }
        
        
        xmlPath = "namesexsame/enamesexsame.xml";*/
        //xmlPath = "a1000telphone/successbunodata.xml";
        
		Iterator<String> iter = xmlList.iterator();
		while (iter.hasNext()) {
		
			String sInputPara = "";
			StringBuffer sbInsert = new StringBuffer("INSERT INTO ID5_XML_ELE_VAL (");
			StringBuffer sbValue = new StringBuffer(" VALUES (");
			
			String xmlpath = iter.next();
			//System.out.println("XML Path: " + xmlpath);
	        bqNodeList = runParser(readXmlToResult("xml/"+xmlpath).toString(), null);
	        for (int index=0; index<bqNodeList.size(); index++) {
	        	BQNode bqNode = bqNodeList.get(index);
	        	nodeNameMap.put(bqNode.getNodeName(), bqNode.getAttrMap().get("desc")+"|"+bqNode.getNodeValue()+"|"+bqNode.getAttrMap().size());
	        	// 输入参数
	        	if (bqNode.getAttrMap().size()>=1 && bqNode.getNodeValue()==null) {
	        		Iterator<String> iter1 = bqNode.getAttrMap().keySet().iterator();
	        		while (iter1.hasNext()) {
	        			String key1 = iter1.next();
	        			//sInputPara += key1+"="+bqNode.getAttrMap().get(key1)+",";
	        			//sInputPara+=bqNode.getAttrMap().get(key1).trim()+",";
	        		}
	        	} else {
	        		String ndKey = bqNode.getNodeName();
	        		if (index==0 || index==1 || "name".equals(ndKey) || "keys".equals(ndKey)) ndKey += "1";
	        		if (index==3 || index==4) ndKey += "2";

	        		sbInsert.append(ndKey).append(",");
	        		String value = bqNode.getNodeValue()==null ? "": bqNode.getNodeValue();
	        		sbValue.append("'").append(value).append(",");
	        	}
	        	//if (sInputPara.length()>=4 && !"desc".equals(sInputPara.substring(0,4)))
	        	if (sInputPara.length()>0 && bqNode.getAttrMap().get("desc")==null)
	        		System.out.println("Input Prameter: " + sInputPara.substring(0, sInputPara.length()-1));
	        	
	        	/*if (bqNode.isbInputNode()) {
	        		nodeNameAttr.put(bqNode.getNodeName(), bqNode.getAttrMap().get("desc"));
	        	}*/
	        }
        
	        sbInsert.append("INPUTPARAM)");
	        sbValue.append("'").append(sInputPara).append("');");
	        System.out.println(sbInsert.toString()+sbValue.toString());
		}
		
		iter = nodeNameMap.keySet().iterator();
		//System.out.println(nodeNameMap.size());
		while (iter.hasNext()) {
			String key = iter.next();
			//System.out.println(key+": " + nodeNameMap.get(key));
		}
		
		System.out.println("---------------------------------------------------------------------------------");
		String sTableName = "ID5_XML_ELE_VAL";
		StringBuffer commentSb = new StringBuffer();
		StringBuffer attrSb = new StringBuffer("CREATE TABE ").append(sTableName).append("(\n");
		iter = nodeNameAttr.keySet().iterator();
		//System.out.println(nodeNameMap.size());
		while (iter.hasNext()) {
			String key = iter.next();
			attrSb.append("\t").append(key).append(" VARCHAR2(64),\n");
			//System.out.println(key+": " + nodeNameAttr.get(key));
			//COMMENT ON COLUMN "XDGL"."BANK_LINK_INFO"."SERIALNO" IS '流水号';
			String sCmmnt = "COMMENT ON COLUMN "+sTableName + "."+key + " IS " + nodeNameAttr.get(key)+";";
			commentSb.append(sCmmnt).append("\n");
		}
		attrSb.deleteCharAt(attrSb.length()-1).append("\n);");
		
		System.out.println("---------------------------------------------------------------------------------");
		//System.out.println(attrSb.toString());
		System.out.println("---------------------------------------------------------------------------------");
		//System.out.println(commentSb.toString());
	}
}
