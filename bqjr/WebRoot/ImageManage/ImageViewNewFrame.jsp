<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例上下框架页面
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%
	//文档编号
	String sDocNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	//获取判断贷前还是贷后的依据参数
	String uploadPeriod = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("uploadPeriod"));
    System.out.println("-------"+sDocNo+"-------"+sTypeNo);
	if (sTypeNo == null) sTypeNo = "";
	if (sDocNo == null) sDocNo = "";
%>

<script type="text/javascript">
	AsControl.OpenView("/AppConfig/Document/AttachmentChooseDialog3.jsp","DocNo=<%=sDocNo%>&TypeNo=<%=sTypeNo%>&uploadPeriod=<%=uploadPeriod%>","rightup");
	AsControl.OpenView("/ImageManage/ImageViewInfo.jsp","ObjectNo=<%=sDocNo%>&TypeNo=<%=sTypeNo%>&uploadPeriod=<%=uploadPeriod%>","rightdown");
</script>

<%@ include file="/IncludeEnd.jsp"%>
