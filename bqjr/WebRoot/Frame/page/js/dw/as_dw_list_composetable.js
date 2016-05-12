var tableNames = new Array();
var selectedRows = new Array();//��¼���ѡ�е��кţ���ά����
var filterValues = new Array();//��¼����Ӧ��filterֵ
var tableDatas = new Array();//����ÿ����������

/*uiparams

{
	colors:[], ��ɫ���룺[0]-ż������ɫ��[1]-��������ɫ��[2]-��껮����ɫ��[3]-ѡ�е�����ɫ
	lockCols:int,��������
	floatWidth:int,���
	floatHeigth:int �߶�
	combineLeft:[][] ���ϲ�����:��ά����array[i][0]=���⣬array[i][1]="...colspan=x..."
	combineRight:[][] �Ҳ��ϲ�����:��ά����array[i][0]=���⣬array[i][1]="...colspan=x..."
	clientCount:["С��","1,2-3,4"] �ͻ���ͳ��,clientCount[1]:�������ö��ŷָ���֧��-��clientCount[0]:����
	serverCount:������ͳ�ƣ�["�ܼ�","100","200"],��heads��1�У���һ�б�ʾ���⣬��������ʾͳ������
	depth:��νṹ����������treeview  depth[i]=0��ʾ���,ע�⣺
		1 ���û�ж����л��Զ���lockColsΪ1
		2 depth��heads��һ����Ԫ��depth[length]>depth[length-1]��ʾ���ɽڵ�
	defaultWidths : Ĭ���п�defaultWidths=self��ʾ����Ӧ
	htmlStyle:���е�html����
	sortable:sortable	�Ƿ������
	colAlign:�ֶ�����ʽ���飺1:����룬2:�У�3:�Ҷ���
	checkFormat:checkFormat		��ʽ��������������	
	colReadOnly:colReadOnly,	�Ƿ�ֻ��
	colEditStyle:colEditStyle	��ʾ�ؼ�
	
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
	this.range = range;//ȡֵ��Χ
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
		this.defaultWidths = new Array(this.heads.length);//����ÿһ�е������
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

/*���õ�Ԫ����ʾ����*/
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
			//ʵ��ֵ�滻
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
//��ʼ����ֵ����
TableBuilder.prototype.initValue = function(){
	selectedRows[this.tableId] = new Array();
};
//ˢ�½���
TableBuilder.prototype.refreshHTML = function(){
	document.getElementById("table1").outerHTML = this.createTableHTML();
};

//����Ӧ��ȵ���
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

