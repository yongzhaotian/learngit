<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sTypeCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeCode"));
	if (sSerialNo == null) sSerialNo="";
	if (sTypeCode == null) sTypeCode="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AreaCodeInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	// ���ø�����������
	doTemp.setDDDWSql("Attr3", "select UserId,UserName from User_Info where UserId in (select UserId from user_role where roleId='"+CommonConstans.AREA_MANAGER+"')");
	if (!"".equals(sSerialNo)) doTemp.setReadOnly("Attr1", true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
	};
	
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	var sRawUserId = "";
	
	function saveRecord(sPostEvents){
	
		// ����������Ƿ����
		if ("<%=sSerialNo%>" == "") {
			var sAreadSerialNo = RunMethod("���÷���", "GetColValue", "BaseDataset_Info,SerialNo,TypeCode='AreaCode' and Attr1='"+getItemValue(0, 0, "Attr1")+"'");
			if ("Null" != sAreadSerialNo) {
				alert("���������Ѿ����ڣ����������룡");
				return;
			}
		}
		
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
		// �������������Ա�ϼ���ԭ���������Ա�ϼ�
		var sCurUserId = getItemValue(0, 0, "Attr3");
		var sAreaNo = getItemValue(0, 0, "Attr1");

		if (sCurUserId!=null && sCurUserId) {
			RunJavaMethodSqlca("com.amarsoft.app.billions.RegionCommanManager", "updateAreaSuper", "roleId=<%=CommonConstans.CEO_MANAGER%>,userId="+sCurUserId+",rawUserId="+sRawUserId+",areaNo="+getItemValue(0, 0, "Attr1"));
		}
		
		// �ж��Ƿ�����û�
		if (sRawUserId!=null && sCurUserId!=null && sRawUserId && sCurUserId && (sCurUserId!=sRawUserId)) {
			RunMethod("���÷���", "updateProvinceSuper", sCurUserId+","+sAreaNo);
		}
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionAreaList.jsp","","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateOrg","<%=CurOrg.orgID %>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID() %>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sSerialNo = getSerialNo("Basedataset_Info","SerialNo");// ��ȡ��ˮ��
			setItemValue(0,getRow(),"SerialNo",sSerialNo);
			setItemValue(0, 0, "TypeCode", "<%=sTypeCode %>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.orgID %>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
			setItemValue(0,0,"UpdateOrg","<%=CurOrg.orgID %>");
			setItemValue(0,0,"UpdateOrgName","<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
		
		sRawUserId = getItemValue(0, 0, "Attr3");
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
