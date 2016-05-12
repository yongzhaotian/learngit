<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sObjectType = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("PhaseNo"));
	String sFlowNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("FlowNo"));
	
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	
	//��ȡ���µ��ֶ�����
	String sSql = "select Max(SerialNo) as SerialNo from FLow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo";
	sSerialNo = Sqlca.getString(new SqlObject(sSql)
			.setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sFlowNo));
	sSql = "select PhaseNo from Flow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo and SerialNo =:SerialNo";
	sPhaseNo = Sqlca.getString(new SqlObject(sSql)
			.setParameter("ObjectNo", sObjectNo).setParameter("FlowNo", sFlowNo).setParameter("SerialNo", sSerialNo));
	
	String sCustomerID = Sqlca.getString("select customerid from Business_Contract where SerialNo = '"+sObjectNo+"'");
	//
	String sCheckPoint = Sqlca.getString("select checkpoint from FLOW_MODEL where flowNo='"+sFlowNo+"' and PhaseNo='"+sPhaseNo+"'");
	if(sCheckPoint == null) sCheckPoint = "";
	
%>
<!-- 
	<textarea type=textfield  bgcolor="#FDFDF3" readonly style='width:100%;height:100px;resize: none;'>
�����Ҫ����ʾ����<%="\r\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sCheckPoint%>
	</textarea>
	 -->
