<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "������������";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sLoanNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
	if(sSerialNo==null) sSerialNo="";
	if(sLoanNo==null) sLoanNo = "";
	String sTypeCode = "RepaymentChannel";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RepaymentChannelInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	
	/*~[Describe=�ж������ձ�����ڿ�ʼ����;InputParam=��;OutPutParam=��;]~*/
	function dateCompare() {
		
		var sStartTime = getItemValue(0, 0, "ATTR2");
		var sEndTime = getItemValue(0, 0, "ATTR3");
		
		if (sEndTime.localeCompare(sStartTime)<=0) {
			alert("��Ч�ڵ����ձ��������ʼ���ڣ�");
			return 1;
		}
		return 0;
	}
	
	function saveRecord(sPostEvents){
		
		// �ֶκϷ��Լ��
		var sret = dateCompare();
		if (sret != 0) return;
		
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
		AsControl.OpenView("/BusinessManage/CollectionManage/RepaymentChannelList.jsp","LoanNo=<%=sLoanNo %>","_self");
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
			
		var retVal = setObjectValue("SelectCityCodeMulti","","",0,0,"");
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
			var sSerialNo = getSerialNo("BaseDataSet_Info","SERIALNO");// ��ȡ��ˮ��
			setItemValue(0,getRow(),"SERIALNO",sSerialNo);
			setItemValue(0, 0, "TYPECODE", "<%=sTypeCode %>");
			setItemValue(0, 0, "ATTRSTR1", "<%=sLoanNo %>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

			setItemValue(0, 0, "TYPECODE", "<%=sTypeCode %>");
			
			// temp set the defautl value is 02   01-Customer, 02-Car
			setItemValue(0, 0, "IDENTIFICATION", "02");
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
