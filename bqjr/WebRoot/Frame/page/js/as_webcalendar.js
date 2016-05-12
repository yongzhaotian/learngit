var calarray = new Array();
var cal;
var isFocus=false; //�Ƿ�Ϊ����
var pickMode ={
"second":1,
"minute":2,
"hour":3,
"day":4,
"month":5,
"year":6 };

var topY=0,leftX=0; //�Զ��嶨λƫ���� 
//ѡ������ͨ�� ID ��ѡ����
function SelectDateById(id,strFormat,x,y)
{
var obj = document.getElementById(id);
if(obj == null){return false;}
obj.focus();
if(obj.onclick != null){obj.onclick();}
else if(obj.click != null){obj.click();}
else{SelectDate(obj,strFormat,postEvent,x,y);}
}

function getCal(obj,date){
	if(calarray.length==0){
		calarray[0] = [obj,date];
		return date;
	}
	for(var i=0;i<calarray.length;i++){
		if(obj==calarray[i][0])
			return calarray[i][1];
	}
	calarray[calarray.length] = [obj,date];
	return date;
}

//ѡ������
function SelectDate(obj,strFormat,startDate,endDate,postEvent,x,y){

	leftX =(x == null) ? leftX : x;
	topY =(y == null) ? topY : y;//�Զ��嶨λƫ����
	if(document.getElementById("ContainerPanel")==null){InitContainerPanel();}
	var date = new Date();
	var by = date.getFullYear()-50; //��Сֵ �� 50 ��ǰ
	if(startDate){
		by = startDate;
	}
	by = date.getFullYear()-80;
	var ey = date.getFullYear()+50; //���ֵ �� 50 ���
	if(endDate){
		ey = endDate;
	}
	//cal = new Calendar(by, ey,1,strFormat); //��ʼ��Ӣ�İ棬0 Ϊ���İ�
	//cal = (cal==null) ? new Calendar(by, ey, 0) : cal; //����ÿ�ζ���ʼ��
	cal = getCal(obj,new Calendar(by, ey, 0));
	//alert('x'); 
	cal.DateMode =pickMode["second"]; //��λ
	if(strFormat.indexOf('s')< 0) {cal.DateMode =pickMode["minute"];}//����Ϊ��
	if(strFormat.indexOf('m')< 0) {cal.DateMode =pickMode["hour"];}//����Ϊʱ
	if(strFormat.indexOf('h')< 0) {cal.DateMode =pickMode["day"];}//����Ϊ��
	if(strFormat.indexOf('d')< 0) {cal.DateMode =pickMode["month"];}//����Ϊ��
	if(strFormat.indexOf('M')< 0) {cal.DateMode =pickMode["year"];}//����Ϊ��
	if(strFormat.indexOf('y')< 0) {cal.DateMode =pickMode["second"];}//Ĭ�Ͼ���Ϊ��
	cal.dateFormatStyleOld = cal.dateFormatStyle;
	cal.dateFormatStyle = strFormat;
	cal.show(obj);
	cal.postEvent = postEvent;//��Ӻ����¼�
}
/**//**//**//**//**//**//**//**
* ��������
* @param d the delimiter
* @param p the pattern of your date
*/
String.prototype.toDate = function(style) {
var y = this.substring(style.indexOf('y'),style.lastIndexOf('y')+1);//��
var M = this.substring(style.indexOf('M'),style.lastIndexOf('M')+1);//��
var d = this.substring(style.indexOf('d'),style.lastIndexOf('d')+1);//��
var h = this.substring(style.indexOf('h'),style.lastIndexOf('h')+1);//ʱ
var m = this.substring(style.indexOf('m'),style.lastIndexOf('m')+1);//��
var s = this.substring(style.indexOf('s'),style.lastIndexOf('s')+1);//��

if(s == null ||s == "" || isNaN(s)) {s = new Date().getSeconds();}
if(m == null ||m == "" || isNaN(m)) {m = new Date().getMinutes();}
if(h == null ||h == "" || isNaN(h)) {h = new Date().getHours();}
if(d == null ||d == "" || isNaN(d)) {d = new Date().getDate();}
if(M == null ||M == "" || isNaN(M)) {M = new Date().getMonth()+1;}
if(y == null ||y == "" || isNaN(y)) {y = new Date().getFullYear();}
var dt ;
eval ("dt = new Date('"+ y+"', '"+(M-1)+"','"+ d+"','"+ h+"','"+ m+"','"+ s +"')");
return dt;
};

