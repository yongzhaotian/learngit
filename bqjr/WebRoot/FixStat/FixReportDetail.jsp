<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginReport.jsp"%>
<%
/* Copyright 2001-2007 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: Rink ( zllin@amarsoft.com ) 
 * Tester:
 * Content: 
 * Input Param:
 *
 * Output param:
 *
 * History Log:
 *
 */
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "固定报表查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;固定报表查询&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>

<html>
<head>
<title>本行信贷业务固定统计报表</title>


<script type="text/javascript">
	function doAction(sAction){
		if(sAction == "back"){
			if (confirm("您确定要退出报表系统吗？")){
				window.open("<%=sWebRootPath%>/Main.jsp","_top");  
			}
		}
		else{
			OpenPage("/FixStat/FixSheetShow.jsp?SheetID="+sAction+"&DisplayCriteria=true&rand="+randomNumber(),"right");
			setTitle(getCurTVItem().name);
		}
	}
	
	function setTitle(sTitle){
		
		document.getElementById("table0").cells(0).innerHTML="<font class=pt9white> &nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	

	function startMenu(){
	<%
		/* TREEVIEW 报表展现范围控制
		 * 通过报表模板中权限标志RightInfo与系统中用户的角色RoleID相结合
		 * 存在两种控制手段：1、报表具体到角色级别，即一张报表对应多个许可的访问角色
		 *				2、报表具体到访问区域，即一张报表简单对应具有相同角色特征的访问角色
		 */
		 //控制方法1
		
		String sUserRole = "and EXISTS ("
									+" select RI.RoleID "
									+" from USER_ROLE UR,ROLE_INFO RI "
									+" where RI.RoleID=UR.RoleID "
									//+" and S_SHEET_MODEL.RightInfo like '%UR.RoleID%' "
									//+" and UR.UserID='"+CurUser.getUserID()+"' "
									+" ) ";
		
		//控制方法2
		/*
		String sUserRole = "and RightInfo like '%'||( "
							+" select RI.RoleID[1,1] "
							+" from USER_ROLE UR,ROLE_INFO RI "
							+" where RI.RoleID=UR.RoleID "
							//+" and UR.RoleID like R_SHEET_MODEL.RightInfo||'%' "
							+" and UR.UserID='"+CurUser.getUserID()+"' "
							+" )||'%'";
		*/
		HTMLTreeView tviTemp = new HTMLTreeView("固定报表查询列表","right");
		tviTemp.initWithSql("OrderNo", "SheetTitle", "", "Describe", "", "FROM R_SHEET_MODEL where OrderNo not like 'h%' AND OrderNo not like 'H%' and  (OrderNo is not null and   OrderNo <> ' ') ", Sqlca);
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandNode('root');
		//expandNode('1');
	}	
</script> 

</head>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


</html>

<script type="text/javascript">
	myleft.width=200;
	startMenu();
</script>
<%@ include file="/IncludeEnd.jsp"%>