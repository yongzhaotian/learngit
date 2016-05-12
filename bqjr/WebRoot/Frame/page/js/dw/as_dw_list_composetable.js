var tableNames = new Array();
var selectedRows = new Array();//记录表格选中的行号：二维数组
var filterValues = new Array();//记录表格对应的filter值
var tableDatas = new Array();//保存每个表格的数据

/*uiparams

{
	colors:[], 颜色代码：[0]-偶数行颜色，[1]-奇数行颜色，[2]-鼠标划过颜色，[3]-选中的行颜色
	lockCols:int,锁定列数
	floatWidth:int,宽度
	floatHeigth:int 高度
	combineLeft:[][] 左侧合并规则:二维数组array[i][0]=标题，array[i][1]="...colspan=x..."
	combineRight:[][] 右侧侧合并规则:二维数组array[i][0]=标题，array[i][1]="...colspan=x..."
	clientCount:["小计","1,2-3,4"] 客户端统计,clientCount[1]:多个编号用逗号分隔，支持-，clientCount[0]:标题
	serverCount:服务器统计，["总计","100","200"],比heads多1列，第一列表示标题，其他则显示统计数据
	depth:层次结构数组用于做treeview  depth[i]=0表示最顶层,注意：
		1 如果没有冻结列会自动设lockCols为1
		2 depth比heads多一个单元，depth[length]>depth[length-1]表示树干节点
	defaultWidths : 默认列宽，defaultWidths=self表示自适应
	htmlStyle:各列的html属性
	sortable:sortable	是否可排序
	colAlign:字段排序方式数组：1:左对齐，2:中，3:右对齐
	checkFormat:checkFormat		格式化输出，针对数字	
	colReadOnly:colReadOnly,	是否只读
	colEditStyle:colEditStyle	显示控件
	
}
*/
TableBuilder.dateArray = new Array();
TableBuilder.columnEgnoreGrag = new Array();
TableBuilder.iCurrentRow = new Array();
TableBuilder.Headers = new Array();
function TableBuilder(tableId,heads,datas,range,uiparams){
	this.tableId = tableId;
	if(TableBuilder.isInTableName(tableId)== false)
		tableNames[tableNames.length] = tableId;
	TableBuilder.iCurrentRow[tableId] = -1;
	this.heads = heads;
	TableBuilder.Headers[tableId] = heads;
	tableDatas[tableId] = datas;
	this.colors = uiparams.colors;
	if(uiparams.lockCols)
		this.lockCols = uiparams.lockCols;
	else
		this.lockCols = 0;
	this.range = range;//取值范围
	if(uiparams.floatWidth)
		this.floatWidth = uiparams.floatWidth;
	else
		this.floatWidth = 800;
	if(uiparams.floatHeight)
		this.floatHeight = uiparams.floatHeight;
	else
		this.floatHeight = 100;
	this.combineLeft = uiparams.combineLeft;
	this.combineRight = uiparams.combineRight;
	this.clientCount = uiparams.clientCount;
	//alert(this.clientCount);
	this.serverCount = uiparams.serverCount;
	this.depth = uiparams.depth;
	//alert("this.depth= " + this.depth);
	this.sortable = uiparams.sortable;
	this.colAlign = uiparams.colAlign;
	this.AlignArray = ["","left","center","right"];
	if(uiparams.defaultWidths =='self'){
		this.defaultWidths = new Array(this.heads.length);//保存每一列的最大宽度
		this.setSelfAdaptWidths(uiparams.checkFormat);
	}
	else{
		this.defaultWidths = uiparams.defaultWidths;
	}
	
	if(uiparams.htmlStyle){
		//alert(1);
		this.htmlStyle = uiparams.htmlStyle;
		//alert("this.htmlStyle = " + this.htmlStyle);
	}
	this.uiparams = uiparams;
	this.initValue();
	
}

TableBuilder.isInTableName = function(tableId){
	for(var i=0;i<tableNames.length;i++){
		if(tableNames[i]==tableId)return true;
	}
	return false;
};

