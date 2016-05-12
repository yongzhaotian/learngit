<%@ page contentType="text/html; charset=GBK"%>
<%@ page language="java" import="com.amarsoft.awe.dw.ui.control.Star"  pageEncoding="GBK"%>
<%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "FiveStarMark";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	//doTemp.setHtmlEvent("STAR", "onclick", "testclick");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//只读模式
	dwTemp.genHTMLObjectWindow(CurPage.getParameter(""));
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","获取评分","获取评分","getMark()","","","",""}
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
