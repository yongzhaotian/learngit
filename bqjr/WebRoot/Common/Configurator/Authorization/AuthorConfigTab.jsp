<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  
		Tester:
		Content: 授权配置主界面,为了兼容als6.5及以下,不使用als6.6+中的tabCompent
		Input Param:
                
		Output param:
			
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权规则配置"; 	// 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	

	%>
<%/*~END~*/%>     

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sTabStrip[][] = {{"true","授权方案配置","doTabAction('scene')"},{"true","授权参数配置","doTabAction('dimension')"}};
		
		//根据定义组生成 tab
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_AuthorInfo","document.all('tabtd')"));

		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=yes";

	%>

</script>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title><%=PG_TITLE%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground" onBeforeUnload="unloadCheck()">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
		<tr>
			<td class="mytop">
				<%@include file="/MainTop.jsp"%>
			</td>
		</tr> 
		<tr>
  			<td valign="top" id="mymiddleShadow" class="mymiddleShadow"></td>
		</tr>
   		<tr>
			<td valign="top" bgcolor="#E0ECFF">
				<%@include file="/Resources/CodeParts/Tab04.jsp"%>
			</td>
		</tr>
	</table>
</body>
</html>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script language=javascript>
  	function doTabAction(varp)
  	{
  		if(varp=="scene"){
  			OpenComp("RuleSceneView","/Common/Configurator/Authorization/RuleSceneView.jsp","","<%=sIframeName%>");
  		}else if(varp=="dimension"){
  			OpenComp("DimensionList","/Common/Configurator/Authorization/DimensionList.jsp","","<%=sIframeName%>");
  		}else{
  			alert("doAction未定义.");
  			return;
  		}
  	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script language=javascript>
	//参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
	hc_drawTabToTable("tab_AuthorInfo",tabstrip,1,document.all('<%=sTabID%>'));
	//设定默认页面
	<%=sTabStrip[0][2]%>
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
