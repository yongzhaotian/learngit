/*
����ȫ�ֱ���
*/
var iResultLength = 0;//���������
var iCurIndex = -1;//��ǰ�����α꣬Ĭ��Ϊ-1����ǰѡ�еĽ���������
var sInputValue = "";//�û��Լ����������
var oCurDatas = null;//��ǰ����josn���ص�
var sLastSuggestValue = "";//�ϴ�ѡ�е���ʾ����������û��Լ���������ݣ���Ŀ��������֤�����ı����Ƿ���ϴ�ֵһ�������һ������ԣ������ظ��ύ

//����ؼ���
function saveKey(key){
	/*
	if(key=="")
		return;
	$.get("hit.jsp",{key:key,rand:Math.random()},function(data){});
	*/
}

//select onpress�¼�
function selectPress(url,dono,colname,obj,keyCode){
	var sValueTmp = String.fromCharCode(keyCode);
	if(obj.getAttribute("ValueTime")==undefined || obj.getAttribute("ValueTime")==null)
		obj.setAttribute("ValueTime",(new Date()).getTime());
	else{
		var lasttime = parseInt(obj.getAttribute("ValueTime"));
		var thistime = (new Date()).getTime();
		//alert(thistime+"|" + lasttime + "|" + (thistime-lasttime));
		if(thistime-lasttime>2000){//����2�����������
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
			//����ֵ��ʾѡ��
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

//��ùؼ�����ʾ�б�
function searchSuggest(url,inputobj,dono,colname,keyCode){
	var key = inputobj.value;
	if(key!='' && (keyCode==38 || keyCode==40 || keyCode==13))	//�ų�up,down,Enter���Ĵ���
		return;
	//�������esc
	if(keyCode==27){
		//inputobj.value='';
		sLastSuggestValue = '';
		document.getElementById("search_suggest").style.display = 'none';
		return;
	}
	//��������û�з����仯����ֱ�ӷ���
	if(key == sLastSuggestValue && key!='')
		return;
	//	if(keyCode==8)alert(key);
	//alert(key);
	iCurIndex = -1;
	sInputValue = key;//���ȱ�����ԭʼ�Ĺؼ���
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
	iResultLength = oCurDatas.length;//�����������
	var value = "";
	if(iResultLength >0)
		value = oCurDatas[0].tradeValue;
	return value;
}

//�������
function showresult(transport,inputobj){
	//���������ʾ�����Ԫ��
	var resultDiv = createSearchNode(inputobj); //document.getElementById("search_suggest");
	var list = eval("(" + transport + ")");
	oCurDatas = list.data;
	iResultLength = oCurDatas.length;//�����������
	if(iResultLength<=0){
		resultDiv.innerHTML = '';
		resultDiv.style.display = 'none';
		return;
	}
	resultDiv.style.display = 'block';
	//�����һ�ε��������
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
	resultDiv.innerHTML += '<div class="suggest_close_div"><a class="suggest_close_href" onclick="clearResource('+inputobj+');">�ر�</a></div>';
}

//�ƶ������
function movePosition(inputobj,step){
	iCurIndex += step;
	if(iCurIndex==-2){//�Ѿ���ͷ���򷵻���������б�����һ��Ԫ��
		iCurIndex = iResultLength-1;
	}
	else if(iCurIndex==iResultLength){//�Ѿ���β���򷵻��Լ��������ԭʼ������
		iCurIndex = -1;
	}
	//��ֵ����
	if(iCurIndex==-1)
		inputobj.value = sInputValue;
	else
		inputobj.value = $.trim(oCurDatas[iCurIndex].tradeValue);
	sLastSuggestValue = inputobj.value;
	//������е���������б���ʽ
	for(var i=0;i<iResultLength;i++){
		document.getElementById('div_result' + i).className = 'suggest_link';
	}
	//�������õ�ǰ��ѡ������ʽ
	if(iCurIndex>-1)
		document.getElementById('div_result' + iCurIndex).className = 'suggest_link_over';
}

/*
�������¼����ƴ���
*/

//������������up ����down���¼�
function inputUpDown(url,inputobj,dono,colname,keyCode){
	//alert(document.getElementById("search_suggest"));
	if(inputobj.value=='' && document.getElementById("search_suggest")==null)
		searchSuggest(url,inputobj,dono,colname,keyCode);
	else{
		if(keyCode==38)movePosition(inputobj,-1);//up
		if(keyCode == 40)movePosition(inputobj,1);//down
	}
}

//�����Ļس��¼��Ĵ���
function inputEnter(inputobj,keyCode){
	if(keyCode==13){
		clearResource(inputobj);
		//�������������ʾ��
		//document.getElementById("search_suggest").style.display = 'none';
		//����ؼ���
		//saveKey(value);
	}
}

//�ı�����ƶ���ѡ��ʱ��css��ʽ
function suggestOver(obj,index){
	//������е���������б���ʽ
	window.status = iResultLength;
	for(var i=0;i<iResultLength;i++){
		document.getElementById('div_result' + i).className = 'suggest_link';
	}
	obj.className = 'suggest_link_over';
	iCurIndex = index;
}

//�ı�����Ƴ���ѡ��ʱ��css��ʽ
function suggestOut(obj){
	//obj.className = 'suggest_link';
}

//������ʾ����¼�����
function suggestClick(value,inputid){
	try{
		var inputobj = document.getElementById(inputid);
		value = $.trim(value);//ȥ�ո���
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