
var tableNames = new Array();
var selectedRows = new Array();//记录表格选中的行号：二维数组
var filterValues = new Array();//记录表格对应的filter值
var filterTitles = new Array();//记录表格对应的filter值
var filterValues2 = new Array();//记录表格对应的filter值
var filterOptions = new Array();//记录filter类型
var filterHiddenValues = new Array();
var filterHiddenNames = new Array();
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
TableBuilder.noChangeHeight = true;
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
	this.clientCountsData = new Array(this.heads.length);//存储小计数据
	if(filterValues[this.tableId]==undefined)
		filterValues[this.tableId] = new Array(this.heads.length);//初始化过滤值数组界限
	if(filterValues2[this.tableId]==undefined)
		filterValues2[this.tableId] = new Array(this.heads.length);//初始化过滤值数组界限
	if(filterTitles[this.tableId]==undefined)
		filterTitles[this.tableId] = new Array();//初始化过滤值数组界限
	
	if(filterOptions[this.tableId]==undefined)
		filterOptions[this.tableId] = new Array(this.heads.length);//初始化过滤类型数组界限
	//alert("filterOptions[this.tableId]=" + filterOptions[this.tableId]);
	if(filterHiddenValues[this.tableId]==undefined){
		filterHiddenNames[this.tableId] = new Array();//初始化过滤值数组界限
		filterHiddenValues[this.tableId] = new Array();//初始化过滤值数组界限
		
	}
		
	
	selectedRows[this.tableId] = new Array();
	this.countData();
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
//获得合并列代码
TableBuilder.prototype.getCombineHtml = function(sbResult,arr){
	//alert(this.combineRight.length)
	for(var i=arr.length-1;i>=0;i--){
		sbResult.append("<thead>");
		for(var j=0;j<arr[i].length;j++){
			var title = arr[i][j][0];
			if(title=='')title = '&nbsp;';
			if(arr[i][j][1]>0)
				sbResult.append('<th colspan="'+ arr[i][j][1] +'">'+ title +'</th>');
			else
				sbResult.append('<th>'+ title +'</th>');
		}
		sbResult.append("</thead>");
	}
	return sbResult;
};
//数据统计
TableBuilder.prototype.countData = function (){
	for(var i=0;i<tableDatas[this.tableId].length;i++){
		for(var j=0;j<tableDatas[this.tableId][i].length;j++){
			if(isNumber(tableDatas[this.tableId][i][j])==false)continue;
			//var sValue = tableDatas[this.tableId][i][j]; 
			var dValue = toNumber(tableDatas[this.tableId][i][j]);
			if(isNaN(dValue)) dValue = 0;
			//if(sValue==undefined || sValue=="" || isNaN(sValue))sValue="0";
			if(this.clientCountsData[j]==null)
				this.clientCountsData[j] = dValue;//toNumber(sValue);
			else
				this.clientCountsData[j] += dValue;//toNumber(sValue);
			//if(4==j)alert(tableDatas[this.tableId][i][j] + "|" + this.clientCountsData[j]);
		}
	}
	//alert("this.clientCountsData=" + this.clientCountsData);
};
TableBuilder.getFomatedNumber = function(str,checkFormat){
	//alert("str=" + str + "|checkFormat=" + checkFormat);
	if(checkFormat==5){
		str = FormatKNumber(str,0);
	}
	else if(checkFormat==2){
		str = FormatKNumber(str,2);
	}
	else if(checkFormat>10){
		str = FormatKNumber(str,checkFormat-10);
	}
	//alert("str=" + str);
	return str;
};

TableBuilder.getFomatedNumber0 = function(str,checkFormat){
	//alert("str=" + str + "|checkFormat=" + checkFormat);
	if(checkFormat==5){
		str = FormatKNumber(str,0).replace(/\,/g,'');
	}
	else if(checkFormat==2){
		str = FormatKNumber(str,2).replace(/\,/g,'');
	}
	else if(checkFormat>10){
		str = FormatKNumber(str,checkFormat-10).replace(/\,/g,'');
	}
	return str;
};

