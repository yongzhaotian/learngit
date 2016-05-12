package com.amarsoft.webservice.util;

import java.awt.image.BufferedImage;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.ResultSet;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class FileHandler {

	public static void main(String args[]) throws IOException {
		// FileHandler fh = new FileHandler();
		// FileInputStream is = fh.InputFile();
		// fh.OutputFile(is);

	}


	public void OutputFile(InputStream is) throws IOException {

		byte[] buf = new byte[2048];
		int len = 0;
		File f = new File("E:/Image/Output/01.jpg");
		FileOutputStream outs = new FileOutputStream(f);
		BufferedOutputStream output = new BufferedOutputStream(outs);
		System.out.println("OutputStream is ini");
		while ((len = is.read(buf, 0, 2048)) != -1) {
			System.out.println("output...");
			output.write(buf, 0, len);
		}
		if (is != null)
			is.close();
		if (output != null)
			output.close();
		System.out.println("End");
	}

	public static byte[] image2Bytes(String imagePath) {
		ImageIcon ima = new ImageIcon(imagePath);
		BufferedImage bu = new BufferedImage(ima.getImage().getWidth(null), ima
				.getImage().getHeight(null), BufferedImage.TYPE_INT_RGB);
		ByteArrayOutputStream imageStream = new ByteArrayOutputStream();
		try {
			// �����jpgͼ��д���������ȥ,�������ת��ͼƬ�ı����ʽ
			boolean resultWrite = ImageIO.write(bu, "jpg", imageStream);
		} catch (IOException e) {
			e.printStackTrace();
		}
		byte[] bImage = imageStream.toByteArray();
		return bImage;
	}

	public static String GetImageStr(String imgFilePath) {
		// ��ͼƬ�ļ�ת��Ϊ�ֽ������ַ��������������Base64���봦��
		byte[] data = null;
		// ��ȡͼƬ�ֽ�����
		try {
			InputStream in = new FileInputStream(imgFilePath);
			data = new byte[in.available()];
			in.read(data);
			in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		// ���ֽ�����Base64����
		BASE64Encoder encoder = new BASE64Encoder();
		return encoder.encode(data);// ����Base64��������ֽ������ַ���
	}

	// ��Base64ת����ͼƬ
	public static boolean GenerateImage(String imgStr, String imgFilePath) {// ���ֽ������ַ�������Base64���벢����ͼƬ
		if (imgStr == null)
			// ͼ������Ϊ��
			return false;
		BASE64Decoder decoder = new BASE64Decoder();
		try {
			// Base64����
			byte[] bytes = decoder.decodeBuffer(imgStr);
			for (int i = 0; i < bytes.length; ++i) {
				if (bytes[i] < 0) {// �����쳣����
					bytes[i] += 256;
				}
			}
			// ����jpegͼƬ
			OutputStream out = new FileOutputStream(imgFilePath);
			out.write(bytes);
			out.flush();
			out.close();
			return true;
		} catch (Exception e) {
			return false;
		}
	}
}
