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
	 * ID��Ϣ��ѯ���
	 * @param reqHeader ��ѯͷ���磺A10001
	 * @param reqData	��ѯ¼�����ݣ�����@13232323232
	 * @return
	 */
	public static String parseID5Info(String reqHeader, String reqData, String stype) {
		
		String sResult = "";
		Connection conn = getConnection();
		//String sRequiredData = parseRequiredData(reqHeader,reqData);
		// ��ѯ�Ƿ��Ѿ����������ݿ�
		try {
			Statement stmt = conn.createStatement();
			// �޸ĳɲ�ѯ�����ֶ�	REQUIREDDATA
			String sCntExist = "select STATUS2,VALUE2 FROM ID5_XML_ELE_VAL where INPUTPARAM='"+reqData+"' and REQHEADER='"+reqHeader+"'";
			ResultSet rs = stmt.executeQuery(sCntExist);
			System.out.println("SQL Exists: " + sCntExist);
			
			if ( rs.next() ) {   // �Ѿ����������ݿ⣬ֱ�Ӵ����ݿ��в�ѯ����
				sResult = rs.getString(1)+"@"+rs.getString(2);
			} else { // ����webservice����������
				String xmlResult = queryId5Result(reqHeader, reqData, stype);
				//String xmlResult = readXmlToResult("src/demo/auniontelephone/unionphone.xml").toString();
				System.out.println("File content xx: " + xmlResult);
				// ��xmlResult���浽�ļ�
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
	 * ID��Ϣ��ѯ���
	 * @param reqHeader ��ѯͷ���磺A10001
	 * @param reqData	��ѯ¼�����ݣ�����@13232323232
	 * @return
	 */
	public static String parseID5Info(Transaction Sqlca, String customerId, String reqHeader, String reqData, String savepath, String stype, String imgpath) throws Exception {
		
		String sResult = "";
		String isopen = "";
		// ��ѯ�Ƿ��Ѿ����������ݿ�
		// �޸ĳɲ�ѯ�����ֶ�	REQUIREDDATA
	String sCntExist = "select STATUS2,VALUE2 FROM ID5_XML_ELE_VAL where (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30))<=0" +
				" and serialno = :SERIALNO";
		ASResultSet rs = Sqlca.getResultSet(new SqlObject(sCntExist).setParameter("SERIALNO", reqHeader+"#"+reqData));
		System.out.println("SQL Exists: " + sCntExist);
		
		if ( rs.next() ) {   // �Ѿ����������ݿ⣬ֱ�Ӵ����ݿ��в�ѯ����
			sResult = "010@"+rs.getString(1)+"@"+rs.getString(2);
		} else { // ����webservice����������
			//��������֤��ʱ�����ﲻ��ѯID5 quliangmao
			 isopen = "select status from business_renzhengbao where 1='1'";
			ASResultSet rsopen = Sqlca.getResultSet(new SqlObject(isopen));
			if ( rsopen.next() ) { 
				if(!"Y".equals(rsopen.getString(1))){//��ѯ��״̬�� ������Yʱ �ǿ�����֤��
					isopen="K";
				}
		   }
			if("K".equals(isopen)){
				String xmlResult = queryId5Result(reqHeader, reqData, stype);
				//String xmlResult = readXmlToResult("/home/tbzeng/Documents/workspace/ALS74CUS/src/demo/auniontelephone/unionphone"+stype+".xml").toString();
				System.out.println("File content xx: " + xmlResult);
				// ��xmlResult���浽�ļ�
				savepath=savepath+"/"+new SimpleDateFormat("yyyy/MM/dd").format(new Date());//CCR-757 bylinhai
				String path = savepath+"/"+reqData.replaceAll("@", "");
				saveToFile(xmlResult, path+".xml",savepath);
				
				/** add �޸�����ID5У�鳬ʱ��ID5_XML_ELE_VAL���������� tangyb 20150826 start **/
		   if("1C1G01".equals(reqHeader)||"1A020201".equals(reqHeader)){ 
					// ����ID5�ɹ����ټ���Ƿ񳬹�30�죬��������Ҫ���»�ȡ
					String sExists = Sqlca.getString(new SqlObject("SELECT SERIALNO FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", reqHeader+"#"+reqData));
					if (sExists != null) {
						double overDayCmp = Sqlca.getDouble(new SqlObject("SELECT (TO_DATE(TO_CHAR(SYSDATE,'yyyy/mm/dd'),'yyyy/mm/dd')-(TO_DATE(SUBSTR(INPUTDATE,1,10), 'yyyy/mm/dd')+30)) AS ID5DATE FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO")
							.setParameter("SERIALNO", reqHeader+"#"+reqData));
						if (overDayCmp > 0) {	// �Ѿ�����30��
							Sqlca.executeSQL(new SqlObject("DELETE  FROM ID5_XML_ELE_VAL WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", reqHeader+"#"+reqData));
						}
					}
				}
				/** add �޸�����ID5У�鳬ʱ��ID5_XML_ELE_VAL���������� tangyb 20150826 end **/
				
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
			//�� �� �� �� �� Ϣ �� ѯ A �� �� : �� λ �� �� , �� λ �� �� , ʡ ID, �� �� �� �� , ��
			//��01088888888,����ͨ,BJ,������,���е�λ���ƿ���Ϊ��,��������Ϊ��,
			// ��,(����)����ʡ��
			//�� �� �� �� �� Ϣ �� ѯ B �� �� : �� ͥ �� �� , �� ͥ �� ַ , ʡ ID, �� �� �� �� , ��
			//��01088888888,���������� XX,BJ,������,���м�ͥ��ַ����Ϊ��,��������
			//Ϊ��,��,(����)����ʡ�� 1C010102 ���Ź̻���Ϣ��ѯ B
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0]+"@"+paraArray[2]+"@"+paraArray[3];
		} else if ("1C010103".equals(reqHeader)) {		// 1C010103 ���Ź̻��ۺ�
			//�� �� �� �� �� �� �� �� : �� �� ,�� λ �� �� , �� λ �� ַ ,�� ͥ �� ַ , Ψ һ �� ʶ , ��
			//��01088888888,����ͨ,������,XX,123456789��,���е�λ���ơ���λ��ַ��
			//��ͥ��ַ����Ϊ��,��������Ϊ��,��,(����)����ʡ��
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0]+"@"+paraArray[4];
		} else if ("1G010101".equals(reqHeader)) {
			// 1G010101 ��ͨ�̻���Ϣ��ѯ A
			//��ͨ�̻���Ϣ��ѯ A ����:�绰,����,��ַ,�硰01082512114,������������
			//�Ƽ����޹�˾,����������,���е绰������д,��������Ϊ��
			
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0];
		} else if ("1C1G01".equals(reqHeader)) {
			//1C1G01 �̻��ۺϲ�ѯ(����+��ͨ)
			//�̻��ۺϲ�ѯ(����+��ͨ)����:�绰,����,��ַ,Ψһ��ʶ,�硰01082512114,
			//�����������пƼ����޹�˾,����������,123456,���е绰������д,������
			//��Ϊ��;�����Ψһ��ʶ��Ϊ��,�м��,(����)����ʡ��
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0]+"@"+paraArray[3];
		} else if ("1Y010401".equals(reqHeader)) {		// 1Y010401 ͬ��ͬ�� A
			//ͬ��ͬ�� A ����:����,�Ա�,ʡ��������,������,������,������,����,����,��
			//��,�硰����,1,110000,1997,12,29,1,1,��,��������������д;�����ꡢ����
			//�¡������ձ���ͬʱ��д;��������Ϊ��
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0]+"@"+paraArray[3]+"@"+paraArray[4]+"@"+paraArray[5];
		} else if ("1Y010402".equals(reqHeader)) {		//1Y010402 ͬ��ͬ�� B
			//ͬ��ͬ�� B ����:����,�Ա�,ʡ��������,������,������,������,����,����,��
			//��,�硰����,1,110000,1997,12,29,1,1,��,��������������д;�����ꡢ����
			//�¡������ձ���ͬʱ��д;��������Ϊ��
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[3]+"@"+paraArray[4]+"@"+paraArray[5];
		} else if ("1Y010403".equals(reqHeader)) {		// 1Y010403 ͬ��ͬ�� C
			//ͬ��ͬ�� C ����:����,�Ա�,ʡ��������,������,������,������,����,����,��
			//��,�硰����,1,110000,1997,12,29,1,1,��,����������ʡ�������ű�����д,
			//������ʡ��������֮��Ķ���Ҳ������;�����ꡢ�����¡������ձ���ͬʱ
			//��д;��������Ϊ��
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[0] + "@" +paraArray[2] + "@" +paraArray[3]+"@"+paraArray[4]+"@"+paraArray[5];
		} else if ("1Y020401".equals(reqHeader)) {		// 1Y020401 ͬ��ͬ��ͬ����
			//ͬ��ͬ��ͬ��������:����,�Ա�,ʡ��������,������,������,������,����,����,
			//����,����ʡ��������,������,������,���������ĸ�����������д;���������
			//�Ա�Ϊ��,�м�Ķ��Ų���ʡ��;�硰,,110000,1997,12,29,ǰ��� 2 ������
			//�ǲ���ʡ�Ե�
			String[] paraArray = reqData.split("@");
			sRetReqData = paraArray[2] + "@" +paraArray[3]+"@"+paraArray[4]+"@"+paraArray[5];
		} else if ("1Y030402".equals(reqHeader)) {		// 1Y030402 ͬ��ͬ��ͬ������Ʒ A
			//ͬ��ͬ��ͬ������Ʒ A ����:����,�Ա�,ʡ��������,������,������,������,
			//����,����,����,������,������,����������������������д;�����������
			//��ʡ��������Ϊ��,�м�Ķ��Ų���ʡ��;�� ��,,,1997,12,29,ǰ��� 3 ��
			//�����ǲ���ʡ�Ե�
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
	 * @param stype 010 ���֤�� 020 �̻�
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
	 * ������ݿ��в����ڣ������ݱ��浽���ݿ�
	 * @param conn
	 * @param xmlResult
	 * @param reqData
	 * @throws Exception
	 */
	public static String parseSingleResult(Connection conn, String xmlResult, String reqHeader, String reqData) throws Exception {

		String sRetVal = "";
		List<BQNode> bqNodeList = runParser(xmlResult, null);	// ��xml�ļ��ַ��������ɽڵ�
		List<String> keysList = new ArrayList<String>();	// �洢�ڵ���
		List<String> valuesList = new ArrayList<String>();	// �洢�ڵ�ֵ
		
		StringBuffer sbInsert = new StringBuffer("INSERT INTO ID5_XML_ELE_VAL (");	// ����insert���ַ���
		StringBuffer sbValue = new StringBuffer(" VALUES(");	// ����values���ַ���
		
		for (int index=0; index<bqNodeList.size(); index++) {
			
			BQNode bqNode = bqNodeList.get(index);
			// ��ȡ�������
			/*if (index == 2) {
				Iterator<String> iter1 = bqNode.getAttrMap().keySet().iterator();
				
				while (iter1.hasNext()) {
					String key1 = iter1.next();
					sInputPara+=bqNode.getAttrMap().get(key1).trim()+"@";
				}
				sInputPara = sInputPara.substring(0, sInputPara.length()-1);
			} */
			
			String ndKey = bqNode.getNodeName();
			// ���node�ڵ�����������������������ݿ�ͬ��
			if (index==0 || index==1 || "name".equals(ndKey) || "keys".equals(ndKey)) ndKey += "1";
			if (index==3 || index==4) ndKey += "2";
			
			String value = bqNode.getNodeValue()==null ? "": bqNode.getNodeValue();
			
			if (bqNode.getNodeName()!=null && bqNode.getNodeName().equalsIgnoreCase("checkPhoto"))  {
				value = value.replaceAll("\\s", ""); // ��Ƭbase64����ֵ
			}
			
			if (index != 2) {
				keysList.add(ndKey);
				valuesList.add(value);
				sbInsert.append(ndKey).append(",");
				sbValue.append("?,");
			}
			// �����ѯ���
			if (index == 3) sRetVal = bqNode.getNodeValue();
			if (index == 4) sRetVal += "@"+bqNode.getNodeValue();
		}
      
		// �����������
		//String sRequiredData = parseRequiredData(reqHeader,reqData);
		// ƴ���������������ͷ��Ϣ
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
        	if ("CHECKPHOTO".equalsIgnoreCase(keysList.get(i))) // �������Ƭ
        		pstmt.setStringForClob(i+1, sVal);
        	else
        		pstmt.setString(i+1, sVal);
        }
        pstmt.executeUpdate();
        
        if (pstmt != null) pstmt.close();
		
		return sRetVal;
	}
	
	/**
	 * ������ݿ��в����ڣ������ݱ��浽���ݿ�
	 * @param conn
	 * @param xmlResult
	 * @param reqData
	 * @throws Exception
	 */
	public static String parseSingleResult(Transaction Sqlca, String customerId, String xmlResult, String reqHeader, String reqData, String savepath,String imgpath) throws Exception {

		String sRetVal = "";	
		List<BQNode> bqNodeList = runParser(xmlResult, null);	// ��xml�ļ��ַ��������ɽڵ�
		List<String> keysList = new ArrayList<String>();	// �洢�ڵ���
		List<String> valuesList = new ArrayList<String>();	// �洢�ڵ�ֵ
		boolean bPhoto = true;		// �Ƿ������Ƭ
		
		StringBuffer sbInsert = new StringBuffer("INSERT INTO "+S_TABLE_NAME+" (");	// ����insert���ַ���
		StringBuffer sbValue = new StringBuffer(" VALUES(");	// ����values���ַ���
		
		for (int index=0; index<bqNodeList.size(); index++) {
			
			BQNode bqNode = bqNodeList.get(index);
			String ndKey = bqNode.getNodeName();
			// ���node�ڵ�����������������������ݿ�ͬ��
			if (index==0 || index==1 || "name".equals(ndKey) || "keys".equals(ndKey)) ndKey += "1";
			if (index==3 || index==4) ndKey += "2";
			
			String value = bqNode.getNodeValue()==null ? "": bqNode.getNodeValue();
			
			if (bqNode.getNodeName()!=null && bqNode.getNodeName().equalsIgnoreCase("checkPhoto"))  {
				value = value.replaceAll("\\s", ""); // ��Ƭbase64����ֵ
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
			// �����ѯ���
			if (index == 3) sRetVal = bqNode.getNodeValue();
			if (index == 4) sRetVal += "@"+bqNode.getNodeValue();
		}
      
		// �����������
		//String sRequiredData = parseRequiredData(reqHeader,reqData);
		// ƴ���������������ͷ��Ϣ
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
						throw new RuntimeException("ת��BASE64ͼƬʧ�ܣ�");
					}
				} else {
					asql.setParameter(keysList.get(i), "");
				}
			} else {
				asql.setParameter(keysList.get(i), valuesList.get(i));
			}
			
		}
        	/*if ("CHECKPHOTO".equalsIgnoreCase(keysList.get(i))) // �������Ƭ
        		pstmt.setStringForClob(i+1, sVal);
        	else
        		pstmt.setString(i+1, sVal);*/
		Sqlca.executeSQL(asql);
        
		return sRetVal;
	}
	
	public static boolean generateImage(String imgStr, String savePath) {//���ֽ������ַ�������Base64���벢����ͼƬ
        if (imgStr == null) {//ͼ������Ϊ��
            return false;
        }
        
        BASE64Decoder decoder = new BASE64Decoder();
        try {
            //Base64����
            byte[] b = decoder.decodeBuffer(imgStr);
            for(int i=0;i<b.length;++i) {
                if(b[i]<0) {//�����쳣����
                    b[i]+=256;
                }
            }
            // ���Ŀ¼�����ڣ� �򴴽�
           /* File dirFile = new File(savePath);
            if (dirFile.isFile()) {
            	File parFile = dirFile.getParentFile();
            	if (!parFile.exists())
            		parFile.mkdirs();
            } else if (dirFile.isDirectory() && !dirFile.exists()) {
            	dirFile.mkdirs();
            }*/
            //����jpegͼƬ
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
