<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "�ʲ�ת��Э������ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	//���ҳ�����	��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//Э����
	if(sSerialNo==null) sSerialNo="";
	
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));//�״�ת�û���ת���жϱ�ʶ
	if(sTransferType==null) sTransferType="";
	
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));//�״�ת�û���ת���жϱ�ʶ
	if(sApplyType==null) sApplyType="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("TransferDealManagerInfo",Sqlca);//���׶�������ģ��
	if(sSerialNo.equals(""))
	{
		doTemp.setVisible("UpdateUserName,UpdateUserID,UpdateOrgName,UpdateOrgID,UpdateDate", false);
	}
	doTemp.setReadOnly("IsTransfer", true);
	
	doTemp.setReadOnly("RivalSerialNo,AccountNo,RivalOpenBank,TrustCompaniesSerialNo,InputUserID,InputUserName,InputOrgID,InputOrgName,InputDate,UpdateUserID,UpdateUserName,UpdateOrgID,UpdateOrgName,UpdateDate", true);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);

	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	
	if(!"0010".equals(sTransferType)){
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}else{
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	}

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()",sResourcesPath},
		{"true","","Button","���沢����","���沢����","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","����","����","goBack()",sResourcesPath},
	};
	if(!"0010".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
	}
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------
	/*ѡ���ʲ�ת�÷�*/
	function selectOpponentName()
	{
		sRec = AsControl.OpenComp("/BusinessManage/CollectionManage/AssetTransferList.jsp", "","_blank", "");//�ʲ�ת�÷�ѡ���б����
		if (typeof(sRec)=="undefined" || sRec.length==0){
			return;
		}
		var array = sRec.split("@");
		if(array.length!=2){
			alert("���÷���Ϣ������!");return;
		}
		setItemValue(0,getRow(),"TrustCompaniesSerialNo",array[0]);
		setItemValue(0,getRow(),"CreditMan",array[1]);
		
	}
	
	/*ѡ�����й�˾*/
	function selectTrustCompanies(){
		sRec = AsControl.OpenComp("/BusinessManage/CollectionManage/TrustCompaniesList.jsp", "", "_blank", "");//�ʲ�ת�����й�˾ѡ���б����
		if (typeof(sRec)=="undefined" || sRec.length==0){
			return;
		}
		var array = sRec.split("@");
		if(array.length!=2){
			alert("���÷���Ϣ������!");return;
		}
		setItemValue(0,getRow(),"RivalSerialNo",array[0]);//���÷����
		setItemValue(0,getRow(),"RivalName",array[1]);//���÷�����
	}
	
	function saveRecord()
	{
		if(!validCheck())return;
		as_save("myiframe0");
	}
	function saveRecordAndReturn()
	{
		if(!validCheck())return;
		as_save("myiframe0");
		AsControl.OpenPage("/BusinessManage/CollectionManage/TransferDealList.jsp","TransferType=<%=sTransferType%>","_self","");
	}
	
	function validCheck(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		var RivalSerialNo = getItemValue(0,getRow(),"RivalSerialNo");
		var TrustCompaniesSerialNo = getItemValue(0,getRow(),"TrustCompaniesSerialNo");
		var EffectiveDate = getItemValue(0,getRow(),"EffectiveDate");
		var MaturityDate = getItemValue(0,getRow(),"MaturityDate");
		var RivalNo = getItemValue(0,getRow(),"RivalNo");
		if(typeof(RivalSerialNo)=="undefined"||RivalSerialNo==""){
			alert("���÷���Ų���Ϊ��");
			return false;
		}
		if(typeof(TrustCompaniesSerialNo)=="undefined"||TrustCompaniesSerialNo==""){
			alert("���÷���Ų���Ϊ��");
			return false;
		}
		if(RivalSerialNo==TrustCompaniesSerialNo){
			alert("���÷������÷�����Ϊͬһ����!");
			return false;
		}
		
		if(typeof(EffectiveDate)!="undefined"&&EffectiveDate!=""&&EffectiveDate.length==10){
			if(typeof(MaturityDate)!="undefined"&&MaturityDate!=""&&MaturityDate.length==10){
				if(EffectiveDate>MaturityDate){
					alert("Э�鵽���ղ���С��Э����Ч��!");
					return false;
				}
			}
		}
		
		var sReturn = RunMethod("���÷���","GetColValue","Transfer_Deal,SerialNo,RivalNo='"+RivalNo+"' and serialNo<>'"+SerialNo+"'");
		if(typeof(sReturn)!="undefined"&&sReturn.toLowerCase()!="null"&&sReturn.length>0){
			alert("Э���ı�����ظ�,�ѱ�Э��š�"+sReturn+"��ռ��");
			return false;
		}

		return true;
	}
	
	// ���ؽ����б�
	function goBack()
	
	{
		AsControl.OpenPage("/BusinessManage/CollectionManage/TransferDealList.jsp","TransferType=<%=sTransferType%>","_self","");
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			initSerialNo();
			setItemValue(0,getRow(),"DealStatus","01");//01��δ��Ч 02������Ч 03:����ֹ
			setItemValue(0,getRow(),"ApplyType","<%=sApplyType%>");//��������
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.orgID %>");
			setItemValue(0,0,"InputUserName", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate", "<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
		else{
			setItemValue(0,0,"UpdateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateOrgID","<%=CurOrg.orgID %>");
			setItemValue(0,0,"UpdateUserName", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate", "<%=StringFunction.getToday()%>");
		}
		
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "Transfer_Deal";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);//��ȡ��ˮ��
		
		setItemValue(0,getRow(),sColumnName,sSerialNo);//����ˮ�������Ӧ�ֶ�
	}

	</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
