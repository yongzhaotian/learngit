<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: pli2 2015-4-3
		Tester:
		Describe: �����˹������м�¼�б�
		
		Input Param:
		SerialNo:��ˮ��
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����˹������� "; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����,�����˱��
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
	if(sSerialNo == null) sSerialNo = "";
	System.out.println(sSerialNo+"---");
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "LoanManCityList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled=true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(100);  //��������ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�����������ݣ�2013-5-9
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
		{"true","","Button","���ô����˳���","����","getRegionCode()",sResourcesPath},
		{"true","","Button","���ù鼯��","�鼯��","turnAccount()",sResourcesPath},
		{"true","","Button","���ø�ʽ������ģ��","��ʽ������","loanManEDoc()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еĳ���","deleteRecord()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		var sRetVal = setObjectValue("SelectCityCodeNoMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("��ѡ��������У�");
			return;
		}
		sRetVal=sRetVal.split("~");
		for(var i=0;i<sRetVal.length;i++){
			sRetVal1=sRetVal[i].split("@");
			 RunMethod("BusinessTypeRelative","InsertBusRelative","InsuranceCity_Info,SerialNo,InsuranceNo,CityNo,"+getSerialNo("InsuranceCity_Info", "SerialNo", "")+",<%=sSerialNo%>,"+sRetVal1[0]);
		}
		reloadSelf();
	}
	
	//���ø�ʽ������ģ��
	function loanManEDoc(){
		var sSerialNos = getItemValueArray(0,"SerialNo");
		var sAreaCodes = getItemValueArray(0,"AreaCode");
		var sProductTypes = getItemValueArray(0,"ProductType");
		var sSerialNo = sSerialNos[0];
		var sAreaCode = sAreaCodes[0];
		var sProductType = sProductTypes[0];

		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || typeof(sAreaCode)=="undefined" || sAreaCode.length==0 ||typeof(sProductType)=="undefined" || sProductType.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		var sRetVal = setObjectValue("SelectDOCCodeNo", "", "", 0, 0, "dialogWidth:500px;dialogHeight:400px;");
		if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("��ѡ��ģ�����ͣ�");
			return;
		}
		sRetVal = sRetVal.replace("@","");
		AsControl.PopView("/BusinessManage/CollectionManage/LoanManDocInfo.jsp", "AreaCodes="+sAreaCodes+"&SerialNoS="+sSerialNos+"&ProductTypes="+sProductTypes+"&TypeNo="+sRetVal, "dialogWidth:500px;dialogHeight:500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	//���ù鼯��
	function turnAccount(){
		var sSerialNos = getItemValueArray(0,"SerialNo");
		var sAreaCodes = getItemValueArray(0,"AreaCode");
		var sProductTypes = getItemValueArray(0,"ProductType");
		var sSerialNo = sSerialNos[0];
		var sAreaCode = sAreaCodes[0];
		var sProductType = sProductTypes[0];
		
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || typeof(sAreaCode)=="undefined" || sAreaCode.length==0 ||typeof(sProductType)=="undefined" || sProductType.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		AsControl.PopView("/BusinessManage/CollectionManage/TurnAccountInfo.jsp", "AreaCodes="+sAreaCodes+"&SerialNoS="+sSerialNos+"&ProductTypes="+sProductTypes, "dialogWidth=360px;dialogHeight=320px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	//���ô����˳���
	function getRegionCode(){
		var sSerialNo = "<%=sSerialNo%>";
		
		var sLoaner = RunMethod("LoanAccount", "selectLoanerType", sSerialNo);
		if(sLoaner==null || typeof(sLoaner)=="undefined" || sLoaner.length==0){
			alert("�����ڴ������������ô��������ͣ�");
			return;
		}
		var result = setObjectValue("selectSubProductType","","",0,0,""); //��ȡҪ�����Ĳ�Ʒ����
 		if(typeof(result)=="undefined" || result.length==0 || result=="_CLEAR_"){
 			return;
 		}
 		result = result.replace("@","");
 		var sReturn = RunMethod("LoanAccount", "selectCityIsNotNull", sLoaner+","+result);
 		if(sReturn==0){
 			alert("�ò�Ʒ�������Ѿ�û�пɹ����ĳ����ˣ�");
 			return;
 		}
	    var sCityName = PopPage("/BusinessManage/CollectionManage/AddLoanManCity.jsp?SerialNo="+sSerialNo+"&ProductType="+result+"&sLoaner="+sLoaner,"","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
	    if(typeof(sCityName)=="undefined" || sCityName.length==0 || sCityName=="_none_"){
	    	return;
	    }
	    reloadSelf();
	}
	
	function deleteRecord(){

		var sSerialNos = getItemValueArray(0,"SerialNo");
		var sAreaCodes = getItemValueArray(0,"AreaCode");
		var sProductTypes = getItemValueArray(0,"ProductType");
		var sSpSerialNos = getItemValueArray(0,"SpSerialNo");
		var sSerialNo = sSerialNos[0];
		var sAreaCode = sAreaCodes[0];
		var sProductType = sProductTypes[0];
		var params = "";
		
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0 || typeof(sAreaCode)=="undefined" || sAreaCode.length==0 ||typeof(sProductType)=="undefined" || sProductType.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		if(confirm("�������ɾ������Ϣ��")){
			var strList = "";
			for(var i = 0; i < sSerialNos.length; i++){
				strList = strList + sSerialNos[i] + "@@" + sAreaCodes[i] + "@@" + sProductTypes[i] + "|";
			}
			if (strList != null && strList != "") {
				strList = strList.substring(0, strList.length - 1);
			}
			
			params = "paramList=" + strList;
			var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.DelectLoanCity",
				"deletLoaner", params);			
			if (result.split("@")[0] != "true") {
				alert(result.split("@")[1]);
				return;
			} else {
				alert("ɾ���ɹ���");
				reloadSelf();
				return;
			}
		}
	}
	
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
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

<%@	include file="/IncludeEnd.jsp"%>

