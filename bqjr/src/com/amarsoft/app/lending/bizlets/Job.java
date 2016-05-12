package com.amarsoft.app.lending.bizlets;

import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class Job extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception {
		//�ֻ�����
		
		String sTelePhone = (String)this.getAttribute("TelePhone");
		//���ɶ�̬����
		String sDynamicPassWord = this.getPassword(6, false, true);
		String testcontent="�����֤��Ϊ:";
		sendMessages(testcontent,sDynamicPassWord,sTelePhone);
		return sDynamicPassWord;
	}	
	
    public static String getPassword(int count, boolean letters, boolean numbers) { 
        return org.apache.commons.lang.RandomStringUtils.random(count, letters, numbers); 
    } 
	
	 /**
     * ���Ͷ���
     * 
     * @param testcontent
     * @return
	 * @throws Exception 
     */
    public void sendMessages(String testcontent,String sDynamicPassWord,String sTelePhone) throws Exception{  
    	
    	// �������Ͷ��Žӿڲ���

    	//String username = "szbq"; // �û�id��Ŀǰ�̶�9570�����ԣ�bill
    	String username = "IT"; // �û�id��Ŀǰ�̶�9570�����ԣ�bill
    	//String pwd = "szbq123"; // ���룬 ���ԣ�abc@123   	
    	String pwd = "IT123"; // ���룬 ���ԣ�abc@123   	
    	String epid= "120012"; // ͨ��id��12610�����ͨ�����۸�7.00�֣�12663����ҵӦ�ã�������棩�۸�7.00��  	
    	String tele = sTelePhone; // �绰����  ���ԣ�13428905223,13798577593,15019258650    ��ʽ��15122638978,13621113262,18681526819,18576698906
    	String linkid="";
    	String subcode="";
    	String stestcontent=testcontent+sDynamicPassWord;
    	String plaintext = pwd; // ����md5���������ַ����� ���»��ߴ���  	
    	String password = Md5(plaintext); // ��ȡMD5��������
    	//System.out.println("�û���"+username+"�����룺"+password+"��ͨ����"+channelid+"���绰���룺"+tele+"������Ϊ��"+stestcontent);
    	System.out.println("�û���"+username+"�����룺"+password+"����ҵID��"+epid+"���绰���룺"+tele+"������Ϊ��"+stestcontent);
    	
    	try {
    		// ��������ʹ��gbk��urlencode����
    		
    		String msg  = URLEncoder.encode(stestcontent, "gb2312");
    		// ���Ͷ��Žӿ�·��
        	//String url = "http://admin.sms9.net/houtai/sms.php?cpid="+username+"&password="+password+"&channelid="+channelid+"&tele="+tele+"&msg="+msg+"&timestamp="+ timestamp;
        	String url = "http://114.255.71.158:8061/?username="+username+"&password="+password+"&message="+msg+"&phone="+tele+"&epid="+epid+"&linkid="+linkid+"&subcode="+ subcode;
        	System.out.println(url);	
        	String res = getReturnData(url);
        	System.out.println(res);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("���Ͷ����쳣");
		}
    }
    
    /**
     * ͨ�����µķ�����ȡURL���ӷ��ص�����Ϣ
     * 
     * @param urlString
     * @return
     * @throws Exception 
     */
	public String getReturnData(String urlString) throws Exception {
		String res = ""; 
		try { 
			URL url = new URL(urlString);
			java.net.HttpURLConnection conn = (java.net.HttpURLConnection)url.openConnection();
			conn.setDoOutput(true);
			conn.setRequestMethod("GET");
			java.io.BufferedReader in = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream(),"UTF-8"));
			String line;
			while ((line = in.readLine()) != null) {
				res += line;
			}
			in.close();
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("���ö��Žӿ��쳣");
		}
		
		return res;
	} 
	
	/**
	 * Md5����
	 * 
	 * @param plainText
	 * @return
	 * @throws Exception 
	 */
	public String Md5(String plainText) throws Exception { 
		String res = ""; 
		try { 
			MessageDigest md = MessageDigest.getInstance("MD5"); 
			md.update(plainText.getBytes()); 
			byte b[] = md.digest(); 
	
			int i; 
	
			StringBuffer buf = new StringBuffer(""); 
			for (int offset = 0; offset < b.length; offset++) { 
				i = b[offset]; 
				if(i<0) 
					i+= 256; 
				if(i<16) 
				    buf.append("0"); 
				buf.append(Integer.toHexString(i)); 
			} 			
			res = buf.toString(); //32λ�ļ��� 
		} catch (NoSuchAlgorithmException e) { 
			e.printStackTrace();
			throw new Exception("MD5�����쳣");
		} 
		
		return res;
	}
}
