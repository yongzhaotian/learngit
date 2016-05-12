package com.amarsoft.app.util;

import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;
import java.security.spec.InvalidKeySpecException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.IvParameterSpec;

import com.sun.org.apache.xml.internal.security.utils.Base64;

public class DesCryt {
	
	/**
	 * 加解密算法
	 * @param data  加解密数据
	 * @param key   秘钥
	 * @param mode  模式
	 * @return      加解密结果
	 */
	public static byte[] desCryt(byte[] data, byte[] key, int mode){
		byte[] result = null ;
		try {
			SecureRandom sr = new SecureRandom();  
			SecretKeyFactory keyFactory;
			DESKeySpec dks = new DESKeySpec(key);
			keyFactory = SecretKeyFactory.getInstance("DES");
			SecretKey secretkey = keyFactory.generateSecret(dks); 
			//创建Cipher对象
			Cipher cipher = Cipher.getInstance("DES/ECB/NoPadding");  
			//初始化Cipher对象  
			cipher.init(mode, secretkey, sr);  
			//加解密
			result = cipher.doFinal(data); 
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (InvalidKeySpecException e) {
			e.printStackTrace();
		} catch (NoSuchPaddingException e) {
			e.printStackTrace();
		} catch (InvalidKeyException e) {
			e.printStackTrace();
		} catch (IllegalBlockSizeException e) {
			e.printStackTrace();
		} catch (BadPaddingException e) {
			e.printStackTrace();
		} 
		
		return result;
	}
	
	 /**
	  * byte数组转换成16进制字符串
	 * @param b
	 * @return
	 */
	public static String bytes2HexString(byte[] b) {
		    String ret = "";
		    for (int i = 0; i < b.length; i++) {
		      String hex = Integer.toHexString(b[i] & 0xFF);
		      if (hex.length() == 1) {
		        hex = '0' + hex;
		      }
		      ret += hex.toUpperCase();
		    }
		    return ret;
	}
	
	 /**
	  * 16进制字符串转成byte数组
	 * @param src
	 * @return
	 */
	public static byte[] hexString2Bytes(String src){
		    byte[] ret = new byte[8];
		    byte[] tmp = src.getBytes();
		    for(int i=0; i<8; i++){
		      ret[i] = uniteBytes(tmp[i*2], tmp[i*2+1]);
		    }
		    return ret;
	 }
	
	 public static byte uniteBytes(byte src0, byte src1) {
		    byte _b0 = Byte.decode("0x" + new String(new byte[]{src0})).byteValue();
		    _b0 = (byte)(_b0 << 4);
		    byte _b1 = Byte.decode("0x" + new String(new byte[]{src1})).byteValue();
		    byte ret = (byte)(_b0 ^ _b1);
		    return ret;
	}
	 
	 //加密算法
	 public static String encode(String key, byte[] data) throws Exception{
        DESKeySpec dks=new DESKeySpec(key.getBytes());
        SecretKeyFactory keyFactory =SecretKeyFactory .getInstance("DES");
        //ksy的长度不能够小于8位字节
        Key secretkey=keyFactory.generateSecret(dks);
        Cipher cipher=Cipher.getInstance("DES/CBC/PKCS5Padding");
        IvParameterSpec iv=new IvParameterSpec("12345678".getBytes());//向量
        AlgorithmParameterSpec paramSpec=iv;
        cipher.init(Cipher.ENCRYPT_MODE, secretkey,paramSpec);
        byte[] bytes=cipher.doFinal(data);
		return Base64.encode(bytes);
	}
	 
	//解密算法
	public static byte[] decode(String key, byte[] data) throws Exception{
		 try{
			SecureRandom sr=new SecureRandom();
	        DESKeySpec dks=new DESKeySpec(key.getBytes());
	        SecretKeyFactory keyFactory =SecretKeyFactory .getInstance("DES");
	        //ksy的长度不能够小于8位字节
	        Key secretkey=keyFactory.generateSecret(dks);
	        Cipher cipher=Cipher.getInstance("DES/CBC/PKCS5Padding");
	        
	        IvParameterSpec iv=new IvParameterSpec("12345678".getBytes());//向量
	        AlgorithmParameterSpec paramSpec=iv;
	        cipher.init(Cipher.DECRYPT_MODE, secretkey,paramSpec);
	        byte[] bytes=cipher.doFinal(data);
			return bytes;
		  }catch(Exception e){
			  e.printStackTrace();
			  throw new Exception(e);
		  }
	}
	 
	 
	 
	public static void main(String[] args) {
		try {
			String data="abc";
			String key="12345678";
			byte[] keys = hexString2Bytes(key);
			String result=encode(data,keys);
			//打印结果
			System.out.println("加密结果："+result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		
		/*	//加解密模式(加密)
			int mode = Cipher.ENCRYPT_MODE;
			//被加解密byte数组16进制字符串
			String dataHexString = "43424424234324209808";
			//秘钥byte数组16进制字符串
			String keyHexString = "9AAB1D2EE004AAC3";
			byte[] data = hexString2Bytes(dataHexString);
			byte[] key = hexString2Bytes(keyHexString);
			byte[] result = desCryt(data, key, mode);
			//打印结果
			System.out.println("加密结果："+bytes2HexString(result));
			*/
            /*
				//加解密模式（解密）
				int mode = Cipher.DECRYPT_MODE;
				//被加解密byte数组16进制字符串
				String dataHexString = "7D592BF239849E76";
				//秘钥byte数组16进制字符串
				String keyHexString = "9AAB1D2EE004AAC3";
				byte[] data = hexString2Bytes(dataHexString);
				byte[] key = hexString2Bytes(keyHexString);
				byte[] result = desCryt(data, key, mode);
				//打印结果
				System.out.println("解密结果："+bytes2HexString(result));
			*/
	}
}
