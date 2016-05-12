<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 预警场景列表
	 */
	String PG_TITLE = "预警场景列表";
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","180");

	String sTempletNo = "AlarmScenarioList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(30);

	//定义后续事件
	//dwTemp.setEvent("BeforeDelete","!Configurator.DelScenarioAll(#ScenarioID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","场景参数配置","查看/修改场景预处理参数","viewAndEditArg()",sResourcesPath},
		{"true","","Button","模型分组配置","查看/修改场景下模型分组","viewAndEditGroup()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		PopComp("AlarmScenarioInfo","/Common/Configurator/AlarmManage/AlarmScenarioInfo.jsp","","dialogWidth=40;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");//OpenStyle
		reloadSelf();
	}
	
	function viewAndEdit(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
       if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
	    }
       PopComp("AlarmScenarioInfo","/Common/Configurator/AlarmManage/AlarmScenarioInfo.jsp","ScenarioID="+sScenarioID,"dialogWidth=40;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		reloadSelf();
	}
    
    /*~[Describe=查看及修改预警参数;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditArg(){
      	var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
      	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
          	return ;
		}
      	popComp("AlarmScenarioArgsList","/Common/Configurator/AlarmManage/AlarmScenarioArgsList.jsp","ScenarioID="+sScenarioID,"",OpenStyle);
	}

    /*~[Describe=查看及修改模型分组配置;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditGroup(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
		if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
          	return ;
		}
    	popComp("AlarmGroupList","/Common/Configurator/AlarmManage/AlarmGroupList.jsp","ScenarioID="+sScenarioID,"",OpenStyle);
    }

	function deleteRecord(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
      	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
          	return ;
		}
		
		if(confirm(getHtmlMessage('45'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function mySelectRow(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
      	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			OpenPage("/Blank.jsp?TextToShow=请选择一条记录","DetailFrame","");
			return;
		}
      	OpenComp("AlarmModelList","/Common/Configurator/AlarmManage/AlarmModelList.jsp","ScenarioID="+sScenarioID,"DetailFrame","");
	}

	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	mySelectRow();
	hideFilterArea();
</script>	
<%@ include file="/IncludeEnd.jsp"%>