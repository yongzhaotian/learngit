<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: ��ҳ����Ҫ����ҵ����ص������б������Ŷ�������б��������ҵ�������б�
			 ��������ҵ�������б�
	Input Param:
	Output param:
	History Log: 
		zywei 2005/07/27 �ؼ�ҳ�� 
		zywei 2007/10/10 �޸�ȡ�����������������ʾ��
		hwang 2009/06/30 �������ҵ���ύʱ���������Ч�Լ��
		sxjiang  2010/07/12   Line138  ���˸���  Line26 �޸����������
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������������б�ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
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

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�Ǽ������������;InputParam=��;OutPutParam=��;]~*/
	function newApprove(){
		var sApproveType = "";//��������������ͣ�01��ͬ���������������02������������������
		//����ͨ����������Ϣ
		var sParaString = "ObjectType"+","+"CreditApply"+","+"SortNo"+","+"<%=CurOrg.getSortNo()%>"+","+"UserID,"+"<%=CurUser.getUserID()%>";
		sReturn = setObjectValue("SelectApply",sParaString,"",0,0,"");		
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;

		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		sPhaseNo = sReturn[1];
		//��������������Ϊ��׼����Ǽ�ͬ�������������������򣬵ǼǷ���������������
		if(sPhaseNo == '1000') sApproveType = '01';
		else sApproveType = '02';
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.credit.approve.action.InitializeApprove","initialize","ApplySerialNo="+sObjectNo+",ApproveOpinion="+sApproveType+",UserID=<%=CurUser.getUserID()%>,ApplyType=<%=sApplyType%>,InitFlowNo=<%=sInitFlowNo%>,InitPhaseNo=<%=sInitPhaseNo%>");
		reloadSelf();
	}

	/*~[Describe=ȡ�������������;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	
		if(confirm(getHtmlMessage('70'))){ //�������ȡ������Ϣ��
			as_del("myiframe0");			
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����			
		}
	}
	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sApproveType = getItemValue(0,getRow(),"ApproveType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	
		var sCompID = "CreditTab";
		var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		var sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function doSubmit(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sApplyType1 = getItemValue(0,getRow(),"ApplyType");//�������ͣ�IndependentApply,DepententApply,CreditLineApply
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert("�õǼ�������������Ѿ��ύ�ˣ������ٴ��ύ��");
			reloadSelf();
			return;
		}
						
		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('499'));//�����������������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		
		//���з�������̽��
		var sReturn = autoRiskScan("008","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApplyType1="+sApplyType1+"&UserID="+"<%=CurUser.getUserID()%>"+"&TaskNo="+sTaskNo);
		if(sReturn != true){
			return;
		}
		
		//���������ύѡ�񴰿�		���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28 
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
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
	
	//ǩ�����
	function signOpinion(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		//��ȡ������ˮ��
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		var sCompID = "SignTaskOpinionInfo";
		var sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}

	//�ջ�
	function takeBack(){
		//���ջ��������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = "<%=sInitPhaseNo%>";	
		//��ȡ������ˮ��
		var sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0){
			if(confirm(getBusinessMessage('498'))){ //ȷ���ջظñ�ҵ����
				sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				//����ɹ�����ˢ��ҳ��
				if(sRetValue == "Commit"){
					reloadSelf();
				}
			}			
		}else{
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
	}

	/*~[Describe=�Զ�����̽��;InputParam=��;OutPutParam=��;]~*/
	function riskSkan(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");	
		var sOccurType=getItemValue(0,getRow(),"OccurType");

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//���з�������̽��
		var result = autoRiskScan("008","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo);
		return result;
	}
	
	/*~[Describe=��ӡ�����������;InputParam=��;OutPutParam=��;]~*/
	function print() {
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sApproveType = getItemValue(0,getRow(),"ApproveType");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} else {
			PopComp("PrintSheetAction","/Common/WorkFlow/PrintSheetAction.jsp","ObjectNo="+sObjectNo,"","");
		}
	}	
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>