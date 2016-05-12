<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "示例详情页面";

	//获得组件参数	：对象编号、对象类型、申请类型、阶段类型、流程编号、阶段编号、发生方式、发生日期
	String sEmpNo=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EmpNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
    
	if(sObjectType == null) sObjectType = "ForceBalanceApply";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "1010";	
	if(sFlowNo == null) sFlowNo = "ForceBalanceApplyFlow";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sEmpNo==null) sEmpNo="";

	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ForceBalanceInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; // 设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(15); //分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	
	String sButtons[][] = {
		{"true","","Button","确认","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	function initRow()
	{
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0,0,"USERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"ORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			}
	}
	
	function saveRecord(){
		  
		   var sTableName = "FORCECANCEL";//表名
		   var sColumnName = "SERIALNO";//字段名
		   var sPrefix = "";//前缀
								
		   //获取流水号
	        var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		    var sObjectNo=getItemValue(0,getRow(),"PutoutNo");
			var sCustomerID=getItemValue(0, getRow(), "CustomerID");
			var sCustomerName=getItemValue(0,getRow(),"CustomerName");
			var sBusinessName=getItemValue(0,getRow(),"BUSINESSNAME");
			var sBusinessSum=getItemValue(0,getRow(),"BusinessSum");
			var sPayinteAmt=getItemValue(0,getRow(),"PayinteAmt");
			var sCPDDays=getItemValue(0,getRow(),"CPDDays");
			var sContractStatus=getItemValue(0,getRow(),"ContractStatus");
			var sSex=getItemValue(0,getRow(),"sex");
			var sCity=getItemValue(0,getRow(),"city");
			var sSalesExecutive=getItemValue(0,getRow(),"salesexecutive");
			var sStores=getItemValue(0,getRow(),"stores");
			var sInputDate="<%=StringFunction.getToday()%>";
		    RunMethod("WorkFlowEngine","InitializeFlow","<%=sObjectType%>,"+sObjectNo+",<%=sApplyType%>,<%=sFlowNo%>,<%=sPhaseNo%>,<%=CurUser.getUserID()%>,<%=CurOrg.orgID%>");
		    RunMethod("ForceCancel","InsertForceCancel",sSerialNo+","+sObjectNo+","+sCustomerID+","+sCustomerName+","+sBusinessName+","+sBusinessSum+","+sPayinteAmt+","+sCPDDays+","+sContractStatus+","+sSex+","+sCity+","+sSalesExecutive+","+sStores+","+sInputDate);
		    top.close();
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