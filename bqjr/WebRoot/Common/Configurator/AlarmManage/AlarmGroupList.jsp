<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "场景分组列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","180");
	
	//获得参数	
	String sScenarioID =  CurPage.getParameter("ScenarioID");
	if (sScenarioID == null) sScenarioID = "";
   	
   	String sTempletNo = "AlarmGroupList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
    
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sScenarioID);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
    
	String sButtons[][] = {
		{"true", "All","Button","新增分组","当前页面新增","afterAdd()",sResourcesPath,"btn_icon_add"},
		{"true", "All","Button","保存","快速保存当前页面","saveRecord()",sResourcesPath,"btn_icon_save"},
		{"true","All","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath,"btn_icon_delete"},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function afterAdd(){
		as_add("myiframe0");
		//快速新增时候给定默认值
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
			alert("删除记录的分组号不能为空！");
        	return ;
		}
		
        if(confirm(getHtmlMessage('45'))){
        	var sReturnMessage = RunJavaMethodTrans("com.amarsoft.app.alarm.action.AlarmConfigAction","delGroupItems","ScenarioID="+sScenarioID+",GroupID="+sGroupID);
    		if(sReturnMessage == "FAILED"){
    			alert("删除分组下检查项失败！");
    			return;
    		}else{
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
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
        setDialogTitle("模型分组配置");
        OpenComp("AlarmGroupConfig","/Common/Configurator/AlarmManage/AlarmGroupConfig.jsp","ScenarioID="+sScenarioID+"&GroupID="+sGroupID,"DetailFrame","");        	
	}

	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	mySelectRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>