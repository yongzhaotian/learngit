<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: �ڰ�ҵ��
		Input Param:
		Output param:
		History Log: xswang 20150427 CCS-173 ��������ͣ��ͬ���͡��ָ���ͬ������
					 xswang 20150615 CCS-900 ����е������ܱ���ͣ
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ڰ�ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�ڰ�ҵ��&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	//����������	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//����sSql�������ݶ���

	String sTempletNo = "BusinessingQueryList"; //ģ����
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//doTemp.setKeyFilter("SerialNo");
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//
	doTemp.multiSelectionEnabled=true;
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","������Ϣ","�鿴������Ϣ","viewFlow()",sResourcesPath},
			{"true","","Button","�������","�������","adjustTask()",sResourcesPath},
			{"true","","Button","�����˻�","�����˻�","returnToPool()",sResourcesPath},
			{"true","","Button","�鿴���","�鿴���","viewOpinions()",sResourcesPath},
			{"true","","Button","ȡ������","ȡ������","cancelApply()",sResourcesPath},
			{"true","","Button","�绰�ֿ�","�绰�ֿ�","getPhoneCode()",sResourcesPath},
			{"true","","Button","�鿴�����","�鿴�����","viewApplyTable()",sResourcesPath},
			// add by xswang 20150427 CCS-173 ��������ͣ��ͬ���͡��ָ���ͬ������
			{(CurUser.hasRole("5001"))?"true":"false","","Button","��ͣ��ͬ","��ͣ��ͬ","suspendContractBatch()",sResourcesPath},
			{(CurUser.hasRole("5001"))?"true":"false","","Button","�ָ���ͬ","�ָ���ͬ","recoveryContractBatch()",sResourcesPath},
			// end by xswang 20150427

	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	
	// �����������Ȩ�޵��� 
	// fixme Ȩ�޻�δ����  add by tbzeng 2014/05/11
	function adjustTask() {
		
		//var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		//var sPhaseNo = getItemValue(0, getRow(), "PhaseNo");
		//�޸�Ϊ��ѡ�����ֵ��һ�� zty
		var sObjectNo = getItemValueArray(0,"ObjectNo");
		var sPhaseNo = getItemValueArray(0,"PhaseNo");
		if (typeof(sObjectNo)=='undefined' || sObjectNo.length==0) {
			alert("��ѡ��һ����¼!");
			return;
		}
		if (sObjectNo.length>1) {
			alert("��֧��������������ֻѡ��һ����¼");
			return;
		}
		
		if ("0010" == sPhaseNo) {
			alert("�ñʺ�ͬ���ڵ���׶Σ����ܽ������������");
			return;
		}
		var retUserVal = setObjectValue("SelectSalesmanSingleByRole", "UserId,<%=CurUser.getUserID()%>", "", 0, 0, "");
		//alert(retUserVal + "|" + typeof retUserVal);
		if (!retUserVal || retUserVal=="_CLEAR_") {
			return;
		}
		var userId = retUserVal.split("@")[0];
		//alert(userId+"|"+sObjectNo);
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.BqjrFlowAction", "adjustTask", "objectNo="+sObjectNo+",userId="+userId+",phaseNo="+sPhaseNo);
		if(sReturn == "Success"){
			alert("��������ɹ�");
		}else if(sReturn == "FailError"){
			alert("�Ѿ��ǵ�ǰ�û������������");
		}else if(sReturn == "Working"){
			alert("��ǰ�׶��Ѿ�����");
		}else{
			alert("�������ʧ��");
		}
		reloadSelf();
	}
	
	// �������˻������ add by tbzeng 2014/05/11
	function returnToPool(){
		//var sObjectType = getItemValue(0,getRow(),"ObjectType");
		//var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		//var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		var sObjectType = getItemValueArray(0,"ObjectType");
		var sObjectNo = getItemValueArray(0,"ObjectNo");
		var sPhaseNo = getItemValueArray(0,"PhaseNo");
		if (typeof(sObjectNo)=='undefined' || sObjectNo.length==0) {
			alert("��ѡ��һ����¼!");
			return;
		}
		if (sObjectNo.length>1) {
			alert("��֧��������������ֻѡ��һ����¼");
			return;
		}
		
		if (sPhaseNo=='0010') {
			alert("����׶��������˻������!");
			return;
		}
		
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.BqjrFlowAction","backFlowPool","objectNo="+sObjectNo+",phaseNo="+sPhaseNo);
		if(sReturn == "Success"){
			//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMainNew.jsp","ComponentNam=����ҵ������&ComponentType=MainWindow&ApproveType=XFApprove","_top","");
			alert("�˻�����سɹ�");
		}else if(sReturn == "FailPool"){
			alert("����������������˻�");
		}else if(sReturn == "Working"){
			alert("��ǰ�׶��Ѿ�����");
		}else{
			alert("�˻�����ʧ��");
		}
		reloadSelf();
	}
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValueArray(0,"ObjectNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(sSerialNo.length > 1){
			alert("��֧��������������ֻѡ��һ����¼");
		}else{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}
	
	 /*~[Describe=�绰¼��;InputParam=��;OutPutParam=��;]~*/
	function getPhoneCode()
	{
		var sCustomerID=getItemValueArray(0,"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if (sCustomerID.length>1) {
			alert("��֧��������������ֻѡ��һ����¼");
			return;
		}
		
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		
	 }
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValueArray(0,"ObjectType");
		var sObjectNo =getItemValueArray(0,"ObjectNo");	
		var sFlowNo = getItemValueArray(0,"FlowNo");
		var sPhaseNo = getItemValueArray(0,"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if (sObjectNo.length>1) {
			alert("��֧��������������ֻѡ��һ����¼");
			return;
		}
		
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=�������;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewGradeCard(){
		
	}
	
	/*~[Describe=�鿴������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewFlow(){
		//���ҵ����ˮ��
		sSerialNo =getItemValueArray(0,"ObjectNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(sSerialNo.length > 1){
			alert("��֧��������������ֻѡ��һ����¼");
		}
		else
		{
			sCompID = "ViewFlow";
			sCompURL = "/InfoManage/QuickSearch/ViewFlow.jsp";
			popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"dialogWidth=900px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}
	}
	
	
	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValueArray(0,"ObjectType");
		var sObjectNo =getItemValueArray(0,"ObjectNo");	
		var sFlowNo = getItemValueArray(0,"FlowNo");
		var sPhaseNo = getItemValueArray(0,"PhaseNo");
		var sSerialNo = getItemValueArray(0,"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if (sObjectNo.length>1) {
			alert("��֧��������������ֻѡ��һ����¼");
			return;
		}
		
		//��ȡ��ǰҵ������̽׶α��  edit by pli2
		var sTaskNo = RunMethod("���÷���", "GetColValue", "FLOW_TASK,MAX(SerialNo), ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'");	
		
		//var OpenStyle = "width=100px,height=60px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//����ѡ��ȡ���������
		var sReturn = popComp("CancelApplyInfo","/Common/WorkFlow/CancelApplyInfo.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&PhaseNo="+sPhaseNo+"&FlowNo="+sFlowNo+"&TaskNo="+sTaskNo+"&Type=6","dialogWidth=600px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		window.returnValue = sReturn;
		window.close();
		reloadSelf();
	}
	
	// �鿴�����    
	function viewApplyTable () {
	printTable("ApplySettle");
}

//==============================  ��ӡ��ʽ������  ��������  add by yzhang9 ============================================================

/*~[Describe=��ӡ��ʽ������;InputParam=��;OutPutParam=��;]~*/
function printTable(type){
		var sObjectNo = getItemValueArray(0,"ObjectNo");
		var sUserID = "<%=CurUser.getUserID()%>";
		var sOrgID = "<%=CurOrg.getOrgID()%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if (sObjectNo.length>1) {
			alert("��֧��������������ֻѡ��һ����¼");
			return;
		}
		
		var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
		if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
			alert("����ϵϵͳ����Ա����ͬģ�����úͺ�ͬ��Ϣ!");
			return;
		}
		var sDocID = 	returnValue.split("@")[0];
		var sUrl = returnValue.split("@")[1];
		var sObjectType = type;
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			//������֪ͨ���Ƿ��Ѿ�����
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //δ���ɳ���֪ͨ��
				//���ɳ���֪ͨ��	
					PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
				//��¼���ɶ���
				RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID="+sOrgID+",userID="+sUserID+",occurType=produce");
			}else{
				//��¼�鿴����
				RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID="+sOrgID+",userID="+sUserID+",occurType=view");
			}
			//��ü��ܺ�ĳ�����ˮ��
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//ͨ����serverlet ��ҳ��
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}
}

