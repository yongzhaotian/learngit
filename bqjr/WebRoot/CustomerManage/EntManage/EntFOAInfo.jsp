<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe: ��ҵӦ��Ӧ���ʿ���Ϣ;
		Input Param:
			CustomerID����ǰ�ͻ����
			SerialNo:��ˮ��
			EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
	 */
	String PG_TITLE = "��ҵӦ��Ӧ���ʿ���Ϣ";
	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sRecordNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	String sReportDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate"));
	if(sCustomerID == null) sCustomerID = "";
	if(sRecordNo == null) sRecordNo = "";
	if(sReportDate == null) sReportDate = "";
	
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sEditRight = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sSerialNo == null ) sSerialNo = "";
	if(sEditRight == null) sEditRight = "";	
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "EntFoaInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	if(sEditRight.equals("01")){
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(sEditRight.equals("02")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		if(bIsInsert){		
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	function goBack(){
		OpenPage("/CustomerManage/EntManage/EntFOAList.jsp","_self","");
	}
	
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,getRow(),"SerialNo",getSerialNo("ENT_FOA","SerialNo"));//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=��Ч�Լ��;ͨ��true,����false;]~*/

	function initRow(){
		if (getRowCount(0) == 0){
			as_add("myiframe0");
			setItemValue(0,0,"UpToDate","<%=sReportDate%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"RecordNo","<%=sRecordNo%>");
			bIsInsert = true;
		}
    }
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>