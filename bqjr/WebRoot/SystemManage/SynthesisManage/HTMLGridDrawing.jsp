<%@page import="com.amarsoft.app.als.product.CVNodeHTMLView"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   yzheng
		Date: 2013-6-7
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/ %>
	<%
	//��ȡ����
	 String sNodeIDArr = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NodeIDArr"));  //�ò�Ʒ��Ӧ�Ľڵ�ID����
     String sProductID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductID"));   //��ǰ��ƷID
     String sIsModified = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IsModified"));   //��ǰҳ���Ƿ��޸�
     String sTypeName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TypeName"));   //��ǰ��Ʒ����

     if(sTypeName == null  ) sTypeName="";
     if(sIsModified == null  ) sIsModified="false";
     if(sNodeIDArr == null  ) sNodeIDArr="";
     if(sProductID == null  ) sProductID="";
     
	 //�������弰Ԥ����	 
 	 CVNodeHTMLView view = new CVNodeHTMLView(Sqlca, sProductID, sNodeIDArr,  "@");  //����CVNodeHTMLView�������HTML���
 	 
  	 //String PRDNodeInfo = view.generateHTMLGrid();  //����HTML������
 	 int[][] maps = view.getMap();   //checkbox״̬����ά
 	 int cols = view.getFacNums();  //������(�׶�����), ��
 	 int rows = view.getNodeIDArray().length;  //�ڵ���, ��
 	 //String map = "";  //checkbox״̬��һά
 	 String[] factors = view.getFactors();  //����
 	 String[] nodeNames = view.getNodeNames();  //�ڵ�����
 	 
 	 //ת��2D int ����Ϊ 1D String ����,����js function, ����Ԥѡcheckbox
//  	 for(int i = 0; i < rows; i++){
//  		for(int j = 0; j < cols; j++){
//  			map += maps[i][j];
//  		}
//  	 }
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>�ޱ����ĵ�</title>
<link rel="stylesheet" href="<%=sWebRootPath%>/SystemManage/SynthesisManage/css/PRDNodeConfig.css">
</head>

<body onbeforeunload="onClose(event)" onunload="">
<div class="lefttit">
	<span>
				 ����˵��:<br />
				 1. ���"���û����ڵ�"��ť, ѡ����Ҫ�Ľڵ�.<br />
				 2. ���"��"ͼƬ��ʽ,�Զ���ڵ�����.���س�����"����"ͼƬ��ʽ��ɱ༭.<br />
	</span>
</div>
<form action='' name="nodeConfigForm">
	<div class="div_tbl">
		<table class="tbl_nor" id="NodeConfigTable">
		  <tr class="tr_nor tr_tit_bg">
		    <td class="td_nor td_font_color td_font_align" colspan="5" style="width:1035px; font-size:14px">�ڵ���Ϣ����ͼ:<%=sTypeName %></td>
		  </tr>
		  <tr class="tr_nor tr_bg2">
		    <td class="td_nor td_tit_bg"><label class="lblleft">�ڵ�</label> <label class="lblright">�׶�</label></td>
		    <%for(int i = 0; i < cols; i++){  //����������(��TITLE�����һ��)%>
		    <td class="td_nor td_font_align tfc2"><input type="checkbox" id="<%=i %>" onclick="selColumnsNew(this.id, this.checked)"><%=factors[i] %></td>
			<%}%>
		  </tr>
		  <%for(int i = 0; i < rows; i++){  //���ɽڵ�(��)%>
		  <tr class="tr_nor" onclick="trClick(this);"  onmouseover="$(this).addClass('tr_bg');" onmouseout="$(this).removeClass('tr_bg');"><!-- tr_bg tr_bg_color -->
		    <td class="td_nor"><input type='text' name="nodeName" class ='iptTxt' size='15' onkeyup="checkEnter(this, event)" value="<%=nodeNames[i]%>"/><span class="txtpen"><%=nodeNames[i]%></span><span class="edpenX" onclick="editClick(this);"></span></td> 
		 	<%for(int j = 0; j < cols; j++){  //��ÿ���ڵ�����check box(��)%>
		 	<td class="td_nor"><input type="checkbox" <%=(maps[i][j]==1?"checked":"")%> name="cell" value="(<%=i%>|<%=j%>)" onclick="changeStatus()"/></td>
		 	<%}%>
		  </tr>
		  <%}%>
		</table>
	</div>
	<div class="btn_zone">
		<a class="linka" href="javascript:void(0);" onclick="selectNodes()">���û����ڵ�</a>
	    <a class="linkb" href="javascript:void(0);" onclick="saveRecord()">����</a>
	    <a class="linkc" href="javascript:void(0);" onclick="goBack()">����</a>
	</div>
