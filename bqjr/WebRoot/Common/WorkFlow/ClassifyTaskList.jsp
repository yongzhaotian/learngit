<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
        Author: cbsu 2009-10-12
        Tester:
        Content: ��ҳ����Ҫ�����弶�������������б�
        Input Param:
        Output param:
        History Log: 
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
    
    /*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
    function doSubmit()
    {
        //����������͡�������ˮ�š��׶α��
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        
        //���������ˮ��
        sSerialNo = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
        {
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

        //���������ύѡ�񴰿�     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28 
        sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
            alert(getHtmlMessage('18'));//�ύ�ɹ���
            //����finallyResult�������˷����Ѿ�Ĭ��Ϊ�����µ��˹��϶������ֵ��finallyResult������������ĸ����߼��������и����෽����
            RunMethod("WorkFlowEngine","UpdateClassifyManResult",sObjectNo + "," + sSerialNo);
            //ˢ�¼�����ҳ��
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
                OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
            }else if (sPhaseInfo == "Failure"){
                alert(getHtmlMessage('9'));//�ύʧ�ܣ�
                return;
            }
        }
    }

    /*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
    function signOpinion()
    {
        //����������͡�������ˮ�š����̱�š��׶α��
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        sResultType = "<%=sResultType%>";
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
        {
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }

        //��ȡ������ˮ��
        sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
        if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
            alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
            return;
        }
        
        sCompID = "SignClassifyOpinionInfo";
        sCompURL = "/Common/WorkFlow/SignClassifyOpinionInfo.jsp";
        popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ResultType="+sResultType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&PhaseNo="+sPhaseNo,"dialogWidth=50;dialogHeight=37;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    }

    /*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
    function viewOpinions() 
    {
        //����������͡�������ˮ�š����̱�š��׶α��
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sFlowNo = getItemValue(0,getRow(),"FlowNo");
        sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
        {
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        popComp("ViewClassifyFlowOpinions","/Common/WorkFlow/ViewClassifyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
    }

    /*~[Describe=ģ�ͷ���;InputParam=��;OutPutParam=��;]~*/
    function viewDetail()
    {
        //���ObjectType(�弶����������ͣ�ֵΪ"Classify"),ObjectNo(��ݺŻ��ͬ��),SerialNo(Classify_Record���SerialNo�����弶����������ˮ��)
        //AccountMonth(����·�),ModelNo(�弶��������ģ�ͺ�),ResultType(�弶�����ǽ�ݻ��ͬ��ֵΪ"BusinessDueBill"��"BusinessContract")
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sObjectNo = getItemValue(0,getRow(),"DuebillNo");
        sSerialNo = getItemValue(0,getRow(),"ObjectNo");
        sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        sResultType = "<%=sResultType%>";
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        
        //�����ϲ�����ϳɲ����ַ���
        sCompURL = "/CreditManage/CreditCheck/ClassifyDetail.jsp";
        sCompID = "ClassifyDetails";
        sParameter = "1=1"+
                     "&Action=_DISPLAY_"+
                     "&ClassifyType=080"+ //�������������ȷ������ʾClassifyDetail.jspҳ��ʱ�Ƿ���ʾ"����"��"����"��ť��
                     "&ObjectType="+sObjectType+
                     "&ObjectNo="+sObjectNo+
                     "&SerialNo="+sSerialNo+
                     "&AccountMonth="+sAccountMonth+
                     "&ModelNo=Classify1"+
                     "&ResultType="+sResultType;
        popComp(sCompID,sCompURL,sParameter);
}

    /*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
    function viewTab()
    {
        //���ObjectType(�弶����������ͣ�Ϊ"Classify")�� SerialNo(Classify_Record���SerialNo�����弶����������ˮ��)��sDuebillNo(��ݺŻ��ͬ��), 
        //AccountMonth(����·�),ResultType(�弶�����ǽ�ݻ��ͬ��ֵΪ"BusinessDueBill"��"BusinessContract")
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sSerialNo = getItemValue(0,getRow(),"ObjectNo");
        sDuebillNo = getItemValue(0,getRow(),"DuebillNo");
        sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
        if (typeof(sDuebillNo)=="undefined" || sDuebillNo.length==0)
        {
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        sResultType = "<%=sResultType%>";
        sCompID = "CreditTab";
        sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
        sParamString = "ComponentName=���շ���ο�ģ��&Action=_DISPLAY_&OpenType=Tab&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&SerialNo="+sDuebillNo+"&ResultType="+sResultType+"&DuebillNo="+sDuebillNo+"&AccountMonth="+sAccountMonth+"&ModelNo=Classify1&ClassifyType=080";
        OpenComp(sCompID,sCompURL,sParamString,"_blank","");
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
        if(!confirm(getBusinessMessage('509'))) return; //��ȷ��Ҫ���������˻���һ������
        //����Ƿ�ǩ�����
        sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
        if(typeof(sReturn)=="undefined" || sReturn.length==0){
            //�˻��������
            sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
            //����ɹ�����ˢ��ҳ��
            if (sRetValue == "Commit"){
                OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=�����������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
            }else{
                alert(sRetValue);
            }
        }else{
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
    my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>