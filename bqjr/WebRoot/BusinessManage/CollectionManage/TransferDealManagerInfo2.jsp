<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	//�״�ת�û���ת���жϱ�ʶ
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	out.println("��ˮ�ţ�"+sSerialNo+"ת�����ͣ�"+sTransferType);
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("TransferDealManagerInfo2",Sqlca);
	doTemp.setReadOnly("ISTRANSFER,TRANSFERTYPE,SERIALNO,RIVALSERIALNO,RIVALNAME,INPUTUSERID,INPUTUSERNAME,INPUTORGID,INPUTORGNAME,UPDATEUSERID,UPDATEUSERNAME,UPDATEORGID,UPDATEORGNAME,UPDATEDATE,INPUTDATE,CREDITMAN", true);
	if(sSerialNo.equals("")){
		doTemp.setVisible("UpdateDate,UpdateUserID,UpdateUserName,UpdateOrgID,UpdateOrgName", false);
	}
	doTemp.setRequired("RELATIVESERIALNO,TRUSTCOMPANIESSERIALNO,MATURITYDATE,SERIALNO", true);
	doTemp.setDDDWSql("IsTransfer", "select itemno,itemname from code_library where codeno='YesNo'");
	doTemp.setDDDWSql("TransferType", "select itemno,itemname from code_library where codeno='TransferType'");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	/*~~�ٴ�ת��Э������״�ת��Э��~~*/
	function selectTransferDealManager()
	{
		var sRec = AsControl.PopPage("/BusinessManage/CollectionManage/TransferDealManagerList.jsp", "Selected=true", "");
		var arr = sRec.split("@");
		if(arr.length!=3){
			alert("��������Э����Ϣ������!");
			return;
		}
		var sTransferSerialNo = arr[0];//Э����
		var sTransactionMan = arr[1];//Э����Ϣ¼��Ķ��ֱ��
		var sTransactionManName = arr[2];//Э����Ϣ��¼��Ķ�������
		//RELATIVESERIALNO\RIVALSERIALNO\RIVALNAME
		if(typeof(sTransferSerialNo) == "undefined" || sTransferSerialNo == "")
		{
			alert("�����б���������Ӧ���ʲ�ת��Э��!");
			return;
		}
		
		setItemValue(0,getRow(),"RELATIVESERIALNO",sTransferSerialNo);
		setItemValue(0,getRow(),"RIVALSERIALNO",sTransactionMan);
		setItemValue(0,getRow(),"RIVALNAME",sTransactionManName);
	}
	
	
	
	/*ѡ�����й�˾*/
	function selectTrustCompanies(){
		sRec = AsControl.PopPage("/BusinessManage/CollectionManage/TrustCompaniesList.jsp", "", "");//�ʲ�ת�����й�˾ѡ���б����
		if (typeof(sRec)=="undefined" || sRec.length==0){
			alert("��δѡ�����й�˾����ѡ���㡾ȷ������ť��");
			return;
		}
		var array = sRec.split("@");
		if(array.length!=2){
			alert("���й�˾��Ϣ������!");return;
		}
		setItemValue(0,getRow(),"TRUSTCOMPANIESSERIALNO",array[0]);//���й�˾���
		setItemValue(0,getRow(),"CREDITMAN",array[1]);//���й�˾����
	}
	</script>
	
	
	
	<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}else{
			beforeUpdate();
		}
		as_save("myiframe0",sPostEvents);
	}
	
	
	/*~~���沢����~~*/
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	/*~~����Э���б����~~*/
	function goBack(){
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerList2.jsp","","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSERID", "<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateOrgName", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"UPDATEORGID","<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEDATE", "<%=StringFunction.getToday()%>");
		//setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			initSerialNo();
			setItemValue(0,0,"ISTRANSFER","1");//�����Ƿ�ת��
			setItemValue(0,0,"TRANSFERTYPE","<%=sTransferType%>");//����ת�����ͣ�0010�״�ת�á�0020��ת�ã�
			setItemValue(0,0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTORGID","<%=CurOrg.orgID %>");
			setItemValue(0,0,"InputUserName", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTUSERID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE", "<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "Transfer_Deal";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "";//ǰ׺
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);//��ȡ��ˮ��
		setItemValue(0,getRow(),sColumnName,sSerialNo);//����ˮ�������Ӧ�ֶ�
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
