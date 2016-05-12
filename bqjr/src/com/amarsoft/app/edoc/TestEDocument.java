package com.amarsoft.app.edoc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashMap;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.awe.util.Transaction;

/**
 * @author fmwu
 * 
 */
public class TestEDocument {

	public static Transaction getSqlca() throws Exception {
		JBOTransaction tx = null;
		Transaction SqlcaRepository = null;
		
		Class.forName("oracle.jdbc.driver.OracleDriver"); 
		
		String sUrl = "jdbc:oracle:thin:@192.168.1.24:1521:orcl";
		String sDriverName = "oracle.jdbc.driver.OracleDriver";
		String sUserName = "als7c";
		String sUserPass = "als7c";
		
		Connection conn = DriverManager.getConnection(sUrl, sUserName, sUserPass);
		
		SqlcaRepository = new Transaction(conn);
		return SqlcaRepository;
	}

	public static void testEDoc() throws Exception {
		String sTemplateFName = "src/com/amarsoft/app/edoc/����ͬ��ʽ����.doc";
		String sDataDefFName = "src/com/amarsoft/app/edoc/����ͬ���ݶ���.xml";
		String sOutDocName = "D:/tmp/als/Upload/Template/edoc/����ͬ.doc";
		String sOutXmlName = "D:/tmp/als/Upload/Template/edoc/����ͬ����.xml";
		String sOutDefalutName = "D:/tmp/als/Upload/Template/edoc/ȱʡ����ͬ.doc";

		EDocument edoc = new EDocument(sTemplateFName, sDataDefFName);
		// System.out.println(edoc.checkTag());
		// System.out.println(edoc.getTagList());
		// System.out.println(edoc.getDefTagList());
		// edoc.saveAsDefault(sOutDefalutName);
		Transaction Sqlca = getSqlca();
		if (Sqlca != null) {
			HashMap map = new HashMap();
			map.put("SerialNo", "20061020000007");
			edoc.saveData(sOutXmlName, map, Sqlca);
			edoc.saveDoc(sOutDocName, map, Sqlca);
			//Sqlca.conn.close();
		}
		System.out.println("OutFName=" + sOutDocName);
	}

	public static void testStamper() throws Exception {
		String sTemplateFName = "src/com/amarsoft/app/edoc/����ǩ��ҳ.doc";
		String sDataDefFName = "src/com/amarsoft/app/edoc/ǩ��ҳ����.xml";
		String sOutDocName = "D:/tmp/edoc/����ǩ��ҳ��������.doc";
		String sOutXmlName = "D:/tmp/edoc/ǩ��ҳ����.xml";
		String sOutDefalutName = "D:/tmp/edoc/����ǩ��ҳ.doc";

		EDocument edoc = new EDocument(sTemplateFName, sDataDefFName);
		edoc.saveAsDefault(sOutDefalutName);
		HashMap map = new HashMap();
		map.put("EDocName", "    ����ͬ");
		map.put("CustomerName", "�����������缯�����޹�˾");
		map.put("ContractID", "C1001101010800028");

		/*
		Transaction Sqlca = getSqlca();
		if (Sqlca != null) {
			edoc.saveAsDefault(sOutDefalutName);
			edoc.saveData(sOutXmlName, map, Sqlca);
			edoc.saveDoc(sOutDocName, map, Sqlca);
			Sqlca.conn.close();
		}
		*/
		System.out.println("OutFName=" + sOutDocName);
	}
	
	/**
	 * @param args	
	 */
	public static void main(String[] args) {
		try {
			TestEDocument.testEDoc();
			//TestEDocument.testStamper();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
