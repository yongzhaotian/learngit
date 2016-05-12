<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","导出Txt","导出Txt","exportPage('"+sWebRootPath+"',0,'txt','"+dwTemp.getArgsValue()+"')","","","",""},
		{"true","","Button","导出Html","导出Html","exportPage('"+sWebRootPath+"',0,'html','"+dwTemp.getArgsValue()+"')","","","",""},
		{"true","","Button","导出Excel","导出Excel","exportPage('"+sWebRootPath+"',0,'excel','"+dwTemp.getArgsValue()+"')","","","",""},
		{"true","","Button","导出Pdf","导出pdf","exportPage('"+sWebRootPath+"',0,'pdf','"+dwTemp.getArgsValue()+"')","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
