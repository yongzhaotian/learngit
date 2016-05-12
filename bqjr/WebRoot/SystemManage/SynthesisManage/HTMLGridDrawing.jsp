<%@page import="com.amarsoft.app.als.product.CVNodeHTMLView"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   yzheng
		Date: 2013-6-7
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/ %>
	<%
	//获取参数
	 String sNodeIDArr = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NodeIDArr"));  //该产品对应的节点ID数组
     String sProductID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductID"));   //当前产品ID
     String sIsModified = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IsModified"));   //当前页面是否修改
     String sTypeName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeName"));   //当前产品名称

     if(sTypeName == null  ) sTypeName="";
     if(sIsModified == null  ) sIsModified="false";
     if(sNodeIDArr == null  ) sNodeIDArr="";
     if(sProductID == null  ) sProductID="";
     
	 //变量定义及预处理	 
 	 CVNodeHTMLView view = new CVNodeHTMLView(Sqlca, sProductID, sNodeIDArr,  "@");  //生成CVNodeHTMLView对象绘制HTML表格
 	 
  	 //String PRDNodeInfo = view.generateHTMLGrid();  //生成HTML表格代码
 	 int[][] maps = view.getMap();   //checkbox状态，二维
 	 int cols = view.getFacNums();  //因子数(阶段类型), 列
 	 int rows = view.getNodeIDArray().length;  //节点数, 行
 	 //String map = "";  //checkbox状态，一维
 	 String[] factors = view.getFactors();  //列名
 	 String[] nodeNames = view.getNodeNames();  //节点名称
 	 
 	 //转化2D int 数组为 1D String 数组,传入js function, 用于预选checkbox
//  	 for(int i = 0; i < rows; i++){
//  		for(int j = 0; j < cols; j++){
//  			map += maps[i][j];
//  		}
//  	 }
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<link rel="stylesheet" href="<%=sWebRootPath%>/SystemManage/SynthesisManage/css/PRDNodeConfig.css">
</head>

<body onbeforeunload="onClose(event)" onunload="">
<div class="lefttit">
	<span>
				 操作说明:<br />
				 1. 点击"配置基础节点"按钮, 选择需要的节点.<br />
				 2. 点击"笔"图片样式,自定义节点名称.按回车或点击"磁盘"图片样式完成编辑.<br />
	</span>
</div>
<form action='' name="nodeConfigForm">
	<div class="div_tbl">
		<table class="tbl_nor" id="NodeConfigTable">
		  <tr class="tr_nor tr_tit_bg">
		    <td class="td_nor td_font_color td_font_align" colspan="5" style="width:1035px; font-size:14px">节点信息配置图:<%=sTypeName %></td>
		  </tr>
		  <tr class="tr_nor tr_bg2">
		    <td class="td_nor td_tit_bg"><label class="lblleft">节点</label> <label class="lblright">阶段</label></td>
		    <%for(int i = 0; i < cols; i++){  //生成列名称(除TITLE外起第一行)%>
		    <td class="td_nor td_font_align tfc2"><input type="checkbox" id="<%=i %>" onclick="selColumnsNew(this.id, this.checked)"><%=factors[i] %></td>
			<%}%>
		  </tr>
		  <%for(int i = 0; i < rows; i++){  //生成节点(行)%>
		  <tr class="tr_nor" onclick="trClick(this);"  onmouseover="$(this).addClass('tr_bg');" onmouseout="$(this).removeClass('tr_bg');"><!-- tr_bg tr_bg_color -->
		    <td class="td_nor"><input type='text' name="nodeName" class ='iptTxt' size='15' onkeyup="checkEnter(this, event)" value="<%=nodeNames[i]%>"/><span class="txtpen"><%=nodeNames[i]%></span><span class="edpenX" onclick="editClick(this);"></span></td> 
		 	<%for(int j = 0; j < cols; j++){  //给每个节点生成check box(列)%>
		 	<td class="td_nor"><input type="checkbox" <%=(maps[i][j]==1?"checked":"")%> name="cell" value="(<%=i%>|<%=j%>)" onclick="changeStatus()"/></td>
		 	<%}%>
		  </tr>
		  <%}%>
		</table>
	</div>
	<div class="btn_zone">
		<a class="linka" href="javascript:void(0);" onclick="selectNodes()">配置基础节点</a>
	    <a class="linkb" href="javascript:void(0);" onclick="saveRecord()">保存</a>
	    <a class="linkc" href="javascript:void(0);" onclick="goBack()">返回</a>
	</div>
