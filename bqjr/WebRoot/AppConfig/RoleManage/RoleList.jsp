<%@page import="com.amarsoft.app.util.ReloadCacheConfigAction"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "角色列表";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "RoleList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//增加过滤器	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelRoleRight(#RoleID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(CurUser.hasRole("099")?"true":"false"),"","Button","新增角色","新增一种角色","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看角色情况","viewAndEdit()",sResourcesPath},
		{(CurUser.hasRole("099")?"true":"false"),"","Button","删除","删除该角色","deleteRecord()",sResourcesPath},
		{"true","","Button","角色下用户","查看该角色所有用户","viewUser()","","","",""},
		{"true","","Button","主菜单授权","给角色授权主菜单","my_AddMenu()",sResourcesPath},
		{"true","","Button","多角色菜单授权","给多个角色授权主菜单","much_AddMenu()","","","",""},
		{(CurUser.hasRole("099")?"true":"false"),"","Button","变更生效","同步缓存中数据使数据库变更生效","reloadCacheRole()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("RoleInfo","/AppConfig/RoleManage/RoleInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0) {
			reloadSelf();
		}
	}
	
	function viewAndEdit(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	
		sReturn=popComp("RoleInfo","/AppConfig/RoleManage/RoleInfo.jsp","RoleID="+sRoleID,"");
		//修改数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			reloadSelf();
		}
	}
	
	function deleteRecord(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getBusinessMessage("902"))){ //删除该角色的同时将删除该角色对应的权限，确定删除该角色吗？
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	<%/*~[Describe=给角色授权主菜单;]~*/%>
	function my_AddMenu(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		PopPage("/AppConfig/RoleManage/AddRoleMenu.jsp?RoleID="+sRoleID,"","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
	}
	
	<%/*[Describe=给多角色授权主菜单;]*/%>
	function much_AddMenu(){
		PopPage("/AppConfig/RoleManage/AddMuchRoleMenus.jsp","","dialogWidth=550px;dialogHeight=600px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
	}
	
	<%/*[Describe=查看该角色所有用户;]*/%>
	function viewUser(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if (typeof(sRoleID)=="undefined" || sRoleID.length==0){
			alert(getMessageText('AWEW1001'));//请选择一条信息！
			return;
		}
		//PopPage("/AppConfig/RoleManage/ViewAllUserList.jsp?RoleID="+sRoleID,"","dialogWidth=700px;dialogHeight=540px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		AsControl.PopView("/AppConfig/RoleManage/ViewAllUserList.jsp","RoleID="+sRoleID,"dialogWidth=700px;dialogHeight=540px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
	}
	
	<%/*~[Describe=生效变更;]~*/%>
	function reloadCacheRole(){
		//AsDebug.reloadCacheAll();
		var sReturn = RunJavaMethod("com.amarsoft.app.util.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("重载参数缓存成功！");
		else alert("重载参数缓存失败！");
	}		

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>