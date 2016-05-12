package demo;

import java.security.Key;
import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.IvParameterSpec;

import com.sun.org.apache.xml.internal.security.utils.Base64;

public class Test1 {

	public static String encode(String key,byte[] data) throws Exception {
		DESKeySpec dks = new DESKeySpec(key.getBytes());
		SecretKeyFactory keyFactory = SecretKeyFactory. getInstance ("DES");
		//key的长度不能够小于8位字节
		Key secretKey = keyFactory.generateSecret(dks);
		Cipher cipher = Cipher. getInstance ("DES/CBC/PKCS5Padding");
		IvParameterSpec iv=new IvParameterSpec("12345678".getBytes()); //向量
		AlgorithmParameterSpec paramSpec = iv;
		cipher.init(Cipher. ENCRYPT_MODE , secretKey,paramSpec);
		byte[] bytes = cipher.doFinal(data);
		return Base64.encode(bytes);
		
	}

	public static byte[] decode(String key, byte[] data) throws Exception {
		try {
			SecureRandom sr = new SecureRandom();
			DESKeySpec dks = new DESKeySpec(key.getBytes());
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
			// key 的长度不能够小于 8 位字节
			Key secretKey = keyFactory.generateSecret(dks);
			Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");

			IvParameterSpec iv = new IvParameterSpec("12345678".getBytes());
			AlgorithmParameterSpec paramSpec = iv;
			cipher.init(Cipher.DECRYPT_MODE, secretKey, paramSpec);
			return cipher.doFinal(data);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception(e);
		}
	}
	
	public static void main(String[] args) throws Exception {

			// 
			String sEcode = "S078JKKtSvAMWap/sIGpd4eiphXoB0MB8EfFuFogsz8RLhrqnYxuAI8jchhX2zrYlCcVJcbeIfkwP7h6A+13QRIPDjUZPyuGoRHHl4EmIc43V81xC3h4JQtjgBbWbu9/khJBgkdSvCDdTGkXROVKa+QS8gpI01kyDnp9O56l6kJu8P/ZApcgYZOBfcGe1gU4XO+IJFNAzOE=";
			String ecode = Test1.encode("12345678", "abc".getBytes());
			System.out.println(ecode);
			String sdecode = new String (Test1.decode("12345678", Base64.decode(sEcode.getBytes())));
			System.out.println(sdecode);
	}
}
