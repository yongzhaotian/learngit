<%@page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.RateConfig"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "功能组件信息"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//获取参数
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType")));//对象类型
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo")));//对象编号
	String termID = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermID")));//组件ID
	String status = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Status")));//状态
	String currency = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Currency")));//币种
	String termMonth=DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("termMonth")));//贷款期限
	if(termMonth == null) termMonth = "0.0";
	
	BusinessObject businessObject= AbstractBusinessObjectManager.getBusinessObject(objectType,objectNo,Sqlca);
	if(businessObject==null){
		throw new Exception("未取到业务主对象ObjectType="+objectType+",ObjectNo="+objectNo+"，请检查！");
	}
	objectType = businessObject.getObjectType();
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
	ASValuePool term = ProductConfig.getProductTerm(productID, productVersion, termID);
	if(term == null || term.isEmpty()) term = ProductConfig.getTerm(termID);
	
	String termType = term.getString("TermType"); 
	String setFlag = term.getString("SetFlag");
	String groupTermIDColName = ProductConfig.getTermTypeAttribute(termType, "GroupTermAttributeID");
	String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");
		
	String rightType = CurComp.getParameter("RightType");
	if(!"ReadOnly".equals(rightType))
	{
		com.amarsoft.app.accounting.product.ProductManage productManage = new com.amarsoft.app.accounting.product.ProductManage(Sqlca);
		productManage.createTermObject(termID, businessObject);
		productManage.getBomanager().updateDB();
		productManage.getBomanager().commit();
	}
	//通过显示模版产生ASDataObject对象doTemp
	String templetNo = ProductConfig.getTermTypeAttribute(termType, "InfoTempletNo");//显示模板编号
	
	String templetFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(templetNo,templetFilter,Sqlca);
	doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	//生成DW对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	if(objectType.equals(BUSINESSOBJECT_CONSTATNTS.business_putout)
		|| objectType.equals(BUSINESSOBJECT_CONSTATNTS.flow_opinion)){
		dwTemp.ReadOnly = "1"; 
		CurComp.setAttribute("RightType","ReadOnly");
	}
	if("BAS".equals(setFlag)){
		dwTemp.Style="2";
	}
	
	
	dwTemp.setEvent("AfterUpdate", "!BusinessManage.UpdateFineBusinessRate("+objectType+","+objectNo+")");
	
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("Currency", currency);
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	
	String dwControlScript = DWExtendedFunctions.genDataWindowControlScript(term, dwTemp);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+objectType+","+termID);
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
			{"false","","Button","保存","保存记录","saveRecord()",sResourcesPath},
			{"false","","Button","删除","删除一条信息","deleteRecord()",sResourcesPath},
	};
	
	String segEditControl = ProductConfig.getTermParameterAttribute(term, "SEGEditControl","DefaultValue");//是否允许编辑分段

	if("BAS".equals(setFlag))
	{
	
		//sButtons[1][0] = "true";
	}
	else if("SET".equals(setFlag))
	{
		sButtons[0][0] = "true";
		//sButtons[1][0] = "true";
		sButtons[2][0] = "true";
	}
	//当不可编辑分段时，则隐藏增删改按钮
	if("2".equals(segEditControl)){
		sButtons[0][0] = "false";
		//sButtons[1][0] = "true";
		sButtons[2][0] = "false";
	}
	
	if("BAS".equals(setFlag)){
%>
<%@ include file="/Resources/CodeParts/Info05.jsp"%>
<% 	}else{
%>
<%@ include file="/Resources/CodeParts/List05.jsp"%>
<% 	}%>


<script language=javascript>
<%out.print(com.amarsoft.app.accounting.config.loader.RateConfig.createJSArray(currency));%>

	function saveRecord(){		
		if("RPT"=="<%=termType%>"){
			var rpt = getItemValue(0,getRow(),"RPTTermID");
			//请根据需求添加校验 by qzhang1 20131203
			/* if(rpt!="RPT05"){
				var day;
				day = getItemValue(0,getRow(),"DefaultDueDay");	
				if(getRowCount(0)==2){
					for(var i=0;i<2;i++){
						day = getItemValue(0,i,"DefaultDueDay");
						if(typeof(day)!="undefined"&&day.length>0){
							break;
						}
					}								
				}
				if(typeof(day)=="undefined"||day.length==0){
					alert("请录入还款日!");
					return ;
				} 
				if(typeof(day)!="undefined"){
					if(day>25||day<1){
						alert("还款日只能录入1-25日之间,请重新录入!");
						return false;					
					}
				}
			} */
			
		}		
		if("RAT"=="<%=termType%>"){
			calcBusinessRate("<%=currency%>");
		}
		as_save("myiframe0","setDWControl()");
		return true;
	}
	
	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		popComp("AddTermSetPara2","/CreditManage/CreditApply/AddTermSetPara2.jsp","ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&TermID=<%=termID%>&TermObjectType<%=objectType%>","dialogWidth=50;dialogHeight=50;");
		reloadSelf();
	}
	
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if(confirm("确定删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=查看详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage(1));
			return;
		}
		popComp("AddTermSetPara2","/CreditManage/CreditApply/AddTermSetPara2.jsp","ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>&TermID=<%=termID%>&TempletNo=<%=templetNo%>&TermObjectType<%=objectType%>&SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=50;");
		RunMethod("BusinessManage","UpdateFineBusinessRate","<%=objectType%>,<%=objectNo%>");
		reloadSelf();
	}
	
	/*校验输入的默认还款日期--gj*/
	function checkDefaultDay(){
		//var defaultDay=getItemValue(0,getRow(),"DefaultDueDay");
		//if(typeof(defaultDay)!="undefined"||defaultDay!=""){
			//if(defaultDay>=31||defaultDay<0){
				//alert("请输入正确的默认还款日！");
				//setItemValue(0,getRow(),"DefaultDueDay","15");  //填错后，默认为15日
				//return;
			//}
		//}
	}
	
	/*~[Describe=设置权限;InputParam=无;OutPutParam=无;]~*/
	function setDWControl()
	{
		<%=dwControlScript%>
	}
	
	//页面初始化
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	setDWControl();
	
	currency = "<%=currency%>";
	termMonth = "<%=termMonth%>";
	businessDate = "<%=SystemConfig.getBusinessDate()%>";
	rightType = "<%=rightType%>";
	
</script>

<%
	String jsfile=ProductConfig.getTermTypeAttribute(termType, "JSFile");
	if(jsfile!=null&&jsfile.length()>0){
%>
<script type="text/javascript" src="<%=sWebRootPath+jsfile%>"> </script>
<%	} %>
<script language=javascript>

</script>
<%@include file="/IncludeEnd.jsp"%>