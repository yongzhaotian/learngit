package demo;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.mail.Session;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.amarsoft.are.ARE;
import com.amarsoft.context.ASUser;
import com.amarsoft.context.ASUserHelp;

/**
 * ������Ҫ������ӳ��õľ�̬��������
 * @author lishui
 *
 */
public class CoderUtils {  
  
    public static char ascii2Char(int ASCII) {  
        return (char) ASCII;  
    }  
  
    public static int char2ASCII(char c) {  
        return (int) c;  
    }  
  
    public static String ascii2String(int[] ASCIIs) {  
        StringBuffer sb = new StringBuffer();  
        for (int i = 0; i < ASCIIs.length; i++) {  
            sb.append((char) ascii2Char(ASCIIs[i]));  
        }  
        return sb.toString();  
    }  
  
    public static String ascii2String(String ASCIIs) {  
        String[] ASCIIss = ASCIIs.split(",");  
        StringBuffer sb = new StringBuffer();  
        for (int i = 0; i < ASCIIss.length; i++) {  
            sb.append((char) ascii2Char(Integer.parseInt(ASCIIss[i])));  
        }  
        return sb.toString();  
    }  
  
    public static int[] string2ASCII(String s) {// �ַ���ת��ΪASCII��  
        if (s == null || "".equals(s)) {  
            return null;  
        }  
  
        char[] chars = s.toCharArray();  
        int[] asciiArray = new int[chars.length];  
  
        for (int i = 0; i < chars.length; i++) {  
            asciiArray[i] = char2ASCII(chars[i]);  
        }  
        return asciiArray;  
    }  
  
    public static String getIntArrayString(int[] intArray) {  
        return getIntArrayString(intArray, ",");  
    }  
  
    public static String getIntArrayString(int[] intArray, String delimiter) {  
        StringBuffer sb = new StringBuffer();  
        for (int i = 0; i < intArray.length; i++) {  
            sb.append(intArray[i]).append(delimiter);  
        }  
        return sb.toString();  
    }  
  
    public static String getASCII(int begin, int end) {  
        StringBuffer sb = new StringBuffer();  
        for (int i = begin; i < end; i++) {  
            sb.append(i).append(":").append((char) i).append("/t");  
            // sb.append((char) i).append("/t");  
            if (i % 10 == 0) {  
                sb.append("/n");  
            }  
        }  
        return sb.toString();  
    }  
  
    public static String getCHASCII(int begin, int end) {  
        return getASCII(19968, 40869);  
    }  
  
    public static void showASCII(int begin, int end) {  
        for (int i = begin; i < end; i++) {  
            // System.out.print(i + ":" + (char) i + "/t");  
            System.out.print((char) i + "/t");  
            if (i % 10 == 0) {  
                System.out.println();  
            }  
        }  
    }  
  
    public static void showCHASCII() {  
        showASCII(19968, 40869);  
    }  
  
    public static void showIntArray(int[] intArray) {  
        showIntArray(intArray, ",");  
    }  
  
    public static void showIntArray(int[] intArray, String delimiter) {  
        for (int i = 0; i < intArray.length; i++) {  
            System.out.print(intArray[i] + delimiter);  
        }  
    }  
  
    /**
     * 
    * @autuor
    * @Title: createFile 
    * @Description: TODO(this method is uesed to create file ) 
    * @param @param filePathAndName
    * @param @param fileContent
    * @param @throws IOException    
    * @return void    
    * @throws
     */
    public static void createFile(String filePathAndName, String fileContent)  
            throws IOException {  
  
        String filePath = filePathAndName;  
        filePath = filePath.toString();  
        File myFilePath = new File(filePath);  
        if (!myFilePath.exists()) {  
            myFilePath.createNewFile();  
        }  
        FileWriter resultFile = new FileWriter(myFilePath);  
        PrintWriter myFile = new PrintWriter(resultFile);  
        String strContent = fileContent;  
        myFile.println(strContent);  
        myFile.close();  
        resultFile.close();  
    }  
  
    private static String getLocationByMobile(final String mobile) throws ParserConfigurationException, SAXException,
    IOException {
        String MOBILEURL = " http://www.youdao.com/smartresult-xml/search.s?type=mobile&q=";
        ARE.getLog().info(MOBILEURL);
        String result = callUrlByGet(MOBILEURL + mobile, "GBK");
        StringReader stringReader = new StringReader(result);
        InputSource inputSource = new InputSource(stringReader);
        DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
        Document document = documentBuilder.parse(inputSource);
        if (!(document.getElementsByTagName("location").item(0) == null)) {
            return document.getElementsByTagName("location").item(0).getFirstChild().getNodeValue();
        } else {
            return "�޴˺ż�¼��";
        }
    }

