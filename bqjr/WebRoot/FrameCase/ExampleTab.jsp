<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
	/* 
	页面说明： 通过数组定义生成Tab框架页面示例
	*/
	//定义tab数组：
	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
		{"true", "List", "/FrameCase/ExampleList.jsp", ""},
		{"true", "Info", "/FrameCase/ExampleInfo.jsp", "ExampleId=2013012300000001"},
		{"true", "Tab", "/FrameCase/ExampleTab.jsp", ""},
		{"true", "Blank", "/Blank.jsp", ""},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>