<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "门店已完成任务";
	//获得页面参数
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	System.out.println("----------------------"+sType);
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreApproveList2";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//05不通过
	if("05".equals(sType)){
		PG_TITLE = "门店不通过任务";
		doTemp.WhereClause=" WHERE (SI.primaryapprovestatus = '2' or SI.agreementapprovestatus = '2' or SI.safdepapprovestatus = '2') ";  // add by tangyb CCS-992
	} else {
		doTemp.WhereClause=" WHERE (((to_date(to_char(SYSDATE, 'yyyy-MM-dd hh24:mi:ss'), 'yyyy-MM-dd hh24:mi:ss') - to_date(SI.safdepapprovetime, 'yyyy-MM-dd hh24:mi:ss')) <= 3) OR"+
			  	" ((to_date(to_char(SYSDATE, 'yyyy-MM-dd hh24:mi:ss'), 'yyyy-MM-dd hh24:mi:ss') - to_date(SI.agreementapprovetime, 'yyyy-MM-dd hh24:mi:ss')) <= 3))"+
				" AND SI.primaryapprovestatus = '1' AND SI.agreementapprovestatus = '1' AND SI.safdepapprovestatus = '1' ";  // add by tangyb CCS-992
	}
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{"false","","Button","协议审核","协议审核","PrimaryApprove()","","","","btn_icon_detail",""},
			{"false","All","Button","导出","导出","exportRetailInfo()","","","","btn_icon_delete",""},
			{"false","All","Button","导入","导入","importStoreInfo()","","","","btn_icon_delete",""},
			{"true","","Button","详情","详情","ViewDetail()","","","","btn_icon_detail",""}, //add by tangyb CCS-992
		};
	
	if("05".equals(sType)){
		sButtons[0][0]="true";
		sButtons[1][0]="true";
		sButtons[2][0]="true";
	}
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.PopView("/BusinessManage/RetailManage/RetailApplyInfo.jsp", "", "");

	}
	
	//-- add by tangyb 添加详情功能 20151224 --//
	function ViewDetail(){
	    	var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
	    	var sRegCode = getItemValue(0,getRow(),"REGCODE");
	    	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	    		alert("请选择一条记录！");
	    		return;
	    	}

	    	AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetail.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode+"&PhaseType=<%=sType%>","_blank");
	    	reloadSelf();
    	
	}
	//-- end --//
	
	//-- add by tangyb 添加导出功能 20151224 --//
	function exportRetailInfo(){
		amarExport("myiframe0");
		reloadSelf();
	}
	//-- end --//
	
	//-- add by tangyb 添加导入功能 20151224 --//
	function importStoreInfo(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
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

		reloadSelf();
	}
	//-- end --//

	//-- add by tangyb 添加协议审核功能 20151224 --//
	function PrimaryApprove() {
		var sRSerialNo = getItemValue(0, getRow(),"RSERIALNO");
		var sSerialNo = getItemValue(0, getRow(),"SERIALNO");
		var sRegCode = getItemValue(0, getRow(),"REGCODE");
		var sPrimaryapprovestatus = getItemValue(0, getRow(),"PRIMARYAPPROVESTATUS");
		
		//alert("sRSerialNo="+sRSerialNo+",sSerialNo="+sSerialNo+",sRegCode="+sRegCode+",sPrimaryapprovestatus="+sPrimaryapprovestatus);
		
		if (typeof (sSerialNo) == "undefined" || sSerialNo.length == 0) {
			alert("请选择一条记录！");
			return;
		}
		
		if(!sPrimaryapprovestatus == "通过"){
			alert("您选择的记录初审未通过不能协议审核");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetail1.jsp", "SerialNo=" + sSerialNo + "&RegCode1=" + sRegCode, "_blank");

		reloadSelf();
	}
	//-- end --//
	
	function doSubmit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		RunMethod("公用方法", "UpdateColValue", "Retail_Info,Status,02,SerialNo='"+sSerialNo+"'");
		reloadSelf();
	}
    
	function initRow(){
					
		
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
