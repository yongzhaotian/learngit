<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:    bwang 2009/04/02 
		Tester:	
		Content:   ���õȼ��϶��б�
		Input Param:
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���õȼ����������б�(��)"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
	<%@include file="/Common/WorkFlow/ApplyList.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=�������õȼ��϶�����;InputParam=��;OutPutParam=��;]~*/
	function newApply()
	{
		var sStyle = "dialogWidth=350px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
		var sReturn = PopComp("RatingApplyCreateDialog","/CustomerRatingManage/CustomerRatingApply/RatingApplyCreateDialog.jsp","",sStyle);
		if(typeof(sReturn)=="undefined"||sReturn =='' || sReturn=="_CANCEL_"){
			reloadSelf();
			return;
		}
		sReturn = sReturn.split("@");
		var sRatingAppID = sReturn[0];
		var sModelID = sReturn[1];
		var sObjectNo = sReturn[2];
		var sObjectType = "<%=sObjectType%>";
		var sPhaseType = "<%=sPhaseType%>";
		var sApplyType = "<%=sApplyType%>";
		var sFlowNo = "<%=sInitFlowNo%>";
		var sPhaseNo = "<%=sInitPhaseNo%>";
		if(typeof(sPhaseNo)=='undefined'||sPhaseNo=='')sPhaseNo = '0010';
		var sOrgID = "<%=CurUser.getOrgID()%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var param = "applyNo="+sRatingAppID+",refModelID="+sModelID+",objectType="+sObjectType+",objectNo="+sObjectNo+",applyType="+sApplyType+",flowNo="+sFlowNo+",phaseNo="+sPhaseNo+",userID="+sUserID+",orgID="+sOrgID;
		var sReturn = RunJavaMethod("com.amarsoft.app.als.rating.action.RatingProcess","startRating",param);
		if(sReturn=='SUCCESS') alert("���������ɹ���");
		else {
			alert("��������ʧ�ܣ�");
			return;
		}
		if(!confirm("��������ǰ�豣֤�ͻ���Ϣ��׼ȷ�����ƣ�ȷ����������������"))return;
	    //var wizardId = "2011101400000001";
	    var param = "RatingAppID="+sRatingAppID;
	    if(sModelID=="WZBANK_DG_003"){//��ҵ��λ����ҳ��
			PopComp("RatingTranOnceList","/CustomerRatingManage/CustomerRatingApply/RatingTranOnceList.jsp","RatingAppID="+sRatingAppID+"&ViewFlag=2");
		}else{
	    	//popWizard(wizardId,param,"");
		}
		reloadSelf();
	}
	
	/*~[Describe=���õȼ���������;InputParam=��;OutPutParam=��;]~*/
	function viewDetail()
	{
		var sRatingAppID = getItemValue(0,getRow(),"RatingAppID");
		if(typeof(sRatingAppID)=="undefined"||sRatingAppID.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		var sModelID = getItemValue(0,getRow(),"RefModelID");
	    var wizardId = "2011101400000001";
	    var param = "RatingAppID="+sRatingAppID+"&ViewFlag=2";
	    if(sModelID=="WZBANK_DG_003"){//��ҵ��λ����ҳ��
			PopComp("RatingTranOnceList","/CustomerRatingManage/CustomerRatingApply/RatingTranOnceList.jsp",param,"");
		}else{
	    	//AsControl.popWizard(wizardId,param,"");
		}
	    reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function cancelApply()
	{
		var sApplyNo = getItemValue(0,getRow(),"RatingAppID");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(typeof(sApplyNo) == "undefined" || sApplyNo.length == 0){
			alert("��ѡ��һ����Ϣ");
			return;
		}
		if(!confirm("��ȷ��ȡ���ñ�����������")) return;
		var sReturn = RunJavaMethod("com.amarsoft.app.als.rating.action.RatingProcess","cancelRating","applyNo="+sApplyNo+",objectNo="+sObjectNo+",objectType="+sObjectType);
		if(sReturn == "SUCCESS"){
			alert("ȡ�������ɹ�");
			reloadSelf();
		} else {
			alert("ȡ������ʧ��");
		}
	}
	
	//ǩ�����
	function signOpinion()
	{
		return;
		//����������͡�������ˮ�š����̱�š��׶α��
		var sTaskNo= getItemValue(0,getRow(),"RelativeTaskNo");
		var sApplyType = getItemValue(0,getRow(),"ApplyType");
		var sApplyNo = getItemValue(0,getRow(),"RatingAppID");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sRatingGrade01 = getItemValue(0,getRow(),"RatingGrade01");
		if (typeof(sApplyNo)=="undefined" || sApplyNo.length==0){
			alert("��ѡ��һ����Ϣ��");//��ѡ��һ����Ϣ��
			return;
		}
		//У���Ƿ���ɲ���
		//var sCompleteSingl = RunJavaMethod("com.amarsoft.app.als.rating.action.CheckBeforeSubmit","checkCompleteSignal","RatingAppID="+sApplyNo);
		if(typeof(sRatingGrade01)=="undefined"||sRatingGrade01.length==0){
			alert("������������δ��ɲ��㣬������ɲ��� �ٽ����˹�����");
			return;
		}
		sCompURL = "/CustomerRatingManage/CustomerRatingApply/signOpinionView.jsp";
		PopComp("signOpinionView",sCompURL,"TaskNo="+sTaskNo+"&ApplyType="+sApplyType+"&ApplyNo="+sApplyNo+"&CustomerID="+sCustomerID,"");
		//RunJavaMethodTrans("com.amarsoft.app.als.rating.action.UpdateRatingResult","updateRatingGrade","SerialNo="+sTaskNo+",RatingAppID="+sApplyNo);
		reloadSelf();
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sApplyType = getItemValue(0,getRow(),"ApplyType");
		sApplyNo = getItemValue(0,getRow(),"RatingAppID");
		if (typeof(sApplyType)=="undefined" || sApplyType.length==0){
			alert("��ѡ��һ����Ϣ��");//��ѡ��һ����Ϣ��
			return;
		}
		PopComp("CRViewOpinionList","/CustomerRatingManage/CustomerRatingApprove/CRViewOpinionList.jsp","ApplyType="+sApplyType+"&ApplyNo="+sApplyNo,"");
	}
	
	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function doSubmit()
	{
		alert('�����������̲�������ʾ');
		return;
		var sApplyType = getItemValue(0,getRow(),"ApplyType");
		var sApplyNo = getItemValue(0,getRow(),"RatingAppID");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sRatingGrade01 = getItemValue(0,getRow(),"RatingGrade01");
		var sUserID = getItemValue(0,getRow(),"UserID");
		if (typeof(sApplyNo)=="undefined" || sApplyNo.length==0){
			alert("��ѡ��һ����Ϣ");//��ѡ��һ����Ϣ��
			return;
		}
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		//sNewPhaseNo=RunJavaMethod("com.amarsoft.app.als.workflow.action.WorkFlowEngine","getPhaseNo","ApplyType="+sApplyType+",ApplyNo="+sApplyNo+",SerialNo="+sSerialNo);
		//if(sNewPhaseNo != sPhaseNo) {
		//	alert("�������Ѿ��ύ�ˣ������ٴ��ύ��");//�������Ѿ��ύ�ˣ������ٴ��ύ��
		//	reloadSelf();
		//	return;
		//}
		if(typeof(sRatingGrade01)=="undefined"||sRatingGrade01.length==0){
			alert("����������δ��ɲ��㣬������ɲ������ύ��");
			return
		}

		//��ȡ������ˮ��
		var sTaskNo = RunJavaMethod("com.amarsoft.app.als.rating.action.RatingProcess","getUnfinishedTaskNo","objectType="+sObjectType+",objectNo="+sObjectNo+",flowNo="+sFlowNo+",phaseNo="+sPhaseNo+",userID="+sUserID);
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
	
		//����Ƿ�ǩ�����
		//var sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		//if(typeof(sReturn)=="undefined" || sReturn.length==0) {
		//	alert("����ǩ���϶������Ȼ�����ύ��");//��ǩ���϶����
		//	return;
		//}

		//���������ύѡ�񴰿�     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_"){
			return;
		}else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				reloadSelf();
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}
	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
    var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>