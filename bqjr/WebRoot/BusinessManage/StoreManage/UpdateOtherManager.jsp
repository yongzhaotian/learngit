<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "����ת��";

	// ���ҳ�����
	String sCity =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("City"));
	String oldSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNO"));
	String oldSalesManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("oldSalesManager"));
	if(oldSalesManager == null) oldSalesManager = "";
	if(sCity == null) sCity = "";
	if(oldSNO == null) oldSNO = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "UpdateOtherManagerInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȷ��","ȷ��","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ�� ","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

/*~[Describe=������ѡ��ѡ��������Ա;InputParam=��;OutPutParam=��;]~*/
	function selectSalesmanSingle1() {
		sCity="<%=sCity%>";
		var sRetVal = setObjectValue("SelectSalesmanSingleByCity", "City,"+ sCity, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			return;
		}
	
		setItemValue(0, 0, "SALESMANAGER", sRetVal.split("@")[0]);
		setItemValue(0, 0, "SALESMANAGERNAME", sRetVal.split("@")[1]);
		return;
	}
	
	function selectSNO(){
		var sSalesManager = getItemValue(0,getRow(),"SALESMANAGER");	
		if (typeof(sSalesManager)=="undefined" || sSalesManager.length==0) {
			alert("����ѡ��һ�����۾���");
			return;
		}
		var sRetVal = setObjectValue("SelectStoreManager", "salesmanager ,"+ sSalesManager, "@SNOName@2", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ��һ���ŵ꣡");
			return;
		}
		setItemValue(0, 0, "SNO", sRetVal.split("@")[1]);
	}
	
	function saveRecord(sPostEvents){
		var newSNO = getItemValue(0,getRow(),"SNO");
		var sSalesManager = getItemValue(0,getRow(),"SALESMANAGER");
		if (typeof(newSNO)=="undefined" || newSNO.length==0) {
			alert("����ѡ��һ���ŵ꣡");
			return;
		}
		
		sCompID = "ShowOldSalesMan";
		sCompURL = "/BusinessManage/StoreManage/ShowOldSalesMan.jsp";
	    popComp(sCompID,sCompURL,"OldSNO=<%=oldSNO%>&NewSNO="+newSNO+"&oldSalesManager=<%=oldSalesManager%>&newSalesManager="+sSalesManager,"dialogWidth=800px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		self.close();
	}
	
	function saveAndGoBack(){
		self.close();
	}
	
	function goBack(){
		
		//AsControl.OpenView("/BusinessManage/StoreManage/StoreList.jsp", "", "_self","");
		top.close();
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
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
