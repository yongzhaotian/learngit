<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sMobilePoseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MOBLIEPOSNO"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	if(sSNo == null) sSNo = "";
	if(sMobilePoseNo == null) sMobilePoseNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "MobilePosSalesmanList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    doTemp.WhereClause+=" and SType is null";
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(30);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sMobilePoseNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  ����  ����  �ر�  ��ʱ�ر�  ȡ���ر�
		{CurUser.hasRole("1005")&&"0010".equals(sPhaseNo)?"true":"false","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{sPhaseNo.equals("0010")||CurUser.hasRole("1004")||CurUser.hasRole("1049")?"true":"false","","Button","�����","ɾ��","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	
	function newRecord(){
//		alert("<%=sSNo %>");
//		alert("<%=sMobilePoseNo %>");
		
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/SalesmanInfo.jsp","SNo=<%=sSNo %>&MobilePoseNo=<%=sMobilePoseNo%>&PhaseNo=<%=sPhaseNo%>","_self","");
	}
	
	function deleteRecord(){
		var sSno = getItemValue(0, getRow(), "SNO");
		var sSalesManager = getItemValue(0, getRow(), "SALEMANAGERNO");
		var sSalesman = getItemValue(0, getRow(), "SALESMANNO");
    	var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			// ���µ�ǰ������Ա
			<%-- RunMethod("���÷���", "UpdateColValue", "User_Info,SuperId,,UserId='"+sSalesman+"' and IsCar='02' and Status='1'");
			var sParam = "type=02,sNo="+getItemValue(0, 0, "SNO")+",salesmanNos="+sSalesman+",salesManager="+sSalesManager+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
			RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon","insertHistory",sParam); --%>
			reloadSelf();
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/SalesmanInfo.jsp","SerialNo="+sSerialNo+"&SNo=<%=sSNo %>&MobilePoseNo=<%=sMobilePoseNo%>&ActionType=Detail&VIWEFLAG=2&PhaseNo=<%=sPhaseNo%>","_self","");
		
	}
	

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>