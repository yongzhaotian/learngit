<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "����¼��"; // ��������ڱ��� <title> PG_TITLE </title>
	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RetailInfo";//ģ�ͱ��
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//���׶�������ģ��
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","�����¼","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�Ҳ��","goBack()",sResourcesPath},
		{"false","","Button","����xxxx","�����б�Ҳ��","selectAreaInfo()",sResourcesPath},
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode()
	{
		var sAreaCode = getItemValue(0,getRow(),"RegionCode");
		//���������滮�����м�ǧ���������ʾ�����滮
		sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"RegionCode","");
			setItemValue(0,getRow(),"RegionName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"RegionCode",sAreaCodeValue);
					setItemValue(0,getRow(),"RegionName",sAreaCodeName);		
			}
		}
	}
	
	/*~[Describe=�������-����-����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;] added by tbzeng 2014/02/21~*/

	
	
	function saveRecord()
	{
		as_save("myiframe0");
	}
	
	// ���ؽ����б�
	function goBack()
	{
		//AsControl.OpenView("/CustomService/BusinessConsult/StoreConsultList.jsp","","_self");
		window.close();
		reloadSelf();
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			var sSerialNo = getSerialNo("Consult_Info","SerialNo");// ��ȡ��ˮ��
			setItemValue(0,getRow(),"SerialNo",sSerialNo);
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
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
