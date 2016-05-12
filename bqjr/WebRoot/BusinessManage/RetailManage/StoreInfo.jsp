<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "门店信息";

	// 获得页面参数
	String sRSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RSerialNo"));
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SSerialNo"));
	if(sRSerialNo == null) sRSerialNo = "";
	if(sSSerialNo == null) sSSerialNo = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHTMLStyle("BranchCodeName", "style={width=250px;");
	
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select Account,AccountName,AccountBank,BusinessScope,isindaccount from Retail_Info where SerialNo=:SerialNo").setParameter("SerialNo", sRSerialNo));
	String sAccount = null;
	String sAccountName = null;
	String sAccountBank = null;
	String sPCategory = null;
	String sIsindaccount = "";
	if (rs.next()) {
		sAccount = rs.getString("Account");
		sAccountName = rs.getString("AccountName");
		sAccountBank = rs.getString("AccountBank");
		sPCategory = rs.getString("BusinessScope");
		sIsindaccount = rs.getString("isindaccount");
	}
	if (sAccount == null) sAccount = "";
	if (sAccountName == null) sAccountName = "";
	if (sAccountBank == null) sAccountBank = "";
	if (sPCategory == null) sPCategory = "";
	if (sIsindaccount == null) sIsindaccount = "";
	
	rs.getStatement().close();
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

		//获取城市经理
		function getCityManager() {
			
			var sCity = getItemValue(0, 0, "CITY");
			if (typeof(sCity)=="undefined" || sCity.length==0) {
				alert("请先选择门店所在城市！");
				return;
			}
			
			var sRetVal = setObjectValue("SelectCityResponsiblePerson", "CityNo,"+getItemValue(0, 0, "CITY"),"",0,0,"");
			if (typeof(sRetVal)=='undefined' || sRetVal=="_CLEAR_") {
				return;
			}
			var sUserId = sRetVal.split("@")[0];
			var sUserName = sRetVal.split("@")[1];
			setItemValue(0, 0, "CITYMANAGER", sUserId);
			setItemValue(0, 0, "CITYMANAGERNAME", sUserName);
		}
		
		// 如果是商户网银，门店结算等信息不可修改
		function isNetBank() {
			
			
		}
		
		// 如果使用商户网银，设置成默认值，替代下拉框不能设置成只读
		function setBankDefValue() {
			
		}


	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		var sRetVal = PopPage("/Common/ToolsC/AllCityCodeNoSingle.jsp","","dialogWidth=550px;dialogHeight=600px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
	
		if (typeof(sRetVal)=='undefined' || sRetVal.length==0) {
			alert("请选择所要选择的城市！");
			return;
		}
		
		var sAreaCodeInfo = sRetVal.split('@');
		var sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
		var sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
		setItemValue(0,0,"REGIONCODE",sAreaCodeValue);
		setItemValue(0,0,"REGIONCODENAME",sAreaCodeName);
		
	}
	
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
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
		
		AsControl.OpenView("/BusinessManage/RetailManage/RetailStoreList.jsp", "RSerialNo=<%=sRSerialNo %>", "_self","");
		
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"InputOrg","<%=CurOrg.orgID%>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateOrg","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var serialNo = getSerialNo("Store_Info","SerialNo");// 获取流水号
			setItemValue(0,getRow(),"SerialNo",serialNo);
			setItemValue(0,0,"InputOrg","<%=CurOrg.orgID%>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
			
			setItemValue(0,0,"UpdateOrg","<%=CurOrg.orgID%>");
			setItemValue(0, 0, "UpdateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
			bIsInsert = true;
		}
		setItemValue(0, 0, "Account", "<%=sAccount %>");
		setItemValue(0, 0, "AccountName", "<%=sAccountName %>");
		setItemValue(0, 0, "AccountBank", "<%=sAccountBank %>");
		setItemValue(0, 0, "PCategory", "<%=sPCategory %>");
		setItemValue(0, 0, "isindaccount", "<%=sIsindaccount%>");
		
		isNetBank();
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
