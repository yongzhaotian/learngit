<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.6
		Tester:
		Content: ��ҳ����Ҫ����ҵ����ص���������б�
		Input Param:
		Output param:
		History Log: 
			2005.08.03 jbye    �����޸�������������Ϣ
			2005.08.05 zywei   �ؼ�ҳ��
			xswang 20150427 CCS-173 ��������ͣ��ͬ���͡��ָ���ͬ������
			xswang 20150615 CCS-900 ����е������ܱ���ͣ
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
	<%@include file="/Common/WorkFlow/TaskNewList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	var sFlowNo = "<%=sFlowNo%>";
	var sPhaseNo = "<%=sPhaseNo%>";
	var sUserID = "<%=CurUser.getUserID()%>";
	/*~[Describe=�ύ����;InputParam=��;OutPutParam=��;]~*/
	function doSubmit(){
		//����������͡�������ˮ�š��׶α��
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
		var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("��ҵ����׶������Ѿ��ύ�������ٴ��ύ��");//��ҵ����׶������Ѿ��ύ�������ٴ��ύ��
			reloadSelf();
			return;
		}
		
		//���������ύѡ�񴰿�	     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28	
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = "";
		if(sFlowNo=="CarFlow"){
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}else{
			sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommit","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		}	
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			
			//ˢ�¼�����ҳ��
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}else if (sPhaseInfo == "Failure9000") {
			alert("�������Ѿ�ȡ��!");
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
	
	function cancelTask(){
		//����������͡�������ˮ�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sUserID = "<%=CurUser.getUserID()%>";
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		
		//���������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("��ҵ����׶������Ѿ��ύ������ȡ����");
			reloadSelf();
			return;
		}
				

		//���������ύѡ�񴰿�	     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28	
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sRet = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","CancelTask","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID+",FlowNo="+sFlowNo);
		if(sRet == 'Success'){
			alert("�����ɹ�");
		}else{
			alert("����ʧ��");
		}
		return;
		
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//�ύ�ɹ���
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
				alert("ȡ���ɹ���");//ȡ���ɹ���
				//ˢ�¼�����ҳ��
				OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}
	}

	//��ȡ���������
	function getTask(){
	
		// ����δ������
		ReloadNotice();
		
		var sFlows = sFlowNo.split(",");
		var sFl = "";
		for(var i=0; i < sFlows.length; i++){
			sFl += sFlows[i]+"@";
		}
		sFl = sFl.substring(0, sFl.length-1);
		var sObjectNo = "";//��ͬ���
		
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getTask","flowNo="+sFl+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		if(sReturn == "FailError"){
			alert("��ǰ��δ����������봦������ٻ�ȡ������");
			return;
		}else if(sReturn != "Failure"){
			RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctFlowNotMatch", "sObjectNo="+sReturn.split("@")[0]+"");
			//ˢ�¼�����ҳ��
			//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMainNew.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			sReturn = sReturn.split("@");
			sObjectNo = sReturn[0];
		    //----------��ӡ�����begin---------------
			 printTable("ApplySettle",sObjectNo);//���ô�ӡ�߼���ӡ
		    //-------��ӡ�����end---------
			 signCheckOpinionOne(sObjectNo,"<%=CurUser.getUserID()%>");
		}else{
			alert("û�п��Ի�õ�����");
			return;
		}
	}
	// ��������
    function ReloadNotice(){
    	<%/*~begin�жϵ�¼���flagΪ2���ǹ���Աֻ��ʾ�˵��������淴ֻ֮�����治��ʾ�˵�add CSS-225���Ա��ݽ��뵯��������ҳ��   20150519 huzp~~���������jira�г���flag=2���ж�*/%>
 	    <%/*~begin�жϵ�¼���orgΪ11������˲������� add CSS-913���Ա��ݽ��뵯��������ҳ��   20150701 huzp~*/%>
 	    if('<%=CurUser.getOrgID()%>'=='11'){
 	    	var UserId = "<%=CurUser.getUserID()%>";
 	    	//�����¹����򵯳����棬���򲻵�������
 	    	//add by byang CCS-1252	���Ƶ�������Ϊ�����ŵķ����Ĺ���
 	    	var userOrg = "<%=CurUser.getOrgID()%>";
 	    	var count= RunMethod("Unique","uniques","notice_info,count(1),noticeid not in (select t.noticeid  from USER_NOTICE t  where t.isflag = '1' and t.UserID = '"+UserId+"') and InputOrg='"+userOrg+"'");
 	    	if(count>0){
 	    		UpNotice();
 	    	}
 	    }
 	    <%/*~end~*/%>
    }
    /******************add CSS-225���Ա��ݽ��뵯��������ҳ��   20150515 huzp***/
	//�����ҳ��,Ȩ��Ϊ���Աʱ����������
	function UpNotice(){//CCS-960  ���Ҫ�㼰��˹���������޷��������塢��С����ɫ���Ӵֵȹ��ܣ�����Ӹ������塢��С����ɫ���Ӵ�  update huzp 20150804
		AsControl.PopView("/Common/WorkFlow/UpNoticeList.jsp", "identtype=01", "dialogWidth=850px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*********************end***************************************/
	
	
	//�������˻������
	function returnToPool(){
		//���������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","returnToPool","objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",objectType="+sObjectType);
		if(sReturn == "Success"){
			//ˢ�¼�����ҳ��
			OpenComp("ApproveMain","/Common/WorkFlow/ApproveMainNew.jsp","ComponentName=����ҵ������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
			alert("�˻�����سɹ�");
			}else{
				alert("�˻������ʧ��");
			}
		
	}
	
	//ǩ�����
	function signCheckOpinionOne(sObjectNo, userID){
		sSortReturn = RunMethod("BusinessManage","getFlowSerialno",sObjectNo+","+userID);
		sSortReturn = sSortReturn.split("@");

		//���������ˮ��
		var sSerialNo = sSortReturn[0];
		var sObjectNo = sSortReturn[1];
		var sObjectType = sSortReturn[2];
		var sFlowNo1 = sSortReturn[3];
		var sPhaseNo1 = sSortReturn[4];
		//alert("|"+sSerialNo+"|"+sObjectType+"|"+sObjectNo+"|"+sFlowNo1+"|"+sPhaseNo1+"|");
		
		//����"�����"��־;���ѻ�ȡ��δ�������ť�����񣬳�����Сʱ���Զ����˵������
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
		if(sReturn!=="Success"){
			alert("����'�����'��־����!");
			return;
		}
		
		// ȥ������������
		/* if(sFlowNo=="CarFlow"){
			doSubmit();
			return;
		} */
		
		var sCancelApply = RunMethod("WorkFlowEngine","QueryCancelApply",sObjectNo);
		if(sCancelApply == "100"){
			alert("�������ѱ�ȡ��");
			reloadSelf();
			return;
		}

		//add �ֽ������
		var sProductID = RunMethod("PublicMethod","GetColValue","productid,business_contract,String@SerialNo@"+sObjectNo);
		if(null == sProductID){
			 sProductID = "";
		}else{
			if("020" == sProductID.split("@")[1])
			{
				SignOpinionForCashLoan(sObjectType,sObjectNo,sSerialNo,sFlowNo1,sPhaseNo1);
				return;
			}
		}
		//end
		
		var OpenStyle = "width=1000px,height=600px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
		var sCompURL = "";
		//sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoViewLR.jsp";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoView.jsp";
		
		//sReturn = OpenComp("SignTaskOpinionInfoViewLR",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
		sReturn = OpenComp("SignTaskOpinionInfoView",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo1+"&PhaseNo="+sPhaseNo1,"_self");
		//sReturn = AsControl.OpenPage(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self",OpenStyle);
		//���ҳ��TAB��ʽչʾ
		//sReturn = parent.addtabCompent("","���ѽ������ҳ��","AsControl.OpenComp('"+sCompURL+"','ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ViewID=001','TabContentFrame')");
		
		//alert(sReturn);
		//sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
		//����ύ�����������Լ������������ҳ��
		while(typeof(sReturn)!="undefined" && sReturn =='SameUser'){
			//����'�����'��־
			RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
			
			sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			//sReturn = AsControl.OpenView(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle, "_self");
			//sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
			//alert(sReturn);
		}
		//reloadSelf();
		//parent.reloadSelf();
	}

	//ǩ�����
	function signCheckOpinion(){
		//���������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		// edit by xswang 20150615 CCS-900 ����е������ܱ���ͣ
		/* // add by xswang 20150427 CCS-173 ��������ͣ��ͬ���͡��ָ���ͬ������
		// �Ӻ�ͬ����ȡ��ǰ��ͬ�ġ�cancelstatus����ʶ
		var sReturn1 = RunMethod("BusinessManage", "SelectContractCancelStatus",sObjectNo);
		if("1" == sReturn1){
			alert("�ú�ͬ�ѱ���ͣ�������ύ");
			return;
		}
		// end by xswang 20150427 */
		// end by xswang 20150615		
		
		//����"�����"��־;���ѻ�ȡ��δ�������ť�����񣬳�����Сʱ���Զ����˵������
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
		if(sReturn!=="Success"){
			alert("����'�����'��־����!");
			return;
		}
		
		if(sFlowNo=="CarFlow"){
			doSubmit();
			return;
		}
		
		var sCancelApply = RunMethod("WorkFlowEngine","QueryCancelApply",sObjectNo);
		if(sCancelApply == "100"){
			alert("�������ѱ�ȡ��");
			reloadSelf();
			return;
		}

		//add �ֽ������
		var sProductID = getItemValue(0,getRow(),"ProductID");
		if("020" == sProductID)
		{
			SignOpinionForCashLoan(sObjectType,sObjectNo,sSerialNo,sFlowNo,sPhaseNo);
			return;
		}
		//end
		
		var OpenStyle = "width=1000px,height=600px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
		var sCompURL = "";
		//sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoViewLR.jsp";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoView.jsp";
		
		//sReturn = OpenComp("SignTaskOpinionInfoViewLR",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
		sReturn = OpenComp("SignTaskOpinionInfoView",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
		//sReturn = AsControl.OpenPage(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self",OpenStyle);
		//���ҳ��TAB��ʽչʾ
		//sReturn = parent.addtabCompent("","���ѽ������ҳ��","AsControl.OpenComp('"+sCompURL+"','ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ViewID=001','TabContentFrame')");
		
		//alert(sReturn);
		//sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
		//����ύ�����������Լ������������ҳ��
		while(typeof(sReturn)!="undefined" && sReturn =='SameUser'){
			//����'�����'��־
			RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
			
			sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			//sReturn = AsControl.OpenView(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle, "_self");
			//sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
			//alert(sReturn);
		}
		//reloadSelf();
		//parent.reloadSelf();
	}
	
	//ǩ�����1
	function signCheckOpinionNew(Serialno,ObjectNo,ObjectType,FLowNo,PhaseNo){
		//���������ˮ��
		var sSerialNo = Serialno;
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		var sObjectType = ObjectType;
		var sObjectNo = ObjectNo;		
		var sFlowNo = FLowNo;
		var sPhaseNo = PhaseNo;
		//����"�����"��־;���ѻ�ȡ��δ�������ť�����񣬳�����Сʱ���Զ����˵������
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
		if(sReturn!=="Success"){
			alert("����'�����'��־����!");
			return;
		}
		
		if(sFlowNo=="CarFlow"){
			doSubmit();
			return;
		}
		//add �ֽ������
		var sProductID = RunMethod("PublicMethod","GetColValue","productid,business_contract,String@SerialNo@"+sObjectNo);
		if(null == sProductID){
			 sProductID = "";
		}else{
			if("020" == sProductID.split("@")[1])
			{
				SignOpinionForCashLoan(sObjectType,sObjectNo,sSerialNo,sFlowNo,sPhaseNo);
				return;
			}
		}
		//end
		var OpenStyle = "width=1000px,height=600px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
		var sCompURL = "";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoViewLR.jsp";
		//sReturn = AsControl.OpenView(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle, "_self");
		sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
		//����ύ�����������Լ������������ҳ��
		while(typeof(sReturn)!="undefined" && sReturn =='SameUser'){
			//����'�����'��־
			RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
			
			sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			//sReturn = AsControl.OpenView(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle, "_self");
			sReturn = AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"",OpenStyle);
			//alert(sReturn);
		}
		//reloadSelf();
		//parent.reloadSelf();
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
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	function printTable(type,sObjectNo){
		
		var sUserID = "<%=CurUser.getUserID()%>";
		var sOrgID = "<%=CurOrg.getOrgID()%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//CCS-316 ��Ҫ���ݺ�ͬ״̬���ƿ��ٲ�ѯ��İ�ť     add by Roger 2015/03/09
		var sContractStatus=getItemValue(0,getRow(),"ContractStatus");
		    if(sContractStatus == "060" || sContractStatus == "070"){   //�·���������к�ͬ����admin�������˶����ܴ�ӡ��ͬ
		    	//������Ա��ɫ�����Ȩ 
		    	if(!<%=CurUser.hasRole(new String[]{"000","099","1000"})%>){
		    		alert("ֻ�й���Ա���ܵ��ĸñʺ�ͬ");
		    		return;
		    	}
	    }
		
		var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
		if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
			alert("����ϵϵͳ����Ա����ͬģ�����úͺ�ͬ��Ϣ!");
			return;
		}
		var sDocID = 	returnValue.split("@")[0];
		var sUrl = returnValue.split("@")[1];
		var sObjectType = type;
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			//������֪ͨ���Ƿ��Ѿ�����
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //δ���ɳ���֪ͨ��
				//���ɳ���֪ͨ��	
					PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
				//��¼���ɶ���
				RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID="+sOrgID+",userID="+sUserID+",occurType=produce");
			}else{
				//��¼�鿴����
				RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID="+sOrgID+",userID="+sUserID+",occurType=view");
			}
			//��ü��ܺ�ĳ�����ˮ��
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//ͨ����serverlet ��ҳ��
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}
}
//   ============================== end  ��ӡ��ʽ������ ============================================================

	/*~[Describe=�鿴����� ;InputParam=��;OutPutParam=��;]~*/
	function viewApplyTable () {
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		 printTable("ApplySettle",sObjectNo);//���ô�ӡ�߼���ӡ
	}
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function viewTab(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sCompID = "CreditTab";
		var sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		var sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sFlowNo=="PutOutFlow" && sPhaseNo != "0035") {
			sParamString += "&ViewID=002";
		}
		
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	
	/*~[Describe=�˻�ǰһ��;InputParam=��;OutPutParam=��;]~*/
	function backStep(){
		//��ȡ������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sUserID = "<%=CurUser.getUserID()%>";
		if(typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
    		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    		return;
		}
		if(!confirm(getBusinessMessage('509'))) return; //��ȷ��Ҫ���������˻���һ������
		//����Ƿ����˻�
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","cancelCheck","serialNo="+sSerialNo+",userID="+sUserID);
		if(sReturn != "Success"){
			alert("��һ���а��˲��ǵ�ǰ�û����������˻�");
			return;
		}else{
			sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","goBack","serialNo="+sSerialNo+",userID="+sUserID);
			if(sReturn =='Success'){
				alert("�˻سɹ���");
			}else{
				alert("�˻���һ��ʧ��!");
			}
			reloadSelf();
			return;
		}
		//����Ƿ�ǩ�����
		//var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0){
			//�˻��������   	
			var sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//����ɹ�����ˢ��ҳ��
			if(sRetValue == "Commit"){
				//OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=�����������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","")
				reloadSelf();
			}else{
				alert(sRetValue);
			}
		}else{
			alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
			return;
		}
	}
	
	/*~[Describe=�����ջ�;InputParam=��;OutPutParam=��;]~*/
	function takeBack(){
		//��ȡ������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined"||sSerialNo.length == 0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//�ջ��������
		var sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�ջ��������","dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		//����ɹ�����ˢ��ҳ��
		if (sRetValue == "Commit"){
		    OpenComp("ApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=�����������&ComponentType=MainWindow&ApproveType=<%=sApproveType%>","_top","");
		}		
	}
	
	/*~[Describe=�Զ�����̽��;InputParam=��;OutPutParam=��;]~*/
	function riskSkan(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		//���з�������̽��
		autoRiskScan("001","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,20);
		//sReturn=RunMethod("BusinessManage","CheckApplyRisk",sObjectType+","+sObjectNo);
		//if(typeof(sReturn) != "undefined" && sReturn != "") 
			//PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
	}
	
	/*~[Describe=�鿴��ְ���鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewReport(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sDocID = AsControl.RunJsp("/FormatDoc/ReportTypeSelect.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType);
		if (typeof(sDocID)=="undefined" || sDocID.length==0){
			alert(getBusinessMessage('505'));//��ְ���鱨�滹δ��д��������д��ְ���鱨���ٲ鿴��
			return;
		}
		
		var sReturn = AsControl.RunJsp("/FormatDoc/GetReportFile.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID);
		if (sReturn == "false"){
			alert("��ְ���鱨�滹δ���ɣ��������ɾ�ְ���鱨���ٲ鿴��");
			return;  
		}
				
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
		OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
	}
	//add by cdeng  2009-02-17  ���Ӳ鿴������ʷ��ť
	function flowHistory(){
		 //��ȡ������ˮ��
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectNo) == "undefined" || sObjectNo.length == 0){
    		alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    		return;
		}
		OpenComp("FlowSubList","/Common/WorkFlow/FlowSubList.jsp","PhaseNo="+sPhaseNo+"&ObjectNo="+sObjectNo+"&FlowNo="+sFlowNo+"&ObjectType="+sObjectType,"_blank");
	}

	/*~[Describe=����ͼ��չʾ;InputParam=��;OutPutParam=��;]~*/
	//add by yxzhang 2010-04-09  ���ڲ鿴����ͼ
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
	
	 /*~[Describe=�绰¼��;InputParam=��;OutPutParam=��;]~*/
	function getPhoneCode()
	{
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		
	 }

	//add �ֽ������
	//ǩ�������copy���Ѵ�ǩ�������
	function SignOpinionForCashLoan(sObjectType,sObjectNo,sSerialNo,sFlowNo,sPhaseNo)
	{
		/* var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo"); */
		
		var OpenStyle = "width=1000px,height=600px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		var sCompURL = "";
		sCompURL = "/CreditManage/CashLoan/CashLoanOpinionInfoView.jsp";
		
		sReturn = OpenComp("CashLoanOpinionInfoView",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
		//����ύ�����������Լ������������ҳ��
		while(typeof(sReturn)!="undefined" && sReturn =='SameUser'){
			//����'�����'��־
			RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","setClicked","objectNo="+sObjectNo+",serialNo="+sSerialNo+",objectType="+sObjectType);
			
			sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
		}
	}
	
	function initRow(){
		setTimeout("reloadSelf()",10000);
		
	}
	
	//end
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	//initRow();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>




<%@ include file="/IncludeEnd.jsp"%>