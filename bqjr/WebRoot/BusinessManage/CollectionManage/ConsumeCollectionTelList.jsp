<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "�绰���������б����";
 
	//���ҳ�����
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));
	String sButtonM1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("buttonM1"));
	String sButtonM2 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("buttonM2"));
	String sButtonM3 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("buttonM3"));
	System.out.println(sButtonM1+","+sButtonM2+","+sButtonM3);
	if(sButtonM1==null) sButtonM1="";
	if(sButtonM2==null) sButtonM2="";
	if(sButtonM3==null) sButtonM3="";
	if(sPhaseType1==null) sPhaseType1="";
	

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ConsumeCollectionTelList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//�����ѡ
	if(sPhaseType1.equals("0011") && sButtonM1.equals("false")){
		doTemp.multiSelectionEnabled=true;
	}
	if(sPhaseType1.equals("0012") && sButtonM2.equals("false")){
		doTemp.multiSelectionEnabled=true;
	}
	if(sPhaseType1.equals("0013") && sButtonM3.equals("false")){
		doTemp.multiSelectionEnabled=true;
	}
	doTemp.setHTMLStyle("CUSTOMERID", "style={width:80px}");
	doTemp.setHTMLStyle("CustomerName","style={width:120px} ");  
	doTemp.setHTMLStyle("Sex","style={width:30px} ");  
	//���ݽ�ɫ����ҳ����ʾ�ĺ�ͬ���� 
	if(sPhaseType1.equals("0011") && sButtonM1.equals("true")){
		doTemp.WhereClause+=" and INPUTUSERID='"+CurUser.getUserID()+"'";
	}
	if(sPhaseType1.equals("0012") && sButtonM2.equals("true")){
		doTemp.WhereClause+=" and INPUTUSERID='"+CurUser.getUserID()+"'";
	}
	if(sPhaseType1.equals("0013") && sButtonM3.equals("true")){
		doTemp.WhereClause+=" and INPUTUSERID='"+CurUser.getUserID()+"'";
	}

	// doTemp.generateFilters(Sqlca);
	
	doTemp.setFilter(Sqlca, "0020", "CUSTOMERID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0023", "CerdID", "Operators=EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	
	// �ͻ���ź����֤������һ����ֵ��Ϊ��ѯ��������֤��ѯЧ��
	boolean flag = true;
	for(int k=0;k<doTemp.Filters.size();k++){
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null){
			flag = false;
			break;
		}
	}
	if(!doTemp.haveReceivedFilterCriteria()) {
		doTemp.WhereClause += " and 1=2";
	} else if(flag) {
		%>
		<script type="text/javascript">
			alert("Ϊ�˿��ٲ�ѯ���ͻ���š����֤��������һ����");
		</script>
		<%
		doTemp.WhereClause += " and 1=2";
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(15);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseType1);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","�鿴��ͬ","�鿴��ͬ","OverDuelContractList()",sResourcesPath},
		{"true","","Button","�ж�����¼��","�ж�����¼��","viewAndEdit()",sResourcesPath},
		{"true","","Button","��ʷ��ѯ","��ʷ��ѯ","viewHistory()",sResourcesPath},
		{"true","","Button","��������","��������","toUser()",sResourcesPath},
		{"false","","Button","�ٴδ���","�ٴδ���","B()",sResourcesPath},
		{"false","","Button","���ü���","���ü���","q()",sResourcesPath},
		{"false","","Button","����ת��","����ת��","w()",sResourcesPath},
		{"false","","Button","���ڼ�¼ͳ�Ʋ�ѯ","���ڼ�¼ͳ�Ʋ�ѯ","a()",sResourcesPath},
		{"false","","Button","���ŷ���","���ŷ���","b()",sResourcesPath},
		{"false","","Button","���ʷ���","���ʷ���","c()",sResourcesPath},
	};
	
	if(sPhaseType1.equals("0011") && sButtonM1.equals("true")){
		sButtons[3][0]="false";
	}
	if(sPhaseType1.equals("0012") && sButtonM2.equals("true")){
		sButtons[3][0]="false";
	}
	if(sPhaseType1.equals("0013") && sButtonM3.equals("true")){
		sButtons[3][0]="false";
	}

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


	//�ж�����¼��
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");//������ˮ��
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");//�ͻ����
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		sCompID = "ConsumeCollectionRegistInfo";
		sCompURL = "/BusinessManage/CollectionManage/ConsumeCollectionRegistInfo.jsp";
	    popComp(sCompID,sCompURL,"CollectionSerialNo="+sSerialNo+"&CustomerID="+sCustomerID+"&PhaseType1=<%=sPhaseType1%>","dialogWidth=400px;dialogHeight=480px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	
	//�鿴������ʷ 
	function viewHistory(){
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenPage("/BusinessManage/CollectionManage/ConsumeCollectionRegistList.jsp", "CustomerID="+sCustomerID+"&PhaseType1=<%=sPhaseType1%>&&buttonM1=<%=sButtonM1%>&&buttonM2=<%=sButtonM2%>&&buttonM3=<%=sButtonM3%>", "_self","");
		
	}
	
	function toUser(){
		sSerialNo=getItemValueArray(0, "SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����");
			return;
		}
		var roleID="";
		if("<%=sPhaseType1%>"=="0011"){
			roleID="1510";
		}else if("<%=sPhaseType1%>"=="0012"){
			roleID="1511";
		}else{
			roleID="1512";
		}
		var sRetVal = setObjectValue("SelectConsumeUserID", "RoleID,"+roleID, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("��ѡ��һ������רԱ��");
			return;
		}
		sRetVal=sRetVal.split("@");
		for(var i=0;i<sSerialNo.length;i++){
			RunMethod("ModifyNumber","GetModifyNumber","CONSUME_COLLECTION_INFO,INPUTUSERID='"+sRetVal[0]+"',SERIALNO='"+sSerialNo[i]+"'");
		}
	    reloadSelf();
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


	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
