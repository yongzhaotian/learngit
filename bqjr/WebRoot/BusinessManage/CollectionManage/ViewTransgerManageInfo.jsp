<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "ת����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//���ҳ�����	��

	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	System.out.println("---------------------"+sObjectType);
	System.out.println("---------------------"+sObjectNo);
	
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ViewTransgerManage";//ģ�ͱ��
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//���׶�������ģ��
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","�����¼","saveRecord()",sResourcesPath},
		{"false","","Button","����","�����б�Ҳ��","goBack()",sResourcesPath},
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>

	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------
	function saveRecord()
	{
		as_save("myiframe0");
	}
	
	// ���ؽ����б�
	function goBack()
	{
		OpenPage("/BusinessManage/CollectionManage/CarTransgerManageList.jsp","_self","");

	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			initSerialNo();

			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "Car_Transfer_Info";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>

<script language=javascript>
    bFreeFormMultiCol=true;//����ƽ�̸�ʽ
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