//���Ĭ�Ͽ��
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
	//��������
	//sbResult.append('<table border="0" cellspacing="0" cellpadding="0" width="100%" id="'+ this.tableId +'" origFloatWidth="'+ this.floatWidth +'" origFloatHeight="'+ this.floatHeight +'" lockCols="'+ this.lockCols +'" onselectstart="javascript:if(event.shiftKey)return false;">');
	if(this.tableId=='myiframe0')
		sbResult.append('<div class="list_topdiv_header" style="overflow:auto;width:100%;height:500px">');
	sbResult.append('<table border="0" cellspacing="0" cellpadding="0" id="'+ this.tableId +'">');
	//�������
	sbResult.append('<thead id="TH_Right_'+ this.tableId +'" >');
	//��������ѡ����
	if(this.tableId=='myiframe0')
		sbResult.append('<th style="width:10px;" class="list_left_border">&nbsp;</th>');
	sbResult.append('<th style="width:40px;">&nbsp;</th>');
	for(var i=0;i<this.heads.length;i++){
		sbResult.append('<th style="'+this.getDefaultWidth(i)+';">'+ this.heads[i] +'</th>');
	}
	if(this.tableId=='myiframe0')
		sbResult.append('<th style="border:0px;background:none;">&nbsp;</th>');
	sbResult.append('</thead>');
	//�������
	for(var i=0;i<tableDatas[this.tableId].length;i++){
		sbResult.append('<tr tableId="'+ this.tableId +'" id="TR_Right_'+ this.tableId +'_'+ i +'" '+ this.getIntervalColor(i) +' origColor="'+ this.colors[i%2] +'" lightColor="'+ this.colors[2] +'" onMouseOver="TableBuilder.TRMouseOver('+i+',undefined,this,\''+ this.colors[3] +'\',event)" onmousedown="TableBuilder.TRClick('+i+',undefined,this,\''+ this.colors[3] +'\',event)" onMouseOut="TableBuilder.TRMouseOut('+i+',undefined,this,\''+ this.colors[3] +'\',event)">');
		//���+
		if(this.tableId=='myiframe0')
			sbResult.append('<td showSub="false" class="list_checkbox_td2 list_composetable_left1">&nbsp;&nbsp;</td>');
		//��������
		var iCurPage = s_c_p[this.tableId.substring(8)];
		var iPageSize = s_p_s[this.tableId.substring(8)];
		sbResult.append('<td class="list_all_no2">'+ (i+1 + iCurPage*iPageSize) +'</td>');
		//�������
		//alert("tableDatas[this.tableId][i].length=" + tableDatas[this.tableId][i].length);
		for(var j=0;j<tableDatas[this.tableId][i].length;j++){
			sbResult.append('<td class="list_all_td" style="padding-left:2px;"');
			if(this.htmlStyle && this.htmlStyle[j]){
				sbResult.append(' ' + this.htmlStyle[j]);
			}
			//���뷽ʽ
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
		//����ӱ�
		sbResult.append('<tr id="TR_SUB_'+this.tableId+'_'+ (i+1) +'" style="display:none">');
		//��������ѡ����
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
TableBuilder.setSubList = function(lineIndex,argsValue,target){//linIndex��0��ʼ
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
				//��¼ԭʼth���
				var widthArray = new Array();
				for(var i=0;i<thParent.childNodes.length;i++)
					widthArray[i] = thParent.childNodes[i].clientWidth;
				alert(widthArray);
				td.innerHTML = TableFactory.createTableHTML(lineIndex);
				//�������ô���Ŀ��
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

//��ü��ɫ����
TableBuilder.prototype.getIntervalColor = function(i){
	var color = "";
	if(this.colors)
		color = " style='background-color:"+ this.colors[i % 2] + "'";
	return color;
};

//�������뿪Ч��
TableBuilder.TRMouseOut = function(index,objleft,objright,visitedColor,evt){
	if(objright){//ѡ���ұߵ����
		if(typeof(objright)=='string')objright=document.getElementById(objright);
		var showColor = "";
		if(index!=TableBuilder.iCurrentRow[objright.getAttribute("tableId")])//�������ѡ�������У���ԭ��ɫ
			showColor = objright.getAttribute("origColor");
		else{//�����ѡ�������У�����ʾ���ʹ�����ɫ
			showColor = visitedColor;
		}
	
		objright.style.backgroundColor = showColor;
	}
	
};
//�����껮��Ч��
TableBuilder.TRMouseOver = function(index,objleft,objright,visitedColor,evt){
	if(objright){//ѡ���ұߵ����
		if(typeof(objright)=='string')objright=document.getElementById(objright);
		objright.style.backgroundColor = objright.getAttribute("lightColor");
	}
};

//��ѡ�е�����ʾ��ɫ:ȡ��
TableBuilder.displaySelectedRowsColor= function(tableId,dataSize,visitedColor){
	//window.status = selectedRows[tableId];
	
	for(var i=0;i<dataSize;i++){
		var obj = document.getElementById("TR_Right_" + tableId + "_" + i);
		var showColor = visitedColor;
		if(TableBuilder.isStrInArray(selectedRows[tableId],i)==-1)//�������ѡ�������У���ԭ��ɫ
			showColor = obj.getAttribute("origColor");
		else{//�����ѡ�������У�����ʾ���ʹ�����ɫ
			showColor = visitedColor;
		}
		obj.style.backgroundColor = showColor;
	}
};
//����ǰ�����и���ɫ
TableBuilder.displayCurrentRowColor = function(tableId,dataSize,visitedColor){
	//alert("visitedColor=" + visitedColor);
	for(var i=0;i<dataSize;i++){
		var obj = document.getElementById("TR_Right_" + tableId + "_" + i);
		//if(i==0)alert(visitedColor);
		var showColor = visitedColor;
		if(i!=TableBuilder.iCurrentRow[tableId])//������ڵ���״̬����ԭ��ɫ
			showColor = obj.getAttribute("origColor");
		else{//����ڵ���״̬������ʾ���ʹ�����ɫ
			showColor = visitedColor;
		}
		obj.style.backgroundColor = showColor;
	}
};
//�е����¼�
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
	if(isCheckBoxSelected==false){//���û���κ��б���
		selectedRows[tableId] = [];
		selectedRows[tableId][0] = index;
	}
	mySelectRow();
	TableBuilder.displayCurrentRowColor(tableId,dataSize,visitedColor);
};

//���ĳһ���п�
TableBuilder.getColumnWidth = function(tableId,colindex){
	var table = document.getElementById(tableId);
	var lockCols = parseInt(table.getAttribute("lockCols"));//��ö�������
	var headTh = null;
	var colHeadObj = null;
	if(colindex<lockCols){//��������
		headTh = document.getElementById("TH_Left_" + tableId);
		colHeadObj = headTh.childNodes[0].childNodes[colindex+1].childNodes[0];
	}
	else{//��������
		headTh = document.getElementById("TH_Right_" + tableId);
		colHeadObj = headTh.childNodes[0].childNodes[colindex-lockCols].childNodes[0];
	}
	return colHeadObj.clientWidth;
};
//checkboxѡ�����
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

//��ö�������Ŀ��
TableBuilder.getLockAreaWidths = function(tableId){
	return 0;
};
//����ĳһ�еĿ��
TableBuilder.setColumnWidth = function(tableId,colindex,width){
	var table = document.getElementById(tableId);
	var tableIndex = tableId.substring(8);
	var lockCols = parseInt(table.getAttribute("lockCols"));//��ö�������
	var headTh = null;//Ҫ�޸ĵı���thead����
	var dataTB = null;//Ҫ�޸ĵ�����tbody����
	var colHeadObj = null;//Ҫ�޸ĵı����ж���div
	var colDataObjs = null;//Ҫ�޸ĵ������ж���div��ע�⣬�����Ǹ�����
	//alert("colindex = " + colindex);
	if(colindex<lockCols){//��������
		headTh = document.getElementById("TH_Right_" + tableId);
		dataTB = document.getElementById(tableId + "_order_GridBody_Locks");
		//headTh���Զ�����tr,����ͨ��headTh.childNodes[0]�Ȼ��tr�����ڻ��th
		//headTh.childNodes[0].childNodes[colindex+1]��ʾth��+1Ŀ�����ų������
		//headTh.childNodes[0].childNodes[colindex+1].childNodes[0]��ʾth�µ�div����
		//alert(headTh.childNodes[0].outerHTML);
		try{
			if(DZ[tableIndex][0][11] == 1)//��������ѡ���ʱ����Ҫcolindex+2
				colHeadObj = headTh.childNodes[0].childNodes[colindex+2].childNodes[0];
			else
				colHeadObj = headTh.childNodes[0].childNodes[colindex+1].childNodes[0];
		}
		catch(e){
			if(DZ[tableIndex][0][11] == 1)//��������ѡ���ʱ����Ҫcolindex+2
				colHeadObj = headTh.childNodes[colindex+2].childNodes[0];
			else
				colHeadObj = headTh.childNodes[colindex+1].childNodes[0];
		}
	}
	else{//��������
		headTh = document.getElementById("TH_Right_" + tableId);
		dataTB = document.getElementById(tableId + "_order_GridBody_Cells");
		//headTh.childNodes[0].childNodes[colindex-lockCols]��ʾtd
		//headTh.childNodes[0].childNodes[colindex-lockCols].childNodes[0]��ʾtd�µ�div����
		//alert(headTh.childNodes[0].innerHTML);
		try{
			colHeadObj = headTh.childNodes[0].childNodes[colindex-lockCols].childNodes[0];
		}
		catch(e){
			colHeadObj = headTh.childNodes[colindex-lockCols].childNodes[0];
		}
	}
	//alert(colDataObj);
	
	//���ñ����п��
	var resetPattern = /style=[^\s\t\n]+/;
	//alert(colHeadObj.parentNode.innerHTML);
	//alert(colHeadObj.outerHTML);
	if(isIEBrowser())
		colHeadObj.outerHTML = colHeadObj.outerHTML.toString().replace(resetPattern, "style='width:" +width + "'");
	else
		colHeadObj.parentNode.innerHTML = colHeadObj.parentNode.innerHTML.replace(resetPattern, "style='width:" +width + "'");
	//alert(colHeadObj.outerHTML);
	//colHeadObj.style.width = width + "px";
	//���������п�ȣ�ע�⣬������Ҫ���ÿ�в�����������С�Ļ��������
	var TrDatas = dataTB.childNodes;
	for(var i=0;i<TrDatas.length;i++){
		var td = null;
		if(colindex<lockCols){//��������
			if(DZ[tableIndex][0][11] == 1)//��������ѡ���ʱ����Ҫcolindex+2
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
//���õ�Ԫ�����ʽ
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
//���õ�Ԫ����ʽ��
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
//��������ʽ��
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

//������ͨ�ú���
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
//����ֽڳ���
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
	["&amp;","&"],//�����ڵ�һ��
	["&quot;","\""],
	["&lt;","<"],
	["&gt;",">"],
	["&nbsp;"," "],  
	["&acute;","'"],
	["","\n"]
];
   //��js����ת����html����
TableBuilder.convertJS2HTML = function(str,checkFormat){
	if(str==null)return "";
   	for(var i=0;i<TableBuilder.ConvertWordMap.length;i++){
   		str = str.replace(TableBuilder.ConvertWordMap[i][1],TableBuilder.ConvertWordMap[i][0]);
   	}
   	//��ʽ����ʾ
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
//�첽ˢ�����ڿؼ�
TableBuilder.checkDateForAsync = function(){
	
};
TableBuilder.reloadDateForAsync = function(){
	
};