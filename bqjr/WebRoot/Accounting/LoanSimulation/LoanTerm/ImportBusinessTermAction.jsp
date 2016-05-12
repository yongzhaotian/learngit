<%@page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "功能组件信息"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//获取参数
	String termID = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermID")));//组件ID
	//判断是否为咨询
	BusinessObject businessObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(businessObject==null) businessObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	
	//初始化业务对象参数
	String productVersion = businessObject.getString("ProductVersion");
	String productID = businessObject.getString("BusinessType");
	if("".equalsIgnoreCase(productVersion))
		throw new Exception("取到的产品版本为空，请检查！");
	if("".equalsIgnoreCase(productID))
		throw new Exception("取到的产品编号为空，请检查！");
	//如果传入的是组件流水号，则获取其TermID
	String termType = ProductConfig.getProductTerm(productID, productVersion, termID).getString("TermType"); 
	String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");
	com.amarsoft.app.accounting.product.ProductManage productManage = new com.amarsoft.app.accounting.product.ProductManage(Sqlca);
	productManage.createTermObject(termID, businessObject);
%>
<script language=javascript>
	//返回检查状态值和客户号
	self.returnValue = "true";
	self.close();
</script>
<%@include file="/IncludeEnd.jsp"%>