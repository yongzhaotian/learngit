<%@page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>

	//��ȡ����
	String termID = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermID")));//���ID
	//�ж��Ƿ�Ϊ��ѯ
	BusinessObject businessObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(businessObject==null) businessObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	
	//��ʼ��ҵ��������
	String productVersion = businessObject.getString("ProductVersion");
	String productID = businessObject.getString("BusinessType");
	if("".equalsIgnoreCase(productVersion))
		throw new Exception("ȡ���Ĳ�Ʒ�汾Ϊ�գ����飡");
	if("".equalsIgnoreCase(productID))
		throw new Exception("ȡ���Ĳ�Ʒ���Ϊ�գ����飡");
	//���������������ˮ�ţ����ȡ��TermID
	String termType = ProductConfig.getProductTerm(productID, productVersion, termID).getString("TermType"); 
	String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");
	com.amarsoft.app.accounting.product.ProductManage productManage = new com.amarsoft.app.accounting.product.ProductManage(Sqlca);
	productManage.createTermObject(termID, businessObject);
%>
<script language=javascript>
	//���ؼ��״ֵ̬�Ϳͻ���
	self.returnValue = "true";
	self.close();
</script>
<%@include file="/IncludeEnd.jsp"%>