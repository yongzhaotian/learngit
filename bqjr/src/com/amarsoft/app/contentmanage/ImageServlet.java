package com.amarsoft.app.contentmanage;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;

public class ImageServlet  extends HttpServlet{

	private static final long serialVersionUID = 332233L;

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}
	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String ImageId =  req.getParameter("ImageId");
		String type_ =  req.getParameter("type_");
		if(type_==null) type_="view";
		
		if(StringX.isEmpty(ImageId)) return ;
		ARE.getLog().trace("ImageId:"+ImageId);

	
		File f = new File(ImageId);
		if(!f.exists() && !f.isFile()){
			ARE.getLog().debug("文件"+ImageId+"不存在!");
		}
		
		InputStream inStream = new FileInputStream(f);
		String fileName = f.getName();
		String contentType = "image";
//		resp.reset();
		String browName = fileName;
		String clientInfo = req.getHeader("User-agent");
		if(clientInfo != null && clientInfo.indexOf("MSIE") > 0 ){
			//IE采用URLEncoder方式处理
			if (clientInfo.indexOf("MSIE 6") > 0 || clientInfo.indexOf("MSIE 5") > 0) {
				// IE6，用GBK，此处实现 有局限性
				browName = new String(fileName.getBytes("GBK"), "ISO-8859-1");
			} else {
				// ie7+用URLEncoder方式
				browName = java.net.URLEncoder.encode(fileName, "UTF-8");
			}
		}
		resp.setContentType(contentType);
		if (type_.equals("view") && (contentType.startsWith("image") || contentType.startsWith("text")))
			resp.setHeader("Content-Disposition", "filename="+browName+";");
		else
			resp.setHeader("Content-Disposition", "attachment;filename="+browName+";");
		
		OutputStream outStream = resp.getOutputStream();
		int k=-1;
		byte[] bytes = new byte[10240];
		while ((k = inStream.read(bytes)) >0 ) {
			if (k >= 10240) {
				ARE.getLog().debug("Attachment Read:"+k);
			}
			outStream.write(bytes, 0, k);
		}
		inStream.close();
		outStream.flush();
		outStream.close();
	}
}
