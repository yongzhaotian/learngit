<%@page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.product.*"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "功能组件信息"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//获取参数
	String termID = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermID")));//组件ID
	String currency = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Currency")));//币种
	String termMonth = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermMonth")));//期限
	if(termMonth == null) termMonth = "0.0";

	BusinessObject businessObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(businessObject==null) businessObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	
	//初始化业务对象参数
	String productVersion = businessObject.getString("ProductVersion");
	String productID = businessObject.getString("BusinessType");
	if("".equalsIgnoreCase(productVersion))
		throw new Exception("取到的产品版本为空，请检查！");
	if("".equalsIgnoreCase(productID))
		throw new Exception("取到的产品编号为空，请检查！");
	if(currency==null || "".equals(currency))
		currency = businessObject.getString("Currency");
	
	//初始化组件参数
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
	
	//通过显示模版产生ASDataObject对象doTemp
	String templetNo = ProductConfig.getTermTypeAttribute(termType, "InfoTempletNo");//显示模板编号
	if(templetNo==null||templetNo.length()==0) ProductConfig.getTermTypeAttribute(termType, "ListTempletNo");//显示模板编号

	String templetFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(templetNo,templetFilter,Sqlca);
	//生成DW对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	if("BAS".equals(setFlag)){
		dwTemp.Style="2";
	}
	
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("Currency", businessObject.getString("BusinessCurrency"));
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	
	String dwControlScript = DWExtendedFunctions.genDataWindowControlScript(term, dwTemp);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("1,2");
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));

	//依次为：
	//0.是否显示
	//1.注册目标组件号(为空则自动取当前组件)
	//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.按钮文字
	//4.说明文字
	//5.事件
	//6.资源图片路径
	String sButtons[][] = {
			{"false","","Button","新增","新增一条信息","newRecord()",sResourcesPath},
			{"false","","Button","保存","保存记录","saveBusinessObjectToSession('"+termObjectType+"')",sResourcesPath},
			{"false","","Button","详情","详情","viewAndEdit()",sResourcesPath},
			{"false","","Button","删除","删除一条信息","deleteRecord()",sResourcesPath},
	};
	
	String segEditControl = ProductConfig.getProductTermParameterAttribute(productID, productVersion, termID, "SEGEditControl","DefaultValue");//是否允许编辑分段

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
	//当不可编辑分段时，则隐藏增删改按钮
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
	
	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		popComp("AddTermSetPara2","/CreditManage/CreditApply/AddTermSetPara2.jsp","TermID=<%=termID%>","dialogWidth=50;dialogHeight=50;");
		reloadSelf();
	}
	
	
	/*~[Describe=查看详情;InputParam=无;OutPutParam=无;]~*/
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
	//页面初始化
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