/*设置单元格显示规则*/
TableBuilder.setDisplayRule = function(tableId,displayRule){
	for(var i=0;i<displayRule.length;i++){
		var sColName = displayRule[i][0];
		var iTableColIndex = TableFactory.getTableColIndexFromDZ(tableId,getColIndex(tableId,sColName));
		var sExpress = displayRule[i][1];
		var sScope = displayRule[i][2];
		var aScope = sScope.split(",");
		for(var ii=0;ii<aScope.length;ii++){
			aScope[ii]= TableFactory.getTableColIndexFromDZ(tableId,getColIndex(tableId,aScope[ii]));
		}
		var sClassName = displayRule[i][3];
		for(var r=0;r<tableDatas[tableId].length;r++){
			//实现值替换
			var sExpressForRow = sExpress.replace(/\{VALUE\}/,"'" + getItemValue(tableId,r,sColName) + "'");
			if(sExpressForRow=="" || eval("("+ sExpressForRow +")") ){
				if(sScope=='' || sScope == '*'){
					TableBuilder.setRowClassName(tableId,r,sClassName);
				}
				else{
					for(var ii=0;ii<aScope.length;ii++){	
						TableBuilder.setItemClassName(tableId,r,aScope[ii],sClassName);
					}
				}
			}
		}
	}
};
//初始化赋值操作
TableBuilder.prototype.initValue = function(){
	selectedRows[this.tableId] = new Array();
};
//刷新界面
TableBuilder.prototype.refreshHTML = function(){
	document.getElementById("table1").outerHTML = this.createTableHTML();
};

//自适应宽度调整
TableBuilder.prototype.setSelfAdaptWidths = function(checkFormat){
	for(var i=0;i<this.defaultWidths.length;i++){
		this.defaultWidths[i] = this.getBytesLength(this.heads[i]);
		
	}
	for(var i=0;i<tableDatas[this.tableId].length;i++){
		for(var j=0;j<tableDatas[this.tableId][i].length;j++){
			var sValue = tableDatas[this.tableId][i][j];
			var sCheckFormat = "";
			if(checkFormat && checkFormat[j])
				sCheckFormat = checkFormat[j];
			sValue = TableBuilder.convertJS2HTML(sValue,sCheckFormat);
			var bLength = this.getBytesLength(sValue);
			if(bLength>this.defaultWidths[j])this.defaultWidths[j]=bLength;
		}
	}
	
	for(var i=0;i<this.defaultWidths.length;i++){
		this.defaultWidths[i] = 6 * this.defaultWidths[i] + 40;
	}
	//window.status = this.defaultWidths;
};

//获得默认宽度
TableBuilder.prototype.getDefaultWidth = function(colIndex){
	if(this.defaultWidths && this.defaultWidths[colIndex])
		return "width:" + this.defaultWidths[colIndex] + "px";
	else
		return "";
};

TableBuilder.prototype.getTrueValue = function(colIndex,value){
	if(bDWConvertCode==false)
		return value;
	if(this.range && this.range[colIndex]){
		for(var i=0;i<this.range[colIndex].length;i+=2){
			if(value==this.range[colIndex][i]){
				return this.range[colIndex][i+1];
			}
		}
	}
	return value;
};

