<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author: sjchuan 2009-10-9
	Tester:
	Content: ��������ֵ׼����Ϣ
	Input Param:
	Output param:
	History Log: cbsu 2009/10/28 ������ҳ��ReserveApplyTab.jsp��Ϊ����ObjectTab.jsp
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������ֵ׼����������"; // ��������ڱ��� <title> PG_TITLE </title>
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

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newApply(){
		//��jsp�еı���ֵת����js�еı���ֵ
		sObjectType = "<%=sObjectType%>";	
		sApplyType = "<%=sApplyType%>";	
		sPhaseType = "<%=sPhaseType%>";
		sInitFlowNo = "<%=sInitFlowNo%>";
		sInitPhaseNo = "<%=sInitPhaseNo%>";	
		//����������������Ի���
		sCompID = "ReserveApplyCreationInfo";
		sCompURL = "/Reserve/ReserveSingleManage/ReserveApplyCreationInfo.jsp";
		sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo,"dialogWidth=650px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sObjectNo=sReturn[1];
		
		//���������������ˮ�ţ��������������
		sCompID = "CreditTab";
        sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
        sViewID = "003";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();			
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sDuebillNo = getItemValue(0,getRow(),"ContractNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
		reloadSelf();
	}
	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
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

	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function doSubmit(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sApplyType = getItemValue(0,getRow(),"ApplyType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		//��ȡ������ˮ��
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		
		//����Ƿ�ǩ�����
		sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
			return;
		}
		
		//���������ύѡ�񴰿�		     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28
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
	
	/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
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
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		sCompID = "SignTaskOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
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
		var sCompID = "ReservePredictList";
		var sCompURL = "/Reserve/ReservePredict/ReservePredictList.jsp";
		var sRightType = "ReadOnly";
		if(sPhaseType=="1010" || sPhaseType=="1030"){
			sRightType = "All";
		}
		popComp(sCompID,sCompURL,"ToInheritObj=y&RightType="+sRightType+"&PhaseType="+sPhaseType+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe= ��Էǹ̶�Ƶ�ʵļ�ֵ���㣬��д�м��;InputParam=��;OutPutParam=��;]~*/
	function calReserve(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseType = getItemValue(0,getRow(),"PhaseType");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sDuebillNo = getItemValue(0,getRow(),"ContractNo");
		var sFlag = getItemValue(0,getRow(),"AvailabilityFlag");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(sFlag == "10"){
			alert("����ť���ܼ���̶�ģʽ����Ƶ�ʵļ�ֵ���ݣ�");
			return;
		}else if(sFlag == "20"){
			RunMethod("ReserveManage","ReserveSingleReserveSum",sAccountMonth+","+sDuebillNo+",true");
			RunMethod("ReserveManage","ReservePigeonHoleDate",sObjectNo);
			reloadSelf();
		}else{
			alert("��������ֵ׼������Ƶ��δ֪�����ܼ��㣡");
			return;
		}
	}	
		
	/*~[Describe= ��Ա��������Ϣ�����ӵ������ת��ϼ��ᰴť;InputParam=��;OutPutParam=��;]~*/
	function changeCalculateFlag(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseType = getItemValue(0,getRow(),"PhaseType");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sDuebillNo = getItemValue(0,getRow(),"ContractNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if (typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0 || 
		    typeof(sDuebillNo)=="undefined" || sDuebillNo.length==0){
			alert("�ñ����ݻ���·ݡ���ݺ���Ϣ��ȫ������ʧ��");
			return;
		}
		if(confirm("��ȷ�Ͻ��е������ת��ϼ��������")){
			sReturn=RunMethod("ReserveManage","ReserveSingleToComp",sObjectNo);
			if(sReturn == "1"){
				alert("����ҵ�������ת��ϼ�����ɣ�");
			}else{
				alert("����ҵ�������ת��ϼ���ʧ�ܣ�");		
			}						
		}
		reloadSelf();		
	}

	/*~[Describe=�鵵;InputParam=��;OutPutParam=��;]~*/
	function archive(){
		//��ó������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('56'))){ //������뽫����Ϣ�鵵��
			//�鵵����
			sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",RESERVE_APPLY");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getHtmlMessage('60'));//�鵵ʧ�ܣ�
				return;			
			}else{
				reloadSelf();	
				alert(getHtmlMessage('57'));//�鵵�ɹ���
			}			
		}
	}

	/*~[Describe=ȡ���鵵;InputParam=��;OutPutParam=��;]~*/
	function cancelarch(){
		//��ó������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('58'))){ //������뽫����Ϣ�鵵ȡ����
			//ȡ���鵵����
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",RESERVE_APPLY");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//ȡ���鵵ʧ�ܣ�
				return;
			}else{
				reloadSelf();
				alert(getHtmlMessage('59'));//ȡ���鵵�ɹ���
			}
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


<%@ include file="/IncludeEnd.jsp"%>