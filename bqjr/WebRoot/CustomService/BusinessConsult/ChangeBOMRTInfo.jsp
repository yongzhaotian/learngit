<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
	ҳ��˵��: ���ڻ��������б�
	*/
	String PG_TITLE = "�������������";
	
	String serialNo = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("serialNO"))); //��ˮ��
	String contractNo = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("contractNO")));	// 
	String customerId = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("customerId")));	// 
	String customerName = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("customerName")));	// 
	String certId = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("certId")));	// 
	String certType = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("certType")));	// 
	String certTypeName = DataConvert.toString(DataConvert.toRealString(
			 	iPostChange, (String)CurPage.getParameter("certTypeName")));	//
	String applyTime = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("applyTime")));	//
	String curPayDate = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("curPayDate")));	//
	String leftTime = DataConvert.toString(DataConvert.toRealString(
				iPostChange, (String)CurPage.getParameter("leftTime")));	//
	String perIods = DataConvert.toString(DataConvert.toRealString(
			 	iPostChange, (String)CurPage.getParameter("perIods")));	//
			
	String btnShow[] = new String[2];
	if(serialNo == null || "".equals(serialNo)){
		serialNo = DBKeyUtils.getSerialNo();
		btnShow[0] = "true";
		btnShow[1] = "true";
	}else{
		btnShow[0] = "false";
		btnShow[1] = "false";
	}
%>
	
