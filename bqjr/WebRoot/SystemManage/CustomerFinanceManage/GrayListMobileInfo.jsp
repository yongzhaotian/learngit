<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: �ֻ��������������ҳ�� */
	String PG_TITLE = "�ֻ��������������ҳ��";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SERIALNO"));
	System.out.println(sSerialNo+"-------------------------------");
	if(sSerialNo==null) sSerialNo="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "GrayListMobile";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if("".equals(sSerialNo)) {
		doTemp.WhereClause+=" and 1=2";
	}else {
		doTemp.WhereClause+=(" and SERIALNO='" + sSerialNo + "'");
	}
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
	function saveRecord(sPostEvents){
		var sPHONE=getItemValue(0,0,"PHONE");
		var sSERIALNO=getItemValue(0,0,"SERIALNO");
		//if (typeof(sPHONE)!="undefined" && sPHONE.length!=0){
			var sCnt=RunMethod("GrayList_MODEL","checkMulti","GrayListMobile,PHONE,"+sPHONE+","+sSERIALNO);
			if(sCnt>0){
				alert("�б��������ظ����ֻ������¼,����������");
				setItemValue(0,0,"PHONE","");
				return;
			}
		//}
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
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/GrayListMobile.jsp","","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
		setItemValue(0, 0, "INPUTORGNAME", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
	    setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UPDATEORG", "<%=CurOrg.orgID %>");
		setItemValue(0, 0, "UPDATEORGNAME", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sSerialNo = "<%=DBKeyUtils.getSerialNo()%>";// ��ȡ��ˮ��
			setItemValue(0,getRow(),"SERIALNO",sSerialNo);
			setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "INPUTORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");

			setItemValue(0, 0, "UPDATEORG", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "UPDATEORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
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
