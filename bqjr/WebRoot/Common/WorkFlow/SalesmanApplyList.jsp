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
    String PG_TITLE = "������Ա����"; // ��������ڱ��� <title> PG_TITLE </title>
  
    
    //���ҳ�����	��
    String sViewId = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewId"));//��Ŀ���
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
    	
		var sURL = "/BusinessManage/CollectionManage/SalesmanApplyInfo.jsp";
		AsControl.PopView(sURL, "ObjectType=<%=sObjectType%>&ApplyType=<%=sApplyType%>&FlowNo=<%=sInitFlowNo%>&PhaseNo=<%=sInitPhaseNo%>", "");
		reloadSelf();
    }
    
    /*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
    function cancelApply(){
        //����������͡�������ˮ��
        var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        if(confirm(getHtmlMessage('70'))){ //�������ȡ������Ϣ��
            //RunMethod("WorkFlowEngine","UpdateTransformFlag","0,"+sObjectNo);
            //as_del("myiframe0");
            RunMethod("���÷���", "DelByWhereClause", "Flow_Object,ObjectNo='"+sObjectNo+"'");
            //RunMethod("���÷���", "DelByWhereClause", "Flow_Task,ObjectNo='"+sObjectNo+"'");
            //RunMethod("���÷���", "DelByWhereClause", "Salesman,EmpNo='"+sObjectNo+"'");
            //as_save("myiframe0");  //�������ɾ������Ҫ���ô����
        }
        reloadSelf();
    }

    /*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
    function viewTab(){
    	var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
       
		AsControl.PopView("/BusinessManage/CollectionManage/SalesmanApplyInfo.jsp", "EmpNo="+sObjectNo+"&ViewId=<%=sViewId%>", "");
		reloadSelf();
    }

    /*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
    function doSubmit(){
        //����������͡�������ˮ�š����̱�š��׶α�š��������͡���ͬ��
        var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
        var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
        var sApplyType1 = "<%=sApplyType%>";      
        var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
        var sApplyType = "<%=sApplyType%>";
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
        
        //���������ύѡ�񴰿�     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28
		var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
       /*  var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
        var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
        var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,""); */
        
      	//����Ƿ�ǩ�����
		//sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
        var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");
        var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");
        var sSerialNo = RunMethod("���÷���", "GetColValue", "Billions_Opinion,SerialNo,ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'")
		sReturn = RunMethod("���÷���", "GetCountByWhereClause", "Flow_Opinion,OpinionNo,ObjectNo='"+sObjectNo+"'");
		if(sReturn<=0) {
			//alert(getBusinessMessage('501'));//��ҵ��δǩ�����,�����ύ,����ǩ�������
			alert("�ñ����뻹δǩ�������");
			return;
		}
		//ǩ���Ӧ�����
		AsControl.PopView("/Common/WorkFlow/SignTaskOpinionInfo1.jsp","TaskNo="+sSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewId=<%=sViewId%>","dialogWidth=680px;dialogHeight=650px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

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
    showFilterArea();
    init();
    my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>