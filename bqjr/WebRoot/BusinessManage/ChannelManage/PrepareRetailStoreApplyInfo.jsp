<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   tbzeng 2014/03/30
		Tester:
		Content: �������Ŷ������
		Input Param:
			ObjectType����������
			ApplyType����������
			PhaseType���׶�����
			FlowNo�����̺�
			PhaseNo���׶κ�		
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ŷ���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));

	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "RetailStoreApply";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "RetailStoreApplyFlow";
	if(sPhaseNo == null) sPhaseNo = "0010";
	
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "RetailStoreApplyInfo";
	
	//����ģ�����������ݶ���	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//���ñ��䱳��ɫ
	//doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//���ͻ����ͷ����ı�ʱ��ϵͳ�Զ������¼�����Ϣ
	//doTemp.appendHTMLStyle("CustomerType"," onClick=\"javascript:parent.clearData()\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//���ñ���ʱ�����������ݱ�Ķ���
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SERIALNO,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.orgID+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","ȷ��","ȷ���������Ŷ������","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ���������Ŷ������","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	
	function getPassedReatil() {
		var sRetVal = setObjectValue("SelectPermitRetailSingle", "", "", 0, 0);
		
		if (typeof(sRetVal)=='undefined'||sRetVal=='_CLEAR_') {
			alert("��ѡ�������̣�");
			return;
		}
		
		setItemValue(0, 0, "RSERIALNO", sRetVal.split("@")[0]);
		setItemValue(0, 0, "RNO", sRetVal.split("@")[1]);
		setItemValue(0, 0, "RNAME", sRetVal.split("@")[2]);
		setItemValue(0, 0, "RNAME1", sRetVal.split("@")[2]);
		setItemValue(0, 0, "RSSerialNo", sRetVal.split("@")[3]);
		
		
	}

	/*~[Describe=�����ֶοɼ���;InputParam=�����¼�;OutPutParam=��;]~*/
	function setRetialStoreField() {
		var sPermitType = getItemValue(0, 0, "PERMITTYPE");
		// ObjectNo,RetailName,OrgCode
		if (sPermitType=="01") {
			hideItem(0, 0, "RNO");
			hideItem(0, 0, "RNAME1");
			showItem(0, 0, "RNAME");
			showItem(0, 0, "REGCODE");
			
			setItemValue(0, 0, "RNAME", "");
			setItemValue(0, 0, "REGCODE", "");
			
			setItemRequired(0, 0, "RNO", false);
			setItemRequired(0, 0, "RNAME1", false);
			setItemRequired(0, 0, "RNAME", true);
			setItemRequired(0, 0, "REGCODE", true);
			setItemRequired(0, 0, "RSERIALNO", true);
			// �˴���ʼ�����̻����к�
			setItemValue(0, 0, "RSERIALNO", getSerialNo("Retail_Info", "SerialNo", "R"));
			setItemValue(0,0,"REGCODE","R");
		} else if (sPermitType=="02") {
			
			hideItem(0, 0, "RNO");
			hideItem(0, 0, "RNAME");
			hideItem(0, 0, "REGCODE");
			hideItem(0, 0, "RNAME");
			showItem(0, 0, "RNAME1");
			
			setItemRequired(0, 0, "RSERIALNO", false);
			setItemRequired(0, 0, "RNO", false);
			setItemRequired(0, 0, "RNAME1", true);
			setItemRequired(0, 0, "REGCODE", false);
		} else {
			alert("��ѡ��׼�����ͣ�");
			return;
		}
		
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);
		RunMethod("���÷���", "RetailInfoInit", getItemValue(0, 0, "SERIALNO"));
	}
	
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel()
	{		
		top.returnValue = "";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		checkRegCode();
		saveRecord("doReturn()");
	}
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		var sObjectNo = getItemValue(0,0,"SERIALNO");
		top.returnValue = sObjectNo+"@"+getItemValue(0, 0, "PERMITTYPE")+"@"+getItemValue(0, 0, "RSERIALNO");
		top.close();
	}

	function checkRegCode(){
		var sRegCode=getItemValue(0,0,"REGCODE");
		var returnVal=RunMethod("���õȼ�����","��ѯ�̻�ע����Ƿ����",sRegCode);
		returnVal=parseFloat(returnVal);
		if( returnVal>0){
			alert("���̻�ע����Ѵ���");
			return;
		}
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼	
			var serialNo = getSerialNo("RetailStoreApply", "SerialNo");
			setItemValue(0, 0, "SERIALNO", serialNo);
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"REGCODE","R");
			
			
		}
		
		hideItem(0, 0, "RNO");
		hideItem(0, 0, "RNAME1");
		setItemRequired(0, 0, "RNAME", true);
		setItemRequired(0, 0, "RNAME1", false);
		setItemRequired(0, 0, "REGCODE", true);
		setItemRequired(0, 0, "RSERIALNO", true);
		// �˴���ʼ�����̻����к�
		setItemValue(0, 0, "RSERIALNO", getSerialNo("Retail_Info", "SerialNo", "R"));
    }
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>