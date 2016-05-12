/*
定义全局变量
*/
var iResultLength = 0;//结果的条数
var iCurIndex = -1;//当前所在游标，默认为-1代表当前选中的结果是输入框
var sInputValue = "";//用户自己输入的内容
var oCurDatas = null;//当前数据josn返回的
var sLastSuggestValue = "";//上次选中的提示结果（包括用户自己输入的内容）：目的用于验证本次文本框是否和上次值一样，如果一样则忽略，避免重复提交

//保存关键字
function saveKey(key){
	/*
	if(key=="")
		return;
	$.get("hit.jsp",{key:key,rand:Math.random()},function(data){});
	*/
}

//select onpress事件
function selectPress(url,dono,colname,obj,keyCode){
	var sValueTmp = String.fromCharCode(keyCode);
	if(obj.getAttribute("ValueTime")==undefined || obj.getAttribute("ValueTime")==null)
		obj.setAttribute("ValueTime",(new Date()).getTime());
	else{
		var lasttime = parseInt(obj.getAttribute("ValueTime"));
		var thistime = (new Date()).getTime();
		//alert(thistime+"|" + lasttime + "|" + (thistime-lasttime));
		if(thistime-lasttime>2000){//超过2秒则清空数据
			obj.setAttribute("TmpValue","");
		}
		obj.setAttribute("ValueTime",thistime);
	}
	if(obj.getAttribute("TmpValue")==undefined || obj.getAttribute("TmpValue")==null)
		obj.setAttribute("TmpValue",sValueTmp);
	else{
		sValueTmp = obj.getAttribute("TmpValue") + sValueTmp;
		obj.setAttribute("TmpValue",sValueTmp);
		
	}
	$.ajax({
		url:url,
		type:"GET",
		data:{key:sValueTmp,dono:dono,colname:colname,rand:Math.random()},
		dataType:"html",
		success:function(data){
			var value = showresultForSelect(data);
			//根据值显示选项
			for(var i=0;i<obj.options.length;i++){
				//alert(obj.options[i].value + "|" + value);
				if(obj.options[i].value==value)
					obj.options[i].selected = true;
			}
		},
		error:function(xhr,st,err){
			alert(st);
		}
	});
}

//获得关键字提示列表
function searchSuggest(url,inputobj,dono,colname,keyCode){
	var key = inputobj.value;
	if(key!='' && (keyCode==38 || keyCode==40 || keyCode==13))	//排除up,down,Enter键的处理
		return;
	//如果按下esc
	if(keyCode==27){
		//inputobj.value='';
		sLastSuggestValue = '';
		document.getElementById("search_suggest").style.display = 'none';
		return;
	}
	//如果输入框没有发生变化，则直接返回
	if(key == sLastSuggestValue && key!='')
		return;
	//	if(keyCode==8)alert(key);
	//alert(key);
	iCurIndex = -1;
	sInputValue = key;//首先保留最原始的关键字
	sLastSuggestValue = sInputValue;
	$.ajax({
		url:url,
		type:"GET",
		data:{key:key,dono:dono,colname:colname,rand:Math.random()},
		dataType:"html",
		success:function(data){
			showresult(data,inputobj);
		},
		error:function(xhr,st,err){
			alert(st);
		}
	});
}

function createSearchNode(inputobj){
	if(document.getElementById("search_suggest")!=null)
		return document.getElementById("search_suggest");
	var obj = document.createElement("div");
	obj.setAttribute("id","search_suggest");
	obj.style.display = 'none';
	inputobj.parentNode.appendChild(obj,inputobj);
	return obj;
}

function showresultForSelect(transport){
	var list = eval("(" + transport + ")");
	var oCurDatas = list.data;
	iResultLength = oCurDatas.length;//获得搜索总数
	var value = "";
	if(iResultLength >0)
		value = oCurDatas[0].tradeValue;
	return value;
}

