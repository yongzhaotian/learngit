<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sModify= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));
	if(sModify==null) sModify="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreList1";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause = " where SI.Status not in ('01','02','04')";

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
		{"true","","Button","激活","激活","activeStore()",sResourcesPath},
		{"false","","Button","关联产品","关联产品","relativeProduct()",sResourcesPath},
		{"false","","Button","移交","移交给另一客户经理","handOver()",sResourcesPath},
		{"true","","Button","解绑门店","解除该门店绑定的销售","unbandSalesman()",sResourcesPath},
		{"true","","Button","解绑记录 ","解绑记录","history()",sResourcesPath},
		{"false","","Button","更换城市经理","更换城市经理","updateCityManager()",sResourcesPath},
		{"true","","Button","门店部分转移 ","门店部分转移","updateOther()",sResourcesPath},
		{"true","","Button","门店批量转移 ","门店批量转移","updateAll()",sResourcesPath},
		{"true","","Button","关闭","关闭","closeStore()",sResourcesPath},
		
		// 撤回原来的暂时关闭功能 update by huzp 20150428
		{"true","","Button","暂时关闭","暂时关闭","amomentCloseStore()",sResourcesPath},
		//{"true","","Button","风控关闭","风控关闭","amomentCloseStore2()",sResourcesPath},
		
		{"true","","Button","取消暂时关闭","取消暂时关闭","cancelCloseStore()",sResourcesPath},
		//by chengwenhao 
		//CCS-1290
		//门店管理列表界面有几个按钮用不到需要隐藏
		{"false","","Button","excel导入 ","excel导入","ExcelImport()",sResourcesPath}, 
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},
		
	};
	
	//用于控制单行按钮显示的最大个数  add by Dahl 20150318
	String iButtonsLineMax = "12";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
			
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	//Excel导出功能呢	
	function exportExcel(){
		amarExport("myiframe0");
	}

	/* 解除该门店绑定的销售 */
	function unbandSalesman() {
		
		var vWhereClause = "<%=doTemp.WhereClause%>";
		var vSalesNo = document.getElementById("DF7_1_INPUT").value;
		var vSalesName = document.getElementById("DF8_1_INPUT").value;
		var vSerialNo = getItemValue(0,getRow(),"SNO");
		var vSname = getItemValue(0,getRow(),"SNAME");
		
		var sStatus = getItemValue(0, getRow(), "STATUS"); //门店状态
		if(sStatus == "06"){ //关闭状态
			alert("门店处于关闭状态，不允许解绑门店 ");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/StoreManage/StoreUserUnbandList.jsp","","_self","");
		
		return;

		var vQuery = vSalesNo;
		if (vSalesName!="" && vSalesNo=="") {
			vQuery = vSalesName;
			var icnt = RunMethod("公用方法", "GetColValue", "user_info,count(userid),username='"+vQuery+"'");
			if (icnt > 1) {
				alert("请在门店详情，门店关联销售中解绑！");
				return;
			}

		}
		
		if (vQuery ==  "") {
			alert("请输入销售编号或名称查询绑定门店！");
			return;
		}
		
		if (vWhereClause.indexOf(vQuery)<0) {
			alert("请先查询！");
			return;
		}
		
		if (typeof(vSerialNo)=="undefined" || vSerialNo.length==0){
			alert("请选择一个门店进行解绑！");
			return;
		}
		
		if (vSalesName!="" && vSalesNo=="") {
			vQuery = RunMethod("公用方法", "GetColValue", "user_info,userid,username='"+vQuery+"'"); 
		}
		
		if (confirm("确定要解除绑定，门店："+vSname+"，销售编号："+RunMethod("公用方法", "GetColValue", "user_info,username,userid='"+vQuery+"'"))){
			RunMethod("公用方法", "DelByWhereClause", "storerelativesalesman,sno='"+vSerialNo+"' and salesmanno='"+vQuery+"'");
			RunMethod("公用方法", "UpdateColValue", "user_info,superid,,userid='"+vQuery+"'");
		}

		reloadSelf();
	}

	function handOver() {
		AsControl.PopView("/BusinessManage/StoreManage/test.jsp", "", "");
	}

	<%/*~[Describe=关联产品;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function relativeProduct() {
		var sStatus = getItemValue(0, getRow(), "STATUS"); //门店状态
		if(sStatus == "06"){ //关闭状态
			alert("门店处于关闭状态，不允许关联产品 ");
			return;
		}
		
		var sRetVal = AsControl.PopView("/BusinessManage/StoreManage/StoreProductDoubleSelect.jsp", "", "dialogWidth:1080px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no");
		var sProductCategorys = sRetVal.split("~")[0];
		var sStores = sRetVal.split("~")[1];
		
		if (typeof(sRetVal)=='undefined' || (sProductCategorys.length==0 || sStores.length==0)) {
			alert("请选择门店和产品范畴！");
			return;
		}
		sProductCategorys = sProductCategorys.substring(0, sProductCategorys.length-1);
		sStores = sStores.substring(0, sStores.length-1);
		/* alert(sStores);
		alert(sProductCategorys);
		return; */
		// 执行java方法进行操作
		RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "getStoreRelativeProductMulti", "serialNo="+sProductCategorys+",objectNo="+sStores+",retailNo=<%=CurUser.getUserID()%>");
		reloadSelf();
	}

	<%/*~[Describe=取消关闭零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function cancelCloseStore() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		//添加了sStatus=‘08’的状态判断，add huzp 20150423(功能已撤销20150428)
		//if (sStatus=="07"||sStatus=="08") {
		if (sStatus=="07") {
			var tipVal = "确定要取消关闭\n门店名称：" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				
				// 如果商户状态为暂时关闭，则不允许关闭
				var sStoreStatus = RunMethod("公用方法", "GetColValue", "Retail_Info,Status,SerialNo=(select RSerialNo from Store_Info where SerialNo='"+sSerialNo+"')");
				if (sStoreStatus == "07") {
					alert("商户状态为暂时关闭时，不允许进行关闭操作！");
					return;
				}
				//添加了风控按钮事件 add huzp 20150423(功能已撤销20150428)
				/*
				if (sStoreStatus == "08") {
					alert("商户状态为风控关闭时，不允许进行关闭操作！");
					return;
				}
				*/
				
				sReturn = RunMethod("公用方法","UpdateColValue","Store_Info,Status,05,SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("取消关闭门店失败！");
					return;			
				}else{
					RunMethod("公用方法","UpdateColValue","Store_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Store_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("暂时关闭状态门店才允许取消关闭！");
			return;
		}
	}

	<%/*~[Describe=暂时关闭零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function amomentCloseStore() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus == "05") {
			
			var tipVal = "确定要暂时关闭\n门店名称：" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				sReturn = RunMethod("公用方法","UpdateColValue","Store_Info,Status,07,SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("门店暂时关闭失败！");
					return;			
				}else{
					RunMethod("公用方法","UpdateColValue","Store_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Store_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("激活状态门店才允许暂时关闭！");
			return;
		}
	}
	
	//仿写原来暂时关闭函数改为风控关闭 add huzp 20150424 （此功能已撤销 20150428）
	function amomentCloseStore2() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var sStatus = getItemValue(0, getRow(), "STATUS");
		if (sStatus == "05") {
			var tipVal = "确定要风控关闭\n门店名称：" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				sReturn = RunMethod("公用方法","UpdateColValue","Store_Info,Status,08,SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("门店风控关闭失败！");
					return;			
				}else{
					RunMethod("公用方法","UpdateColValue","Store_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Store_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("激活状态门店才允许风控关闭！");
			return;
		}
	}

	<%/*~[Describe=关闭零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function closeStore() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		//对于状态为激活或暂时关闭的零售商，可将其关闭。其他状态不允许;
		var sStatus = getItemValue(0, getRow(), "STATUS");
		
		// 添加sStatus=="08" 状态  add huzp 20150423（此功能已撤销20150428）
		//if (sStatus=="07" ||sStatus=="08" || sStatus=="05" || sStatus=="03") {
		   if (sStatus=="07" || sStatus=="05" || sStatus=="03") {
			
			var tipVal = "您确定要关闭门店：" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				var userId='<%=CurUser.getUserID()%>'; //修改人
				var orgid = "<%=CurOrg.orgID%>"; //机构编号
				//alert("serialNo="+getItemValue(0, 0, "SERIALNO")+",retailNo="+getItemValue(0, 0, "RSERIALNO"));
				var sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "closeStore", "serialNo="+getItemValue(0, getRow(), "SERIALNO")+",retailNo="+getItemValue(0, getRow(), "RSERIALNO")+ ",userId=" + userId + ",orgid=" + orgid);
				if(sReturn == "Fail") {				
					alert("门店关闭失败！");
					return;			
				}else{
					RunMethod("公用方法","UpdateColValue","Store_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Store_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
				reloadSelf();
			}
		} else {
			alert("只有门店为准入、激活和暂时关闭状态才允许进行关闭操作！");
			return;
		}
	}

	<%/*~[Describe=激活零售商;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/26~*/%>
	function activeStore() {
		openColseDate="<%=DateX.format(new java.util.Date(), "yyyy/MM/dd HH:mm:ss")%>";
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		/*add CCS-884 门店状态只能转入状态才允许激活 tangyb 20150720 start
		var sRetailStatus = RunMethod("公用方法", "GetColValue", "RETAIL_INFO,STATUS, SERIALNO=(SELECT RSERIALNO FROM STORE_INFO WHERE SERIALNO='"+sSerialNo+"')");
		if (sRetailStatus !== "05") {
			alert("请先激活商户！");
			return;
		}*/
		var sno = getItemValue(0, getRow(), "SNO"); //门店代码
		var sStatus = getItemValue(0, getRow(), "STATUS"); //门店状态
		if (sStatus == "03") { //准入状态
			var tipVal = "确定要激活门店：" + getItemValue(0, getRow(), "SNAME");
			if (confirm(tipVal)) {
				//-- update CCS-884 门店管理优化 tangyanbo 20150720 start --//
				//校验必输字段是否为空
				var errorMes = RunJavaMethodSqlca("com.amarsoft.app.billions.StoreInfo", "queryStoreKeyInfoIsNull", "serialno="+sSerialNo);
				if(errorMes != ""){
					alert(errorMes);
					return;
				}
				
				var sRetailStatus = RunMethod("公用方法", "GetColValue", "RETAIL_INFO,STATUS, SERIALNO=(SELECT RSERIALNO FROM STORE_INFO WHERE SERIALNO='"+sSerialNo+"')");
				if (sRetailStatus !== "05") {
					alert("请先激活商户！");
					return;
				}
				
				//校验是否关联产品
				var ccount = RunMethod("公用方法", "GetColValue", "storerelativeproduct,count(1),sno='"+sno+"'"); 
				if (typeof(ccount) == "undefined" || parseInt(ccount) == 0) {
					alert("请先关联产品！");
					return;
				}
				
				//校验是否关联销售人员
				var xcount = RunMethod("公用方法", "GetColValue", "storerelativesalesman,count(1),sno='"+sno+"' and stype is null"); 
				if (typeof(xcount) == "undefined" || parseInt(xcount) == 0) {
					alert("请先关联销售人员！");
					return;
				}
				//-- end --//
				
				sReturn = RunMethod("公用方法","UpdateColValue","Store_Info,Status,05,SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
					alert("激活门店失败！");
					return;			
				}else{
					RunMethod("公用方法","UpdateColValue","Store_Info,openColseName,<%=CurUser.getUserID()%>, SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
					RunMethod("ModifyNumber","GetModifyNumber","Store_Info,openColseDate='"+openColseDate+"',SerialNo='"+getItemValue(0, getRow(), "SERIALNO")+"'");
				}
			}
			reloadSelf();
		} else if (sStatus == "05") {
			alert("门店已经被激活！");
			return;
		}else {
			alert("准入状态门店才允许激活！");
			return;
		}
	}

	<%/*~[Describe=门店信息查看;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/20~*/%>
	function viewReservCustomerInfo(){
		
		AsControl.OpenView("/CustomService/BusinessConsult/ReservConsultInfo.jsp","CustomerType=Customer","_blank","");
	}
	
	<%/*~[Describe=客户预约;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/20~*/%>
	function viewReservCommercialInfo(){
		
		AsControl.OpenView("/CustomService/BusinessConsult/ReservConsultInfo.jsp","CustomerType=Commercial","_blank","");
	}
	
	<%/*~[Describe=商户预约;InputParam=无;OutPutParam=无;] added by tbzeng 2014/02/20~*/%>
	function viewStoreInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SERILNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//alert(1);
		AsControl.OpenView("/BusinessManage/StoreManage/StoreInfo.jsp","SNo="+sSNo,"_self","");
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
	
	//查看历史记录 
	function history(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNO = getItemValue(0,getRow(),"SNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/StoreManage/StoreUserHistoryList.jsp","SNO="+sSNO,"_self","");
	}
	
	//更改城市经理
	function updateCityManager(){
		var sStatus = getItemValue(0, getRow(), "STATUS"); //门店状态
		if(sStatus == "06"){ //关闭状态
			alert("门店处于关闭状态，不允许更改城市经理");
			return;
		}

		sCompID = "UpdateSalesManagerSuper";
		sCompURL = "/BusinessManage/StoreManage/UpdateSalesManagerSuper.jsp";
	    popComp(sCompID,sCompURL,"","dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();	
	}
    
	//门店批量转移
	function updateAll(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNO = getItemValue(0,getRow(),"SNO");
		var sCity = getItemValue(0,getRow(),"CITY"); 
		
		var sStatus = getItemValue(0, getRow(), "STATUS"); //门店状态
		if(sStatus == "06"){ //关闭状态
			alert("门店处于关闭状态，不允许批量转移");
			return;
		}
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		sCompID = "UpdateAllManager";
		sCompURL = "/BusinessManage/StoreManage/UpdateAllManager.jsp";
	    popComp(sCompID,sCompURL,"City="+sCity+"&SNO="+sSNO,"dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();	
	}
	
	//门店部分转移 
	function updateOther(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNO = getItemValue(0,getRow(),"SNO");
		var sCity = getItemValue(0,getRow(),"CITY");
		var oldSalesManager = getItemValue(0,getRow(),"SALESMANAGER");
		
		var sStatus = getItemValue(0, getRow(), "STATUS"); //门店状态
		if(sStatus == "06"){ //关闭状态
			alert("门店处于关闭状态，不允许部分转移 ");
			return;
		}
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
//		sCompID = "UpdateOtherManager";
//		sCompURL = "/BusinessManage/StoreManage/UpdateOtherManager1.jsp";
//	    popComp(sCompID,sCompURL,"City="+sCity+"&SNO="+sSNO+"&oldSalesManager="+oldSalesManager,"dialogWidth=400px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	   
	    sCompID = "UpdateOtherStoreManager";
		sCompURL = "/BusinessManage/StoreManage/UpdateOtherStoreManager.jsp";
	    popComp(sCompID,sCompURL,"City="+sCity+"&SNO="+sSNO+"&oldSalesManager="+oldSalesManager,"dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();	
	}
	
	function viewAndEdit(){
		var sSSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSNo = getItemValue(0, getRow(), "SNO");
		var sStatus= getItemValue(0, getRow(), "STATUS");
		if (typeof(sSSerialNo)=="undefined" || sSSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/StoreManage/StoreInfoTab.jsp","SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&Status="+sStatus+"&Modify=<%=sModify%>","_blank","");
		reloadSelf();
	}
	
	
	//excel导入
	function ExcelImport(){
		var sStatus = getItemValue(0, getRow(), "STATUS"); //门店状态
		if(sStatus == "06"){ //关闭状态
			alert("门店处于关闭状态，不允许Excel导入");
			return;
		}
		
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportStoreInfo", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		
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