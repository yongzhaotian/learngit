<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   bwang
		Tester:
		Content: ���õȼ�����������Ϣ
		Input Param:
		
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ���������"; // ��������ڱ��� <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
    String sTempletNo = "CRApplyCreateDialog";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	doTemp.setReadOnly("CustomerName,OccurType,RefModelName,FSReport",true);
	
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
		{"true","","Button","ȷ��","ȷ�������ͻ���������","saveRecord()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ�������ͻ���������","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		if(bIsInsert){
			initSerialNo();
		}
		as_save("myiframe0","doReturn()");
	}
		
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		//ѡ��ͻ�
		var sCustomerID = "";
		var sParaString = "UserID"+","+"<%=CurUser.getUserID()%>";
		var sReturn = setObjectValue("SelectCustomerBelong01",sParaString,"@CustomerID@0@CustomerName@1@CustomerType@2",0,0,"");
		if(typeof(sReturn)=="undefined" || sReturn.length==0||sReturn=="_CANCEL_")return;
		sCustomerID = getItemValue(0,0,"CustomerID");
		//�жϸÿͻ��Ƿ����ݴ���ʽ
		var sTempSaveFlag = RunMethod("CustomerRatingTool","GetTempSaveFlag",sCustomerID);
		if(sTempSaveFlag =="1"){
			setItemValue(0,0,"CustomerID","");
			setItemValue(0,0,"CustomerName","");
			setItemValue(0,0,"CustomerType","");
			alert("�ÿͻ���Ϣ�洢��ʽΪ�ݴ棬���ܷ���������");
			return;
		}
		setItemValue(0,0,"CustomerID",sCustomerID);
		//����ѡ��Ŀͻ����ÿͻ������Ʊ�
		addFinanceType();	
		//ȷ���ͻ������������͡�
		var sResult = RunMethod("CustomerRatingTool","JudgeCROccurType",sCustomerID);
		if(typeof(sResult)=="undefined" || sResult.length==0)return;
		setItemValue(0,0,"OccurTypeID",sResult);
		
		if(sResult == "010")
			setItemValue(0,0,"OccurType","��������");
		else 
			setItemValue(0,0,"OccurType","��������");
	}

	/*~��������ģ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectModel(){
		var sCustomerID = getItemValue(0,0,"CustomerID");
		if(typeof(sCustomerID)== "undefined" || sCustomerID.length==0){
			alert("����ѡ���û���");
			return;
		}
		var sReturn = RunMethod("CustomerRatingTool","GetRatingModelCondition",sCustomerID);
		if(typeof(sReturn)=="undefined"|| sReturn==""){
			alert("��ÿͻ�����ģ���б����");
			return;
		}
		sReturn = sReturn.split("@");
		var alertInform  = "";
		if(sReturn[0] =="NONE") alertInform += "�������";
		if(sReturn[1]=="NONE") alertInform += " ��ҵ��ģ";
		if(sReturn[2]=="NONE") alertInform += " ����ʱ��";
		
		if(alertInform != ""){
			alert("�ÿͻ���"+alertInform+"����Ϣ������,�����ƺ��ٽ�������");
			return;
		}else{
			var paramString = "Attribute1"+","+sReturn[0]+","+"Attribute2"+","+sReturn[1]+","+"Attribute3"+","+sReturn[2];
			setObjectValue("selectRuleModel", paramString, "@RefModelID@0@RefModelName@1");
		}
	}
	
	/*~[Describe=ȷ��;InputParam=��;OutPutParam=��;]~*/
	function doReturn()
	{
		var sRatingAppID = getItemValue(0,getRow(),"RatingAppID");
		var sModelID = getItemValue(0,getRow(),"RefModelID");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sReportDate = getItemValue(0,getRow(),"ReportDate");
		var sReportScope = getItemValue(0,getRow(),"ReportScope");
		var sReportPeriod = getItemValue(0,getRow(),"ReportPeriod");
		var sAuditFlag = getItemValue(0,getRow(),"AuditFlag");
		var sUserID = "<%=CurUser.getUserID()%>";
		var sOrgID = "<%=CurOrg.getOrgID()%>";
		var param = sCustomerID+","+sReportDate+","+sReportScope+","+sReportPeriod+","+sAuditFlag;
		//����������������
		RunMethod("CustomerRatingTool","LockFSRecord",param);
		self.returnValue = sRatingAppID+"@"+sModelID+"@"+sCustomerID;
		self.close();
    }
    
    /*~[Describe=ȡ��;InputParam=��;OutPutParam=��;]~*/
    function doCancel(){		
			top.close();
	}
    
	/*~[Describe=�����񱨱���Ϣ;InputParam=��;OutPutParam=��;]~*/
	function addFinanceType(){		
		var sCustomerID = getItemValue(0,0,"CustomerID");
		if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
			alert("����ѡ��ͻ���");
			return;
		}
		var sReturn = RunMethod("CustomerRatingTool","AddFinanceType",sCustomerID);
		if(typeof(sReturn)=="undefined"||sReturn.length==0){
			alert("��ò��񱨱����");
			return;
		}else if(sReturn=="NOSETUPDATE"){
			alert("�뱣֤�ͻ��Ĺ�����࣬��ҵ��ģ������ʱ�����Ϣ����¼���ٽ���������");
			return;
		}else if(sReturn=="NOREPORT"){
			alert("�ÿͻ�û�п��õı�����¼����Ӧ�ı�����������");
			return;
		}
		
		sReturn = sReturn.split("@");
		setItemValue(0,0,"ReportDate",sReturn[0]);
		setItemValue(0,0,"ReportPeriod",sReturn[1]);
		setItemValue(0,0,"ReportScope",sReturn[2]);
		setItemValue(0,0,"AuditFlag",sReturn[3]);

		var period ="";
		if(sReturn[1]=="01")period="�±�";
		else if(sReturn[1]=="02")period="����";
		else if(sReturn[1]=="03") period="���걨";
		else if(sReturn[1]=="04") period="�걨";
		var scope="";
		if(sReturn[2]=="01")scope="����";
		else if(sReturn[2]=="02")scope="�ϲ�";
		else if(sReturn[2]=="03")scope="����";
		
		sFSReport = "�ڴ�:"+sReturn[0]+" ����:"+period+" �ھ�:"+scope;
		setItemValue(0,0,"FSReport",sFSReport);
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼
			setItemValue(0,0,"RatingPerion","<%=StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)%>"); 
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"LaunchUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"LaunchOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"RatingType","10");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");	
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
		
    }

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "Rating_Apply";//����
		var sColumnName = "RatingAppID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,0,"RatingAppID",sSerialNo);
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();	
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��	
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>