</form>
</body>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	var preTrClick = null;  //�洢��һ�ε�����к�
	var isModified = "<%=sIsModified%>";  //��ǰҳ��ʱ���޸Ĺ�
	
	/*~[Describe=�������������;InputParam=curTr:��ǰ��;OutPutParam=��;]~*/
	function trClick(curTr){
		stripeTable();
		
		if ($(curTr).hasClass("tr_stripe_color")){
			$(curTr).removeClass("tr_stripe_color");  //����ǰ���Ѿ��и��и���Ч������ȥ����Ч��
		}
		
		$(preTrClick).removeClass("tr_bg_color");  //ȥ����һ�ε���еĸ���Ч��
		$(curTr).addClass("tr_bg_color");  //Ϊ��ǰ��������ӵ������Ч��
		preTrClick = curTr;
	}
	
	/*~[Describe=�༭/�Ǳ༭ģʽ�����л�;InputParam=tdPen:��ǰ��;OutPutParam=��;]~*/
	function editClick(tdPen){
		isModified = "true";
		if ($(tdPen).hasClass("edpenX")){   //����״̬����༭״̬
			$(tdPen).removeClass("edpenX").addClass("edpen");
			$(tdPen).prev().hide().prev().show();    //hide span and show input
			$(tdPen).prev().prev().focus();  //Ϊinput��ý���
		}
		else if($(tdPen).hasClass("edpen")) {  //�༭״̬���볣��״̬
			toggleVal($(tdPen).prev().prev()[0]);   //toggleVal(input)
		}
	}
	
	/*~[Describe=�����س��¼�;InputParam=obj:input����, event:�¼�;OutPutParam=��;]~*/
	function checkEnter(obj, event){
		if(event.keyCode == 13){
			toggleVal(obj);
		}
	}
	
	/*~[Describe=�༭״̬���볣��״̬(helper function);InputParam=obj:input����, event:�¼�;OutPutParam=��;]~*/
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
	
	/*~[Describe=�뿪ҳ��ǰ�жϵ�ǰҳ���Ƿ��޸Ĺ�;InputParam=event:�¼�;OutPutParam=��;]~*/
	function onClose(event){
		if(isModified == "true"){
				event.returnValue = "�Ƿ��뿪?";	
		}
	}
	
	function goBack(){
		AsControl.OpenView("/Common/Configurator/CreditPolicy/ProductTypeList.jsp", "", "_self", "");
	}
	
	/*~[Describe=Ϊĳ��Ʒѡ��չ�ֽڵ�;InputParam=��;OutPutParam=��;]~*/
	function selectNodes(){
		var sPara = "ProductID=" + "<%=sProductID%>";
		//�����ѡ�еĽڵ㣬�ڵ�������ͼ��ѡ
		var selectedNodes =  RunJavaMethodSqlca("com.amarsoft.app.als.product.CVNodeDBManipulateController", "checkPRDNode", sPara);  
		
		var sNodeInfo = AsControl.PopView("/SystemManage/SynthesisManage/PRDNodeSelect.jsp","SelectedNodes=" + selectedNodes,"dialogWidth=600px;dialogHeight=650px;center:yes;status:no;statusbar:no");

		if(typeof(sNodeInfo) != "undefined" && sNodeInfo != "" && sNodeInfo != null){
			var sNodeInfoArr = sNodeInfo.split("@");
			var sPRDNodeID = sNodeInfoArr[0].split("|").join("@");  //-- �ڵ�ID
	//			var sPRDNodeName = sNodeInfoArr[1];// �ڵ�����,δʹ��
			//����ѡ��ڵ�(ID����ȥ�����һ��@����)����������HTML
			AsControl.OpenView("/SystemManage/SynthesisManage/HTMLGridDrawing.jsp", "NodeIDArr=" + sPRDNodeID.substr(0, sPRDNodeID.length -1) + "&ProductID=" + "<%=sProductID%>"  + "&IsModified=true&TypeName=<%=sTypeName%>", "_self", "");
		}
	}
	
	 /*~[Describe=����ҳ��ʱ�������Ѵ������ݿ����Ϣ��ѡ��״̬Ϊtrue��checkbox;InputParam=checkbox��״̬��Ϣ������������������;OutPutParam=��;]~*/
// 	function preSelect(map, rows, cols)
// 	{
// 		var cell = document.all("cell");
	
// 		for(var i =0; i < rows * cols; i++){
// 			if(map[i] == "1"){
// 				cell[i].checked = true;
// 			}
// 		}
// 	}
	
	 /*~[Describe=����ѡ����;InputParam=��;OutPutParam=��;]~*/
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
	    	alert("�빴ѡ����һ����ѡ��");
	    	return;
	    }
	    
		for(var i = 0; i < nodes.length; i++)  {
			if (nodes[i].value == ""){
				var msg = "��" + (i+1) + "�нڵ�����Ϊ��, ����������"
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
	    	alert("����ɹ�");
	    	isModified = "false";
	    }
	    else{
	    	alert("����ʧ��");
	    }
	}
	
    /*~[Describe=��ѡĳ��;InputParam=ѡ���е�id�����е�checkbox״̬��true/false��;OutPutParam=��;]~*/
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
    
    /*~[Describe=��ѡcheckboxʱ�ı��޸�״̬;InputParam=��;OutPutParam=��;]~*/
    function changeStatus(){
    	isModified = "true";
    }
    
    /*~[Describe=��ѡcheckboxʱ�ı��޸�״̬;InputParam=��;OutPutParam=��;]~*/
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