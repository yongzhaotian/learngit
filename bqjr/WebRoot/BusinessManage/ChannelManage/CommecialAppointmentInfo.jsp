<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "�̻�ԤԼ"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CommecialConsultInfo";//ģ�ͱ��
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//���׶�������ģ��
	
	doTemp.setUnit("CITYNAME", "<input class=\"inputdate\" value=\"...\" type=button onClick=parent.getRegionCode()>");	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","����","�����¼","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�Ҳ��","goBack()",sResourcesPath},
		{"false","","Button","����xxxx","�����б�Ҳ��","selectAreaInfo()",sResourcesPath},
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	function getRegionCode() {
		alert("Caoni ma");
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID %>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID() %>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID() %>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	// ���ؽ����б�
	function goBack()
	{
		AsControl.OpenView("/BusinessManage/ChannelManage/CommecialAppoinmentList.jsp","","_self");
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			var sSerialNo = getSerialNo("Consult","SERIALNO");// ��ȡ��ˮ��
			setItemValue(0,getRow(),"SERIALNO",sSerialNo);
			setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID %>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			
			setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID %>");
			setItemValue(0,0,"UPDATEORGNAME","<%=CurOrg.orgName %>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }

	</script>

<script language=javascript>
	bFreeFormMultiCol = true;
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
