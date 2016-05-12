package com.amarsoft.app.util;

import java.io.File;
import java.net.URL;
import java.util.Vector;

public class ASLocator {
	private static ASLocator asl = null;

	public static String getRoot() {
		if (asl == null ) asl = new ASLocator();
		String resourcePath = "/"+asl.getClass().getName();
		resourcePath = resourcePath.replace('.','/');
		URL url = asl.getClass().getResource(resourcePath+".class");
		String xmlPath = url.getFile();
    	xmlPath = xmlPath.substring(0,xmlPath.indexOf("WEB-INF"));
    	if( xmlPath.startsWith("file:")) xmlPath = xmlPath.substring(6);
//    	if (xmlPath.startsWith("/")) xmlPath = xmlPath.substring(1,xmlPath.length());
		return xmlPath ;
	}
	
	public static String[] getFileList(String sFilePath,String sSuffix) throws Exception {
		if( sFilePath == null || sFilePath.equals("") )
			sFilePath = File.listRoots()[0].getPath();
		File fDir = new File(sFilePath);
		if (!fDir.isDirectory())
			throw new Exception("指定的路径不是目录：" + sFilePath);
		File[] fList = fDir.listFiles();
		Vector vFile = new Vector(10,10);
		for (int i = 0; i < fList.length; i++) {
			if (fList[i].isFile() && fList[i].getName().endsWith(sSuffix))
				vFile.addElement(fList[i].getName());
		}
		String[] saRet = new String[vFile.size()];
		for (int j = 0; j < vFile.size(); j++)
			saRet[j] = (String) vFile.elementAt(j);
		return saRet;
	}
}
