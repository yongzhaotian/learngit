<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
	 */
	%>
<%/*~END~*/%>

<html>
<head>
<title>Session������Ϣ</title>
<%
	String businessObjectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessObjectType")));
	if(businessObjectType==null ) businessObjectType = "";
	
	String serialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")));
	
	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	
	//ȡ�ֶθ��µ�ҵ�������
	simulationObject.removeRelativeObject(businessObjectType, serialNo);
%>
<script language=javascript>
	//���ؼ��״ֵ̬�Ϳͻ���
	self.returnValue = "true";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>