<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号、发生方式、发生日期
	
	String sApplySerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplySerialNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
    
	
	if(sApplySerialNo == null) sApplySerialNo = "";	
	if(sObjectType == null) sObjectType = "MobilePosApply";	
	if(sApplyType == null) sApplyType = "MobilePosApply";
	if(sPhaseType == null) sPhaseType = "1010";	
	if(sFlowNo == null) sFlowNo = "MobilePosApplyFlow";
	if(sPhaseNo == null) sPhaseNo = "";
	
   String sSql = "";
   String sStatusCode = "";
	ASResultSet rs = null;//-- 存放结果集
	sSql = "select Status as StatusCode  from MOBILEPOS_INFO where ApplySerialNo=:ApplySerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ApplySerialNo",sApplySerialNo));
	if(rs.next()){
		sStatusCode = rs.getString("StatusCode");
     }
	rs.getStatement().close();
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "MobilePosApplyInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if((sStatusCode.equals("02"))||(sStatusCode.equals("03"))||(sStatusCode.equals("04"))){
		doTemp.setReadOnly("", true);
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//设置保存时操作关联数据表的动作
	//dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+","+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.orgID+")");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sApplySerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	

	String sButtons[][] = {
		{((sStatusCode.equals("02"))||(sStatusCode.equals("03"))||(sStatusCode.equals("04")))?"false":"true","","Button","确认","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		var sRetVal = setObjectValue("SelectCityCodeSingle", "", "", 0, 0, "");
		
		if (typeof(sRetVal)=='undefined' || sRetVal=='__CLEAR__' || sRetVal.length==0) {
			alert("请选择城市！");
			return;
		}
		setItemValue(0, 0, "CITY", sRetVal.split("@")[0]);
		setItemValue(0, 0, "CITYNAME", sRetVal.split("@")[1]);
		
	}
	
	
	
	
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		var sObjectNo = getItemValue(0, 0, "SerialNo");
		
		var sUserId = getItemValue(0, 0, "USERID");//获取当前输入的用户编号	
		
		/**
		 * add_CCS-958：PRM-516 移动POS点的改进优化_tangyb_20150806_start
		 * 1.在移动POS的申请中，系统自动识别同一个门店不能在同一时间段同时申请两个移动POS点。
		 */
		var applyserialno = getItemValue(0, 0, "ApplySerialNo");//申请流水号
		var retaivestoreno = getItemValue(0, 0, "RetaiveStoreNo");//关联门店
		var starttime = getItemValue(0, 0, "StartTime");//开始时间	
		var endtime = getItemValue(0, 0, "EndTime");//结束时间
		
		//alert("starttime="+starttime+",endtime="+endtime+",retaivestoreno="+retaivestoreno+",applyserialno="+applyserialno);
		
		if (starttime != '' && endtime != '') {
			var sdate = starttime.split('/'); //用的是时间控件格式是yyyy/MM/dd
			var edate = endtime.split('/');
			//因为当前时间的月份需要+1，故在此-1，不然和当前时间做比较会判断错误
			var start = new Date(sdate[0], sdate[1] - 1, sdate[2]); 
			var end = new Date(edate[0], edate[1] - 1, edate[2]);
			var date = new Date();//当前时间
			if (end <= date) {
				alert("结束日期必须大于当前日期");
				return;
			}
			if (start >= end) {
				alert("结束日期必须大于开始日期 ");
				return;
			}
		}
		
		//查询门店是否在同一时间段同时申请多个移动POS点
		var args = "starttime="+starttime+",endtime="+endtime+",retaivestoreno="+retaivestoreno+",applyserialno="+applyserialno;
		var isRepeat = RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMobilePosNo", "checkStorePosApp", args);
		
		if(isRepeat == "1"){
			alert("同一个门店不能在同一时间段同时申请两个以上移动POS点。");
			return;
		}
		/*-- end --*/
		
		as_save("myiframe0",sPostEvents);
		UpdatePosNo(sObjectNo);//生成POS点编号

	}
	<%/*~[Describe=保存后生成pos点编号;]~*/%>
	function UpdatePosNo(sObjectNo){
		var PosNo = RunMethod("公用方法","GetColValue","MobilePos_Info,MOBLIEPOSNO,SerialNo='"+sObjectNo+"'");
		if(PosNo.length==0||PosNo==""){
			RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMobilePosNo","UpdatePosNo","SerialNo="+sObjectNo);
		}
		
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		//AsControl.OpenView("/BusinessManage/CollectionManage/SalesManList.jsp","","_self");
		top.close();
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		
		var sEmpNo = getItemValue(0, 0, "SerialNo");
		RunMethod("WorkFlowEngine","InitializeFlow","<%=sObjectType%>"+","+sEmpNo+","+"<%=sApplyType%>"+","+"<%=sFlowNo%>"+","+"<%=sPhaseNo%>"+","+"<%=CurUser.getUserID()%>"+","+"<%=CurOrg.orgID%>");		
		
		bIsInsert = false;
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UPDATEORG", "");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	function getStoreReatil(){
		var sRetVal = setObjectValue("SelectApprovedStore", "UserID,<%=CurUser.getUserID()%>", "", 0, 0);
	
		if (typeof(sRetVal)=='undefined'||sRetVal=='_CLEAR_') {
			alert("请选择关联门店！");
			return;
		}
	//	alert(sRetVal);
		//SerialNo@RSerialNo@Sname@Address@City@SalesManagerName@SalesManPhone@CityManager
		setItemValue(0, 0, "RetaiveStoreNo", sRetVal.split("@")[0]);
		//setItemValue(0, 0, "RSerialNo", sRetVal.split("@")[1]);
		var sRname = RunMethod("公用方法", "GetColValue", "retail_info,rname,serialno='"+sRetVal.split("@")[1]+"'");
		setItemValue(0, 0, "RSerialNo", sRname);
		setItemValue(0, 0, "SName", sRetVal.split("@")[2]);
		setItemValue(0, 0, "StoreAddress", sRetVal.split("@")[3]);
		setItemValue(0, 0, "StoreCity", sRetVal.split("@")[4]);
		setItemValue(0, 0, "City", sRetVal.split("@")[4]);
		setItemValue(0, 0, "SalesManagerName", sRetVal.split("@")[5]);
		setItemValue(0, 0, "SalesManPhone", sRetVal.split("@")[6]);
		setItemValue(0, 0, "CityManager", sRetVal.split("@")[7]);
       //setItemValue(0, 0, "CityManagerName", sRetVal.split("@")[7]);
		
		setItemValue(0, 0, "CityName", sRetVal.split("@")[8]);
		setItemValue(0, 0, "StoreCityName", sRetVal.split("@")[8]);
		
		
		
		
	}
	function initRow(){
		var sRetativeStoreNo=getItemValue(0,0,"RetaiveStoreNo");
		//alert(sRetativeStoreNo);
		var sRetVal=RunMethod("BusinessManage","SelectStoreInfoForMobilePos",sRetativeStoreNo);
		
		/* setItemValue(0, 0, "RSerialNo", sRetVal.split("@")[1]); */
		var sRname = RunMethod("公用方法", "GetColValue", "retail_info,rname,serialno='"+sRetVal.split("@")[1]+"'");
		setItemValue(0, 0, "RSerialNo", sRname);
		setItemValue(0, 0, "SName", sRetVal.split("@")[2]);
		setItemValue(0, 0, "StoreAddress", sRetVal.split("@")[3]);
		setItemValue(0, 0, "StoreCity", sRetVal.split("@")[4]);
		setItemValue(0, 0, "City", sRetVal.split("@")[4]);
		//setItemValue(0, 0, "SalesManagerName", sRetVal.split("@")[5]);
		setItemValue(0, 0, "SalesManPhone", sRetVal.split("@")[6]);
		//setItemValue(0, 0, "CityManager", sRetVal.split("@")[7]);
		setItemValue(0, 0, "CityName", sRetVal.split("@")[8]);
		setItemValue(0, 0, "StoreCityName", sRetVal.split("@")[8]);
		
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			var ApplySerialNo=getSerialNo("MOBILEPOS_INFO","ApplySerialNo","");
			var sSerialNo="POS"+ApplySerialNo;
			setItemValue(0, 0, "ApplySerialNo", ApplySerialNo);
			setItemValue(0, 0, "Status", "01");
			setItemValue(0, 0, "SerialNo", sSerialNo);
			setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "PermitType", "03");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
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