//   ============================== end  ��ӡ��ʽ������ ============================================================
	
	//add by zty 20151026  ������ͣ
	function suspendContractBatch(){
		
		var sSerialNo =getItemValueArray(0,"ObjectNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		var sSerialNoArray = "";
		
		for(var i=0;i<sSerialNo.length;i++){
			sSerialNoArray = sSerialNoArray +"@'"+sSerialNo[i]+"'";
		}
		
		sSerialNoArray = sSerialNoArray.substring(1);
		
		var msg1 = RunJavaMethodSqlca("com.amarsoft.app.billions.BatchSuspendOrRecoveryContract", "contractSuspendValidate","objectNos="+sSerialNoArray);
		
		if(msg1 == "0"){
			var msg2 = RunJavaMethodSqlca("com.amarsoft.app.billions.BatchSuspendOrRecoveryContract", "contractSuspendExecute","objectNos="+sSerialNoArray);
			if(msg2 == "0"){
				alert("��ͬ��ͣ�ɹ�");
				reloadSelf();
			}else{
				alert("��ͬ��ִͣ��ϵͳ�쳣�����Ժ����Ի���ϵIT��");
			}
		}else if(msg1 == "1"){
			alert("�����̨��ͬ��Ϊ�գ�");
		}else if(msg1 == "2"){
			alert("��ѡ��ĺ�ͬ������еĺ�ͬ���밴����������ͬ�ٽ��в���!");
		}else if(msg1 == "3"){
			alert("��ѡ��ĺ�ͬ������ͣ�ĺ�ͬ���밴����������ͬ�ٽ��в���!");
		}else if(msg1 == "4"){
			alert("��ͬ��ͣУ��ϵͳ�쳣�����Ժ����Ի���ϵIT��");
		}
		
	
	}
	
	//add by zty 20151026  �����ָ�
    function recoveryContractBatch(){
		
		var sSerialNo =getItemValueArray(0,"ObjectNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		var sSerialNoArray = "";
		
		for(var i=0;i<sSerialNo.length;i++){
			sSerialNoArray = sSerialNoArray +"@'"+sSerialNo[i]+"'";
		}
		
		sSerialNoArray = sSerialNoArray.substring(1);
		
		var msg1 = RunJavaMethodSqlca("com.amarsoft.app.billions.BatchSuspendOrRecoveryContract", "contractRecoveryValidate","objectNos="+sSerialNoArray);
		
		if(msg1 == "0"){
			var msg2 = RunJavaMethodSqlca("com.amarsoft.app.billions.BatchSuspendOrRecoveryContract", "contractRecoveryExecute","objectNos="+sSerialNoArray);
			if(msg2 == "0"){
				alert("��ͬ�ָ��ɹ�");
				reloadSelf();
			}else{
				alert("��ͬ�ָ�ִ��ϵͳ�쳣�����Ժ����Ի���ϵIT��");
			}
		}else if(msg1 == "1"){
			alert("�����̨��ͬ��Ϊ�գ�");
		}else if(msg1 == "2"){
			alert("��ѡ��ĺ�ͬ��δ��ͣ�ĺ�ͬ���밴����������ͬ�ٽ��в���!");
		}else if(msg1 == "3"){
			alert("��ͬ�ָ�У��ϵͳ�쳣�����Ժ����Ի���ϵIT��");
		}
		
	
	}
	
	// add by xswang 20150427 CCS-173 ��������ͣ��ͬ���͡��ָ���ͬ������
	//��ͣ��ͬ
	function suspendContract(){
		sSerialNo =getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		var sObjectNo =getItemValue(0,getRow(),"ObjectNo");
		
		// add by xswang 20150615 CCS-900 ����е������ܱ���ͣ
		var sReturn2 = RunMethod("���÷���","GetColValue","FLOW_TASK,max(serialno),objectno='"+sObjectNo+"'");//����׶�
		var sReturn3 = RunMethod("���÷���","GetColValue","FLOW_TASK,phasetype,objectno='"+sObjectNo+"' and serialno ='"+sReturn2+"'");//�׶�
		var sReturn4 = RunMethod("���÷���","GetColValue","FLOW_TASK,taskstate,objectno='"+sObjectNo+"' and serialno ='"+sReturn2+"'");// taskstate
		if( (sReturn3 != "1010") && (sReturn4 == "1") ){
			alert("����еĺ�ͬ���ܱ���ͣ!");
			return;
		}
		// end by xswang 20150615
		
		//����ͣ�ĺ�ͬ�����ٴ���ͣ
		var sReturn1 = RunMethod("���÷���","GetColValue","BUSINESS_CONTRACT,cancelstatus,SerialNo='"+sObjectNo+"'");
		if(sReturn1 == "1"){
			alert("�˺�ͬ����ͣ!");
			return;
		}else{
			RunMethod("BusinessManage", "UpdateContractCancelStatus",sObjectNo);
			alert("��ͬ��ͣ�ɹ�");
			reloadSelf();
		}
	}
	
	//�ָ���ͬ
	function recoveryContract(){
		sSerialNo =getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		var sObjectNo =getItemValue(0,getRow(),"ObjectNo");
		//����ͬû�б���ͣ��������ָ�
		var sReturn1 = RunMethod("���÷���","GetColValue","BUSINESS_CONTRACT,cancelstatus,SerialNo='"+sObjectNo+"'");
		if(sReturn1 != "1"){
			alert("�˺�ͬδ��ͣ,����ָ�!");
			return;
		}else{
			RunMethod("BusinessManage", "UpdateContractCancelStatus1",sObjectNo);
			alert("��ͬ�ָ��ɹ�");
			reloadSelf();
		}
	}
	
	// end by xswang 20150427
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>