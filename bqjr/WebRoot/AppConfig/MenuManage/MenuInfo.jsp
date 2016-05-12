<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "菜单详情页面";
	//获得参数	
	String sMenuID =  CurPage.getParameter("MenuID");
	if(sMenuID==null) sMenuID="";

	String sTempletNo = "MenuInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//如果不为新增页面，则参数的ID不可修改
	if(sMenuID.length() != 0 ){
		doTemp.setReadOnly("MenuID",true);
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setRightType(); //设置权限
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sMenuID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","All","Button","保存","","saveRecord()","","","",""},
		{"true","All","Button","配置可见角色","","selectMenuRoles()","","","",""},
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0","afterOpen();"); //刷新tree使用
	}
	
	function afterOpen(){
		AsControl.OpenView("/AppConfig/MenuManage/MenuTree.jsp", "DefaultNode="+getItemValue(0,0,"SortNo"), "frameleft", "");
	}
	
	<%/*~[Describe=选择菜单可见角色;InputParam=无;OutPutParam=无;]~*/%>
	function selectMenuRoles(){
		var sMenuID=getItemValue(0,0,"MenuID");
		var sMenuName=getItemValue(0,0,"MenuName");
		AsControl.PopView("/AppConfig/MenuManage/SelectMenuRoleTree.jsp","MenuID="+sMenuID+"&MenuName="+sMenuName,"dialogWidth=440px;dialogHeight=500px;center:yes;resizable:no;scrollbars:no;status:no;help:no");
	}

	function initRow(){
		if (getRowCount(0)==0){ //如果没有找到对应记录，则新增一条，并设置字段默认值
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	var bFreeFormMultiCol = true;//分栏
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>