<%@page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.product.*"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>

	//��ȡ����
	String termID = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermID")));//���ID
	String currency = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Currency")));//����
	String termMonth = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermMonth")));//����
	if(termMonth == null) termMonth = "0.0";

	BusinessObject businessObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(businessObject==null) businessObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	
	//��ʼ��ҵ��������
	String productVersion = businessObject.getString("ProductVersion");
	String productID = businessObject.getString("BusinessType");
	if("".equalsIgnoreCase(productVersion))
		throw new Exception("ȡ���Ĳ�Ʒ�汾Ϊ�գ����飡");
	if("".equalsIgnoreCase(productID))
		throw new Exception("ȡ���Ĳ�Ʒ���Ϊ�գ����飡");
	if(currency==null || "".equals(currency))
		currency = businessObject.getString("Currency");
	
	//��ʼ���������
	String termType = ProductConfig.getProductTerm(productID, productVersion, termID).getString("TermType"); 
	String setFlag = ProductConfig.getProductTerm(productID, productVersion, termID).getString("SetFlag");
	String groupTermIDColName = ProductConfig.getTermTypeAttribute(termType, "GroupTermAttributeID");
	String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");
	ASValuePool term = ProductConfig.getProductTerm(productID, productVersion, termID);
	
	com.amarsoft.app.accounting.product.ProductManage productManage = new com.amarsoft.app.accounting.product.ProductManage(Sqlca);
	if(groupTermIDColName==null||groupTermIDColName.length()==0||termID.equals(businessObject.getString(groupTermIDColName))){
		productManage.initBusinessObject(termID, businessObject);
	}
	else{
		productManage.createTermObject(termID, businessObject);
	}
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String templetNo = ProductConfig.getTermTypeAttribute(termType, "InfoTempletNo");//��ʾģ����
	if(templetNo==null||templetNo.length()==0) ProductConfig.getTermTypeAttribute(termType, "ListTempletNo");//��ʾģ����

	String templetFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(templetNo,templetFilter,Sqlca);
	//����DW����
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	if("BAS".equals(setFlag)){
		dwTemp.Style="2";
	}
	
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("Currency", businessObject.getString("BusinessCurrency"));
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	
	String dwControlScript = DWExtendedFunctions.genDataWindowControlScript(term, dwTemp);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("1,2");
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));

	//����Ϊ��
	//0.�Ƿ���ʾ
	//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
	//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.��ť����
	//4.˵������
	//5.�¼�
	//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"false","","Button","����","����һ����Ϣ","newRecord()",sResourcesPath},
			{"false","","Button","����","�����¼","saveBusinessObjectToSession('"+termObjectType+"')",sResourcesPath},
			{"false","","Button","����","����","viewAndEdit()",sResourcesPath},
			{"false","","Button","ɾ��","ɾ��һ����Ϣ","deleteRecord()",sResourcesPath},
	};
	
	String segEditControl = ProductConfig.getProductTermParameterAttribute(productID, productVersion, termID, "SEGEditControl","DefaultValue");//�Ƿ�����༭�ֶ�

	if("BAS".equals(setFlag))
	{
	
		sButtons[1][0] = "true";
	}
	else if("SET".equals(setFlag))
	{
		sButtons[0][0] = "true";
		sButtons[1][0] = "true";
		sButtons[3][0] = "true";
	}
	//�����ɱ༭�ֶ�ʱ����������ɾ�İ�ť
	if("2".equals(segEditControl)){
		sButtons[0][0] = "false";
		sButtons[1][0] = "true";
		sButtons[3][0] = "false";
	}
	
	if("BAS".equals(setFlag)){
%>
<%@ include file="/Resources/CodeParts/Info05.jsp"%>
<% 	}else{
%>
<%@ include file="/Resources/CodeParts/List05.jsp"%>
<% 	}%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/LoanSimulation/js/businessobject.js"> </script>
<script language=javascript>
<%out.print(com.amarsoft.app.accounting.config.loader.RateConfig.createJSArray(currency));%>
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		popComp("AddTermSetPara2","/CreditManage/CreditApply/AddTermSetPara2.jsp","TermID=<%=termID%>","dialogWidth=50;dialogHeight=50;");
		reloadSelf();
	}
	
	
	/*~[Describe=�鿴����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage(1));
			return;
		}
		popComp("AddTermSetPara2","/CreditManage/CreditApply/AddTermSetPara2.jsp","TermID=<%=termID%>&SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=50;");
		reloadSelf();
	}
    
	function selectMFOrgID(){
		setObjectValue("SelectRamusOrg","","@ORGID@0@OrgName@1",0,0,"");
	}
	
	function initRow(){
	}
	
<%
	ProductManage pm=new ProductManage(Sqlca);
	List<BusinessObject> list = pm.getTermObjectList(businessObject, termType);
	out.print(DWExtendedFunctions.setDataWindowValues(businessObject,list, dwTemp,Sqlca) );
%>
	//ҳ���ʼ��
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();
	rightType = 'All'; 
	currency="<%=currency%>";
	termMonth = "<%=termMonth%>";
	businessDate = "<%=SystemConfig.getBusinessDate()%>";
	<%=dwControlScript%>
</script>
<%
	String jsfile=ProductConfig.getTermTypeAttribute(termType, "JSFile");
	if(jsfile!=null&&jsfile.length()>0){
%>
<script type="text/javascript" src="<%=sWebRootPath+jsfile%>"> </script>
<%	} %>
<%@include file="/IncludeEnd.jsp"%>