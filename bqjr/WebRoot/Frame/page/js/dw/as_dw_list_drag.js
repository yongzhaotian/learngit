/**
 * 表头拖拉事件
 */
TableBuilder.header_onmousedown = function(self,evt){
	//if(onmousedown)return;
	if(self.currentTH != null) return;
	var obj = document.elementFromPoint(evt.x,evt.y);
	var objL = document.elementFromPoint(evt.x - 2,evt.y);
	if(!objL)return;
	window.status=objL.id;
	if(obj.tagName.toLowerCase() == "th" && obj.childNodes && obj.childNodes[0].columnIndex){
		if(objL.tagName.toLowerCase() == "th")
		{
			obj = objL;
		}
		//alert(obj.tagName);
		if(obj.className == "fixed") return;
		self.currentX = evt.x;
		self.currentTH = obj.childNodes[0];
		self.currentTH.setCapture();
	}
}

TableBuilder.egnoreGrag = function (tableColIndex){
	//alert(tableColIndex);
	if(TableBuilder.columnEgnoreGrag){
		for(var i=0;i<TableBuilder.columnEgnoreGrag.length;i++){
			if(TableBuilder.columnEgnoreGrag[i]==tableColIndex)
				return true;
		}
	}
	return false;
}

TableBuilder.header_onmouseup = function(self,evt){
	//if(onmouseup)return;
	if(self.currentTH != null){
		self.currentTH.releaseCapture();
		self.currentTH = null;
		//alert(1);
		
		//alert(2);
	}
	//change_height();
}

TableBuilder.header_onmousemove = function(self,evt){
	//if(onmousemove)return;
	if(self.currentTH != null){
		//alert(self.currentTH.columnIndex);
		if(self.currentTH.columnIndex && TableBuilder.egnoreGrag(parseInt(self.currentTH.columnIndex)+DZ[0][0][6]))
			return;
		var width = Math.round(parseInt(self.currentTH.clientWidth) + evt.x - self.currentX);
		if(width < 0) width = 0;
		
		var dt = parseInt(self.currentTH.style.width) - width;
		self.currentTH.style.width = width;
		//alert(self.currentTH.columnIndex);
		if(self.currentTH.columnIndex)
			TableBuilder.header_resizeCell(self.currentTH.tableName,self.currentTH.columnIndex,self.currentTH.style.width);
		
		self.currentX = evt.x;
	}
}

TableBuilder.header_resizeCell = function(tableName,idx, width){
	if(isNaN(idx))return;
	var cells = document.getElementById(tableName + "_order_GridBody_Cells");
	var rows = cells.childNodes;
	var i = 0;
	//alert(idx);
	for (var i = 0; i < rows.length; i++){
		var cell = rows[i].childNodes[idx].childNodes[0];
		var resetPattern = /style=[^\s\t\n]+/g;
		//var resetPattern = /DIV style="[\w\W]+?"/g;
		var sHtml = cell.outerHTML;
		//alert(width);
		//alert("old cell:" + sHtml);
		sHtml = sHtml.replace(resetPattern, 'style="width:' +width + ';');
		cell.outerHTML = sHtml; 
		//alert("sHtml=" + sHtml);
	}
	document.getElementById(tableName + "_cells").style.width = document.getElementById(tableName + "_float").offsetWidth;
	TableBuilder.header_reloadEvents();
}
TableBuilder.header_reloadEvents = function(row){
	//因为重写了html,所以事件需要重新调用
	if(DZ[0][0][10]){
		for(var i=0;i<DZ[0][0][10].length;i++){
			addListEventListeners(0,row,DZ[0][0][10][i][0],DZ[0][0][10][i][1],DZ[0][0][10][i][2]);
		}
	}
	//change_height();
}