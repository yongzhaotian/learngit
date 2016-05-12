<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: Ԥ���źŷ����϶���Ϣ_List
		Input Param:			 
			SignalType��Ԥ�����ͣ�01������02�������
			SignalStatus��Ԥ��״̬��10��������15�����ַ���20�������У�30����׼��40�������    
	 */
	String PG_TITLE = "Ԥ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sSql = "";
		
	//����������	
	String sSignalType = CurPage.getParameter("SignalType");
	String sSignalStatus = CurPage.getParameter("SignalStatus");
	//����ֵת��Ϊ���ַ���	
	if(sSignalType == null) sSignalType = "";
	if(sSignalStatus == null) sSignalStatus = "";	

	String[][] sHeaders = {							
							{"CustomerName","�ͻ�����"},
							{"SignalName","Ԥ���ź�"},
							{"SignalType","Ԥ������"},
							{"SignalStatus","Ԥ��״̬"},													
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�ʱ��"}
							};
		
	sSql =  " select RS.ObjectNo,GetCustomerName(RS.ObjectNo) as CustomerName, "+
			" RS.SignalName,getItemName('SignalType',RS.SignalType) as SignalType, "+
			" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus, "+
			" GetOrgName(RS.InputOrgID) as InputOrgName, "+
			" GetUserName(RS.InputUserID) as InputUserName,RS.InputDate,RS.SerialNo, "+
			" RS.ObjectType "+
			" from RISK_SIGNAL RS,RISKSIGNAL_OPINION RO "+
			" where RS.SerialNo = RO.ObjectNo "+
			" and RS.ObjectType = 'Customer' "+
			" and RS.SignalType = '"+sSignalType+"' "+
			" and RS.SignalStatus = '"+sSignalStatus+"' "+
			" and RO.CheckUser = '"+CurUser.getUserID()+"' ";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	//���ø�ʽ
	doTemp.setHTMLStyle("CustomerName,SignalName","style={width:180px}");
	doTemp.setHTMLStyle("SignalType,SignalStatus","style={width:80px}");
	doTemp.setAlign("SignalType,SignalStatus","2");
	//���ù�����
	doTemp.setColumnAttribute("CustomerName,SignalName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {	
			{(sSignalStatus.equals("20")?"true":"false"),"","Button","ǩ�����","��д�ñ�Ԥ����Ϣ���϶����","newOpinion()",sResourcesPath},		
			{"true","","Button","�鿴���","�鿴/�޸��϶��������","viewOpinion()",sResourcesPath},
			{"true","","Button","Ԥ������","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{(sSignalStatus.equals("20")?"true":"false"),"","Button","��дԤ����鱨��","��дԤ����鱨��","writeReport()",sResourcesPath},
			{(sSignalStatus.equals("20")?"true":"false"),"","Button","�ύ","�ύ��ѡ�еļ�¼","commitRecord()",sResourcesPath},
			{(sSignalStatus.equals("30")?"true":"false"),"","Button","�鿴Ԥ����鱨��","�鿴Ԥ����鱨��","viewReport()",sResourcesPath},		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=ǩ�����;InputParam=��;OutPutParam=��;]~*/
	function newOpinion(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "SignRiskSignalOpinionInfo";
		sCompURL = "/CreditManage/CreditAlarm/SignRiskSignalOpinionInfo.jsp";
		OpenComp(sCompID,sCompURL,"ObjectNo="+sSerialNo+"&SignalType=<%=sSignalType%>","_blank",OpenStyle);		
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinion(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		AsControl.PopView("/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","ObjectNo="+sSerialNo+"&SignalType=<%=sSignalType%>","");
	}
	
	function viewReport(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,INSPECT_INFO,String@ObjectType@RiskSignal@String@ObjectNo@"+sSerialNo);
		if(typeof(sReturn)=="undefined" || sReturn.length == 0){
			alert(getBusinessMessage('678'));//��δ����Ԥ����鱨��
			return;
		}
		AsControl.PopView("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
	}
	/*~[Describe=��дԤ����鱨��;InputParam=��;OutPutParam=��;]~*/
	function writeReport(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,INSPECT_INFO,String@ObjectType@RiskSignal@String@ObjectNo@"+sSerialNo);
		if(typeof(sReturn)!="undefined" && sReturn.length != 0){
			alert('�Ѿ����Ԥ����鱨�棬ֻ�ܲ鿴');//�Ѿ����Ԥ����鱨�棬ֻ�ܲ鿴
			
		}
		AsControl.PopView("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
	}
					
	/*~[Describe=�鿴���޸��������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/CreditManage/CreditAlarm/RiskSignalApproveInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=�ύ��¼;InputParam=��;OutPutParam=��;]~*/
	function commitRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		//����Ƿ���дԤ����鱨��		
		sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,INSPECT_INFO,String@ObjectType@RiskSignal@String@ObjectNo@"+sSerialNo);
		if(typeof(sReturn)=="undefined" || sReturn.length == 0){
			alert(getBusinessMessage('678'));//��δ����Ԥ����鱨��
			return;
		}
		//����Ƿ�ǩ�����
		sReturn=RunMethod("PublicMethod","GetColValue","Opinion,RISKSIGNAL_OPINION,String@ObjectNo@"+sSerialNo);
		sReturnValue=sReturn.split("~");
		sReturnValue=sReturnValue[0].split("@");
		if(typeof(sReturnValue[1])=="undefined" || sReturnValue[1].trim().length == 0||sReturnValue[1]=="null"){
			alert("��δǩ�������");//��δǩ�������
			return;
		}
		if(confirm(getHtmlMessage('17'))){ //ȷ����Ҫ�ύ�ü�¼��
			sSignalStatus = PopPage("/CreditManage/CreditAlarm/AddSignalStatusDialog.jsp","","resizable=yes;dialogWidth=18;dialogHeight=8;center:yes;status:no;statusbar:no");
			if(typeof(sSignalStatus) != "undefined" && sSignalStatus.length != 0 && sSignalStatus != '_none_'){
				//�ύ����
				sReturn = RunMethod("PublicMethod","UpdateColValue","String@SignalStatus@"+sSignalStatus+",RISK_SIGNAL,String@SerialNo@"+sSerialNo);
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
					alert(getHtmlMessage('9'));//�ύʧ�ܣ�
					return;
				}else{
					reloadSelf();
					alert(getHtmlMessage('18'));//�ύ�ɹ���
				}
			}	
		}			
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>