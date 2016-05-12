package com.scoreport.serviceclient;

import java.io.IOException;
import java.io.StringReader;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.xml.sax.InputSource;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.RuntimeContext;
import com.amarsoft.context.ASUser;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class ScoreTaskServlet extends HttpServlet {

	/**
	 * 
	 */
	static final long serialVersionUID = 5490805165054548998L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}

	@SuppressWarnings("deprecation")
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String CertID = req.getParameter("CertID");
		String SerialNo = req.getParameter("SerialNo");
		
		Map map = null;
		try {
			String scoretask_partner_code = Configure.getInstance().getConfigure("scoretask_partner_code");
			String scoretask_partner_key = Configure.getInstance().getConfigure("scoretask_partner_key");
			IScoreTask ist = new IScoreTask();
			IScoreTaskPortType iScoreTaskHttpPort = ist.getIScoreTaskHttpPort();
			String xmlData = getETLPortXml(CertID,SerialNo);
			
			ARE.getLog().info("��ʼ���ͱ��ģ����ͱ���Ϊ��"+xmlData);
			String sResult = iScoreTaskHttpPort.createTask(scoretask_partner_code, scoretask_partner_key, xmlData);
			ARE.getLog().info("�ӿڷ��ر��ģ�"+sResult);
			map = proeResult(sResult);
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().error("���ýӿ�ʧ�ܣ�ʧ��ԭ��"+e);
			resp.getWriter().write("fail");
		}
		if(map!=null&&map.size()>0){
			String msg = (String) map.get("msg");
			String result = (String) map.get("result");
//			System.out.println("���ͽӿڱ���Ϊ��"+xmlData);
//			System.out.println("�ӿڷ��ر��ģ�"+sResult);
//			System.out.println("���ýӿڷ��ش���Ϊ��"+result);
//			System.out.println("���ýӿڷ���˵����"+msg);
			ARE.getLog().info("���ýӿڷ��ش���Ϊ��"+result);
			ARE.getLog().info("���ýӿڷ���˵����"+msg);
		}
		resp.getWriter().write("success");
		resp.getWriter().flush();
		resp.getWriter().close();
	}
		

		public static String getETLPortXml(String CertID,String SerialNo){
			String xmlData = null ;
			String currTime =new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
			xmlData = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?> \n"
					+"<validate> \n"+
					"<serialno>"+SerialNo+"</serialno> \n"+	   
					"<id_number>"+CertID+"</id_number> \n"+
				//	"<account_mobile>"+PhoneNo+"</account_mobile> \n"+
					"<inputdate>"+currTime+"</inputdate> \n"+ 
					"<channeltype>01</channeltype> \n"+
					"</validate>";
			
			return xmlData;
		}
	
		/**
		 * ��������ı���
		 * 
		 * @param param
		 * @return
		 * @throws Exception
		 */
		@SuppressWarnings({ "rawtypes", "unchecked" })
		private static Map<String, String> proeResult(String param) throws Exception {
			Map resultMap = new HashMap();
			StringReader read = new StringReader(param);
			InputSource source = new InputSource(read);
			SAXBuilder sb = new SAXBuilder();
			Document doc;
			String msg = "���Ľ����ɹ�!";
			String result = "0000";
			try {
				doc = sb.build(source);
				if (doc != null) {
					Element root = doc.getRootElement();
					if (root != null ) {
						Element element = root.getChild("result"); //�������
						if(element != null){
							resultMap.put("result", element.getValue());
						}
						
						element = root.getChild("info"); //���˵��
						if(element != null){
							resultMap.put("msg", element.getValue());
						}
					}
				}
			} catch (Exception e) {
				msg = "�����������쳣";
				result = "9999";
				resultMap.put("msg", msg);
				resultMap.put("result", result);
			} finally {
				read.close();
			}
			return resultMap;
		}
	
	

}