<%
	
	
	String sDoNo = "SignTaskOpinionInfo";
	/* �Ƿ���Ҫ����ҳ��ѡ����� */
	boolean needPage = false;
	//��ʱ�Ѹ����׶ε���ʾģ�������õ�PHASEATTRIBUTE�ֶ���(��Ӧ���������е�'�׶�����')
	/* {DONO:xxxInfo}{NEEDPAGE:true}  */
	String str = Sqlca.getString("select PHASEDESCRIBE from FLOW_MODEL where flowNo='"+sFlowNo+"' and PhaseNo='"+sPhaseNo+"' and PHASEDESCRIBE is not null  ");
	System.out.println("*********"+str);
	if( ! StringX.isEmpty(str)){
		String[] strs = StringX.parseArray(str);
		for(String s: strs){
			String tempStr = s.replace(" ", "");
			if(tempStr.substring(0, 4).equalsIgnoreCase("DONO")){
				sDoNo = tempStr.substring(5);
			}else if(tempStr.substring(0,8).equalsIgnoreCase("NEEDPAGE")){
				needPage = StringX.parseBoolean(tempStr.substring(9));
			}
		}
	}
	
	
	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sDoNo,Sqlca);
	
	// ר����������û��ֶ�
	if ("0140".equals(sPhaseNo) && "WF_MEDIUM02".equals(sFlowNo)) {
		doTemp.setVisible("InputUserName,InputTime,InputOrgName", false);
	}
	
	//PBOC���ȡ�������ʾ
	boolean bFlow = true;
	String sPhasename = Sqlca.getString(new SqlObject("select PhaseName from FLow_Model where FlowNo = :Flowno and PhaseNo =:PhaseNo")
					.setParameter("Flowno", sFlowNo).setParameter("PhaseNo", sPhaseNo));
	if(sPhasename.startsWith("PBOC")){
		bFlow =false;
	}
	
	
	//��ͥ��Ա����˲�   ���ѡ��
	if ("0080".equals(sPhaseNo) && "WF_HARD".equals(sFlowNo) && "HomePhoneInfoOpinionInfo".equalsIgnoreCase(sDoNo)) {
		doTemp.setVRadioCode("PhaseOpinion", "FamilyMemberPhoneInfoCheck");
	}
	
	//����ASDataWindow����		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform��ʽ
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"false","","Button","ɾ��","ɾ�����","deleteRecord()",sResourcesPath},
			{"true","","Button","���Ҫ��","�鿴���Ҫ��","viewApprove()",sResourcesPath},
			{"true","","Button","��������","�鿴����","viewTab()",sResourcesPath},
			{"true","","Button","�˻�ǰһ��","�˻�����","backStep()",sResourcesPath},
			{"true","","Button","��һ����֤","�ύ����","doSubmit()",sResourcesPath},
			{"true","","Button","�鿴���","�鿴���","viewOpinions()",sResourcesPath},
			{"true","","Button","�绰�ֿ�","�鿴�绰�ֿ�","getPhoneCode()",sResourcesPath},
			{"false","","Button","����¼��","����¼��","playTape()",sResourcesPath},
			{"true","","Button","�鿴��Ƭ","�鿴��Ƭ","viewImage()",sResourcesPath},
			{"true","","Button","ȡ������","ȡ������","cancelApply()",sResourcesPath},
			{"true","","Button","����绰","����绰","btnMakeCall_Click()",sResourcesPath},
			{"true","","Button","Ӱ�����","Ӱ�����","imageManage()",sResourcesPath},
			{"true","","Button","�鿴�����","�鿴�����","creatApplyTable()",sResourcesPath},
	};
	
	if ("0140".equals(sPhaseNo) && "WF_MEDIUM02".equals(sFlowNo)) sButtons[9][0] = "true";
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<embed name="3_devUnknown" id="3_devUnknown" src="E:\123.wma" type="audio/x-wav" hidden="true" autostart="false" loop="false"/>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	 /*~[Describe=Ӱ�����;InputParam=��;OutPutParam=��;]~*/
    function imageManage(){
        var sObjectNo   = "<%=sObjectNo%>";
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
     var param = "ObjectType=Business&TypeNo=20&RightType=100&ObjectNo="+sObjectNo;
     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
//	   var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
//	   AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
     
    }
	
	function saveRecord(sPostEvents){
		var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0) {
			var sOpinionNo = getSerialNo("FLOW_OPINION", "OpinionNo", "");
			setItemValue(0,getRow(),"OpinionNo",sOpinionNo);
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function chick(){
		var sPhaseOpinion = getItemValue(0,getRow(),"PhaseOpinion");
		if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
			alert("δѡ�������");
			return true;
		}
	}
	
	//
	function svresult(){
		var sResult = getItemValue(0,getRow(),"SVRESULT");

		if(sResult=="01"){//�ܾ�  
			setItemRequired(0,0,"PhaseOpinion",true);
		}else if(sResult=="02"){//ͨ��
			setItemRequired(0,0,"PhaseOpinion",false);
		}else{
			setItemRequired(0,0,"PhaseOpinion",false);
		}
		
		
	}
	
	/*~[Describe=ɾ����ɾ�����;InputParam=��;OutPutParam=��;]~*/
    function deleteRecord()
    {
	    var sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0){
	   		alert("����û��ǩ�������������ɾ�����������");
	 	}
	 	else if(confirm("��ȷʵҪɾ�������"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("���ɾ���ɹ�!");
	  		}
	   		else
	   		{
	    		alert("���ɾ��ʧ�ܣ�");
	   		}
			reloadSelf();
		}
	} 
	
    /*~[Describe=�ύҵ��;InputParam=��;OutPutParam=��;]~*/
    function doSubmit()
	{
		//����������͡�������ˮ�š��׶α��
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var OrgID = "<%=CurUser.getOrgID()%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sDoNo = "<%=sDoNo%>";
		var needPage = <%=needPage%>;
		//���������ˮ��
		var sSerialNo = "<%=sSerialNo%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ�� 
			return;
		}
		
		//  ��ȡid5�绰
		/* var sId5 = getItemValue(0, 0, "PhaseOpinion3");
		var sIdOpinion = getItemValue(0, 0, "PhaseOpinion");
		alert("|"+sId5+"|" + typeof sId5 + "|"+sIdOpinion+"|"+typeof sIdOpinion + "|");
		return; */
		
		//����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ���
		var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		var sCancelApply = RunMethod("WorkFlowEngine","QueryCancelApply",sObjectNo);
		
		var sCreditReport=getItemValue(0,getRow(),"CreditReport");
		var sCreditNum=getItemValue(0,getRow(),"CreditNum");
		var sCreditLimit=getItemValue(0,getRow(),"CreditLimit");
		var sUseLimit=getItemValue(0,getRow(),"UseLimit");
		var sCreditStatus=getItemValue(0,getRow(),"CreditStatus");
		var sIsNormalCredit=getItemValue(0,getRow(),"IsNormalCredit");
		var sOverDueMonthCredit=getItemValue(0,getRow(),"OverDueMonthCredit");
		var sPutoutAccount=getItemValue(0,getRow(),"PutoutAccount");
		var sPutoutSum=getItemValue(0,getRow(),"PutoutSum");
		var sIsNormalPutout=getItemValue(0,getRow(),"IsNormalPutout");
		var sOverDueMonthPutout=getItemValue(0,getRow(),"OverDueMonthPutout");
		var sSuccessDate=getItemValue(0,getRow(),"SuccessDate");
		var sQueryTime1=getItemValue(0,getRow(),"QueryTime1");
		var sQueryTime2=getItemValue(0,getRow(),"QueryTime2");
		var sPhoneNumber=getItemValue(0,getRow(),"PhoneNumber");
		
		if(sCreditReport=="1"){
			if (typeof(sCreditNum)=="undefined" || sCreditNum.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sCreditLimit)=="undefined" || sCreditLimit.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sUseLimit)=="undefined" || sUseLimit.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sCreditStatus)=="undefined" || sCreditStatus.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sIsNormalCredit)=="undefined" || sIsNormalCredit.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sOverDueMonthCredit)=="undefined" || sOverDueMonthCredit.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sPutoutAccount)=="undefined" || sPutoutAccount.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sPutoutSum)=="undefined" || sPutoutSum.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sIsNormalPutout)=="undefined" || sIsNormalPutout.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sOverDueMonthPutout)=="undefined" || sOverDueMonthPutout.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sSuccessDate)=="undefined" || sSuccessDate.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sQueryTime1)=="undefined" || sQueryTime1.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sQueryTime2)=="undefined" || sQueryTime2.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
			if (typeof(sPhoneNumber)=="undefined" || sPhoneNumber.length==0){
				alert("��Ϣ������,������"); 
				return;
			}
		}
		
		
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			if(sCancelApply == "100"){
				alert("�������ѱ�ȡ��");
				window.close();
				return;
			}else{
				alert("��ҵ����׶������Ѿ��ύ�������ٴ��ύ��");//��ҵ����׶������Ѿ��ύ�������ٴ��ύ��
				reloadSelf();
				return;
			}
		}
		if(sCancelApply == "100"){
			alert("�������ѱ�ȡ��");
			window.close();
			return;
		}
		
		if(<%=bFlow%>){
			var sPhaseOpinion = getItemValue(0,getRow(),"PhaseOpinion");
			if(typeof(sPhaseOpinion)=="undefined" || sPhaseOpinion.length==0){
				alert("δѡ�������");
				return true;
			} else {
				
				if (sPhaseOpinion=="060" && "ID5PhoneOpinionInfo"==="<%=sDoNo%>") {
					var sId5 = getItemValue(0, 0, "PhaseOpinion3");
					if (! (sId5 && CheckPhoneCode(sId5))) {
						//alert(sId5 + "|" +sId5.replace(/(\s+|[A-Za-z])/g, ""));
						alert("��������ȷ��ID5�绰����");
						return;
					} 
				}
			}
		}
		
		saveRecord();
		
		//PBOC�׶β��������
		if(!<%=bFlow%>){
			var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
			sReturn= RunMethod("BusinessManage","InsertOpinion","PBOC�Ѽ��,<%=sSerialNo%>,"+sOpinionNo+",<%=sObjectNo%>,<%=sObjectType%>,"+sUserID+","+OrgID);
		}
		
		//���������ύѡ�񴰿�	     ���Ӳ������ݣ���ֹ�ظ��ύ by yzheng,qxu 2013/6/28	
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = "";
		if(needPage){
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}else{
			sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoFlagCommint","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		}
		
		// ���º�ͬ״̬
		RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctBCStatus", "sObjectNo="+sObjectNo+"");
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			
			//alert(getHtmlMessage('18'));//�ύ�ɹ���	// comment by tbzeng 2014/05/03 ȥ���ύ�ɹ���ʾ��
			//top.close();
			/* var sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			var sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			
			var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
			AsControl.PopComp(sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,OpenStyle); */
			var isSameUser = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","sameUser","objectNo="+sObjectNo+",objectType="+sObjectType+",userID=<%=CurUser.getUserID()%>");
			//alert(isSameUser);
			
			if(isSameUser=="Yes"){
				window.returnValue = "SameUser";
				//var sCompURL = "";
				//sCompURL = "/Common/WorkFlow/SignTaskOpinionInfoNew.jsp";
				//sReturn = OpenComp("SignTaskOpinionInfoViewLR",sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_self");
				parent.reloadSelf();
			}else{
				window.returnValue = "NotSameUser";
				parent.parent.reloadSelf();
			}
			//window.close();

			//ˢ�¼�����ҳ��
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
				
				}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
		}
		
	}
    
    /*~[Describe=�绰¼��;InputParam=��;OutPutParam=��;]~*/
	function getPhoneCode()
	{
		var sCustomerID="<%=sCustomerID%>";
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
		sReturn = sReturn.split("@");
		
	 }
    
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sFlowNo = "<%=sFlowNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=�˻�ǰһ��;InputParam=��;OutPutParam=��;]~*/
	function backStep(){
		//��ȡ������ˮ��
		var sSerialNo = "<%=sSerialNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		//����Ƿ����˻�
		var sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","cancelCheck","serialNo="+sSerialNo+",userID="+sUserID);
		if(sReturn != "Success"){
			alert("��һ���а��˲��ǵ�ǰ�û����������˻�");
			return;
		}else{
			sReturn = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","goBack","serialNo="+sSerialNo+",userID="+sUserID);
			if(sReturn =='Success'){
				window.returnValue = "SameUser";
				window.close();
				parent.reloadSelf();
			}else{
				window.returnValue = "NotSameUser";
			}
			return;
		}
		//����Ƿ�ǩ�����
		//var sReturn = PopPageAjax("/Common/WorkFlow/CheckOpinionActionAjax.jsp?SerialNo="+sSerialNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0){
			//�˻��������   	
			var sRetValue = PopPageAjax("/Common/WorkFlow/CancelTaskActionAjax.jsp?SerialNo="+sSerialNo+"&rand=" + randomNumber(),"�˻��������","dialogWidth=0;dialogHeight=0;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			//����ɹ�����ˢ��ҳ��
			if(sRetValue == "Commit"){
				reloadSelf();
			}else{
				alert(sRetValue);
			}
		}else{
			alert(getBusinessMessage('510'));//��ҵ����ǩ����������������˻�ǰһ����
			return;
		}
	}
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function viewTab(){
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sCustomerID = "<%=sCustomerID%>";

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//OpenComp("SignTaskOpinionList","/Common/WorkFlow/SignTaskOpinionList.jsp","CustomerID="+sCustomerID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		
		AsControl.OpenComp("/Common/WorkFlow/SignTaskOpinionList.jsp","CustomerID="+sCustomerID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank03","dialogWidth=950px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		
	}
	
	/*~[Describe=����¼��;InputParam=��;OutPutParam=��;]~*/
	function playTape(){
		AsControl.PopComp("/Common/WorkFlow/playTape.jsp","","");
	}
	
	/*~[Describe=�鿴ͼƬ;InputParam=��;OutPutParam=��;]~*/
	function viewImage(){
		AsControl.PopComp("/Common/WorkFlow/SignTaskImage.jsp","ObjectNo=<%=sObjectNo%>","");
	}
	
	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
		var OpenStyle = "width=100px,height=60px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//����ѡ��ȡ���������
		var sReturn = AsControl.PopComp("/Common/WorkFlow/CancelApplyInfo.jsp","ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&PhaseNo=<%=sPhaseNo%>&FlowNo=<%=sFlowNo%>&TaskNo=<%=sSerialNo%>&Type=1",OpenStyle);
		window.returnValue = sReturn;
		parent.parent.parent.reloadSelf();
		//window.close();
	}
	
	
	
	//�������ñ���Ϊ��ʱ��Ϊ����
	function getCreditReport(){
		 var sCreditReport=getItemValue(0,getRow(),"CreditReport");
		 if(sCreditReport=="1"){
			 setItemRequired(0,0,"CreditReport",true);
			 setItemRequired(0,0,"CreditNum",true);
			 setItemRequired(0,0,"CreditLimit",true);
			 setItemRequired(0,0,"UseLimit",true);
			 setItemRequired(0,0,"CreditStatus",true);
			 setItemRequired(0,0,"IsNormalCredit",true);
			 setItemRequired(0,0,"OverDueMonthCredit",true);
			 setItemRequired(0,0,"PutoutAccount",true);
			 setItemRequired(0,0,"PutoutSum",true);
			 setItemRequired(0,0,"IsNormalPutout",true);
			 setItemRequired(0,0,"OverDueMonthPutout",true);
			 setItemRequired(0,0,"SuccessDate",true);
			 setItemRequired(0,0,"QueryTime1",true);
			 setItemRequired(0,0,"QueryTime2",true);
			 setItemRequired(0,0,"PhoneNumber",true);
		 }else{
			 setItemRequired(0,0,"CreditReport",false);
			 setItemRequired(0,0,"CreditNum",false);
			 setItemRequired(0,0,"CreditLimit",false);
			 setItemRequired(0,0,"UseLimit",false);
			 setItemRequired(0,0,"CreditStatus",false);
			 setItemRequired(0,0,"IsNormalCredit",false);
			 setItemRequired(0,0,"OverDueMonthCredit",false);
			 setItemRequired(0,0,"PutoutAccount",false);
			 setItemRequired(0,0,"PutoutSum",false);
			 setItemRequired(0,0,"IsNormalPutout",false);
			 setItemRequired(0,0,"OverDueMonthPutout",false);
			 setItemRequired(0,0,"SuccessDate",false);
			 setItemRequired(0,0,"QueryTime1",false);
			 setItemRequired(0,0,"QueryTime2",false);
			 setItemRequired(0,0,"PhoneNumber",false);
		 }
	}
	
	/*~[Describe=�ֻ�������֤;InputParam=��;OutPutParam=��;]~*/
	function checkMobile(obj){ 
		
	    var sPhoneNumber = getItemValue(0,getRow(),"PhoneNumber");
	    if(typeof(sPhoneNumber) == "undefined" || sPhoneNumber.length==0){
	    	return false;
	    }
	    if(!(/^1[3|4|5|8][0-9]\d{8}$/.test(sPhoneNumber))){ 
	        alert("�ֻ�����������������������"); 
	        //obj.focus();
		    setItemValue(0,0,"PhoneNumber","");
	        return false; 
	    } 
	} 
	
	//���ÿ��������
	function creditNum(){
		var sCreditNum = getItemValue(0,getRow(),"CreditNum");
		if(sCreditNum<=0 ){
			alert("���ÿ�������1~99֮��");
    		 setItemValue(0,0,"CreditNum","");
    	}
    	if(sCreditNum>99 ){
			alert("���ÿ�������1~99֮��");
    		 setItemValue(0,0,"CreditNum","");
    	}
	}
	
	//���24����������������
	function overDueMonthCredit(){
		var sOverDueMonthCredit = getItemValue(0,getRow(),"OverDueMonthCredit");
		if(sOverDueMonthCredit<=0 ){
			alert("���24���������������1~99֮��");
    		 setItemValue(0,0,"OverDueMonthCredit","");
    	}
    	if(sOverDueMonthCredit>99 ){
			alert("���24���������������1~99֮��");
    		 setItemValue(0,0,"OverDueMonthCredit","");
    	}
	}
	
	//�����˻������
	function putoutAccount(){
		var sPutoutAccount = getItemValue(0,getRow(),"PutoutAccount");
		if(sPutoutAccount<=0 ){
			alert("�����˻�����1~99֮��");
    		 setItemValue(0,0,"PutoutAccount","");
    	}
    	if(sPutoutAccount>99 ){
			alert("�����˻�����1~99֮��");
    		 setItemValue(0,0,"PutoutAccount","");
    	}
	}
	
	//�������24����������������
	function overDueMonthPutout(){
		var sOverDueMonthPutout = getItemValue(0,getRow(),"OverDueMonthPutout");
		if(sOverDueMonthPutout<=0 ){
			alert("�������24���������������1~99֮��");
    		 setItemValue(0,0,"OverDueMonthPutout","");
    	}
    	if(sOverDueMonthPutout>99 ){
			alert("�������24���������������1~99֮��");
    		 setItemValue(0,0,"OverDueMonthPutout","");
    	}
	}
	
	
	//���6���±���ѯ�������
	function queryTime1(){
		var sQueryTime1 = getItemValue(0,getRow(),"QueryTime1");
		if(sQueryTime1<=0 ){
			alert("���6���±���ѯ������1~99֮��");
    		 setItemValue(0,0,"QueryTime1","");
    	}
    	if(sQueryTime1>99 ){
			alert("���6���±���ѯ������1~99֮��");
    		 setItemValue(0,0,"QueryTime1","");
    	}
	}
	
	//���6���±���ѯ�������
	function queryTime2(){
		var sQueryTime2 = getItemValue(0,getRow(),"QueryTime2");
		if(sQueryTime2<=0 ){
			alert("���30�챻��ѯ������1~99֮��");
    		 setItemValue(0,0,"QueryTime2","");
    	}
    	if(sQueryTime2>99 ){
			alert("���30�챻��ѯ������1~99֮��");
    		 setItemValue(0,0,"QueryTime2","");
    	}
	}
	
	//�����Ŷ�ȼ��
	function creditLimit(){
		var sCreditLimit = getItemValue(0,getRow(),"CreditLimit");
		if(sCreditLimit<1 ){
			alert("�����Ŷ����1~1000w֮��");
    		 setItemValue(0,0,"CreditLimit","");
    	}
    	if(sCreditLimit>10000000 ){
			alert("�����Ŷ����1~1000w֮��");
    		 setItemValue(0,0,"CreditLimit","");
    	}
	}
	
	
	//���ö�ȼ��
	function useLimit(){
		var sUseLimit = getItemValue(0,getRow(),"UseLimit");
		if(sUseLimit<1 ){
			alert("���ö����1~1000w֮��");
    		 setItemValue(0,0,"UseLimit","");
    	}
    	if(sUseLimit>10000000 ){
			alert("���ö����1~1000w֮��");
    		 setItemValue(0,0,"UseLimit","");
    	}
	}
	
	
	//�����ܶ���
	function putoutSum(){
		var sPutoutSum = getItemValue(0,getRow(),"PutoutSum");
		if(sPutoutSum<1 ){
			alert("�����ܶ���1~99999999֮��");
    		 setItemValue(0,0,"PutoutSum","");
    	}
    	if(sPutoutSum>99999999 ){
			alert("�����ܶ���1~99999999֮��");
    		 setItemValue(0,0,"PutoutSum","");
    	}
	}
	
	
	//������绰
	function btnMakeCall_Click()
	{
		var sRetVal = PopPage("/Common/WorkFlow/PhoneCallInputInfo.jsp", "", "dialogWidth=450px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sRetVal!="_none_"){
			var txt_Pfhc;
			Pfhc="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=ecMakeCall& CustomerNumber=";
			Pfhc+= sRetVal+"&CallerParty=";
	        window.location= Pfhc;
		}
		
	}

	function creatApplyTable(){
		var sObjectNo = "<%=sObjectNo%>";
			sObjectType = "ApplySettle";
			sExchangeType = "";
		//������֪ͨ���Ƿ��Ѿ�����
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //δ���ɳ���֪ͨ��
			alert("���뵥δ����!");
			return;
		}
		//��ü��ܺ�ĳ�����ˮ��
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		//ͨ����serverlet ��ҳ��
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 

	}
	
	/*~[Describe=��ѯ���Ҫ����ʾ;InputParam=��;OutPutParam=��;]~*/
	function viewApprove(){
		alert("���Ҫ����ʾ��");
	}
	
	/*~[Describe=���ѡ�񴥷��¼�;InputParam=��;OutPutParam=��;]~*/
	function selectID5Opinion() {
		
		/* var sSelOp = getItemValue(0, 0, "PhaseOpinion");
		if (sSelOp!=null && sSelOp && sSelOp=="060") {
			setItemRequired(0, 0, "PhaseOpinion3", true);
			showItem(0, 0, "PhaseOpinion3");
		} else {
			setItemRequired(0, 0, "PhaseOpinion3", false);
			hideItem(0, 0, "PhaseOpinion3");
		} */
	}
	
	function trimAlpha(obj) {
		
		var sId5 = getItemValue(0, 0, "PhaseOpinion3");
		setItemValue(0, 0, "PhaseOpinion3", sId5.replace(/(\s+|[a-zA-z])/g,""));
	}

	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		bCheckBeforeUnload = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
