<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ���ҵ��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���ҵ��&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	//����������	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//����sSql�������ݶ���

	String sTempletNo = "BusinessedQueryList"; //ģ����
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//doTemp.setKeyFilter("SerialNo");
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//ccs-887 ���������ϴ���ҪĬ�ϲ�ѯ��ֻ��ʾ��ѯ����ȥ��ѯ update "and 1=2"  huzp 20150609
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";	
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","������Ϣ","�鿴������Ϣ","viewFlow()",sResourcesPath},
			{"false","","Button","�������","�������","",sResourcesPath},
			{"false","","Button","�����˻�","�����˻�","",sResourcesPath},
			{"true","","Button","�鿴���","�鿴���","viewOpinions()",sResourcesPath},
			{"true","","Button","�绰�ֿ�","�绰�ֿ�","getPhoneCode()",sResourcesPath},
			{"true","","Button","�鿴�����","�鿴�����","viewApplyTable()",sResourcesPath},
			{"true","","Button","¼����ѯ","¼����ѯ","playTape()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"ObjectNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}
	
	/*~[Describe=����¼��;InputParam=��;OutPutParam=��;]~*/
	function playTape(){
		var sContractNo=getItemValue(0,getRow(),"ObjectNo");
		var sRet = setObjectValue("SelectWMAUrl", "ContractNo,"+sContractNo, "", 0, 0, "");
		if (sRet==='_CLEAR_' || typeof(sRet)=='undefined' || sRet==='undefined') {
			return;
		}
		var sWmaUrl = sRet.split("@")[1];
		AsControl.PopComp("/Common/WorkFlow/playTape.jsp","WmaURL="+sWmaUrl,"");
	}
	
	/*~[Describe=ȡ��ԭ��;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo =getItemValue(0,getRow(),"ObjectNo");	
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if(sPhaseNo!="9000"){
			alert("�ý׶β���ȡ���׶Σ�");
			return;
		}
		var OpenStyle = "width=100px,height=60px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
		//����ѡ��ȡ���������
		var sReturn = AsControl.PopComp("/Common/WorkFlow/CancelApplyInfo.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&PhaseNo="+sPhaseNo+"&FlowNo="+sFlowNo+"&TaskNo="+sSerialNo+"&Type=1&temp=temp",OpenStyle);
		window.returnValue = sReturn;
		window.close();
		reloadSelf();
	}

	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo =getItemValue(0,getRow(),"ObjectNo");	
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
	}
	
	/*~[Describe=�������;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewGradeCard(){
		
	}
	
	/*~[Describe=�鿴������Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewFlow(){
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"ObjectNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sCompID = "ViewFlow";
			sCompURL = "/InfoManage/QuickSearch/ViewFlow.jsp";
			popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sSerialNo,"dialogWidth=900px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
	 
	//add   wlq    �鿴�����    20140801  
	function viewApplyTable () {
		printTable("ApplySettle");
	}
    
//  ==============================  ��ӡ��ʽ������  ��������  add by yzhang9 ============================================================
	
	/*~[Describe=��ӡ��ʽ������;InputParam=��;OutPutParam=��;]~*/
	function printTable(type){
			var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
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
