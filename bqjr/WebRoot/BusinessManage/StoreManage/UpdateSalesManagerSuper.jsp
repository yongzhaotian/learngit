<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "���۾���ת��";

	// ���ҳ�����
	/*String sCity =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("City"));
	String oldSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNO"));
	String oldSalesManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("oldSalesManager"));
	if(oldSalesManager == null) oldSalesManager = "";
	if(sCity == null) sCity = "";
	if(oldSNO == null) oldSNO = "";*/
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "UpdateSalesManagerSuper";//ģ�ͱ��
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

/*~[Describe=������ѡ��ѡ��ԭ���о���;InputParam=��;OutPutParam=��;]~*/
	function selectSalesmanSingle1() {
		var sRetVal = setObjectValue("SelectCityManager", "", "", 0, 0, "");
		
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			return;
		}
	
		setItemValue(0, 0, "CITYMANAGERFROM", sRetVal.split("@")[0]);
		setItemValue(0, 0, "CITYMANAGERFROMNAME", sRetVal.split("@")[1]);
		return;
	}
	
	/*~[Describe=������ѡ��ѡ���³��о���;InputParam=��;OutPutParam=��;]~*/
	function selectSalesmanSingle2() {
		var sRetVal = setObjectValue("SelectCityManager", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			return;
		}
	
		setItemValue(0, 0, "CITYMANAGERTO", sRetVal.split("@")[0]);
		setItemValue(0, 0, "CITYMANAGERTONAME", sRetVal.split("@")[1]);
		return;
	}
	
	/*~[Describe=������ѡ��ѡ�����۾���;InputParam=��;OutPutParam=��;]~*/
	function selectSalesManager(){
		var sCITYMANAGERFROM = getItemValue(0,getRow(),"CITYMANAGERFROM");	
		if (typeof(sCITYMANAGERFROM)=="undefined" || sCITYMANAGERFROM.length==0) {
			alert("����ѡ��һ�����о���");
			return;
		}
		var sRetVal = setObjectValue("SelectSalesManagerByCityManager", "superId ,"+ sCITYMANAGERFROM, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ��һ�����۾���");
			return;
		}
		setItemValue(0, 0, "SALESMANAGER", sRetVal.split("@")[0]);
		setItemValue(0, 0, "SALESMANAGERNAME", sRetVal.split("@")[1]);
	}
	
	function saveRecord(sPostEvents){
		var sret = datecheck();
		if (sret != 0) return;
		
		var salesManagers = getItemValue(0,getRow(),"SALESMANAGER");
		var cityManagerFrom = getItemValue(0,getRow(),"CITYMANAGERFROM");
		var cityManagerTo = getItemValue(0,getRow(),"CITYMANAGERTO");
		var moveDate = getItemValue(0,getRow(),"moveDate");
		
		if (typeof(salesManagers)=="undefined" || salesManagers.length==0) {
			alert("����ѡ��һ�����۾���");
			return;
		}
		
		if (typeof(cityManagerTo)=="undefined" || cityManagerTo.length==0) {
			alert("��ѡ��Ҫת�Ƶĳ����۾���");
			return;
		}
		var sParam = "salesManager="+cityManagerFrom+",newSalesManager="+cityManagerTo+",ewNo="+salesManagers+",moveDate="+moveDate+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
		
		
		var retResult = RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "updateCityManager", sParam);
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
