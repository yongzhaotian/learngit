<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	String sWhereClause =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("WhereClause"));
	if(sWhereClause==null) sWhereClause="";
	if(sTemp==null) sTemp="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "";//ģ�ͱ��
	if(sTemp.equals("001")){
		sTempletNo = "RetailList";
	}else if(sTemp.equals("002")){
		sTempletNo = "UserList";
	}else{
		sTempletNo = "StoreList";
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	//CCS-1209 �������룺���۲�ͬ����Ϣ��ѯ�����У����Ӳ�ѯ�ֶΣ����֤����
	if(sTemp.equals("002")){
		doTemp.setFilter(Sqlca, "0225", "CertId", "Operators=BeginsWith,EndWith,Contains,EqualsString;");
	}
	doTemp.parseFilterData(request,iPostChange);
	
	doTemp.WhereClause = " where 1=1";
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause = " where 1=2";
	if (!sWhereClause.equals("")) doTemp.WhereClause = sWhereClause;
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{sTemp.equals("001")?"false":"true","","Button","�ŵ�����","�ŵ�����","viewStoreInfo()",sResourcesPath},
		{sTemp.equals("001")?"false":"true","","Button","�ͻ�ԤԼ","�ͻ�ԤԼ","viewReservCustomerInfo()",sResourcesPath},
		{sTemp.equals("001")?"false":"true","","Button","�̻�ԤԼ","�̻�ԤԼ","viewReservCommercialInfo()",sResourcesPath},
		{sTemp.equals("001")?"false":"true","","Button","�鿴�ͻ�ԤԼ","�鿴�ͻ�ԤԼ","viewAppointInfo()",sResourcesPath},
		{sTemp.equals("001")?"false":"true","","Button","�鿴�̻�ԤԼ","�鿴�̻�ԤԼ","viewCommeInfo()",sResourcesPath},
	};
	if(sTemp.equals("002")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
		sButtons[4][0]="false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	<%/*~[Describe=�ͻ�ԤԼ;InputParam=��;OutPutParam=��;]~*/%>
	function viewReservCustomerInfo(){
		AsControl.OpenView("/CustomService/BusinessConsult/ReservCustomerConsultInfo.jsp","CType=01&WhereClause=<%=doTemp.WhereClause%>","_self","");
	}
	
	<%/*~[Describe=�̻�ԤԼ;InputParam=��;OutPutParam=��;]~*/%>
	function viewReservCommercialInfo(){
		AsControl.OpenView("/CustomService/BusinessConsult/ReservCommecialConsultInfo.jsp","CType=02&WhereClause=<%=doTemp.WhereClause %>","_self","");
	}
	
	<%/*~[Describe=�ŵ���Ϣ�鿴;InputParam=��;OutPutParam=��;]~*/%>
	function viewStoreInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/CustomService/BusinessConsult/StoreInfo.jsp","SerialNo="+sSerialNo+"&WhereClause=<%=doTemp.WhereClause %>&ViewId=02","_self","");
	}

	<%/*~[Describe=�ͻ�ԤԼ�鿴;InputParam=��;OutPutParam=��;]~*/%>
	function viewAppointInfo(){
		sCompID = "AppointManageList";
		sCompURL = "/InfoManage/QuickSearch/AppointManageList.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=800px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;help:no;");
	    reloadSelf();
	}
	
	<%/*~[Describe=�̻�ԤԼ�鿴;InputParam=��;OutPutParam=��;]~*/%>
	function viewCommeInfo(){
		sCompID = "CommecialAppoinmentList";
		sCompURL = "/BusinessManage/ChannelManage/CommecialAppoinmentList.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=800px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;help:no;");
	    reloadSelf();
	}


	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>