package com.amarsoft.app.lending.bizlets;

import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class Job extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception {
		//手机号码
		
		String sTelePhone = (String)this.getAttribute("TelePhone");
		//生成动态密码
		String sDynamicPassWord = this.getPassword(6, false, true);
		String testcontent="你的验证码为:";
		sendMessages(testcontent,sDynamicPassWord,sTelePhone);
		return sDynamicPassWord;
	}	
	
    public static String getPassword(int count, boolean letters, boolean numbers) { 
        return org.apache.commons.lang.RandomStringUtils.random(count, letters, numbers); 
    } 
	
	 /**
     * 发送短信
     * 
     * @param testcontent
     * @return
	 * @throws Exception 
     */
    public void sendMessages(String testcontent,String sDynamicPassWord,String sTelePhone) throws Exception{  
    	
    	// 构建发送短信接口参数

    	//String username = "szbq"; // 用户id，目前固定9570，测试：bill
    	String username = "IT"; // 用户id，目前固定9570，测试：bill
    	//String pwd = "szbq123"; // 密码， 测试：abc@123   	
    	String pwd = "IT123"; // 密码， 测试：abc@123   	
    	String epid= "120012"; // 通道id，12610：广告通道，价格7.00分；12663：行业应用（禁发广告）价格7.00分  	
    	String tele = sTelePhone; // 电话号码  测试：13428905223,13798577593,15019258650    正式：15122638978,13621113262,18681526819,18576698906
    	String linkid="";
    	String subcode="";
    	String stestcontent=testcontent+sDynamicPassWord;
    	String plaintext = pwd; // 构建md5加密明文字符串， 用下划线串联  	
    	String password = Md5(plaintext); // 获取MD5加密密码
    	//System.out.println("用户："+username+"，密码："+password+"，通道："+channelid+"，电话号码："+tele+"，内容为："+stestcontent);
    	System.out.println("用户："+username+"，密码："+password+"，企业ID："+epid+"，电话号码："+tele+"，内容为："+stestcontent);
    	
    	try {
    		// 汉字内容使用gbk的urlencode编码
    		
    		String msg  = URLEncoder.encode(stestcontent, "gb2312");
    		// 发送短信接口路径
        	//String url = "http://admin.sms9.net/houtai/sms.php?cpid="+username+"&password="+password+"&channelid="+channelid+"&tele="+tele+"&msg="+msg+"&timestamp="+ timestamp;
        	String url = "http://114.255.71.158:8061/?username="+username+"&password="+password+"&message="+msg+"&phone="+tele+"&epid="+epid+"&linkid="+linkid+"&subcode="+ subcode;
        	System.out.println(url);	
        	String res = getReturnData(url);
        	System.out.println(res);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("发送短信异常");
		}
    }
    
    /**
     * 通过以下的方法获取URL连接返回的流信息
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
			throw new Exception("调用短信接口异常");
		}
		
		return res;
	} 
	
	/**
	 * Md5加密
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
			res = buf.toString(); //32位的加密 
		} catch (NoSuchAlgorithmException e) { 
			e.printStackTrace();
			throw new Exception("MD5加密异常");
		} 
		
		return res;
	}
}
