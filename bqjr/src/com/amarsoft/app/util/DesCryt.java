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
	 * �ӽ����㷨
	 * @param data  �ӽ�������
	 * @param key   ��Կ
	 * @param mode  ģʽ
	 * @return      �ӽ��ܽ��
	 */
	public static byte[] desCryt(byte[] data, byte[] key, int mode){
		byte[] result = null ;
		try {
			SecureRandom sr = new SecureRandom();  
			SecretKeyFactory keyFactory;
			DESKeySpec dks = new DESKeySpec(key);
			keyFactory = SecretKeyFactory.getInstance("DES");
			SecretKey secretkey = keyFactory.generateSecret(dks); 
			//����Cipher����
			Cipher cipher = Cipher.getInstance("DES/ECB/NoPadding");  
			//��ʼ��Cipher����  
			cipher.init(mode, secretkey, sr);  
			//�ӽ���
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
	  * byte����ת����16�����ַ���
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
	  * 16�����ַ���ת��byte����
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
	 
	 //�����㷨
	 public static String encode(String key, byte[] data) throws Exception{
        DESKeySpec dks=new DESKeySpec(key.getBytes());
        SecretKeyFactory keyFactory =SecretKeyFactory .getInstance("DES");
        //ksy�ĳ��Ȳ��ܹ�С��8λ�ֽ�
        Key secretkey=keyFactory.generateSecret(dks);
        Cipher cipher=Cipher.getInstance("DES/CBC/PKCS5Padding");
        IvParameterSpec iv=new IvParameterSpec("12345678".getBytes());//����
        AlgorithmParameterSpec paramSpec=iv;
        cipher.init(Cipher.ENCRYPT_MODE, secretkey,paramSpec);
        byte[] bytes=cipher.doFinal(data);
		return Base64.encode(bytes);
	}
	 
	//�����㷨
	public static byte[] decode(String key, byte[] data) throws Exception{
		 try{
			SecureRandom sr=new SecureRandom();
	        DESKeySpec dks=new DESKeySpec(key.getBytes());
	        SecretKeyFactory keyFactory =SecretKeyFactory .getInstance("DES");
	        //ksy�ĳ��Ȳ��ܹ�С��8λ�ֽ�
	        Key secretkey=keyFactory.generateSecret(dks);
	        Cipher cipher=Cipher.getInstance("DES/CBC/PKCS5Padding");
	        
	        IvParameterSpec iv=new IvParameterSpec("12345678".getBytes());//����
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
			//��ӡ���
			System.out.println("���ܽ����"+result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		
		/*	//�ӽ���ģʽ(����)
			int mode = Cipher.ENCRYPT_MODE;
			//���ӽ���byte����16�����ַ���
			String dataHexString = "43424424234324209808";
			//��Կbyte����16�����ַ���
			String keyHexString = "9AAB1D2EE004AAC3";
			byte[] data = hexString2Bytes(dataHexString);
			byte[] key = hexString2Bytes(keyHexString);
			byte[] result = desCryt(data, key, mode);
			//��ӡ���
			System.out.println("���ܽ����"+bytes2HexString(result));
			*/
            /*
				//�ӽ���ģʽ�����ܣ�
				int mode = Cipher.DECRYPT_MODE;
				//���ӽ���byte����16�����ַ���
				String dataHexString = "7D592BF239849E76";
				//��Կbyte����16�����ַ���
				String keyHexString = "9AAB1D2EE004AAC3";
				byte[] data = hexString2Bytes(dataHexString);
				byte[] key = hexString2Bytes(keyHexString);
				byte[] result = desCryt(data, key, mode);
				//��ӡ���
				System.out.println("���ܽ����"+bytes2HexString(result));
			*/
	}
}
