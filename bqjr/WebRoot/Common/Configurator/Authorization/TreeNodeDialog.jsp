<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.sadre.app.widget.tree.ITreeNode"%>
<%@page import="com.amarsoft.sadre.app.widget.*"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zllin@20120410
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获取参数：查询名称和参数
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	
	//将空值转化为空字符串
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
		
	//ARE.getLog().info(sSelName);
	//ARE.getLog().info(sParaString);
	Map attributes = new HashMap();
	if(sParaString.length()>0){
		String [] var = sParaString.split(",");
		for(int v=0; v<var.length; v++){
			String[] tmp = var[v].split("@");
			attributes.put(tmp[0], tmp[1]);
		}
	}
	//ARE.getLog().info("attributes="+attributes);
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "选择信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义业务逻辑;]~*/%>
<%
	
%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义业务逻辑;]~*/%>
<html>
<head> 
<title><%=PG_TITLE%></title>

<script language=javascript>
	function TreeViewOnClick()
	{		
		var sType = getCurTVItem().type;
		var sName = getCurTVItem().name;
		var sValue = getCurTVItem().value;
		if(sType == "root")
		{
			buff.ReturnString.value = "root";
		}else
		{
			if(sType == "page")
			{
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.sObjectInfo = buff.ReturnString.value;
			}else
			{
				alert("页节点信息不能选择，请重新选择！");
			}
		}
	}
	
	function TreeViewOnDBLClick(){
		TreeViewOnClick();
	};
	
	function startMenu() 
	{
	<%
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"选择信息列表","right");
		tviTemp.TriggerClickEvent=true;		
		
		//参数从左至右依次为：
		ITreeNode treeNode = null;
		if(sSelName.equalsIgnoreCase("IMPL")){
			treeNode = new MethodTree();
		}else if(sSelName.equalsIgnoreCase("DIMENSION")){
			treeNode = new DimensionTree();
		}else if(sSelName.equalsIgnoreCase("ImportScene")){
			treeNode = new ImportSceneTree();
		}
		
		treeNode.appendTreeNode(tviTemp, attributes, Sqlca);
		
		//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
		//tviTemp.initWithSql(sSelHideField,sSelFieldDisp,sSelFieldName,"","",sSelCode,sSelFilterField,Sqlca);		
		
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandNode('root');	
	}
	
	
</script>
<style>

.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}

</style>
</head>

<body class="pagebackground">
	<center>
		<form  name="buff">
		<input type="hidden" name="ReturnString" value="">
			<table width="90%" border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
				<tr> 
        				<td id="myleft"  align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
				</tr>
			</table>
		</form>
	</center>
</body>
<script>
	startMenu();	
</script>
</html>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>