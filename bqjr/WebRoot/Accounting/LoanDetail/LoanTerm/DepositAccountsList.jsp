<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%
	String PG_TITLE = "�˻���Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String businessType = "";
	String projectVersion = "";
	
	//����������	
	
	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String status = DataConvert.toRealString(iPostChange,CurPage.getParameter("Status"));
	String right=DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("RightType")));
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(status == null) status = "";
	
	BusinessObject bo = AbstractBusinessObjectManager.getBusinessObject(sObjectType,sObjectNo,Sqlca);

	//��ʾģ����
	String sTempletNo = "DepositAccountsList";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+bo.getObjectType());
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	

	String sButtons[][] = {
			{"true", "", "Button", "�����ſ��ʺ�", "����һ���ſ��ʺ���Ϣ","createRecord('00')",sResourcesPath},
			{"true", "", "Button", "���������ʺ�", "����һ�������ʺ���Ϣ","createRecord('01')",sResourcesPath},
			{"true", "", "Button", "���������ʺ�", "����һ�������ʺ���Ϣ","createRecord('99')",sResourcesPath},
			{"true", "", "Button", "����", "��������","viewFee()",sResourcesPath},
			{"true", "", "Button", "ɾ��", "ɾ��һ����Ϣ","deleteRecord()",sResourcesPath},
	};
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[4][0]="false";
	}
	if(sObjectType.equals("jbo.app.ACCT_LOAN_CHANGE" ) || sObjectType.equals("jbo.app.ACCT_FEE" )){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
	}
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function createRecord(AccountIndicator){
		OpenPage("/Accounting/LoanDetail/LoanTerm/DepositAccountsInfo.jsp?Status=<%=status%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&AccountIndicator="+AccountIndicator,"_self","");
		//reloadSelf();
		}
	
	function viewFee(){
		var SerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(SerialNo)=="undefined"||SerialNo.length==0){
			alert("��ѡ��һ����¼");
			return;
		}
		OpenPage("/Accounting/LoanDetail/LoanTerm/DepositAccountsInfo.jsp?Status=<%=status%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&SerialNo="+SerialNo,"_self","");
	}
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		setNoCheckRequired(0);  //���������б���������
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("ȷ��ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	
	//��ʼ��
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>