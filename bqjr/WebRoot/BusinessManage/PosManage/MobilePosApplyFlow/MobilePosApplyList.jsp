<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
    <%
    /*
    Content: ��ҳ����Ҫ������ص������б�����϶��������б��϶��е������б��϶�ͨ���������б�
    Input Param:
    Output param:
    History Log:
    */
    %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = ""; // ��������ڱ��� <title> PG_TITLE </title>
    %>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
    <%@include file="./ApplyList.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
    <script type="text/javascript">
	
	function AppDetail(){
	}
	function backStep(){
	}

    
    /*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
    function newApply(){
    	var sURL = "/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosInfoDetail.jsp";
    	var ssObjectType="<%=sObjectType%>";
    	
		AsControl.PopView(sURL, "ObjectType=<%=sObjectType%>&ApplyType=<%=sApplyType%>&FlowNo=<%=sInitFlowNo%>&PhaseNo=<%=sInitPhaseNo%>", "");
		reloadSelf();
    }
    
    /*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
    function cancelApply(){
        //����������͡�������ˮ��
       var sApplySerialNo = getItemValue(0,getRow(),"ApplySerialNo");
        if (typeof(sApplySerialNo)=="undefined" || sApplySerialNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        
        if(confirm(getHtmlMessage('70'))){ //�������ȡ������Ϣ��
        	RunMethod("���÷���","DelByWhereClause","mobilepos_info,APPLYSERIALNO='"+sApplySerialNo+"'");
            as_del("myiframe0");
            as_save("myiframe0");  //�������ɾ������Ҫ���ô����
        }
    }

    
    /*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
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
 	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
    function doSubmit(){
        //����������͡�������ˮ�š����̱�š��׶α�š���������
        var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
        var sApplySerialNo = getItemValue(0,getRow(),"ApplySerialNo");
        var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
        var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
        var sMobilePosNo = getItemValue(0,getRow(),"MobilePosNo");
     //   alert("sObjectType="+sObjectType+"��sObjectNo="+sObjectNo+"��sApplySerialNo="+sApplySerialNo+"��sFlowNo="+sFlowNo+"��sPhaseNo="+sPhaseNo);
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        
		var sCount = RunMethod("���÷���", "GetColValue", "DOC_ATTACHMENT,count(1),OBJECTNO='"+sObjectNo+"'");
		if(sCount=="0.0"){
			alert("�����ϴ�������Ϣ��");
			return;
		}
		var sSalCount = RunMethod("���÷���", "GetColValue", "MOBLIEPOSRELATIVESALMAN,count(1),posno='"+sMobilePosNo+"'");
		if(sSalCount=="0.0"){
			alert("���ȹ���������Ա��");
			return;
		}
		var sProductCount = RunMethod("���÷���", "GetColValue", "MOBILEPOSRELATIVEPRODUCT,count(1),posNo='"+sMobilePosNo+"'");
		if(sProductCount=="0.0"){
			alert("���ȹ�����Ʒ��");
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

     //   alert("sTaskNo"+sTaskNo);
        //���������ύѡ�񴰿�
        var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogPosPrimary.jsp?SerialNo="+sTaskNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
 //       alert("sPhaseInfo"+sPhaseInfo);
        if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		
        else if (sPhaseInfo == "Success"){
            alert(getHtmlMessage('18'));//�ύ�ɹ���
            //����finallyResult�������˷����Ѿ�Ĭ��Ϊ�����µ��˹��϶������ֵ��finallyResult������������ĸ����߼��������и����෽����
           	RunMethod("���÷���","UpdateColValue","MOBILEPOS_INFO,Status,02,SerialNo = '"+sObjectNo+"'");
            reloadSelf();
        }else if (sPhaseInfo == "Failure"){
            alert(getHtmlMessage('9'));//�ύʧ�ܣ�
            return;
        }else{
  //     	alert("33333");
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
        var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE"); 
        var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
        var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
        var sPhaseNo = getItemValue(0,getRow(),"PHASENO");       
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
        
        PopComp("SignClassifyOpinionInfo","/Common/WorkFlow/SignClassifyOpinionInfo.jsp","TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&PhaseNo="+sPhaseNo,"dialogWidth=700px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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