TableBuilder.prototype.createTableHTML = function(){
	filterValues[this.tableId]=[];
	//alert(this.uiparams.colEditStyle);
	var sbResult = new StringBuffer();
	//创建大表格
	//sbResult.append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="'+ this.tableId +'" origFloatWidth="'+ this.floatWidth +'" origFloatHeight="'+ this.floatHeight +'" lockCols="'+ this.lockCols +'" onselectstart="javascript:if(event.shiftKey)return false;">');
	if(this.tableId=='myiframe0')
		sbResult.append('<div class="list_topdiv_header" style="overflow:auto;width:100%;height:500px">');
	sbResult.append('<table border="0" cellspacing="0" cellpadding="0" id="'+ this.tableId +'">');
	//输出标题
	sbResult.append('<thead id="TH_Right_'+ this.tableId +'" >');
	//输出最左侧选择栏
	if(this.tableId=='myiframe0')
		sbResult.append('<th style="width:10px;" class="list_left_border">&nbsp;</th>');
	sbResult.append('<th style="width:40px;">&nbsp;</th>');
	for(var i=0;i<this.heads.length;i++){
		sbResult.append('<th style="'+this.getDefaultWidth(i)+';">'+ this.heads[i] +'</th>');
	}
	if(this.tableId=='myiframe0')
		sbResult.append('<th style="border:0px;background:none;">&nbsp;</th>');
	sbResult.append('</thead>');
	//输出数据
	for(var i=0;i<tableDatas[this.tableId].length;i++){
		sbResult.append('<tr tableId="'+ this.tableId +'" id="TR_Right_'+ this.tableId +'_'+ i +'" '+ this.getIntervalColor(i) +' origColor="'+ this.colors[i%2] +'" lightColor="'+ this.colors[2] +'" onMouseOver="TableBuilder.TRMouseOver('+i+',undefined,this,\''+ this.colors[3] +'\',event)" onmousedown="TableBuilder.TRClick('+i+',undefined,this,\''+ this.colors[3] +'\',event)" onMouseOut="TableBuilder.TRMouseOut('+i+',undefined,this,\''+ this.colors[3] +'\',event)">');
		//输出+
		if(this.tableId=='myiframe0')
			sbResult.append('<td showSub="false" class="list_checkbox_td2 list_composetable_left1">&nbsp;&nbsp;</td>');
		//输出序号列
		var iCurPage = s_c_p[this.tableId.substring(8)];
		var iPageSize = s_p_s[this.tableId.substring(8)];
		sbResult.append('<td class="list_all_no2">'+ (i+1 + iCurPage*iPageSize) +'</td>');
		//输出数据
		//alert("tableDatas[this.tableId][i].length=" + tableDatas[this.tableId][i].length);
		for(var j=0;j<tableDatas[this.tableId][i].length;j++){
			sbResult.append('<td class="list_all_td" style="padding-left:2px;"');
			if(this.htmlStyle && this.htmlStyle[j]){
				sbResult.append(' ' + this.htmlStyle[j]);
			}
			//对齐方式
			if(this.colAlign && this.colAlign[j])
				sbResult.append(' align="'+ this.AlignArray[this.colAlign[j]] +'"');
			sbResult.append('>');
			var sCheckFormat = "";
			if(this.uiparams.checkFormat && this.uiparams.checkFormat[j])
				sCheckFormat = this.uiparams.checkFormat[j];
			var sValue = TableBuilder.convertJS2HTML(tableDatas[this.tableId][i][j],sCheckFormat);
			sValue = this.getTrueValue(j,sValue);
			if(sValue=='')sValue="&nbsp;";
			sbResult.append(sValue);
			sbResult.append('</td>');
		}
		if(this.tableId=='myiframe0')
			sbResult.append('<td class="list_all_lastcolumn">&nbsp;</td>');
		sbResult.append('</tr>');
		//输出子表
		sbResult.append('<tr id="TR_SUB_'+this.tableId+'_'+ (i+1) +'" style="display:none">');
		//输出最左侧选择栏
		sbResult.append('<td class="list_all_no">&nbsp;</td>');
		if(this.tableId=='myiframe0')
			sbResult.append('<td colspan="'+ (tableDatas[this.tableId][i].length+1) +'" class="list_all_no3">&nbsp;</td>');
		else
			sbResult.append('<td colspan="'+ (tableDatas[this.tableId][i].length+2) +'" class="list_all_no3">&nbsp;</td>');
		sbResult.append('</tr>');
	}
	sbResult.append('</table>');
	if(this.tableId=='myiframe0')
		sbResult.append('</div>');
	return sbResult.toString();
};
TableBuilder.setSubList = function(lineIndex,argsValue,target){//linIndex从0开始
	var dwname = "myiframe0";
	var tableIndex = dwname.substring(8);
	var tr = document.getElementById("TR_SUB_" + dwname + "_" + lineIndex);
	if(target){
		if(target.getAttribute("showSub")=="true"){
			tr.style.display = "none";
			target.setAttribute("showSub","false");
			target.className = "list_checkbox_td2 list_composetable_left1";
			return;
		}
		else{
			target.setAttribute("showSub","true");
			target.className = "list_checkbox_td2 list_composetable_left0";
		}
	}
	//alert("argsValue=" + argsValue);
	//alert("DZ[0][0][8]=" + DZ[0][0][8]);
	$.ajax({
	   type: "POST",
	   url: sDWResourcePath + "/SubListSearch.jsp",
	   processData: false,
	   data: "SERIALIZED_ASD=" + DZ[0][0][8] + "&index=" + lineIndex + "&ArgsValue=" + argsValue,
	   success: function(msg){
			var result = eval("(" + msg + ")");
			
			if(result.status=="success" && result.data){
				//alert(TableFactory.createTableHTML(lineIndex));
				//alert("DZ[lineIndex][2]= " + DZ[lineIndex]);
				eval(result.data);
				//alert(document.getElementById("TR_SUB_" + dwname + "_" + lineIndex).innerHTML);
				var tr = document.getElementById("TR_SUB_" + dwname + "_" + lineIndex);
				tr.style.display = 'block';
				var td = tr.childNodes[1];
				td.innerHTML = TableFactory.createTableHTML(lineIndex);
				/*
				//alert(td.innerHTML);
				var thead = document.getElementById("TH_Right_myiframe0");
				//var thParent = (tr.childNodes[0].tagName=='TR')?tr.childNodes[0]:tr;
				var thParent = document.getElementById("TR_Right_" + dwname + "_" + (lineIndex-1));
				
				var oldTableWidth = thead.parentNode.clientWidth;
				alert("oldTableWidth=" + oldTableWidth);
				//记录原始th宽度
				var widthArray = new Array();
				for(var i=0;i<thParent.childNodes.length;i++)
					widthArray[i] = thParent.childNodes[i].clientWidth;
				alert(widthArray);
				td.innerHTML = TableFactory.createTableHTML(lineIndex);
				//重新设置大表格的宽度
				var newTableWidth = thead.parentNode.clientWidth;
				alert("newTableWidth=" + newTableWidth);
				thParent.childNodes[0].style.width = "10px";
				for(var i=1;i<thParent.childNodes.length;i++){
					if(i<thParent.childNodes.length-1){
						thParent.childNodes[i].style.width = widthArray[i];
					}
					else{
						thParent.childNodes[i].style.width = widthArray[i] + newTableWidth - oldTableWidth;
					}
					//alert(thParent.childNodes[i].style.width);
				}
				alert(thParent.outerHTML);
				*/
			}
	   }
	});
};

