<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
		/*
		Content:    Ԥ����������
		Input Param:
                    ScenarioID��    �������
                    AlarmArgID��    �������
	 */
	String PG_TITLE = "Ԥ����������";
	
	//����������	
	String sScenarioID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ScenarioID"));
	String sAlarmArgID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AlarmArgID"));
	if(sScenarioID==null) sScenarioID="";
	if(sAlarmArgID==null) sAlarmArgID="";

	String sTempletNo = "AlarmScenarioArgsInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//doTemp.setDefaultValue("ScenarioID",sScenarioID);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAlarmArgID+","+sScenarioID);
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
		sObjectNo = getItemValue(0,getRow(),"ScenarioID");
      	parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	function newRecord(){
        sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        OpenComp("AlarmScenarioArgsInfo","/Common/Configurator/AlarmManage/AlarmScenarioArgsInfo.jsp","ScenarioID="+sScenarioID,"_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>