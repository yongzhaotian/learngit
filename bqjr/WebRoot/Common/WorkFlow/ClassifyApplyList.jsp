<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
    Author: cbsu  2009.10.13
    Tester:
    Content: ��ҳ����Ҫ�����弶������ص������б�����϶��������б��϶��е������б��϶�ͨ���������б�
    Input Param:
    Output param:
    History Log:
    */
    %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "�弶���෽������"; // ��������ڱ��� <title> PG_TITLE </title>
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
        var sResultType = "<%=sResultType%>";
        
        //����������������Ի���
        var sCompID = "ClassifyDialog";
        var sCompURL = "/CreditManage/CreditCheck/ClassifyDialog.jsp";
        var sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ResultType="+sResultType+"&PhaseType="+sPhaseType+"&ClassifyType=010","dialogWidth=500px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_" || sReturn.length == 0) return;
        RunMethod("WorkFlowEngine","UpdateClassifyModelResult",sReturn);
        reloadSelf();
    }
    
    /*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
    function cancelApply(){
        //����������͡�������ˮ��
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

    /*~[Describe=ģ�ͷ���;InputParam=��;OutPutParam=��;]~*/
    function viewDetail(){
        //���ObjectType(�弶����������ͣ�ֵΪ"Classify"),ObjectNo(��ݺŻ��ͬ��),SerialNo(Classify_Record���SerialNo�����弶����������ˮ��)
        //AccountMonth(����·�),ModelNo(�弶��������ģ�ͺ�),ResultType(�弶�����ǽ�ݻ��ͬ��ֵΪ"BusinessDueBill"��"BusinessContract")
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        var sObjectNo = getItemValue(0,getRow(),"DuebillNo");
        var sSerialNo = getItemValue(0,getRow(),"SerialNo");
        var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        
        var sResultType = "<%=sResultType%>";
        //�弶����Ľ׶�ID������������룬�϶��е����룬�϶�ͨ��������
        var sPhaseType = "<%=sPhaseType%>";
        //����sClassifyType��ȷ������ʾClassifyDetail.jspҳ��ʱ�Ƿ���ʾ"����"��"����"��ť��
        if (sPhaseType == "1010") {
            sClassifyType = "010";
        } else {
            sClassifyType = "020";
        }
        
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        
        //�����ϲ�����ϳɲ����ַ���
        var sCompURL = "/CreditManage/CreditCheck/ClassifyDetail.jsp";
        var sCompID = "ClassifyDetails";
        var sParameter = "1=1"+
                     "&Action=_DISPLAY_"+
                     "&ClassifyType="+sClassifyType+
                     "&ObjectType="+sObjectType+
                     "&ObjectNo="+sObjectNo+
                     "&SerialNo="+sSerialNo+
                     "&AccountMonth="+sAccountMonth+
                     "&ModelNo=Classify1"+
                     "&ResultType="+sResultType;
        popComp(sCompID,sCompURL,sParameter);
        
        if (sClassifyType == "010") {
        	//��ģ�ͷ��������µ�CLASSIFY_RECORD���FinallyResult�ֶΡ�
            RunMethod("WorkFlowEngine","UpdateClassifyModelResult",sSerialNo);
        }
        reloadSelf();
    }
    
    /*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
    function viewTab(){
        //���ObjectType(�弶����������ͣ�Ϊ"Classify")�� SerialNo(Classify_Record���SerialNo�����弶����������ˮ��)��sDuebillNo(��ݺŻ��ͬ��), 
        //AccountMonth(����·�),ResultType(�弶�����ǽ�ݻ��ͬ��ֵΪ"BusinessDueBill"��"BusinessContract")
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        var sSerialNo = getItemValue(0,getRow(),"SerialNo");
        var sObjectNo = getItemValue(0,getRow(),"DuebillNo");
        var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        var sPhaseType = "<%=sPhaseType%>"; //�弶����Ľ׶�ID������������룬�϶��е����룬�϶�ͨ��������
        
        if (sPhaseType == "1010") {
            sClassifyType = "010";
            sViewID = "000";//jschen@20100423 ����tab���޸�
        } else {
            sClassifyType = "020";
            sViewID = "002";//jschen@20100423 ����tabֻ��
        }
        
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        var sResultType = "<%=sResultType%>";
        var sCompID = "CreditTab";
        var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
        var sParamString = "ComponentName=���շ���ο�ģ��"+
				       "&OpenType=Tab"+ //jschen@20100412 �������ִ򿪷���ģ�ͽ���ķ�ʽ
            		   "&Action=_DISPLAY_"+
            		   "&ClassifyType="+sClassifyType+
            		   "&ObjectType="+sObjectType+
            		   "&ObjectNo="+sSerialNo+
            		   "&SerialNo="+sObjectNo+
            		   "&AccountMonth="+sAccountMonth+
            		   "&ModelNo=Classify1"+
            		   "&ResultType="+sResultType+
            		   "&ViewID="+sViewID;
        popComp(sCompID,sCompURL,sParamString,"");
        
        if (sClassifyType == "010") {
        	//��ģ�ͷ��������µ�CLASSIFY_RECORD���FinallyResult�ֶ�.
            RunMethod("WorkFlowEngine","UpdateClassifyModelResult",sSerialNo);
        }
        reloadSelf();
    }

    /*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
    function doSubmit(){
        //����������͡�������ˮ�š����̱�š��׶α�š���������
        var sObjectType = getItemValue(0,getRow(),"ObjectType");
        var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        var sCRSerialNo = getItemValue(0,getRow(),"SerialNo");
        var sFlowNo = getItemValue(0,getRow(),"FlowNo");
        var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
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

        //����ҵ���Ƿ��Ѿ�����ģ������
        var sModeResult = RunMethod("WorkFlowEngine","CheckClassifyModeResult",sCRSerialNo); 
        if(typeof(sModeResult)=="undefined" || sModeResult.length==0) {
            alert("���Ƚ���ģ������");
            return;
        }

        //��ȡ������ˮ��
        var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
        if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
            alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
            return;
        }
        
        //����Ƿ�ǩ�����
        var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
        if(typeof(sReturn)=="undefined" || sReturn.length==0) {
            alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
            return;
        }
        
        //���������ύѡ�񴰿�  ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28 
        var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
            alert(getHtmlMessage('18'));//�ύ�ɹ���
            //����finallyResult�������˷����Ѿ�Ĭ��Ϊ�����µ��˹��϶������ֵ��finallyResult������������ĸ����߼��������и����෽����
            RunMethod("WorkFlowEngine","UpdateClassifyManResult",sCRSerialNo + "," +sTaskNo);
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
        var sObjectType = getItemValue(0,getRow(),"ObjectType"); //"Classify"
        var sSerialNo = getItemValue(0,getRow(),"SerialNo");//�弶����������ˮ��
        var sFlowNo = getItemValue(0,getRow(),"FlowNo");
        var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        var sResultType = "<%=sResultType%>"; //�弶�����ݻ��ͬ 
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }

        //����ҵ���Ƿ��Ѿ�����ģ������
        var sModeResult = RunMethod("WorkFlowEngine","CheckClassifyModeResult",sSerialNo); 
        if(typeof(sModeResult)=="undefined" || sModeResult.length==0) {
            alert("���Ƚ���ģ������");
            return;
        }
        
        //��ȡFlow_Task���е�������ˮ��
        var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sSerialNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
        if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
            alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
            return;
        }
        
        PopComp("SignClassifyOpinionInfo","/Common/WorkFlow/SignClassifyOpinionInfo.jsp","TaskNo="+sTaskNo+"&ResultType="+sResultType+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo,"dialogWidth=700px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
        popComp("ViewClassifyFlowOpinions","/Common/WorkFlow/ViewClassifyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
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