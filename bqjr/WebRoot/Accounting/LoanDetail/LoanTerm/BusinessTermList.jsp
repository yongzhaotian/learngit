<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "列表信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获取参数
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo")));//对象编号
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType")));//对象类型
	String status = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Status")));//状态
	String termType = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermType")));//组件类型
	String templetNo = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TempletNo")));//显示模板编号
	
	String termObjectType = ProductConfig.getTermTypeAttribute(termType, "RelativeObjectType");//组件关联业务对象
	String productVersion = "",productID="";
	BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(objectType, objectNo,Sqlca);
	if(businessObject != null)
	{
		productID = businessObject.getString("BusinessType");
		productVersion = businessObject.getString("ProductVersion");
	}else{
		throw new Exception("对象【"+objectType+".+"+objectNo+"】不存在！");
	}
	
	if("".equalsIgnoreCase(productVersion))
		throw new Exception("取到的产品版本为空，请检查！");
	if("".equalsIgnoreCase(productID)) 
		throw new Exception("取到的产品编号为空，请检查！");
	
	//通过显示模版产生ASDataObject对象doTemp
	String templetFilter = "1=1";
	//生成ASDO对象
	ASDataObject doTemp = new ASDataObject(templetNo,templetFilter,Sqlca);
	
	doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	//生成DW对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("ProductID", productID);
	valuePool.setAttribute("ProductVersion", productVersion);
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+businessObject.getObjectType());
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
			{"true", "", "Button", "删除", "删除一条信息","deleteRecord()",sResourcesPath},
			{"false", "", "Button", "详情", "费用详情","viewRecord()",sResourcesPath},
			{"false","","Button","保存","保存记录","saveRecord()",sResourcesPath}
	};
	
	if(termType.equals("SPT")) sButtons[3][0] = "true";
%>
<%@ include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(){
		as_save("myiframe0","");
		return true;
	}

	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		var returnValue = setObjectValue("SelectTermLibrary","TermType,<%=termType%>,ObjectType,Product,ObjectNo,<%=productID+"-"+productVersion%>","",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") return;
		
		var sTermID = returnValue.split("@")[0];
		
		var sReturn = RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=businessObject.getObjectType()%>,<%=objectNo%>");
		reloadSelf();
	}
	
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		setNoCheckRequired(0);  //先设置所有必输项都不检查
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
	
	function initRow(){
		
	}

	//初始化
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@include file="/IncludeEnd.jsp"%>