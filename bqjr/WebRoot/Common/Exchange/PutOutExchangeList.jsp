<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   fxie  2005.01.21
		Tester:
		Content: ���ʽ����б�������
		Input Param:
			                sDealType:��ͼ��Ҷ����
		Output param:
		History Log: 
			fXie 2005-01-22    ���ʽ��״���
	 */
	%>
<%/*~END~*/%>
<%
	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	//��ȡ�������͡����̱�š��׶α�š������˴��롢��ɱ�־
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
	
	//����ʱʹ��
	sApproveType="PutOutApprove";
	//���Ա�־��0 ������ʾ������Ϣ 1����ʾ������Ϣ   
	String sDegbugFlag ="1" ; 
%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ʽ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	ASResultSet rs = null;
	String sTempletNo="PutOutExchangeList";
	String sWhereClause1="";
	String sWhereClause2="";
	
	if(sDealType.substring(0,3).equals("010")){
		sWhereClause1 = " and ExchangeState = '1' and ExchangeType not like 'A%'";
	}else if (sDealType.substring(0,3).equals("020")){
		sWhereClause1 = " and ExchangeState = '2' and ExchangeType not like 'A%'";
	}else if (sDealType.substring(0,3).equals("030")){
		sWhereClause1 = " and ExchangeState = '3' and ExchangeType not like 'A%'";
	}else if (sDealType.substring(0,3).equals("090")){
		sWhereClause1 = " and ExchangeState = '9' and ExchangeType not like 'A%'";
	}

	//ѡ���֧��
	if (sDealType.equals("010")||sDealType.equals("020")||sDealType.equals("030")) {
		sWhereClause2=" and (ExchangeType is not null and ExchangeType <> ' ' and ExchangeType <> '0000')";
	//չ��
	}else if (sDealType.equals("010010")||sDealType.equals("020010")||sDealType.equals("030010")){
		sWhereClause2=" and ExchangeType = '6201'";
	//��������֤
	}else if (sDealType.equals("010020")||sDealType.equals("020020")||sDealType.equals("030020")){
		sWhereClause2=" and ExchangeType = '6801'";
	//���гжһ�Ʊ
	}else if (sDealType.equals("010030")||sDealType.equals("020030")||sDealType.equals("030030")){
		sWhereClause2=" and ExchangeType = '8315'";
	//����	
	}else if (sDealType.equals("010040")||sDealType.equals("020040")||sDealType.equals("030040")){
		sWhereClause2=" and ExchangeType = '6501'";
	//һ�����
	}else if (sDealType.equals("010050")||sDealType.equals("020050")||sDealType.equals("030050")){
		sWhereClause2=" and ExchangeType = '6002'";
	//ί�д���
	}else if (sDealType.equals("010060")||sDealType.equals("020060")||sDealType.equals("030060")){
		sWhereClause2=" and ExchangeType = '6003'";
	//���Ŵ���
	}else if (sDealType.equals("010070")||sDealType.equals("020070")||sDealType.equals("030070")){
		sWhereClause2=" and ExchangeType = '6005'";
	//������Ѻ��
	}else if (sDealType.equals("010080")||sDealType.equals("020080")||sDealType.equals("030080")){
		sWhereClause2=" and ExchangeType = '6007'";
	//���Ҵ���
	}else if (sDealType.equals("010090")||sDealType.equals("020090")||sDealType.equals("030090")){
		sWhereClause2=" and ExchangeType = '2201'";
	//ѭ������Ǽ�
	}else if (sDealType.equals("010100")||sDealType.equals("020100")||sDealType.equals("030100")){
		sWhereClause2=" and ExchangeType = '6901'";
	}else{
		sWhereClause2="";
	}				
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    // ����ͨ��״̬���޶������
    doTemp.WhereClause += " and (FLOW_OBJECT.ObjectType||FLOW_OBJECT.ObjectNo) "+
						  " in (select ObjectType||ObjectNo from FLOW_TASK where UserID = '"+CurUser.getUserID()+"' and PhaseNo='0035')"+
						  " and FLOW_OBJECT.ApplyType='PutOutApply' "+
						  " and FLOW_OBJECT.FlowNo='PutOutFlow' "+
						  " and FLOW_OBJECT.PhaseNo in('1000','0040') "+sWhereClause1+sWhereClause2+
						  " Order by FLOW_OBJECT.ObjectNo Desc";
	
    //���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	doTemp.setHTMLStyle("SerialNo,BusinessTypeName,ArtificialNo"," style={width:120px}");
	doTemp.setHTMLStyle("ExchangeTypeName,ExchangeStateName"," style={width:60px}"); 
	doTemp.setHTMLStyle("CustomerName"," style={width:200px}"); 
	
	if (sDealType.equals("020020")||sDealType.equals("030020")||sDealType.equals("020040")||sDealType.equals("030040")||sDealType.equals("090020")||sDealType.equals("090040")){ 
		doTemp.setVisible("ArtificialNo",true); 
		doTemp.setVisible("DuebillSerialNo",true); 
	}else if (sDealType.equals("010030")||sDealType.equals("020030")||sDealType.equals("030030")||sDealType.equals("090030")){
		doTemp.setVisible("ArtificialNo",false); 
		doTemp.setVisible("DuebillSerialNo",false); 
		doTemp.setVisible("RenameArtificialNo",true); 
		if (sDealType.equals("010030")||sDealType.equals("090030")){
			doTemp.setVisible("RenameDuebillSerialNo",false); 
		}else{
			doTemp.setVisible("RenameDuebillSerialNo",true); 
		}			
	}else if (sDealType.equals("010020")||sDealType.equals("010040")){
		doTemp.setVisible("ArtificialNo",true); 
		doTemp.setVisible("DuebillSerialNo",false); 
	}else{
		doTemp.setVisible("ArtificialNo",false); 
		doTemp.setVisible("DuebillSerialNo",true); 
	}
	
	//���ö�ѡ��   
	doTemp.multiSelectionEnabled = true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    
	//����DataWindowչ�ַ��ͱ༭��ʽ
	dwTemp.Style="1";
	dwTemp.ReadOnly = "1";
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
		
		String sButtons[][] = {
								{"true","","Button","ȫѡ","ȫѡ","SelectedAll()",sResourcesPath},
								{"true","","Button","��ѡ","��ѡ","SelectedBack()",sResourcesPath},
								{"true","","Button","ȡ��ȫѡ","ȡ��ȫѡ","SelectedCancel()",sResourcesPath},
								{"true","","Button","�Ŵ�����","�鿴�Ŵ�����","viewTab()",sResourcesPath},
								{"true","","Button","�˻طŴ�������","�˻طŴ�������","back()",sResourcesPath},
								{"true","","Button","����","���׷���","TradeTransfer()",sResourcesPath},
								{"true","","Button","���·���","�������·���","TradeTransfer()",sResourcesPath},
								{"true","","Button","��������","Ĩ�ʽ���","TradeCancel()",sResourcesPath},
								{"true","","Button","�ſ�������뵥","�ſ�������뵥","PutOutBook()",sResourcesPath},
								{"false","","Button","�鵵","δ���ͽ��׹鵵","PigeonHole()",sResourcesPath},
								{"true","","Button","������־","�鿴������־","ViewLog()",sResourcesPath}
							  };
							  
	    if (sDealType.substring(0,3).equals("010")){
			sButtons[4][0] = "true";
			sButtons[5][0] = "true";
			sButtons[6][0] = "false";
			sButtons[7][0] = "false";
			sButtons[8][0] = "true";
			sButtons[9][0] = "true";
		}else if (sDealType.substring(0,3).equals("020")){
			sButtons[4][0] = "false";
			sButtons[5][0] = "false";
			sButtons[6][0] = "true";
			sButtons[7][0] = "true";
			sButtons[8][0] = "true";
		}else if (sDealType.substring(0,3).equals("090")){
			sButtons[4][0] = "false";
			sButtons[5][0] = "false";
			sButtons[6][0] = "false";
			sButtons[7][0] = "false";
			sButtons[8][0] = "true";
		}else{
			sButtons[4][0] = "false";
			sButtons[5][0] = "false";
			sButtons[6][0] = "false";
			sButtons[7][0] = "true";
			sButtons[8][0] = "true";
		}

		if (sDealType.equals("030030")){
			sButtons[9][0] = "true";
		}
	    if (sDealType.equals("010")){
			sButtons[4][0] = "false";
	    }
		
	%> 
