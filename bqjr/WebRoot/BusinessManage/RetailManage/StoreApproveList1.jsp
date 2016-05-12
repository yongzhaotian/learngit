<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "门店准入审批";
	//获得页面参数
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	System.out.println("----------------------"+sType);
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreApproveList1";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.multiSelectionEnabled=true;
	 doTemp.WhereClause="where  SI.PrimaryApproveTime is not null  and  SI.PrimaryApproveStatus='1' and SI.status='02' "; 
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow	dw
	Vector vTemp = dwTemp.genHTMLDataWindow(sType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			
			{"true","","Button","协议审核","协议审核","PrimaryApprove()","","","","btn_icon_detail",""},
			{"true","All","Button","导出","导出","exportRetailInfo()","","","","btn_icon_delete",""},
			{"true","All","Button","导入","导入","importStoreInfo()","","","","btn_icon_delete",""},
			{"true","All","Button","撤销","撤销","UndoStoreInfo()","","","","btn_icon_delete",""}, // add by tangyb CCS-992
			{"true","All","Button","详情","详情","ViewDetail()","","","","btn_icon_detail",""}, // add by tangyb CCS-992
		};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    //-- add by 添加详情功能 tangyb 20151223 --//
    function ViewDetail(){
    	var sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	var sRegCode=getItemValue(0,getRow(),"REGCODE");
    	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
    		alert("请选择一条记录！");
    		return;
    	}

    	AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetail.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode+"&PhaseType=<%=sType%>","_blank");
    	reloadSelf();
    	
    }
    //-- end --//
    
	function exportRetailInfo(){
		amarExport("myiframe0");
		reloadSelf();
	}
	function importStoreInfo(){
	
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		
		var retal=RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportSafApproveStore", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		var sReturn = "";
		var sReturnNo = "";
		if(retal!=null||retal!=" "){
			sReturn = retal.split("@")[0];
			sReturnNo = retal.split("@")[1];
		}
		if(sReturn=="error"){
			alert("导入失败！");
			return;
		}
		
		var rt = RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectSnoIsBuild", "AllSerialNo="+sReturnNo);
		
		if(rt == "S"){
			alert("导入成功！");
		}else{
			alert("导入失败！");
		}
		
		reloadSelf();
	}

	//-- add by 添加撤销功能 tangyb 20151223 --//
	function UndoStoreInfo() {
		var sSeriaslNo = getItemValueArray(0, "SerialNo");
		var sSerialNo = sSeriaslNo[0];
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert("请选择一条记录！");
			return;
		}

		for (var i = 0; i < sSeriaslNo.length; i++) {
			var sAgreementApproveStatus = RunMethod("公用方法", "GetColValue",
					"Store_info,AGREEMENTAPPROVESTATUS,serialno='" + sSeriaslNo[i] + "'");
			var sSafdePapproveStatus = RunMethod("公用方法", "GetColValue",
					"Store_info,SAFDEPAPPROVESTATUS,serialno='" + sSeriaslNo[i] + "'");
			if ((sAgreementApproveStatus == "1" || sSafdePapproveStatus == "2") || (sAgreementApproveStatus == "2" || sSafdePapproveStatus == "1")) {
				alert(sSeriaslNo[i] + " 安全部或合作协议已审批，不能撤销！");
				return;
			} else if (sAgreementApproveStatus == "4" && sSafdePapproveStatus == "4") {
				RunMethod("PublicMethod", "UpdateColValue", "String@PrimaryApproveStatus@4@String@PrimaryApproveTime@None,store_info,String@serialno@"+ sSeriaslNo[i]);
				RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectSnoIsBuild", "SerialNo=" + sSeriaslNo[i]);
				alert("撤销成功");
			}
		}
		reloadSelf();
	}
	//-- end --//

	function PrimaryApprove(){
		//var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sSeriaslNo = getItemValueArray(0,"SerialNo");
		var sRegCode = getItemValueArray(0,"REGCODE");
		var sAgreementApproveStatus = getItemValueArray(0,"AGREEMENTAPPROVESTATUS");
		var sSerialNo=sSeriaslNo[0];
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		for(var i=0;i<sAgreementApproveStatus.length;i++){
			if(sAgreementApproveStatus[i]=="1" ){
				alert(sSeriaslNo[i]+",该门店已审核，不能再审！");
				return;
			}
		}
		
		AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetail1.jsp","SerialNo="+sSeriaslNo+"&RegCode1="+sRegCode,"_blank");

		reloadSelf();
	}

	function initRow() {
		//以下逻辑会导致这一块卡顿的，分别移动到上传门店确认函和新增门店详情保存按钮
		/* 
		RunJavaMethodSqlca("com.amarsoft.app.billions.SelectRetailInfo","UpdateStoreConfirLetter","1");
		RunJavaMethodSqlca("com.amarsoft.app.billions.SelectRetailInfo","UpdateStoreEntrustedCollection","1");
		setItemValue(0,0,"STOREMAINCONTRACTPOSITION","店长");
		 */
	}
	
	$(document).ready(function() {
		AsOne.AsInit();
		init();
		my_load(2, 0, 'myiframe0');
		initRow();

	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
