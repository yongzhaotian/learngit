<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��˰��Ϣ�б�";
	//���ҳ�����
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sRecordNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	String sReportDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate"));
	if(sCustomerID==null) sCustomerID="";
	if(sRecordNo == null) sRecordNo = "";
	if(sReportDate == null) sReportDate = "";
	
	String customerType = "";
	SqlObject objSql = new SqlObject("SELECT CustomerType FROM CUSTOMER_INFO where CustomerID=:CustomerID").setParameter("CustomerID", sCustomerID);
	ASResultSet rs = Sqlca.getASResultSet(objSql);
	if(rs.next()){
		customerType = rs.getString("CustomerType");
	}
	rs.getStatement().close();
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "";//ģ�ͱ��
	if(customerType.startsWith("3", 1)){  //���˿ͻ�
		sTempletNo = "EntTaxIndList";
	}
	else{
		sTempletNo = "EntTaxList";
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sRecordNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
 
	String sButtons[][] = {
		{"true","","Button","����","������˰��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴��˰��Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����˰��Ϣ","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntTaxInfo.jsp?EditRight=02&ReportDate="+"<%=sReportDate%>","_self","");
	}
	

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserId");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>')
		{
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}
		}else alert(getHtmlMessage('3'));		
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
    	sUserID=getItemValue(0,getRow(),"InputUserId");
		if(sUserID=='<%=CurUser.getUserID()%>')
			sEditRight='02';
		else
			sEditRight='01';
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)		
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{       
			OpenPage("/CustomerManage/EntManage/EntTaxInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
		}
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
