<%@page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.product.*"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "列表信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获取参数
	String termType = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermType")));//组件类型	
	BusinessObject businessObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(businessObject==null) businessObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");
	
	String termLibraryObjectNo=businessObject.getString("BusinessType")+"-"+businessObject.getString("ProductVersion");
	String termIDAttribute=ProductConfig.getTermTypeAttribute(termType, "RelativeAttributeID");
	String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");

	//通过显示模版产生ASDataObject对象doTemp
	String templetFilter = "1=1";
	//通过显示模版产生ASDataObject对象doTemp
	String templetNo = ProductConfig.getTermTypeAttribute(termType, "ListTempletNo");//显示模板编号
	//生成ASDO对象
	ASDataObject doTemp = new ASDataObject(templetNo,templetFilter,Sqlca);
	//生成DW对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = vTemp = dwTemp.genHTMLDataWindow("1,2");
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
			{"true", "", "Button", "新增", "新增一条信息","newRecord()",sResourcesPath},
			{"true", "", "Button", "详情", "费用详情","viewRecord()",sResourcesPath},
			{"true", "", "Button", "删除", "删除一条信息","deleteBusinessObjectFromSession(\'"+termObjectType+"\',\'SerialNo\')",sResourcesPath},
			
	};
%>
<%@ include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/LoanSimulation/js/businessobject.js"> </script>
<script language=javascript>

	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		if("<%=businessObject.getString("BusinessType")%>"=="null"){
			alert("<%=businessObject.getString("BusinessType")%>");
			return
		}
		var returnValue = setObjectValue("SelectTermLibrary","TermType,<%=termType%>,ObjectType,Product,ObjectNo,<%=termLibraryObjectNo%>","",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") return;
		var termID = returnValue.split("@")[0];

		popComp("BusinessTermInfo","/Accounting/LoanSimulation/LoanTerm/ImportBusinessTermAction.jsp","TermID="+termID,"");
		reloadSelf();
	}
	
	function viewRecord(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var termID = getItemValue(0,getRow(),"<%=termIDAttribute%>");
		
		if(typeof(serialNo)=="undefined"||serialNo.length==0){
			alert("请选择一条记录");
			return;
		}
		OpenComp("BusinessTermView","/Accounting/LoanSimulation/LoanTerm/BusinessTermInfo.jsp","TermID="+termID+"&SerialNo="+serialNo,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function initRow(){
	}

	<%
		ProductManage pm=new ProductManage(Sqlca);
		List<BusinessObject> list = pm.getTermObjectList(businessObject, termType);
		out.print(DWExtendedFunctions.setDataWindowValues(businessObject,list, dwTemp,Sqlca) );
	%>
	//初始化
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@include file="/IncludeEnd.jsp"%>