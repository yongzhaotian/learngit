<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "����������ҳ��";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	if(sTemp==null) sTemp="";
	if(sSerialNo==null) sSerialNo="";
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "LoanManInfo1";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = null;
	if(sTemp.equals("modify")){
		vTemp=dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	}else{
		vTemp=dwTemp.genHTMLDataWindow("");
	}
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
	if(sTemp.equals("modify")){
		sButtons[2][0]="false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	 function getRegionCode(){
		 var sRetVal = setObjectValue("SelectCityCodeSingle", "", "", 0, 0, "");
			
			if (typeof(sRetVal)=='undefined' || sRetVal=='__CLEAR__' || sRetVal.length==0) {
				alert("��ѡ����У�");
				return;
			}
			setItemValue(0, 0, "city", sRetVal.split("@")[0]);
			setItemValue(0, 0, "cityName", sRetVal.split("@")[1]);
    }
	
	 function getRegionCode1()
		{
			var retVal = setObjectValue("SelectCityCodeMulti","","",0,0,"");
			if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
				alert("��ѡ����Ҫѡ��ĳ��У�");
				return;
			}
			var cityItems = retVal.split("~");
			var sCityNos = "";
			var sCityName = "";
			for (var i in cityItems) {
				sCityNos += cityItems[i].split("@")[0]+",";
				sCityName+=cityItems[i].split("@")[1]+",";
			}
			sCityNos = sCityNos.substring(0,sCityNos.length-1);
			setItemValue(0, 0, "province", sCityNos);
			setItemValue(0, 0, "provinceName", sCityName);
		}
	 
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
		AsControl.OpenView("/CustomerManage/CooperationCustomerManage/LoanManList1.jsp","","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UPDATEORG", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sSerialNo = getSerialNo("Service_Providers","serialNo");// ��ȡ��ˮ��
			setItemValue(0,getRow(),"serialNo",sSerialNo);
			setItemValue(0,getRow(),"CreditAttribute","0001");
			setItemValue(0,getRow(),"customerType1","06");
			setItemValue(0, 0, "inputOrgID", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"inputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"inputDate","<%=StringFunction.getToday()%>");

			setItemValue(0, 0, "updateOrgID", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "updateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"updateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"updateDate","<%=StringFunction.getToday()%>");
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