//获得间隔色代码
TableBuilder.prototype.getIntervalColor = function(i){
	var color = "";
	if(this.colors)
		color = " style='background-color:"+ this.colors[i % 2] + "'";
	return color;
};

//表格鼠标离开效果
TableBuilder.TRMouseOut = function(index,objleft,objright,visitedColor,evt){
	if(objright){//选中右边的情况
		if(typeof(objright)=='string')objright=document.getElementById(objright);
		var showColor = "";
		if(index!=TableBuilder.iCurrentRow[objright.getAttribute("tableId")])//如果不在选中数组中，则还原颜色
			showColor = objright.getAttribute("origColor");
		else{//如果在选中数组中，则显示访问过的颜色
			showColor = visitedColor;
		}
	
		objright.style.backgroundColor = showColor;
	}
	
};
//表格鼠标划过效果
TableBuilder.TRMouseOver = function(index,objleft,objright,visitedColor,evt){
	if(objright){//选中右边的情况
		if(typeof(objright)=='string')objright=document.getElementById(objright);
		objright.style.backgroundColor = objright.getAttribute("lightColor");
	}
};

//给选中的行显示颜色:取消
TableBuilder.displaySelectedRowsColor= function(tableId,dataSize,visitedColor){
	//window.status = selectedRows[tableId];
	
	for(var i=0;i<dataSize;i++){
		var obj = document.getElementById("TR_Right_" + tableId + "_" + i);
		var showColor = visitedColor;
		if(TableBuilder.isStrInArray(selectedRows[tableId],i)==-1)//如果不在选中数组中，则还原颜色
			showColor = obj.getAttribute("origColor");
		else{//如果在选中数组中，则显示访问过的颜色
			showColor = visitedColor;
		}
		obj.style.backgroundColor = showColor;
	}
};
//给当前点中行赋颜色
TableBuilder.displayCurrentRowColor = function(tableId,dataSize,visitedColor){
	//alert("visitedColor=" + visitedColor);
	for(var i=0;i<dataSize;i++){
		var obj = document.getElementById("TR_Right_" + tableId + "_" + i);
		//if(i==0)alert(visitedColor);
		var showColor = visitedColor;
		if(i!=TableBuilder.iCurrentRow[tableId])//如果不在点中状态，则还原颜色
			showColor = obj.getAttribute("origColor");
		else{//如果在点中状态，则显示访问过的颜色
			showColor = visitedColor;
		}
		obj.style.backgroundColor = showColor;
	}
};
//行单击事件
TableBuilder.TRClick = function(index,objleft,objright,visitedColor,evt){
	//alert(objright);
	if(!objright)return;
	if(typeof(objright)=='string')objright=document.getElementById(objright);
	var tableId = objright.getAttribute("tableId");
	var dataSize = tableDatas[tableId].length;
	TableBuilder.iCurrentRow[tableId] = index;
	var objs = document.getElementsByName("check_S_"+ tableId);
	var isCheckBoxSelected = false;
	if(objs){
		for(var i=0;i<objs.length;i++){
			if(objs[i].checked)isCheckBoxSelected = true;
		}
	}
	//alert(isCheckBoxSelected);
	if(isCheckBoxSelected==false){//如果没有任何行被打钩
		selectedRows[tableId] = [];
		selectedRows[tableId][0] = index;
	}
	mySelectRow();
	TableBuilder.displayCurrentRowColor(tableId,dataSize,visitedColor);
};

