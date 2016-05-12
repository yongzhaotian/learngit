<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
 	/* 
 		页面说明： 通过数组定义生成strip框架页面示例
 	*/
 	//定义strip数组：
 	//参数：0.是否显示, 1.标题，2.高度，3.组件ID，4.URL，5，参数串，6.事件
	String sStrips[][] = {
		{"true","典型List" ,"500","ExampleList","/FrameCase/ExampleList.jsp","",""},
		{"true","典型Info" ,"500","ExampleInfo","/FrameCase/ExampleInfo.jsp","ExampleId=2012081700000001",""},
	};
 	String sButtons[][] = {
 			{"true","","Button","按钮1","按钮1","aaa()",sResourcesPath,"btn_icon_edit"},
 			{"true","","Button","按钮2","按钮2","bbb()",sResourcesPath,"btn_icon_help"},
 	};
%><%@include file="/Resources/CodeParts/Strip05.jsp"%>
<script type="text/javascript">
	function aaa(){
		alert(1);
	}
	
	function bbb(){
		alert(2);
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>