</form>
</body>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	var preTrClick = null;  //存储上一次点击的行号
	var isModified = "<%=sIsModified%>";  //当前页面时否被修改过
	
	/*~[Describe=高亮被点击的行;InputParam=curTr:当前行;OutPutParam=无;]~*/
	function trClick(curTr){
		stripeTable();
		
		if ($(curTr).hasClass("tr_stripe_color")){
			$(curTr).removeClass("tr_stripe_color");  //若当前行已经有隔行高亮效果，则去除该效果
		}
		
		$(preTrClick).removeClass("tr_bg_color");  //去除上一次点击行的高亮效果
		$(curTr).addClass("tr_bg_color");  //为当前点击行增加点击高亮效果
		preTrClick = curTr;
	}
	
	/*~[Describe=编辑/非编辑模式互相切换;InputParam=tdPen:当前行;OutPutParam=无;]~*/
	function editClick(tdPen){
		isModified = "true";
		if ($(tdPen).hasClass("edpenX")){   //常规状态进入编辑状态
			$(tdPen).removeClass("edpenX").addClass("edpen");
			$(tdPen).prev().hide().prev().show();    //hide span and show input
			$(tdPen).prev().prev().focus();  //为input获得焦点
		}
		else if($(tdPen).hasClass("edpen")) {  //编辑状态进入常规状态
			toggleVal($(tdPen).prev().prev()[0]);   //toggleVal(input)
		}
	}
	
	/*~[Describe=监听回车事件;InputParam=obj:input对象, event:事件;OutPutParam=无;]~*/
	function checkEnter(obj, event){
		if(event.keyCode == 13){
			toggleVal(obj);
		}
	}
	
	/*~[Describe=编辑状态进入常规状态(helper function);InputParam=obj:input对象, event:事件;OutPutParam=无;]~*/
	function toggleVal(obj){
		var span = $(obj).hide().next().show();  //hide input and show span
		span.next().removeClass("edpen").addClass("edpenX");
		span.text($(obj).val());
	}
	
	function onRefresh(){
		alert(123);
		//reloadSelf();
		//AsControl.OpenView("/SystemManage/SynthesisManage/HTMLGridDrawing.jsp", "NodeIDArr=" + "<%=sNodeIDArr%>" + "&ProductID=" + "<%=sProductID%>"  + "&IsModified=false", "_self", "");
	}
	
	/*~[Describe=离开页面前判断当前页面是否被修改过;InputParam=event:事件;OutPutParam=无;]~*/
	function onClose(event){
		if(isModified == "true"){
				event.returnValue = "是否离开?";	
		}
	}
	
	function goBack(){
		AsControl.OpenView("/Common/Configurator/CreditPolicy/ProductTypeList.jsp", "", "_self", "");
	}
	
	/*~[Describe=为某产品选择展现节点;InputParam=无;OutPutParam=无;]~*/
	function selectNodes(){
		var sPara = "ProductID=" + "<%=sProductID%>";
		//检查已选中的节点，在弹出的树图框反选
		var selectedNodes =  RunJavaMethodSqlca("com.amarsoft.app.als.product.CVNodeDBManipulateController", "checkPRDNode", sPara);  
		
		var sNodeInfo = AsControl.PopView("/SystemManage/SynthesisManage/PRDNodeSelect.jsp","SelectedNodes=" + selectedNodes,"dialogWidth=600px;dialogHeight=650px;center:yes;status:no;statusbar:no");

		if(typeof(sNodeInfo) != "undefined" && sNodeInfo != "" && sNodeInfo != null){
			var sNodeInfoArr = sNodeInfo.split("@");
			var sPRDNodeID = sNodeInfoArr[0].split("|").join("@");  //-- 节点ID
	//			var sPRDNodeName = sNodeInfoArr[1];// 节点名称,未使用
			//根据选择节点(ID数组去除最后一个@符号)，重新生成HTML
			AsControl.OpenView("/SystemManage/SynthesisManage/HTMLGridDrawing.jsp", "NodeIDArr=" + sPRDNodeID.substr(0, sPRDNodeID.length -1) + "&ProductID=" + "<%=sProductID%>"  + "&IsModified=true&TypeName=<%=sTypeName%>", "_self", "");
		}
	}
	
	 /*~[Describe=载入页面时，根据已存入数据库的信息，选中状态为true的checkbox;InputParam=checkbox的状态信息，表格行数，表格列数;OutPutParam=无;]~*/
