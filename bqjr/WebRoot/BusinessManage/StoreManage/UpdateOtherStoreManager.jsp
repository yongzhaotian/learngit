<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%

	/*
		Author:  
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 2015/06/05 CCS-863 �ŵ겿��ת��ʱ���۾�����һ�Զ�У�飬�����У��
	*/

	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "�ŵ겿��ת��";

	// ���ҳ�����
	String sCity =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("City"));
	String oldSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNO"));
	String oldSalesManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("oldSalesManager"));
	if(oldSalesManager == null) oldSalesManager = "";
	if(sCity == null) sCity = "";
	if(oldSNO == null) oldSNO = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "UpdateOtherManagerInfo1";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//doTemp.setCheckFormat("REMOVEDATE", "3");
	
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



/*~[Describe=��Ч����Ҫ���ڵ��ڽ���;InputParam=��;OutPutParam=��;]~*/
	function datecheck() {
		
		var sMoveDate = getItemValue(0, 0, "moveDate");
		sMoveDate = sMoveDate.split("/");//�õ���ʱ��ؼ���ʽ��yyyy/MM/dd
		//var sEndTime = getItemValue(0, 0, "endDate");
		//��Ϊ��ǰʱ����·���Ҫ+1�����ڴ�-1����Ȼ�͵�ǰʱ�����Ƚϻ��жϴ���
		var MoveDate = new Date(sMoveDate[0], sMoveDate[1] - 1, sMoveDate[2]);
		var now = new Date();//��ǰʱ��
		if (MoveDate < now && !( sMoveDate[0] == now.getFullYear() && sMoveDate[1] == (now.getMonth() + 1) && sMoveDate[2] == now.getDate() )) {
			alert("��Ч�ձ�����ڵ��ڽ��죡");
			return 1;
		}
		return 0;
	}

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
	
	function selectSalesmanSingle2() {
		sCity="<%=sCity%>";
		var sRetVal = setObjectValue("SelectSalesmanSingleByCity", "City,"+ sCity, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			return;
		}
	
		setItemValue(0, 0, "SALESMANAGER1", sRetVal.split("@")[0]);
		setItemValue(0, 0, "SALESMANAGERNAME1", sRetVal.split("@")[1]);
		return;
	}
	
	function selectSNO(){
		var sSalesManager = getItemValue(0,getRow(),"SALESMANAGER");	
		if (typeof(sSalesManager)=="undefined" || sSalesManager.length==0) {
			alert("����ѡ��һ�����۾���");
			return;
		}
		var sRetVal = setObjectValue("SelectStoreManager1", "salesmanager ,"+ sSalesManager, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ��һ���ŵ꣡");
			return;
		}
		setItemValue(0, 0, "SNO", sRetVal);
		setItemValue(0, 0, "SNOName", sRetVal);
	}
	
	function saveRecord(sPostEvents){
		var sret = datecheck();
		if (sret != 0) return;
		
		var newSNO = getItemValue(0,getRow(),"SNO");
		var salesManager = getItemValue(0,getRow(),"SALESMANAGER");
		var newSalesManager = getItemValue(0,getRow(),"SALESMANAGER1");
		var moveDate = getItemValue(0,getRow(),"moveDate");
		
		
		if (typeof(newSNO)=="undefined" || newSNO.length==0) {
			alert("����ѡ��һ���ŵ꣡");
			return;
		}
		if (typeof(newSalesManager)=="undefined" || newSalesManager.length==0) {
			alert("��ѡ��Ҫת�Ƶ����۾���");
			return;
		}
		var sParam = "salesManager="+salesManager+",newSalesManager="+newSalesManager+",ewNo="+newSNO+",moveDate="+moveDate+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
		
		var snoArr = newSNO.split("@");
		var whereClause = "(SR.SNO = '";
		for( var i=0,len=snoArr.length ; i<len ; i++ ){
			whereClause += snoArr[i];
			if( i < len - 2 ){
				whereClause += "' OR SR.SNO = '";
			}
		}
		whereClause += "')";
		whereClause += " and SR.stype is null ";	//����ѡ�ŵ�󶨵�������Ա
		
		var sales = RunMethod("GetElement","GetElementValue","wm_concat(distinct SR.Salesmanno),storerelativesalesman SR,"+whereClause);
		sales = sales.split(",");
		var Salesmanno = "(SR.Salesmanno = '";
		for( var i=0,len=sales.length ; i<len ; i++ ){
			Salesmanno += sales[i];
			if( i < len - 1 ){
				Salesmanno += "' OR SR.Salesmanno = '";
			}
		}
		Salesmanno += "')";
		Salesmanno += " and SR.stype is null ";	//��������Ա�󶨵��ŵ��
		var snoArr = RunMethod("GetElement","GetElementValue"," wm_concat(SR.sno),storerelativesalesman SR,"+Salesmanno);
		snoArr = snoArr.split(",");
		for( var i=0,len=snoArr.length ; i<len ; i++ ){
			if( newSNO.indexOf(snoArr[i]) == -1 ){
				alert("���Ƚ���ŵ�");
				return;
			}
		}
		
		// add by xswang 2015/06/05 CCS-863 �ŵ겿��ת��ʱ���۾�����һ�Զ�У�飬�����У��
		//��������Ա�󶨵����۾���������ѡ�ŵ�ģ�		
		var snoArr2 = newSNO.split("@");
		var whereClause1 = "(SR.SNO <> '";
		for( var i=0,len=snoArr2.length ; i<len ; i++ ){
			whereClause1 += snoArr2[i];
			if( i < len - 2 ){
				whereClause1 += "' and SR.SNO <> '";
			}
		}
		whereClause1 += "')";
		whereClause1 += " and SR.stype is null ";
		
		var snoArr1 = RunMethod("GetElement","GetElementValue","salemanagerno,storerelativesalesman SR,"+Salesmanno+" and "+whereClause1 );
		if(snoArr1 != "Null" && snoArr1 != "" && snoArr1 != " "){
			snoArr1 = snoArr1.split(",");
			for( var i=0,len=snoArr1.length ; i<len ; i++ ){
				if(newSalesManager.indexOf(snoArr1[i]) == -1){
					if(salesManager != newSalesManager){
						alert("�����۴����������ŵ��Ѱ����۾�������ת��!");
						return;
					}
				}
			}
		}
		// end by xswang 2015/06/05
		
//		RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "updateAllManager2", sParam);
		var retResult = RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "updateAllManager1", sParam);
		if(retResult=="SUCESS"){
			alert("ת�Ƴɹ���");
		}
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