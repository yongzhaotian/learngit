<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
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
    <%@include file="./TaskList.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
    /*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
    function signOpinion()
    {
    	 //����������͡�������ˮ�š��׶α��
        sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        sPhaseNo = getItemValue(0,getRow(),"PHASENO");
  //      alert("sObjectType=:"+sObjectType+",sObjectNo=:"+sObjectNo+"sPhaseNo=:"+sPhaseNo);
        //���������ˮ��
        sSerialNo = getItemValue(0,getRow(),"FSerialNo");
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
        

        //���������ύѡ�񴰿�
        sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogPos.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&oldPhaseNo="+sPhaseNo+"&objectNo="+sObjectNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
        
        
        if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
            alert(getHtmlMessage('18'));//�ύ�ɹ���
            //����finallyResult�������˷����Ѿ�Ĭ��Ϊ�����µ��˹��϶������ֵ��finallyResult������������ĸ����߼��������и����෽����
            RunMethod("WorkFlowEngine","UpdateClassifyManResult",sObjectNo + "," + sSerialNo);
            //ˢ�¼�����ҳ��
            top.reloadSelf();
        }else if (sPhaseInfo == "Failure"){
            alert(getHtmlMessage('9'));//�ύʧ�ܣ�
            return;
        }else{
            sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogPos.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
            //����ύ�ɹ�����ˢ��ҳ��
            if (sPhaseInfo == "Success"){
                alert(getHtmlMessage('18'));//�ύ�ɹ���
                //ˢ�¼�����ҳ��
                top.reloadSelf();
            }else if (sPhaseInfo == "Failure"){
                alert(getHtmlMessage('9'));//�ύʧ�ܣ�
                return;
            }
        }
    }



    /*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
    function viewTab(){
    	var sApplySerialNo = getItemValue(0,getRow(),"ApplySerialNo");
    	var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
    	var sSNo = getItemValue(0,getRow(),"RetativeStoreNo");
    	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    	var sMobilePosNo = getItemValue(0,getRow(),"MobilePosNo");
        if (typeof(sApplySerialNo)=="undefined" || sApplySerialNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
 
		AsControl.PopView("/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosInfoDetail.jsp", "ApplySerialNo="+sApplySerialNo+"&ObjectNo="+sObjectNo+"&MobilePosNo="+sMobilePosNo+"&PhaseNo="+sPhaseNo+"&sNo="+sSNo, "");
		reloadSelf();
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