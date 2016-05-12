<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
		/*
		Content:    Ԥ��ģ������
		Input Param:
					ScenarioID: ������ 
					ModelID��    ��ʾģ�ͱ��
	 */
	String PG_TITLE = "Ԥ��ģ������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sScenarioID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ScenarioID"));
	String sModelID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelID"));
	if(sModelID==null) sModelID="";
	if(sScenarioID==null) sScenarioID="";

	String sSubTypeNo = Sqlca.getString(new SqlObject("select DefaultSubTypeNo from SCENARIO_CATALOG where ScenarioID=:ScenarioID").setParameter("ScenarioID",sScenarioID));
	if(sSubTypeNo == null) sSubTypeNo = null;
	String sTempletNo = "AlarmModelInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//����Ĭ��ֵ
	doTemp.setDefaultValue("ScenarioID",sScenarioID);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sScenarioID+","+sModelID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecordAndReturn(){
		as_save("myiframe0","doReturn('Y');");
	}
    
	function saveRecordAndAdd(){
		as_save("myiframe0","newRecord()");
	}

    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"AlarmModelNo");
       parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	function newRecord(){
        OpenComp("AlarmModelInfo","/Common/Configurator/AlarmManage/AlarmModelInfo.jsp","ScenarioID=<%=sScenarioID%>","_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"SubTypeNo","<%=sSubTypeNo%>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
			setItemFocus(0,0,"ModelID");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>