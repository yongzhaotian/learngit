<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "�ֹ�ƥ��";

	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	
	String sBusinessDate = SystemConfig.getBusinessDate();

	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "BankLinkFileList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setReadOnly("", true); 
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	/* function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		
		as_save("myiframe0",sPostEvents);
	} */
	
	function saveRecord(sPostEvents){
		if(!vI_all("myiframe0")) return;
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	function getCustomerID(){
		var returnValue = setObjectValue("SelectCustomerID","","",0,0,"");
		sCustomerID=returnValue.split("@")[0];
		if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			setItemValue(0, 0, "CUSTOMERID", "");
			return;
		}
		setItemValue(0, 0, "CUSTOMERID", sCustomerID);
		setItemValue(0,0,"MATCHINGFLAG","3");
		setItemValue(0, 0, "UPDATEORGID", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=sBusinessDate%>");
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		
		setItemValue(0, 0, "UPDATEORGID", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSERID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=sBusinessDate%>");
	}
	
	function deleteRecord(){
		var Serialno = getItemValue(0,getRow(),"serialno");
		if (typeof(Serialno)=="undefined" || Serialno.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}

	function viewAndEdit(){
		var Serialno = getItemValue(0,getRow(),"serialno");
		if (typeof(Serialno)=="undefined" || Serialno.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/WithholdDetailsInfo.jsp","SerialNo="+Serialno,"_self","");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
