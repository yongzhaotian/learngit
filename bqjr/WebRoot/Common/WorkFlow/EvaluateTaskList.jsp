<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: bwang 2009/04/02 
		Tester:
		Content: ��ҳ����Ҫ�������õȼ���������������б�
		Input Param:
		Output param:
		History Log: ��ʼ��ҳ��
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���õȼ������϶�����"; // ��������ڱ��� <title> PG_TITLE </title>
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
	
	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function doSubmit()
	{
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sEvaluateScore = getItemValue(0,getRow(),"EvaluateScore");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if (typeof(sEvaluateScore)=="undefined" || sEvaluateScore.length==0){
			alert("���Ƚ���ģ��������");//���Ƚ���ģ������
			return;
		}
		
		//��ȡ������ˮ��
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		//����Ƿ�ǩ�����
		var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert("����ǩ���϶������Ȼ�����ύ��");//��ǩ���϶����
			return;
		}

		//���������ύѡ�񴰿�		
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sSerialNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_"){
			return;
		}else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=���õȼ��϶�����&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=34;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=���õȼ��϶�����&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}
	}
		
	//ǩ�����
	function signOpinion() 
	{
		   //������͡���ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sEvaluateScore = getItemValue(0,getRow(),"EvaluateScore");
		var sERObjectNo = getItemValue(0,getRow(),"ERObjectNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if (typeof(sEvaluateScore)=="undefined" || sEvaluateScore.length==0){
			alert("���Ƚ���ģ��������");//���Ƚ���ģ������
			return;
		}
		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}

	    var sParaString = "TaskNo="+sTaskNo
	                      +"&ObjectType="+sObjectType
                          +"&ObjectNo="+sERObjectNo
                          +"&ERSerialNo="+sSerialNo
                          +"&PhaseNo="+sPhaseNo;
        PopComp("SignEvaluateOpinionInfo","/Common/WorkFlow/SignEvaluateOpinionInfo.jsp",sParaString,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        //���˹����������ͽ�����µ�EVALUATE_RECORD���� add by cbsu 2009-11-11
        RunMethod("WorkFlowEngine","UpdateEvaluateManResult",sSerialNo + "," + sTaskNo);
		reloadSelf();
	}
		
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//������͡���ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		PopComp("ViewEvaluateOpinions","/Common/WorkFlow/ViewEvaluateOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=���õȼ���������;InputParam=��;OutPutParam=��;]~*/
	function viewDetail()
	{
		var sSerialNo = getItemValue(0,getRow(),"ERSerialNo");
		var sOrgID    = getItemValue(0,getRow(),"OrgID");
		var sObjectNo = getItemValue(0,getRow(),"ERObjectNo");
		var sFinishFlag ="<%=sFinishFlag%>";
		var hasRole = "N";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			var sEditable="true";
			if(hasRole=="N")
				sEditable="false";
			if(sFinishFlag=="Y") 
				sEditable="false";
			OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&CustomerID="+sObjectNo+"&ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo+"&Editable="+sEditable,"_blank",OpenStyle);
		    reloadSelf();
		}		
	}
	/*~[Describe=�˻�ǰһ��;InputParam=��;OutPutParam=��;]~*/
	function backStep()
	{	
			
		//��ȡ������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");				
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
        {	
    		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    		return;
		}
		
		//����Ƿ�ǩ�����
		sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");	
		if(typeof(sReturn)=="undefined" || sReturn.length==0) 
		{						
			//�˻��������   
			if(!confirm(getBusinessMessage('509'))) return; //��ȷ��Ҫ���������˻���һ������	
			sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//����ɹ�����ˢ��ҳ��
			if(sRetValue == "Commit"){
				//OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=���õȼ��϶�����&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
				reloadSelf();
			}else{
				alert(sRetValue);
			}
		}else
		{
			alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
			return;
		}
		
	}
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>