//获得统计信息
TableBuilder.prototype.getCountInfo = function(sbResult,firstIndex,lastIndex){
	var countArr = this.clientCount[1].split(",");
	for(var i=firstIndex;i<=lastIndex;i++){
		var info = this.clientCountsData[i];
		if(info ==undefined)
			info = "0";
		var sCheckFormat = "";
		if(this.uiparams.checkFormat && this.uiparams.checkFormat[i])
			sCheckFormat = this.uiparams.checkFormat[i];
		if(info==0)
			info = TableBuilder.getFomatedNumber("0",sCheckFormat);
		else
			info = TableBuilder.getFomatedNumber(info+"",sCheckFormat);
		if(TableBuilder.isIntInArray(countArr,i)){
			sbResult.append('<td class="list_all_td"><div class="list_gridCell_standard list_div_pagecount" style="'+ this.getDefaultWidth(i) +';text-align:'+TableBuilder.getAlign(this.tableId.substring(8),TableFactory.getDZColIndexFromTalbe(this.tableId,i))+';">'+ info +'</div></td>');
		}
		else{
			sbResult.append('<td class="list_all_td"><div class="list_gridCell_standard " style="'+ this.getDefaultWidth(i) +';text-align:'+TableBuilder.getAlign(this.tableId.substring(8),TableFactory.getDZColIndexFromTalbe(this.tableId,i))+';">&nbsp;</div></td>');
		}
	}
	return sbResult;
};
//获得默认宽度
TableBuilder.prototype.getDefaultWidth = function(colIndex){
	if(this.defaultWidths && this.defaultWidths[colIndex])
		return "width:" + this.defaultWidths[colIndex] + "px";
	else
		return "";
};
//获得过滤代码
TableBuilder.prototype.getFilterHtml = function(index){
	var range = "";
	if(this.range && this.range[index])
		range = this.range[index].toString();
	var sortHtml = "";
	if(this.sortable[index]== "1" && this.depth==undefined)
		sortHtml = '<span class="list_sort_span" name="Sorter_'+ this.tableId +'" id="Sorter_'+ this.tableId + '_'+ index +'" sortDirect="" onclick="TableFactory.sort(\''+ this.tableId +'\','+ index +',this)">→</span>';
	
	var iDZColIndex = TableFactory.getDZColIndexFromTalbe(this.tableId,index);
	var sColName = DZ[this.tableId.substring(8)][1][iDZColIndex][15];
	//alert(filterNames);
	if(DZ[this.tableId.substring(8)][1][iDZColIndex][21]=="" && TableBuilder.isStrInArray2(filterNames[this.tableId.substring(8)],sColName)>-1  && this.depth==undefined){
		//sortHtml =  sortHtml + '<span isfilter=\'true\' class=\'list_search_span\' title="过滤" onclick="TableBuilder.showFilterDialog(this,\''+ this.tableId +'\',\''+ index +'\',\''+ range +'\',event)">&nbsp;&nbsp;</span>';
		sortHtml =  sortHtml + '<span isfilter=\'true\' class=\'list_search_span\'>&nbsp;&nbsp;</span>';
	}
	//alert(sortHtml);
	return sortHtml;
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
	//alert(this.uiparams.colEditStyle);
	var sbResult = new StringBuffer();
	//创建大表格
	//sbResult.append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="'+ this.tableId +'" origFloatWidth="'+ this.floatWidth +'" origFloatHeight="'+ this.floatHeight +'" lockCols="'+ this.lockCols +'" onselectstart="javascript:if(event.shiftKey)return false;">');
	sbResult.append('<table border="0" cellspacing="0" cellpadding="0"  id="'+ this.tableId +'" origFloatWidth="'+ this.floatWidth +'" origFloatHeight="'+ this.floatHeight +'" lockCols="'+ this.lockCols +'" onselectstart="javascript:if(event.shiftKey)return false;">');
	sbResult.append('<thead id="TH_Right_'+ this.tableId +'" class="list_topdiv_header">');
	//输出最左侧选择栏
	if(this.uiparams.multySelect && this.uiparams.multySelect==1){
		sbResult.append('<th><div class="list_gridCell_narrow list_left_border"><input class="list_left_cbInput" type="checkbox" id="DW_CheckAll_'+ this.tableId +'" name="CheckAll_'+ this.tableId +'" onclick="TableBuilder.SelAll(\''+ this.tableId +'\',this)"></div></th>');
	}
	sbResult.append('<th><div class="list_gridCell_narrow list_left_border">&nbsp;</div></th>');
	//输出标题
	for(var i=0;i<this.heads.length;i++){
		sbResult.append('<th');
		if(this.htmlStyle && this.htmlStyle[i] && /[\{'"]width\:[0-9]+px[\}'"]/ig.test(this.htmlStyle[i])){
			//alert(this.htmlStyle[i].match(/\{width\:[0-9]+px\}/));
			var search = this.htmlStyle[i].match(/[\{'"]width\:[0-9]+px[\}'"]/);
			//alert(search);
			sbResult.append(' style=' + search);
		}
		sbResult.append(' ><div id="Header_'+ this.tableId + "_" + i +'" style="'+ this.getDefaultWidth(i) +'" tableName="'+ this.tableId +'" columnIndex="'+ (i-this.lockCols) +'" class="list_gridCell_standard">'+ this.heads[i] +' '+ this.getFilterHtml(i) +'</div></th>');
	}
	sbResult.append('</thead>');
	sbResult.append('<tbody id="'+ this.tableId +'_order_GridBody_Cells">');
	//输出数据
	for(var i=0;i<tableDatas[this.tableId].length;i++){
		sbResult.append('<tr id="TR_Right_'+ this.tableId + '_' + i + '" tableId="'+ this.tableId +'" '+ this.getIntervalColor(i) +' origColor="'+ this.colors[i%2] +'" lightColor="'+ this.colors[2] +'" onMouseOver="TableBuilder.TRMouseOver('+i+',undefined,this,\''+ this.colors[3] +'\',event)" onmousedown="TableBuilder.TRClick('+i+',undefined,this,\''+ this.colors[3] +'\',event)" onMouseOut="TableBuilder.TRMouseOut('+i+',undefined,this,\''+ this.colors[3] +'\',event)">');
		//输出checkbox
		if(this.uiparams.multySelect && this.uiparams.multySelect==1)
			sbResult.append('<td class="list_all_no"><div  class="list_gridCell_narrow" ><input class="list_left_cbInput" type="checkbox" name="check_S_'+ this.tableId +'" onclick="TableBuilder.iCurrentRow[\''+ this.tableId +'\'] = '+i+';TableBuilder.displaySelectedRows(\''+ this.tableId +'\')"></div></td>');
		//输出序号列
		var iCurPage = s_c_p[this.tableId.substring(8)];
		var iPageSize = s_p_s[this.tableId.substring(8)];
		sbResult.append('<td class="list_all_no"><div class="list_gridCell_narrow" >'+ (i+1 + iCurPage*iPageSize) +'</div></td>');
		for(var j=0;j<tableDatas[this.tableId][i].length;j++){
			//对齐方式
			var sAlign = "";
			if(this.colAlign && this.colAlign[j])
				sAlign = ' align="'+ this.AlignArray[this.colAlign[j]] +'"';
			var sCheckFormat = "";//格式化显示
			if(this.uiparams.checkFormat && this.uiparams.checkFormat[j])
				sCheckFormat = this.uiparams.checkFormat[j];
			var sUnit = "";
			if(this.uiparams && this.uiparams.colUnit)
				sUnit = this.uiparams.colUnit[j];
			
			var sValue;
			if(this.uiparams && this.uiparams.colReadOnly && this.uiparams.colReadOnly[j]=="0"){
				sValue = TableBuilder.convertJS2HTML(tableDatas[this.tableId][i][j],sCheckFormat,false);
				sValue= this.createInput("INPUT_"+ this.tableId +"_" + this.uiparams.colNames[j], this.uiparams.colEditStyle[j], sValue,sUnit, this.range[j], i, j,sCheckFormat);
			}
			else{
				sValue = TableBuilder.convertJS2HTML(tableDatas[this.tableId][i][j],sCheckFormat);
				sValue = '<span id="INPUT_'+ this.tableId + "_" + this.uiparams.colNames[j] + "_" + i+ "_" + j +'" class="list_event_width">'+ this.getTrueValue(j,sValue) + "</span>";
			}
			if(this.htmlStyle && this.htmlStyle[j])
				sbResult.append('<td class="list_all_td" '+ this.htmlStyle[j] +'><div id="DIV_Data_'+ this.tableId + "_" + i + "_" + j +'" class="list_gridCell_standard" style="'+ this.getDefaultWidth(j) +'"'+ sAlign +'>'+ sValue +'</div></td>');
			else
				sbResult.append('<td class="list_all_td"><div id="DIV_Data_'+ this.tableId + "_" + i + "_" + j +'" class="list_gridCell_standard" style="'+ this.getDefaultWidth(j) +'"'+ sAlign +'>'+ sValue +'</div></td>');
		}
		sbResult.append('</tr>');
	}
	//输出右侧小计数据
	if(this.clientCount){
		var countArr = this.clientCount[1].split(",");
		sbResult.append('<tr class="list_smallcount_color">');
		sbResult = this.getCountInfo(sbResult,this.lockCols,this.heads.length-1);
		sbResult.append('</tr>');
	}
	//输出右侧总计数据
	if(this.serverCount){
		sbResult.append('<tr class="list_totalcount_color">');
		for(var t=this.lockCols;t<this.heads.length;t++){
			var sValue = this.serverCount[t+1];
			var sCheckFormat = "";
			if(this.uiparams.checkFormat && this.uiparams.checkFormat[t])
				sCheckFormat = this.uiparams.checkFormat[t];
			sbResult.append('<td class="list_all_td"><div class="list_gridCell_standard list_div_totalcount" style="'+ this.getDefaultWidth(t) +';text-align:'+TableBuilder.getAlign(this.tableId.substring(8),TableFactory.getDZColIndexFromTalbe(this.tableId,t))+'">'+ TableBuilder.getFomatedNumber(sValue,sCheckFormat) +'</div></td>');
		}
		sbResult.append('</tr>');
	}
	sbResult.append('</tbody>');
	sbResult.append('</table>');
	return sbResult.toString();
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
	
	if(objleft){//选中左边的情况
		if(typeof(objectleft)=='string')objleft=document.getElementById(objectleft);
		objright = document.getElementById("TR_Right_" + objleft.getAttribute("tableId") + "_" + index);
	}
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
	if(objleft){//选中左边的情况
		if(typeof(objectleft)=='string')objleft=document.getElementById(objectleft);
		objright = document.getElementById("TR_Right_" + objleft.getAttribute("tableId") + "_" + index);
		//alert(objright);
	}
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
	for(var i=0;i<dataSize;i++){
		var obj = document.getElementById("TR_Right_" + tableId + "_" + i);
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
	//alert("test");
	//暂停ctrl和shift选择功能
	if(objleft){//选中左边的情况
		if(typeof(objectleft)=='string')objleft=document.getElementById(objectleft);
		objright = document.getElementById("TR_Right_" + objleft.getAttribute("tableId") + "_" + index);
	}
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
//显示隐藏子祥
TableBuilder.displayChild = function(tableId,index,depthstr,evt){
	var depth = depthstr.split(",");
	//获得本节点的下一个节点
	var lastLeft = null;
	var lastimg = null;
	for(var i=index+1;i<depth.length-1;i++){
		var objleft = document.getElementById('TR_Left_' + tableId + '_' + i);
		var objright = document.getElementById('TR_Right_' + tableId + '_' + i);
		if(depth[i]>depth[index]){
			
			if(lastLeft==null){
				if(objleft.style.display == 'none'){
					objleft.style.display = 'block';
					objright.style.display = 'block';
				}
				else{
					objleft.style.display = 'none';
					objright.style.display = 'none';
				}
				lastimg = document.getElementById("IMG_"+ tableId + "_" + index);
				//改变文件夹图片
				TableBuilder.changeImage(objleft,lastimg);
			}
			else{
				objleft.style.display = lastLeft.style.display;
				objright.style.display = lastLeft.style.display;
				//改变文件夹图片
				TableBuilder.changeImage(objleft,lastimg);
			}
			
		}
		else{//遇到同层则直接返回
			break;
		}
		lastLeft = document.getElementById('TR_Left_' + tableId + '_' + i);
		lastimg = document.getElementById("IMG_"+ tableId + "_" + i);
	}
};
//gridview需要变换图片
TableBuilder.changeImage= function(obj,img){
	try{
		if(obj.style.display=='none' && img){
			//img.src = sSkinPath +'/images/dw/folder0.gif';
			img.className = "tree_grid_folder_collapse";
		}
		else{
			//img.src = sSkinPath +'/images/dw/folder.gif';
			img.className = "tree_grid_folder_expand";
		}
	}
	catch(e){}
};
//是否FilterDiv
TableBuilder.isFilterDiv = function(evt){
	var obj = document.elementFromPoint(evt.x,evt.y);
	if(obj==null)return false;
	if(obj.id == "TableFilter")
		return true;
	var parent = obj.parentNode;
	while(parent){
		if(parent.id=="TableFilter")
			return true;
		parent = parent.parentNode;
	}
	return false;
	
};
//显示过滤框
TableBuilder.showFilterDialog = function(obj,tableId,index,range,evt){
	//alert(range);
	var div = document.getElementById("TableFilter");
	//alert(document.body.clientWidth);
	div.setAttribute("tableId",tableId);
	div.colIndex = index;
	div.scrollTop = 0;//防止因滚动造成的现实不全的问题
	if(range!=""){//有取值范围的
		//首先增加滚动条
		div.style.overflowX="hidden";
		div.style.overflowY="auto";
		div.style.height="200px";
		div.childNodes[0].style.display = 'none';
		div.childNodes[1].style.display = 'block';
		//设置取值范围
		var obj = div.childNodes[1];
		obj.innerHTML = "";
		var range = range.split(",");
		var value = (filterValues[tableId][index]==undefined?"":filterValues[tableId][index]);
		for(var i=0;i<range.length;i+=2){
			var sel = "";
			if(i==0 && range[i]=="")continue;
			if(TableBuilder.isStrInArray(value.split("|"),range[i])>-1)sel = "checked";
			obj.innerHTML += '<input type="checkbox" value="'+ range[i] +'" '+ sel +' onclick="TableBuilder.setFilterValue(this.parentNode)">'+ range[i+1] +'<br>';
			/*单选
			obj.options[obj.length] = new Option(range[i+1],range[i]);
			if(range[i]==value)
				obj.options[obj.length-1].selected = true;
				*/
		}
		div.style.display = 'block';
		document.getElementById('TableFullFilter_' + tableId).style.display = 'none';
	}
	else{
		//首先取消滚动条
		div.style.overflowX="hidden";
		div.style.overflowY="hidden";
		div.style.height="70px";
		div.childNodes[0].style.display = 'block';
		div.childNodes[1].style.display = 'none';
		//alert(div.childNodes[0].style.display);
		div.childNodes[0].value = (filterValues[tableId][index]==undefined?"":filterValues[tableId][index]);
		div.style.display = 'block';
		document.getElementById('TableFullFilter_' + tableId).style.display = 'none';
		div.childNodes[0].focus();
	}
	var iLeft = (evt.x?evt.x+document.body.scrollLeft:evt.clientX+document.body.scrollLeft);
	//var iTop = (evt.y?evt.y+document.body.scrollTop:evt.clientY+document.body.scrollTop);
	var iTop = (evt.y?evt.y:evt.clientY);
	if(iLeft+div.clientWidth>document.body.clientWidth){//防止右侧超标
		div.style.left = iLeft - div.clientWidth;
		div.style.top = iTop;
	}
	else{
		div.style.left = iLeft;
		div.style.top = iTop;
	}
};
//给过滤框中的checkbox赋值
TableBuilder.setFilterValue = function(span){
	var div = span.parentNode;
	var checkboxArray = span.childNodes;
	var value = "";
	//alert(checkboxArray.length);
	for(var i=0;i<checkboxArray.length;i++){
		if(checkboxArray[i].checked){
			if(value=="")
				value = checkboxArray[i].value;
			else
				value += "|" + checkboxArray[i].value;
		}
	}
	filterValues[div.getAttribute("tableId")][div.colIndex]=value;
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
	var width = 0;
	var table = document.getElementById(tableId);
	var lockCols = parseInt(table.getAttribute("lockCols"));//获得冻结列数
	var headTh = document.getElementById("TH_Left_" + tableId);
	for(var i=0;i<=lockCols;i++){
		width += headTh.childNodes[0].childNodes[i].childNodes[0].clientWidth;
	}
	return width;
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
		headTh = document.getElementById("TH_Left_" + tableId);
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
	var objleft = document.getElementById("TR_Left_" + tableId + "_" + rowindex);
	var objright = document.getElementById("TR_Right_" + tableId + "_" + rowindex);
	if(objleft){
		for(var i=0;i<objleft.childNodes.length;i++){
			if(objleft.childNodes[i].className!='list_all_no'){
				objleft.childNodes[i].style.backgroundColor='';
				objleft.childNodes[i].setAttribute("ignore_select_color","1");
				objleft.childNodes[i].className = 'list_all_td ' +className;
			}
		}
	}
	if(objright){
		for(var i=0;i<objright.childNodes.length;i++){
			if(objright.childNodes[i].className!='list_all_no'){
				objright.childNodes[i].className = 'list_all_td ' +className;
			}
		}
	}
};

document.onclick = function(evt){
	if(evt==undefined)
		evt = event;
	if(evt.target){
		if(evt.target.getAttribute("isfilter")=="true")
			return;
		if(!TableBuilder.isFilterDiv(evt) && evt.target.tagName!='DIV'){
			document.getElementById("TableFilter").style.display = 'none';
		}
	}
	else if(evt.srcElement){
		if(evt.srcElement.getAttribute("isfilter")=="true")
			return;
		if(!TableBuilder.isFilterDiv(evt) && evt.srcElement.tagName!='DIV'){
			document.getElementById("TableFilter").style.display = 'none';
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
			//document.getElementById(tableNames[i] + "_static").style.height = (iNewHeigth/tableNames.length) +"px";
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
TableBuilder.convertJS2HTML = function(str,checkFormat,convert){
	if(str==null)return "";
	if(convert==undefined || convert==true){
		str = str.replace(/&/g,"&amp;");
		str = str.replace(/"/g,"&quot;");
		str = str.replace(/</g,"&lt;");
		str = str.replace(/>/g,"&gt;");
		str = str.replace(/ /g,"&nbsp;");
		str = str.replace(/'/g,"&acute;");
		str = str.replace(/\\n/g,"");
		
	}
	//格式化显示
   	if(checkFormat){
   		//alert(checkFormat);
   		if(checkFormat==5){
   			str = FormatKNumber(str,0);
   		}
   		else if(checkFormat==2){
   			str = FormatKNumber(str,2);
   		}
   		else if(checkFormat==6){//万元整数
   			str = FormatKNumber(str/10000,0);
   		}
   		else if(checkFormat==7){//万元小数
   			str = FormatKNumber(str/10000,2);
   		}
   		else if(checkFormat>10){
   			str = FormatKNumber(str,checkFormat-10);
   		}
   	}
   	return str;
};

//修改input类型
TableBuilder.reviseInput = function(inputtype){
	if(inputtype=="1")
		inputtype="text";
	else if(inputtype=="2" || inputtype=="Select")
		inputtype="select";
	else if(inputtype=="RadioboxV" || inputtype=="Radiobox")
		inputtype="radio";
	else if(inputtype=="Checkbox")
		inputtype="checkbox";
	else if(inputtype=="Textarea" || inputtype=="3")
		inputtype="textarea";
	else if(inputtype=="Date"){
		inputtype="date";
	}
	else
		inputtype="text";
	return inputtype;
};
//创建input
TableBuilder.prototype.createInput = function(inputname,inputType,inputValue,unit,inputRange,row,col,checkFormat){
	return TableBuilder.createInput(this.tableId,inputname,inputType,inputValue,unit,inputRange,row,col,checkFormat);
};
TableBuilder.createInput = function(tableId,inputname,inputType,inputValue,unit,inputRange,row,col,checkFormat){
	var result = new StringBuffer();
	var tableIndex = tableId.substring(8);
	var sHtmlStyle = '';
	var iDZColIndex = TableFactory.getDZColIndexFromTalbe(tableId,col);
	var sAlign = TableBuilder.getAlign(tableIndex,iDZColIndex);
	sHtmlStyle += "text-align:" + sAlign;
	sHtmlStyle = 'style="'+ sHtmlStyle +'"';
	//if(true)return inputValue;
	inputType = TableBuilder.reviseInput(inputType);
	var inputname = inputname + "_" + row + "_" + col;
	var inputId = inputname;
	var sLimit = TableBuilder.getLimit(tableIndex,iDZColIndex);
	//alert(inputId);
	//alert(inputType);
	if(inputType == 'select'){
		result.append('<select id="'+inputId+'" onfocus="clearErrors(this)" name="'+inputname+'" '+sHtmlStyle+' class="list_all_input_select" onchange="tableDatas[\''+ tableId +'\']['+ row +']['+ col +']=this.value">');
		if(inputRange){
			for(var i=0;i<inputRange.length;i+=2){
				var sel = '';
				if(inputRange[i]==inputValue)sel = 'selected';
				result.append('<option value="'+ inputRange[i] +'" '+ sel +'>'+ inputRange[i+1] +'</option>');
			}
		}
		result.append('</select>');
		//result.append(unit);
	}
	else if(inputType == 'radio'){
		if(inputRange){
			for(var i=0;i<inputRange.length;i+=2){
				var sel = '';
				if(inputRange[i]=='')continue;
				if(inputRange[i]==inputValue)sel = 'checked';
				result.append('<input onfocus="clearErrors(this)" '+sHtmlStyle+' id="'+inputId+'_'+ i +'" name="'+inputname+'" type="'+ inputType +'" value="'+ inputRange[i] +'" '+sel+' onclick="tableDatas[\''+ tableId +'\']['+ row +']['+ col +']=this.value">' + inputRange[i+1]);
			}
			if(row==0)
				TableBuilder.columnEgnoreGrag[TableBuilder.columnEgnoreGrag.length] = col;
		}
		else{
			result.append(inputValue);
		}
	}
	else if(inputType == 'checkbox'){
		var sel = '';
		if(inputValue=='1')sel = 'checked';
		result.append('<input onfocus="clearErrors(this)" id="'+inputId+'" '+sHtmlStyle+'  name="'+inputname+'" type="'+ inputType +'" '+ sel +' onclick="tableDatas[\''+ tableId +'\']['+ row +']['+ col +']=(this.checked?1:0)">');
		if(row==0)
			TableBuilder.columnEgnoreGrag[TableBuilder.columnEgnoreGrag.length] = col;
	}
	else if(inputType=='textarea'){
		//alert(inputType);
		var iDZColIndex = TableFactory.getDZColIndexFromTalbe(tableId,col);
		result.append('<input onfocus="clearErrors(this)" id="'+inputId+'" '+sHtmlStyle+'  class="list_all_input_1" name="'+inputname+'" type="text" value="'+ inputValue.substring(0,20) +'" onclick="window.showModalDialog(\''+ sDWResourcePath +'/TextAreaDialog.jsp?tableId='+tableId+'&tableRow='+row+'&tableCol='+col+'&dzCol='+ iDZColIndex +'\',self,\'dialogWidth:500px,dialogHeight:400px\')">');
	}
	else if(inputType=='date'){
		var iDZColIndex = TableFactory.getDZColIndexFromTalbe(tableId,col);
		//alert(inputId);
		//alert('<input id="'+inputId+'" '+sHtmlStyle+' class="list_all_input_1 easyui-datebox" name="'+inputname+'" type="text" value="'+ inputValue +'" onchange="tableDatas[\''+ tableId +'\']['+ row +']['+ col +']=this.value">');
		var sStartDate = "1900/01/01";
		var sEndDate = "2100/12/31";
		if(inputRange && inputRange[2]){
			sStartDate=inputRange[2];
		}
		if(inputRange && inputRange[3]){
			sEndDate=inputRange[3];
		}
		result.append('<input onfocus="clearErrors(this)" onclick="SelectDate(this,\'yyyy\\/MM\\/dd\',\''+ sStartDate +'\',\''+ sEndDate +'\')" id="'+inputId+'" '+sHtmlStyle+' '+sLimit+' class="list_all_input_1" name="'+inputname+'" readonly type="text" value="'+ inputValue +'" onchange="tableDatas[\''+ tableId +'\']['+ row +']['+ col +']=this.value">');
		TableBuilder.dateArray[TableBuilder.dateArray.length]=[col,inputId];
		if(row==0)
			TableBuilder.columnEgnoreGrag[TableBuilder.columnEgnoreGrag.length] = col;
	}
	else{
		var sExtAttr = "";
		var sOnchange = "";
		var dotSize = 0;
		//alert(checkFormat);
		if(checkFormat && (checkFormat==2 || checkFormat==5 || checkFormat==6 || checkFormat==7 || checkFormat>10)){
			
			//if(checkFormat==2 || checkFormat==5 || checkFormat==6)
			if(checkFormat==5 || checkFormat==6)
				dotSize = 0;
			else if(checkFormat==7 || checkFormat==2)
				dotSize = 2;
			else if(checkFormat>10)
				dotSize = checkFormat - 10;
			
			/*checkFormat==2处理有错,修改为sExtAttr = 'onkeypress="NumberFilter(this.value,'+dotSize+',event)" onbeforepaste="ReplaceNaN(this)"';
			if(checkFormat==2)
				sExtAttr = 'onkeypress="IntegerFilter(this.value,event)" onbeforepaste="ReplaceNaN(this)"';
			else
				sExtAttr = 'onkeypress="NumberFilter(this.value,'+dotSize+',event)" onbeforepaste="ReplaceNaN(this)"';
			*/
			sExtAttr = 'onkeypress="NumberFilter(this.value,'+dotSize+',event)" onbeforepaste="ReplaceNaN(this)"';
			sOnchange = ';if(this.value!=\'\')this.value=FormatKNumber(this.value,'+ dotSize +');';
		}
		result.append('<input onfocus="clearErrors(this)" id="'+inputId+'" '+sHtmlStyle+' '+sLimit+' class="list_all_input_1" name="'+inputname+'" type="text" value="'+ inputValue +'" onblur="tableDatas[\''+ tableId +'\']['+ row +']['+ col +']=this.value" onkeyup="tableDatas[\''+ tableId +'\']['+ row +']['+ col +']=this.value" onchange="'+sOnchange+'" '+sExtAttr+'>');
	}

	return result.toString();
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