<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ChangeBOMTRInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo, Sqlca);
	doTemp.parseFilterData(request, iPostChange);
	CurPage.setAttribute("FilterHTML", doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2";   //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(serialNo);
	for(int i = 0; i < vTemp.size(); i++) {
		out.print((String)vTemp.get(i));
	}
	
	String sButtons[][] = {
		{btnShow[0], "", "Button", "�ύ", "����", "saveRecord()", sResourcesPath},
		{btnShow[1], "", "Button", "ȡ��", "ȡ��", "cancelRecord()", sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	function initRow() {
		if (getRowCount(0) == 0) { // ���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");
			setItemValue(0, 0, "ALTER_TYPE", "01");
			setItemValue(0, 0, "ALTER_VALUE", "");
			setItemValue(0, 0, "STATUS", "0");
			setItemValue(0, 0, "SERIALNO", "<%=serialNo %>");
			setItemValue(0, 0, "CONTRACTNO", "<%=contractNo %>");
			setItemValue(0, 0, "CUSTOMERID", "<%=customerId %>");
			setItemValue(0, 0, "CUSTOMERNAME", "<%=customerName %>");
			setItemValue(0, 0, "CUSTOMERID", "<%=customerId %>");
			setItemValue(0, 0, "CUSTOMERNAME", "<%=customerName %>");
			setItemValue(0, 0, "CERTID", "<%=certId %>");
			setItemValue(0, 0, "CERTTYPE_NAME", "<%=certTypeName %>");
			setItemValue(0, 0, "CERTTYPE", "<%=certType %>");
			setItemValue(0, 0, "APPLY_TIME", "<%=applyTime %>");
			setItemValue(0, 0, "CUR_PAYDATE", "<%=curPayDate == null || "null".equals(curPayDate) ? "" : curPayDate %>");
			setItemValue(0, 0, "LEFT_TIMES", "<%=leftTime %>");
			setItemValue(0, 0, "INPUT_USERID", "<%=CurUser.getUserID() %>");
			alterValueOnchange();
		} else {
			showOtherItem("contractNOBtn", "none");
			setItemDisabled(0, 0, "APPLY_REASON", true);
		}
		setItemRequired(0, 0, "PRE_APPLYTIME", false);
	}
	
	function alterValueOnchange() {

		var alterType = getItemValue("0", "0", "ALTER_TYPE");
		var alterValue = getItemValue("0", "0", "ALTER_VALUE");
		var curPayDate = getItemValue("0", "0", "CUR_PAYDATE");
		var applyTime = "<%=applyTime %>";
		if(alterType == null || alterType == ""){
			alert("��ѡ��������ͣ�");
			setItemOption("0", "0", "ALTER_PAYDATE", "");
			setItemValue("0", "0", "ALTER_PAYDATE", "");
			return;
		}
		if(alterValue == null || alterValue == ""){
			setItemOption("0", "0", "ALTER_PAYDATE", "");
			setItemValue("0", "0", "ALTER_PAYDATE", "");
			return;
		}
		if (curPayDate == null || curPayDate == "" || curPayDate == "null") {
			alert("��ȡ������ʼ������ڣ�");
			setItemOption("0", "0", "ALTER_PAYDATE", "");
			setItemValue("0", "0", "ALTER_PAYDATE", "");
			return;
		}
		var params = "alterType=" + alterType + ",alterValue=" + alterValue 
					+ ",curPayDate=" + curPayDate + ",applyTime=" + applyTime;
		var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BOMTRApplyCheck", 
								"queryAlterPayDate", params);		// У�鷵�ؽ��
		if (result.split("@")[0] == "false") {
			setItemValue(0, 0, "ALTER_VALUE", "");
			setItemOption("0", "0", "ALTER_PAYDATE", "");
			setItemValue("0", "0", "ALTER_PAYDATE", "");
			alert(result.split("@")[1]);
			return;
		} else {
			var opts = result.split("@")[1];
			setItemOption("0", "0", "ALTER_PAYDATE", opts);
			setItemValue("0", "0", "ALTER_PAYDATE", "");
		}
	}
	
	function saveRecord() {
		
		var curPayDate = "<%=curPayDate %>";
		if (curPayDate == null || curPayDate == "" || curPayDate == "null") {
			alert("��ȡ������ʼ������ڣ�");
			return;
		}
		var alterPayDate = getItemValue("0", "0", "ALTER_PAYDATE");
		if(alterPayDate == null || alterPayDate == ""){
			alert("����󻹿����ڲ���Ϊ�գ�");
			return;
		}
		var contractNo = getItemValue(0, 0, "CONTRACTNO");
		var alterType = getItemValue(0, 0, "ALTER_TYPE");
		var alterValue = getItemValue(0, 0, "ALTER_VALUE");
		var applyReason = getItemValue(0, 0, "APPLY_REASON");//����ԭ��
		var alterPayDate = getItemValue(0, 0, "ALTER_PAYDATE");
		var params = "contractNo=" + contractNo + ",alterType=" + alterType + ",alterValue=" + alterValue
					+ ",customerId=<%=customerId %>,customerName=<%=customerName %>"
					+ ",applyTime=<%=applyTime %>,curPayDate=" + curPayDate + ",inputUserId=<%=CurUser.getUserID() %>"
					+ ",inputDate=<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>,pt=<%=perIods %>,alterPayDate=" + alterPayDate;
		var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BOMTRApplyCheck", "applyCheck", params);		// У�鷵�ؽ��
		if (result.split("@")[0] == "false") {
			alert(result.split("@")[1]);
			return;
		}

		if (contractNo == null || contractNo == ""){
			alert("�������ͬ�ţ�");
			return;
		}
		if(alterType == null || alterType == ""){
			alert("��ѡ��������ͣ�");
			return;
		}
		if(alterValue == null || alterValue == ""){
			alert("��ѡ���������գ�");
			return;
		}
		var preApplyTime = result.split("@")[1];	// �ϴ�����ʱ��
		preApplyTime = preApplyTime == null || preApplyTime == "null" ? "" : preApplyTime; 
		var alterPayDate = getItemValue(0, 0, "ALTER_PAYDATE");	// �����Ļ�����
		var serialNO = getItemValue(0, 0, "SERIALNO");	// ��ˮ��
		var customerId = getItemValue(0, 0, "CUSTOMERID");	// �ͻ�ID
		var customerName = getItemValue(0, 0, "CUSTOMERNAME");	// �ͻ�����
		var certType = getItemValue(0, 0, "CERTTYPE");	// ֤������
		var certId = getItemValue(0, 0, "CERTID");	// ֤������
		
		if (serialNO == null || serialNO == "") {
			alert("��ȡ������ˮ�ţ�");
			return;
		}
		if (customerName == null || customerName == ""){
			alert("������ͻ�������");
			return;
		}
		if (certType == null || certType == "") {
			alert("��ȡ����֤�����ͣ�");
			return;
		}
		if (certId == null || certId == "") {
			alert("��ȡ����֤�����룡");
			return;
		}
		if (certId == null || certId == "") {
			alert("��ȡ�����״α���󻹿����ڣ�");
			return;
		}
		
		setItemValue(0, 0, "PRE_APPLYTIME", preApplyTime == null || preApplyTime == "null" ? "" : preApplyTime);
		params = "serialNo=" + serialNO + ", contractNO=" + contractNo + ", customerId=" + customerId 
				+ ", customerName=" + customerName + ", alterType=" + alterType + ", alterPaydate=" + alterPayDate 
				+ ", alterValue=" + alterValue + ", status=0" + ", applyReason=" + applyReason + ", curPaydate=" + curPayDate
				+ ", leftTimes=<%=leftTime %>" + ", preApplytime=" + preApplyTime + ", inputUserid=<%=CurUser.getUserID() %>" 
				+ ", updateUserid=<%=CurUser.getUserID() %>, certId=" + certId + ", certType=" + certType
				+ ", applyTime=<%=applyTime %>";
		// ������Ϣ
		if(confirm("һ���ύ���������ϲ������ü�¼���Ƿ��ύ��")){
			result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BOMTRApply", "submitApply", params);	
			if (result.split("@")[0] != "true") {
				alert(result.split("@")[1]);
				return;
			} else {
				alert("����ɹ���");
				return;
			}
		}
		
	}
	
	// ��ʾ/���ؿؼ�
	function showOtherItem(id, display) {
		window.frames["myiframe0"].document.getElementById(id).style.display = display;
	}
	
	
	function cancelRecord() {
		
		if (window.confirm("��ȷ��Ҫȡ����")) {
			window.close();
		}
	}
</script>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	bFreeFormMultiCol = true;
	my_load(2, 0, 'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>
