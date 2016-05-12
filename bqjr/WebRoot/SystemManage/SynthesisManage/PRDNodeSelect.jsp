<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: yzheng 2013-05-23
		Tester:
		Describe: 产品相关节点选择
		Input Param:
			selectedNodes：已经选择的节点，对树图进行反选
		Output Param:
			sPRDNodeID：产品相关节点编号
			sPRDNodeName：产品相关节点名称

		HistoryLog:
	 */
	%>
<%/*~END~*/%>
<%
	String sWhereClause="";//条件语句
	//获取参数
	String selectedNodes=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelectedNodes"));
	
	if(selectedNodes == null) 
		selectedNodes = "";
	else if (selectedNodes != "")
	{
		selectedNodes = selectedNodes.substring(0, selectedNodes.length()-1);   //去除最后一个“@”符号
	}
	
	//out.print(selectedNodes);
%>

<html>
<head>
<title>请选择产品相关节点 </title>
</head>
<script type="text/javascript">

	//树图单击响应函数,获取用户选择的业务品种
	function TreeViewOnClick(){
		var sPRDNodeID=getCurTVItem().id;
		var sPRDNodeName=getCurTVItem().name;		
		buff.PRDNode.value=sPRDNodeID+"@"+sPRDNodeName;		
	}		
	
	//双击相应事件
	function TreeViewOnDBLClick(){
		newPRDNode();
	}	

	//处理获取的信息与返回
	function newPRDNode(){
		var nodes = getCheckedTVItems();
		if(nodes.length < 1){
			alert("未选择节点");
			return;
		}
		var str = "";
		var id = "";
		for(var i = 0; i < nodes.length; i++){
			str += nodes[i].name + "|";
			id += nodes[i].id + "|";
		}
		//alert("您选择了节点【"+str+"】，共【"+nodes.length+"】个记录");
		//alert("您选择了节点【"+id+"】，共【"+nodes.length+"】个记录");
		top.returnValue = id+"@"+str;
		top.close();
	}

	function testChecked(){

	}
	
	//返回
	function goBack(){
		top.close();
	}

	//将查询出的业务品种按照TreeView展示
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("产品相关节点列表","right");
		tviTemp.TriggerClickEvent=true;
		sWhereClause =  "from PRD_NODEINFO where IsInUse = '1'";
		//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
		tviTemp.initWithSql("NodeID","NodeName","NodeID","", "",sWhereClause,"order by SortNo asc",Sqlca);
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.MultiSelect = true;
		out.println(tviTemp.generateHTMLTreeView());
	%>
	
		
	}
</script>

<body class="pagebackground">
<center>
<form  name="buff">
<input type="hidden" name="PRDNode" value="">
<table width="96%" align=center border='1' height="90%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr>
    <td id="myleft" colspan='2' align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>
<tr height=4%>
	<span class="STYLE9"></span></br>
	<p align="left" class="black9pt">产品相关节点列表<font color=red>(勾选父节点可选中所有子节点)</font></p>
	<td nowrap align="right" class="black9pt" >
		<%=HTMLControls.generateButton("确定","确定","javascript:newPRDNode()",sResourcesPath)%>
	</td>
	<td nowrap class="black9pt" >
		<%=HTMLControls.generateButton("取消","取消","javascript:goBack()",sResourcesPath)%>
	</td>
</tr>
</table>
</form>
</center>
</body>
</html>

<script type="text/javascript">
	startMenu();
	expandNode('root');
	expandNode('1');
</script>

<%@ include file="/IncludeEnd.jsp"%>
