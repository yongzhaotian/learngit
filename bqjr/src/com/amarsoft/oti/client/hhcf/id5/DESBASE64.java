package com.amarsoft.oti.client.hhcf.id5;

import java.security.Key;
import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.IvParameterSpec;


/**
 * ID5加密揭密
 * @author Administrator
 *
 */
public class DESBASE64 {
	
	public static final String ALGORITHM_DES = "DES/CBC/PKCS5Padding";
	public static final String DES_CRYPT_CHARSET = "GBK";

    /**
     * DES算法，加密
     *
     * @param data 待加密字符串
     * @param key  加密私钥，长度不能够小于8位
     * @return 加密后的字节数组，一般结合Base64编码使用
     * @throws CryptException 异常
     */
    public static String encode(String key,String data) throws Exception
    {
        return encode(key, data.getBytes());
    }
    /**
     * DES算法，加密
     *
     * @param data 待加密字符串
     * @param key  加密私钥，长度不能够小于8位
     * @return 加密后的字节数组，一般结合Base64编码使用
     * @throws CryptException 异常
     */
    public static String encode(String key,byte[] data) throws Exception
    {
        try
        {
	    	DESKeySpec dks = new DESKeySpec(key.getBytes());
	    	
	    	SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
            //key的长度不能够小于8位字节
            Key secretKey = keyFactory.generateSecret(dks);
            Cipher cipher = Cipher.getInstance(ALGORITHM_DES);
            IvParameterSpec iv = new IvParameterSpec("12345678".getBytes());
            AlgorithmParameterSpec paramSpec = iv;
            cipher.init(Cipher.ENCRYPT_MODE, secretKey,paramSpec);
            
            byte[] bytes = cipher.doFinal(data);
            return Base64.encode(bytes);
        } catch (Exception e)
        {
            throw new Exception(e);
        }
    }

    /**
     * DES算法，解密
     *
     * @param data 待解密字符串
     * @param key  解密私钥，长度不能够小于8位
     * @return 解密后的字节数组
     * @throws Exception 异常
     */
    public static byte[] decode(String key,byte[] data) throws Exception
    {
        try
        {
        	SecureRandom sr = new SecureRandom();
	    	DESKeySpec dks = new DESKeySpec(key.getBytes());
	    	SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
            //key的长度不能够小于8位字节
            Key secretKey = keyFactory.generateSecret(dks);
            Cipher cipher = Cipher.getInstance(ALGORITHM_DES);
            IvParameterSpec iv = new IvParameterSpec("12345678".getBytes());
            AlgorithmParameterSpec paramSpec = iv;
            cipher.init(Cipher.DECRYPT_MODE, secretKey,paramSpec);
            return cipher.doFinal(data);
        } catch (Exception e)
        {
            throw new Exception(e);
        }
    }
    
    /**
     * 获取编码后的值
     * @param key
     * @param data
     * @return
     * @throws Exception
     */
    public static String decodeValue(String key,String data) 
    {
    	byte[] datas;
    	String value = null;
		try {
			if(System.getProperty("os.name") != null && (System.getProperty("os.name").equalsIgnoreCase("sunos") || System.getProperty("os.name").equalsIgnoreCase("linux")))
	        {
	    		datas = decode(key, Base64.decode(data));
	        }
	    	else
	    	{
	    		datas = decode(key, Base64.decode(data));
	    	}
			
			return new String(datas, "GB18030");
		} catch (Exception e) {
			e.printStackTrace();
			value = "";
		}
    	return value;
    }

    public static void main(String[] args) throws Exception
    {
      
      //System.out.println("明：abc ；密：" + Des2.encode("12345678","abc"));
  	 // System.out.println("明：ABC ；密：" + Des2.encode("12345678","ABC"));
  	 // //System.out.println("明：中国人 ；密：" + Des2.encode("12345678","中国人"));
  	//  System.out.println("g3ME4dIH/5dpd1M mHqZ2eWk8pxuq8V5=" + Des2.decodeValue("88888888", "g3ME4dIH/5dpd1MmHqZ2eWk8pxuq8V5"));
//  	  System.out.println("ss=" + Des2.decodeValue("88888888", "rc+uwHsk8I4SGFElQ4NMQbZgdrPwMSNrfv0Pt5RQ15/2q+i7jd6JFOgahlPhhGDuohv5MS7K8UZiVxP7Zp796Y0FQPJu58wx5LhlHUEZCUXcHAKnjX0EsQSrpfmIF/JZxMfcGCNWCABDTRQG8oDs2CMYGI/g2cmL9nU6EpG4RGH9zhx9Gsovv/mnxKKqLI9fySUfAaMxReEZoUWpEFPKk7xvV7mxQsUNNaaCekCt0D+FP65bQBweZA=="));
  	 
  	 // System.out.println("明：在那遥远的地方 ；密：" + Des2.encode("12345678","g3ME4dIH/5dpd1M mHqZ2eWk8pxuq8V5"));
  	  //System.out.println(new String(Des2.decode("wwwid5cn", "ABB0E340805D367C438E24FC4005C121F60247F6EE4430B5".toLowerCase().getBytes())));
  	  System.out.println("dd=" + DESBASE64.encode("12345678", new String("idtagpckhd")));
  	  System.out.println("dd=" + DESBASE64.encode("88888888", new String("周慧".getBytes("GBK"),"GBK")));
  	  System.out.println("dd=" + DESBASE64.decodeValue("12345678", "yPJEpR5wlVn35Ag+YyRsSw=="));
  	System.out.println("dd=" + DESBASE64.decodeValue("88888888", "URaCiPDpEbI="));
    }
	
}
