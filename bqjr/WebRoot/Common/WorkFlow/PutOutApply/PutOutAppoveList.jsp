<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.6
		Tester:
		Content: ��ҳ����Ҫ����ҵ����ص���������б�
		Input Param:
		Output param:
		History Log: 
			2005.08.03 jbye    �����޸�������������Ϣ
			2005.08.05 zywei   �ؼ�ҳ��
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
	<%@include file="/Common/WorkFlow/TaskList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	var sFlowNo = "<%=sFlowNo%>";
	var sPhaseNo = "<%=sPhaseNo%>";
	var sUserID = "<%=CurUser.getUserID()%>";
	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function doSubmit(){
		//����������͡�������ˮ�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		//���������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("��ҵ����׶������Ѿ��ύ�������ٴ��ύ��");//��ҵ����׶������Ѿ��ύ�������ٴ��ύ��
			reloadSelf();
			return;
		}
		
		//���������ύѡ�񴰿�	     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28	
        var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
//		var sPhaseInfo = "";
		if(sFlowNo=="CarFlow"){
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog_Car.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}else{
//			sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommit","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		}	
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_")  return;
		else if (sPhaseInfo == "Success"){
			if(sPhaseNo=='0030' && sObjectType=='PutOutApply'){
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='190',serialNo='"+sObjectNo+"'");//�޸ĺ�ͬ״̬
			}
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			//ˢ�¼�����ҳ��
			parent.reloadSelf();
			//OpenComp("PutOutAppoveApplyMain","/Common/WorkFlow/PutOutApply/PutOutAppoveApplyMain.jsp","ComponentName=�ſ�&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				//ˢ�¼�����ҳ��
				OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}
	}
	
	function cancelTask(){
		//����������͡�������ˮ�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sUserID = "<%=CurUser.getUserID()%>";
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		
		//���������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("��ҵ����׶������Ѿ��ύ������ȡ����");
			reloadSelf();
			return;
		}
				

		//���������ύѡ�񴰿�	     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28	
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sRet = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","CancelTask","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID+",FlowNo="+sFlowNo);
		if(sRet == 'Success'){
			alert("�����ɹ�");
		}else{
			alert("����ʧ��");
		}
		return;
		
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			//ˢ�¼�����ҳ��
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success"){
				alert("ȡ���ɹ���");//ȡ���ɹ���
				//ˢ�¼�����ҳ��
				OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}
	}
	
	//��ȡ���������
	function getTask(){
		//alert("******"+sFlowNo+"--"+sPhaseNo+"--"+sUserID);
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getTask","flowNo="+sFlowNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		if(sReturn == "Success"){
		//ˢ�¼�����ҳ��
		OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		alert("��ȡ����ɹ���");
		}else{
			alert("û�п��Ի�õ�����");
		}
	}
	
	//�������˻������
	function returnToPool(){
		//���������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","returnToPool","objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",objectType="+sObjectType);
		if(sReturn == "Success"){
			//ˢ�¼�����ҳ��
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			alert("�˻�����سɹ�");
			}else{
				alert("�˻������ʧ��");
			}
		
	}

	//ǩ�����
	function signCheckOpinion(){
		//���������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		//����"�����"��־;���ѻ�ȡ��δ�������ť�����񣬳�����Сʱ���Զ����˵������
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
		if(sReturn!=="Success"){
			alert("����'�����'��־����!");
			return;
		}
		
		if(sFlowNo=="CarFlow"){
			doSubmit();
			return;
		}
		
		var OpenStyle = "width=100%,height=100%,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
		var sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoViewLR.jsp";
		sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
		//����ύ�����������Լ������������ҳ��
		while(typeof(sReturn)!="undefined" && sReturn =='SameUser'){
			//����'�����'��־
			RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
			
			sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
			//alert(sReturn);
		}
		//reloadSelf();
		parent.reloadSelf();
	}
		
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function viewTab(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sCompID = "CreditTab";
		var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		var sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	
		if (sFlowNo=="PutOutFlow" && sPhaseNo != "0010") {
			sParamString += "&ViewID=002";
		}
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	
	/*~[Describe=�˻�ǰһ��;InputParam=��;OutPutParam=��;]~*/
	function backStep(){
		//��ȡ������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sUserID = "<%=CurUser.getUserID()%>";
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
    		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    		return;
		}
		if(!confirm(getBusinessMessage('509'))) return; //��ȷ��Ҫ���������˻���һ������
		//����Ƿ����˻�
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","cancelCheck","serialNo="+sSerialNo+",userID="+sUserID);
		if(sReturn != "Success"){
			alert("��һ���а��˲��ǵ�ǰ�û����������˻�");
			return;
		}else{
			sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","goBack","serialNo="+sSerialNo+",userID="+sUserID);
			if(sReturn =='Success'){
				alert("�˻سɹ���");
			}else{
				alert("�˻���һ��ʧ��!");
			}
			reloadSelf();
			return;
		}
		//����Ƿ�ǩ�����
		//var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0){
			//�˻��������   	
			var sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//����ɹ�����ˢ��ҳ��
			if(sRetValue == "Commit"){
				//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=�����������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
				reloadSelf();
			}else{
				alert(sRetValue);
			}
		}else{
			alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
			return;
		}
	}
	
	/*~[Describe=�����ջ�;InputParam=��;OutPutParam=��;]~*/
	function takeBack(){
		//��ȡ������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined"||sSerialNo.length == 0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//�ջ��������
		var sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�ջ��������","dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		//����ɹ�����ˢ��ҳ��
		if (sRetValue == "Commit"){
		    OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=�����������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		}		
	}
	
	/*~[Describe=�Զ�����̽��;InputParam=��;OutPutParam=��;]~*/
	function riskSkan(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		//���з�������̽��
		autoRiskScan("001","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,20);
		//sReturn=RunMethod("BusinessManage","CheckApplyRisk",sObjectType+","+sObjectNo);
		//if(typeof(sReturn) != "undefined" && sReturn != "") 
			//PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
	}
	
	/*~[Describe=�鿴��ְ���鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewReport(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sDocID = AsControl.RunJsp("/FormatDoc/ReportTypeSelect.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
		if (typeof(sDocID)=="undefined" || sDocID.length==0){
			alert(getBusinessMessage('505'));//��ְ���鱨�滹δ��д��������д��ְ���鱨���ٲ鿴��
			return;
		}
		
		var sReturn = AsControl.RunJsp("/FormatDoc/GetReportFile.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID);
		if (sReturn == "false"){
			alert("��ְ���鱨�滹δ���ɣ��������ɾ�ְ���鱨���ٲ鿴��");
			return;  
		}
				
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
		OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
	}
	//add by cdeng  2009-02-17  ���Ӳ鿴������ʷ��ť
	function flowHistory(){
		 //��ȡ������ˮ��
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectNo) == "undefined" || sObjectNo.length == 0){
    		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    		return;
		}
		OpenComp("FlowSubList","/Common/WorkFlow/FlowSubList.jsp","PhaseNo="+sPhaseNo+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&ObjectType="+sObjectType,"_blank");
	}

	/*~[Describe=����ͼ��չʾ;InputParam=��;OutPutParam=��;]~*/
	//add by yxzhang 2010-04-09  ���ڲ鿴����ͼ
	function viewFlowGraph(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			var iViewFileLength = RunMethod("WorkFlowEngine","GetViewFileLength",sFlowNo);
			if(typeof(iViewFileLength)=="undefined" || iViewFileLength.length==0){
				alert("���̵�ͼ�ζ��岻���ڣ�������������ͼ�ٲ鿴��");
				return;
			}
			popComp("FlowGraphView","/Common/WorkFlow/FlowGraphView.jsp","ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo);
		}
	}
	
	
	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function contractDetail(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("PutOutApplyTab","/Common/WorkFlow/PutOutApply/PutOutApplyTab.jsp","ObjectNo="+sObjectNo+"&CustomerID="+sCustomerID);
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
