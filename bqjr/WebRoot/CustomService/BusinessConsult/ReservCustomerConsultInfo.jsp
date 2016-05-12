<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "客户预约"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sWhereClause = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("WhereClause"));
	
	if (sSerialNo == null) sSerialNo = "";
	if (sWhereClause == null) sWhereClause = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CustomerConsultInfo";//模型编号
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//交易定义详情模板
	
	// 设置默认值

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存记录","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表也面","goBack()",sResourcesPath},
		{"false","","Button","返回xxxx","返回列表也面","selectAreaInfo()",sResourcesPath},
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=弹出所有预约销售人员信息 InputParam=无;OutPutParam=无;]~*/
	function getSalesmanSingle() {
		
		var sRetVal = setObjectValue("SelectSalesmanSingle", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择销售！");
			return;
		}
		setItemValue(0, 0, "RESERVSALES", sRetVal.split("@")[0]);
		setItemValue(0, 0, "RESERVSALESNAME", sRetVal.split("@")[1]);
		return;
		
	}
	
	/*~[Describe=弹出单选门店信息 InputParam=无;OutPutParam=无;]~*/
	function getStoreSingle() {
		
		var sRetVal = setObjectValue("SelectStoreSingle", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择门店！");
			return;
		}
		setItemValue(0, 0, "RESERVSTORE", sRetVal.split("@")[0]);
		setItemValue(0, 0, "RESERVSTORENAME", sRetVal.split("@")[1]);
		return;
	}
	
	/*~[Describe=弹出所有商品信息 InputParam=无;OutPutParam=无;]~*/
	function getProductCTypeMulti() {
		
		var sRetVal = setObjectValue("SelectProductCTypeMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择商品！");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "CHARMPRODUCT", sCTypeIds.substring(0, sCTypeIds.length-1));
		setItemValue(0, 0, "CHARMPRODUCTNAME", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	/*~[Describe=弹出所有产品信息 InputParam=无;OutPutParam=无;]~*/
	function getBusinessTypeMulti() {
		
		var sRetVal = setObjectValue("SelectBusinessTypeMulti", "", "", 0, 0, "");
		
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择产品！");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeNos = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeNos += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "BUSINESSTYPE", sCTypeNos.substring(0, sCTypeNos.length-1));
		setItemValue(0, 0, "BUSINESSTYPENAME", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	
	// 检测时间是否大于当前时间
	function checkDateAfterNow(field) {
		
		var sNowDate = getItemValue(0, 0, "INPUTDATE");
		var sInputDate = getItemValue(0, 0, "RESERVDATETIME");
		if (sNowDate.localeCompare(sInputDate) >= 0) {
			alert("选择日期应大于当前日期");
		}		
	}
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode() {

		var sRetVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//var sRetVal = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode=","dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		
		if (typeof(sRetVal)=="undefined" || sRetVal=='_CLEAR_' || sRetVal.length==0) {
			alert("请选择的城市！");
			return;
		}
		
		setItemValue(0, 0, "CITY", sRetVal.split("@")[0]);
		setItemValue(0, 0, "CITYNAME", sRetVal.split("@")[1]);

	}
	
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		//alert("客户预约信息提交成功!");
	}
	
	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID() %>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	// 返回交易列表
	function goBack()
	{
		AsControl.OpenView("/CustomService/BusinessConsult/StoreConsultList.jsp","WhereClause=<%=sWhereClause %>","_self");
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			var sSerialNo = getSerialNo("Consult_Info","SERIALNO");// 获取流水号
			setItemValue(0,getRow(),"SERIALNO",sSerialNo);
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID %>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID %>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName %>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }

	</script>

<script language=javascript>
	bFreeFormMultiCol = true;
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
