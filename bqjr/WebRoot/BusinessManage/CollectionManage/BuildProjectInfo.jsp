<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "�ｨ����Ŀ"; // ��������ڱ��� <title> PG_TITLE </title>
	//���ҳ�����	��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//��Ŀ���
	String sProtocolNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProtocolNo"));//��Ŀ��������Э����
	String sflag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("flag"));
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));//ת������
	String sStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));//��Ŀ���
	
	if(sTransferType==null) sTransferType="";
	if(sSerialNo==null) sSerialNo="";
	if(sProtocolNo==null)sProtocolNo="";
	if(sStatus==null) sStatus="";
	if(sflag==null) sflag="";
	//out.println("��Ŀ��ţ�"+sSerialNo+"Э���ţ�"+sProtocolNo);
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "BuildProjectInfo";//ģ�ͱ��
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//���׶�������ģ��
	if(sSerialNo.equals("")){
		doTemp.setVisible("UpdateUserID,UpdateUserName,UpdateOrgID,UpdateOrgName,UpdateDate", false);
		doTemp.setReadOnly("TransactionMan,TransactionManName,Status,InputUserID,InputOrgID,InputDate,UpdateUserID,UpdateOrgID,UpdateDate,InputUserName,InputOrgName,UpdateUserName,UpdateOrgName", true);
	}
	
	doTemp.setDDDWSql("ProjectType", "select itemno,itemname from code_library where codeno='ProjectType'");
	doTemp.setDDDWSql("status","select itemno,itemname from code_library where codeno='ProjectPhaseType' and itemno='0010'");//��Ŀ״̬0010���ｨ��; 0020�������У�0030�����ս�;
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()",sResourcesPath},
		//{"true","","Button","����","����","goBack()",sResourcesPath},
	};
	
	//�ｨ�׶ο��Ա�����Ŀ��Ϣ���ǳｨ�׶β��ܱ�����Ŀ��Ϣ
	//if(!sStatus.equals("0010")){
	//	sButtons[0][0]="false";
	//}
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------
	/*~~��Ŀ����Э��~~*/
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
		if(typeof(sTransferSerialNo) == "undefined" || sTransferSerialNo == "")
		{
			alert("�����б���������Ӧ���ʲ�ת��Э��!");
			return;
		}
		
		setItemValue(0,getRow(),"ProtocolNo",sTransferSerialNo);
		setItemValue(0,getRow(),"TransactionMan",sTransactionMan);
		setItemValue(0,getRow(),"TransactionManName",sTransactionManName);
	}
	
	
	
	function saveRecord()
	{
		as_save("myiframe0");
	}
	
	// ���ؽ����б�
	function goBack()
	{
		var sflag="<%=sflag%>";
		//alert("==================="+sflag);
		if(sflag=="Y"){
			OpenPage("/BusinessManage/CollectionManage/BuildProjectList.jsp","_self","");
		}
		if(sflag=="S"){
			OpenPage("/BusinessManage/CollectionManage/WorkProjectList.jsp","_self","");
		}
		if(sflag=="N"){
			OpenPage("/BusinessManage/CollectionManage/FinalProjectList.jsp","_self","");
		}
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			initSerialNo();
			bIsInsert = true;
			setItemValue(0,getRow(),"Status","0010");//������Ŀ״̬Ϊ�ｨ��
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"InputDate","<%=StringFunction.getToday()%>");
		}else{
			setItemValue(0,getRow(),"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"UpdateOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"UpdateOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "Transfer_Project_Info";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	</script>

<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>