<%/*~END~*/%>



<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

	/*~[Describe=�˻طŴ�������;InputParam=��;OutPutParam=��;]~*/
	function back()
	{
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sReturn = getItemValueArray(0,"SerialNo");
		if (sReturn.length==0){
			alert(getHtmlMessage('1'));
			return;
		}

		if(sBusinessType == "2010" || sBusinessType == "1090010")
		{
			if(confirm("�˻طŴ���������"))
			{
				sRelativePutOutNo = getItemValue(0,getRow(),"RelativePutOutNo");
				//alert(sRelativePutOutNo);
				PopPage("/Common/WorkFlow/DeleteAcceptBillAction.jsp?PutOutNo="+sRelativePutOutNo,"","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
				reloadSelf();
			}
		}else if(confirm("�˻طŴ���������")) 
		{
			for(var iMSR = 0; iMSR < getRowCount(0) ; iMSR++)
			{
				var a = getItemValue(0,iMSR,"MultiSelectionFlag");
				if(a == "��"){
					sReturn = getItemValue(0,iMSR,"SerialNo");
					PopPageAjax("/Common/WorkFlow/AutoSubmitActionAjax.jsp?ObjectType=PutOutApply&ObjectNo="+sReturn+"&FlowNo=PutOutFlow&PhaseNo=1000&PhaseAction=���ز�������","","");
				}
			}
			alert("�����ɹ�");
			reloadSelf();
		}
	}
	
	/*~[Describe=���׵��ʷ���ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function doSubmit(){
		var sReturn = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sReturn)=="undefined" || sReturn.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		if (confirm("ȷ��Ҫ���͸ñʽ�����")){
			PopPage("/Common/Exchange/PutOutExchangeAction.jsp?SerialNoArray="+sReturn+"&DegbugFlag=<%=sDegbugFlag%>","","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			reloadSelf();
		}
	}
	
	/*~[Describe=������������ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function TradeTransfer()
	{
		var sReturnArrary = getItemValueArray(0,"SerialNo");
		if (sReturnArrary.length==0){
			doSubmit();
			return;
		}
		
		var sMessage="";
		
		if (sReturnArrary.length>1){
			sMessage = "ȷ��Ҫ�������ʹ��ѡ��Ľ�����";
		}else{
			sMessage = "ȷ��Ҫ���ʹ��ѡ��Ľ�����";
		}
		
		if (confirm(sMessage)){
			PopPage("/Common/Exchange/PutOutExchangeAction.jsp?SerialNoArray="+sReturnArrary+"&DegbugFlag=<%=sDegbugFlag%>","","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			reloadSelf();
		}
	}
	
	/*~[Describe=����Ĩ�� ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function doCancle(){
		var sReturn = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sReturn)=="undefined" || sReturn.length==0){
			alert(getHtmlMessage('1'));
			return;
		}		
		
		if (confirm("ȷ��Ҫ�����ñʽ�����")){
			PopPage("/Common/Exchange/PutOutExchangeCancel.jsp?SerialNoArray="+sReturn+"&DegbugFlag=<%=sDegbugFlag%>","","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			reloadSelf();
		}	
	}
	
	/*~[Describe=����Ĩ�� ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function TradeCancel()
	{
		var sReturnArrary = getItemValueArray(0,"SerialNo");
		if (sReturnArrary.length==0){
			doCancle();
			return;
		}		
		
		if (sReturnArrary.length>1){
			sMessage = "ȷ��Ҫ�����������ѡ��Ľ�����";
		}else{
			sMessage = "ȷ��Ҫ�������ѡ��Ľ�����";
		}
		
		if (confirm(sMessage)){
			PopPage("/Common/Exchange/PutOutExchangeCancel.jsp?SerialNoArray="+sReturnArrary+"&DegbugFlag=<%=sDegbugFlag%>","","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			reloadSelf();
		}	
	}
	
	/*~[Describe=ȫѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedAll(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "��"){
				setItemValue(0,iMSR,"MultiSelectionFlag","��");
			}
		}
	}
	
	
	/*~[Describe=��ѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedBack(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "��"){
				setItemValue(0,iMSR,"MultiSelectionFlag","��");
			}else{
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}
	
	/*~[Describe=ȡ��ȫѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedCancel(){
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != ""){
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}
	
	/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function viewDetail()
	{
		sObjectType = "PutOutApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
	
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		openObject(sObjectType,sObjectNo,"001");
	}
	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "PutOutApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		sExchangeState = getItemValue(0,getRow(),"ExchangeState");
		if (sExchangeState != "1") {
			sParamString += "&ViewID=002"
		}
		
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=��ӡ����֪ͨ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function PutOutBook()
	{
		sObjectType = "CreditPutOut";
		sObjectNo = getItemValueArray(0,"SerialNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			sObjectNo = getItemValue(0,getRow(),"SerialNo");
			if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
			{
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}
		}

		sExchangeType = PopPage("/Common/WorkFlow/GetExchangeTypeAction.jsp?ObjectNo="+sObjectNo,"_self","dialogWidth=0;dialogHeight=0;minimize:yes");
		
		if(typeof(sExchangeType)=="undefined" || sExchangeType.length==0) {
			return;
		}
		
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
		OpenPage("/FormatDoc/ProducePutoutOtherFile.jsp?ExchangeType="+sExchangeType,"_blank02",CurOpenStyle); 
		
	}
	
	function ViewLog(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
	
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		OpenPage("/Common/Exchange/ExchangeLogList.jsp?SerialNo="+sSerialNo,"_blank02","width=720,height=600,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes"); 
	}
	
		
	/*~[Describe=����δ���ͽ��׹鵵ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function doPigeonHole(){
		var sReturn = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sReturn)=="undefined" || sReturn.length==0){
			alert(getHtmlMessage('1'));
			return;
		}		
		
		if (confirm("�鵵���������·��ͽ��ף�����ϸ�˶�Ҫ�鵵�Ľ������룬ȷ��Ҫ�鵵�ñʽ�����")){
			sReturnStatus = PopPageAjax("/Common/Exchange/ExchangePigeonHoleActionAjax.jsp?SerialNoArray="+sReturn,"","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			sReturn = getSplitArray(sReturnStatus);
			sStatus=sReturn[0];
			sMsg = sReturn[1];
			alert(sMsg);
			reloadSelf();
		}	
	}
	
	/*~[Describe=����δ���ͽ��׹鵵ObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function PigeonHole(){
		var sReturnArrary = getItemValueArray(0,"SerialNo");
		if (sReturnArrary.length==0){
			doPigeonHole()
			return;
		}		
		
		if (sReturnArrary.length>1){
			sMessage = "�鵵���������·��ͽ��ף�����ϸ�˶�Ҫ�鵵�Ľ������룬ȷ��Ҫ�����鵵���ѡ��Ľ�����";
		}else{
			sMessage = "�鵵���������·��ͽ��ף�����ϸ�˶�Ҫ�鵵�Ľ������룬ȷ��Ҫ�鵵���ѡ��Ľ�����";
		}
		
		if (confirm(sMessage)){
			sReturnStatus = PopPageAjax("/Common/Exchange/ExchangePigeonHoleActionAjax.jsp?SerialNoArray="+sReturnArrary,"","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
			sReturn = getSplitArray(sReturnStatus);
			sStatus=sReturn[0];
			sMsg = sReturn[1];
			alert(sMsg);
			reloadSelf();
		}	
	}
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>

<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>