//获得某一列列宽
TableBuilder.getColumnWidth = function(tableId,colindex){
	var table = document.getElementById(tableId);
	var lockCols = parseInt(table.getAttribute("lockCols"));//获得冻结列数
	var headTh = null;
	var colHeadObj = null;
	if(colindex<lockCols){//冻结区域
		headTh = document.getElementById("TH_Left_" + tableId);
		colHeadObj = headTh.childNodes[0].childNodes[colindex+1].childNodes[0];
	}
	else{//正常区域
		headTh = document.getElementById("TH_Right_" + tableId);
		colHeadObj = headTh.childNodes[0].childNodes[colindex-lockCols].childNodes[0];
	}
	return colHeadObj.clientWidth;
};
//checkbox选择控制
TableBuilder.SelAll = function(tableId,source){
	var objs = document.getElementsByName("check_S_" + tableId);
	for(var i=0;i<objs.length;i++){
		objs[i].checked = source.checked;
	}
	TableBuilder.displaySelectedRows(tableId);
};
TableBuilder.displaySelectedRows = function(tableId){
	var tableIndex = tableId.substring(8);
	var objs = document.getElementsByName("check_S_" + tableId);
	var aSelRows = new Array();
	for(var i=0;i<objs.length;i++){
		if(objs[i].checked){
			aSelRows[aSelRows.length] = i;
		}
	}
	selectRows(tableIndex,aSelRows);
};

