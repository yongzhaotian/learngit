<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "销售经理转移";

	// 获得页面参数
	/*String sCity =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("City"));
	String oldSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNO"));
	String oldSalesManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("oldSalesManager"));
	if(oldSalesManager == null) oldSalesManager = "";
	if(sCity == null) sCity = "";
	if(oldSNO == null) oldSNO = "";*/
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "UpdateSalesManagerSuper";//模型编号
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

/*~[Describe=弹出单选框选择原城市经理;InputParam=无;OutPutParam=无;]~*/
	function selectSalesmanSingle1() {
		var sRetVal = setObjectValue("SelectCityManager", "", "", 0, 0, "");
		
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			return;
		}
	
		setItemValue(0, 0, "CITYMANAGERFROM", sRetVal.split("@")[0]);
		setItemValue(0, 0, "CITYMANAGERFROMNAME", sRetVal.split("@")[1]);
		return;
	}
	
	/*~[Describe=弹出单选框选择新城市经理;InputParam=无;OutPutParam=无;]~*/
	function selectSalesmanSingle2() {
		var sRetVal = setObjectValue("SelectCityManager", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			return;
		}
	
		setItemValue(0, 0, "CITYMANAGERTO", sRetVal.split("@")[0]);
		setItemValue(0, 0, "CITYMANAGERTONAME", sRetVal.split("@")[1]);
		return;
	}
	
	/*~[Describe=弹出单选框选择销售经理;InputParam=无;OutPutParam=无;]~*/
	function selectSalesManager(){
		var sCITYMANAGERFROM = getItemValue(0,getRow(),"CITYMANAGERFROM");	
		if (typeof(sCITYMANAGERFROM)=="undefined" || sCITYMANAGERFROM.length==0) {
			alert("请先选择一个城市经理！");
			return;
		}
		var sRetVal = setObjectValue("SelectSalesManagerByCityManager", "superId ,"+ sCITYMANAGERFROM, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择一个销售经理！");
			return;
		}
		setItemValue(0, 0, "SALESMANAGER", sRetVal.split("@")[0]);
		setItemValue(0, 0, "SALESMANAGERNAME", sRetVal.split("@")[1]);
	}
	
	function saveRecord(sPostEvents){
		var sret = datecheck();
		if (sret != 0) return;
		
		var salesManagers = getItemValue(0,getRow(),"SALESMANAGER");
		var cityManagerFrom = getItemValue(0,getRow(),"CITYMANAGERFROM");
		var cityManagerTo = getItemValue(0,getRow(),"CITYMANAGERTO");
		var moveDate = getItemValue(0,getRow(),"moveDate");
		
		if (typeof(salesManagers)=="undefined" || salesManagers.length==0) {
			alert("请先选择一名销售经理！");
			return;
		}
		
		if (typeof(cityManagerTo)=="undefined" || cityManagerTo.length==0) {
			alert("请选择要转移的城市售经理！");
			return;
		}
		var sParam = "salesManager="+cityManagerFrom+",newSalesManager="+cityManagerTo+",ewNo="+salesManagers+",moveDate="+moveDate+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
		
		
		var retResult = RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "updateCityManager", sParam);
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
