<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   sjchuan 2009-10-10
		Tester:
		Content: ���������б�
		Input Param:
		Output param:
		History Log: cbsu 2009/10/28 ������ҳ��ReserveApplyTab.jsp��Ϊ����ObjectTab.jsp
	 */
	%>
<%/*~END~*/%>

	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������б�"; // ��������ڱ��� <title> PG_TITLE </title>
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

	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function doSubmit()	{
		//��ö������͡������š��׶α��
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
		sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("��ҵ����׶������Ѿ��ύ�������ٴ��ύ��");//��ҵ����׶������Ѿ��ύ�������ٴ��ύ��
			reloadSelf();
			return;
		}
		
		//����Ƿ�ǩ�����
		sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
			return;
		}
		
		//���������ύѡ�񴰿�	     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28	
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_"){
			return;
		}else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			//ˢ�¼�����ҳ��
			//reloadSelf(); //����ֻˢ��listҳ�棬��߽ڵ���ϢҲҪˢ�� by qzhang1 2013/07/05
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
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
				//reloadSelf();  //����ֻˢ��listҳ�棬��߽ڵ���ϢҲҪˢ�� by qzhang1 2013/07/05
				OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}
	}
	
    
	/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
	function signOpinion(){
		//���������ˮ�š��������͡�������
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		//ǩ���Ӧ�����
		sCompID = "SignTaskOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
		
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function viewTab(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		var sPhaseType = "<%=sPhaseType%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//���������������ˮ�ţ��������������
		sCompID = "CreditTab";
        sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
        sViewID = "003";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}	
	
	/*~[Describe=�˻�ǰһ��;InputParam=��;OutPutParam=��;]~*/
	function backStep(){
		//��ȡ������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");				
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
    		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    		return;
		}
		if(!confirm(getBusinessMessage('497'))) return; //��ȷ��Ҫ����������������˻���һ������
		//����Ƿ�ǩ�����
		sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0){
			//�˻��������   	
			sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//����ɹ�����ˢ��ҳ��
			if (sRetValue == "Commit"){
				OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=�����������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
			}
    	}else{
			alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
			return;
		}
	}

	/*~[Describe= �鿴�ֽ�����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function predictInfo(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseType = getItemValue(0,getRow(),"PhaseType");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "ReservePredictList";
		sCompURL = "/Reserve/ReservePredict/ReservePredictList.jsp";
		popComp(sCompID,sCompURL,"ToInheritObj=y&RightType=ReadOnly&PhaseType="+sPhaseType+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no;");
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