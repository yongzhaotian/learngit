<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "ί�����";
	//���ҳ�����
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	if(sPhaseType1==null) sPhaseType1="";
	String sTempletNo="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	if(sType.endsWith("4")){
		sTempletNo = "ConsumeQIQIANCollectionList";//ģ�ͱ��
	}else{
		sTempletNo ="ConsumeCollectionProviderList";
	}
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseType1);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","�鿴��ͬ","�鿴��ͬ","OverDuelContractList()",sResourcesPath},
		{"true","","Button","�鿴��ʷ","�鿴��ʷ","viewHistory()",sResourcesPath},
		{"true","","Button","����","����","viewAndEdit()",sResourcesPath},
		{"true","","Button","����","����","expornt()",sResourcesPath},
		{"true","","Button","ɾ�� ","ɾ��","deleteXin()",sResourcesPath},
		{"false","","Button","����ί�⹫˾","����ί�⹫˾","editCommpany()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	//�ж�����¼��
	function viewAndEdit(){
		var sType="<%=sType%>";
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// ����Excel�� alert("��ѡ���ļ���");
			return;
		}
		alert(sFilePath);
		if(sType=="4"){
			RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "importCommusModel1", "filePath="+sFilePath+",flag=1"+",userid="+"<%=CurUser.getUserID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		}else{
			RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "importCommusModel", "filePath="+sFilePath+",flag=1"+",userid="+"<%=CurUser.getUserID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		}
		reloadSelf();
	}
	
	function expornt(){
		amarExport("myiframe0");
	}
	
	//�鿴������ʷ 
	function viewHistory(){
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenPage("/BusinessManage/CollectionManage/ConsumeCollectionRegistList.jsp", "CustomerID="+sCustomerID+"&PhaseType1=<%=sPhaseType1%>", "_self","");
		
	}
	
	function deleteXin(){
		var sLoanNo = getItemValue(0,getRow(),"SERIALNO");//�޸�Ϊ wlq 
		if (typeof(sLoanNo)=="undefined" || sLoanNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}
	
	/*�鿴�ͻ������������ں�ͬ*/
	function OverDuelContractList(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("�ô���������Ϣ���������ͻ���Ϊ�գ�");
			return;
		}
	
		sCompID = "ConsumeOverDuelBCList";
		sCompURL = "/BusinessManage/CollectionManage/ConsumeOverDuelBCList.jsp";
		sParamString = "CustomerID="+sCustomerID;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=850px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		reloadSelf();
	}

	
	//add  wlq  ����ί�⹫˾  20140725  --
	function editCommpany(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "ConsumeOverDuelBCList";
		sCompURL = "/BusinessManage/CollectionManage/ConsumeOverDuelBCFrame.jsp";
		sParamString = "temp=002&SerialNo="+sSerialNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=950px;dialogHeight=650px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		reloadSelf();
	}
	

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
