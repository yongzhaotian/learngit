<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "附件信息"; //-- 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;附件信息&nbsp;&nbsp;"; //--默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//--默认的内容区文字
	String PG_LEFT_WIDTH = "200";//--默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = "";	//--存放sql语句
	ASResultSet rs = null;//--存放结果集
	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sRegCode = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RegCode"));
	String sPhaseType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	
	if (sPhaseType == null) sPhaseType = "";
	//获得页面参数	

    if (sSerialNo == null) sSerialNo="";
    if (sRegCode == null) sRegCode="";
	String sTreeViewTemplet = "RetailApplyFileView";//

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
<%
	

	ARE.getLog().debug("===============sTreeViewTemplet="+sTreeViewTemplet);
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"审批操作","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sSqlTreeView ="";

	sSqlTreeView = "from CODE_LIBRARY where CodeNo= '"+sTreeViewTemplet+"' and isinuse = '1'  ";
	tviTemp.initWithSql("ItemNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By ItemNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
<html>
<head>
<title><%=PG_TITLE%></title>
<style type="text/css">
	.no_select {
		-moz-user-select:none;
	}
</style>
</head>
<body leftmargin="0" topmargin="0" class="windowbackground" onload="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
<!-- for refresh this page -->
<form name="DOFilter" method=post onSubmit="if(!checkDOFilterForm(this)) return false;">
<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
</form>
	<tr>
		<td valign="top">
			<table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="content_table"  id="content_table">
				<tr> 
					<td id="myleft_leftMargin" class="myleft_leftMargin"></td>
					<td width="2" id="myleft" <%=(Integer.parseInt(PG_LEFT_WIDTH)<10?"style=\"display:none;\"":"")%>>
						<table style="height:100%;width:100%;" cellspacing="0" cellpadding="0">
						<tr height="100%"><td><iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no></iframe></td></tr>
						</table>
					</td>
			</table>
		</td>
	</tr>
</table>
<div id="myboard" style="position: absolute; left: 0; top: 0; width: 100%; height: 100%; cursor: w-resize; display: none;"></div>
</body>
</html>
<script type="text/javascript">
	function setTitle(sTitle){
		document.getElementById("table0").rows[0].cells[0].innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}
	
	myleft.width=<%=PG_LEFT_WIDTH%>;
	
	$(function(){
		$("#divDrag").bind("mousedown", function(e){
			var myboard = $("#myboard").show();
			var mybody = $("body").addClass("no_select");
			$(document).bind("mousemove", dragmove).bind("mouseup", dragup);
			var x = e.clientX;
			var width = window.parseInt(myleft.width, 10);
			function dragmove(e){
				myleft.width = width + e.clientX - x;
			}
			function dragup(){
				$(document).unbind("mousemove", dragmove).unbind("mouseup", dragup);
				myboard.hide();
				mybody.removeClass("no_select");
			}
		});
	});
	setTimeout(function(){
		if(myleft.width<10){
			myleft.style.display = "none";
			mycenter.style.display = "none";
		}
	}, 100);
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 

	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";
		
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name+"&RegCode="+"<%=sRegCode%>";
		OpenComp(sCompID,sURL,sParaStringTmp,"frameright");
		
	}
	
	//treeview单击选中事件
	function TreeViewOnClick()
	{
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;
		openChildComp("RetailAttachmentList","/BusinessManage/RetailManage/ImageViewFrameRetail.jsp","ComponentName="+sCurItemName+"&AccountType=ALL&Type="+sCurItemDescribe+"&SerialNo=<%=sSerialNo%>&RegCode=<%=sRegCode%>&PhaseType=<%=sPhaseType%>");
	}
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
