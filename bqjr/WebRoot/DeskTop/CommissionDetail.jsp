<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String ym = DataConvert.toRealString(
			iPostChange,(String)CurComp.getParameter("ym"));
	
	String param = DataConvert.toRealString(
			iPostChange,(String)CurComp.getParameter("param"));
	String myCSURL = CurConfig.getConfigure("MyCSURL");
	if (myCSURL == null || "".equals(myCSURL)) {
		out.print("<br /><span style=\"color: red; margin-left: 50px; margin-top: ");
		out.print("50px; font-family: verdana,arial,sans-serif; font-size:12px; ");
		out.print("font-weight: bolder;\">���ó���δ�����ļ�·����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>");
		out.print("<span style=\"color: blue; cursor: pointer; font-family: ");
		out.print("verdana,arial,sans-serif; font-size:12px; font-weight: bolder;\" ");
		out.print("onclick=\"javascript: history.go(-1);\" />");
		out.print("������һҳ</span>");
	}
	if (ym == null || "".equals(ym) || param == null 
			|| "".equals(param)) {
		out.print("<br /><span style=\"color: red; margin-left: 50px; ");
		out.print("margin-top: 50px; font-family: "); 
		out.print("verdana,arial,sans-serif; font-size:12px; font-weight: ");
		out.print("bolder;\">δ�ҵ���Ӧ����Ϣ������ϵ����Ա��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>");
		out.print("<span style=\"color: blue; cursor: pointer; font-family: ");
		out.print("verdana,arial,sans-serif; font-size:12px; font-weight: bolder;\" ");
		out.print("onclick=\"javascript: history.go(-1);\" />");
		out.print("������һҳ</span>");
	} else {
		try {
			String path = myCSURL + "COMMISSION" + File.separator + ym + File.separator + param + ".html";
			BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(path), "GBK"));
			String line = "";
			StringBuffer buffer = new StringBuffer();
			while ((line=br.readLine()) != null) {
				buffer.append(line);
			}
			out.print(buffer.toString());
		} catch (Exception e) {
			e.printStackTrace();
			out.print("<br /><span style=\"color: red; margin-left: 50px; ");
			out.print("margin-top: 50px; font-family: "); 
			out.print("verdana,arial,sans-serif; font-size:12px; font-weight: ");
			out.print("bolder;\">δ�ҵ���Ӧ����Ϣ������ϵ����Ա��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>");
			out.print("<span style=\"color: blue; cursor: pointer; font-family: ");
			out.print("verdana,arial,sans-serif; font-size:12px; font-weight: bolder;\" ");
			out.print("onclick=\"javascript: history.go(-1);\" />");
			out.print("������һҳ</span>");
		}
	}
%>
<%@ include file="/IncludeEnd.jsp"%>