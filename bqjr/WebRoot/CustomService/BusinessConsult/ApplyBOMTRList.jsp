<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		页面说明：延期还款申请列表
	*/
	String PG_TITLE = "延期还款申请列表";
    
    //通过DW模型产生ASDataObject对象doTemp
    String sTempletNo = "ApplyBOMTRList";//模型编号
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request, iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //创建数据窗口对象
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    dwTemp.Style ="1";//设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1";//设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(10);
    
    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(CurUser.getUserID());
    for(int i = 0;i < vTemp.size();i++){
    	out.print((String)vTemp.get(i));
    }
    
    String sButtons[][] = {
    		{"true", "", "Button", "延期还款申请", "延期还款申请", "addApply()", sResourcesPath},
    		{"true", "", "Button", "变更还款日申请", "变更还款日申请", "changeApply()", sResourcesPath},
    		{"true", "", "Button", "详情", "详情", "detailsApply()", sResourcesPath},
    		{"true", "", "Button", "取消申请", "取消申请", "cancel()", sResourcesPath}
    	};
%>

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function addApply(){
		var params = "";
		var retVal = setObjectValue("selectContractNOForBOMTR", "", "", 0, 0,"");
		if (typeof retVal == "undefined" || retVal == "_CLEAR_") {
			return;
		}
		var contractNO = retVal.split("@")[0];
		var customerId = retVal.split("@")[1];
		var customerName = retVal.split("@")[2];
		var certId = retVal.split("@")[3];
		var certTypeName = retVal.split("@")[4];
		var certType = retVal.split("@")[5];
		params = "contractNo=" + contractNO;
		var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.QueryBOMTRInfo","queryBOMTRRelativeInfo",params);
		if (result.split("@")[0] == "false") {
			alert(result.split("@")[1]);
			return;
		}
		var applyTime = result.split("@")[1];
		var curPayDate = result.split("@")[2];
		var leftTime = result.split("@")[3];
		var perIods = result.split("@")[4];
		if (applyTime == null || applyTime == "") {
			alert("获取申请日期异常！");
			return;
		}
		if (curPayDate == null || curPayDate == "") {
			alert("获取变更日期异常！");
			return;
		}
		if (leftTime == null || leftTime == "") {
			alert("获取剩余次数异常！");
			return;
		}
		params = "contractNO=" + contractNO + "&customerId=" + customerId 
					+ "&customerName=" + customerName + "&certId=" + certId + "&certType=" + certType 
					+ "&certTypeName=" + certTypeName + "&applyTime=" + applyTime 
					+ "&curPayDate=" + curPayDate + "&leftTime=" + leftTime +"&perIods=" + perIods;
		var sURL = "/CustomService/BusinessConsult/DelayApplyBOMTRInfo.jsp";
		var sStyle = "dialogWidth=550px;dialogHeight=620px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
		popComp("DelayApplyBOMTRInfo", sURL, params, sStyle);
		reloadSelf();
	}
	
	
	function changeApply(){
		var params = "";
		var retVal = setObjectValue("selectContractNOForBOMTR", "", "", 0, 0,"");
		if (typeof retVal == "undefined" || retVal == "_CLEAR_") {
			return;
		}
		var contractNO = retVal.split("@")[0];
		var customerId = retVal.split("@")[1];
		var customerName = retVal.split("@")[2];
		var certId = retVal.split("@")[3];
		var certTypeName = retVal.split("@")[4];
		var certType = retVal.split("@")[5];
		params = "contractNo=" + contractNO;
		var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.QueryBOMTRInfo","queryBOMTRRelativeInfo",params);
		if (result.split("@")[0] == "false") {
			alert(result.split("@")[1]);
			return;
		}
		var applyTime = result.split("@")[1];
		var curPayDate = result.split("@")[2];
		var leftTime = result.split("@")[3];
		var perIods = result.split("@")[4];
		if (applyTime == null || applyTime == "") {
			alert("获取申请日期异常！");
			return;
		}
		if (curPayDate == null || curPayDate == "") {
			alert("获取变更日期异常！");
			return;
		}
		if (leftTime == null || leftTime == "") {
			alert("获取剩余次数异常！");
			return;
		}
		params = "contractNO=" + contractNO + "&customerId=" + customerId 
				+ "&customerName=" + customerName + "&certId=" + certId + "&certType=" + certType 
				+ "&certTypeName=" + certTypeName + "&applyTime=" + applyTime 
				+ "&curPayDate=" + curPayDate + "&leftTime=" + leftTime + "&perIods=" + perIods;
		var sURL = "/CustomService/BusinessConsult/ChangeBOMRTInfo.jsp";
		var sStyle = "dialogWidth=550px;dialogHeight=620px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
		popComp("DelayApplyBOMTRInfo", sURL, params, sStyle);
		reloadSelf();
	}
	
	function detailsApply() {
		
		var serialNO = getItemValue(0, getRow(), "SERIALNO");
		var alter_type = getItemValue(0, getRow(), "ALTER_TYPE_NONE");
		if (serialNO == null || serialNO == "") {
			alert("请选择一条记录！");
			return;
		}
		var sURL = "/CustomService/BusinessConsult/ApplyBOMTRInfo.jsp";
		var sStyle = "dialogWidth=550px;dialogHeight=620px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
		popComp("DelayApplyBOMTRInfo", sURL, "serialNO=" + serialNO, sStyle);
		reloadSelf();
	}
	
	function cancel(){
		var customerId = getItemValue(0, getRow(), "CUSTOMERID");
		var serialNO = getItemValue(0, getRow(), "SERIALNO");
		var alter_type = getItemValue(0, getRow(), "ALTER_TYPE_NONE");
		var status = getItemValue(0, getRow(), "STATUS");

		if (customerId == null || customerId == "") {
			alert("请选择一条记录！");
			return;
		}
		if (serialNO == null || serialNO == "") {
			alert("请选择一条记录！");
			return;
		}
	
	if (status == "已取消"){
		alert("请勿重复取消！");
		return;
	}else if (status == "已提交"){
		if(confirm("确认需要取消吗？")){
			params = "customerId=" + customerId + ", serialNo=" + serialNO + ", alterType=" + alter_type 
					+ ", UpdateUserid =<%=CurUser.getUserID() %>";
			var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BOMTRApply", "cancelApproval", params);
			alert(result.split("@")[1]);
			reloadSelf();
			}
	}else if (status == "已执行"){
		alert("该申请已执行，不允许取消！");
		return;
		}
	}
	

</script>
<script type="text/javascript">
$(document).ready(function(){
	AsOne.AsInit();
	init();
	my_load(2, 0, 'myiframe0');
});
</script>	
<%@ include file="/IncludeEnd.jsp"%>