//获得冻结区域的宽度
TableBuilder.getLockAreaWidths = function(tableId){
	return 0;
};
//设置某一列的宽度
TableBuilder.setColumnWidth = function(tableId,colindex,width){
	var table = document.getElementById(tableId);
	var tableIndex = tableId.substring(8);
	var lockCols = parseInt(table.getAttribute("lockCols"));//获得冻结列数
	var headTh = null;//要修改的标题thead区域
	var dataTB = null;//要修改的数据tbody区域
	var colHeadObj = null;//要修改的标题列对象div
	var colDataObjs = null;//要修改的数据列对象div：注意，这里是个数组
	//alert("colindex = " + colindex);
	if(colindex<lockCols){//冻结区域
		headTh = document.getElementById("TH_Right_" + tableId);
		dataTB = document.getElementById(tableId + "_order_GridBody_Locks");
		//headTh会自动包含tr,所以通过headTh.childNodes[0]先获得tr才能在获得th
		//headTh.childNodes[0].childNodes[colindex+1]表示th，+1目的是排除序号列
		//headTh.childNodes[0].childNodes[colindex+1].childNodes[0]表示th下的div对象
		//alert(headTh.childNodes[0].outerHTML);
		try{
			if(DZ[tableIndex][0][11] == 1)//出现左侧多选组的时候需要colindex+2
				colHeadObj = headTh.childNodes[0].childNodes[colindex+2].childNodes[0];
			else
				colHeadObj = headTh.childNodes[0].childNodes[colindex+1].childNodes[0];
		}
		catch(e){
			if(DZ[tableIndex][0][11] == 1)//出现左侧多选组的时候需要colindex+2
				colHeadObj = headTh.childNodes[colindex+2].childNodes[0];
			else
				colHeadObj = headTh.childNodes[colindex+1].childNodes[0];
		}
	}
	else{//正常区域
		headTh = document.getElementById("TH_Right_" + tableId);
		dataTB = document.getElementById(tableId + "_order_GridBody_Cells");
		//headTh.childNodes[0].childNodes[colindex-lockCols]表示td
		//headTh.childNodes[0].childNodes[colindex-lockCols].childNodes[0]表示td下的div对象
		//alert(headTh.childNodes[0].innerHTML);
		try{
			colHeadObj = headTh.childNodes[0].childNodes[colindex-lockCols].childNodes[0];
		}
		catch(e){
			colHeadObj = headTh.childNodes[colindex-lockCols].childNodes[0];
		}
	}
	//alert(colDataObj);
	
	//设置标题列宽度
	var resetPattern = /style=[^\s\t\n]+/;
	//alert(colHeadObj.parentNode.innerHTML);
	//alert(colHeadObj.outerHTML);
	if(isIEBrowser())
		colHeadObj.outerHTML = colHeadObj.outerHTML.toString().replace(resetPattern, "style='width:" +width + "'");
	else
		colHeadObj.parentNode.innerHTML = colHeadObj.parentNode.innerHTML.replace(resetPattern, "style='width:" +width + "'");
	//alert(colHeadObj.outerHTML);
	//colHeadObj.style.width = width + "px";
	//设置数据列宽度，注意，这里需要针对每行操作，否则缩小的话会出问题
	var TrDatas = dataTB.childNodes;
	for(var i=0;i<TrDatas.length;i++){
		var td = null;
		if(colindex<lockCols){//冻结区域
			if(DZ[tableIndex][0][11] == 1)//出现左侧多选组的时候需要colindex+2
				td = TrDatas[i].childNodes[colindex+2];
			else
				td = TrDatas[i].childNodes[colindex+1];
		}
		else
			td = TrDatas[i].childNodes[colindex-lockCols];
		var div = td.childNodes[0];
		//alert(div.parentNode.innerHTML);
		//alert(div.outerHTML);
		if(isIEBrowser())
			div.outerHTML = div.outerHTML.toString().replace(resetPattern, "style='width:" +width + "'");
		else
			div.parentNode.innerHTML = div.parentNode.innerHTML.replace(resetPattern, "style='width:" +width + "'");
		//div.style.width = width + "px";
	}
	
};
//设置单元格的样式
TableBuilder.setItemStyle = function(tableId,rowindex,colindex,style){
	if(style==null || style=="")return;
	style = style.split(";");
	var div = document.getElementById('DIV_Data_'+ tableId + "_" + rowindex + "_" + colindex);
	//alert('DIV_Data_'+ tableId + "_" + rowindex + "_" + colindex + "|" + div);
	if(div){
		var td = div.parentNode;
		if(td){
			for(var i=0;i<style.length;i++){
				style[i] = style[i].replace("=","='") + "'";
				eval("(td.style." + style[i] + ")");
			}
		}
	}
};
//设置单元格样式名
TableBuilder.setItemClassName = function(tableId,rowindex,colindex,className){
	if(className==null || className=="")return;
	var div = document.getElementById('DIV_Data_'+ tableId + "_" + rowindex + "_" + colindex);
	//alert('DIV_Data_'+ tableId + "_" + rowindex + "_" + colindex + "|" + div);
	if(div){
		var td = div.parentNode;
		if(td){
			td.style.backgroundColor='';
			td.setAttribute("ignore_select_color","1");
			td.className = 'list_all_td ' +className;
		}
	}
};
//设置行样式名
TableBuilder.setRowClassName = function(tableId,rowindex,className){
	if(className==null || className=="")return;
	var objright = document.getElementById("TR_Right_" + tableId + "_" + rowindex);
	if(objright){
		for(var i=0;i<objright.childNodes.length;i++){
			if(objright.childNodes[i].className!='list_all_no'){
				objright.childNodes[i].className = 'list_all_td ' +className;
			}
		}
	}
};

//以下是通用函数
TableBuilder.isStrInArray = function(arr,str){
	if(arr){
		for(var i=0;i<arr.length;i++){
			if(arr[i]==str)
				return i;
		}
	}
	return -1;
};
TableBuilder.isStrInArray2 = function(arr,str){
	if(arr){
		
		for(var i=0;i<arr.length;i++){
			//alert(arr[i] + "|" + str);
			if(arr[i].toUpperCase()==str.toUpperCase())
				return i;
		}
	}
	return -1;
};

