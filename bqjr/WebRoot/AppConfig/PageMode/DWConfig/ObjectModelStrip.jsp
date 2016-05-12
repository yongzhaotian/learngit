<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
 	/* 
 		页面说明： 通过数组定义生成strip框架页面示例
 	*/
 	String sDoNo = CurPage.getParameter("DONO");
	if(sDoNo==null) sDoNo = "";
 	//定义strip数组：
 	//参数：0.是否显示, 1.标题，2.高度，3.组件ID，4.URL，5，参数串，6.事件
	String sStrips[][] = {
		{"true","模板目录信息" ,"300","OWCatalogInfo","/AppConfig/PageMode/DWConfig/ObjectModelCatalogInfo.jsp","DONO="+sDoNo,""},
		{"true","模板定义信息" ,"600","OWLibList","/AppConfig/PageMode/DWConfig/ObjectModelLibraryList.jsp","DONO="+sDoNo,""},
	};
 	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/Strip05.jsp"%>
<script type="text/javascript">	
	setDialogTitle("显示模板配置");
	//$("#ConditonMap1Tab3").click();
	document.getElementById("ConditonMap1Tab3").click();
</script>
<%@ include file="/IncludeEnd.jsp"%>