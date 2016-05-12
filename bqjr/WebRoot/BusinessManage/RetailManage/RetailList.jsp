<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sModify =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));
	if(sModify == null) sModify = "";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RetailList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  详情  激活  关闭  暂时关闭  取消关闭
		{"false","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情查看","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","激活","激活","activeRetail()",sResourcesPath},
		{"true","","Button","关闭","关闭","closeRetail()",sResourcesPath},
		{"true","","Button","暂时关闭","暂时关闭","amomentCloseRetail()",sResourcesPath},
		{"true","","Button","取消关闭","取消关闭","cancelCloseRetail()",sResourcesPath},
		{"true","","Button","excel商户导入","excel商户导入","ExcelImport()",sResourcesPath},
		{"true","","Button","excel支行代码导入","excel支行代码导入","ExcelImportBank()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},

	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	//Excel导出功能呢	
	function exportExcel(){
		amarExport("myiframe0");
	}

	<%/*~[Describe=取消关闭零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function cancelCloseRetail() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//对于状态为关闭或暂时关闭的零售商，通过取消关闭可将状态更新为激活;
		//取消关闭零售商时，项下的门店状态不进行自动更新，需手工进行门店状态的修改。
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus=="07") {
			var tipVal = "确定要取消关闭零售商：" + getItemValue(0, getRow(), "RNAME");
			if (confirm(tipVal)) {
				sReturn = RunMethod("公用方法","UpdateColValue","Retail_Info,Status,05,SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("取消关闭零售商失败！");
					return;			
				}else{
					RunMethod("公用方法","UpdateColValue","Retail_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Retail_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("暂时关闭状态零售商才允许取消关闭！");
			return;
		}
	}

	<%/*~[Describe=暂时关闭零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function amomentCloseRetail() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//对于状态为激活的零售商，可将其暂时关闭。零售商关闭或暂时关闭时，项下所有门店所有关闭或暂时关闭。
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus == "05") {
			var tipVal = "您确定要暂时关闭零售商：" + getItemValue(0, getRow(), "RNAME");
			if (confirm(tipVal)) {
				sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "temporayCloseRetail", "serialNo="+getItemValue(0, 0, "SERIALNO"));
				if(sReturn == "Fail") {				
					alert("暂时关闭零售商失败！");
					return;			
				}else{
					RunMethod("公用方法","UpdateColValue","Retail_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Retail_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("激活状态零售商才允许暂时关闭！");
			return;
		}
	}

	<%/*~[Describe=关闭零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function closeRetail() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//对于状态为激活或暂时关闭的零售商，可将其关闭。其他状态不允许;
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus=="05" || sStatus=="07") {
			var tipVal = "确定要关闭零售商：" + getItemValue(0, getRow(), "RNAME");
			if (confirm(tipVal)) {

				var sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "closeRetail", "serialNo="+getItemValue(0, 0, "SERIALNO"));

				if(sReturn == "Fail") {				
					alert("关闭零售商失败！");
					return;			
				}else{
					RunMethod("公用方法","UpdateColValue","Retail_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Retail_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("激活或暂时关闭状态零售商才允许关闭！");
			return;
		}
	}

	<%/*~[Describe=激活零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function activeRetail() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus == "03") {
			var tipVal = "您确定要激活零售商\n"+"零售商编号：" + getItemValue(0, getRow(), "RNO")+"\n名称：" + getItemValue(0, getRow(), "RNAME");
			if (confirm(tipVal)) {
				sReturn = RunMethod("公用方法","UpdateColValue","Retail_Info,Status,05, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("零售商激活失败！");
					return;			
				}else{
					RunMethod("公用方法","UpdateColValue","Retail_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Retail_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
			}
			reloadSelf();
		}else {
			alert("准入状态零售商才允许激活！");
			return;
		}
	}

	function newRecord(){
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoTab.jsp","RSerialNo="+sSerialNo+"&Modify=<%=sModify%>","_blank","");
		reloadSelf();
	}
	
	
	//excel导入
	function ExcelImport(){
		
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportRetailInfo", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		
		//RunMethod("BlackListModel","delAddressMulti","");
		reloadSelf();
		
		
		
	}
	
	function ExcelImportBank(){
		
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportBankInfo", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		
		//RunMethod("BlackListModel","delAddressMulti","");
		reloadSelf();
		
		
		
	}
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//使用ObjectViewer以视图001打开Example，
	}

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>