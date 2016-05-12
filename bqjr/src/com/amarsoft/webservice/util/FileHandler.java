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
			// 把这个jpg图像写到这个流中去,这里可以转变图片的编码格式
			boolean resultWrite = ImageIO.write(bu, "jpg", imageStream);
		} catch (IOException e) {
			e.printStackTrace();
		}
		byte[] bImage = imageStream.toByteArray();
		return bImage;
	}

	public static String GetImageStr(String imgFilePath) {
		// 将图片文件转化为字节数组字符串，并对其进行Base64编码处理
		byte[] data = null;
		// 读取图片字节数组
		try {
			InputStream in = new FileInputStream(imgFilePath);
			data = new byte[in.available()];
			in.read(data);
			in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		// 对字节数组Base64编码
		BASE64Encoder encoder = new BASE64Encoder();
		return encoder.encode(data);// 返回Base64编码过的字节数组字符串
	}

	// 将Base64转换成图片
	public static boolean GenerateImage(String imgStr, String imgFilePath) {// 对字节数组字符串进行Base64解码并生成图片
		if (imgStr == null)
			// 图像数据为空
			return false;
		BASE64Decoder decoder = new BASE64Decoder();
		try {
			// Base64解码
			byte[] bytes = decoder.decodeBuffer(imgStr);
			for (int i = 0; i < bytes.length; ++i) {
				if (bytes[i] < 0) {// 调整异常数据
					bytes[i] += 256;
				}
			}
			// 生成jpeg图片
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
