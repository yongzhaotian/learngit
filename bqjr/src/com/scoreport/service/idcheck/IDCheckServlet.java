package com.scoreport.service.idcheck;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilderFactory;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

import net.sf.json.JSON;
import net.sf.json.JSONObject;
import net.sf.json.xml.XMLSerializer;

import com.amarsoft.app.check.BankCardCheck;
import com.amarsoft.are.ARE;

public class IDCheckServlet extends HttpServlet {

	/**
	 * 
	 */
	static final long serialVersionUID = 5490805165054548990L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		DateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		
		String serialno = req.getParameter("serialno");//��ͬ��
		String realname = req.getParameter("realname");//��ʵ����
		String certno = req.getParameter("certno");//���֤��
		String bankcardtype = req.getParameter("bankcardtype");//���п�����
		String xfbankcode = req.getParameter("xfbankcode");//���б���
		String dkbankcode = req.getParameter("dkbankcode");//�������б���
		String servicetype = req.getParameter("servicetype");//��������
		String bankcardno = req.getParameter("bankcardno");//���п���
		String mobileno = req.getParameter("mobileno");//�ֻ�����
		String infotype = req.getParameter("infotype");//������Դ
		String customerid = req.getParameter("customerid");//�ͻ�ID
		
		BankCardCheck bankCard = new BankCardCheck(serialno, realname, certno, bankcardtype, xfbankcode, dkbankcode, servicetype, bankcardno, mobileno, infotype, customerid);
		String ouid = bankCard.genarateOutid("bqxf");//����������ˮ��
		String validateStr = "";
		String queryStr = "";
		String returnStr = "";
		try {
			validateStr = bankCard.platfromValidate(ouid);
//			System.out.println(validateStr);
			
			JSONObject vaObj = xmltojson(validateStr, 0);
			String result = vaObj.getString("result");
			if("0000".equals(result)){//������ճɹ�
				bankCard.operateCardvalidateInfo(1);//���ճɹ������ĺ�̨���ô���
				Thread.sleep(5000);//�ȴ�����ƽ̨��ѯ���
				queryStr = bankCard.platformQuery(ouid);
				JSONObject queryObj = xmltojson(queryStr,1);
				result = queryObj.getString("result");
				int i = 0;
				while("1001".equals(result) && i < 3){
					Thread.sleep(3000);
					queryStr = bankCard.platformQuery(ouid);
					queryObj = xmltojson(queryStr,1);
					result = queryObj.getString("result");
					i = i + 1;
				}
				if("1001".equals(result)){
					queryObj.put("reqstatus", "03");//�޷��ؽ��
				}else if("0000".equals(result)){
					queryObj.put("reqstatus", "01");//��֤�ɹ�
				}else if("1111".equals(result)){
					queryObj.put("reqstatus", "02");//��֤ʧ��
				}else if("9003".equals(result)){
					queryObj.put("reqstatus", "05");//δ��������
				}else{
					queryObj.put("reqstatus", "04");//δ����ƽ̨
				}
				queryObj.put("ouid", ouid);
				queryObj.put("applytime",df.format(new Date()));
				returnStr = queryObj.toString();
				
			}else{
				returnStr = vaObj.toString();
			}
		} catch (Exception e) {
			bankCard.operateCardvalidateInfo(0);
			JSONObject errObj = new JSONObject();
			errObj.put("result", "6666");
			errObj.put("info", "���Ӵ���ƽ̨ʧ��");
			errObj.put("reqstatus", "04");
			errObj.put("ouid", ouid);
			errObj.put("applytime",df.format(new Date()));
			returnStr = errObj.toString();
			ARE.getLog().error("���Ӵ���ƽ̨����", e);
		}
		resp.setCharacterEncoding("utf-8");
		resp.getWriter().write(returnStr);
		resp.getWriter().flush();
		resp.getWriter().close();
	}
	
	/**
	 * ��������ƽ̨���ص�XML
	 * @param xml
	 * @param flag 0 У��ӿ� 1 ��ѯ�ӿ�
	 * @return
	 * @throws JDOMException
	 * @throws IOException
	 */
	 
	private static JSONObject xmltojson(String xml,int flag) throws JDOMException, IOException{
		InputStream is = new ByteArrayInputStream(xml.getBytes("utf-8"));
		SAXBuilder sb = new SAXBuilder();
		Document d = sb.build(is);
		Element root = d.getRootElement();
		Element result = root.getChild("result");
		Element info = root.getChild("info");
		
		JSONObject obj = new JSONObject();
		obj.put(result.getName(), result.getText());
		obj.put(info.getName(), info.getText());
		if(flag == 1){//��ѯ�ӿ�
			Element resultcode = root.getChild("resultcode");
			obj.put(resultcode.getName(), resultcode.getText());
		}
		return obj;
	}
	
	
	/**
	 * ���������ã�ȱ��jar
	 * json-lib-2.4-jdk15.jar 

		ezmorph-1.0.6.jar 
		
		xom-1.2.1.jar 
		
		commons-lang-2.1.jar 
		
		commons-io-1.3.2.jar 
		
		jaxen-1.1.jar 

	 * @param xml
	 */
	private static void convertXMLtoJSOM(String xml){
		
		XMLSerializer xmlSerializer = new XMLSerializer();
		JSON json = xmlSerializer.read(xml);
		System.out.println(json.toString());
		
		
	}
	
	public static void main(String[] args) {
		String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Return><result>0000</result><info>���ճɹ�</info></Return>";
		//convertXMLtoJSOM(xml);
		try {
			JSONObject obj = xmltojson(xml,0);
			System.out.println(obj.get("info"));
		} catch (JDOMException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	

}
