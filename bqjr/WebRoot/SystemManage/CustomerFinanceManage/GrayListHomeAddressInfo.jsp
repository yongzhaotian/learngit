<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 家庭地址灰名单详情页面 */
	String PG_TITLE = "家庭地址灰名单详情页面";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SERIALNO"));
	System.out.println(sSerialNo+"-------------------------------");
	if(sSerialNo==null) sSerialNo="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "GrayListHomeAddressInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if("".equals(sSerialNo)) {
		doTemp.WhereClause+=" and 1=2";
	}else {
		doTemp.WhereClause+=(" and SERIALNO='" + sSerialNo + "'");
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		var sPROVINCE=getItemValue(0,0,"PROVINCE");
		var sCITY=getItemValue(0,0,"CITY");
		var sAREA=getItemValue(0,0,"AREA");
		var sTOWN=getItemValue(0,0,"TOWN");
		var sVILLEGE=getItemValue(0,0,"VILLEGE");
		var sCELL=getItemValue(0,0,"CELL");
		var sHOUSENO=getItemValue(0,0,"HOUSENO");
		var sVAL = (sPROVINCE + sCITY + sAREA + sTOWN + sVILLEGE + sCELL + sHOUSENO);
		
		var sSERIALNO=getItemValue(0,0,"SERIALNO");
		//if (typeof(sVAL)!="undefined" && sVAL.length!=0){
			var sCnt=RunMethod("GrayList_MODEL","checkMulti","GrayListHomeAddress,(PROVINCE||CITY||AREA||TOWN||VILLEGE||CELL||HOUSENO),"+sVAL+","+sSERIALNO);
			if(sCnt>0){
				alert("列表中已有重复的家庭地址记录,请重新输入");
				setItemValue(0,0,"PROVINCE","");
				setItemValue(0,0,"CITY","");
				setItemValue(0,0,"AREA","");
				setItemValue(0,0,"TOWN","");
				setItemValue(0,0,"VILLEGE","");
				setItemValue(0,0,"CELL","");
				setItemValue(0,0,"HOUSENO","");
				return;
			}
		//}
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/GrayListHomeAddress.jsp","","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
		setItemValue(0, 0, "INPUTORGNAME", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
	    setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UPDATEORG", "<%=CurOrg.orgID %>");
		setItemValue(0, 0, "UPDATEORGNAME", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var sSerialNo = "<%=DBKeyUtils.getSerialNo()%>";// 获取流水号
			setItemValue(0,getRow(),"SERIALNO",sSerialNo);
			setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "INPUTORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");

			setItemValue(0, 0, "UPDATEORG", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "UPDATEORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			bIsInsert = true;
		}
    }
	
	function getRegionCode() {
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择所要选择的城市！");
			return;
		}
		//setItemValue(0, 0, "CITY", retVal.split("@")[0]);
		setItemValue(0, 0, "CITY", retVal.split("@")[1]);

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