/**//**//**//**//**//**//**//**
* ��ʽ������
* @param d the delimiter
* @param p the pattern of your date
* @author meizz
*/
Date.prototype.format = function(style) {
var o = {
"M+" : this.getMonth() + 1, //month
"d+" : this.getDate(), //day
"h+" : this.getHours(), //hour
"m+" : this.getMinutes(), //minute
"s+" : this.getSeconds(), //second
"w+" : "��һ����������".charAt(this.getDay()), //week
"q+" : Math.floor((this.getMonth() + 3) / 3), //quarter
"S" : this.getMilliseconds() //millisecond
};
if(/(y+)/.test(style)) {
style = style.replace(RegExp.$1,
(this.getFullYear() + "").substr(4 - RegExp.$1.length));
}
for(var k in o){
if(new RegExp("("+ k +")").test(style)){
style = style.replace(RegExp.$1,
RegExp.$1.length == 1 ? o[k] :
("00" + o[k]).substr(("" + o[k]).length));
}
}
return style;
};
//������ѡ����
Calendar.prototype.ReturnDate = function(datevalue,dt) {
	//alert(this.beginDate + "," + datevalue);
	if(this.beginDate && datevalue<this.beginDate)return;//������ʱ�仹����ֱ�ӷ���
	if(this.endDate && datevalue>this.endDate)return;//������ʱ�仹����ֱ�ӷ���
	if (this.dateControl != null){this.dateControl.value = dt;}
	calendar.hide();
	calendar.dayValue = dt;
	if(this.dateControl.onchange == null){return;}
	//�� onchange ת���������������ⴥ����֤�¼�
	//var ev = this.dateControl.onchange.toString(); //�ҳ��������ִ�
	//ev = ev.substring(
	//((ev.indexOf("ValidatorOnChange();")> 0) ? ev.indexOf("ValidatorOnChange();") + 20 : ev.indexOf("{") + 1)
	//, ev.lastIndexOf("}"));//ȥ����֤���� ValidatorOnChange();
	//var fun = new Function(ev); //���¶��庯��
	//this.dateControl.onchange = fun;
	this.dateControl.onchange();//�����Զ��� changeEvent ����
};
//�����������
Calendar.prototype.ReturnMaxDate = function(datevalue,dt) {
	if (this.dateControl != null){this.dateControl.value = dt;}
	calendar.hide();
	calendar.dayValue = dt;
	if(this.dateControl.onchange == null){return;}
	this.dateControl.onchange();//�����Զ��� changeEvent ����
};

/**//**//**//**//**//**//**//**
* ������
* @param beginYear 1990
* @param endYear 2010
* @param lang 0(����)|1(Ӣ��) ����������
* @param dateFormatStyle "yyyy-MM-dd";
* @update
*/
function Calendar(beginDate, endDate, lang, dateFormatStyle) {
this.beginYear = 1950;
this.endYear = 2050;
this.lang = 0; //0(����) | 1(Ӣ��)
this.dateFormatStyle = "yyyy-MM-dd hh:mm:ss";
this.beginDate;
this.endDate;
if(beginDate){
	if(typeof(beginDate)=="number"){
		this.beginYear = beginDate;
		this.beginDate = new Date(this.beginYear,0,1);
	}
	else{
		this.beginYear = parseInt(beginDate.substring(0,4));
		var sMonth = beginDate.substring(5,7);
		if(sMonth.substring(0,1)=="0")
			sMonth = sMonth.substring(1);
		var sDay = beginDate.substring(8,10);
		if(sDay.substring(0,1)=="0")
			sDay = sDay.substring(1);
		this.beginDate = new Date(this.beginYear,parseInt(sMonth)-1,parseInt(sDay));
		//alert(this.beginDate);
	}
}
if(endDate){
	if(typeof(endDate)=="number"){
		this.endYear = endDate;
		this.endDate = new Date(this.endYear,12,31);
	}
	else{
		this.endYear = parseInt(endDate.substring(0,4));
		var sMonth = endDate.substring(5,7);
		if(sMonth.substring(0,1)=="0")
			sMonth = sMonth.substring(1);
		var sDay = endDate.substring(8,10);
		if(sDay.substring(0,1)=="0")
			sDay = sDay.substring(1);
		this.endDate = new Date(this.endYear,parseInt(sMonth)-1,parseInt(sDay));
	}
}
//alert("beginDate=" + this.beginDate);
//alert("endYear=" + this.endYear);
/*
if (beginYear != null && endYear != null){
	this.beginYear = beginYear;
	this.endYear = endYear;
}
*/
if (lang != null){
this.lang = lang;
}

if (dateFormatStyle != null){
this.dateFormatStyle = dateFormatStyle;
}

this.dateControl = null;
this.panel = this.getElementById("calendarPanel");
this.container = this.getElementById("ContainerPanel");
this.form = null;

this.date = new Date();
this.year = this.date.getFullYear();
this.month = this.date.getMonth();

this.day = this.date.getDate();
this.hour = this.date.getHours();
this.minute = this.date.getMinutes();
this.second = this.date.getSeconds();

this.colors = {
"cur_word" : "#FFFFFF", //��������������ɫ
"cur_bg" : "#ff8800", //�������ڵ�Ԫ��Ӱɫ
"sel_bg" : "#81cbff", //�ѱ�ѡ������ڵ�Ԫ��Ӱɫ
"sun_word" : "#FF0000", //������������ɫ
"sat_word" : "#0000FF", //������������ɫ
"td_word_light" : "#333333", //��Ԫ��������ɫ
"td_word_dark" : "#CCCCCC", //��Ԫ�����ְ�ɫ
"td_bg_out" : "#fff", //��Ԫ��Ӱɫ
"td_bg_over" : "#cceaff", //���������Ԫ��Ӱɫ
"tr_word" : "#666", //����ͷ������ɫ
"tr_bg" : "#fff", //����ͷ��Ӱɫ
"input_border" : "#f6af3a", //input�ؼ��ı߿���ɫ
"input_bg" : "#fff" //input�ؼ��ı�Ӱɫ
};
/*�ŵ��� show ����ΪҪ�� pickMode �ж�
this.draw();
this.bindYear();
this.bindMonth();
*/
//this.changeSelect();
//this.bindData(); 
}

