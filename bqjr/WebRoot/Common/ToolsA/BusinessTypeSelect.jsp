<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hwang 2009-06-17 
		Tester:
		Describe: 业务品种选择
		Input Param:
			无
		Output Param:
			TypeNo：业务品种编号
			TypeName：业务品种名称

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>
<%
	String sWhereClause="";//条件语句
	//获取参数
	String sStatus=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	if(sStatus == null) sStatus = "";
%>

<html>
<head>
<title>请选择业务品种 </title>
</head>
<script type="text/javascript">

	//树图单击响应函数,获取用户选择的业务品种
	function TreeViewOnClick(){
		var sBusinessType=getCurTVItem().id;
		var sBusinessTypeName=getCurTVItem().name;		
		buff.BusinessType.value=sBusinessType+"@"+sBusinessTypeName;		
	}		
	
	//双击相应事件
	function TreeViewOnDBLClick(){
		newBusiness();
	}	

	//处理获取的信息与返回
	function newBusiness(){
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
		HTMLTreeView tviTemp = new HTMLTreeView("业务品种列表","right");
		tviTemp.TriggerClickEvent=true;
		if("0110".equals(sStatus)){//公司客户
			sWhereClause=" from BUSINESS_TYPE where isinuse='1' and TypeNo not like '3%' and TypeNo not like '2100%' and TypeNo not like '2060%' and TypeNo not like '2030_%' and TypeNo not like '2040_%' and Attribute1 like '%1%'";
		}else{//中小企业客户
			sWhereClause=" from BUSINESS_TYPE where isinuse='1' and TypeNo not like '3%' and TypeNo not like '2100%' and TypeNo not like '2060%' and TypeNo not like '2030_%' and TypeNo not like '2040_%' and Attribute1 like '%1%'";
		}
		tviTemp.initWithSql("TypeNo","TypeName","TypeNo","",sWhereClause,Sqlca);
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.MultiSelect = true;
		out.println(tviTemp.generateHTMLTreeView());
	%>
	}
</script>

<body class="pagebackground">
<center>
<form  name="buff">
<input type="hidden" name="BusinessType" value="">
<table width="96%" align=center border='1' height="90%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr>
    <td id="myleft" colspan='2' align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>
<tr height=4%>
	<span class="STYLE9"></span></br>
	<p align="left" class="black9pt">业务品种类型<font color=red>(可选择流动资金贷款等大项)</font></p>
	<td nowrap align="right" class="black9pt" >
		<%=HTMLControls.generateButton("确定","确定","javascript:newBusiness()",sResourcesPath)%>
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
