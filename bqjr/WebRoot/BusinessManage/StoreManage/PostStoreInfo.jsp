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
	String sActionType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ActionType"));

	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	
	if (sSerialNo == null) sSerialNo = "";
	if (sSSerialNo == null) sSSerialNo = "";
	if (sSNo == null) sSNo = "";
	if (sActionType == null) sActionType = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StorePostStoreInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	
	//关闭状态不允许编辑 update CCS-884 关闭状态隐藏保存按钮 tangyb 20150720
	if(!"06".equals(sStatus)){
		dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	}else{
		dwTemp.ReadOnly = "1"; // 设置是否只读 1:只读 0:可写
	}
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
	};
	
	//add CCS-884 关闭状态隐藏保存按钮 tangyb 20150720
	if("06".equals(sStatus)){
		sButtons[0][0]="false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	function selectStore() {
		var sRet = setObjectValue("SelectStoreMulti", "", "");
		if (typeof(sRet)=='undefined' || "_CLEAR_"==sRet || sRet.length==0) {
			alert("请选择需要关联的门店！");
			return;
		}
		sRet = sRet.substring(0, sRet.length-1);
		var sRelativeSNo = "";
		var sRelativeSName = "";
		var retArray = sRet.split("@");
		for (var i in retArray) {
			if (i%2==0) {
				sRelativeSNo += retArray[i] + "@";
			} else if (i%2==1) {
				sRelativeSName += retArray[i] + "@";
			}
		}
	
		setItemValue(0, 0, "RELATIVESNO", sRelativeSNo.substring(0, sRelativeSNo.length-1));
		setItemValue(0, 0, "RELATIVESNAME", sRelativeSName.substring(0, sRelativeSName.length-1));
		
	}
	function selectStoreSingle() {
		
		var sSNo = setObjectValue("SelectStoreSingle", "", "");
		if (typeof(sSNo)=='undefined' || sSNo.length==0) {
			alert("请选择需要关联的门店！");
			return;
		}
	
		setItemValue(0, 0, "RELATIVESNO", sSNo.split("@")[0]);
		
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);

		var retResult = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "getStoreRelativePostStore", "serialNo="+getItemValue(0, 0, "SERIALNO"));
		if ("FAIL"==retResult) {
			alert("关联产品失败，请检查！");
			return;
		}
		
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		if ("<%=sActionType%>" ==  "<%=CommonConstans.VIEW_DETAIL %>") {
			self.close();
			return;
		}
		
		AsControl.OpenView("/BusinessManage/StoreManage/PostStoreList.jsp", "SNo=<%=sSNo %>", "_self","");

	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var serialNo = getSerialNo("Storerelativepoststore", "SerialNo");
			setItemValue(0, 0, "SERIALNO", serialNo);
			setItemValue(0, 0, "SNO", "<%=sSNo %>");
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
