<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "������뷽��������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","180");

	//��ȡ�������
	
	//��ȡҳ�����
	String sBookType  = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BookType")));
	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AccountingCatalogList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    //���ӹ�����	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!SystemManage.DeleteOrgBelong(#OrgID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","���÷�������","���÷�����������","edit()",sResourcesPath}
		};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>

<script type="text/javascript">
    var oldAccountingNo=""; //��¼��ǰ��ѡ

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{ 
		as_add("myiframe0");//������¼
		initSerialNo();
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);	
	}
    
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var accountingNo = getItemValue(0,getRow(),"AccountingNo");	//���������
        if(typeof(accountingNo) == "undefined" || accountingNo.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=���ñ仯;InputParam=��;OutPutParam=��;]~*/
	function edit()
	{
		var accountingNo = getItemValue(0,getRow(),"AccountingNo");	//���������
        if(typeof(accountingNo) == "undefined" || accountingNo.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
        AsControl.OpenView("/Accounting/Config/ConditionRuleDef.jsp","ObjectNo="+accountingNo+"&ObjectType=jbo.app.ACCOUNTING_CATALOG","_blank",OpenStyle);
	}


	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ACCOUNTING_CATALOG";//����
		var sColumnName = "AccountingNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=ѡ��仯;InputParam=��;OutPutParam=��;]~*/
	function mySelectRow()
	{
		var accountingNo = getItemValue(0,getRow(),"AccountingNo");
       	if(typeof(accountingNo)=="undefined" || accountingNo.length==0) {
			OpenPage("/Blank.jsp?TextToShow=��ѡ��һ����¼","DetailFrame","");
			return;
		}
		if(oldAccountingNo!=accountingNo)
		{
       		OpenComp("AccountingLibraryList","/Accounting/Config/AccountingLibraryList.jsp","AccountingNo="+accountingNo,"DetailFrame","");
       		oldAccountingNo = accountingNo;
		}
	}

	
	
</script>




<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	

<%@ include file="/IncludeEnd.jsp"%>
