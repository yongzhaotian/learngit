package com.amarsoft.webclient;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.rmi.RemoteException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.jws.soap.SOAPBinding.Style;

import com.amarsoft.webclient.app.QueryValidatorServices;
import com.amarsoft.webclient.app.QueryValidatorServicesProxy;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.dw.ASConv;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.oti.client.hhcf.id5.DESBASE64;
import com.amarsoft.oti.client.hhcf.id5.ID5Constants;

import oracle.jdbc.OraclePreparedStatement;
import sun.misc.BASE64Decoder;

public class ID5Util {

	public static Map<String, String> nodeNameMap = new HashMap<String, String>();
	public static Map<String, String> nodeNameAttr = new HashMap<String, String>();
	public static final String S_TABLE_NAME = "ID5_XML_ELE_VAL";
	public static final String S_SAVE_IMG_PATH = "imges";
	
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
	
	/**
	 * ID信息查询入口
	 * @param reqHeader 查询头，如：A10001
	 * @param reqData	查询录入数据：张三@13232323232
	 * @return
	 */
	public static String parseID5Info(String reqHeader, String reqData, String stype) {
		
		String sResult = "";
		Connection conn = getConnection();
		//String sRequiredData = parseRequiredData(reqHeader,reqData);
		// 查询是否已经存在于数据库
		try {
			Statement stmt = conn.createStatement();
			// 修改成查询必须字段	REQUIREDDATA
			String sCntExist = "select STATUS2,VALUE2 FROM ID5_XML_ELE_VAL where INPUTPARAM='"+reqData+"' and REQHEADER='"+reqHeader+"'";
			ResultSet rs = stmt.executeQuery(sCntExist);
			System.out.println("SQL Exists: " + sCntExist);
			
			if ( rs.next() ) {   // 已经存在于数据库，直接从数据库中查询数据
				sResult = rs.getString(1)+"@"+rs.getString(2);
			} else { // 调用webservice并保存数据
				String xmlResult = queryId5Result(reqHeader, reqData, stype);
				//String xmlResult = readXmlToResult("src/demo/auniontelephone/unionphone.xml").toString();
				System.out.println("File content xx: " + xmlResult);
				// 将xmlResult保存到文件
				String path = reqData.replaceAll("@", "");
				saveToFile(xmlResult, path+".xml",path);
				sResult = parseSingleResult(conn, xmlResult, reqHeader,reqData);
			}
			rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
		}	finally {
			if (conn != null)
				try {	conn.close();	} catch (SQLException e) { e.printStackTrace(); }
		}
		return sResult;
	}
	
	/**
	 * ID信息查询入口
	 * @param reqHeader 查询头，如：A10001
	 * @param reqData	查询录入数据：张三@13232323232
	 * @return
	 */
	public static String parseID5Info(Transaction Sqlca, String customerId, String reqHeader, String reqData, String savepath, String stype, String imgpath) throws Exception {
		
		String sResult = "";
		String isopen = "";
		// 查询是否已经存在于数据库
		// 修改成查询必须字段	REQUIREDDATA
	String sCntExist = "select STATUS2,VALUE2 FROM ID5_XML_ELE_VAL where (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30))<=0" +
				" and serialno = :SERIALNO";
		ASResultSet rs = Sqlca.getResultSet(new SqlObject(sCntExist).setParameter("SERIALNO", reqHeader+"#"+reqData));
		System.out.println("SQL Exists: " + sCntExist);
		
		if ( rs.next() ) {   // 已经存在于数据库，直接从数据库中查询数据
			sResult = "010@"+rs.getString(1)+"@"+rs.getString(2);
		} else { // 调用webservice并保存数据
			//当开启认证宝时，这里不查询ID5 quliangmao
			 isopen = "select status from business_renzhengbao where 1='1'";
			ASResultSet rsopen = Sqlca.getResultSet(new SqlObject(isopen));
			if ( rsopen.next() ) { 
				if(!"Y".equals(rsopen.getString(1))){//查询的状态中 当等于Y时 是开启认证宝
					isopen="K";
				}
		   }
			if("K".equals(isopen)){
				String xmlResult = queryId5Result(reqHeader, reqData, stype);
				//String xmlResult = readXmlToResult("/home/tbzeng/Documents/workspace/ALS74CUS/src/demo/auniontelephone/unionphone"+stype+".xml").toString();
				System.out.println("File content xx: " + xmlResult);
				// 将xmlResult保存到文件
				savepath=savepath+"/"+new SimpleDateFormat("yyyy/MM/dd").format(new Date());//CCR-757 bylinhai
				String path = savepath+"/"+reqData.replaceAll("@", "");
				saveToFile(xmlResult, path+".xml",savepath);
				
				/** add 修改连接ID5校验超时“ID5_XML_ELE_VAL”锁表问题 tangyb 20150826 start **/
		   if("1C1G01".equals(reqHeader)||"1A020201".equals(reqHeader)){ 
					// 连接ID5成功后再检查是否超过30天，超过则需要重新获取
					String sExists = Sqlca.getString(new SqlObject("SELECT SERIALNO FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", reqHeader+"#"+reqData));
					if (sExists != null) {
						double overDayCmp = Sqlca.getDouble(new SqlObject("SELECT (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30)) AS ID5DATE FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO")
							.setParameter("SERIALNO", reqHeader+"#"+reqData));
						if (overDayCmp > 0) {	// 已经超过30天
							Sqlca.executeSQL(new SqlObject("DELETE  FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", reqHeader+"#"+reqData));
						}
					}
				}
				/** add 修改连接ID5校验超时“ID5_XML_ELE_VAL”锁表问题 tangyb 20150826 end **/
				
				sResult = parseSingleResult(Sqlca, customerId, xmlResult, reqHeader,reqData, savepath,imgpath);
				sResult = "020@" + sResult;
			}
			rsopen.getStatement().close();
		}
		rs.getStatement().close();	
		return sResult;
	}

