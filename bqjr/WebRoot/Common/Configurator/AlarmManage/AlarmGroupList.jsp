<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "���������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","180");
	
	//��ò���	
	String sScenarioID =  CurPage.getParameter("ScenarioID");
	if (sScenarioID == null) sScenarioID = "";
   	
   	String sTempletNo = "AlarmGroupList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sScenarioID);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
    
	String sButtons[][] = {
		{"true", "All","Button","��������","��ǰҳ������","afterAdd()",sResourcesPath,"btn_icon_add"},
		{"true", "All","Button","����","���ٱ��浱ǰҳ��","saveRecord()",sResourcesPath,"btn_icon_save"},
		{"true","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath,"btn_icon_delete"},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function afterAdd(){
		as_add("myiframe0");
		//��������ʱ�����Ĭ��ֵ
		setItemValue(0,getRow(),"ScenarioID","<%=sScenarioID%>");
		setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,getRow(),"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"InputOrgName","<%=CurUser.getOrgName()%>");
		setItemValue(0,getRow(),"InputTime","<%=StringFunction.getTodayNow()%>");
	}
	
	function saveRecord(){
		setItemValue(0,getRow(),"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,getRow(),"UpdateTime","<%=StringFunction.getTodayNow()%>");
		as_save("myiframe0");
	}

	function deleteRecord(){
		var sScenarioID = "<%=sScenarioID%>";
		var sGroupID = getItemValue(0,getRow(),"GroupID");
        if(typeof(sGroupID)=="undefined" || sGroupID.length==0) {
			alert("ɾ����¼�ķ���Ų���Ϊ�գ�");
        	return ;
		}
		
        if(confirm(getHtmlMessage('45'))){
        	var sReturnMessage = RunJavaMethodTrans("com.amarsoft.app.alarm.action.AlarmConfigAction","delGroupItems","ScenarioID="+sScenarioID+",GroupID="+sGroupID);
    		if(sReturnMessage == "FAILED"){
    			alert("ɾ�������¼����ʧ�ܣ�");
    			return;
    		}else{
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
    		}
		}
        reloadSelf();
	}
	
	function mySelectRow(){
		var sScenarioID = "<%=sScenarioID%>";
		var sGroupID = getItemValue(0,getRow(),"GroupID");
        if(typeof(sGroupID)=="undefined" || sGroupID.length==0) {
        	return ;
		}
        setDialogTitle("ģ�ͷ�������");
        OpenComp("AlarmGroupConfig","/Common/Configurator/AlarmManage/AlarmGroupConfig.jsp","ScenarioID="+sScenarioID+"&GroupID="+sGroupID,"DetailFrame","");        	
	}

	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	mySelectRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>