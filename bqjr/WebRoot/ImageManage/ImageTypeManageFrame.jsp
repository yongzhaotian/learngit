<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例上下框架页面
 */
 
	//获得页面参数
	String sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
 	String compNo = CurComp.getParameter("compNo");
 	
%><%@include file="/Resources/CodeParts/Frame03.jsp"%>
<%-- <input id="mediaTypeNo" type="hidden" value="<%=sStartWithId%>"/> --%>
<script type="text/javascript">	
	myleft.width=400;
	//var param = "Type=<%=sType%>";
	if("<%=compNo%>"=="1"){
		AsControl.OpenView("/ImageManage/ImageTypeTreePreview.jsp", "", "frameleft","");
		AsControl.OpenView("/ImageManage/ImageTypeList.jsp","", "frameright","");
	}else if("<%=compNo%>"=="2"){
		AsControl.OpenView("/ImageManage/ProductTypeTreePreview.jsp", "", "frameleft","");
	}else if("<%=compNo%>"=="3"){
		AsControl.OpenView("/ImageManage/ProductTreePreview.jsp", "", "frameleft","");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>
