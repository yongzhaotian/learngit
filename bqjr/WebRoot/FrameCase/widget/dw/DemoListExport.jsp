<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","����Txt","����Txt","exportPage('"+sWebRootPath+"',0,'txt','"+dwTemp.getArgsValue()+"')","","","",""},
		{"true","","Button","����Html","����Html","exportPage('"+sWebRootPath+"',0,'html','"+dwTemp.getArgsValue()+"')","","","",""},
		{"true","","Button","����Excel","����Excel","exportPage('"+sWebRootPath+"',0,'excel','"+dwTemp.getArgsValue()+"')","","","",""},
		{"true","","Button","����Pdf","����pdf","exportPage('"+sWebRootPath+"',0,'pdf','"+dwTemp.getArgsValue()+"')","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
