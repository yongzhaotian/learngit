<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%

	/*
		Author:  
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 2015/06/05 CCS-863 门店部分转移时销售经理无一对多校验，需添加校验
	*/

	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "门店部分转移";

	// 获得页面参数
	String sCity =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("City"));
	String oldSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNO"));
	String oldSalesManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("oldSalesManager"));
	if(oldSalesManager == null) oldSalesManager = "";
	if(sCity == null) sCity = "";
	if(oldSNO == null) oldSNO = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "UpdateOtherManagerInfo1";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//doTemp.setCheckFormat("REMOVEDATE", "3");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","确定","确定","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","取消","取消 ","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">



/*~[Describe=生效日需要大于等于今天;InputParam=无;OutPutParam=无;]~*/
	function datecheck() {
		
		var sMoveDate = getItemValue(0, 0, "moveDate");
		sMoveDate = sMoveDate.split("/");//用的是时间控件格式是yyyy/MM/dd
		//var sEndTime = getItemValue(0, 0, "endDate");
		//因为当前时间的月份需要+1，故在此-1，不然和当前时间做比较会判断错误
		var MoveDate = new Date(sMoveDate[0], sMoveDate[1] - 1, sMoveDate[2]);
		var now = new Date();//当前时间
		if (MoveDate < now && !( sMoveDate[0] == now.getFullYear() && sMoveDate[1] == (now.getMonth() + 1) && sMoveDate[2] == now.getDate() )) {
			alert("生效日必须大于等于今天！");
			return 1;
		}
		return 0;
	}

/*~[Describe=弹出单选框选择销售人员;InputParam=无;OutPutParam=无;]~*/
	function selectSalesmanSingle1() {
		sCity="<%=sCity%>";
		var sRetVal = setObjectValue("SelectSalesmanSingleByCity", "City,"+ sCity, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			return;
		}
	
		setItemValue(0, 0, "SALESMANAGER", sRetVal.split("@")[0]);
		setItemValue(0, 0, "SALESMANAGERNAME", sRetVal.split("@")[1]);
		return;
	}
	
	function selectSalesmanSingle2() {
		sCity="<%=sCity%>";
		var sRetVal = setObjectValue("SelectSalesmanSingleByCity", "City,"+ sCity, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			return;
		}
	
		setItemValue(0, 0, "SALESMANAGER1", sRetVal.split("@")[0]);
		setItemValue(0, 0, "SALESMANAGERNAME1", sRetVal.split("@")[1]);
		return;
	}
	
	function selectSNO(){
		var sSalesManager = getItemValue(0,getRow(),"SALESMANAGER");	
		if (typeof(sSalesManager)=="undefined" || sSalesManager.length==0) {
			alert("请先选择一个销售经理！");
			return;
		}
		var sRetVal = setObjectValue("SelectStoreManager1", "salesmanager ,"+ sSalesManager, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择一个门店！");
			return;
		}
		setItemValue(0, 0, "SNO", sRetVal);
		setItemValue(0, 0, "SNOName", sRetVal);
	}
	
	function saveRecord(sPostEvents){
		var sret = datecheck();
		if (sret != 0) return;
		
		var newSNO = getItemValue(0,getRow(),"SNO");
		var salesManager = getItemValue(0,getRow(),"SALESMANAGER");
		var newSalesManager = getItemValue(0,getRow(),"SALESMANAGER1");
		var moveDate = getItemValue(0,getRow(),"moveDate");
		
		
		if (typeof(newSNO)=="undefined" || newSNO.length==0) {
			alert("请先选择一个门店！");
			return;
		}
		if (typeof(newSalesManager)=="undefined" || newSalesManager.length==0) {
			alert("请选择要转移的销售经理！");
			return;
		}
		var sParam = "salesManager="+salesManager+",newSalesManager="+newSalesManager+",ewNo="+newSNO+",moveDate="+moveDate+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
		
		var snoArr = newSNO.split("@");
		var whereClause = "(SR.SNO = '";
		for( var i=0,len=snoArr.length ; i<len ; i++ ){
			whereClause += snoArr[i];
			if( i < len - 2 ){
				whereClause += "' OR SR.SNO = '";
			}
		}
		whereClause += "')";
		whereClause += " and SR.stype is null ";	//查所选门店绑定的销售人员
		
		var sales = RunMethod("GetElement","GetElementValue","wm_concat(distinct SR.Salesmanno),storerelativesalesman SR,"+whereClause);
		sales = sales.split(",");
		var Salesmanno = "(SR.Salesmanno = '";
		for( var i=0,len=sales.length ; i<len ; i++ ){
			Salesmanno += sales[i];
			if( i < len - 1 ){
				Salesmanno += "' OR SR.Salesmanno = '";
			}
		}
		Salesmanno += "')";
		Salesmanno += " and SR.stype is null ";	//查销售人员绑定的门店号
		var snoArr = RunMethod("GetElement","GetElementValue"," wm_concat(SR.sno),storerelativesalesman SR,"+Salesmanno);
		snoArr = snoArr.split(",");
		for( var i=0,len=snoArr.length ; i<len ; i++ ){
			if( newSNO.indexOf(snoArr[i]) == -1 ){
				alert("请先解绑门店");
				return;
			}
		}
		
		// add by xswang 2015/06/05 CCS-863 门店部分转移时销售经理无一对多校验，需添加校验
		//查销售人员绑定的销售经理（不在所选门店的）		
		var snoArr2 = newSNO.split("@");
		var whereClause1 = "(SR.SNO <> '";
		for( var i=0,len=snoArr2.length ; i<len ; i++ ){
			whereClause1 += snoArr2[i];
			if( i < len - 2 ){
				whereClause1 += "' and SR.SNO <> '";
			}
		}
		whereClause1 += "')";
		whereClause1 += " and SR.stype is null ";
		
		var snoArr1 = RunMethod("GetElement","GetElementValue","salemanagerno,storerelativesalesman SR,"+Salesmanno+" and "+whereClause1 );
		if(snoArr1 != "Null" && snoArr1 != "" && snoArr1 != " "){
			snoArr1 = snoArr1.split(",");
			for( var i=0,len=snoArr1.length ; i<len ; i++ ){
				if(newSalesManager.indexOf(snoArr1[i]) == -1){
					if(salesManager != newSalesManager){
						alert("该销售代表在其他门店已绑定销售经理，不能转移!");
						return;
					}
				}
			}
		}
		// end by xswang 2015/06/05
		
//		RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "updateAllManager2", sParam);
		var retResult = RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "updateAllManager1", sParam);
		if(retResult=="SUCESS"){
			alert("转移成功！");
		}
		self.close();
	}
	
	function saveAndGoBack(){
		self.close();
	}
	
	function goBack(){
		
		//AsControl.OpenView("/BusinessManage/StoreManage/StoreList.jsp", "", "_self","");
		top.close();
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
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