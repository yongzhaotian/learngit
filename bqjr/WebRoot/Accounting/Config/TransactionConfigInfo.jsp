<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "���㽻�׶�������"; // ��������ڱ��� <title> PG_TITLE </title>

	//�������
	String sitemno =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));//���ױ��
	if(sitemno==null) sitemno="";
	String scodeno =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));//���״���
	if(scodeno==null) scodeno="";

	ASDataObject doTemp = new ASDataObject("TransactionConfigInfo",Sqlca);//���׶�������ģ��

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sitemno);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","�����¼","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�Ҳ��","goBack()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------
	function saveRecord()
	{
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=SystemConfig.getBusinessTime()%>");
		as_save("myiframe0");
	}
	
	// ���ؽ����б�
	function goBack()
	{
		AsControl.OpenView("/Accounting/Config/TransactionConfigList.jsp","","right","");
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"TypeSortNo","1");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=SystemConfig.getBusinessTime()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=SystemConfig.getBusinessTime()%>");
			setItemValue(0,0,"CodeNo","T_Transaction_Def");
			bIsInsert = true;
		}
    }

	</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
