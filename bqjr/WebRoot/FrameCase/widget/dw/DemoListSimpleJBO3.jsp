<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%@
 page import="com.amarsoft.are.jbo.JBOFactory" %><%@
 page import="com.amarsoft.are.jbo.BizObjectManager" %>
<%
	//��ȡjbo��list
	BizObjectManager bomOne = JBOFactory.getFactory().getManager("jbo.ui.test.V_EXAMPLE_UE");
	ASObjectModel doTemp = new ASObjectModel(bomOne);
	doTemp.setJboWhere("1=1");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(10);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			
	};
%><%@
include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
