<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "���֧���嵥��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
%>

<%
	//����������
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sAccountInFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountInFlag"));
	String sBusinessSum = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessSum"));
	String sBusinessCurrency = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessCurrency"));

	if(sSerialNo == null ) sSerialNo = ""; 
	if(sObjectType == null) sObjectType = "";
    if(sObjectNo == null) sObjectNo = ""; 
    if(sAccountInFlag == null) sAccountInFlag = "1";
    if(sBusinessSum == null) sBusinessSum = "0";
    if(sBusinessCurrency == null) sBusinessCurrency = "01";

    
%>


<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "PutOutInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,"ColAttribute like '%"+sAccountInFlag+"%'",Sqlca);
	
	
	//���ý��Ϊ��λһ������
	doTemp.setType("TransFerSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("TransFerSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("TransFerSum","3");	
	//֧������Ϊ����
	doTemp.appendHTMLStyle("TransFerSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"֧����������ڵ���0��\" ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
%> 

<%@include file="/Resources/CodeParts/Info05.jsp"%>

<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		setItemValue(0,0,"ObjectType","<%=sObjectType%>");
		setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();
		as_save("myiframe0","goBack()");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/Accounting/LoanDetail/LoanTerm/PaymentBillList.jsp","_self","");
	}

</script>

<script type="text/javascript">
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");	
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"TurnFee","0");
			setItemValue(0,0,"BussType","11");
			setItemValue(0,0,"AccountInFlag","1");
			setItemValue(0,0,"AccountOutFlag","1");
			setItemValue(0,0,"AccountOutBank","<%=CurOrg.getOrgName()%>");
			bIsInsert = true;
			initSerialNo();
		}
		setItemValue(0,0,"AccountInFlag","<%=sAccountInFlag%>");
		if("1" == "<%=sAccountInFlag%>"){
			setItemValue(0,0,"AccountInBank","<%=CurOrg.getOrgName()%>");
		}else{
			setItemValue(0,0,"AccountInBank","");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ACCT_TRANSFER";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=���Ļ㻮·������ѡ���ĵĸ���;InputParam=��;OutPutParam=��;]~*/
	function changeClearingType(){
		var clearingType = getItemValue(0,getRow(),"ClearingType");
		if("1"==clearingType){
			setItemValue(0,0,"TurnMsgType","CMT100");
			setItemValue(0,0,"BussTypeNo","CMT100");
			setItemDisabled(0,getRow(),"TurnMsgType",true);
		}else if("2"==clearingType){
			setItemValue(0,0,"TurnMsgType","PKG001");
			setItemValue(0,0,"BussTypeNo","PKG001");
			setItemDisabled(0,getRow(),"TurnMsgType",true);
		}else{
			setItemValue(0,0,"TurnMsgType","CMT101");
			setItemValue(0,0,"BussTypeNo","CMT101");
			setItemDisabled(0,getRow(),"TurnMsgType",false);
		}
		return;
	}
	
	/*~[Describe=����ѡ���Ĵ���ҵ�����ͺŵı仯;InputParam=��;OutPutParam=��;]~*/
	function changeTurnMsgType(){
		var turnMsgType = getItemValue(0,getRow(),"TurnMsgType");
		setItemValue(0,0,"BussTypeNo",turnMsgType);
		return;
	}
	//����ת���˻��Ƿ�Ϊ����
	function changeAcctInFlag(){
		var sReturn = getItemValue(0,getRow(),"AccountInFlag");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		OpenPage("/CreditManage/CreditApply/PaymentBillInfo.jsp?AccountInFlag="+sReturn+"&SerialNo="+sSerialNo,"_self","");
	}
	//����������־�����������ʧ��С��ԭ����Ա�д
	function changeDestroyFlag(){
		var sReturn = getItemValue(0,getRow(),"DestroyFlag");
		if("03" == sReturn){
			setItemDisabled(0,getRow(),"DestroySourse",false);
		}else{ 
			setItemValue(0,0,"DestroySourse","");
			setItemDisabled(0,getRow(),"DestroySourse",true);
		}
		return;
	}
</script>

<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>