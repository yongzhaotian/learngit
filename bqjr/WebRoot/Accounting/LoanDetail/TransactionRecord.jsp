<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "���׼�¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String objectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//������
	String objectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));//��������
	if(objectNo == null)objectNo = "";
	if(objectType == null)objectType = "";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "Acct_Transaction";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    //���ӹ�����	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+objectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"true", "", "Button", "��������", "��������","viewLoanRecord()",sResourcesPath},
			{"true", "", "Button", "��¼����", "��¼����","viewSubjectRecord()",sResourcesPath},
	};
	%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=�鿴���޸Ľ�������;InputParam=��;OutPutParam=��;]~*/
	function viewLoanRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sDocumentType = getItemValue(0,getRow(),"DocumentType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		if(typeof(sDocumentType)=="undefined" || sDocumentType.length==0) {
			alert("���ཻ��û��������Ϣ��")
		}else{
		   	OpenComp("TransactionInfo","/Accounting/Transaction/TransactionInfo.jsp","ObjectNo="+sSerialNo+"&ObjectType="+sObjectType+"&ToInheritObj=y","_blank","");	
		}
	}
	
	/*~[Describe=�鿴���޸ķ�¼����;InputParam=��;OutPutParam=��;]~*/
	function viewSubjectRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else 
		{
		    OpenComp("LoanDetailList","/Accounting/LoanDetail/LoanDetailList.jsp","TransSerialNo="+sSerialNo,"_blank","");	
		}
	}
</script>


<script type="text/javascript">	



	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	

<%@ include file="/IncludeEnd.jsp"%>
