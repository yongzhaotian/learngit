<%@ page contentType="text/html; charset=GBK"%>
<%@ page language="java" import="com.amarsoft.awe.dw.ui.control.Star"  pageEncoding="GBK"%>
<%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "FiveStarMark";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setHtmlEvent("STAR", "onclick", "testclick");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","All","Button","��ȡ����","��ȡ����","getMark()","","","",""}
	};
	sButtonPosition = "north";
%>
<%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function setMark(i){
		setItemValue(0,0,"STAR",i);
	}
	function getMark(){
		alert(getItemValue(0,0,"STAR"));
	}
	function testclick(){
		getMark();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
