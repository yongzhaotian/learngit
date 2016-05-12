<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>Session保存信息</title>
<%
	String businessObjectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessObjectType")));
	if(businessObjectType==null ) businessObjectType = "";
	
	String serialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")));
	
	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	
	//取字段更新到业务对象中
	simulationObject.removeRelativeObject(businessObjectType, serialNo);
%>
<script language=javascript>
	//返回检查状态值和客户号
	self.returnValue = "true";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>