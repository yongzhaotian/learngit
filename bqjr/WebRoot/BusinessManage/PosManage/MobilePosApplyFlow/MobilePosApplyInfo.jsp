<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	//����������	���������͡��������͡��׶����͡����̱�š��׶α�š�������ʽ����������
	
	String sApplySerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplySerialNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
    
	
	if(sApplySerialNo == null) sApplySerialNo = "";	
	if(sObjectType == null) sObjectType = "MobilePosApply";	
	if(sApplyType == null) sApplyType = "MobilePosApply";
	if(sPhaseType == null) sPhaseType = "1010";	
	if(sFlowNo == null) sFlowNo = "MobilePosApplyFlow";
	if(sPhaseNo == null) sPhaseNo = "";
	
   String sSql = "";
   String sStatusCode = "";
	ASResultSet rs = null;//-- ��Ž����
	sSql = "select Status as StatusCode  from MOBILEPOS_INFO where ApplySerialNo=:ApplySerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ApplySerialNo",sApplySerialNo));
	if(rs.next()){
		sStatusCode = rs.getString("StatusCode");
     }
	rs.getStatement().close();
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "MobilePosApplyInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if((sStatusCode.equals("02"))||(sStatusCode.equals("03"))||(sStatusCode.equals("04"))){
		doTemp.setReadOnly("", true);
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//���ñ���ʱ�����������ݱ�Ķ���
	//dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+","+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.orgID+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sApplySerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	

	String sButtons[][] = {
		{((sStatusCode.equals("02"))||(sStatusCode.equals("03"))||(sStatusCode.equals("04")))?"false":"true","","Button","ȷ��","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		var sRetVal = setObjectValue("SelectCityCodeSingle", "", "", 0, 0, "");
		
		if (typeof(sRetVal)=='undefined' || sRetVal=='__CLEAR__' || sRetVal.length==0) {
			alert("��ѡ����У�");
			return;
		}
		setItemValue(0, 0, "CITY", sRetVal.split("@")[0]);
		setItemValue(0, 0, "CITYNAME", sRetVal.split("@")[1]);
		
	}
	
	
	
	
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		var sObjectNo = getItemValue(0, 0, "SerialNo");
		
		var sUserId = getItemValue(0, 0, "USERID");//��ȡ��ǰ������û����	
		
		/**
		 * add_CCS-958��PRM-516 �ƶ�POS��ĸĽ��Ż�_tangyb_20150806_start
		 * 1.���ƶ�POS�������У�ϵͳ�Զ�ʶ��ͬһ���ŵ겻����ͬһʱ���ͬʱ���������ƶ�POS�㡣
		 */
		var applyserialno = getItemValue(0, 0, "ApplySerialNo");//������ˮ��
		var retaivestoreno = getItemValue(0, 0, "RetaiveStoreNo");//�����ŵ�
		var starttime = getItemValue(0, 0, "StartTime");//��ʼʱ��	
		var endtime = getItemValue(0, 0, "EndTime");//����ʱ��
		
		//alert("starttime="+starttime+",endtime="+endtime+",retaivestoreno="+retaivestoreno+",applyserialno="+applyserialno);
		
		if (starttime != '' && endtime != '') {
			var sdate = starttime.split('/'); //�õ���ʱ��ؼ���ʽ��yyyy/MM/dd
			var edate = endtime.split('/');
			//��Ϊ��ǰʱ����·���Ҫ+1�����ڴ�-1����Ȼ�͵�ǰʱ�����Ƚϻ��жϴ���
			var start = new Date(sdate[0], sdate[1] - 1, sdate[2]); 
			var end = new Date(edate[0], edate[1] - 1, edate[2]);
			var date = new Date();//��ǰʱ��
			if (end <= date) {
				alert("�������ڱ�����ڵ�ǰ����");
				return;
			}
			if (start >= end) {
				alert("�������ڱ�����ڿ�ʼ���� ");
				return;
			}
		}
		
		//��ѯ�ŵ��Ƿ���ͬһʱ���ͬʱ�������ƶ�POS��
		var args = "starttime="+starttime+",endtime="+endtime+",retaivestoreno="+retaivestoreno+",applyserialno="+applyserialno;
		var isRepeat = RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMobilePosNo", "checkStorePosApp", args);
		
		if(isRepeat == "1"){
			alert("ͬһ���ŵ겻����ͬһʱ���ͬʱ�������������ƶ�POS�㡣");
			return;
		}
		/*-- end --*/
		
		as_save("myiframe0",sPostEvents);
		UpdatePosNo(sObjectNo);//����POS����

	}
	<%/*~[Describe=���������pos����;]~*/%>
	function UpdatePosNo(sObjectNo){
		var PosNo = RunMethod("���÷���","GetColValue","MobilePos_Info,MOBLIEPOSNO,SerialNo='"+sObjectNo+"'");
		if(PosNo.length==0||PosNo==""){
			RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMobilePosNo","UpdatePosNo","SerialNo="+sObjectNo);
		}
		
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		//AsControl.OpenView("/BusinessManage/CollectionManage/SalesManList.jsp","","_self");
		top.close();
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		
		var sEmpNo = getItemValue(0, 0, "SerialNo");
		RunMethod("WorkFlowEngine","InitializeFlow","<%=sObjectType%>"+","+sEmpNo+","+"<%=sApplyType%>"+","+"<%=sFlowNo%>"+","+"<%=sPhaseNo%>"+","+"<%=CurUser.getUserID()%>"+","+"<%=CurOrg.orgID%>");		
		
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UPDATEORG", "");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	function getStoreReatil(){
		var sRetVal = setObjectValue("SelectApprovedStore", "UserID,<%=CurUser.getUserID()%>", "", 0, 0);
	
		if (typeof(sRetVal)=='undefined'||sRetVal=='_CLEAR_') {
			alert("��ѡ������ŵ꣡");
			return;
		}
	//	alert(sRetVal);
		//SerialNo@RSerialNo@Sname@Address@City@SalesManagerName@SalesManPhone@CityManager
		setItemValue(0, 0, "RetaiveStoreNo", sRetVal.split("@")[0]);
		//setItemValue(0, 0, "RSerialNo", sRetVal.split("@")[1]);
		var sRname = RunMethod("���÷���", "GetColValue", "retail_info,rname,serialno='"+sRetVal.split("@")[1]+"'");
		setItemValue(0, 0, "RSerialNo", sRname);
		setItemValue(0, 0, "SName", sRetVal.split("@")[2]);
		setItemValue(0, 0, "StoreAddress", sRetVal.split("@")[3]);
		setItemValue(0, 0, "StoreCity", sRetVal.split("@")[4]);
		setItemValue(0, 0, "City", sRetVal.split("@")[4]);
		setItemValue(0, 0, "SalesManagerName", sRetVal.split("@")[5]);
		setItemValue(0, 0, "SalesManPhone", sRetVal.split("@")[6]);
		setItemValue(0, 0, "CityManager", sRetVal.split("@")[7]);
       //setItemValue(0, 0, "CityManagerName", sRetVal.split("@")[7]);
		
		setItemValue(0, 0, "CityName", sRetVal.split("@")[8]);
		setItemValue(0, 0, "StoreCityName", sRetVal.split("@")[8]);
		
		
		
		
	}
	function initRow(){
		var sRetativeStoreNo=getItemValue(0,0,"RetaiveStoreNo");
		//alert(sRetativeStoreNo);
		var sRetVal=RunMethod("BusinessManage","SelectStoreInfoForMobilePos",sRetativeStoreNo);
		
		/* setItemValue(0, 0, "RSerialNo", sRetVal.split("@")[1]); */
		var sRname = RunMethod("���÷���", "GetColValue", "retail_info,rname,serialno='"+sRetVal.split("@")[1]+"'");
		setItemValue(0, 0, "RSerialNo", sRname);
		setItemValue(0, 0, "SName", sRetVal.split("@")[2]);
		setItemValue(0, 0, "StoreAddress", sRetVal.split("@")[3]);
		setItemValue(0, 0, "StoreCity", sRetVal.split("@")[4]);
		setItemValue(0, 0, "City", sRetVal.split("@")[4]);
		//setItemValue(0, 0, "SalesManagerName", sRetVal.split("@")[5]);
		setItemValue(0, 0, "SalesManPhone", sRetVal.split("@")[6]);
		//setItemValue(0, 0, "CityManager", sRetVal.split("@")[7]);
		setItemValue(0, 0, "CityName", sRetVal.split("@")[8]);
		setItemValue(0, 0, "StoreCityName", sRetVal.split("@")[8]);
		
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var ApplySerialNo=getSerialNo("MOBILEPOS_INFO","ApplySerialNo","");
			var sSerialNo="POS"+ApplySerialNo;
			setItemValue(0, 0, "ApplySerialNo", ApplySerialNo);
			setItemValue(0, 0, "Status", "01");
			setItemValue(0, 0, "SerialNo", sSerialNo);
			setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "PermitType", "03");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
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