//结果处理
function showresult(transport,inputobj){
	//获得搜索提示结果的元素
	var resultDiv = createSearchNode(inputobj); //document.getElementById("search_suggest");
	var list = eval("(" + transport + ")");
	oCurDatas = list.data;
	iResultLength = oCurDatas.length;//获得搜索总数
	if(iResultLength<=0){
		resultDiv.innerHTML = '';
		resultDiv.style.display = 'none';
		return;
	}
	resultDiv.style.display = 'block';
	//清除上一次的搜索结果
	resultDiv.innerHTML = '';

	for(var i=0;i<iResultLength;i++){
		var suggest = '<table id="div_result'+ i +'" '
			+ 'width="100%" border="0" cellspacing="0" cellpadding="0" '
			+ 'onmouseover="suggestOver(this,'+ i +')" '
			//+ 'onmouseout="suggestOut(this)" '
			+ 'onclick=suggestClick("'+ oCurDatas[i].tradeValue +'","'+inputobj.id+'") '
			+ 'class="suggest_link"'
			+ '><tr>'
			+ '<td width= "20%">'+oCurDatas[i].tradeKey+'&nbsp;</td>';
		if(oCurDatas[i].tradeTitle=='' || oCurDatas[i].tradeTitle==null || oCurDatas[i].tradeTitle==undefined)
			suggest+= '<td align="left" width="80%">'+oCurDatas[i].tradeValue+'&nbsp</td>';
		else
			suggest+= '<td align="left" width="80%">'+oCurDatas[i].tradeTitle+'['+ oCurDatas[i].tradeValue +']&nbsp</td>';
			//+ '<td width= "50%" align="left">'+oCurDatas[i].tradeTitle+'</td>'
		suggest	+= '</tr></table>';
		resultDiv.innerHTML += suggest;
	}
	resultDiv.innerHTML += '<div class="suggest_close_div"><a class="suggest_close_href" onclick="clearResource('+inputobj+');">关闭</a></div>';
}

//移动结果项
function movePosition(inputobj,step){
	iCurIndex += step;
	if(iCurIndex==-2){//已经到头，则返回搜索结果列表的最后一个元素
		iCurIndex = iResultLength-1;
	}
	else if(iCurIndex==iResultLength){//已经到尾，则返回自己输入的最原始的数据
		iCurIndex = -1;
	}
	//赋值操作
	if(iCurIndex==-1)
		inputobj.value = sInputValue;
	else
		inputobj.value = $.trim(oCurDatas[iCurIndex].tradeValue);
	sLastSuggestValue = inputobj.value;
	//清除所有的搜索结果列表样式
	for(var i=0;i<iResultLength;i++){
		document.getElementById('div_result' + i).className = 'suggest_link';
	}
	//重新设置当前的选中项样式
	if(iCurIndex>-1)
		document.getElementById('div_result' + iCurIndex).className = 'suggest_link_over';
}

/*
以下是事件控制代码
*/

//处理结果项上移up 下移down的事件
function inputUpDown(url,inputobj,dono,colname,keyCode){
	//alert(document.getElementById("search_suggest"));
	if(inputobj.value=='' && document.getElementById("search_suggest")==null)
		searchSuggest(url,inputobj,dono,colname,keyCode);
	else{
		if(keyCode==38)movePosition(inputobj,-1);//up
		if(keyCode == 40)movePosition(inputobj,1);//down
	}
}

//输入框的回车事件的处理
function inputEnter(inputobj,keyCode){
	if(keyCode==13){
		clearResource(inputobj);
		//隐藏搜索结果提示框
		//document.getElementById("search_suggest").style.display = 'none';
		//保存关键字
		//saveKey(value);
	}
}

//改变鼠标移动到选项时的css样式
function suggestOver(obj,index){
	//清除所有的搜索结果列表样式
	window.status = iResultLength;
	for(var i=0;i<iResultLength;i++){
		document.getElementById('div_result' + i).className = 'suggest_link';
	}
	obj.className = 'suggest_link_over';
	iCurIndex = index;
}

//改变鼠标移出该选项时的css样式
function suggestOut(obj){
	//obj.className = 'suggest_link';
}

//搜索提示项单击事件处理
function suggestClick(value,inputid){
	try{
		var inputobj = document.getElementById(inputid);
		value = $.trim(value);//去空格处理
		inputobj.value = value;
		clearResource(inputobj);
	}
	catch(e){}
	//document.getElementById("search_suggest").style.display = 'none';
}

function clearResource(inputobj){
	try{
		inputobj.parentNode.removeChild(document.getElementById("search_suggest"));	
	}
	catch(e){}
	iResultLength =0;
	iCurIndex = -1;
	sInputValue = "";
	oCurDatas = null;
	sLastSuggestValue = "";	
}