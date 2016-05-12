<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: Ԥ���źŷ�����Ϣ_List
		Input Param:			
			SignalType��Ԥ�����ͣ�01������02�������
			SignalStatus��Ԥ��״̬��10��������15�����ַ���20�������У�30����׼��40�������   
	 */
	String PG_TITLE = "Ԥ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
		
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
		
	String sSql =  " select ObjectNo,GetCustomerName(ObjectNo) as CustomerName, "+
			" SignalName,getItemName('SignalType',SignalType) as SignalType, "+
			" getItemName('SignalStatus',SignalStatus) as SignalStatus, "+
			" GetOrgName(InputOrgID) as InputOrgName, "+
			" GetUserName(InputUserID) as InputUserName,InputDate,SerialNo, "+
			" ObjectType "+
			" from RISK_SIGNAL "+
			" where ObjectType = 'Customer' "+
			" and SignalType = '"+sSignalType+"' "+   
			" and SignalStatus = '"+sSignalStatus+"' "+
			" and InputUserID = '"+CurUser.getUserID()+"' ";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//�����ֶ�λ��
	doTemp.setAlign("SignalType,SignalStatus","2");
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	//���ø�ʽ
	doTemp.setHTMLStyle("CustomerName","style={width:200px}");	
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
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{((!sSignalStatus.equals("10") && !sSignalStatus.equals("20"))?"true":"false"),"","Button","�鿴���","�鿴/�޸��϶��������","viewOpinion()",sResourcesPath},
			{"true","","Button","Ԥ������","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","�ύ","�ύ��ѡ�еļ�¼","commitRecord()",sResourcesPath},
			{(sSignalStatus.equals("30")?"true":"false"),"","Button","�鿴Ԥ����鱨��","�鿴Ԥ����鱨��","viewReport()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp","_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2'))){ //�������ɾ������Ϣ��
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinion(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		AsControl.PopView("/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","ObjectNo="+sSerialNo+"&SignalType=<%=sSignalType%>","");
	}
			
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=�ύ��¼;InputParam=��;OutPutParam=��;]~*/
	function commitRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
			
		if(confirm(getHtmlMessage('17'))){ //ȷ����Ҫ�ύ�ü�¼��
			//�ύ����
			sReturn = RunMethod("PublicMethod","UpdateColValue","String@SignalStatus@15,RISK_SIGNAL,String@SerialNo@"+sSerialNo);
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
				alert(getHtmlMessage('9'));//�ύʧ�ܣ�
				return;
			}else{
				reloadSelf();
				alert(getHtmlMessage('18'));//�ύ�ɹ���
			}				
	   	}	
	}
	/*~[Describe=��дԤ����鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewReport(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		AsControl.PopView("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
	}
		
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>