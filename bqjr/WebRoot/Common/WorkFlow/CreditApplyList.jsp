<%@page import="com.sun.org.apache.xpath.internal.objects.XString"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.sadre.util.DateUtil"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: ��ҳ����Ҫ����ҵ����ص������б������Ŷ�������б��������ҵ�������б�
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
		xswang 2015/05/25 CCS-808 ϵͳȫ���̵��ӻ����죺�ļ��������
		xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
<%
	String PG_TITLE = "���ŷ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String sSubApplyType= DataConvert.toRealString(iPostChange,(CurComp.getParameter("subApplyType")));
	//add by xswang 2015/05/25 CCS-808 ϵͳȫ���̵��ӻ����죺�ļ��������
	String sToday = StringFunction.getTodayNow();
	//end by xswang 
	String sNo= CurUser.getAttribute8();
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
		var serialNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//��֤��ͬ��Ʒ�Ƿ��Ѿ���Ӱ������������
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sAmount = RunMethod("���÷���","GetColValueTables","product_ecm_type,product_type_ctype,count(1),product_ecm_type.PRODUCT_TYPE_ID = product_type_ctype.PRODUCT_TYPE_ID and product_type_ctype.PRODUCT_ID ='"+sBusinessType+"' ");
		if(sAmount == 0){
			alert("��������ƷӰ�����������øò�Ʒ��Ӧ��Ӱ���ļ���");
			return false;
		}
		// ��������Ѿ��ϴ�����ɾ���ü�¼���ϴ�
		/*var sDocNo = RunMethod("���÷���", "GetColValue", "DOC_ATTACHMENT,DocNo,DocNo='"+serialNo+"'");
		if (sDocNo!="Null") {
			RunMethod("���÷���", "DelByWhereClause", "DOC_ATTACHMENT,DocNo='"+serialNo+"'");
		}
		
		AsControl.PopView("/AppConfig/Document/AttachmentChooseDialog3.jsp","DocNo="+serialNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();*/
	    var param = "ObjectType=Business&TypeNo=20&ObjectNo="+serialNo;
	    AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
	    // var param = "ObjectType=Business&TypeNo=20&RightType=&ObjectNo="+serialNo;
	    // AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
	}
		
	/*~[Describe=Segment��У��;InputParam=��;OutPutParam=��;]~*/
	function CheckSegment(){
		var SerialNo = getItemValue(0, getRow(), "SerialNo");//��ͬ��ˮ��
		sCount = RunMethod("LoanAccount","CheckSegment", SerialNo);
		if(sCount > 0){
			return true;
		}
		return false;
	}
	
	/*~[Describe=ID5���;InputParam=��;OutPutParam=��;]~*/
	function id5Check() {
		var smath = trim("   1EE650");
		var reg = /^[1-9]\d*[Ee]\d+/g;
		var sresult = reg.test(smath)
		alert(sresult);
		return;
		if ("<%=CurUser.getUserID()%>" !== "140001") {
			alert("�����û�140001���ԣ�");
			return;
		}
		
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (false && (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} 
		
		// ����ID5���֤
		var sIndName = getItemValue(0, getRow(), "CustomerName");
		var sIdCardNum = RunMethod("���÷���", "GetColValue", "IND_INFO,CERTID,CUSTOMERID='"+getItemValue(0, getRow(), "CustomerID")+"'");
		//alert("reqHeader=1A020201,reqData="+sIndName+"@"+sIdCardNum);
		var sRetId5 = RunJavaMethodSqlca("com.amarsoft.webclient.RunID5", "runParserId5", "reqHeader=1A020201,reqData="+sIndName+"@"+sIdCardNum+",savepath=<%=CurConfig.getConfigure("ImageFolder")%>"+",stype=010");
		var sretHead = sRetId5.split("@")[0];
		
		if ("010" === sretHead) {
			alert("�û��Ѿ������ڱ������ݿ⣬ ��ѯ�������ֵ��" + sRetId5.substring(4,sRetId5.length));
		} else if("020" === sretHead) {
			alert("���������ݿ⣬�ӹ���ͨ��ѯ�� ��ѯ�������ֵ��" + sRetId5.substring(4,sRetId5.length));
		} else {
			alert("δ��������� " + sRetId5);
		}
		// ����ID5�̻�
		if (confirm("�Ƿ��������ID5�̻�")) {
			var sPhone = RunMethod("���÷���", "GetColValue", "IND_INFO,WORKTEL,CUSTOMERID='"+getItemValue(0, getRow(), "CustomerID")+"'");
			if (sPhone==="Null" || sPhone==="") {
				alert("�绰Ϊ��");
			} else {
				sPhone = sPhone.replace(/-/g, "");
			}
			//alert(sPhone);
			//var sIdCardNum = RunMethod("���÷���", "GetColValue", "IND_INFO,CERTID,CUSTOMERID='"+getItemValue(0, getRow(), "CustomerID")+"'");
			//alert("reqHeader=1A020201,reqData="+sIndName+"@"+sIdCardNum);
			var sRetPhone = RunJavaMethodSqlca("com.amarsoft.webclient.RunID5", "runParserId5", "reqHeader=1G010101,reqData="+sPhone+",savepath=<%=CurConfig.getConfigure("ImageFolder")%>"+",stype=020");
			var sretHead = sRetPhone.split("@")[0];
			if ("010" === sretHead) {
				alert("�̻��Ѿ������ڱ������ݿ⣬ ��ѯ�������ֵ��" + sRetPhone.substring(4,sRetPhone.length));
			} else if("020" === sretHead) {
				alert("���������ݿ⣬�ӹ���ͨ��ѯ�� ��ѯ�������ֵ��" + sRetPhone.substring(4,sRetPhone.length));
			} else {
				alert("δ��������� " + sRetPhone);
			}
		}
	}
		
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newApply(){
		
		//��jsp�еı���ֵת����js�еı���ֵ
		var sObjectType = "<%=sObjectType%>";	
		var sApplyType = "<%=sApplyType%>";	
		var ssSubApplyType="<%=sSubApplyType%>";
		var sPhaseType = "<%=sPhaseType%>";
		var sInitFlowNo = "<%=sInitFlowNo%>";
		var sInitPhaseNo = "<%=sInitPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		// add by xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
		//var sStore = RunMethod("BusinessManage","getStore",sUserID);
		var sSno = "<%=CurUser.getAttribute8()%>";
		var sStore = RunMethod("BusinessManage","getStoreNew",sSno);
		// end by xswang 2015/06/01
		var ssCity=RunMethod("GetElement","GetElementValue","city,user_info,userid='"+sUserID+"'");
		
		if(typeof(sStore)=="undefined" || sStore.length==0 || sStore == "Null"){
			alert("ѡ�������ŵ�Ϊ�գ�������ҳ��ť�Աߵ���ŵ�ѡ���ŵ�����ѡ���ŵ꣡");
			return;
		}
		var subProductType=null;
		if(sApplyType == "CreditLineApply"){
			if(ssSubApplyType=="StuEducation"){//����ѧ����
				subProductType = 5;
			}else if("AdultEducation"==ssSubApplyType){//������˴�
				subProductType = 4;
			}else if("ssSubApplyType"==ssSubApplyType){//����ѧ������
				subProductType = 7;
			}else{
				subProductType = 0;
			}
		}
		
		if(confirm("��ǰ��¼�����ŵ�Ϊ��\n\r"+sStore+"\n\r�Ƿ�ȷ���ڸ��ŵ귢�����룿")){
			var rValues=RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "getCreditID", "ProductType="+subProductType+",citys="+ssCity);
			 if(rValues=="false"){
				alert("�ó����²�Ʒ����Ϊ���Ѵ�û����ش����ˣ�");
				return;
			} 
			//����������������Ի���
			if(sApplyType == "CreditLineApply"){
				if(ssSubApplyType=="StuEducation"){//����ѧ����
					sCompID = "CreditLineApplyCreationInfo";
					sCompURL = "/BusinessManage/ApplyEducationMain/CreditEducationApplyCreationInfo.jsp";
					subProductType="5";
				} else if("AdultEducation"==ssSubApplyType){//������˴�
					sCompID = "CreditLineApplyCreationInfo";
					sCompURL = "/BusinessManage/ApplyEducationMain/CreditEducationApplyCreationInfo.jsp";
					subProductType="4";
				}else if( "StuPos" == ssSubApplyType ){//ѧ�����Ѵ�   add by dahl
					sCompID = "CreditStuPosApplyCreationInfo";
					sCompURL = "/CreditManage/CreditApply/CreditStuPosApplyCreationInfo.jsp";	 
					subProductType="7";
				}else{
			 		sCompID = "CreditLineApplyCreationInfo";
					sCompURL = "/CreditManage/CreditApply/CreditLineApplyCreationInfo.jsp";	 
				}
			}else{
				sCompID = "CreditApplyCreation";
				sCompURL = "/CreditManage/CreditApply/CreditApplyCreationInfoAll.jsp";
			}
	    	 sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo+"&SubProductType="+subProductType,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
			sReturn = sReturn.split("@");
			sObjectNo=sReturn[0];

			//add by qfang �����жϣ����Ϊ"�����¹����ò�Ʒ"���򵯳�ҳ�棬��ʾҵ��Ʒ�ַ����������־λ�ֶ�
			sObjectType=sReturn[1];	
			if(sReturn[2] != null){ 
				sTypeNo=sReturn[2];
				sSortReturn = RunMethod("CreditLine","CheckProductSortFlag",sTypeNo);
				if(sSortReturn.split("@")[0] == "true"){
					popComp("SortFlagInfo","/CreditManage/CreditApply/SortFlagInfo.jsp","TypeNo="+sTypeNo+"&ObjectNo="+sObjectNo,"dialogWidth=400px;dialogHeight=300px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");		
				}
			} 
			//add end
			
	         //���������������ˮ�ţ��������������
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle); 
		}
		reloadSelf();		
	}
	
    /*~[Describe=Ӱ�����;InputParam=��;OutPutParam=��;]~*/
    function imageManage(){
        var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
    }
    
	
	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		var sUserID = "<%=CurUser.getUserID()%>";
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		/***************begin update huzp CCS-1334,����ʽ�ᵥ*******************************/
		if("1"=="<%=switch_status%>"){
			var sPretrialSerialNo = getItemValue(0,getRow(),"PretrialSerialNo");
		}
		/********************end*********************************************************/

		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var contract_status=RunMethod("���÷���", "GetColValue", "BUSINESS_CONTRACT,ContractStatus,serialNo='"+sObjectNo+"'");
		if("0701"==contract_status||"0702"==contract_status||"0703"==contract_status){
			alert("Engine�����У����Ժ��ύ");//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}
		if (confirm("��ȷ��Ҫȡ���ñ�������")) {
			
			var sSerialNo = RunMethod("���÷���", "GetColValue", "FLOW_TASK,MAX(SerialNo), ObjectNo='"+sObjectNo+"'");	//RunMethod("BusinessManage","SelectFlowSerialno",sObjectNo+","+sPhaseNo+","+sObjectType);
			var sSales=<%=CurUser.hasRole("1006")%>;
			var sCE=<%=CurUser.hasRole("1027")%>;
			var edu1=<%=CurUser.hasRole("1626")%>;
			var edu2=<%=CurUser.hasRole("1628")%>;
			var sReturn = "";
			if(sSales){
				sReturn=popComp("CancelApplyInfo","/Common/WorkFlow/CancelApplyInfo1.jsp","SerialNo="+sSerialNo+"&Type=7",OpenStyle);
			}else if(sCE){
				sReturn=popComp("CancelApplyInfo","/Common/WorkFlow/CancelApplyInfo1.jsp","SerialNo="+sSerialNo+"&Type=8",OpenStyle);
			}else if(edu1||edu2){
				sReturn=popComp("CancelApplyInfo","/Common/WorkFlow/CancelApplyInfo1.jsp","SerialNo="+sSerialNo+"&Type=7",OpenStyle);
			}
			if (typeof(sReturn)=="undefined" || sReturn.length==0||sReturn=="_CANCEL_"){
				return;
			}
			//�޸Ľ׶�Ϊ"��ȡ��"��
			var sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","CancelTask","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
			
			
			if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
			else if (sPhaseInfo == "Success"){
				alert("ȡ����ͬ�ɹ���");
				//��ȡ�����Ͳ����Flow_Task��
				
			    if(sSales){
			    	RunMethod("Flow_Opinion","ModifyFO",sSerialNo+","+"����ȡ��");
			    }else if(sCE){
					RunMethod("Flow_Opinion","ModifyFO",sSerialNo+","+"CEר��ȡ��");
			    }else{
			    	RunMethod("Flow_Opinion","ModifyFO",sSerialNo+","+"���ȡ��");
			    } 
				//RunMethod("BusinessManage","UpdateApplyPhaseType",sObjectNo+","+sObjectType+","+"1060");
				//�޸ĺ�ͬ״̬RunMethod("BusinessManage","UpdateContractStatus",sObjectNo+","+"100");
				//ˢ�¼�����ҳ�� 
				// add by tbzeng 2014/07/10 ���ȡ����ͬ����¼��Ȼ���������ҳ�棬�޷������ύ 
				var sTimeNullSerialNo = RunMethod("���÷���", "GetColValue", "FLOW_TASK,SERIALNO,OBJECTNO='"+sObjectNo+"' and (endtime is null or endtime='')");
				//alert(sTimeNullSerialNo+"|"+typeof sTimeNullSerialNo);
				if (sTimeNullSerialNo!="Null" && sTimeNullSerialNo.length>0) {
					
					var sBeginTime = RunMethod("���÷���", "GetColValue","FLOW_TASK,BEGINTIME,SERIALNO=(SELECT MAX(SERIALNO) FROM FLOW_TASK WHERE OBJECTNO='"+sObjectNo+"')");
					RunMethod("���÷���", "UpdateColValue", "FLOW_TASK,ENDTIME,"+sBeginTime+",SERIALNO='"+sTimeNullSerialNo+"'");
				}
				// end 2014
				
				// add by tbzeng 2104/07/15 ��¼��ͬȡ���¼����¼����ͼ�¼060
				var sEvtSerialNo = getSerialNo("Event_Info", "Serialno", "");
				var sCols = "Serialno@Eventname@Eventtime@Contractno@Inputuser@Inputorg@Type@Remarks";
				var sVals = sEvtSerialNo+"@��ͬȡ��@<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>@"+sObjectNo+"@<%=CurUser.getUserID()%>@<%=CurOrg.orgID%>@060@ȡ����ͬ�¼���¼";
				//RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.InsertEvalue", "recordEvent", "colName="+sCols+",colValue="+sVals);
				// end 2014/07/15
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
				alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
				reloadSelf();
				return;
			} else if (sPhaseInfo == "RuleError"){//by yzheng,qxu 2013/6/28
				alert("�����������ʧ��!");//�������Ѿ��ύ�ˣ������ٴ��ύ��
				reloadSelf();
				return;
			}
			
			/***************begin update huzp CCS-1334,����ʽ�ᵥ*******************************/
			//����Ԥ����Ϣ���ж�Ӧ��״̬
			if("1"=="<%=switch_status%>"){
				if (typeof(sPretrialSerialNo)!="undefined" || sPretrialSerialNo.length!=0){
					//RunMethod("���÷���", "UpdateColValue", "Pretrial_Info,STATE,005,SERIALNO="+sPretrialSerialNo);
					var sParam = "SERIALNO=" +sPretrialSerialNo;
					RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateIndInfoAction", "updatePretrialInfoState", sParam);
				}
			}
			/***************end*******************************/
			// ���º�ͬ״̬
			RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctBCStatus", "sObjectNo="+sObjectNo+"");
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
		//reloadSelf(); //update CCS-499 ��������˵��º�ͬ״̬�б����ݳ���һҳ�ģ��鿴ĳҳ��ͬ����������رպ������˵�һҳ  by rqiao 20150331
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
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		 var sUserID = "<%=CurUser.getUserID()%>";
		
		//var sReturnVal=RunMethod("BusinessManage","SelectUnlogContractOverTime",sObjectType+","+sApplyType1+","+sUserID); 
		var sReturnVal=RunMethod("BusinessManage","SelectUnlogContractOverTime",sObjectType+","+sUserID); 
		
		var sObFlowNo = RunMethod("���÷���", "GetColValue", "FLOW_OBJECT,OBJATTRIBUTE5,OBJECTNO='"+sObjectNo+"'");
		if (sObFlowNo!="Null" && sObFlowNo.length>0) {
			alert("�����ظ��ύ��");
			return;
		}
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		// add by tbzeng 2014/07/11 У���ͬ�Ϳͻ���Ϣ�Ƿ��Ѿ�����
		var sContratNo = getItemValue(0, getRow(), "SerialNo");

		//ͳһ��ȡ��ͬ�������ֶ�
		var sColName = "TEMPSAVEFLAG@Manufacturer1@RepaymentWay@ContractStatus@SalesManager@CreditID";
		var sTableName = "BUSINESS_CONTRACT";
		var sWhereClause = "String@SERIALNO@"+sContratNo;
		var	bcReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		var bcReturnArr = bcReturn.split("@");
		var sContractTempFlag = bcReturnArr[1];
		var sManufacturer1 = bcReturnArr[3];
		var sRepaymentWay = bcReturnArr[5];
		var contract_status = bcReturnArr[7];
		//����һ�������������ѻ�ȡ
		//var sContractTempFlag = RunMethod("PublicMethod", "GetColValue", "BUSINESS_CONTRACT,TEMPSAVEFLAG,Manufacturer1,SERIALNO='"+sContratNo+"'");
		var sIndTempFlag = RunMethod("���÷���", "GetColValue", "IND_INFO,TEMPSAVEFLAG, CUSTOMERID=(SELECT CUSTOMERID FROM BUSINESS_CONTRACT WHERE SERIALNO='"+sContratNo+"')");
		var sAssistTempFlag=RunMethod("���÷���", "GetColValue", "ASSISTINVESTIGATE,TEMPSAVEFLAG,OBJECTNO='"+sContratNo+"'");
		//add CCS-363 PRM-81 ����������û����дҲ���ύ
		var sSelfMonthIncome = RunMethod("���÷���", "GetColValue", "IND_INFO,SelfMonthIncome, CUSTOMERID=(SELECT CUSTOMERID FROM BUSINESS_CONTRACT WHERE SERIALNO='"+sContratNo+"')");
		if(null == sSelfMonthIncome || "" == sSelfMonthIncome) sSelfMonthIncome = "0";
		//end
		
		//add PRM-499 �ͺŸ����ʽ������û����дҲ���ύ by huanghui 20150713
		//�������������������ѻ�ȡ
		//var sManufacturer1 = RunMethod("���÷���", "GetColValue", "BUSINESS_CONTRACT,Manufacturer1,SERIALNO='"+sContratNo+"'");
		//var sRepaymentWay = RunMethod("���÷���", "GetColValue", "BUSINESS_CONTRACT,RepaymentWay,SERIALNO='"+sContratNo+"'");
		//end
		
		if (sIndTempFlag == "1" || parseFloat(sSelfMonthIncome)<=0) { // У��ͻ���Ϣ�Ƿ��Ѿ�����// update CCS-363 PRM-81 ����������û����дҲ���ύ
			alert("���ȱ���ͻ���Ϣ���ύ��");
			return;
		}
		
		//add PRM-499 �ͺŸ����ʽ������û����дҲ���ύ by huanghui 20150713
		if (sContractTempFlag == "1" || null== sManufacturer1 || ""==sManufacturer1|| "Null"==sManufacturer1 || null== sRepaymentWay || ""==sRepaymentWay|| "Null"==sRepaymentWay) {	// У���ͬ��Ϣ�Ƿ��Ѿ�����
			alert("���ȱ����ͬ��Ϣ���ύ��");
			return;
		}
		// end 2014/07/11
		//У��Э����Ϣ�Ƿ��Ѿ�����
		if(sAssistTempFlag!="2"){
			alert("���ȱ���Э����Ϣ���ύ��");
			return;
	    	}
		// �������ɻ�����Ϣ�ٱ���
		var params = "objectNo=" + sContratNo;
		var res = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.LoadContractLoanInfo", 
									"gainIsGenSchedule", params);
		if (res != "2") {
			alert("�����ں�ͬ�������ɻ�����Ϣ��");
			return;
		}
		
		// ѧ��ѡ���Ʒ��֤ add by tbzeng 2014/08/27
		var sCusTypeNo = RunMethod("���÷���", "GetColValue", "IND_INFO,HEADSHIP,CUSTOMERID='"+sObjectNo.substring(0,8)+"'"); 
		var sBizType = getItemValue(0, getRow(), "BusinessType");
		var sBizTypeUse = sBizType;
		if (sBizType && sBizType.length>1) sBizType = sBizType.substring(0, 2);
		//alert(sCusTypeNo + "|" + sBizType);
		var adultEducationType="<%=sSubApplyType%>";
		if("AdultEducation"==adultEducationType ||"StuEducation"==adultEducationType){// 4 5  ��ѧ���� ���ǳ���da
			var educationPutoutno=RunMethod("���÷���", "GetColValue", "business_education_info,SCHOOL_NAME,putoutno='"+sContratNo+"'");
			if( null== educationPutoutno || ""==educationPutoutno|| "Null"==educationPutoutno){
				if("AdultEducation"==adultEducationType){
				
				}else{
					alert("���ȱ���ѧ������Ϣ");
				    return;
				}
			}
			var  isRepeat=	RunJavaMethodSqlca("com.amarsoft.app.billions.IsRepeatEducationInfo", "InserOrupdateEducationInfoByServerNo", "putoutno='"+sContratNo+"'");
			//  ��֤�õ����Ե绰���벻���ظ�
			if("K"!=isRepeat){
				alert("���й�ϵ�ĵ绰�����ظ�����,�����ظ����벢�޸�!");
			}
		}else{
			if (sBizType=="XS" || sBizType=="xs" || sBizType=="Xs" || sBizType=="xS") {
					if (sCusTypeNo != "9") {
						//����У��ѧ�����Ѵ� add by dyh 20150618
						if("StuPos" != adultEducationType){
							alert("�ò�Ʒ��"+sBizTypeUse+",ֻ��ѧ���û�ʹ�ã�");
							return;
						}
					}
			} else {
				if (sCusTypeNo == "9") {
					alert("ѧ���û�����ʹ�øò�Ʒ��"+sBizTypeUse+"��");
					return;
				}
			}
		}
		// 2014/08/27--end
		
		
		// �����У�� CCS-685 slyang 2015/04/09
		/* var sSpecialBizType = RunMethod("���÷���", "IsSpecialBizType", sObjectNo);
		if(!CheckSegment() && sSpecialBizType=="false"){
			
			alert("��ͬ������Ч,�����ͬ���±��棡");
			return;
		} */
		
		var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ApplyCheak","cheakMangees","serialNo="+sObjectNo);
		if (result.split("@")[0] != "true") {
			alert(result.split("@")[1]);
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

		//��ȡ������ˮ��
		var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//����������Ӧ���������񲻴��ڣ���˶ԣ�
			return;
		} 
		
		//CCS-1210 ���֤�����桢�ֳ��ո�Ϊ������  start
		// add by tbzeng 2014/05/28  �Ѿ��ϴ��ֳ���Ƭ���Ҵ�ӡ�����������ύ
		//var sApplyTablePath = RunMethod("���÷���", "GetColValue", "Formatdoc_Record,SavePath,ObjectType='ApplySettle' and  ObjectNo='"+sObjectNo+"'");
		//var sIsTransScenePhoto = RunMethod("���÷���", "GetColValue", "ecm_page,DocumentId,ObjectNo='"+sObjectNo+"'");
		//if (sIsTransScenePhoto=="Null") {
		//	alert("�����ϴ��ֳ���Ƭ���ύ��");
		//	return;
		//}
		var uploadImages = RunJavaMethodSqlca("com.amarsoft.app.billions.UploadedImageCommon","getUploadedImageTypes","objectNo="+sObjectNo);
		if (uploadImages.indexOf("�ͻ����֤����")==-1 || uploadImages.indexOf("�ͻ��ֳ���Ƭ")==-1 || uploadImages.indexOf("�ͻ����֤����")==-1) {
			alert("�����ϴ��ֳ���Ƭ�����֤�����������֤���������ύ��");
			return;
		}
		//CCS-1210 ���֤�����桢�ֳ��ո�Ϊ������  end
		
		//if (sApplyTablePath=="Null") {
		//	alert("�����ں�ͬ����ҳ���ӡ��������ύ��");
		//	return;
		//} 		
		var sProductID = getItemValue(0,getRow(),"ProductID");
		if(sReturnVal!=0){
			alert("���ȴ�������δע���ͬ");
			return false;
		} 
		
		//�жϵ�ǰ��ͬ�Ƿ���Ҫ�ϴ���������
		var uploadStatus = RunJavaMethodSqlca("com.amarsoft.app.als.image.ImageUploadAfterLoan","isNeedUploadImageAfterLoan","sObjectNo = "+sObjectNo);
		if(uploadStatus =="δ�ϴ�"){
			RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,uploadFlag,2,SerialNo = '"+sObjectNo+"'");
		}else if(uploadStatus =="�����ϴ�"){
			RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,uploadFlag,3,SerialNo = '"+sObjectNo+"'");
		}else {
			RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,uploadFlag,3,SerialNo = '"+sObjectNo+"'");
		}
		RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,OPERATEDSTATUS,1,SerialNo = '" + sObjectNo + "'");
		ShowMessage("ϵͳ�����ύ����ȴ�...",true,true);
		//��¼�ύʱ�� add by jli5 20150422 λ�ò�Ҫ�޸ģ���ŵ�����У��֮���ύ����֮ǰ
		RunJavaMethodSqlca("com.amarsoft.app.als.rule.InsertRuleRunLog","insertSubTime","SerialNo = "+sObjectNo);
		
		
		//�жϵ�ǰ�����Ƿ��ӡ�����
		/* var sApplyRepot = RunMethod("BusinessManage","getApplyReport",sObjectNo+","+sProductID);
		if(typeof(sApplyRepot)=="undefined" || sApplyRepot.length==0 || sApplyRepot == "Null") {
			alert("δ������������������������ύ��");
			return;
		} */ 		
		//���������ύѡ�񴰿�		���Ӳ������ݣ���ֹ�ظ��ύ by yzheg,qxu 2013/6/28 
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = "";
		if(sFlowNo=="CarFlow"){ //����ǳ������̣��������������ύ
			//���ù����������ȼ�
			var sRet = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getGrade","objectType="+sObjectType+",objectNo="+sObjectNo);
			if(sRet!="Success"){
				alert("��������ȼ�����");
				try{hideMessage();}catch(e) {}//add in 
				return;
			}
			sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommit","SerialNo="+sTaskNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		}else{ //��� �����Ѵ����̣���Ҫ�������Լ�����flowNo
		//	sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommitWithRule","SerialNo="+sTaskNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
			//����һ�������������ѻ�ȡ
			//var contract_status=RunMethod("���÷���", "GetColValue", "BUSINESS_CONTRACT,ContractStatus,serialNo='"+sObjectNo+"'");
			if("070"==contract_status||"0701"==contract_status){
				alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
				reloadSelf();
				return;
			}
			RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.InsertAutoRuleAction","updateBusinssConByserialNo","serialNo="+sObjectNo);
			//����Ƿ���p2p����
			RunJavaMethodSqlca("com.amarsoft.proj.action.P2PCredit","checkIsUseP2p","ContractSerialNo="+sObjectNo);
			//RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,ContractStatus,070,commit_Date,,SerialNo = '"+sObjectNo+"'");
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			reloadSelf();
		
		}
		
		// ���º�ͬ״̬
		//RunJavaMethodSqlca("com.amarsoft.app.billions.CorrectRuleEngineFlowNotMatch", "correctBCStatus", "sObjectNo="+sObjectNo+"");
if(sFlowNo=="CarFlow"){		
		try{hideMessage();}catch(e) {}//add in 
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,ContractStatus,070,SerialNo = '"+sObjectNo+"'");
			alert(getHtmlMessage('18'));//�ύ�ɹ���
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//�ύʧ�ܣ�
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,ContractStatus,070,SerialNo = '"+sObjectNo+"'");
			alert(getBusinessMessage('486'));//�������Ѿ��ύ�ˣ������ٴ��ύ��
			reloadSelf();
			return;
		}else if (sPhaseInfo == "RuleError"){
			alert("�����������ʧ��!");
			reloadSelf();
			return;
		}else if (sPhaseInfo == "Failure9000") {
			RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,ContractStatus,100,SerialNo = '"+sObjectNo+"'");
			alert("�������Ѿ�ȡ��!");
			reloadSelf();
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=34;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//����ύ�ɹ�����ˢ��ҳ��
			if (sPhaseInfo == "Success"){
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,ContractStatus,070,SerialNo = '"+sObjectNo+"'");
				alert(getHtmlMessage('18'));//�ύ�ɹ���
				reloadSelf();
			}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}
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
		
		sCompID = "SignTaskOpinionInfo";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions(){
		//����������͡�������ˮ�š����̱�š��׶α��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		//alert("---"+sObjectType+"----"+sObjectNo+"----"+sFlowNo+"----"+sPhaseNo);
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		popComp("ViewApplyFlowOpinions","/Common/WorkFlow/ViewApplyFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
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
		RunJavaMethod("com.amarsoft.app.als.rule.impl.DefaultService","getResultJs","");
		//����������͡�������ˮ��
		/*
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
		*/
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
			if(sFlag == "5"){   //5��������������鱨���������������
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
	
	/*~[Describe=��ӡ�����;InputParam=��;OutPutParam=��;]~*/
	function creatApplyTable(){
			var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
			sObjectType = "ApplySettle";
			sExchangeType = "";
			var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}else{
						//������֪ͨ���Ƿ��Ѿ�����
						var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
						if (sReturn == "false"){ //δ���ɳ���֪ͨ��
							//���ɳ���֪ͨ��	
							PopPage("/FormatDoc/Report17/03.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
							//��¼���ɶ���
							RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=produce");
						}else{
							//��¼�鿴����
							RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=view");
						}
						//��ü��ܺ�ĳ�����ˮ��
						var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
						//ͨ����serverlet ��ҳ��
						var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
						//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
						OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
	}
	/*~[Describe=��ӡ���Ӻ�ͬ;InputParam=��;OutPutParam=��;]~*/
	function creatContract(){//CCS-652  ������Ʒ - ���Ӻ�ͬ��ӡģ�壬��ӡ�߼�
		printTable("ApplySettle");
	}
	
	/*~[Describe=��ӡ����Э��;InputParam=��;OutPutParam=��;]~*/
	function creatThirdTable(){
		printTable("ThirdSettle");
	}
	
	/*~[Describe=��ӡ���������;InputParam=��;OutPutParam=��;]~*/
	function printApprove(){
		printTable("ApproveSettle");
	}
	
	/*~[Describe=��ӡ����С��ʿ;InputParam=��;OutPutParam=��;]~*/
	function printRemind(){
		printTable("CreditSettle");
	}
	
	/*~[Describe=��ӡ�����պ�;InputParam=��;OutPutParam=��;]~*/
	function printRishTip(){

		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type=RishSettle");
		if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
			alert("����ϵϵͳ����Ա����ͬģ�����úͺ�ͬ��Ϣ!");
			return;
		}
		var sDocID = returnValue.split("@")[0];
		var sUrl = returnValue.split("@")[1];
		//add by daihuafeng 20150708 ----begin �ഫһ�����������Ƶ�ҵ����Դ��APPʱ�ͻ�ǩ����URLǩ��
		sUrl = sUrl+"?ObjectNo="+sObjectNo;
		//add by daihuafeng 20150708 ----end
		
		OpenPage(sUrl,"_blank02",CurOpenStyle); 

	}
	
	/*~[Describe=��ӡ���Ļ�����������;InputParam=��;OutPutParam=��;]~*/
	function printSuiXinHuan(){

		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
	    var sBugPayPkgind = RunMethod("���÷���", "GetColValue", "business_contract,BugPayPkgind,serialno='"+sObjectNo+"'");
		if (typeof(sBugPayPkgind)=="undefined" || sBugPayPkgind.length==0 || (sBugPayPkgind!="1" && sBugPayPkgind!="2")){
			alert("�ú�ͬδ�������Ļ������!");
			return;
		}
		
		var sUrl = "/FormatDoc/Report17/ApplySuiXinHuan.jsp?ObjectNo="+sObjectNo;
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		OpenPage(sUrl,"_blank02",CurOpenStyle); 

	}

	/*~[Describe=��ӡ�۱�����ͬ ;InputParam=��;OutPutParam=��;]~*/
	function printBaiBaoDai(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sBusinessType2 = RunMethod("���÷���", "GetColValue", "business_contract,BusinessType2,serialno='"+sObjectNo+"'");
		if (typeof(sBusinessType2)=="undefined" || sBusinessType2.length==0 || sBusinessType2!="2015061500000017"){
			alert("�ú�ͬδ����۱���!");
			return; 
		}
		printTable("BaiBaoDai");
	}
	
	
	//   ==============================  ��ӡ��ʽ������  ��������  add by yzhang9  CCS-613  ============================================================
		
	/*~[Describe=��ӡ��ʽ������;InputParam=��;OutPutParam=��;]~*/
	function printTable(type){
			var sObjectNo = getItemValue(0,getRow(),"SerialNo");
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}
			
			var sObjectType = type;
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}else{
				//������֪ͨ���Ƿ��Ѿ�����
				var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
				if(sReturn == "move"){
					//alert("��ǰ���ɵ��ļ��Ѿ����ƶ��ˣ��޷�չʾ��Ҳ������������");
					return;
				}else if (sReturn == "false"){ //δ���ɳ���֪ͨ��
					var returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
					if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
						alert("����ϵϵͳ����Ա����ͬģ�����úͺ�ͬ��Ϣ!");
						return;
					}
					var sDocID = returnValue.split("@")[0];
					var sUrl = returnValue.split("@")[1];
					var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
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
	
	
	var time_range = function (beginTime, endTime, nowTime) {
	    var strb = beginTime.split (":");
	    if (strb.length != 2) {
	         return false;
	     }

	    var stre = endTime.split (":");
	     if (stre.length != 2) {
	         return false;
	    }
	 
	     var strn = nowTime.split (":");
	     if (stre.length != 2) {
	         return false;
	     }
	     var b = new Date ();
	     var e = new Date ();
	     var n = new Date ();
	 
	     b.setHours (strb[0]);
	     b.setMinutes (strb[1]);
	     e.setHours (stre[0]);
	     e.setMinutes (stre[1]);
	     n.setHours (strn[0]);
	     n.setMinutes (strn[1]);
	 
	     if (n.getTime () - b.getTime () > 0 && n.getTime () - e.getTime () < 0) {
	    	 alert("��ǰʱ���Ƕ�����ִ���������� " + endTime + " ���ύע�ᣡ");
	         return true;
	    } else {
	        //alert ("��ǰʱ���ǣ�" + n.getHours () + ":" + n.getMinutes () + "�����ڸ�ʱ�䷶Χ�ڣ�");
	        return false;
	    }
	}
	
	/*~[Describe=��ͬ�ύע��;InputParam=��;OutPutParam=��;]~*/
	function doRegistration(){

			/***********CCS-1041,ϵͳ����ʱ���ܵ�¼ϵͳ huzp 20151217**************************************/
			var sTaskFlag = RunMethod("���÷���","GetColValue","system_setup,taskflag,1=1");
			if(sTaskFlag=="1"){
				alert("ϵͳ������������ʱ�޷��ύע��!");
				return;
			}else{
				var sObjectNo = getItemValue(0,getRow(),"SerialNo");
				var sObjectType = getItemValue(0,getRow(),"ObjectType");
				var sCustomerType = getItemValue(0,getRow(),"CustomerType");
				var sSureType = RunMethod("���÷���","GetColValue","Business_Contract,SureType,serialNo = '"+sObjectNo+"' ");
				if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
					alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
					return;
				}
				if(confirm("�Ƿ�ȷ���ύע�� ��")){//CCS-1154,��ͬ�ύע�ᣬ���ӡ�����ȷ����ʾ��
					//add by yongxu 20150709  
					if (sSureType=="APP"){
						alert("PAD�˺�ͬ������PC���ύ��");
						return false;
					}
					//end by yongxu
					var sSignRet = RunJavaMethodSqlca("com.amarsoft.app.billions.CommonTransationFix", "contractRegistration", "objectno="+sObjectNo);
					if ("Failure" === sSignRet) {
						alert("�ύע��ʧ�ܣ��������ݿ����ӣ�");
					}
					//add by fangxq 20151228
					reloadSelf();
					return;
				}
				//end by fangxq
				//if(sCustomerType=="0310"){//���˿ͻ�
					//�޸ĵ�ǰѡ�������״̬Ϊ"��ǩ��"020��ͬ״̬
					<%-- RunMethod("BusinessManage","UpdateReturn",sObjectNo+","+"020,<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>"); --%>
					//�޸Ľ׶�Ϊ"��ǩ��"��
					/* RunMethod("BusinessManage","UpdateApplyPhaseType",sObjectNo+","+sObjectType+","+"1070"); */
				reloadSelf();
				//}
				return;
			}
			/***********end**********************************************************************/
	}
	/*~[Describe=ִ�зſ��;InputParam=��;OutPutParam=��;]~*/
	function makePaymentPlan(){
		/* �����á�������������������������������������������������������������������������������������������������������*/
		//var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var productID = getItemValue(0,getRow(),"BusinessType");
		/* if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} */
		if(confirm("�����ȷ��ִ�зſ����")){
			CalcMaturity();
			var sReturn = RunMethod("LoanAccount","RunTransaction3",productID+",,TRA001,<%=BUSINESSOBJECT_CONSTATNTS.business_contract%>,"+sObjectNo+",<%=CurUser.getUserID()%>,");
			if(typeof(sReturn)=="undefined"||sReturn.length==0){
				alert("ϵͳ�����쳣��");
				return;
			}
			alert(sReturn.split("@")[1]);
			reloadSelf();
			return;
		}
	}
	/*~[Describe=���㵽����;InputParam=��;OutPutParam=��;]~*/
	function CalcMaturity(){
		var SerialNo=getItemValue(0,getRow(),"SerialNo");//��ͬ��ˮ��
		<%-- var sPutOutDate = "<%=DateUtil.getToday()%>";//��ͬ��Ч�� --%>
		var sPutOutDate = "<%=SystemConfig.getBusinessDate()%>";
		var sDay = sPutOutDate.substring(8,10); 
		var deDaultDueDay = "";
		if(sDay == "29" ){
			deDaultDueDay = "02";
			RunMethod("PublicMethod","UpdateColValue","String@defaultdueday@"+deDaultDueDay+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//��ͬ��Ч��
		}else if(sDay == "29"){
			deDaultDueDay = "03";
			RunMethod("PublicMethod","UpdateColValue","String@defaultdueday@"+deDaultDueDay+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//��ͬ��Ч��
		}else if(sDay == "30"){
			deDaultDueDay = "04";
			RunMethod("PublicMethod","UpdateColValue","String@defaultdueday@"+deDaultDueDay+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//��ͬ��Ч��
		}	
    	var sTermMonth_ = RunMethod("GetElement","GetElementValue","Periods,business_contract,SerialNo='"+SerialNo+"'");//����
    	var sTermMonth = parseInt(sTermMonth_,10);
    	var sMaturity = "";
		if(typeof(sTermMonth)== "undefined" || sTermMonth.length == 0 ) {
			alert("��ͬδ¼������ڴΣ�");
			return ;
		}
		if(sTermMonth !=0){
		   sLoanTermFlag ="020";//���޵�λ(��)
		   sMaturity = RunMethod("BusinessManage","CalcMaturity",sLoanTermFlag+","+sTermMonth+","+sPutOutDate);
		}
		RunMethod("PublicMethod","UpdateColValue","String@PutOutDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//��ͬ��Ч��
		RunMethod("PublicMethod","UpdateColValue","String@contractEffectiveDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//��ͬ��Ч��
		RunMethod("PublicMethod","UpdateColValue","String@Maturity@"+sMaturity+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//��ͬ������
	}
	
	
	/*~[Describle=���������ϴ�;InputParam=��;OutPutParam=��;]*/
	function informationUpload(){
		//����������͡�������ˮ��
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		 if(getItemValue(0,getRow(),"uploadFlag")=="�����ϴ�"){
			 alert("�ò�Ʒ�����ϴ��������ϣ�");
			 return false;
		 } 
		 var sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.image.ImageUploadAfterLoan","checkUploadImageEnabled","sNo="+'<%=sNo%>'+",sObjectNo="+sObjectNo);
		 if(sReturn=="PASS"){
			 var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo+"&uploadPeriod=1";
			 AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
		 }else if(sReturn == "NIDC"){
			 alert("����ָ�����в����ϴ��������ϣ�");
			 reloadSelf();
			 return false;
		 }else if(sReturn == "ORD"){
			 //����δ�ϴ���������״̬
			 var sStatus = RunJavaMethodSqlca("com.amarsoft.app.als.image.ImageUploadAfterLoan","getUploadStatusWhenOverdue","sObjectNo="+sObjectNo);
//			 RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkresult2,"+sStatus+",SerialNo='"+sObjectNo+"' ");
			 alert("�ѳ���ָ���Ĵ��������ϴ�ʱ�䣡");
			 reloadSelf();
			 return false;
		 }
	}
	
	//�ϴ�����������ύ
	function uploadImageSubmit(){
		//����������͡�������ˮ�š����̱�š��׶α�š���������
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sToday = "<%=sToday%>";
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//�ж��Ƿ����ϴ���������
		var sAmount = RunMethod("���÷���","GetColValue","ECM_PAGE,count(1),objectno = '"+sObjectNo+"' and  objectType = 'BusinessLoan' ");
		if(sAmount==0){
			alert("δ�ϴ��κδ������ϣ�");
			return false;
		}
		//���´����ϴ�״̬Ϊ�����ϴ���
		RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,uploadFlag,1,SerialNo = '"+sObjectNo+"' ");
		//���´�����״̬Ϊδ���
		RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkstatus,2,SerialNo = '"+sObjectNo+"' ");
		//���´������Ͻ��������ʱ��
		RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checktime,"+sToday+",SerialNo = '"+sObjectNo+"' ");
		alert("�ύ�ɹ�!");
		reloadSelf();
		return false;
	}
	/*~[Describle=��������������;InputParam=��;OutPutParam=��;]*/
	/**
	function subjoinCondition(){
		//����������͡�������ˮ��
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	}**/

	//add CCS-574 PRM-256 ԭ�ظ���ƻ���˶ϵͳ����  by rqiao 20150401
	/*~[Describle=������;InputParam=��;OutPutParam=��;]*/
	function ReconsiderSubmit()
	{
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");//��ͬ���
		var sObjectType = "<%=sObjectType%>";	
		var sApplyType = "<%=sApplyType%>";	
		//��ȡ��ǰFLOW_TASK�������ͬ�ĵı�� ������FLOW_TASK���һ������ 
		var sSerialNo = RunMethod("���÷���", "GetColValue", "FLOW_TASK,MAX(SerialNo), ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'");
		var sUserName = "<%=CurUser.getUserName()%>";
		var sOrgName = "<%=CurUser.getOrgName()%>";
		var returnValue = RunMethod("���÷���", "GetColValue", "FLOW_OBJECT,FlowNo||'@'||FlowName,ObjectNo='"+sObjectNo+"'");
		
		var sNextFlowNo = returnValue.split("@")[0];
		var sFlowName = returnValue.split("@")[1];
		var sInitFlowNo = "<%=sInitFlowNo%>";
		var sInitPhaseNo = "<%=sInitPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var sOrgID = "<%=CurOrg.orgID%>";
		var sInputTime= "<%=StringFunction.getTodayNow()%>"
		var sAllowReconsider = getItemValue(0,getRow(),"AllowReconsider");//add ���ܷ�ԭ�ظ��  by  hhuang 20150630
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		//����Ƿ����ԭ�ظ������룬�����ظ�����
		var sRelativeCount = RunMethod("���÷���", "GetColValue", "BUSINESS_CONTRACT,SerialNo,RelativeSerialNo='"+sObjectNo+"'");
		if(null == sRelativeCount) sRelativeCount = "";
		
		if("undefined" != sRelativeCount && "Null" != sRelativeCount && sRelativeCount.length > 0)
		{
			alert("�ú�ͬ�ѽ��й�ԭ�ظ��������ѡ��");
			return;
		}
		
		if(confirm("ȷ�ϸ��������")){
			//add ����IF��������������ύ����ܷ�ԭ�ظ�� = N�ĺ�ͬ��ϵͳ��ʾ����Ȩ�ޡ�  BY HUANGHUI 20150706
			var sPar_Value = "ObjectType="+sObjectType+",ObjectNo="+sObjectNo+",ApplyType="+sApplyType+",FlowNo="+sInitFlowNo+",PhaseNo="+sInitPhaseNo+",serialNo="+sSerialNo+",UserID="+sUserID+",OrgID="+sOrgID+",userName="+sUserName+",orgName="+sOrgName+",NextFlowNo="+sNextFlowNo+",FlowName="+sFlowName+",InputTime="+"<%=StringFunction.getTodayNow()%>";
			returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddReconsiderInfo", "CheckReconsiderRule",sPar_Value);
			if(typeof(returnValue)=="undefined"||returnValue.length==0){
				alert("ϵͳ�����쳣��");
				return;
			}
			
			if("��"==sAllowReconsider || "Success" != returnValue)
			{
				alert("��Ȩ��");
				return;
			}
			
			// ԭ�ظ���ԭ�򵯳���   add by yzhang9 
			var sCompID = "ResurrectionReason";
			var sCompURL = "/Common/WorkFlow/ResurrectionReason.jsp";
			var sReturn = popComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApplyType="+sApplyType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo+"&SerialNo="+sSerialNo+"&UserID="+sUserID+"&OrgID="+sOrgID+"&UserName="+sUserName+"&OrgName="+sOrgName+"&NextFlowNo="+sNextFlowNo+"&FlowName="+sFlowName+"&InputTime="+sInputTime,"dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			
			if (typeof(sReturn)=="undefined" || sReturn.length==0){
				reloadSelf();
				return;
			}
			//var sResurrectionReason = returnValue.split("@")[0]; //��ӦCode: ResurrectionReason  
			//var sResurrectionReasonRemark = returnValue.split("@")[1];//������ѡ��'����'ʱ  ��д��������ע 
			//������ԭ����µ� ��ͬ���ֶ� 
			/* RunMethod("���÷���","UpdateColValue","business_contract,ResurrectionReason,"+sResurrectionReason+",serialno='"+sObjectNo+"'");
			if(sResurrectionReasonRemark!=""){
				RunMethod("���÷���","UpdateColValue","business_contract,ResurrectionReasonRemark,"+sResurrectionReasonRemark+",serialno='"+sObjectNo+"'");
			} */
			if(sReturn == "false"){
				reloadSelf();
				return;
			}
			
			//var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddReconsiderInfo", "GenerateReconsiderContractInfo",sPar_Value);

			if(typeof(sReturn)=="undefined"||sReturn.length==0||("Success" == sReturn.split("@")[0] && sReturn.indexOf("@")==-1)){
				alert("ϵͳ�����쳣��");
				return;
			}
			else if("Faile" == sReturn.split("@")[0])
			{
				alert("��Ȩ��");
				/* RunMethod("���÷���","UpdateColValue","business_contract,ResurrectionReason,,serialno='"+sObjectNo+"'");
				RunMethod("���÷���","UpdateColValue","business_contract,ResurrectionReasonRemark,,serialno='"+sObjectNo+"'"); */
				return;
			}else 
			{
				ShowMessage("ϵͳ�����ύ����ȴ�...",true,true);
				alert("����ɹ�");
					
				try{hideMessage();}catch(e) {}//add in 
				reloadSelf();
			}
		}
	}
	//end
	
	// add by xswang 2015/05/25 CCS-808 ϵͳȫ���̵��ӻ����죺�ļ��������
	//�ļ���������
	function viewErrorDoc(){
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo"); //��ͬ��ˮ��
		//���������ϴ������ִ�ǰ����
		var sContractStatus = getItemValue(0,getRow(),"ContractStatus"); //��ͬ״̬
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if(sContractStatus == "��ע��"){
			var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo+"&OperateMode=upload";
			AsControl.OpenView("/ImageManage/ImageAfterLoanCheckList.jsp",param,"_blank","");
		}
	}
	
	//���������ύ
	function checkdocSubmit(){
		//���ݺ�ͬ״̬�ж��Ƿ���Ҫ�ύ
		var sContractStatus = getItemValue(0,getRow(),"ContractStatus"); //��ͬ״̬

		//����������͡�������ˮ�š����̱�š��׶α�š���������
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		var sApplyType1 = "<%=sApplyType%>";
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sUserID = "<%=CurUser.getUserID()%>";
		var sToday = "<%=sToday%>";
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(sContractStatus == "��ע��"){
			//�������ϼ��
			//������������ϸ���״̬
			RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkstatus,6,SerialNo = '"+sObjectNo+"' ");
			alert("�ύ�ɹ�!");
			reloadSelf();
			return false;
		}
	}
	// end by xswang 2015/05/25
	
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