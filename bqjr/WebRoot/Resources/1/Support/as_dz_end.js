function getTrueLength(mystr){
	var cArr = mystr.match(/[^x00-xff]/ig);
	return mystr.length+(cArr==null?0:cArr.length);
}

function  getLeft(mystr,leftLen){
	var mylen=mystr.length;
	var realNum=0;
	for(var i=1;i<=mylen;i++){
		if(mystr.charCodeAt(i-1)<0||mystr.charCodeAt(i-1)>255)
			realNum++;
		if(i+realNum==leftLen) break;
		if(i+realNum>leftLen) {i--; break; }
	}
	return mystr.substring(0,i);
}	

function textareaMaxByIndex(iDW,iRow,iCol){ 
	var obj=getASObjectByIndex(iDW,iRow,iCol); 
	var maxlimit=DZ[iDW][1][iCol][7]; 
	if(maxlimit==0) return; 
	//if (obj.value.length > maxlimit)  
	//	obj.value = obj.value.substring(0, maxlimit); 	
	if(getTrueLength(obj.value) > maxlimit){
		obj.value = getLeft(obj.value, maxlimit); 
	}
} 


/*去除F2就放开此函数
function AsSaveResult(myobjname){}
*/	

function isDate(value,separator){
	if(value==null||value.length<10) return false;	
	var sItems = value.split(separator); // value.split("/");
	
    if (sItems.length!=3) return false;
    if (isNaN(sItems[0])) return false;
    if (isNaN(sItems[1])) return false;
    if (isNaN(sItems[2])) return false;
    //年份必须为4位，月份和日必须为2位
    if (sItems[0].length!=4) return false;
    if (sItems[1].length!=2) return false;
    if (sItems[2].length!=2) return false;

    if (parseInt(sItems[0],10)<1900 || parseInt(sItems[0],10)>2150) return false;
    if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
    if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;

    if ((sItems[1]<=7) && ((sItems[1] % 2)==0) && (sItems[2]>=31)) return false;
    if ((sItems[1]>=8) && ((sItems[1] % 2)==1) && (sItems[2]>=31)) return false;
    //本年不是闰年
	if (!((sItems[0] % 4)==0) && (sItems[1]==2) && (sItems[2]==29)){
		if ((sItems[1]==2) && (sItems[2]==29)) return false;
	}else{
		if ((sItems[1]==2) && (sItems[2]==30)) return false;
    }

    return true;
}

try{
	document.frames["myiframe0"].document.body.oncontextmenu='self.event.returnValue=true';
}catch(e){}

function myUpdateTotalSum(myobjname){
	try {
		var myi = myobjname.substring(myobjname.length-1);
		var mycss = frames(myobjname).document.styleSheets[0].href; 
		
		if(DZ[myi][0][4]==1 && mycss.indexOf("style_rp.css")>0 ) //my_load_show:ShowSummary  && style_rp.css
		{ 
			var mytjTable = frames(myobjname).document.body.getElementsByTagName("TABLE")[0];
			var mytjRow = mytjTable.rows[mytjTable.rows.length-1];
			var mytjCells = mytjRow.cells;

			var i = 0, iColShow = 0;
		
			for(i=0;i<f_c[myi];i++){
				if(DZ[myi][1][i][2]==0) continue; 
				iColShow ++;
				if(DZ[myi][1][i][14]==2)
					mytjCells[iColShow].innerHTML = "&nbsp;"+amarMoney(DZ[myi][3][i],DZ[myi][1][i][12])+"&nbsp;";
			}
		}
	} 	catch(e) { var a = 1; }
}
/*
function my_load_show_action_s(myobjname,myact,my_sortorder,sort_which){
	try { 
	 	if(!before_my_load_show_action_s(myobjname,myact,my_sortorder,sort_which)) return;
	 	if(!isValid()) return; 
	 	
	 	var myi=myobjname.substring(myobjname.length-1);	 
	 	switch(myact){
	 		case 1:		 
	 			s_c_p[myi]=0;		 
	 			break;		 
	 		case 2:		 
	 			if(s_c_p[myi]>0) s_c_p[myi]--;		 
	 			break;		 
	 		case 3:		 
	 			if(s_c_p[myi]<s_p_c[myi]-1) s_c_p[myi]++;	 
	 			break;		 
	 		case 4:		 
	 			s_c_p[myi]=s_p_c[myi]-1;		 
	 			break;		 
	 	}		 
	 	 
	 	var myoldstatus = window.status; 
	 	window.status="正在从服务器获得数据，请稍候....";   
	 	ShowMessage("正在从服务器获得数据，请稍候....",true,false);
	 	//alert("DZ="+DZ);
	 	self.showModalDialog(sPath+"GetDWData.jsp?dw="+DZ[myi][0][1]+"&pg="+s_c_p[myi]+"&rand="+amarRand(),window.self,"dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
	 	try{hideMessage();}catch(e) {} 
	 	window.status=myoldstatus; 
	 	   
	 	init(false);
	 	
	 	my_load_show(2,0,myobjname);
	 	
	 	myUpdateTotalSum(myobjname);
	 	
	} 	catch(e) { var a = 1; }
}		 
*/ 
