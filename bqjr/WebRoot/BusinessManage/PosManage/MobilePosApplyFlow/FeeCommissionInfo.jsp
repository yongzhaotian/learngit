<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "门店信息";

	// 获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sSerialNoS =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNoS"));
	
	String BusinessDate=SystemConfig.getBusinessDate();
	
	if (sSerialNo == null) sSerialNo = "";
	if (sSerialNoS == null) sSerialNoS = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "FeeCommissionsInfoForMobilePos";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	// 设置字段可见属性
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	doTemp.setHTMLStyle("COMSPSTARTDATE","onChange=\"javascript:parent.CheckStartDate()\"");
	doTemp.setHTMLStyle("COMSPENDDATE","onChange=\"javascript:parent.CheckEndDate()\"");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并返回","保存并返回列表","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	var bIsInsert = false; // 标记DW是否处于“新增状态”
	
	function selectProductCategory() {
		
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "",0,0,"dialogWidth:360px;dialogHeight:650px;resizable:yes;scrollbars:no;status:no;help:no");
		//alert(sRetVal);
		if (typeof(sRetVal)=='undefined' || sRetVal.length==0) {
			alert("请选择商品范畴！");
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
		setItemValue(0, 0, "PNO", sPNo.substring(0, sPNo.length-1));
		setItemValue(0, 0, "PNAME", sPName.substring(0, sPName.length-1));
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		if(!CheckStartDate()){
			return;
		}
		if(!CheckEndDate()){
			return;
		}
		
		var sBASEAMOUNT=getItemValue(0,getRow(),"BASEAMOUNT");
		var sSERVICERATIO=getItemValue(0,getRow(),"SERVICERATIO");
		var sFIXSERVICEAMOUNT=getItemValue(0,getRow(),"FIXSERVICEAMOUNT");
		var sCOMMISSIONRATIO=getItemValue(0,getRow(),"COMMISSIONRATIO");
		var sFIXCOMMISSIONAMOUNT=getItemValue(0,getRow(),"FIXCOMMISSIONAMOUNT");
		var sCOMSPSTARTDATE=getItemValue(0,getRow(),"COMSPSTARTDATE");
		var sCOMSPENDDATE=getItemValue(0,getRow(),"COMSPENDDATE");
		var sSERIALNO="";
		var sSERIALNOS="<%=sSerialNoS %>";
		sSERIALNOS=sSERIALNOS.split(",");
		//alert(sSERIALNOS);
		
		for(var i=0;i<sSERIALNOS.length;i++){
		sSERIALNO=sSERIALNOS[i];
		//RunMethod("ProductManage","UpdateCommission","BASEAMOUNT="+sBASEAMOUNT+",SERVICERATIO="+sSERVICERATIO+",FIXSERVICEAMOUNT="+sFIXSERVICEAMOUNT+",COMMISSIONRATIO="+sCOMMISSIONRATIO+",FIXCOMMISSIONAMOUNT="+sFIXCOMMISSIONAMOUNT+",COMSPSTARTDATE="+sCOMSPSTARTDATE+",COMSPENDDATE="+sCOMSPENDDATE+",SERIALNO="+sSERIALNO);
		RunMethod("ProductManage","UpdateCommissionForMobilePos",sBASEAMOUNT+","+sSERVICERATIO+","+sFIXSERVICEAMOUNT+","+sCOMMISSIONRATIO+","+sFIXCOMMISSIONAMOUNT+","+sCOMSPSTARTDATE+","+sCOMSPENDDATE+","+sSERIALNO);
		
		}
		//alert("保存成功！");
		//sSERIALNO=sSERIALNOS[sSERIALNOS.length-1];
		//alert(sSERIALNO);
		as_save("myiframe0",sPostEvents);
		
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/ProductList.jsp", "", "_self","");
		self.close();
		//parent.parent.reloadSelf();
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	//检查佣金的起始日期
	function CheckStartDate(){
		var sCOMSPSTARTDATE=getItemValue(0,getRow(),"COMSPSTARTDATE");
		
		if("<%=BusinessDate%>">sCOMSPSTARTDATE){
			alert("佣金起始日期不能小于当前系统日期！");
			setItemValue(0,getRow(),"sCOMSPSTARTDATE","");
			return false;
		}
		return true;
	}
	
	//检查佣金的结束日期
	function CheckEndDate(){
		var sCOMSPSTARTDATE=getItemValue(0,getRow(),"COMSPSTARTDATE");
		var sCOMSPENDDATE=getItemValue(0,getRow(),"COMSPENDDATE");
		if (typeof(sCOMSPSTARTDATE)=="undefined" || sCOMSPSTARTDATE.length==0){
			alert("佣金起始日期不能为空！");
			setItemValue(0,getRow(),"COMSPENDDATE","");
			return false;
		}
		if(sCOMSPSTARTDATE>sCOMSPENDDATE){
			alert("佣金结束日期不能小于佣金起始日期！");
			setItemValue(0,getRow(),"COMSPENDDATE","");
			return false;
		}
		return true;
	}
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
	}
	
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
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