    /**
     * ����Url����ʹ��Get��ʽ
     * @param callurl
     * @param charset
     * @return
     */
    private static String callUrlByGet(String callurl, String charset) {
    String result = "";
    try {
        URL url = new URL(callurl);
        URLConnection connection = url.openConnection();
        connection.connect();
        BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream(), charset));
        String line;
        while ((line = reader.readLine()) != null) {
            result += line;
            result += "\n";
        }
    } catch (Exception e) {
        e.printStackTrace();
        return "";
    }
    return result;
    }

    /**
     *  ͨ��tenpay��ȡ�ֻ�������
     * @param tel
     * @return
     * @throws Exception
     */
    public static String getMobileLocation(String tel){
        Pattern pattern = Pattern.compile("1\\d{10}");
        Matcher matcher = pattern.matcher(tel);
        int i=0;
        while(true){
        	
        	if(i==100){
        		return "Exception";
        	}
        	i++;
        try{
        if (matcher.matches()) {
            String url = "http://life.tenpay.com/cgi-bin/mobile/MobileQueryAttribution.cgi?chgmobile=" + tel;
            String result = callUrlByGet(url, "GBK");
            StringReader stringReader = new StringReader(result);
            InputSource inputSource = new InputSource(stringReader);
            DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
            Document document = documentBuilder.parse(inputSource);
            String retmsg = document.getElementsByTagName("retmsg").item(0).getFirstChild().getNodeValue();
            if (retmsg.equals("OK")) {
                String supplier = document.getElementsByTagName("supplier").item(0).getFirstChild().getNodeValue().trim();
                String province = document.getElementsByTagName("province").item(0).getFirstChild().getNodeValue().trim();
                String city = document.getElementsByTagName("city").item(0).getFirstChild().getNodeValue().trim();
                if (province.equals("-") || city.equals("-")) {
                	getLocationByMobile(tel);
                	ARE.getLog().info("�Ƹ�ͨ��ѯ���"+tel + "," + supplier + "," + getLocationByMobile(tel));
                    return (tel + "," + supplier + "," + getLocationByMobile(tel));
                } else {
                	ARE.getLog().info("�Ƹ�ͨ��ѯ���"+tel + "," + supplier + "," + province + city);
                    return (tel + "," + supplier + "," + province + city);
                }
            } else {
                return "Exception";
            }
        } else {
            return "Exception";
        }
        }catch(Exception e)
        {
            e.printStackTrace();
            ARE.getLog().error(e.getMessage());
            continue;
        }
        }
    }
    /**
     * ͨ��138�ӿڻ�ȡ������
     * @param mobile
     * @return
     * @throws Exception
     */
    public static String getMobileAddress(String mobile)
    {
        String address = "";
        int i=0;
        while(true){
        	
        	if(i==150){
        		return "";
        	}
        	i++;
        try
        {
            mobile = mobile.trim();
        if (mobile.matches("^(13|15|18|14|12|16|17|19|10|11)\\d{9}$") || mobile.matches("^(013|015|018|014|012|016|017|019|010|011)\\d{9}$")) //��13��15��18��ͷ�������λȫΪ����
        {
            String url = "http://www.ip138.com:8080/search.asp?action=mobile&mobile=" + mobile;
            URLConnection connection = (URLConnection) new URL(url).openConnection();
            connection.setDoOutput(true);
            connection.setConnectTimeout(60 * 1000);// �������ӳ�ʱʱ��Ϊ10�� 
            connection.setReadTimeout(60 * 1000);// ���ö�ȡ��ʱʱ��Ϊ20�� 
            InputStream os = connection.getInputStream();
            Thread.sleep(100);
            int length = os.available();
            byte[] buff = new byte[length];
            os.read(buff);
            String s = new String(buff, "gbk");
            //System.out.println("����������Ϣ  1  "+s);
            int len = s.lastIndexOf("���Ź�����");
            s = s.substring(len, len+100);
            //System.out.println("����������Ϣ  2  "+s);
            len = s.lastIndexOf("</TD>");
            address = s.substring(0, len);
            len = address.lastIndexOf(">");
            address = address.substring(len+1, address.length());
            //System.out.println("����������Ϣ  3  "+address);
            address = address.replace("&nbsp;", ",");
            address = address.replace("d> -->", "");
            address = address.replace(" -->", "");
            address = address.replace("-->", "");
            s = null;
            buff = null;
            os.close();
            connection = null;
            }
        return address;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            ARE.getLog().error(e.getMessage());
            address = "δ֪";
            System.out.println("�ֻ�"+mobile+",�����ز�ѯʧ��====================");
            continue;
        }
        
        }
    }
    
     /**
      * �ж��Ƿ�Ϊ���غ���,��غ�������0
      * @param phoneNumber
      * @param cityName
      * @return
      * @throws Exception
      */
    public static void  check(String mobile){
    	String inputLine = "";
    	String urlStr = "http://life.tenpay.com/cgi-bin/mobile/MobileQueryAttribution.cgi?chgmobile="+mobile;
    	while(true) {
    		try {
    			URL url = new URL(urlStr);
    			URLConnection uc = url.openConnection();
    			InputStream is = uc.getInputStream();
    			int buf = is.available();
    			byte[] b = new byte[buf];
    			is.read(b);
    			inputLine = new String(b, "GBK");
    			ARE.getLog().info(inputLine);
    			is.close();
    			break;
    		} catch (Exception e) {
    			e.printStackTrace();
    			continue;
    		}
    	}
    }
    public static String changePhoneNumber(String phoneNumber,String cityName) throws Exception{
        if (phoneNumber.matches("^(13|15|18)\\d{9}$") || phoneNumber.matches("^(013|015|018)\\d{9}$")){ //�ж��Ƿ�Ϊ�ֻ�����
        	if(getMobileLocation(phoneNumber).indexOf(cityName)>0){//�Ƿ�Ϊ���غ���
                return phoneNumber;
            }else{
                return "0"+phoneNumber;
            }
        }else{
            return phoneNumber;
        }
    }
    /**
     * �ж��Ƿ�Ϊ����غ���,IP138�ӿ�
     * @param phoneNumber
     * @param cityName
     * @return
     * @throws Exception
     */
