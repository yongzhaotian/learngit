<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明：
	*/
	String PG_TITLE = "用户管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获取是否车贷标志	
	String sIsCar = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("isCar"));
	if(sIsCar == null) sIsCar = "";
	
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"用户管理","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView ="";
	
	if(CurUser.hasRole("1047")){
		sSqlTreeView = " from ORG_INFO where OrgID in (select OrgID from ORG_INFO where SortNo like '10%')";
	}else{
		sSqlTreeView = " from ORG_INFO where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')";
	}
	
	
	if(CurUser.hasRole("1036")){
		sSqlTreeView +=" or OrgID in (select OrgID from ORG_INFO where SortNo like '105%')";
	}
	if(CurUser.hasRole("1035")){
		sSqlTreeView +=" and OrgID not in (select OrgID from ORG_INFO where SortNo like '104%') or OrgID in (select OrgID from ORG_INFO where SortNo like '105%') ";
	}
	if(CurUser.hasRole("1036") && CurUser.hasRole("1035")){
		sSqlTreeView +=" or OrgID in (select OrgID from ORG_INFO where SortNo like '105%')";
	}

	
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	tviTemp.initWithSql("SortNo","OrgName","OrgID","","",sSqlTreeView,"Order By SortNo",Sqlca);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	function TreeViewOnClick(){
		var sOrgID = getCurTVItem().value;		
		if(sOrgID != "null" && sOrgID!='root'){
			OpenComp("UserList","/AppConfig/OrgUserManage/UserList.jsp","ComponentName=用户管理&OrgID="+sOrgID,"right");
			setTitle(getCurTVItem().name+"人员一览");
		}
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		click_change(1);
	}

	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>