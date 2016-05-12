<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%@
 page import="com.amarsoft.are.jbo.JBOFactory" %><%@
 page import="com.amarsoft.are.jbo.BizObjectManager" %>
<%
	//获取jbo的list
	BizObjectManager bomOne = JBOFactory.getFactory().getManager("jbo.ui.test.TEST_CUSTOMER_INFO");
	ASObjectModel doTemp = new ASObjectModel(bomOne);
	doTemp.setVisible("*",false); //缺省显示全部属性，这里设置全部不显示的
	doTemp.setVisible("SERIALNO,CUSTOMERNAME,TELEPHONE",true);   //设置显示的
	doTemp.setColumnFilter("CUSTOMERNAME",true);
	//doTemp.setDDDWCode("ISINUSE","YesNo"); 
	doTemp.setJboWhere("1=1");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(10);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			
	};
%><%@
include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
