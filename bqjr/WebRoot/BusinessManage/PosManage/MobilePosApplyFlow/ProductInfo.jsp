<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "门店信息";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SSerialNo"));
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sMobilePosNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MobilePosNo"));
	String sActionType = DataConvert.toRealString(iPostChange, (String)CurPage.getParameter("ActionType"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	
	if (sSSerialNo == null) sSSerialNo = "";
	if (sSerialNo == null) sSerialNo = "";
	if (sMobilePosNo == null) sMobilePosNo = "";
	if (sSNo == null) sSNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "MobilePosProductInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	// 设置字段可见属性
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{CurUser.hasRole("1005")&&"0010".equals(sPhaseNo)?"true":"false","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	function selectProductCategory() {
		var ssSNo="<%=sSNo%>";
		var sRetVal = setObjectValue("SelectProductForMobilePos", "SNo,"+ssSNo+",POSNO,<%=sMobilePosNo%>", "",0,0,"dialogWidth:660px;dialogHeight:450px;resizable:yes;scrollbars:no;status:no;help:no");
		//alert(sRetVal);
		if (typeof(sRetVal)=='undefined' || sRetVal.length==0) {
			//alert("请选择商品范畴！");
			return;
		}
		
		sRetVal = sRetVal.substring(0, sRetVal.length-1);
		var retArry = sRetVal.split("@");
		var sPNo = "";
		var sPName = "";
		for (var i in retArry) {
			if (i%2==0) {
				sPNo += retArry[i] + "@";
			} else if (i%2==1) {
				sPName += retArry[i] + "@";
			}
		}
//		alert(sPNo.substring(0, sPNo.length-1));
//		alert(sPName.substring(0, sPName.length-1));
		setItemValue(0, 0, "PNO", sPNo.substring(0, sPNo.length-1));
		setItemValue(0, 0, "PNAME", sPName.substring(0, sPName.length-1));
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		//as_save("myiframe0",sPostEvents); 
		var sParam = "";
		var sSerialNo = getItemValue(0,0,"SERIALNO");//流水号
		var sPosNo = getItemValue(0,0,"POSNO");//pos编号
		var sPNos = getItemValue(0,0,"PNO");
		var sPNAMEs = getItemValue(0,0,"PNAME");
		var sINPUTORG = getItemValue(0,0,"INPUTORG");
		var sINPUTUSER = getItemValue(0,0,"INPUTUSER");
		var sINPUTDATE = getItemValue(0,0,"INPUTDATE");
		var sUPDATEORG = getItemValue(0,0,"UPDATEORG");
		var sUPDATEUSER = getItemValue(0,0,"UPDATEUSER");
		var sUPDATEDATE = getItemValue(0,0,"UPDATEDATE");
		sParam = "SerialNo="+sSerialNo+",POSNO="+sPosNo+",PNO="+sPNos+",PNAME="+sPNAMEs+",INPUTORG="+sINPUTORG
		+",INPUTUSER="+sINPUTUSER+",INPUTUSER="+sINPUTUSER+",UPDATEDATE="+sUPDATEDATE+",INPUTDATE="+sINPUTDATE
		+",UPDATEORG="+sUPDATEORG+",UPDATEUSER="+sUPDATEUSER;
		
		var sRetResult= RunJavaMethodSqlca("com.amarsoft.app.billions.PosRelativeProduct", "sRelativeProduct", sParam);
		if ("FALSE" == sRetResult) {
			alert("关联产品失败，请检查！");
			return;
		}else if("NoProduct"==sRetResult){
			alert("产品选择失败，请检查！");
			return;
		}else{
			alert("关联产品成功！");
		}
		var sPNO = RunMethod("公用方法","GetColValue", "MobilePosRelativeProduct,PNO,SerialNo='"+sSerialNo+"'");
		setItemValue(0, 0, "PNO",sPNO );
		var sPName = RunMethod("公用方法","GetColValue", "MobilePosRelativeProduct,PNAME,SerialNo='"+sSerialNo+"'");
		setItemValue(0, 0, "PNAME",sPName );
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		if ("<%=sActionType%>" == "<%=CommonConstans.VIEW_DETAIL%>") {
			self.close();
			return;
		}
		var sSNo = "<%=sSNo%>"
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/ProductList.jsp", "SNo="+sSNo+"&MOBLIEPOSNO=<%=sMobilePosNo %>", "_self","");

	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var sSerialNo = getSerialNo("MobilePosRelativeProduct","SerialNo");// 获取流水号
			setItemValue(0,0,"SERIALNO",sSerialNo);
			setItemValue(0, 0, "POSNO", "<%=sMobilePosNo %>");
			setItemValue(0, 0, "SSERIALNO", "<%=sSSerialNo %>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
		
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
