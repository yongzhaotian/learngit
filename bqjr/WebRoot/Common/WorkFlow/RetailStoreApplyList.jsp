<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
    Author: ccxie 2010/03/18
    Tester:
    Content: ��ҳ����Ҫ��������ͬ�����ص������б�����϶��������б��϶��е������б��϶�ͨ���������б�
    Input Param:
    Output param:
    History Log:
    */
    %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "�������ŵ�׼�����"; // ��������ڱ��� <title> PG_TITLE </title>
    
    String sViewId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewId"));
    if (sViewId == null) sViewId = "01";
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
		var sObjectType = "<%=sObjectType%>";	
		var sApplyType = "<%=sApplyType%>";	
		var sPhaseType = "<%=sPhaseType%>";
		var sInitFlowNo = "<%=sInitFlowNo%>";
		var sInitPhaseNo = "<%=sInitPhaseNo%>";
		
    	var sRetVal = PopPage("/BusinessManage/ChannelManage/PrepareRetailStoreApplyInfo.jsp", "ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo, "dialogWidth=450px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    	if (typeof(sRetVal)=='undefined' || sRetVal.length==0) {
			return;
		}
    	var sPermitType = sRetVal.split("@")[1];
		var sUrl = "";
    	if (sPermitType == '01') {
    		
			sUrl = "/BusinessManage/ChannelManage/RetailApplyTV.jsp"; 
		} else if (sPermitType == '02') {
			sUrl = "/BusinessManage/ChannelManage/StoreApplyTV.jsp"; 
		}
    	
		AsControl.PopView(sUrl, "RSSerialNo="+sRetVal.split("@")[0]+"&RSerialNo="+sRetVal.split("@")[2]+"&ApplyType="+sApplyType, "");
		reloadSelf();
    }
    
    /*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
    function cancelApply(){
        //����������͡�������ˮ��
        //var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        if(confirm(getHtmlMessage('70'))){ //�������ȡ������Ϣ��
            as_del("myiframe0");
            as_save("myiframe0");  //�������ɾ������Ҫ���ô����
            reloadSelf();
        }
    }

    /*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
    function viewTab(){
    	var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        
		var sPermitType = getItemValue(0, getRow(), "PERMITTYPE");
        if (sPermitType == '01') {
			sUrl = "/BusinessManage/ChannelManage/RetailApplyTV.jsp";
		} else if (sPermitType == '02') {
			sUrl = "/BusinessManage/ChannelManage/StoreApplyTV.jsp"; 
		}
        //alert(sRetVal);
		AsControl.PopView(sUrl, "RSSerialNo="+getItemValue(0, getRow(), "SERIALNO")+"&RSerialNo="+getItemValue(0, getRow(), "RSERIALNO")+"&ViewId=<%=sViewId%>&ApplyType="+getItemValue(0, getRow(), "APPLYTYPE"), "");
		reloadSelf();
    }

    /*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
	function doSubmit(){
		//add by hwang,������ȡ����sApplyType1��������
		//����������͡�������ˮ�š����̱�š��׶α�š���������
		var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
		var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
		var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
		var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
		var sApplyType1 = "<%=sApplyType%>";
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sUserID = "<%=CurUser.getUserID()%>";

		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);		
		if(sNewPhaseNo != sPhaseNo) {
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}
		
		// �ж��������Ƿ��Ѿ�¼������
		var sRSerialNo = getItemValue(0, getRow(), "RSERIALNO");
		var sIsSave = RunMethod("���÷���", "GetColValue", "Retail_Info,IsSave,SerialNo='"+sRSerialNo+"'");
		if (sIsSave != "01") {
			alert("����¼����̻��������ύ��");
			return;
		}
		
		// ���Ϊ�ŵ������ж��Ƿ�ñ��ŵ��������Ѿ�������ŵ�
		//var sPermitType = getItemValue(0, getRow(), "PERMITTYPE");
		var dStoreCnt = RunMethod("���÷���", "GetCountByWhereClause", "Store_Info,SerialNo,Rsserialno='"+getItemValue(0, getRow(), "SERIALNO")+"'");
		if (dStoreCnt <= 0.0) {
			alert("�ñ������»�û�й����ŵ꣬����\n����-�ŵ��б�������ŵ꣡");
			return;
		}
		
		//��ȡ������ˮ��
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		} 
		
		//���������ύѡ�񴰿�		���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28 
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = "";
		sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommit","SerialNo="+sTaskNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			//alert(getHtmlMessage('18'));//�ύ�ɹ���
			alert("��һ���ύ����ȫ�������,����\n�����������ͨ���򱻷���в鿴!");
			var sPermitType = getItemValue(0, getRow(), "PERMITTYPE");
			if (sPermitType == "01") {
				var sRSerialNo = getItemValue(0, getRow(), "RSERIALNO");
				RunMethod("���÷���", "UpdateColValue", "Retail_Info,Status,02,SerialNo='"+sRSerialNo+"'");
			} 
			RunMethod("���÷���", "UpdateColValue", "Store_Info,Status,02,RSSerialNo='"+sObjectNo+"'");
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
		var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
		var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
		var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
		var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
		
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
    
    /*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
    function viewOpinions(){
        //����������͡�������ˮ�š����̱�š��׶α��
        var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
        var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
        var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
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
			var sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",GUARANTY_TRANSFORM");
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
	function cancelarchive(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('58'))){ //������뽫����Ϣ�鵵ȡ����
			//ȡ���鵵����
			var sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",GUARANTY_TRANSFORM");
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
    initRow();
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>