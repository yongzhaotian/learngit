<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   hxli  2005.7.28
		Tester:
		Content: �������Ԥ����Ϣ_List
		Input Param:
			                AlertType��Ԥ������
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������Ԥ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sAlertType;
	String sTreatmentStatus;
	
	//����������	
	sAlertType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertType"));
	sTreatmentStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TreatmentStatus"));
	if(sAlertType==null) sAlertType="";
	if(sTreatmentStatus==null) sTreatmentStatus="";
	
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {
		{"ObjectName","��ʾ��ض���"},
		{"AlertTypeName","��ʾ����"},
		{"AlertTip","��ʾ����"},
		{"OccurDate","��������"},
		{"Remark","��ע"},
		{"InputUserName","�Ǽ���"},
		{"InputTime","�Ǽ�ʱ��"},
		};
		
	sSql =  " select SerialNo,ObjectType,ObjectNo,GetObjectName(ObjectType,ObjectNo) as ObjectName,"+
			" AlertType,GetItemName('AlertSignal',AlertType) as AlertTypeName,AlertTip,AlertDescribe,"+
			" OccurDate,OccurTime,UserID,OrgID,OccurReason,Treatment,EndTime,Remark,"+
			" GetUserName(InputUser) as InputUserName,InputUser,InputOrg,InputTime,UpdateTime"+
			" from ALERT_LOG where 1=1";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.multiSelectionEnabled=true;
	doTemp.UpdateTable="ALERT_LOG";
	//���ùؼ���
	doTemp.setKey("SerialNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,ObjectType,AlertType,AlertDescribe,UserID,OrgID,OccurReason,OccurTime,Treatment,EndTime,Remark,InputUser,InputOrg,UpdateTime",false);
	//���ø�ʽ
	doTemp.setHTMLStyle("ObjectName","style={width:200px}");
	doTemp.setHTMLStyle("AlertTip","style={width:250px}");
	//���ù�����
	doTemp.setColumnAttribute("AlertTip,InputUserName,ObjectName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));


	if(sTreatmentStatus.equals("Undistributed")){
		doTemp.WhereClause+=" and UserID is null";
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause +=" and InputUser='"+CurUser.getUserID()+"'";
	}else if(sTreatmentStatus.equals("Unfinished")){
		doTemp.WhereClause+=" and OrgID='"+CurUser.getOrgID()+"' and EndTime is null";
	}else if(sTreatmentStatus.equals("Finished")){
		doTemp.WhereClause+=" and (UserID='"+CurUser.getUserID()+"' or InputUser='"+CurUser.getUserID()+"')  and EndTime is not null";
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause +=" and 1=2";
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAlertType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
		{"false","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"false","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"false","","Button","ԭʼ���","�鿴��ص�ҵ�����","openWithObjectViewer()",sResourcesPath},
		{"false","","Button","�ַ�","�ַ���ѡ�еļ�¼","distribute()",sResourcesPath},
		{"false","","Button","����","���ٴ������","follow()",sResourcesPath},
		{"false","","Button","��ɴ���","��ɴ���","finish()",sResourcesPath},
		};

		if(sTreatmentStatus.equals("Undistributed")) {
			sButtons[0][0] = "true";
			sButtons[1][0] = "true";
			sButtons[2][0] = "true";
			sButtons[3][0] = "true";
		}else if(sTreatmentStatus.equals("Unfinished")){
			sButtons[1][0] = "true";
			sButtons[3][0] = "true";
			sButtons[4][0] = "true";
			sButtons[5][0] = "true";
			sButtons[6][0] = "true";
		}else{
			sButtons[1][0] = "true";
			sButtons[3][0] = "true";
			sButtons[5][0] = "true";
		}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		popComp("NewAlert","/CreditManage/CreditAlarm/AlertInfo.jsp","");
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")) 
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sAlertID=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sAlertID)=="undefined" || sAlertID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		popComp("AlertInfo","/CreditManage/CreditAlarm/AlertInfo.jsp","AlertID="+sAlertID,"","");
		reloadSelf();
	}
	
	
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function openWithObjectViewer()
	{
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectType)=="undefined" || sObjectType.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		//alert(sObjectType+"."+sObjectNo);
		openObject(sObjectType,sObjectNo,"001");
	}
	
	function distribute(){
		var sAlertIDs = getItemValueArray(0,"SerialNo");
		var sAlertIDString="";
		for(i=0;i<sAlertIDs.length;i++){
			sAlertIDString += "@" + sAlertIDs[i];
		}
		if (sAlertIDString=="")
		{
			alert("��˫����ѡ����ѡ��һ�����ϼ�¼��");
			return;
		}
		sReturn=popComp("AlertDistribute","/CreditManage/CreditAlarm/AlertDistributeVSFrame.jsp","AlertIDString="+sAlertIDString,"");

		reloadSelf();
	}
	function finish(){
		sAlertID=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sAlertID)=="undefined" || sAlertID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		popComp("AlertFinishInfo","/CreditManage/CreditAlarm/AlertFinishInfo.jsp","AlertID="+sAlertID,"","");
		reloadSelf();
	}
	
	function follow(){
		sAlertID=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sAlertID)=="undefined" || sAlertID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		popComp("AlertHandleList","/CreditManage/CreditAlarm/AlertHandleList.jsp","AlertID="+sAlertID,"","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
<%
    if(!doTemp.haveReceivedFilterCriteria()) {
%>
	showFilterArea();
<%
	}	
%>

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