// 	function preSelect(map, rows, cols)
// 	{
// 		var cell = document.all("cell");
	
// 		for(var i =0; i < rows * cols; i++){
// 			if(map[i] == "1"){
// 				cell[i].checked = true;
// 			}
// 		}
// 	}
	
	 /*~[Describe=保存选择结果;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		var nodes = document.nodeConfigForm.elements["nodeName"];
	    var cell = document.all("cell"); //document.getElementById("NodeConfigTable");
	    var txt = "";
	    var result = "";
	    var sPara = "";
	    var nodeNames = "";
	    
	    for(var i =0; i <cell.length; i++){
	    	if(cell[i].checked){
	    		txt = txt +cell[i].value + "@";
	    	}
	    }
	    
	    //alert(txt);
	
	    if(txt == ""){
	    	alert("请勾选至少一个复选框");
	    	return;
	    }
	    
		for(var i = 0; i < nodes.length; i++)  {
			if (nodes[i].value == ""){
				var msg = "第" + (i+1) + "行节点名称为空, 请先命名！"
				alert(msg);
		    	return;
			}
			else{
			 	nodeNames += nodes[i].value + "@";
			}
		}
	    
	    sPara = "Records=" + txt + ", Seperator=" + "@" + ", NodeIDArr=" + "<%=sNodeIDArr%>" + ", ProductID=" + "<%=sProductID%>" + ", NodeNames=" + nodeNames;
	    result =  RunJavaMethodSqlca("com.amarsoft.app.als.product.CVNodeDBManipulateController","select2Update",sPara);
	    
	    if (result == "SUCCESS"){
	    	alert("保存成功");
	    	isModified = "false";
	    }
	    else{
	    	alert("保存失败");
	    }
	}
	
    /*~[Describe=反选某列;InputParam=选中列的id，该列的checkbox状态（true/false）;OutPutParam=无;]~*/
    function selColumnsNew(col, isChecked){
    	isModified = "true";
    	var tarTable = document.getElementById("NodeConfigTable");
    	var cell = document.all("cell");

    	for(var i =0; i <cell.length; i++){
	    	if(i % (tarTable.rows[1].cells.length-1) == col){
	    		cell[i].checked = isChecked;
	    	}
	    }
    }
    
    /*~[Describe=点选checkbox时改变修改状态;InputParam=无;OutPutParam=无;]~*/
    function changeStatus(){
    	isModified = "true";
    }
    
    /*~[Describe=点选checkbox时改变修改状态;InputParam=无;OutPutParam=无;]~*/
    function stripeTable(){
    	var tarTable = document.getElementById("NodeConfigTable");

    	for(var i =2; i <tarTable.rows.length; i++){
	    	if(i % 2 == 0){
	    		$(tarTable.rows[i]).addClass("tr_stripe_color");
	    	}
	    }
    }
    
    window.onload = function(){
    	stripeTable();
    }
</script>
</html>
<%@ include file="/IncludeEnd.jsp"%>