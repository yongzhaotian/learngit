package com.amarsoft.webclient;

import java.rmi.RemoteException;
import java.security.Key;
import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.Cipher;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.IvParameterSpec;
import javax.xml.rpc.ServiceException;

import org.apache.axis.encoding.Base64;

public class ClientTest {

	public static String encode(String key,byte[] data) throws Exception {
		DESKeySpec dks = new DESKeySpec(key.getBytes());
		SecretKeyFactory keyFactory = SecretKeyFactory. getInstance ("DES");
		Key secretKey = keyFactory.generateSecret(dks);
		Cipher cipher = Cipher. getInstance ("DES/CBC/PKCS5Padding");
		IvParameterSpec iv=new IvParameterSpec("12345678".getBytes()); 
		AlgorithmParameterSpec paramSpec = iv;
		cipher.init(Cipher. ENCRYPT_MODE , secretKey,paramSpec);
		byte[] bytes = cipher.doFinal(data);
		return Base64.encode(bytes);
		
	}

	public static byte[] decode(String key, byte[] data) throws Exception {
		try {
			DESKeySpec dks = new DESKeySpec(key.getBytes());
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
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
	
	public static void main(String[] args) {

		try {
			/*String version = new VersionServiceLocator().getVersion()
					.getVersion();
			System.out.println(version);*/
			
			System.out.println("ehwlelfxxxxxxxxxxxxxxxxxxxxxxxxxxx");

			String ecodex = ClientTest.encode("xxxxxx", "abcxxxxxxxxx".getBytes());
			System.out.println("abcxxxxxxxxx".getBytes());
			
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO: handle exception
		}
	}
}
