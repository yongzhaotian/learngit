<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		ҳ��˵�������ڻ��������б�
	*/
	String PG_TITLE = "���ڻ��������б�";
    
    //ͨ��DWģ�Ͳ���ASDataObject����doTemp
    String sTempletNo = "ApplyBOMTRList";//ģ�ͱ��
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    doTemp.generateFilters(Sqlca);
    doTemp.parseFilterData(request, iPostChange);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
    //�������ݴ��ڶ���
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    dwTemp.Style ="1";//����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "1";//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(10);
    
    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow(CurUser.getUserID());
    for(int i = 0;i < vTemp.size();i++){
    	out.print((String)vTemp.get(i));
    }
    
    String sButtons[][] = {
    		{"true", "", "Button", "���ڻ�������", "���ڻ�������", "addApply()", sResourcesPath},
    		{"true", "", "Button", "�������������", "�������������", "changeApply()", sResourcesPath},
    		{"true", "", "Button", "����", "����", "detailsApply()", sResourcesPath},
    		{"true", "", "Button", "ȡ������", "ȡ������", "cancel()", sResourcesPath}
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
			alert("��ȡ���������쳣��");
			return;
		}
		if (curPayDate == null || curPayDate == "") {
			alert("��ȡ��������쳣��");
			return;
		}
		if (leftTime == null || leftTime == "") {
			alert("��ȡʣ������쳣��");
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
			alert("��ȡ���������쳣��");
			return;
		}
		if (curPayDate == null || curPayDate == "") {
			alert("��ȡ��������쳣��");
			return;
		}
		if (leftTime == null || leftTime == "") {
			alert("��ȡʣ������쳣��");
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
			alert("��ѡ��һ����¼��");
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
			alert("��ѡ��һ����¼��");
			return;
		}
		if (serialNO == null || serialNO == "") {
			alert("��ѡ��һ����¼��");
			return;
		}
	
	if (status == "��ȡ��"){
		alert("�����ظ�ȡ����");
		return;
	}else if (status == "���ύ"){
		if(confirm("ȷ����Ҫȡ����")){
			params = "customerId=" + customerId + ", serialNo=" + serialNO + ", alterType=" + alter_type 
					+ ", UpdateUserid =<%=CurUser.getUserID() %>";
			var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BOMTRApply", "cancelApproval", params);
			alert(result.split("@")[1]);
			reloadSelf();
			}
	}else if (status == "��ִ��"){
		alert("��������ִ�У�������ȡ����");
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