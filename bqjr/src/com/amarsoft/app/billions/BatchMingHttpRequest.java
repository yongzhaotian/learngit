package com.amarsoft.app.billions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.xml.sax.InputSource;

public class BatchMingHttpRequest {
    /**
     * 
     * @param url
     * @param param
     */
    public static String sendGet(String url, String param) {
        String result = "";
        BufferedReader in = null;
        try {
            String urlNameString = url + "?" + param;
            URL realUrl = new URL(urlNameString);
            URLConnection connection = realUrl.openConnection();
            connection.setRequestProperty("accept", "*/*");
            connection.setRequestProperty("connection", "Keep-Alive");
            connection.setRequestProperty("user-agent",
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            connection.connect();
            Map<String, List<String>> map = connection.getHeaderFields();
            for (String key : map.keySet()) {
                System.out.println(key + "--->" + map.get(key));
            }
            in = new BufferedReader(new InputStreamReader(
                    connection.getInputStream()));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (in != null) {
                    in.close();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return result;
    }

    /**
     * 
     * @param url
     * @param param
     */
    public static Map sendPost(String url, String param){
    	OutputStreamWriter out =null;

        BufferedReader in = null;
        String result = "";
            URL realUrl;
			try {
				realUrl = new URL(url);
				URLConnection conn;
				try {
					conn = realUrl.openConnection();
					conn.setRequestProperty("accept", "*/*");
					conn.setRequestProperty("connection", "Keep-Alive");
					conn.setRequestProperty("user-agent",
					"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
					conn.setDoOutput(true);
					conn.setDoInput(true);
					    out = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");  //8859_1        
					out.write(param);
					out.flush();
					in = new BufferedReader(
							new InputStreamReader(conn.getInputStream(),"utf-8"));
					String line;
					while ((line = in.readLine()) != null) {
						result += line;
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			} catch (MalformedURLException e) {
				e.printStackTrace();
			}
        finally{
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
	        catch (Exception ex) {
	        	ex.printStackTrace();
	        } 
        }
        return getBatchMingS(result);
    } 
  public static Map getBatchMingS(String str){
	  Map  map  =  new HashMap();
	  String retresult="ERROOOO1";
	  String retrInfo="异常的数据";
	  String retrpolicyNo="";
	  String changepremium="";
	  if("".equals(str)|| str ==null){
    	  map.put("retResult", retresult);
    	  map.put("retrInfo", retrInfo);
	  }
    
    	  StringReader read = new StringReader(str);
    	  InputSource source = new InputSource(read);
    	  SAXBuilder sb = new SAXBuilder();
         org.jdom.Document doc;
		try {
			doc = sb.build(source);
			if(doc != null){
				Element root = doc.getRootElement();
				if(root!= null &&root.getChild("person") != null){
					Element result=root.getChild("person").getChild("result"); //退保费
					Element changeum=root.getChild("person").getChild("changepremium"); //退保费
					Element info=root.getChild("person").getChild("info"); //0000  代表成功
					Element policyNo=root.getChild("person").getChild("orgPolicyNo"); //保单号
					if(result != null){
						
						retresult=result.getValue();
					}
					if(info != null){
						
						retrInfo=info.getValue();
					}
					if(policyNo != null){
						
						retrpolicyNo=policyNo.getValue();
					}
					if(changeum != null){
						changepremium=changeum.getValue();
					}					
				}
			}
		} catch (JDOMException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			map.put("retrpolicyNo", retrpolicyNo);
			map.put("retResult", retresult);
			map.put("retrInfo", retrInfo);
			map.put("changepremium", changepremium);
		}
      return map;
  }
}