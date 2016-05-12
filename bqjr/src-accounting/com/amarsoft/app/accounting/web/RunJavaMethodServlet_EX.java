package com.amarsoft.app.accounting.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URLDecoder;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.AWEException;
import com.amarsoft.awe.RuntimeContext;
import com.amarsoft.awe.control.RunJavaMethodServlet;
import com.amarsoft.awe.util.JavaMethod;
import com.amarsoft.awe.util.JavaMethodReturn;

public class RunJavaMethodServlet_EX extends RunJavaMethodServlet {
	private static final long serialVersionUID = 1L;
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		String dataSource = getInitParameter("DataSource");
		if ((dataSource == null) || ("".equals(dataSource)))
			dataSource = "als";
		ARE.getLog().debug(
				"[RED] RunJavaMethodServlet InitParameter : DataSource["
						+ dataSource + "]");
		
		response.setContentType("text/html; charset=GBK");
		response.setHeader("Cache-Control", "no-store");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0L);
		response.setCharacterEncoding("utf-8");

		HttpSession session = request.getSession();

		RuntimeContext CurARC = (RuntimeContext) session
				.getAttribute("CurARC");
		if (CurARC == null) {
			response.sendRedirect(request.getContextPath()
					+ "/Frame/page/sys/SessionExpire.jsp");
			return;
		}
		
		JavaMethodReturn ret = new JavaMethodReturn();
		PrintWriter out = response.getWriter();
		String sClassName = request.getParameter("ClassName");
		String sMethodName = request.getParameter("MethodName");
		String sArgs = request.getParameter("Args");
		if (sArgs == null)
			sArgs = "";
		else
			sArgs = URLDecoder.decode(sArgs, "UTF-8");
		String sArgsObject = request.getParameter("ArgsObject");
		if ("Sqlca".equalsIgnoreCase(sArgsObject)) {
			ret = JavaMethod.runSqlca(sClassName, sMethodName, sArgs,
					dataSource);
		} else if ("Trans".equalsIgnoreCase(sArgsObject)) {
			ret = JavaMethod.runTrans(sClassName, sMethodName, sArgs);
		}else if ("LAS".equalsIgnoreCase(sArgsObject)) {
			ret = JavaMethod.runTrans(sClassName, sMethodName, sArgs);
		} else {
			ret = JavaMethod.run(sClassName, sMethodName, sArgs);
		}
		out.print(ret.getReturnText());
		out.flush();
		out.close();
	}
	
	private JavaMethodReturn runMethod(String sClassName, String sMethod, String sArgs) throws AWEException{
		Map<String, String> args = JavaMethod.getArgMap(sArgs);
		JavaMethodReturn ret = new JavaMethodReturn();
		try {
			Class c = Class.forName(sClassName);
			StringBuffer sbf = new StringBuffer("[Method] Java");
			sbf.append(" ClassName");
			sbf.append("[");
			sbf.append(sClassName);
			sbf.append("]");
			sbf.append(" Method");
			sbf.append("[");
			sbf.append(sMethod);
			sbf.append("]");
			Object object = c.newInstance();
			ARE.getLog().trace(sbf.toString());
			
			Method m = c.getMethod(sMethod, new Class[0]);
			Object o = m.invoke(object, new Object[0]);
			if (o == null) {
				ARE.getLog().warn(
						"AWES0005 [Method] [" + sClassName + "][" + sMethod
								+ "] Return Object is null!");
			}
			ret.setResult((String) o);
			
		} catch (Exception e) {
			if (e instanceof NoSuchMethodException) {
				ret.setCode("AWES0005");
				ret.setResult("后台服务方法不存在");
				ARE.getLog().warn(
						"AWES0005 [Method] [" + sClassName + "][" + sMethod
								+ "] is Not Exist!", e);
			} else if (e instanceof ClassNotFoundException) {
				ret.setCode("AWES0005");
				ret.setResult("后台服务类不存在");
				ARE.getLog().warn(
						"AWES0005 [Method] [" + sClassName + "][" + sMethod
								+ "] is Not Exist!", e);
			} else if (e instanceof InvocationTargetException) {
				Throwable e1 = ((InvocationTargetException) e)
						.getTargetException();
				ARE.getLog().error("AWES0009:RunJavaMethod异常", e1);
				throw new AWEException("AWES0009", e1);
			}
		}
		return ret;
	}
	
}
