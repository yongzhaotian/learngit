<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	/*
	Author: syang 2009/12/17
	Tester:
	Content: ����̨�û��Զ���TAB�����ݿ⽻���Ž�ҳ�棬����ֱ��ʹ��RunMethodʱ���������ݻ�������
	Input Param:
	Output param:
	*/
	
	String operate  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Operate"));
	String userid  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String tabid = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TabID"));
	String tabname = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TabName"));
	String script = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Script"));
	String cache = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Cache"));
	String close = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Close"));
	
	com.amarsoft.app.util.WorkTipTabsManage wttm = new com.amarsoft.app.util.WorkTipTabsManage();
	wttm.setAttribute("Operate",operate);
	wttm.setAttribute("UserID",userid);
	wttm.setAttribute("TabID",tabid);
	wttm.setAttribute("TabName",tabname);
	wttm.setAttribute("Script",script);
	wttm.setAttribute("Cache",cache);
	wttm.setAttribute("Close",close);
	out.println(wttm.run(Sqlca));
%>
<%@ include file="/IncludeEndAJAX.jsp"%>
