<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "������Ա";

	// ���ҳ�����
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sVIWEFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("VIWEFLAG"));//�����鰴ť�򿪵ı��  add by ybpan  CCS-588

	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	
	if (sSerialNo == null) sSerialNo = "";
	if (sSNo == null) sSNo="";
	if (sVIWEFlag == null) sVIWEFlag="";
	
	String sPrevUrl =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PrevUrl"));
	String flag = CurPage.getParameter("flag");
	if(sPrevUrl==null) sPrevUrl="";
	if(flag==null) flag = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreSalesmanInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	// ��ȡ���ŵ����ڳ���
	String values = Sqlca.getString(new SqlObject("Select City||'@'||company from Store_Info si where si.SNo=:SNo").setParameter("SNo", sSNo));
	String salesNo = Sqlca.getString(new SqlObject("SELECT SALESMANNO FROM STORERELATIVESALESMAN WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sSerialNo));
	String sCity = values.split("@")[0];
	String company = "";
	if(values.split("@").length >1){
		company = values.split("@")[1];
	}
	if (salesNo == null) salesNo = "";
	// �����ֶοɼ�����
	
	/* if ("Detail".equals(sActionType)) {
		doTemp.setUnit("SALESMANNO", "<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectSalesmanSingle()>");
	} */
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform

	//�ر�״̬������༭ update CCS-884 �ر�״̬���ر��水ť tangyb 20150720
	if(!"06".equals(sStatus)){
		dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}else{
		dwTemp.ReadOnly = "1"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
	};

	//add CCS-884 �ر�״̬���ر��水ť tangyb 20150720
	if("06".equals(sStatus)){
		sButtons[0][0]="false";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
    var sSaleTypeold="";  //�������ҳ���޸�ʱ�������͵�ԭֵ  add by ybpan  CCS-588

	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	function selectSalesman() {
		var company = '<%=company%>';
		if(company == "")
		{
		  alert("�ŵ�ҵ�������ڹ�˾Ϊ��");
		  return;
		}
		//CCS-541     //  AduEduRoleId    StuEduRoleId     add by yzhang9 CCS-571     add by ybpan CCS-588,���÷��ز���
		var sSNos = setObjectValue("SelectSalesmanByAuthor", "City,<%=sCity%>,company,<%=company%>", "@SALESMANNO@0@USERTYPE@1",0,0,"");
		//end by jshu 20150310
		if (typeof(sSNos)=='undefined' || sSNos.length==0) {
			//alert("��ѡ��������Ա��");
			return;
			
		}
		//֮ǰ��������ѡ������Ϊû���д��� add by huzp 20150428
		sSNos = sSNos.substring(0, sSNos.length-1);
		var retArry = sSNos.split("@");
		var sPNo = "";
		var sPName = "";
		for (var i in retArry) {
			if (i%2==0) {
				sPNo += retArry[i] + "@";
			} else if (i%2==1) {
				sPName += retArry[i] + "@";
			}
		}
		setItemValue(0, 0, "SALESMANNO", sPNo.substring(0, sPNo.length-1));
	}
	function selectSalesmanSingle() {
		
		var sSNo = setObjectValue("SelectSalesmanSingle", "", "");

		if (typeof(sSNo)=='undefined' || sSNo.length==0) {
			alert("��ѡ��������Ա��");
			return;
		}
		//���������function�������δ˴���  update by huzp 20150428
		//setItemValue(0, 0, "SALESMANNO", sSNo.split("@")[0]);

	}
	
	function saveRecord(sPostEvents){
		
		/* if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents); */
		var sSalesmanNos = getItemValue(0, 0, "SALESMANNO");
		var sSaleTypeNew = getItemValue(0, 0, "SALETYPE");  //�������ҳ���޸�ʱ�������͵���ֵ  add by ybpan  CCS-588
		var sUserType=getItemValue(0, 0, "USERTYPE");//�û�����:01-�ڲ�Ա��02-�ⲿԱ��  add by ybpan CCS-588

		if (typeof(sSalesmanNos)=="undefined" || sSalesmanNos=="") {
			alert("��ѡ�����۴���");
			return;
		}
		
		//add by ybpan  CCS-588  at 20150409  ϵͳ����������ALDIģʽ�Ŀͻ�����
		//��Ϊ�������ߵ�������޸��������Ͳ��ǿͻ�������Ҫ��Ϊ�ͻ�����ʱҪУ����ŵ��Ƿ��Ѿ����ڿͻ�����
		if(("<%=sVIWEFlag%>" != "2" &&sSaleTypeNew=="02")||(sSaleTypeold!="02"&&sSaleTypeNew=="02") ){         
			
			var sSaleManager =  RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "checkSaleManager", "sNo=<%=sSNo%>");
			if(sSaleManager=="true"){
					alert("���ŵ��Ѿ������ͻ�����");
					return ;
				}
		}
		//�����ⲿԱ��ѡ����������Ϊ���ܣ�����ʾ������Ϣ    
		if(sUserType=='02'&&sSaleTypeNew=="02"){
			alert("ֻ���ڲ���Ա������Ϊ�ͻ�����");
			return;
		}
		//end by ybpan   CCS-588  at 20150409  ϵͳ����������ALDIģʽ�Ŀͻ�����
		 
		var sParam = "type=01,sNo="+getItemValue(0, 0, "SNO")+",salesmanNos="+getItemValue(0, 0, "SALESMANNO")+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>,saleType="+getItemValue(0, getRow(), "SALETYPE")+",VIWEFlag=<%=sVIWEFlag%>";
		var retResult= RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "storeRelativeSalesman", sParam);
		if (false && "FAIL"==retResult) {
			 RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "checkStoreRelativeSalesman", "serialNo=<%=sSNo%>");
			return;
		} else if ("SUCCESS") {
			var sExitManagers = retResult.split("@")[1];
			if (typeof(sExitManagers)=='undefined' || sExitManagers.length==0) {
				if("<%=sVIWEFlag%>" == "2"){
					as_save("myiframe0");
				}
				reloadSelf();
				return;
			}
			alert(sExitManagers.replace(/@/g,", ")+"\n����������Ա�Ѿ��������������۾�����Ҫ���������ŵ꣬���Ƚ��");
		}
		reloadSelf();
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		AsControl.OpenView("/BusinessManage/StoreManage/SalesManList.jsp", "SNo=<%=sSNo %>", "_self","");

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
		sSaleTypeold = getItemValue(0, 0, "SALETYPE"); //�������ҳ���޸�ʱ�������͵�ԭֵ  add by ybpan  CCS-588 ԭֵ��Ҫ����߶��壬initRow�и�ֵ
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sSerialNo = getSerialNo("StoreRelativeSalesman","SerialNo");// ��ȡ��ˮ��
			setItemValue(0,0,"SERIALNO",sSerialNo);
			setItemValue(0, 0, "SNO", "<%=sSNo %>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID%>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			setItemValue(0, 0, "SALESMANNO", "<%=salesNo %>");
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
