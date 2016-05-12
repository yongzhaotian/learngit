<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: pli2 2015-4-3
		Tester:
		Describe: 贷款人关联城市记录列表
		
		Input Param:
		SerialNo:流水号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷款人关联城市 "; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数,贷款人编号
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
	if(sSerialNo == null) sSerialNo = "";
	System.out.println(sSerialNo+"---");
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "LoanManCityList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled=true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(100);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
		{"true","","Button","配置贷款人城市","新增","getRegionCode()",sResourcesPath},
		{"true","","Button","配置归集户","归集户","turnAccount()",sResourcesPath},
		{"true","","Button","配置格式化报告模板","格式化报告","loanManEDoc()",sResourcesPath},
		{"true","","Button","删除","删除所选中的城市","deleteRecord()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		var sRetVal = setObjectValue("SelectCityCodeNoMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("请选择关联城市！");
			return;
		}
		sRetVal=sRetVal.split("~");
		for(var i=0;i<sRetVal.length;i++){
			sRetVal1=sRetVal[i].split("@");
			 RunMethod("BusinessTypeRelative","InsertBusRelative","InsuranceCity_Info,SerialNo,InsuranceNo,CityNo,"+getSerialNo("InsuranceCity_Info", "SerialNo", "")+",<%=sSerialNo%>,"+sRetVal1[0]);
		}
		reloadSelf();
	}
	
	//配置格式化报告模板
	function loanManEDoc(){
		var sSerialNos = getItemValueArray(0,"SerialNo");
		var sAreaCodes = getItemValueArray(0,"AreaCode");
		var sProductTypes = getItemValueArray(0,"ProductType");
		var sSerialNo = sSerialNos[0];
		var sAreaCode = sAreaCodes[0];
		var sProductType = sProductTypes[0];

		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || typeof(sAreaCode)=="undefined" || sAreaCode.length==0 ||typeof(sProductType)=="undefined" || sProductType.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		var sRetVal = setObjectValue("SelectDOCCodeNo", "", "", 0, 0, "dialogWidth:500px;dialogHeight:400px;");
		if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("请选择模板类型！");
			return;
		}
		sRetVal = sRetVal.replace("@","");
		AsControl.PopView("/BusinessManage/CollectionManage/LoanManDocInfo.jsp", "AreaCodes="+sAreaCodes+"&SerialNoS="+sSerialNos+"&ProductTypes="+sProductTypes+"&TypeNo="+sRetVal, "dialogWidth:500px;dialogHeight:500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	//配置归集户
	function turnAccount(){
		var sSerialNos = getItemValueArray(0,"SerialNo");
		var sAreaCodes = getItemValueArray(0,"AreaCode");
		var sProductTypes = getItemValueArray(0,"ProductType");
		var sSerialNo = sSerialNos[0];
		var sAreaCode = sAreaCodes[0];
		var sProductType = sProductTypes[0];
		
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || typeof(sAreaCode)=="undefined" || sAreaCode.length==0 ||typeof(sProductType)=="undefined" || sProductType.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		AsControl.PopView("/BusinessManage/CollectionManage/TurnAccountInfo.jsp", "AreaCodes="+sAreaCodes+"&SerialNoS="+sSerialNos+"&ProductTypes="+sProductTypes, "dialogWidth=360px;dialogHeight=320px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	//配置贷款人城市
	function getRegionCode(){
		var sSerialNo = "<%=sSerialNo%>";
		
		var sLoaner = RunMethod("LoanAccount", "selectLoanerType", sSerialNo);
		if(sLoaner==null || typeof(sLoaner)=="undefined" || sLoaner.length==0){
			alert("请先在贷款人详情配置贷款人类型！");
			return;
		}
		var result = setObjectValue("selectSubProductType","","",0,0,""); //获取要关联的产品类型
 		if(typeof(result)=="undefined" || result.length==0 || result=="_CLEAR_"){
 			return;
 		}
 		result = result.replace("@","");
 		var sReturn = RunMethod("LoanAccount", "selectCityIsNotNull", sLoaner+","+result);
 		if(sReturn==0){
 			alert("该产品类型下已经没有可关联的城市了！");
 			return;
 		}
	    var sCityName = PopPage("/BusinessManage/CollectionManage/AddLoanManCity.jsp?SerialNo="+sSerialNo+"&ProductType="+result+"&sLoaner="+sLoaner,"","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
	    if(typeof(sCityName)=="undefined" || sCityName.length==0 || sCityName=="_none_"){
	    	return;
	    }
	    reloadSelf();
	}
	
	function deleteRecord(){

		var sSerialNos = getItemValueArray(0,"SerialNo");
		var sAreaCodes = getItemValueArray(0,"AreaCode");
		var sProductTypes = getItemValueArray(0,"ProductType");
		var sSpSerialNos = getItemValueArray(0,"SpSerialNo");
		var sSerialNo = sSerialNos[0];
		var sAreaCode = sAreaCodes[0];
		var sProductType = sProductTypes[0];
		var params = "";
		
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || typeof(sAreaCode)=="undefined" || sAreaCode.length==0 ||typeof(sProductType)=="undefined" || sProductType.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		if(confirm("您真的想删除该信息吗？")){
			var strList = "";
			for(var i = 0; i < sSerialNos.length; i++){
				strList = strList + sSerialNos[i] + "@@" + sAreaCodes[i] + "@@" + sProductTypes[i] + "|";
			}
			if (strList != null && strList != "") {
				strList = strList.substring(0, strList.length - 1);
			}
			
			params = "paramList=" + strList;
			var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.DelectLoanCity",
				"deletLoaner", params);			
			if (result.split("@")[0] != "true") {
				alert(result.split("@")[1]);
				return;
			} else {
				alert("删除成功！");
				reloadSelf();
				return;
			}
		}
	}
	
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

