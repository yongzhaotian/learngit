<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zllin@amarsoft.com
		Tester:
		Describe: 授权维度列表
		Input Param:
				
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权维度列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","160");
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("AuthorSceneGroupList",Sqlca);

	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
		{"true","","Button","新增","新增授权方案组","newRecord()",sResourcesPath},
		{"true","","Button","编辑","编辑授权方案组","editSceneGroup()",sResourcesPath},
		{"true","","Button","删除","删除授权方案组","deleteSceneGroup()",sResourcesPath},
		//刷新缓存功能请项目组酌情使用
		{"false","","Button","刷新缓存","刷新授权配置缓存","reloadCache()",sResourcesPath},
		};
	%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function newRecord(){
		OpenPage("/Common/Configurator/Authorization/SceneGroupInfo.jsp","DetailFrame","");
	}
	
	function editSceneGroup(){
		var sGroupID = getItemValue(0,getRow(),"GROUPID");//--方案组别编号
		if(typeof(sGroupID)=="undefined" || sGroupID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			OpenPage("/Common/Configurator/Authorization/SceneGroupInfo.jsp?GroupID="+sGroupID,"DetailFrame","");
		}
	}
	
	function deleteSceneGroup(){
		var sGroupID = getItemValue(0,getRow(),"GROUPID");//--方案组别编号
		var sGroupName = getItemValue(0,getRow(),"GROUPNAME");//--方案组别名称
		if(typeof(sGroupID)=="undefined" || sGroupID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			if(!confirm("将同时删除其项下的授权方案,确认删除授权方案组【"+sGroupName+"】吗?")) return;
			var sReturn = RunMethod("PublicMethod","AuthorObjectManage","remove,SceneGroup,"+sGroupID);
			if(sReturn && sReturn == "SUCCESSFUL"){
				alert("删除授权方案组【"+sGroupName+"】成功.");
			}else{
				alert("删除授权组别失败！");
				return;
			}
		}
		reloadSelf();
	}
	
	function reloadCache(){
		if(confirm("您即将刷新授权定义缓存,请确认没有用户正在使用系统或者与授权相关的功能!\n警告:若您在刷新授权定义缓存时,用户正在使用与授权相关功能,可能导致功能异常!")){
			var sReturn=RunJavaMethodSqlca("com.amarsoft.app.als.sadre.util.ReloadSADERCache","reloadSADRECache","");
			if(sReturn=="<%=com.amarsoft.app.util.RunJavaMethodAssistant.SUCCESS_MESSAGE%>"){
				alert("成功刷新授权定义缓存!");
			}else{
				alert("刷新授权定义缓存异常,请与系统管理员联系!");
			}
		}
	}

	function mySelectRow(){
		var sGroupID = getItemValue(0,getRow(),"GROUPID");//--方案组别编号
		if(typeof(sGroupID)=="undefined" || sGroupID.length==0) {
		}else{
			OpenPage("/Common/Configurator/Authorization/RuleSceneList.jsp?GroupID="+sGroupID,"DetailFrame","");
		}
	}
    
</script>
<script	type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	//OpenPage("/Blank.jsp?TextToShow=请先选择相应的授权方案!","DetailFrame","");
</script>
<%@	include file="/IncludeEnd.jsp"%>