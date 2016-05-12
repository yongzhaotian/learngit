package com.amarsoft.app.edoc;

import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class FileViewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			HttpSession session = request.getSession(true);
			if ((session == null) || (session.getAttributeNames() == null)) {
				throw new Exception("------Timeout------");
			}
			String sFileName = "";
			String sContentType = "text/html";
			String sViewType = "view";

			sFileName = DataConvert.toString(request.getParameter("filename"));
			sContentType = DataConvert.toString(request.getParameter("contenttype"));
			sViewType = DataConvert.toString(request.getParameter("viewtype"));

			ARE.getLog().debug("[FileViewServlet]" + sContentType + ":" + sFileName);

			File dFile = null;
			File nFile = null;
			dFile = new File(sFileName);
			if(!dFile.exists()){
				sFileName = new String(sFileName.getBytes("ISO-8859-1"),"GBK");
				nFile = new File(sFileName);
			}
			if (!nFile.exists()) {
				ARE.getLog().warn("[FileViewServlet-ERR]文件不存在:" + sFileName + "!");
				String sCon = "文件不存在 !";
				ServletOutputStream outStream = response.getOutputStream();
				outStream.println(DataConvert.toRealString(3, sCon));
				outStream.flush();
				outStream.close();
			} else {
				String sNewFileName = StringFunction.getFileName(sFileName);
				String browName = sNewFileName;
				String clientInfo = request.getHeader("User-agent");
				if ((clientInfo != null) && (clientInfo.indexOf("MSIE") > 0)) {
					if ((clientInfo.indexOf("MSIE 6") > 0) || (clientInfo.indexOf("MSIE 5") > 0)) {
						browName = new String(sNewFileName.getBytes("GBK"),"ISO-8859-1");
					} else {
						browName = URLEncoder.encode(sNewFileName, "UTF-8");
					}
				}
				response.setContentType(sContentType + ";charset=GBK");
				if (sViewType.equals("view"))
					response.setHeader("Content-Disposition", "filename=" + browName + ";");
				else {
					response.setHeader("Content-Disposition", "attachment;filename=" + browName + ";");
				}
				ServletOutputStream outStream2 = response.getOutputStream();
				InputStream inStream = new FileInputStream(sFileName);

				int iContentLength = (int) nFile.length();
				if ((iContentLength < 0) || (iContentLength > 102400))
					iContentLength = 102400;
				byte[] abyte0 = new byte[iContentLength];
				int k = -1;
				while ((k = inStream.read(abyte0, 0, iContentLength)) > 0) {
					if (k >= 10240) {
						ARE.getLog().debug("[FileViewServlet]Read:" + k);
					}
					outStream2.write(abyte0, 0, k);
				}
				inStream.close();

				outStream2.flush();
				outStream2.close();
				return;
			}
		} catch (Exception e1) {
			ARE.getLog().error("[FileViewServlet-ERR]", e1);
		}
	}

	public String getServletInfo() {
		return "This is a file view servlet!";
	}
}