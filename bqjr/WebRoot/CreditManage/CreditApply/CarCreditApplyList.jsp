<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: ��ҳ����Ҫ����ҵ����ص������б��������Ŷ�������б����������ҵ�������б���
			 ��������ҵ�������б�
	Input Param:
	Output param:
	History Log: 
		zywei 2005/07/27 �ؼ�ҳ�� 
		zywei 2007/10/10 �޸�ȡ���������ʾ��
		zywei 2007/10/10 �������鱨��ʱ�����ͷ���ҵ����������ҵ����Ʊ����ҵ���ۺ�����ҵ�񡢸��˿ͻ���
						 ��С��ҵ֮���ҵ��Ž��е��鱨���ʽ���������ж�
		zywei 2007/10/10 ����û��򿪶����������ظ������������Ĵ���
		qfang 2011/06/13 �����жϣ����Ϊ"�����¹����ò�Ʒ"���򵯳�ҳ�棬��ʾҵ��Ʒ�ַ����������־λ�ֶ�
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
<%
	String PG_TITLE = "���ŷ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	// ��ȡ����Ԥ������
	String sTypeCode = "PreCredit";
	String sql = "select attrstr1 from Basedataset_Info where TypeCode='"+sTypeCode+"' order by UpdateDate desc ";
	String attrstr1 = DataConvert.toString( Sqlca.getString(sql));
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

	/*~[Describe=Segment�ϴ�����;InputParam=��;OutPutParam=��;]~*/
	function uploadAttachment(){
		 var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
		 OpenPage("/FormatDoc/RiskTip.jsp","_blank02",CurOpenStyle); 

		return;
		
		var serialNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var sCustomerType =  getItemValue(0,getRow(),"CustomerType");
		// ��������Ѿ��ϴ�����ɾ���ü�¼���ϴ�
		/*var sDocNo = RunMethod("���÷���", "GetColValue", "DOC_ATTACHMENT,DocNo,DocNo='"+serialNo+"'");
		if (sDocNo!="Null") {
			RunMethod("���÷���", "DelByWhereClause", "DOC_ATTACHMENT,DocNo='"+serialNo+"'");
		}
		
		AsControl.PopView("/AppConfig/Document/AttachmentChooseDialog3.jsp","DocNo="+serialNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();*/
		var param = "";
		if("03"==sCustomerType || "04"==sCustomerType){
			param = "ObjectType=Business&TypeNo=30&ObjectNo="+serialNo;
		}else{
			param = "ObjectType=Business&TypeNo=40&ObjectNo="+serialNo;
		}
	     
	     AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
	}

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newApply(){
		
		//�ж�Ԥ���Ƿ����ã���Ԥ�����ã��������ڴ��������롣��Ԥ����Ч������ʾ���辭��Ԥ��������롱��
		var yesNo = "<%=attrstr1%>";
		if("1"==yesNo){
			alert("�辭��Ԥ���������");
			return;
		}
		
		//��jsp�еı���ֵת����js�еı���ֵ
		var sObjectType = "<%=sObjectType%>";	
		var sApplyType = "<%=sApplyType%>";	
		var sPhaseType = "<%=sPhaseType%>";
		var sInitFlowNo = "<%=sInitFlowNo%>";
		var sInitPhaseNo = "<%=sInitPhaseNo%>";
		//alert("======="+sObjectType+"============"+sApplyType+"============"+sPhaseType+"========="+sInitFlowNo+"==========="+sInitPhaseNo);
		
		//����������������Ի���
		if(sApplyType == "CarCreditLineApply"){
			sCompID = "CarCreditApplyInfo";
			sCompURL = "/CreditManage/CreditApply/CarCreditApplyInfo.jsp";
		}
		sParamString ="ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sObjectNo=sReturn[0];
		//add by qfang �����жϣ����Ϊ"�����¹����ò�Ʒ"���򵯳�ҳ�棬��ʾҵ��Ʒ�ַ����������־λ�ֶ�
		//sObjectType=sReturn[1];
		//if(sReturn[2] != null){ 
		//	sTypeNo=sReturn[2];
		//	sSortReturn = RunMethod("CreditLine","CheckProductSortFlag",sTypeNo);
		//	if(sSortReturn.split("@")[0] == "true"){
		//		popComp("SortFlagInfo","/CreditManage/CreditApply/SortFlagInfo.jsp","TypeNo="+sTypeNo+"&ObjectNo="+sObjectNo,"dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");		
		//	}
		//}
		//add end
		
        //���������������ˮ�ţ��������������
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();		
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		var sUserID = "<%=CurUser.getUserID()%>";
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sFlowNo = "<%=sInitFlowNo%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if (confirm("��ȷ��Ҫȡ���ñ�������")) {
			//alert("-----"+sObjectType+"------"+sObjectNo);
			
			var sSerialNo = RunMethod("���÷���", "GetColValue", "FLOW_TASK,MAX(SerialNo), ObjectNo='"+sObjectNo+"'");	//RunMethod("BusinessManage","SelectFlowSerialno",sObjectNo+","+sPhaseNo+","+sObjectType);
			//�޸Ľ׶�Ϊ"��ȡ��"��
			var sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","CancelTask","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID+",flowNo="+sFlowNo);
			if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
			else if (sPhaseInfo == "Success"){
				alert("ȡ����ͬ�ɹ���");
				//RunMethod("BusinessManage","UpdateApplyPhaseType",sObjectNo+","+sObjectType+","+"1060");
				//�޸ĺ�ͬ״̬RunMethod("BusinessManage","UpdateContractStatus",sObjectNo+","+"100");
				//ˢ�¼�����ҳ�� 
				// add by tbzeng 2014/07/10 ���ȡ����ͬ����¼��Ȼ���������ҳ�棬�޷������ύ 
				var sEndTime =  RunMethod("���÷���", "GetColValue", "FLOW_TASK,ENDTIME,SERIALNO=(SELECT MAX(RELATIVESERIALNO) FROM FLOW_TASK WHERE  OBJECTNO='"+sObjectNo+"')");
				
				if (sEndTime!=null && (sEndTime=="Null" || sEndTime.length<=0)) {
					
					var sBeginTime = RunMethod("���÷���", "GetColValue","FLOW_TASK,BEGINTIME,SERIALNO=(SELECT MAX(SERIALNO) FROM FLOW_TASK WHERE OBJECTNO='"+sObjectNo+"')");
					var sLastPreSerialNo = RunMethod("���÷���", "GetColValue", "FLOW_TASK,MAX(RELATIVESERIALNO),OBJECTNO='"+sObjectNo+"'");
					RunMethod("���÷���", "UpdateColValue", "FLOW_TASK,ENDTIME,"+sBeginTime+",SERIALNO='"+sLastPreSerialNo+"'");
				}
				// end 2014
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
				alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
				reloadSelf();
				return;
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=����ſ�;InputParam=��;OutPutParam=��;]~*/
	function applyLoan(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//�޸ĺ�ͬ״̬:���ſ�180
		var returns=RunMethod("BusinessManage","UpdateContractStatus",sObjectNo+","+"180");
		//alert("-----"+returns);
		if(returns=="1.0"){
			alert("����ſ�ɹ���");
			reloadSelf();
		}else{
			alert("����ſ�ʧ�ܣ�");
			reloadSelf();
		}
		
	}

	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function doSubmit(){
		//add by hwang,������ȡ����sApplyType1��������
		//����������͡�������ˮ�š����̱�š��׶α�š���������
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sApplyType1 = "<%=sApplyType%>";
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		var sUserID = "<%=CurUser.getUserID()%>";
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);		
		if(sNewPhaseNo != sPhaseNo) {
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}

		//��ȡ������ˮ��
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		} 
		
		//�ύ֮ǰ��У��
		var sColName = "TempSaveFlag";
		var sTableName = "Business_Contract";
		var sWhereClause = "SerialNo='"+sObjectNo+"'";
		var sTempSaveFlag=RunMethod("���÷���","GetColValue",sTableName + "," + sColName + "," + sWhereClause);
		if("2"!=sTempSaveFlag){
			alert("��ͬ��Ϣδ���棬�뱣������ύ��");
			return;
		}
		//���������ύѡ�񴰿�		���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28 
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

		var sPhaseInfo = "";
	 	if (sFlowNo=="CarFlowNew"){
			//��ȡ���̽׶���ˮ��
			
			//String TableName,String ColName,String WhereClause
			sTaskNo = RunMethod("���÷���","GetColValue","FLOW_TASK,SerialNo,ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"' and PhaseNo='"+sPhaseNo+"'");
					
			//���ù����������ȼ�
			var sRet = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getGrade","objectType="+sObjectType+",objectNo="+sObjectNo);
			if(sRet!="Success"){
				alert("��������ȼ�������");
				return;
			}
			sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommit","SerialNo="+sTaskNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		}else{ //��� �����Ѵ����̣���Ҫ�������Լ�����flowNo
			sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommitWithRule","SerialNo="+sTaskNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		}
		
		
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
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=34;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		
		sCompID = "SignTaskOpinionInfoCarFlow";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoCarFlow.jsp";
		popComp(sCompID,sCompURL,"FlowNo="+sFlowNo+"&TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/CarViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
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
		//PhaseNo = "<%=sInitPhaseNo%>";
		var sPhaseNo = RunMethod("WorkFlowEngine","GetInitPahseNo",sObjectType+","+sObjectNo);
		//��ȡ������ˮ��
		var sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0){
			if(confirm(getBusinessMessage('498'))){ //ȷ���ջظñ�ҵ����
				sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				//�ջسɹ����ˢ��ҳ��
				if(sRetValue == "Commit"){
					reloadSelf();
				}
			}
		}else{
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}				
	}

	/*~[Describe=�鵵;InputParam=��;OutPutParam=��;]~*/
	function archive(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('56'))){ //������뽫����Ϣ�鵵��
			//�鵵����
			sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",BUSINESS_APPLY");
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
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('58'))){ //������뽫����Ϣ�鵵ȡ����
			//ȡ���鵵����
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BUSINESS_APPLY");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//ȡ���鵵ʧ�ܣ�
				return;
			}else{
				reloadSelf();
				alert(getHtmlMessage('59'));//ȡ���鵵�ɹ���
			}
		}
	}

	/*~[Describe=�Զ�����̽��;InputParam=��;OutPutParam=��;]~*/
	function riskSkan(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sApplyType1 = "<%=sApplyType%>";
		var sOccurType=getItemValue(0,getRow(),"OccurType");

		//��ȡ������ˮ��
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		}
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//���з�������̽��
        autoRiskScan("001","OccurType="+sOccurType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ApplyType1="+sApplyType1+"&UserID="+"<%=CurUser.getUserID()%>"+"&TaskNo="+sTaskNo);
		//autoRiskScan("001","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,20);
		
	}
		
	/*~[Describe=��д���鱨��;InputParam=��;OutPutParam=��;]~*/
	function genReport(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sDocID = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sReturn = AsControl.RunJsp("/FormatDoc/ReportTypeSelect.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
		if(typeof(sReturn)=="undefined" || sReturn.length==0){
			sFlag = AsControl.RunJsp("/FormatDoc/GetBusinessTypeAction.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
			if(sFlag =="1") sDocID = "06";//��˾�ͻ��ͷ���ҵ����鱨��
			else if(sFlag =="2") sDocID = "04";//��˾�ͻ����Ŷ����������ҵ����鱨��
			else if(sFlag =="3") sDocID = "05";//��˾�ͻ���Ʊ����ҵ����鱨��
			else if(sFlag =="4") sDocID = "03";//��˾�ͻ��ۺ����ŵ��鱨��
			else if(sFlag =="8"){
				sDocID = "08";//���˿ͻ�����ҵ����鱨��
				alert("����ҵ����Ҫ��д���鱨��");  //added by yzheng 2013-6-25
				return;
			}
			else if(sFlag =="9") sDocID = "09";//��С��ҵ����ҵ����鱨��
			else{
				sDocID = setObjectValue("SelectReportType","","",0,0,"");
				if(sDocID == "" || sDocID == "_CANCEL_" || sDocID == "_NONE_" || sDocID == "_CLEAR_" || typeof(sDocID) == "undefined") return;			
				sDocID = sDocID.split("@");
				sDocID = sDocID[0];
			}
		}else{
			sDocID = sReturn;
			sFlag = AsControl.RunJsp("/FormatDoc/GetBusinessTypeAction.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
			if(sFlag == "5"){   //5���������������鱨���������������
				sReturn = PopPage("/Common/WorkFlow/ButtonDialog.jsp","","dialogWidth=18;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if(typeof(sReturn)=="undefined" || sReturn.length==0){
					return;
				}else if (sReturn == "_CANCEL_"){
					PopPage("/FormatDoc/DeleteReportAction.jsp?ObjectNo="+sObjectNo,"","");
					sDocID = setObjectValue("SelectReportType","","",0,0,"");
					if(sDocID == "" || sDocID == "_CANCEL_" || sDocID == "_NONE_" || sDocID == "_CLEAR_" || typeof(sDocID) == "undefined") return;			
					sDocID = sDocID.split("@");
					sDocID = sDocID[0];	
				}				
			}			
		}
		sReturn = PopPage("/FormatDoc/AddData.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if(typeof(sReturn)!='undefined' && sReturn!=""){
			sReturnSplit = sReturn.split("?");
			var sFormName=randomNumber().toString();
			sFormName = "AA"+sFormName.substring(2);
			OpenComp("FormatDoc",sReturnSplit[0],sReturnSplit[1],"_blank",OpenStyle); 
		}
	}
	
	/*~[Describe=���ɵ��鱨��;InputParam=��;OutPutParam=��;]~*/
	function createReport(){
		//����������͡�������ˮ�š��ͻ����
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}	
		
		var sDocID = AsControl.RunJsp("/FormatDoc/ReportTypeSelect.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
		if (typeof(sDocID)=="undefined" || sDocID.length==0){
			alert(getBusinessMessage('505'));//���鱨�滹δ��д��������д���鱨���ٲ鿴��
			return;
		}
		
		if (confirm(getBusinessMessage('504'))){ //�Ƿ�Ҫ���Ӵ�ӡ����,���������ȷ����ť��
			var sAttribute1 = PopPage("/Common/WorkFlow/DefaultPrintSelect.jsp?DocID="+sDocID+"&rand="+randomNumber(),"","dialogWidth=800px;dialogHeight=600px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
			if (typeof(sAttribute1)=="undefined" || sAttribute1.length==0)
				return;
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute1,"_blank02",CurOpenStyle); 
		}else{
			var sAttribute = PopPage("/FormatDoc/DefaultPrint/GetAttributeAction.jsp?DocID="+sDocID,"","");
			if (typeof(sAttribute)=="undefined" || sAttribute.length==0) return;
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
			OpenPage("/FormatDoc/ProduceFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&CustomerID="+sCustomerID+"&Attribute="+sAttribute,"_blank02",CurOpenStyle); 
		}
	}	
	
	/*~[Describe=�鿴���鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewReport(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sDocID = AsControl.RunJsp("/FormatDoc/ReportTypeSelect.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
		if (typeof(sDocID)=="undefined" || sDocID.length==0){
			alert(getBusinessMessage('505'));//���鱨�滹δ��д��������д���鱨���ٲ鿴��
			return;
		}
		
		var sReturn = AsControl.RunJsp("/FormatDoc/GetReportFile.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID);
		if (sReturn == "false"){
			createReport();
			return;  
		}else{
			if(confirm(getBusinessMessage('503'))){ //���鱨���п��ܸ��ģ��Ƿ����ɵ��鱨����ٲ鿴��
				createReport();
				return; 
			}else{
				var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
				OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
		}
	}
	
	/*~[Describe=���Ƶ�ǰ;InputParam=��;OutPutParam=��;]~*/
	function copyThis(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if (confirm("��ȷ�ϸ���������Ϣ��")){
			sReturn = RunMethod("WorkFlowEngine","CopyApplyFlow",sObjectType+","+sObjectNo);
			if(typeof(sReturn)!="undefined" && sReturn.length!=0){
				alert("���Ƴɹ�");
				reloadSelf();
			}
		}
	}	

	/*~[Describe=��ɫͨ��;InputParam=��;OutPutParam=��;]~*/
	function greenWay(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
		    sReturn=RunMethod("BusinessManage","initializeGreenWay",sObjectNo+","+"<%=CurUser.getUserID()%>"+","+"<%=CurOrg.getOrgID()%>");
		    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;

			sObjectType = "BusinessContract";
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}
	}	

	/*~[Describe=����ͼ��չʾ;InputParam=��;OutPutParam=��;]~*/
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
	
	/*~[Describe=����������׼�ύ;InputParam=��;OutPutParam=��;]~*/
	function conditionSubmit(){
		
	}
	
	/*~[Describe=�鿴��׼����;InputParam=��;OutPutParam=��;]~*/
	function viewApprove(){
		
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