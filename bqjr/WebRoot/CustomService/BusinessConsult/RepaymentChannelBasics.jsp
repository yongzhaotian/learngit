<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "������������";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sLoanNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
	String sOperateType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateType")); 
	if(sSerialNo==null || "".equals(sSerialNo)) sSerialNo = "";
	if(sOperateType == null) sOperateType ="";
	String sTypeCode = "RepaymentChannel";
	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RepaymentChannelInfoNew";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","����","���������޸�","saveRecord(saveSerailNo())",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"false","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
	if(!"".equals(sOperateType)){
		sButtons[0][0] = "false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	var existCityValue = "" ; //�Ѿ����ڳ���
	
	function checkExistCityChannel(){
		var sBigValue = getItemValue(0, 0, "BIGVALUE");
		var sSerialNo = getItemValue(0,0,"SERIALNO");
		if(""== sBigValue) return false;
		sReturn = RunMethod("PublicMethod","GetColValue","BIGVALUENAME,BaseDataSet_Info,String@BigValue@"+sBigValue+"@String@TypeCode@RepaymentChannel");
		sReturnNo = RunMethod("PublicMethod","GetColValue","SERIALNO,BaseDataSet_Info,String@BigValue@"+sBigValue+"@String@TypeCode@RepaymentChannel");
		if(bIsInsert){//����
			if("" == sReturn) return false;
			return true;
		}else{//�޸�
			if("" == sReturn) return false;
			return !(sReturnNo.indexOf(sSerialNo)>=0);
		}
	}
	
	function saveRecord(sPostEvents){
		if(checkExistCityChannel()){
			alert("�ó��еĻ��������Ѵ��ڣ�");
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

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		existCityValue = getItemValue(0, 0, "BIGVALUENAME");	
		var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//alert(retVal+"|"+typeof(retVal));
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ����Ҫѡ��ĳ��У�");
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
		setItemValue(0, 0, "BIGVALUE", sCityNos);    //�޸�Ϊ  wlq 
		setItemValue(0, 0, "BIGVALUENAME", sCityNames);
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
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
			setSessionValue("repaymentChannelSerialNo",sSerialNo);//����ˮ�ű��浽session
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
