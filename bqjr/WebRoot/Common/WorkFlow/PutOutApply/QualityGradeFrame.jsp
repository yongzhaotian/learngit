<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	页面说明: 示例上下框架页面
 */
%>
<%
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialNo"));	
	String sQualityGrade  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("qualityGrade"));	
	String sLandmarkStatus  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("landmarkStatus"));	
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	String oldLandmark  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("oldLandmark"));
	String sCustomerName  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));
	if(oldLandmark==null) oldLandmark="";	
	if(sDoWhere==null) sDoWhere="";		
	if(sSerialNo==null) sSerialNo="";	
	if(sQualityGrade==null) sQualityGrade="";	
	if(sLandmarkStatus==null) sLandmarkStatus="";
	if(sCustomerName==null) sCustomerName="";
%>
<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<script type="text/javascript">	
  var ssCustomerName="<%=sCustomerName%>";
	AsControl.OpenView("/Common/WorkFlow/PutOutApply/QualityGradeList.jsp","serialNo=<%=sSerialNo%>&doWhere=<%=sDoWhere%>&CustomerName=<%=sCustomerName%>","rightup","");
	AsControl.OpenView("/Common/WorkFlow/PutOutApply/RecordDataList.jsp","serialNo=<%=sSerialNo%>&qualityGrade=<%=sQualityGrade%>&landmarkStatus=<%=sLandmarkStatus%>&oldLandmark=<%=oldLandmark%>","rightdown","");
</script>

<%@ include file="/IncludeEnd.jsp"%>
