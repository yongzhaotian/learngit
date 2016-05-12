<%@page import="com.amarsoft.awe.res.model.SkinItem"%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String sReloadType = CurPage.getParameter("ReloadType");
	if("FixSkins".equals(sReloadType)){
		if(SkinItem.initFixSkins(session.getServletContext())){
			out.print("SUCCESS");
		}
		return;
	}
	String sPath = CurPage.getParameter("Path");
	String sResult = ASUserHelp.changeSkinPath(CurUser.getUserID(), sPath, Sqlca);
	if(StringX.isSpace(sResult)){
		CurUser.getSkin().setPath(sPath);
		if(!com.amarsoft.awe.res.model.SkinItem.reloadSkin(session.getServletContext(), CurUser.getSkin())){
			Sqlca.rollback();
			sResult = "ÖØÖÃÆ¤·ôÊ§°Ü";
		}
	}
	out.print(sResult);
%><%@ include file="/IncludeEndAJAX.jsp"%>