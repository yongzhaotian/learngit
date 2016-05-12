<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: Ԥ���źŷ����϶���Ϣ_List
		Input Param:			 
			FinishType��������ͣ�Y������ɣ�N��δ��ɣ�			    
	 */
	String PG_TITLE = "Ԥ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sClewDate = "";
	String sSql = "";
		
	//����������	
	String sFinishType = CurPage.getParameter("FinishType");	
	//����ֵת��Ϊ���ַ���	
	if(sFinishType == null) sFinishType = "";
	
	//��ʾ����
	sClewDate = StringFunction.getRelativeDate(StringFunction.getToday(),7);
	
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
			" from RISK_SIGNAL RS "+
			" where RS.ObjectType = 'Customer' "+
			" and RS.SignalType = '01' "+ 
			" and RS.SignalStatus = '30' "+
			" and ((exists (select RO.ObjectNo from RISKSIGNAL_OPINION RO "+
			" where RO.ObjectNo = RS.SerialNo "+
			" and RO.NextCheckDate <= '"+sClewDate+"' "+
			" and RO.NextCheckUser = '"+CurUser.getUserID()+"'))) ";

	if(sFinishType.equals("N"))
		sSql += " and (FinishDate is null or FinishDate = ' ') ";
	if(sFinishType.equals("Y"))
		sSql += " and (FinishDate is not null and FinishDate <> ' ') ";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	
	doTemp.setHTMLStyle("CustomerName,SignalName","style={width:200px}");
	doTemp.setHTMLStyle("SignalType,SignalStatus","style={width:50px}");
	doTemp.setHTMLStyle("InputDate","style={width:80px}");
	//���ø�ʽ
	doTemp.setAlign("SignalType,SignalStatus","2");
	//���ù�����
	doTemp.setColumnAttribute("SignalName","IsFilter","1");
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
			{(sFinishType.equals("N")?"true":"false"),"","Button","Ԥ���������","��д�ñ�Ԥ����Ϣ��Ԥ����鱨��","newReport()",sResourcesPath},		
			{(sFinishType.equals("Y")?"true":"false"),"","Button","�鿴Ԥ����鱨��","�鿴/�޸�Ԥ����鱨������","viewReport()",sResourcesPath},
			{"true","","Button","Ԥ������","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{(sFinishType.equals("N")?"true":"false"),"","Button","��ɼ��","�ύ��ѡ�еļ�¼","commitRecord()",sResourcesPath}		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=Ԥ�����;InputParam=��;OutPutParam=��;]~*/
	function newReport(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		AsControl.PopView("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
	}
	
	/*~[Describe=�鿴Ԥ���������;InputParam=��;OutPutParam=��;]~*/
	function viewReport(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		AsControl.PopView("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
	}
					
	/*~[Describe=�鿴���޸�Ԥ������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		OpenPage("/CreditManage/CreditAlarm/RiskSignalCheckInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=�ύ��¼;InputParam=��;OutPutParam=��;]~*/
	function commitRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		//�ύ����
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishDate@<%=StringFunction.getToday()%>,RISK_SIGNAL,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("��ѡ��¼�ύʧ�ܣ�");
			return;
		}else{
			reloadSelf();
			alert("��ѡ��¼�ύ�ɹ���");
		}					
	}
		
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>