/**//**//**//**//**//**//**//**
* ���������ԣ����԰�����������չ��
*/
Calendar.language = {
"year" : [[""], [""]],
"months" : [["1","2","3","4","5","6","7","8","9","10","11","12"],
["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
],
"weeks" : [["��","һ","��","��","��","��","��"],
["SUN","MON","TUR","WED","THU","FRI","SAT"]
],
"hour" : [["ʱ"], ["H"]],
"minute" : [["��"], ["M"]],
"second" : [["��"], ["S"]],
"clear" : [["���"], ["CLS"]],
"today" : [["����"], ["TODAY"]],
"pickTxt" : [["ȷ��"], ["OK"]],//pickMode ��ȷ���ꡢ��ʱ�ѽ����ɡ�ȷ����
"close" : [["�ر�"], ["CLOSE"]]
};

Calendar.prototype.draw = function() {
calendar = this;

var mvAry = [];
//mvAry[mvAry.length] = ' <form name="calendarForm" style="margin: 0px;">'; //�� <form> ����Ƕ��
mvAry[mvAry.length] = ' <div name="calendarForm" style="margin: 0px; background:#f6af3a ">';
mvAry[mvAry.length] = ' <table width="100%" border="0" cellpadding="0" cellspacing="1" style="font-size:12px;">';
mvAry[mvAry.length] = ' <tr style="">';//�����У���ť | ����ѡ�� | �Ұ�ť
mvAry[mvAry.length] = ' <th align="left" width="1%">';
mvAry[mvAry.length] = '<input style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:20px;height:20px;color:#f6af3a;font-weight:bold" name="prevYear" type="button" id="prevYear" value="&lt;&lt;"></th>';
mvAry[mvAry.length] = '<th align="center" width="98%" nowrap="nowrap"><input style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:16px;height:20px;color:#f6af3a;font-weight:bold';//����input
if(calendar.DateMode > pickMode["month"]){mvAry[mvAry.length] = 'display:none;';}//pickMode ��ȷ����ʱ���ء��¡�
mvAry[mvAry.length] ='" name="prevMonth" type="button" id="prevMonth" value="&lt;" />';
mvAry[mvAry.length] = '<select name="calendarYear" id="calendarYear" style="font-size:12px;width:54px;"></select><select name="calendarMonth" id="calendarMonth" style="font-size:12px;width:42px;';
if(calendar.DateMode > pickMode["month"]){mvAry[mvAry.length] = 'display:none;';}//pickMode ��ȷ����ʱ���ء��¡�
mvAry[mvAry.length] = '"></select>';
mvAry[mvAry.length] = '<input style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:16px;height:20px;color:#f6af3a;font-weight:bold';//����input
if(calendar.DateMode > pickMode["month"]){mvAry[mvAry.length] = 'display:none;';}//pickMode ��ȷ����ʱ���ء��¡�
mvAry[mvAry.length] ='" name="nextMonth" type="button" id="nextMonth" value="&gt;" /></th>';
mvAry[mvAry.length] = '<th align="right" width="1%"><input style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:20px;height:20px;color:#f6af3a;font-weight:bold" name="nextYear" type="button" id="nextYear" value="&gt;&gt;">';//����input
mvAry[mvAry.length] = '</th>';
mvAry[mvAry.length] = ' </tr>';
mvAry[mvAry.length] = ' </table>';
mvAry[mvAry.length] = ' <table id="calendarTable" width="100%" style="font-size:12px;';
if(calendar.DateMode >= pickMode["month"]){mvAry[mvAry.length] = 'display:none;';}//pickMode ��ȷ���ꡢ��ʱ���ء��족
mvAry[mvAry.length] = '" border="0" cellpadding="3" cellspacing="1">';
mvAry[mvAry.length] = ' <tr>';
for(var i = 0; i < 7; i++) {
mvAry[mvAry.length] = ' <th style="font-weight:normal;background-color:' + calendar.colors["tr_bg"] + ';color:' + calendar.colors["tr_word"] + ';">' + Calendar.language["weeks"][this.lang][i] + '</th>';
}
mvAry[mvAry.length] = ' </tr>';
for(var i = 0; i < 6;i++){
mvAry[mvAry.length] = ' <tr align="center">';
for(var j = 0; j < 7; j++) {
if (j == 0){
mvAry[mvAry.length] = ' <td style="cursor:default;color:' + calendar.colors["sun_word"] + ';"></td>';
} else if(j == 6) {
mvAry[mvAry.length] = ' <td style="cursor:default;color:' + calendar.colors["sat_word"] + ';"></td>';
} else {
mvAry[mvAry.length] = ' <td style="cursor:default;"></td>';
}
}
mvAry[mvAry.length] = ' </tr>';
}

//��ӵĴ��룬����ʱ�����
mvAry[mvAry.length] = ' <tr style="';
if(calendar.DateMode >= pickMode["day"]){mvAry[mvAry.length] = 'display:none;';}//pickMode ��ȷ��ʱ�����ء�ʱ�䡱
mvAry[mvAry.length] = '"><td align="center" colspan="7">';
mvAry[mvAry.length] = ' <select name="calendarHour" id="calendarHour" style="font-size:12px;"></select>' + Calendar.language["hour"][this.lang];
mvAry[mvAry.length] = '<span style="';
if(calendar.DateMode >= pickMode["hour"]){mvAry[mvAry.length] = 'display:none;';}//pickMode ��ȷ��Сʱʱ���ء��֡�
mvAry[mvAry.length] = '"><select name="calendarMinute" id="calendarMinute" style="font-size:12px;"></select>' + Calendar.language["minute"][this.lang]+'</span>';
mvAry[mvAry.length] = '<span style="';
if(calendar.DateMode >= pickMode["minute"]){mvAry[mvAry.length] = 'display:none;';}//pickMode ��ȷ��Сʱ����ʱ���ء��롱
mvAry[mvAry.length] = '"><select name="calendarSecond" id="calendarSecond" style="font-size:12px;"></select>'+ Calendar.language["second"][this.lang]+'</span>';
mvAry[mvAry.length] = ' </td></tr>';

mvAry[mvAry.length] = ' </table>';
//mvAry[mvAry.length] = ' </from>';
mvAry[mvAry.length] = ' <div align="center" style="padding:2px 2px 2px 2px;background-color:' + calendar.colors["input_bg"] + ';background:#ffc76c">';
mvAry[mvAry.length] = ' <input name="calendarClear" type="button" id="calendarClear" value="' + Calendar.language["clear"][this.lang] + '" style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:35px;height:20px;font-size:12px;cursor:pointer;"/>';
mvAry[mvAry.length] = ' <input name="calendarToday" type="button" id="calendarToday" value="';
mvAry[mvAry.length] = (calendar.DateMode == pickMode["day"]) ? Calendar.language["today"][this.lang] : Calendar.language["pickTxt"][this.lang];
mvAry[mvAry.length] = '" style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:35px;height:20px;font-size:12px;cursor:pointer"/>';
mvAry[mvAry.length] = ' <input name="calendarMax" type="button" id="calendarMax" value="���ֵ" style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:40px;height:20px;font-size:12px;cursor:pointer" onclick="setMaxDate()"/>';
mvAry[mvAry.length] = ' <input name="calendarClose" type="button" id="calendarClose" value="' + Calendar.language["close"][this.lang] + '" style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:35px;height:20px;font-size:12px;cursor:pointer"/>';
mvAry[mvAry.length] = ' </div>';

mvAry[mvAry.length] = ' </div>';
this.panel.innerHTML = mvAry.join("");

/**********/

var obj = this.getElementById("prevYear");
obj.onclick = function () {calendar.goPrevYear(calendar);};
obj.onblur = function () {calendar.onblur();};

obj = this.getElementById("nextYear");
obj.onclick = function () {calendar.goNextYear(calendar);};
obj.onblur = function () {calendar.onblur();};

obj = this.getElementById("prevMonth");
obj.onclick = function () {calendar.goPrevMonth(calendar);};
obj.onblur = function () {calendar.onblur();};
this.prevMonth= obj;

obj = this.getElementById("nextMonth");
obj.onclick = function () {calendar.goNextMonth(calendar);};
obj.onblur = function () {calendar.onblur();};
this.nextMonth= obj;

obj = this.getElementById("calendarClear");
obj.onclick = function ()
{ calendar.ReturnDate(undefined,""); /*calendar.dateControl.value = "";calendar.hide();*/
  calendar.postEvent();
};
this.calendarClear = obj;

obj = this.getElementById("calendarClose");
obj.onclick = function () {calendar.hide();};
this.calendarClose = obj;

obj = this.getElementById("calendarYear");
obj.onchange = function () {calendar.update(calendar);};
obj.onblur = function () {calendar.onblur();};
this.calendarYear = obj;

obj = this.getElementById("calendarMonth");
with(obj)
{
onchange = function () {calendar.update(calendar);};
onblur = function () {calendar.onblur();};
}this.calendarMonth = obj;

obj = this.getElementById("calendarHour");
obj.onchange = function () {calendar.hour = this.options[this.selectedIndex].value;};
obj.onblur = function () {calendar.onblur();};
this.calendarHour = obj;

obj = this.getElementById("calendarMinute");
obj.onchange = function () {calendar.minute = this.options[this.selectedIndex].value;};
obj.onblur = function () {calendar.onblur();};
this.calendarMinute = obj;

obj = this.getElementById("calendarSecond");
obj.onchange = function () {calendar.second = this.options[this.selectedIndex].value;};
obj.onblur = function () {calendar.onblur();};
this.calendarSecond = obj;

obj = this.getElementById("calendarToday");
obj.onclick = function () {
var today = (calendar.DateMode != pickMode["day"]) ?
new Date(calendar.year,calendar.month,calendar.day,calendar.hour,calendar.minute,calendar.second)
: new Date();
calendar.ReturnDate(today,today.format(calendar.dateFormatStyle));
calendar.postEvent();
};
this.calendarToday = obj;
};

function setMaxDate(){
	var maxDate = this.endDate;
	if(this.endDate==undefined){
		maxDate = new Date(9999,11,31,23,59,59);
		calendar.ReturnMaxDate(maxDate,maxDate.format(calendar.dateFormatStyle));
	}
	else
		calendar.ReturnDate(maxDate,maxDate.format(calendar.dateFormatStyle));
	calendar.postEvent();
}

//��������������
Calendar.prototype.bindYear = function() {
var cy = this.calendarYear;
cy.length = 0;
for (var i = this.beginYear; i <= this.endYear; i++){
cy.options[cy.length] = new Option(i + Calendar.language["year"][this.lang], i);
}
};

//�·������������
Calendar.prototype.bindMonth = function() {
var cm = this.calendarMonth;
cm.length = 0;
for (var i = 0; i < 12; i++){
cm.options[cm.length] = new Option(Calendar.language["months"][this.lang][i], i);
}
};

//Сʱ�����������
Calendar.prototype.bindHour = function() {
var ch = this.calendarHour;
if(ch.length > 0){return;}// ����Ҫ���°󶨣��������
//ch.length = 0;
var h;
for (var i = 0; i < 24; i++){
h = ("00" + i +"").substr(("" + i).length);
ch.options[ch.length] = new Option(h, h);
}
};

//���������������
Calendar.prototype.bindMinute = function() {
var cM = this.calendarMinute;
if(cM.length > 0){return;}//����Ҫ���°󶨣��������
//cM.length = 0;
var M;
for (var i = 0; i < 60; i++){
M = ("00" + i +"").substr(("" + i).length);
cM.options[cM.length] = new Option(M, M);
}
};

//���������������
Calendar.prototype.bindSecond = function() {
var cs = this.calendarSecond;
if(cs.length > 0){return;}//����Ҫ���°󶨣��������
//cs.length = 0;
var s;
for (var i = 0; i < 60; i++){
s = ("00" + i +"").substr(("" + i).length);
cs.options[cs.length] = new Option(s, s);
}
};
//��ǰһ��
Calendar.prototype.goPrevYear = function(e){
	if (this.year == this.beginYear){return;}
	this.year--;
	this.date = new Date(this.year, this.month, 1);
	this.changeSelect();
	this.bindData();
};
//��ǰһ��
Calendar.prototype.goPrevMonth = function(e){
	if (this.year == this.beginYear && this.month == 0){return;}
	this.month--;
	if (this.month == -1) {
		this.year--;
		this.month = 11;
	}
	this.date = new Date(this.year, this.month, 1);
	this.changeSelect();
	this.bindData();
};

//���һ��
Calendar.prototype.goNextMonth = function(e){
	if (this.year == this.endYear && this.month == 11){return;}
	this.month++;
	if (this.month == 12) {
		this.year++;
		this.month = 0;
	}
	this.date = new Date(this.year, this.month, 1);
	this.changeSelect();
	this.bindData();
};
//���һ��
Calendar.prototype.goNextYear = function(e){
	if (this.year == this.endYear){return;}
	this.year++;
	this.date = new Date(this.year, this.month, 1);
	this.changeSelect();
	this.bindData();
};


//�ı�SELECTѡ��״̬
Calendar.prototype.changeSelect = function() {
	var cy = this.calendarYear;
	var cm = this.calendarMonth;
	var ch = this.calendarHour;
	var cM = this.calendarMinute;
	var cs = this.calendarSecond;
	//�����������
	if(this.date.getFullYear()<this.beginYear || (this.date.getFullYear()==this.beginYear && this.date.getMonth()<this.beginDate.getMonth())){
		cy[0].selected = true;
		cm[this.beginDate.getMonth()].selected =true;
		this.date = new Date(this.beginYear, this.beginDate.getMonth(), 1);
	}
	else if(this.date.getFullYear()>this.endYear || (this.date.getFullYear()==this.endYear && this.date.getMonth()>this.endDate.getMonth())){
		cy[cy.length-1].selected = true;
		cm[this.endDate.getMonth()].selected =true;
		this.date = new Date(this.endYear, this.endDate.getMonth(), 1);
	}
	else{
		cy[this.date.getFullYear()-this.beginYear].selected = true;
		cm[this.date.getMonth()].selected =true;
	}
	//��ʼ��ʱ���ֵ
	ch[this.hour].selected =true;
	cM[this.minute].selected =true;
	cs[this.second].selected =true;
};

//�����ꡢ��
Calendar.prototype.update = function (e){
this.year = e.calendarYear.options[e.calendarYear.selectedIndex].value;
this.month = e.calendarMonth.options[e.calendarMonth.selectedIndex].value;
this.date = new Date(this.year, this.month, 1);
//this.changeSelect();
this.bindData();
};
Calendar.prototype.isValidDate = function(datevalue){
	if(this.beginDate && datevalue<this.beginDate)
		return false;
	if(this.endDate && datevalue>this.endDate)
		return false;
	return true;
};
Calendar.prototype.postEvent = function() {};
Calendar.prototype.dayValue = function() {};
// �����ݵ�����ͼ
Calendar.prototype.bindData = function () {
	var calendar = this;
	if(calendar.DateMode >= pickMode["month"]){return;}
	// var dateArray = this.getMonthViewArray(this.date.getYear(),
	// this.date.getMonth());
	// �޸� ��Firefox ����ݴ���
	var dateArray = this.getMonthViewArray(this.date.getFullYear(), this.date.getMonth());
	var tds = this.getElementById("calendarTable").getElementsByTagName("td");
	for(var i = 0; i < tds.length; i++) {
		tds[i].style.backgroundColor = calendar.colors["td_bg_out"];
		tds[i].onclick = function () {return;};
		tds[i].onmouseover = function () {return;};
		tds[i].onmouseout = function () {return;};
		if (i > dateArray.length - 1) break;
		tds[i].innerHTML = dateArray[i];
		if(calendar.isValidDate(new Date(calendar.date.getFullYear(),calendar.date.getMonth(),dateArray[i]))==false){
			tds[i].style.textDecoration = "line-through";
			tds[i].style.color="#cccccc";
		}
		else{
			tds[i].style.textDecoration = "none";
			tds[i].style.color="#000000";
		}
		if (dateArray[i] != "&nbsp;"){
			tds[i].bgColorTxt = "td_bg_out"; // ���汳��ɫ��class
			var cur = new Date();
			tds[i].isToday = false;
			if (cur.getFullYear() == calendar.date.getFullYear() && cur.getMonth() == calendar.date.getMonth() && cur.getDate() == dateArray[i]) {
				// �ǽ���ĵ�Ԫ��
				tds[i].style.backgroundColor = calendar.colors["cur_bg"];
				tds[i].bgColorTxt = "cur_bg";
				tds[i].isToday = true;
			}
			if(calendar.dateControl != null ){
				cur = calendar.dateControl.value.toDate(calendar.dateFormatStyle);
				if (cur.getFullYear() == calendar.date.getFullYear() && cur.getMonth() == calendar.date.getMonth()&& cur.getDate() == dateArray[i]) {
					// ���ѱ�ѡ�еĵ�Ԫ��
					calendar.selectedDayTD = tds[i];
					tds[i].style.backgroundColor = calendar.colors["sel_bg"];
					tds[i].bgColorTxt = "sel_bg";
				}
			}
			tds[i].onclick = function () {
				if(calendar.DateMode == pickMode["day"]){ // ��ѡ������ʱ��������Ӽ�����ֵ
					var dReturnDate = new Date(calendar.date.getFullYear(),calendar.date.getMonth(),this.innerHTML);
					calendar.ReturnDate(dReturnDate,dReturnDate.format(calendar.dateFormatStyle));
				}
				else{
					if(calendar.selectedDayTD != null){ // �����ѡ�еı���ɫ
						calendar.selectedDayTD.style.backgroundColor =(calendar.selectedDayTD.isToday)? calendar.colors["cur_bg"] : calendar.colors["td_bg_out"];
					}
					this.style.backgroundColor = calendar.colors["sel_bg"];
					calendar.day = this.innerHTML;
					calendar.selectedDayTD = this; // ��¼��ѡ�е�����
				}
				if(typeof calendar.postEvent == "function") calendar.postEvent();
			};
			if(calendar.isValidDate(new Date(calendar.date.getFullYear(),calendar.date.getMonth(),this.innerHTML))){
				tds[i].style.cursor ="pointer"; // �������ָ״
			}
			else{
				tds[i].style.cursor ="defualt";
			}
			tds[i].onmouseover = function () {
				if(calendar.isValidDate(new Date(calendar.date.getFullYear(),calendar.date.getMonth(),this.innerHTML)))
					this.style.backgroundColor = calendar.colors["td_bg_over"];
			};
			tds[i].onmouseout = function () {
				if(calendar.selectedDayTD != this) {
					if(calendar.isValidDate(new Date(calendar.date.getFullYear(),calendar.date.getMonth(),this.innerHTML)))
						this.style.backgroundColor = calendar.colors[this.bgColorTxt];
				}
			};
			tds[i].onblur = function () {calendar.onblur();};
		}
	}
};

//�����ꡢ�µõ�����ͼ����(������ʽ)
Calendar.prototype.getMonthViewArray = function (y, m) {
var mvArray = [];
var dayOfFirstDay = new Date(y, m, 1).getDay();
var daysOfMonth = new Date(y, m + 1, 0).getDate();
for (var i = 0; i < 42; i++) {
mvArray[i] = "&nbsp;";
}
for (var i = 0; i < daysOfMonth; i++){
mvArray[i + dayOfFirstDay] = i + 1;
}
return mvArray;
};

//��չ document.getElementById(id) ������������� from meizz tree source
Calendar.prototype.getElementById = function(id){
if (typeof(id) != "string" || id == "") return null;
if (document.getElementById) return document.getElementById(id);
if (document.all) return document.all(id);
try {return eval(id);} catch(e){ return null;}
};

//��չ object.getElementsByTagName(tagName)
Calendar.prototype.getElementsByTagName = function(object, tagName){
if (document.getElementsByTagName) return document.getElementsByTagName(tagName);
if (document.all) return document.all.tags(tagName);
};

//ȡ��HTML�ؼ�����λ��
Calendar.prototype.getAbsPoint = function (e){
	var x = e.clientLeft;
	var y = e.clientTop;
	//alert(e.offsetParent.outerHTML+x+','+y);
	var iScrollTop = 0;
	var iScrollLeft = 0;
	while(e = e.offsetParent){
		x += e.offsetLeft;
		y += e.offsetTop;
		iScrollTop = e.scrollTop;
		iScrollLeft = e.scrollLeft;
	}
	//alert("iScrollTop="+ iScrollTop);
	return {"x": x-iScrollLeft, "y": y-iScrollTop};
};

//��ʾ����
Calendar.prototype.show = function (dateObj, popControl) {
	if (dateObj == null){
		//throw new Error("arguments[0] is necessary");
	}
	this.dateControl = dateObj;
	var now = new Date();
	this.date = (dateObj.value.length > 0) ? new Date(dateObj.value.toDate(this.dateFormatStyle)) : now.format(this.dateFormatStyle).toDate(this.dateFormatStyle) ;// ��Ϊ�������dateFormatStyle��ʼ������

	if(this.panel.innerHTML==""||cal.dateFormatStyleOld != cal.dateFormatStyle){//2�ѹ�������ڴ˴��� ����ʾ����ʽ�ı䣬�����³�ʼ��
	
		this.draw();
	}
	this.draw();
	this.bindYear();
	this.bindMonth();
	this.bindHour();
	this.bindMinute();
	this.bindSecond();
	
	this.year = this.date.getFullYear();
	this.month = this.date.getMonth();
	this.day = this.date.getDate();
	this.hour = this.date.getHours();
	this.minute = this.date.getMinutes();
	this.second = this.date.getSeconds();
	this.changeSelect();
	this.bindData();

	if (popControl == null){
		popControl = dateObj;
	}
	var xy = this.getAbsPoint(popControl);
	//this.panel.style.left = xy.x + "px";
	//this.panel.style.top = (xy.y + dateObj.offsetHeight) + "px";

	
	if(document.getElementById("myiframe0_cells")){
		this.panel.style.left = (xy.x + leftX-document.getElementById("myiframe0_cells").scrollLeft)+ "px"; // �޸� �� �����Զ���ƫ����
	}
	else{
		this.panel.style.left = (xy.x + leftX)+ "px"; // �޸� �� �����Զ���ƫ����
	}
	//alert("document.dateObj.scrollTop=" + (document.body.scrollHeight - document.body.clientHeight));
	//alert(document.body.outerHTML);
	//alert(DZ);
	if(document.getElementById('div_my0')){
		this.panel.style.top = (xy.y + topY + dateObj.offsetHeight-document.getElementById('div_my0').scrollTop) + "px";
	}
	else if(document.getElementById("myiframe0_cells")){
		this.panel.style.top = (xy.y + dateObj.offsetHeight-document.getElementById("myiframe0_cells").scrollTop) + "px";
	}
	else{
		this.panel.style.top = (xy.y + topY + dateObj.offsetHeight) + "px";
	}

	// �� visibility ��Ϊ display�������ʧȥ������¼� //this.setDisplayStyle("select", "hidden");
	//this.panel.style.visibility = "visible";
	//this.container.style.visibility = "visible";
	this.panel.style.display = "";
	this.container.style.display = "";

	if( !this.dateControl.isTransEvent)
	{
		this.dateControl.isTransEvent = true;
		/* ��д�ڷ���ֵ��ʱ�� ReturnDate �����У�ȥ����֤�¼��ĺ���
		this.dateControl.changeEvent = this.dateControl.onchange;//�� onchange ת���������������ⴥ����֤�¼�
		this.dateControl.onchange = function()
		{if(typeof(this.changeEvent) =='function'){this.changeEvent();}}*/
		if(this.dateControl.onblur != null){
		this.dateControl.blurEvent = this.dateControl.onblur;}//�������ı���� onblur ��ʹ��ԭ�����¼���������
		this.dateControl.onblur = function(){
			calendar.onblur();if(typeof(this.blurEvent) =='function'){this.blurEvent();}
		};
	}

	this.container.onmouseover = function(){isFocus=true;};
	this.container.onmouseout = function(){isFocus=false;};
};

//��������
Calendar.prototype.hide = function() {
//this.setDisplayStyle("select", "visible");
//this.panel.style.visibility = "hidden";
//this.container.style.visibility = "hidden";
this.panel.style.display = "none";
this.container.style.display = "none";
isFocus=false;
};

//����ת��ʱ�������� �� �ɺ���� 2006-06-25 ���
Calendar.prototype.onblur = function() {
if(!isFocus){this.hide();}
};

// ȷ�����������ڵ��� body ��󣬷��� FireFox �в��ܳ��������Ϸ�
function InitContainerPanel() //��ʼ������
{
var str = '<div id="calendarPanel" style="position: absolute;display: none;z-index:9999; background-color: #FFFFFF;border: 3px solid #ff8800;width:175px;font-size:12px;"></div>';
if(document.all)
{
str += '<iframe style="position:absolute;z-index:2000;width:expression(this.previousSibling.offsetWidth);';
str += 'height:expression(this.previousSibling.offsetHeight);';
str += 'left:expression(this.previousSibling.offsetLeft);top:expression(this.previousSibling.offsetTop);';
str += 'display:expression(this.previousSibling.style.display);" scrolling="no" frameborder="no"></iframe>';
}
var div = document.createElement("div");
div.innerHTML = str;
div.id = "ContainerPanel";
div.style.display ="none";
document.body.appendChild(div);
}//����calendar.show(dateControl, popControl);