	private static void saveToFile(String xmlResult, String path,String savepath) {
		
		try {
			File xmlDir = new File(savepath);
			if (!xmlDir.exists()) xmlDir.mkdirs();
			File xmlFile = new File(path);
			System.out.println("File Content: " + xmlResult);
			
			FileWriter fw = new FileWriter(xmlFile);
			fw.write(xmlResult);
			fw.close();
			
			System.out.println(xmlFile.getAbsolutePath());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static String parseRequiredData(String reqHeader, String reqData) {
		
		String sRetReqData = reqData;
		
		if (Arrays.asList("1C010101","1C010102").contains(reqHeader)) {		// 
			//电 信 固 话 信 息 查 询 A 参 数 : 单 位 电 话 , 单 位 名 称 , 省 ID, 城 市 名 称 , 如
			//“01088888888,国政通,BJ,北京”,其中单位名称可以为空,其它均不为空,
			// 但,(逗号)不能省略
			//电 信 固 话 信 息 查 询 B 参 数 : 家 庭 电 话 , 家 庭 地 址 , 省 ID, 城 市 名 称 , 如
			//“01088888888,北京海淀区 XX,BJ,北京”,其中家庭地址可以为空,其它均不
			//为空,但,(逗号)不能省略 1C010102 电信固话信息查询 B
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0]+"@"+paraArray[2]+"@"+paraArray[3];
		} else if ("1C010103".equals(reqHeader)) {		// 1C010103 电信固话综合
			//电 信 固 话 综 合 参 数 : 电 话 ,单 位 名 称 , 单 位 地 址 ,家 庭 地 址 , 唯 一 标 识 , 如
			//“01088888888,国政通,海淀区,XX,123456789”,其中单位名称、单位地址、
			//家庭地址可以为空,其它均不为空,但,(逗号)不能省略
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0]+"@"+paraArray[4];
		} else if ("1G010101".equals(reqHeader)) {
			// 1G010101 联通固话信息查询 A
			//联通固话信息查询 A 参数:电话,名称,地址,如“01082512114,北京华瑞网研
			//科技有限公司,北京海淀区,其中电话必须填写,其它可以为空
			
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0];
		} else if ("1C1G01".equals(reqHeader)) {
			//1C1G01 固话综合查询(电信+联通)
			//固话综合查询(电信+联通)参数:电话,名称,地址,唯一标识,如“01082512114,
			//北京华瑞网研科技有限公司,北京海淀区,123456,其中电话必须填写,其它可
			//以为空;但如果唯一标识不为空,中间的,(逗号)不能省略
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0]+"@"+paraArray[3];
		} else if ("1Y010401".equals(reqHeader)) {		// 1Y010401 同名同性 A
			//同名同性 A 参数:姓名,性别,省行政区号,出生年,出生月,出生日,属相,星座,姓
			//氏,如“张三,1,110000,1997,12,29,1,1,张,其中姓名必须填写;出生年、出生
			//月、出生日必须同时填写;其它可以为空
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0]+"@"+paraArray[3]+"@"+paraArray[4]+"@"+paraArray[5];
		} else if ("1Y010402".equals(reqHeader)) {		//1Y010402 同名同性 B
			//同名同性 B 参数:姓名,性别,省行政区号,出生年,出生月,出生日,属相,星座,姓
			//氏,如“张三,1,110000,1997,12,29,1,1,张,其中姓名必须填写;出生年、出生
			//月、出生日必须同时填写;其它可以为空
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[3]+"@"+paraArray[4]+"@"+paraArray[5];
		} else if ("1Y010403".equals(reqHeader)) {		// 1Y010403 同名同性 C
			//同名同性 C 参数:姓名,性别,省行政区号,出生年,出生月,出生日,属相,星座,姓
			//氏,如“张三,1,110000,1997,12,29,1,1,张,其中姓名、省行政区号必须填写,
			//姓名、省行政区号之间的逗号也必须有;出生年、出生月、出生日必须同时
			//填写;其它可以为空
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0] + "@" +paraArray[2] + "@" +paraArray[3]+"@"+paraArray[4]+"@"+paraArray[5];
		} else if ("1Y020401".equals(reqHeader)) {		// 1Y020401 同年同月同日生
			//同年同月同日生参数:姓名,性别,省行政区号,出生年,出生月,出生日,属相,星座,
			//姓氏,其中省行政区号,出生年,出生月,出生日这四个参数必须填写;如果姓名、
			//性别为空,中间的逗号不能省略;如“,,110000,1997,12,29,前面的 2 个逗号
			//是不能省略的
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[2] + "@" +paraArray[3]+"@"+paraArray[4]+"@"+paraArray[5];
		} else if ("1Y030402".equals(reqHeader)) {		// 1Y030402 同年同月同日生产品 A
			//同年同月同日生产品 A 参数:姓名,性别,省行政区号,出生年,出生月,出生日,
			//属相,星座,姓氏,出生年,出生月,出生日这三个参数必须填写;如果姓名、性
			//别、省行政区号为空,中间的逗号不能省略;如 “,,,1997,12,29,前面的 3 个
			//逗号是不能省略的
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[3]+"@"+paraArray[4]+"@"+paraArray[5];
		} else {
			sRetReqData = reqData;
		}
		
		return sRetReqData;
	}

	/**
	 * 
	 * @param reqHeader
	 * @param reqData
	 * @param stype 010 身份证， 020 固话
	 * @return
	 * @throws Exception
	 * @throws RemoteException
	 */
	private static String queryId5Result(String reqHeader, String reqData, String stype)
			throws Exception, RemoteException {
		
		String SKEY = ID5Constants.SKEY;
		QueryValidatorServicesProxy proxy = new QueryValidatorServicesProxy();
		if ("010".equals(stype)) {
			proxy.setEndpoint(ID5Constants.WSDL_URL);
		} else if ("020".equals(stype)) {
			proxy.setEndpoint(ID5Constants.WSDL_URL_PHONE);
		}
		QueryValidatorServices service = proxy.getQueryValidatorServices();
		//System.setProperty(ContainsBean.ID5_SSL_TRUSTSTORE,ContainsBean.ID5_CHECKID_KEYSTORE);
		String username = DESBASE64.encode(SKEY, ID5Constants.ID5_USERNAME);
		String password = DESBASE64.encode(SKEY, ID5Constants.ID5_PASSWORD);
		String dataSource = DESBASE64.encode(SKEY, reqHeader);
		String param =  DESBASE64.encode(SKEY,reqData.replaceAll("@", ",").getBytes("GB18030"));
		
		String queryXml = service.querySingle(username, password, dataSource, param);
		System.out.println("Query xml: " + queryXml);
		
		String resultdecode = DESBASE64.decodeValue(SKEY, queryXml);
		
		return resultdecode;
	}


	/**
	 * 如果数据库中不存在，将数据保存到数据库
	 * @param conn
	 * @param xmlResult
	 * @param reqData
	 * @throws Exception
	 */
	public static String parseSingleResult(Connection conn, String xmlResult, String reqHeader, String reqData) throws Exception {

		String sRetVal = "";
		List<BQNode> bqNodeList = runParser(xmlResult, null);	// 将xml文件字符串解析成节点
		List<String> keysList = new ArrayList<String>();	// 存储节点名
		List<String> valuesList = new ArrayList<String>();	// 存储节点值
		
		StringBuffer sbInsert = new StringBuffer("INSERT INTO ID5_XML_ELE_VAL (");	// 生成insert段字符串
		StringBuffer sbValue = new StringBuffer(" VALUES(");	// 生成values段字符串
		
		for (int index=0; index<bqNodeList.size(); index++) {
			
			BQNode bqNode = bqNodeList.get(index);
			// 获取输入参数
			/*if (index == 2) {
				Iterator<String> iter1 = bqNode.getAttrMap().keySet().iterator();
				
				while (iter1.hasNext()) {
					String key1 = iter1.next();
					sInputPara+=bqNode.getAttrMap().get(key1).trim()+"@";
				}
				sInputPara = sInputPara.substring(0, sInputPara.length()-1);
			} */
			
			String ndKey = bqNode.getNodeName();
			// 解决node节点重名，后面的数字是与数据库同步
			if (index==0 || index==1 || "name".equals(ndKey) || "keys".equals(ndKey)) ndKey += "1";
			if (index==3 || index==4) ndKey += "2";
			
			String value = bqNode.getNodeValue()==null ? "": bqNode.getNodeValue();
			
			if (bqNode.getNodeName()!=null && bqNode.getNodeName().equalsIgnoreCase("checkPhoto"))  {
				value = value.replaceAll("\\s", ""); // 照片base64编码值
			}
			
			if (index != 2) {
				keysList.add(ndKey);
				valuesList.add(value);
				sbInsert.append(ndKey).append(",");
				sbValue.append("?,");
			}
			// 保存查询结果
			if (index == 3) sRetVal = bqNode.getNodeValue();
			if (index == 4) sRetVal += "@"+bqNode.getNodeValue();
		}
      
		// 解析必须参数
		//String sRequiredData = parseRequiredData(reqHeader,reqData);
		// 拼接输入参数和请求头消息
		keysList.add("INPUTPARAM");
		keysList.add("REQHEADER");
		//keysList.add("REQUIREDDATA");
		//valuesList.add(sInputPara);
		valuesList.add(reqData);
		valuesList.add(reqHeader);
		//valuesList.add(sRequiredData);
		
		sbInsert.append("INPUTPARAM,REQHEADER)");
		sbValue.append("?,?)");
		String sql = sbInsert.toString()+sbValue.toString();
		
		System.out.println(sql);
		System.out.println("Input param2: " + reqData);
		
        OraclePreparedStatement pstmt = (OraclePreparedStatement) conn.prepareStatement(sql);
        for (int i=0; i<valuesList.size(); i++) {
        	String sVal = valuesList.get(i);
        	if ("CHECKPHOTO".equalsIgnoreCase(keysList.get(i))) // 如果是照片
        		pstmt.setStringForClob(i+1, sVal);
        	else
        		pstmt.setString(i+1, sVal);
        }
        pstmt.executeUpdate();
        
        if (pstmt != null) pstmt.close();
		
		return sRetVal;
	}
	
	/**
	 * 如果数据库中不存在，将数据保存到数据库
	 * @param conn
	 * @param xmlResult
	 * @param reqData
	 * @throws Exception
	 */
	public static String parseSingleResult(Transaction Sqlca, String customerId, String xmlResult, String reqHeader, String reqData, String savepath,String imgpath) throws Exception {

		String sRetVal = "";	
		List<BQNode> bqNodeList = runParser(xmlResult, null);	// 将xml文件字符串解析成节点
		List<String> keysList = new ArrayList<String>();	// 存储节点名
		List<String> valuesList = new ArrayList<String>();	// 存储节点值
		boolean bPhoto = true;		// 是否存在照片
		
		StringBuffer sbInsert = new StringBuffer("INSERT INTO "+S_TABLE_NAME+" (");	// 生成insert段字符串
		StringBuffer sbValue = new StringBuffer(" VALUES(");	// 生成values段字符串
		
		for (int index=0; index<bqNodeList.size(); index++) {
			
			BQNode bqNode = bqNodeList.get(index);
			String ndKey = bqNode.getNodeName();
			// 解决node节点重名，后面的数字是与数据库同步
			if (index==0 || index==1 || "name".equals(ndKey) || "keys".equals(ndKey)) ndKey += "1";
			if (index==3 || index==4) ndKey += "2";
			
			String value = bqNode.getNodeValue()==null ? "": bqNode.getNodeValue();
			
			if (bqNode.getNodeName()!=null && bqNode.getNodeName().equalsIgnoreCase("checkPhoto"))  {
				value = value.replaceAll("\\s", ""); // 照片base64编码值
				if (value!=null && value.length() <= 9) {
					bPhoto = false;
				}
			}
			
			if (index != 2) {
				keysList.add(ndKey);
				valuesList.add(value);
				sbInsert.append(ndKey).append(",");
				sbValue.append(":").append(ndKey).append(",");
			}
			// 保存查询结果
			if (index == 3) sRetVal = bqNode.getNodeValue();
			if (index == 4) sRetVal += "@"+bqNode.getNodeValue();
		}
      
		// 解析必须参数
		//String sRequiredData = parseRequiredData(reqHeader,reqData);
		// 拼接输入参数和请求头消息
		keysList.add("INPUTPARAM");
		keysList.add("REQHEADER");
		keysList.add("SERIALNO");
		keysList.add("INPUTDATE");
		keysList.add("CUSTOMERID");
		valuesList.add(reqData);
		valuesList.add(reqHeader);
		valuesList.add(reqHeader+"#"+reqData);
		valuesList.add(DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss"));
		valuesList.add(customerId);
		
		sbInsert.append("INPUTPARAM,REQHEADER,SERIALNO,INPUTDATE,CUSTOMERID)");
		sbValue.append(":INPUTPARAM,:REQHEADER,:SERIALNO,:INPUTDATE,:CUSTOMERID)");
		String sql = sbInsert.toString()+sbValue.toString();
		
		System.out.println(sql);
		System.out.println("Input param2: " + reqData);
		
		SqlObject asql = new SqlObject(sql);
		for (int i=0; i<valuesList.size(); i++) {
			if ("CHECKPHOTO".equalsIgnoreCase(keysList.get(i))) {
				
				if (bPhoto) {
					String sImgFold  = imgpath+"/"+new SimpleDateFormat("MM/dd/HH").format(new Date());
					File imgFile = new File(sImgFold);
					if (!imgFile.exists()) imgFile.mkdirs();
					String path = sImgFold+"/"+reqData.split("@")[1]+".jpg";
					if (generateImage(valuesList.get(i), path)) {
						asql.setParameter(keysList.get(i), path);
					} else {
						throw new RuntimeException("转化BASE64图片失败！");
					}
				} else {
					asql.setParameter(keysList.get(i), "");
				}
			} else {
				asql.setParameter(keysList.get(i), valuesList.get(i));
			}
			
		}
        	/*if ("CHECKPHOTO".equalsIgnoreCase(keysList.get(i))) // 如果是照片
        		pstmt.setStringForClob(i+1, sVal);
        	else
        		pstmt.setString(i+1, sVal);*/
		Sqlca.executeSQL(asql);
        
		return sRetVal;
	}
	
	public static boolean generateImage(String imgStr, String savePath) {//对字节数组字符串进行Base64解码并生成图片
        if (imgStr == null) {//图像数据为空
            return false;
        }
        
        BASE64Decoder decoder = new BASE64Decoder();
        try {
            //Base64解码
            byte[] b = decoder.decodeBuffer(imgStr);
            for(int i=0;i<b.length;++i) {
                if(b[i]<0) {//调整异常数据
                    b[i]+=256;
                }
            }
            // 如果目录不存在， 则创建
           /* File dirFile = new File(savePath);
            if (dirFile.isFile()) {
            	File parFile = dirFile.getParentFile();
            	if (!parFile.exists())
            		parFile.mkdirs();
            } else if (dirFile.isDirectory() && !dirFile.exists()) {
            	dirFile.mkdirs();
            }*/
            //生成jpeg图片
            OutputStream out = new FileOutputStream(savePath);    
            out.write(b);
            out.flush();
            out.close();
            return true;
        } catch (Exception e) {
            return false;
        }
        
    }
	
	public static Connection getConnection () {
		
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			conn = DriverManager.getConnection("jdbc:oracle:thin:@10.40.1.135:1521:orcl", "als7c", "als7c");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return conn;
	}
}
