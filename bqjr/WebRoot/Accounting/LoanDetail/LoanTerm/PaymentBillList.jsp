<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "֧���嵥"; // ��������ڱ��� <title> PG_TITLE </title>
%>

<%
	//����������
	String sPutoutSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String right=DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("RightType")));
	if(sPutoutSerialNo == null) sPutoutSerialNo = ""; 
    if(sObjectType == null) sObjectType = "";
%>

<%//�������
	String sTempletNo = "";	 
%>

<%
	//��ʾģ��		
	sTempletNo = "PutOutList";	
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
	doTemp.WhereClause+=" and ObjectType='"+sObjectType+"' and ObjectNo='"+sPutoutSerialNo+"'";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPutoutSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>


<%
	String sButtons[][] = {
		{"true","","Button","����","����","newRecord()",sResourcesPath}, 
		{"true","","Button","����","�鿴","viewRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath}}; 
	if("ReadOnly".equals(right)){
		sButtons[0][1]="false";
		sButtons[2][1]="false";
	}
%>  

<%@include file="/Resources/CodeParts/List05.jsp"%>

<script type="text/javascript">

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		OpenPage("/Accounting/LoanDetail/LoanTerm/PaymentBillInfo.jsp","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2'))){//�������ɾ������Ϣ��
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sAccountInFlag = getItemValue(0,getRow(),"AccountInFlag");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			OpenPage("/Accounting/LoanDetail/LoanTerm/PaymentBillInfo.jsp?SerialNo="+sSerialNo+"&AccountInFlag="+sAccountInFlag,"_self","");				
		}
	}
</script>


<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@	include file="/IncludeEnd.jsp"%>
