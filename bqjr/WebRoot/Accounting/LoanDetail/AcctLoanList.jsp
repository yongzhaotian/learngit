<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "̨����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String businessType = "";
	String projectVersion = "";
	
	//����������	
	
	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ContractSerialNo"));
	if(sObjectNo == null) sObjectNo = "";
	
	//��ʾģ����
	String sTempletNo = "AcctLoanList";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	
	String sButtons[][] = {
			{"true", "", "Button", "����", "����","viewRecord()",sResourcesPath},
	};
	
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>

<script type="text/javascript">
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else 
		{
			OpenComp("AcctLoanView","/Accounting/LoanDetail/AcctLoanView.jsp","ObjectNo="+sSerialNo+"&ObjectType=<%=BUSINESSOBJECT_CONSTATNTS.loan%>"+"&RightType=ReadOnly","_blank","");				
		}
	}
</script>


<script language=javascript>
	//��ʼ��
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
/*~END~*/
%>

<%@ include file="/IncludeEnd.jsp"%>