/*    public static String checkphone(String phoneNumber,String cityName) throws Exception{
    	String flag = "Exception";
    	if (phoneNumber.matches("^(13|15|18|14|12|16|17|19|10|11)\\d{9}$") || phoneNumber.matches("^(013|015|018|014|012|016|017|019|010|011)\\d{9}$")){ //�ж��Ƿ�Ϊ�ֻ�����
    		String sReturn = getMobileAddress(phoneNumber);
    		ARE.getLog().info("sReturn="+sReturn);
    		if("".equals(sReturn)||sReturn==null||sReturn.length()<=0){
    			return flag;
    		}
 	   
    		if(sReturn.indexOf(cityName)>0){//�����ֻ�����
    			flag = "true";
    		}else{//��غ���
    			flag = "false";
    		}
    		
    	}else if(phoneNumber.matches("^[+]{0,4}[0,4](\\d){2,3}[ ]?([-]?((\\d)|[ ]){1,14})+$")||phoneNumber.matches("^\\d{7,8}+$")){//�绰����У��
    			flag = "true";
    	}
    	ARE.getLog().info("flag="+flag);
    	return flag;
 	   
    }
    */
    /**
     * �ж��Ƿ�Ϊ���غ���,��غ�������0
     * @param phoneNumber
     * @param cityName
     * @return
     * @throws Exception
     */
   public static String checkphone(String phoneNumber,String cityName) throws Exception{
       if (phoneNumber.matches("^1[3|4|5|7|8][0-9]\\d{8}$")){ //�ж��Ƿ�Ϊ�ֻ�����
    	   if(getMobileLocation(phoneNumber).equals("Exception")){
    		   return "Exception";
           }
           if(getMobileLocation(phoneNumber).indexOf(cityName)>0){//�Ƿ�Ϊ���غ���
               return "true";
           }else{
               return "false";
           }
       }else if(phoneNumber.matches("^[+]{0,4}[0,4](\\d){2,3}[ ]?([-]?((\\d)|[ ]){1,14})+$")||phoneNumber.matches("^\\d{7,8}+$")){ 
           return "true";
       }else{
    	   return "Exception";
       }
   }
    
    public static void main(String[] args) throws IOException {  
       // System.out.println("\u8BFB\u53D6\u914D\u7F6E\u6587\u4EF6\u9519\u8BEF\uFF01\u8BF7\u68C0\u67E5\u914D\u7F6E\u6587\u4EF6\u3002");
        try {
        	System.out.println("�ֻ�������:" + checkphone("14543456565","����"));
            /*System.out.println("�ֻ�������:" + changeAllPhoneNumber("13510731129","����"));
            System.out.println("�ֻ�������:" + changeAllPhoneNumber("075567656798","����"));*/
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }  
} 