<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%if(CurConfig.getParameter("RunMode")!=null && CurConfig.getParameter("RunMode").equals("Development")){
	//�ǿ���ģʽ������Ԥ��
 %>
<%
	//System.out.println("title=" + AWEHelp.getPageTitle(CurPage));
	String sTempletNo = CurPage.getParameter("DONO");//ģ���
	ASDataObject doTemp = new ASDataObject(sTempletNo);
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	String sButtons[][] = {
		
	};
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<%}%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
