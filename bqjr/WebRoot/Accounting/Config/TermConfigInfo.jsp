<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "ҵ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//���ҳ�����	
	String sItemNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo")));
	if(sItemNo==null||sItemNo.length()==0)sItemNo="";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "TermConfigInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2";//����DW���
	dwTemp.ReadOnly = "0";//�����Ƿ�ֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("TermType"+","+sItemNo);
	for (int i = 0; i < vTemp.size(); i++)
	out.print((String) vTemp.get(i));

	String sButtons[][] = { 
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath },
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
	%> 


	<%@include file="/Resources/CodeParts/Info05.jsp"%>


	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		AsControl.OpenView("/Accounting/Config/TermConfigList.jsp","","_self","");
	}

	
	</script>


	<script type="text/javascript">

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"CodeNo","<%="TermType"%>");
		}
    }
	
	</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	//var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>
