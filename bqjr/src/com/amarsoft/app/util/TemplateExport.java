package com.amarsoft.app.util;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;


/**
 * 主要用于把datawindow的页面业务要素导出为一个文档
 * @author Administrator
 *
 */
public class TemplateExport {
	private String fileSavePath = "";
	
	public TemplateExport(String request){
		fileSavePath = request;
	}
	
	/**
	 * 生成文件
	 * @param list 存放了显示模板元素的list
	 * @param ext 扩展名，如".xls"
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws IOException
	 */
	public String genFile(Vector list,String ext) throws UnsupportedEncodingException, IOException{
		java.io.File dFile = new java.io.File(fileSavePath);
		if (!dFile.exists()){
			dFile.mkdir();
		}
		
		java.text.SimpleDateFormat sdf_temp = new java.text.SimpleDateFormat("yyyyMMdd_HHmmssSSS");
		String sNow = sdf_temp.format(new java.util.Date());
		String sSourceName = sNow + ext;
		String xlsFileName = fileSavePath+"/" + sSourceName;
		String sFileZipName = fileSavePath+"/" + sNow + ".zip";
		java.io.File xlsFile = new java.io.File(xlsFileName);
		if(!xlsFile.exists()){
			xlsFile.createNewFile();
		}
		java.io.FileOutputStream xlsFileOut = new java.io.FileOutputStream(xlsFile);

		xlsFileOut.write(str2byte("<HTML leftmargin='5%' topmargin='auto'>")); 
		xlsFileOut.write(str2byte("<HEAD>"));
		xlsFileOut.write(str2byte("<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=gb_2312-80\">"));
		xlsFileOut.write(str2byte("</HEAD>"));
		xlsFileOut.write(str2byte("<BODY> "));


		xlsFileOut.write(str2byte("<table>"));
		xlsFileOut.write(str2byte("<TBODY>"));
		
		//标题
		xlsFileOut.write(str2byte("<TR>"));
		xlsFileOut.write(str2byte("<TH>要素名称</TH>"));
		xlsFileOut.write(str2byte("<TH>输入方式</TH>"));
		xlsFileOut.write(str2byte("<TH>数据来源</TH>"));
		xlsFileOut.write(str2byte("<TH>显示格式</TH>"));
		xlsFileOut.write(str2byte("<TH>必输项</TH>"));
		xlsFileOut.write(str2byte("<TH>征信说明</TH>"));
		xlsFileOut.write(str2byte("<TH>备注</TH>"));
		xlsFileOut.write(str2byte("</TR>"));
		for(int i=0;i<list.size();i++){
			String[] row = (String[])list.get(i);
			xlsFileOut.write(str2byte("<TR>"));
			xlsFileOut.write(str2byte("<TD>"+row[0]+"</TD>"));
			xlsFileOut.write(str2byte("<TD>"+row[1]+"</TD>"));
			xlsFileOut.write(str2byte("<TD>"+row[2]+"</TD>"));
			xlsFileOut.write(str2byte("<TD>"+row[3]+"</TD>"));
			xlsFileOut.write(str2byte("<TD>"+row[4]+"</TD>"));
			xlsFileOut.write(str2byte("<TD>"+row[5]+"</TD>"));
			xlsFileOut.write(str2byte("<TD>"+row[6]+"</TD>"));
			xlsFileOut.write(str2byte("</TR>"));
		}
		
		xlsFileOut.write(str2byte("</TBODY>"));
		xlsFileOut.write(str2byte("</TABLE>"));
		xlsFileOut.write(str2byte("</BODY>"));
		xlsFileOut.write(str2byte("</HTML>"));
		zipFileEx(fileSavePath,sSourceName, sFileZipName);// ZipFiles(fs,sFileZipName);
		return sFileZipName; 
		//return xlsFileName; 
	}
	private static byte[] str2byte(String s) throws UnsupportedEncodingException {
			return s.getBytes("GBK");
	}
	public static void zipFileEx(String FilePath, String FileName, String ZipFileName) throws IOException {
		String sSlash = "\\";
		if (FilePath.indexOf("/") >= 0)
			sSlash = "/";
		if (!sSlash.equals(FilePath.substring(FilePath.length() - 1)))
			FilePath = FilePath + sSlash;

		ZipOutputStream os = new ZipOutputStream(new java.io.FileOutputStream(ZipFileName));

		ZipEntry ze = new ZipEntry(FileName);
		ze.setMethod(ZipEntry.DEFLATED);
		os.putNextEntry(ze);

		java.io.FileInputStream fs = new java.io.FileInputStream(FilePath.concat(FileName));
		byte[] buff = new byte[1024];
		int n = 0;
		while ((n = fs.read(buff, 0, buff.length)) > 0){
			os.write(buff, 0, n);
		}
		fs.close();
		os.closeEntry();
		os.close();
	}
}
