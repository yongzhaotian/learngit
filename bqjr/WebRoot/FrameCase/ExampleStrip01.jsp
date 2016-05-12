<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
 	/* 
 		页面说明： 通过数组定义生成strip框架页面示例
 	*/
 	//定义strip数组：
 	//参数：0.是否显示, 1.标题，2.URL，3，参数串
	String sTabStrip[][] = {
		{"true", "典型List", "/FrameCase/ExampleList.jsp", ""},
		{"true", "典型Info", "/FrameCase/ExampleInfo.jsp", "ExampleId=2012081700000001"},
		{"true", "其他List", "/FrameCase/ExampleList.jsp", ""},
	};
%><%@include file="/Resources/CodeParts/Strip01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>