<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "还款渠道详情";

	// 获得页面参数
	String sChannelSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ChannelSerialNo"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("detailSerialNo"));
	String sOperateType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateType"));
	String sfromContractView =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("fromContractView"));//是否来自合同查看
 	if(sOperateType == null) sOperateType = "";
 	if(sChannelSerialNo==null || "".equals(sChannelSerialNo)) 
 	 	sChannelSerialNo = (String)session.getAttribute("repaymentChannelSerialNo");
 	if(sChannelSerialNo == null) sChannelSerialNo = "";
	if(sSerialNo==null) sSerialNo = "";
	if(sfromContractView == null) sfromContractView = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RepaymentChannelDetailList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(!"".equals(sSerialNo)){
		doTemp.WhereClause= " WHERE SERIALNO='"+sSerialNo+"'";
	}else{
		doTemp.WhereClause= " WHERE 1=2";
	}
	
	if(!sfromContractView.equals("")){
		doTemp.setReadOnly("BANKNAME,MOBILEBANK,ONLINEBANK,COUNTERTRANSFER,SELFTRANSFER", true);
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
	if(!"".equals(sOperateType)){
		sButtons[0][0] = "false";
	}
	if(!"".equals(sfromContractView)){
		sButtons[0][0] = "false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
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
		var sfromContractView ="<%=sfromContractView%>";
		if("" ==sfromContractView){
			AsControl.OpenView("/CustomService/BusinessConsult/RepaymentChannelDetails.jsp","SerialNo=<%=sChannelSerialNo %>","_self");
		}else{
			AsControl.OpenView("/BusinessManage/QueryManage/BusinessChannelList.jsp","SerialNo=<%=sChannelSerialNo %>","_self");
		}
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"CHANNELSERIALNO","<%=sChannelSerialNo%>");
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	/*~[Describe=弹出行政规划选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode()
	{
			
		var retVal = setObjectValue("SelectCityCodeMulti","","",0,0,"");
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
			var sSerialNo = getSerialNo("REPAYMENT_CHANNEL_LIST","SERIALNO");// 获取流水号
			setItemValue(0,getRow(),"SERIALNO",sSerialNo);
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
			// temp set the defautl value is 02   01-Customer, 02-Car
			bIsInsert = true;
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
