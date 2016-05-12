<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%
	String PG_TITLE = "�˻���Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String businessType = "";
	String projectVersion = "";
	
	//���ҳ�����
	String SerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String sStatus = DataConvert.toRealString(iPostChange,CurPage.getParameter("Status"));
	String sAccountIndicator = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("AccountIndicator")));
	String right=DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("RightType")));
	if(SerialNo == null) SerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sStatus == null) sStatus = "";
	
	BusinessObject bo = AbstractBusinessObjectManager.getBusinessObject(sObjectType,sObjectNo,Sqlca);
	
	//��ʾģ����
	String sTempletNo = "DepositAccountsInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	if("00".equals(sAccountIndicator) || "01".equals(sAccountIndicator) || !"".equals(SerialNo))
		doTemp.setReadOnly("AccountIndicator",true);
	else if("99".equals(sAccountIndicator))
		doTemp.setDDDWSql("AccountIndicator","select itemno,itemname from code_library where codeno = 'AccountIndicator' and itemno in('02','03','04')");
	
	if("00".equals(sAccountIndicator) || "99".equals(sAccountIndicator) || !"".equals(SerialNo)){
		doTemp.setVisible("PRI",false);
		doTemp.setDefaultValue("PRI","1");
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2"; //����DW��� 1:Grid 2:Freeform
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		dwTemp.ReadOnly = "1";
	}else{
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(SerialNo);
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	

	String sButtons[][] = {
			{"true", "", "Button", "����", "����һ����Ϣ","saveRecord()",sResourcesPath},
			{"true", "", "Button", "����", "����","goBack()",sResourcesPath},
	};
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		sButtons[0][1]="false";
	}
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>

<script language=javascript>
	var coreCheckFlag = false;
	//����
	function saveRecord(){
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();
		//�˻����� ���Ϊ�ſ��˻���Ϊ������Ա������Ϊ�����˻�������ֻ�ܱ���һ���ٴγ������ܱ���
		var accountIndicator = getItemValue(0,getRow(),"AccountIndicator");
		var status = getItemValue(0,getRow(),"Status");
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		/* if("01"==accountIndicator){
			as_save("myiframe0","goBack();");
		}else{
			
		}*/	
		sReturn = RunMethod("PublicMethod","DistinctAccount","<%=sObjectNo%>,<%=bo.getObjectType()%>,"+accountIndicator+","+serialNo);
		if(sReturn>=1){
			alert("���˻������Ѵ���");
			return;
		}else
			as_save("myiframe0","goBack();");
	}
	//����
	function goBack(){
		OpenPage("/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp?Status=<%=sStatus%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self","");
	}
	
	/*~[Describe=ִ����������ǰ��ʼ����ˮ��;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "ACCT_DEPOSIT_ACCOUNTS";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺	
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ObjectType","<%=bo.getObjectType()%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Status","0");
			bIsInsert = true;
			
			if("<%=sAccountIndicator%>" == "00")
				setItemValue(0,0,"AccountIndicator","00");
			else if("<%=sAccountIndicator%>" == "01")
				setItemValue(0,0,"AccountIndicator","01");
		}else{
			bIsInsert = false;
		}
	}
	//�ı��˻�������������ѡ��ĸı�
	function changeAccountIndicator(){
		var sResult = getItemValue(0,getRow(),"AccountIndicator");
		if("00"==sResult){
			setItemDisabled(0,getRow(),"PRI",false);
			return;
		}else{
			setItemValue(0,0,"PRI","1");
			setItemDisabled(0,getRow(),"PRI",true);
			return;
		}
	}
		
</script>

<script language=javascript>
	//��ʼ��
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>