<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "还款渠道详情";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sLoanNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
	String sOperateType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateType")); 
	if(sSerialNo==null || "".equals(sSerialNo)) sSerialNo = "";
	if(sOperateType == null) sOperateType ="";
	String sTypeCode = "RepaymentChannel";
	
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RepaymentChannelInfoNew";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存","保存所有修改","saveRecord(saveSerailNo())",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"false","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
	if(!"".equals(sOperateType)){
		sButtons[0][0] = "false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	var existCityValue = "" ; //已经存在城市
	
	function checkExistCityChannel(){
		var sBigValue = getItemValue(0, 0, "BIGVALUE");
		var sSerialNo = getItemValue(0,0,"SERIALNO");
		if(""== sBigValue) return false;
		sReturn = RunMethod("PublicMethod","GetColValue","BIGVALUENAME,BaseDataSet_Info,String@BigValue@"+sBigValue+"@String@TypeCode@RepaymentChannel");
		sReturnNo = RunMethod("PublicMethod","GetColValue","SERIALNO,BaseDataSet_Info,String@BigValue@"+sBigValue+"@String@TypeCode@RepaymentChannel");
		if(bIsInsert){//新增
			if("" == sReturn) return false;
			return true;
		}else{//修改
			if("" == sReturn) return false;
			return !(sReturnNo.indexOf(sSerialNo)>=0);
		}
	}
	
	function saveRecord(sPostEvents){
		if(checkExistCityChannel()){
			alert("该城市的还款渠道已存在！");
			return;
		}
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
		AsControl.OpenView("/CustomService/BusinessConsult/RepaymentChannelList.jsp","LoanNo=<%=sLoanNo %>","_self");
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
		existCityValue = getItemValue(0, 0, "BIGVALUENAME");	
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//alert(retVal+"|"+typeof(retVal));
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("请选择所要选择的城市！");
			return;
		}
		var cityItems = retVal.split("~");
		var sCityNos = "";
		var sCityNames = "";
		for (var i in cityItems) {
			sCityNos += cityItems[i].split("@")[0]+",";
			sCityNames += cityItems[i].split("@")[1]+",";
		}
		sCityNos = sCityNos.substring(0,sCityNos.length-1);
		sCityNames = sCityNames.substring(0,sCityNames.length-1);
		//setItemValue(0, 0, "NearCity", sCityNos);
		//setItemValue(0, 0, "NearCityName", sCityNames);
		setItemValue(0, 0, "BIGVALUE", sCityNos);    //修改为  wlq 
		setItemValue(0, 0, "BIGVALUENAME", sCityNames);
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
			setItemValue(0,getRow(),"SERIALNO","<%=sSerialNo%>");
			setItemValue(0, 0, "TYPECODE", "<%=sTypeCode %>");
			setItemValue(0, 0, "ATTRSTR1", "<%=sLoanNo %>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

			setItemValue(0, 0, "TYPECODE", "<%=sTypeCode %>");
			
			// temp set the defautl value is 02   01-Customer, 02-Car
			setItemValue(0, 0, "IDENTIFICATION", "02");
			bIsInsert = true;
			setSessionValue("repaymentChannelSerialNo",sSerialNo);//将流水号保存到session
		}else{
			existCityValue = getItemValue(0, 0, "BIGVALUENAME");
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
