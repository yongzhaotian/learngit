<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sViewId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NoteType"));
	
	if (sCustomerID == null) sCustomerID = "";
	if(sSerialNo==null) sSerialNo="";
	if(sViewId==null) sViewId="";
	
	if ("002".equals(sViewId)) CurPage.setAttribute("RightType", "ReadOnly");
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "SocialInfoQueryInfo";//ģ�ͱ��
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
	
	// fixme ֻ�ܲ鿴������Ϣ
	//if ("002".equals(sViewId)) sButtons[2][0] = "false";
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		var sRetVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//alert(retVal+"|"+typeof(retVal));
		if (typeof(sRetVal)=="undefined" || sRetVal=='_CLEAR_') {
			setItemValue(0, 0, "City", "");
			setItemValue(0, 0, "CityName", "");
			return;
		}
		sAreaCodeInfo = sRetVal.split('@');
		sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
		sAreaCodeName = sAreaCodeInfo[1];//--������������
		setItemValue(0, 0, "City", sAreaCodeValue);
		setItemValue(0, 0, "CityName", sAreaCodeName);
		
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
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/SocialInfoQueryList.jsp","","_self");
		//OpenComp("ObjectViewer","/Frame/ObjectViewer.jsp","ObjectType=Customer&ObjectNo=<%=sCustomerID%>&ViewID=002","_parent","");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			
			if ("<%=sViewId%>"!="002") {
				as_add("myiframe0");
				var sSerialNo = getSerialNo("SocialInfoQuery","SerialNo");// ��ȡ��ˮ��
				setItemValue(0, 0, "SerialNo", sSerialNo);
			}
			setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

			setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "UpdateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
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
