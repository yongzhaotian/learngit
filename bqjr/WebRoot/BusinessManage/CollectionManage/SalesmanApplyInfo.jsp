<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	//����������	���������͡��������͡��׶����͡����̱�š��׶α�š�������ʽ����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sEmpNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EmpNo"));
	
	if(sObjectType == null) sObjectType = "SalesmanApply";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "1010";	
	if(sFlowNo == null) sFlowNo = "SalesmanApplyFlow";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sEmpNo==null) sEmpNo="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "SalesManInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//���ñ���ʱ�����������ݱ�Ķ���
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#USERID,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.orgID+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sEmpNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	

	String sButtons[][] = {
		{"true","","Button","ȷ��","���������޸�","saveRecord()",sResourcesPath},
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
	
	function getEmpNo(obj){
		
		var sEmpNo = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getEmpNo", "tableName=USER_INFO,colName=USERID,empType="+obj.value);
		
		setItemValue(0, 0, "USERID", sEmpNo);
		setItemValue(0, 0, "LOGINID", sEmpNo);
		//alert(sEmpNo);
	}
	
	function checkEmail() {
		
		var bEmail = CheckEMail(getItemValue(0, 0, "EMAIL"));
		if (!bEmail) {
			alert("��������ȷ�ĵ������䣡");
			return;
		}
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		
		var sEmpNo = getItemValue(0, 0, "EMPNO");
		
		RunMethod("WorkFlowEngine","InitializeFlow","<%=sObjectType%>"+","+sEmpNo+","+"<%=sApplyType%>"+","+"<%=sFlowNo%>"+","+"<%=sPhaseNo%>"+","+"<%=CurUser.getUserID()%>"+","+"<%=CurOrg.orgID%>");		
		var sUserId = getItemValue(0, 0, "USERID");//��ȡ��ǰ������û����
		//alert(sUserId);
		var sReturn=RunMethod("���÷���", "selectUser",sUserId);
		//alert(sReturn);
		if(sReturn==0){
		as_save("myiframe0",sPostEvents);
		}else{
			alert("�û�����ظ����޷����棡");
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
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UPDATEORG", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0,getRow(),"EMPNO","<%=sEmpNo %>");
			setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "INPUTORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
			
			setItemValue(0, 0, "UPDATEORG", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "UPDATEORGNAME", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
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