TableBuilder.isIntInArray = function(arr,int){
	for(var i=0;i<arr.length;i++){
		if(arr[i].indexOf("-")==-1){
			if(parseInt(arr[i])==int)
				return true;
		}
		else{
			var tmp = arr[i].split("-");
			var iB = parseInt(tmp[0]);
			var iE = parseInt(tmp[1]);
			if(int>=iB && int <=iE)
				return true;
		}
	}
	return false;
};
TableBuilder.tableResize = function(parentWidth,parentHeight,checkWidth,checkHeight){
	//alert("1:" +checkWidth);
	if(checkWidth){
		
		parentWidth= parentWidth+checkWidth;
	}
	if(checkHeight){
		//alert("0:" +checkLength);
		parentHeight= parentHeight+checkWidth;
	}
	
	for(var i=0;i<tableNames.length;i++){
		try{
			var iOrigHeigth = parseInt(document.getElementById(tableNames[i]).getAttribute("origFloatHeight"));
			var iNewHeigth =  parentHeight - 75;
			//alert("parentWidth=" + parentWidth);
			//parentWidth += 17;//
			//alert("parentWidth17=" + parentWidth);
			document.getElementById(tableNames[i] + "_float").style.width = parentWidth +"px";
			document.getElementById(tableNames[i] + "_cells").style.width = parentWidth +"px";
			document.getElementById(tableNames[i] + "_static").style.height = (iNewHeigth/tableNames.length) +"px";
			document.getElementById(tableNames[i] + "_cells").style.height = (iNewHeigth/tableNames.length) +"px";
		}
		catch(e){
			if(isIEBrowser())
				alert(e.message);
		}
	}
};
//获得字节长度
TableBuilder.prototype.getBytesLength = function(str){
	var bytesCount = 0;
	if (str != null)
	{
	for (var i = 0; i < str.length; i++)
	{
	var c = str.charAt(i);
	if (/^[\u0000-\u00ff]$/.test(c))
	{
	bytesCount += 1;
	}
	else
	{
	bytesCount += 2;
	}
	}
	}
	return bytesCount;
};

function mySelectRow() {}

TableBuilder.ConvertWordMap = [
	["&amp;","&"],//必须在第一行
	["&quot;","\""],
	["&lt;","<"],
	["&gt;",">"],
	["&nbsp;"," "],  
	["&acute;","'"],
	["","\n"]
];
   //将js代码转换成html代码
TableBuilder.convertJS2HTML = function(str,checkFormat){
	if(str==null)return "";
   	for(var i=0;i<TableBuilder.ConvertWordMap.length;i++){
   		str = str.replace(TableBuilder.ConvertWordMap[i][1],TableBuilder.ConvertWordMap[i][0]);
   	}
   	//格式化显示
   	if(checkFormat){
   		if(checkFormat==5){
   			str = FormatKNumber(str,0);
   		}
   		else if(checkFormat==2){
   			str = FormatKNumber(str,2);
   		}
   		else if(checkFormat>10){
   			str = FormatKNumber(str,checkFormat-10);
   		}
   	}
   	return str;
};
TableBuilder.getAlign = function(tableIndex,colindex){
	var arr = ["","left","center","right"];
	var iAlign = parseInt(DZ[tableIndex][1][colindex][8]);
	var sAlign = arr[iAlign];
	return sAlign;
};
TableBuilder.getLimit = function(tableIndex,colindex){
	var sResult = DZ[tableIndex][1][colindex][7];
	if(sResult =="0" || sResult=="" || sResult==undefined)
		return "";
	sResult = "maxLength=" + sResult;
	return sResult;
};
TableBuilder.ReloadDate_EvnetId = undefined;
TableBuilder.reloadDate = function(){
	if(TableBuilder.dateArray){
		for(var i=0;i<TableBuilder.dateArray.length;i++){
			try{
				$( '#'+ TableBuilder.dateArray[i][1]).datepicker({inline: true});
			}
			catch(e){}
		}
	}
};
//异步刷新日期控件
TableBuilder.checkDateForAsync = function(){
	
};
TableBuilder.reloadDateForAsync = function(){
	
};