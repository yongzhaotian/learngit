<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例上下框架页面
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "个人征信查询授权书"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;个人征信查询授权书&nbsp;&nbsp;"; //默认的内容区标题
	%>
<%/*~END~*/%>

<%
	//文档编号
	String sDocNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
    System.out.println("-------sDocNo:"+sDocNo+",-------sTypeNo:"+sTypeNo);
	if (sTypeNo == null) sTypeNo = "";
	if (sDocNo == null) sDocNo = "";
	
%>

<script type="text/javascript">
	AsControl.OpenView("/AppConfig/Document/AttachmentChooseNoOrder.jsp","DocNo=<%=sDocNo%>&TypeNo=<%=sTypeNo%>","rightup");
	AsControl.OpenView("/ImageManage/ImageViewNoOrderInfo.jsp","ObjectNo=<%=sDocNo%>&TypeNo=<%=sTypeNo%>","rightdown");
</script>

<%@ include file="/IncludeEnd.jsp"%>
