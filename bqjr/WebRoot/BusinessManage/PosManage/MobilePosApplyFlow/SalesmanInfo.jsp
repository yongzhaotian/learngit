<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "������Ա";

	// ���ҳ�����
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo")); //�ŵ���
	String sMobilePoseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MobilePoseNo")); //POS���
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));

	if (sSerialNo == null) sSerialNo = "";
	if (sSNo == null) sSNo="";
	if (sMobilePoseNo == null) sMobilePoseNo="";
	if(sPhaseNo == null) sPhaseNo = "";
	
	String starttime = ""; //��ʼʱ��
	String endtime = ""; //����ʱ��
	
	ASResultSet rs = null;//-- ��Ž����
	String sql = "SELECT t.STARTTIME,t.ENDTIME FROM mobilepos_info t WHERE moblieposno = :mobileposeno";
	rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("mobileposeno",sMobilePoseNo));
	if(rs.next()){
		starttime = rs.getString("STARTTIME");
		endtime = rs.getString("ENDTIME");
	}
	rs.getStatement().close();
	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "MobilePosSalesmanInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	// ��ȡ���ŵ����ڳ���
	
	// �����ֶοɼ�����
	
	/* if ("Detail".equals(sActionType)) {
		doTemp.setUnit("SALESMANNO", "<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectSalesmanSingle()>");
	} */
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{CurUser.hasRole("1005")&&"0010".equals(sPhaseNo)?"true":"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	function selectSalesman() {
		var args = "sSNo,<%=sSNo%>,sPOSNO,<%=sMobilePoseNo%>,starttime,<%=starttime%>,endtime,<%=endtime%>";
		
		var sSalManForPos = setObjectValue("SelectSalesmanByCityForMobilePos", args, "@SALESMANNO@0@USERNAME@1",0,0,"");
		
		if (typeof(sSalManForPos)=='undefined' || sSalManForPos.length==0) {
			alert("��ѡ��������Ա��");
			return;
			
		}
		sSalManForPos = sSalManForPos.substring(0, sSalManForPos.length-1);
		var retArry = sSalManForPos.split("@");
		var salNo = "";
		var salName = "";
		for (var i in retArry) {
			if (i%2==0) {
				salNo += retArry[i] + "@";
			} else if (i%2==1) {
				salName += retArry[i] + "@";
			}
		}
		salNo = salNo.substring(0,salNo.length-1)
		setItemValue(0, 0, "SALESMANNO",salNo );
//		setItemValue(0, 0, "SALESMANNAME", salName.substring(0,salName.length-1));

	}
	
<%-- 	function selectSalesman() {
		//CCS-541     //  AduEduRoleId    StuEduRoleId     add by yzhang9 CCS-571 UserId@Username
		alert("<%=sSNo%>");
		
		var sSalManForPos = setObjectValue("SelectSalesmanByCityForMobilePos", "sSNo,<%=sSNo%>", "");
		if (typeof(sSalManForPos)=='undefined' || sSalManForPos.length==0) {
			//alert("��ѡ��������Ա��");
			return;
		}
		sSalManForPos=sSalManForPos.substring(0,(sSalManForPos.length-1));
		var sSalManForPosArr = sSalManForPos.split("@");
		var salNo = "";
		var salName = "";
		for (var i=0;i<sSalManForPosArr.length;i++){
			if((i%2)==0){
				if(i==0){
					salNo = sSalManForPosArr[i];
				}else{
				salNo= salNo+","+ sSalManForPosArr[i];
				}
			}else{
				if(i==1){
					salName = sSalManForPosArr[i];
				}else{
					salName= salName+","+ sSalManForPosArr[i];
				}
			}
		}
		setItemValue(0, 0, "SALESMANNO", salNo);
		setItemValue(0, 0, "SALESMANNAME", salName);
		
		
		
	} --%>
	
function saveRecord(sPostEvents){
		
		var sSalesmanNos = getItemValue(0, 0, "SALESMANNO");
		
		if (typeof(sSalesmanNos)=="undefined" || sSalesmanNos=="") {
			alert("��ѡ�����۴���");
			return;
		}
		<%-- var sParam = "sNo=<%=sSNo%>"+",PosNo="+getItemValue(0, 0, "POSNO")+",salesmanNos="+getItemValue(0, 0, "SALESMANNO")+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
		var retResult= RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "MobilePosRelativeSalesman", sParam); --%>
		/* as_save("myiframe0",sPostEvents);  */
		<%-- var sPosNo = "<%=sMobilePoseNo%>"; --%>
		var sSerialno = getItemValue(0, 0, "SERIALNO");
		 var sPosNo = getItemValue(0, 0, "POSNO");
		var sInputOrg = "<%=CurUser.getOrgID()%>";
		var sInputUser = "<%=CurUser.getUserID()%>";
		var sInputDate = "<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";
		var sSno = "<%=sSNo%>";
		var salesmanager = RunMethod("���÷���","GetColValue", "Store_info,SALESMANAGER,sno='"+sSno+"'");
		
		var sParam = "PosNo="+sPosNo+",InputOrg="+sInputOrg+",InputUser="+sInputUser+",InputDate="+sInputDate+",SalManForPos="+sSalesmanNos+",Serialno="+sSerialno+",Salesmanager="+salesmanager;
		var retResult= RunJavaMethodSqlca("com.amarsoft.app.billions.PosRelativeSalman", "sRelativeSalMan", sParam);
		if(retResult=="TRUE"){
			alert("�����ɹ���");
		}else if(retResult=="NoSal"){
			alert("δ�������ۣ���ѡ�����ۣ�");
			return;
		}else{
			alert("����ʧ�ܣ�");
			return;
		}
		var sSALESMANNO = RunMethod("���÷���","GetColValue", "Store_info,SALESMANNO,sno='"+sSno+"'");
		var sSALESMANNO = RunMethod("���÷���","GetColValue", "MOBLIEPOSRELATIVESALMAN,SALESMANNO,SerialNo='"+sSerialno+"'");
		setItemValue(0, 0, "SALESMANNO",sSALESMANNO );
		/* reloadSelf(); */
	}
	
	
	function goBack(){
		
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/SalesManListForMobilePos.jsp", "SNo=<%=sSNo %>&MOBLIEPOSNO=<%=sMobilePoseNo%>", "_self","");

	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sSerialNo = getSerialNo("MOBLIEPOSRELATIVESALMAN","SerialNo");// ��ȡ��ˮ��
			setItemValue(0,0,"SERIALNO",sSerialNo);
			setItemValue(0, 0, "POSNO", "<%=sMobilePoseNo %>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			<%-- setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>"); --%>
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
