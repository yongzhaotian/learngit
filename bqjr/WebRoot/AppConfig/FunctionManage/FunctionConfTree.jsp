<%@page import="com.amarsoft.app.awe.config.function.model.ResourceTree"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sDefaultNode = CurPage.getParameter("DefaultNode"); //默认打开节点
	if(sDefaultNode == null) sDefaultNode = "";

	HTMLTreeView tviTemp = new ResourceTree().getResourceTree(Sqlca, "功能点配置");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	
	String sButtons[][] = {
		{"true","All","Button","新增","新增一条记录","newRecord()","","","","btn_icon_add"},
		{"true","All","Button","删除","删除所选中的记录","deleteRecord()","","","","btn_icon_delete"},
		{"true","","Button","查询","","showTVSearch()","","","",""},
	};
%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
	function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
	
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"frameright");
	}
	function TreeViewOnClick(){
		var sID = getCurTVItem().id;
		var sNodeType = getCurTVItem().value; //这里借用value属性来区分节点的类型：模块、功能点、按钮中的一个
		if(sNodeType=="Function"){ //功能点
			openChildComp("/AppConfig/FunctionManage/FunctionInfo.jsp","FunctionID="+sID);
		}else if(sNodeType=="RightPoint"){ //权限点
			var sParentID = getCurTVItem().parentID; //父节点对象
			openChildComp("/AppConfig/FunctionManage/RightPointInfo.jsp", "FunctionID="+sParentID+"&SerialNo="+sID);
		}else{
			openChildComp("/AppConfig/MenuManage/MenuInfo.jsp","MenuID="+sID+"&RightType=ReadOnly");
		}
	}
	
	function newRecord(){
		var sID = getCurTVItem().id;
		var sName = getCurTVItem().name;
		if(!sID){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
			return ;
		}
		var sNodeType = getCurTVItem().value; //这里借用value属性来区分节点的类型：模块、功能点、按钮中的一个
		if(sNodeType=="Function"){ //功能点下新增权限点
			alert("将在所选节点【"+sName+"】下增加<权限点>配置！");
			openChildComp("/AppConfig/FunctionManage/RightPointInfo.jsp", "FunctionID="+sID+"&RightPointType=button");
		}else if(sNodeType=="RightPoint"){ //权限点类型节点下不做任何操作
			return;
		}else{
			alert("将在所选节点【"+sName+"】下增加<功能点>配置！");
			openChildComp("/AppConfig/FunctionManage/FunctionInfo.jsp", "ModuleID="+sID+"&ModuleName="+sName);
		}
	}
	
	function deleteRecord(){
		var sID = getCurTVItem().id;
		if(!sID){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
			return ;
		}
		var sNodeType = getCurTVItem().value;
		if(sNodeType=="Function"){
			if(confirm("删除该记录将同时删除其与可见角色的关联关系，\n您确定删除吗？")){
				var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.function.action.DeleteFunctionAction","deleteFuncAndRela","FunctionID="+sID);
				if(typeof sReturn != "undefined" && sReturn == "SUCCEEDED"){
					AsControl.OpenView("/AppConfig/FunctionManage/FunctionConfTree.jsp", "", "frameleft", "");
					AsControl.OpenView("/Blank.jsp","TextToShow=请在左侧选择一项","frameright","");
				}
			}
		}else if(sNodeType=="RightPoint"){
			if(confirm("删除该记录将同时删除其与可见角色的关联关系，\n您确定删除吗？")){
				var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.function.action.DeleteRightPointAction","deleteRightAndRela","RightPointNo="+sID);
				if(typeof sReturn != "undefined" && sReturn == "SUCCEEDED"){
					AsControl.OpenView("/AppConfig/FunctionManage/FunctionConfTree.jsp", "", "frameleft", "");
					AsControl.OpenView("/Blank.jsp","TextToShow=请在左侧选择一项","frameright","");
				}
			}
		}else{
			alert("该节点不能删除！");
			return;
		}
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem('<%=sDefaultNode%>');
	}
	
	startMenu();
</script>
<%@ include file="/IncludeEnd.jsp"%>