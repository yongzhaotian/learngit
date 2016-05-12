//check CorpID
function CheckORG(CorpID){
	var financecode = new Array();
	if(CorpID=="00000000-0")	return false;
	for(var i=0;i<CorpID.length;i++){
		financecode[i]= CorpID.charCodeAt(i);
	}
    var w_i = new Array(8);
    var c_i = new Array(8);
    s = 0,c = 0;
    w_i[0] = 3;
    w_i[1] = 7;
    w_i[2] = 9;
    w_i[3] = 10;
    w_i[4] = 5;
    w_i[5] = 8;
    w_i[6] = 4;
    w_i[7] = 2;
    if(financecode[8] != 45)	return false;
    for(i = 0; i < 10; i++){
        c = financecode[i];
        if(c <= 122 && c >= 97)
            return false;
    }

    fir_value = financecode[0];
    sec_value = financecode[1];
    if(fir_value >= 65 && fir_value <= 90)
        c_i[0] = (fir_value + 32) - 87;
    else if(fir_value >= 48 && fir_value <= 57)
        c_i[0] = fir_value - 48;
    else
        return false;
    s += w_i[0] * c_i[0];
    if(sec_value >= 65 && sec_value <= 90)
        c_i[1] = (sec_value - 65) + 10;
    else if(sec_value >= 48 && sec_value <= 57)
        c_i[1] = sec_value - 48;
    else
        return false;
    s += w_i[1] * c_i[1];
    for(var j = 2; j < 8; j++){
        if(financecode[j] < 48 || financecode[j] > 57)
            return false;
        c_i[j] = financecode[j] - 48;
        s += w_i[j] * c_i[j];
    }

    c = 11 - s % 11;
    return financecode[9] == 88 && c == 10 || c == 11 && financecode[9] == 48 || c == financecode[9] - 48;
}

//����У��
function CheckDate(sDate){
	return checkDate(sDate);
}
function checkDate(sDate){
	var checkedDate = sDate;
	var year,month,day;	
	//����Ϊ�� ���Ȳ�����8��14 ���ش���
	var maxDay = new Array(0,31,29,31,30,31,30,31,31,30,31,30,31);
	//if(checkedDate == null ) return false;
	checkedDate = checkedDate.trim();
	if (checkedDate.length != 8 && checkedDate.length != 14) {
		return false;
	}
	year = checkedDate.substring(0, 4).trim();
	month = checkedDate.substring(4, 6).trim();
	day = checkedDate.substring(6, 8).trim();
	
	// ������1��4λ ��С��1900 ���ش���
	if (year < 1900) {
		return false;
	}
	// ������5��6λ ����1��12����֮�� ���ش���
	if (month < 1 || month > 12) {
		return false;
	}
	// ������7��8λ ����1��maxDay[month]����֮�� ���ش���
	if (day > maxDay[month] || day == 0) {
		return false;
	}
	// ������2�·����ڴ���29
	if (day == 29 && month == 2 && (year % 4 != 0 || year % 100 == 0) && (year % 4 != 0 || year % 400 != 0)) 
	{
		return false;
	}
	if (checkedDate.length == 14) {
		// ���ڳ���Ϊ14λ
		var hour = checkedDate.substring(8, 10);
		var miniute = checkedDate.substring(10, 12);
		var second = checkedDate.substring(12, 14);
		
		// ������9��10λ Сʱ��0��23����֮�� ���ش���
		if (hour > 23 || hour < 0) {
			return false;
		}
		// ������11��12λ ������0��59����֮�� ���ش���
		if (miniute > 59 || miniute < 0) {
			return false;
		}
		// ������13��14λ ����0��59����֮�� ���ش���
		if (second > 59 || second < 0) {
			return false;
		}
	}
	return true;
}

function CheckPersonId(personId){
	return checkPersonId(personId);
}

function checkPersonId(personId){
	var strJiaoYan = new Array("1","0","X","9","8","7","6","5","4","3","2");
	var intQuan = new Array(7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2,1);
	var intTemp = 0;
	for (var i = 0; i < personId.length - 1; i++){
			intTemp += personId.substring(i, i + 1) * intQuan[i];
    }
	intTemp %= 11;
	return personId.substring(personId.length - 1)==strJiaoYan[intTemp];
}

//���֤У��
function CheckLicense(ID){    	
	var checkedValue = ID;		
	checkedValue = checkedValue.trim();
	if (checkedValue.length != 15 && checkedValue.length != 18)
		return false;
	var dateValue;
	if (checkedValue.length == 15)
		dateValue = "19" + checkedValue.substring(6, 12);		
	else
		dateValue = checkedValue.substring(6, 14);
	if (!checkDate(dateValue))
		return false;
	if (checkedValue.length == 18)		    
		return checkPersonId(checkedValue);
	return true;   
}

//������ŵ���ȷ�Լ������
function CheckLoanCardID(loanCardCode){
	var financecode = new Array();
	for(var i=0;i<loanCardCode.length;i++){
	 	financecode[i]= loanCardCode.charCodeAt(i);
	}
	var weightValue = new Array(14);
	var checkValue = new Array(14);
	totalValue = 0;
	c = 0;
	weightValue[0] = 1;
	weightValue[1] = 3;
	weightValue[2] = 5;
	weightValue[3] = 7;
	weightValue[4] = 11;
	weightValue[5] = 2;
	weightValue[6] = 13;
	weightValue[7] = 1;
	weightValue[8] = 1;
	weightValue[9] = 17;
	weightValue[10] = 19;
	weightValue[11] = 97;
	weightValue[12] = 23;
	weightValue[13] = 29;
	for(var j = 0; j < 14; j++){
		if (financecode[j] >= 65 && financecode[j] <= 90){
			checkValue[j] = (financecode[j] - 65) + 10;
		} else if (financecode[j] >= 48 && financecode[j] <= 57){
			checkValue[j] = financecode[j] - 48;
		} else {
			return false;
		}
		totalValue += weightValue[j] * checkValue[j];
	}
	c = 1 + totalValue % 97;
	val = (financecode[14] - 48) * 10 + (financecode[15] - 48);
	return val == c;
}

//У����������
function CheckPostalcode(Postalcode){
	var str = Postalcode;
	str = str.trim();	
	if (str.length > 0){
		if (str.length != 6 || str == "000000"){ //����Ҫ���������벻����λȫΪ0.
			return false;
		}

		var Letters = "1234567890";
		for (var i = 0;i < str.length;i++){
			var CheckChar = str.charAt(i);
			if (Letters.indexOf(CheckChar) == -1){
				return false;
			}
		}
	}
	return true;
}

//У��绰����
function CheckPhoneCode(PhoneCode){
	var str = PhoneCode;
	str = str.trim();
	if (str.length > 0) {
		var patrn=/^([0-9]{1,3}-)?([0-9]{2,4}-)?[0-9]{7,11}(-[0-9]{1,5})?$/;//ƥ��绰���뼰�ֻ�����
		if (patrn.exec(str)) {
			return true;
		}
	}
	return false;
}

//У������ʼ���ַ
function CheckEMail(EMail){
	var Count = 0;
	var str = EMail;
	str = str.trim();
	if (str.length > 0) {
		var Letters = "@";
		//����ַ������Ƿ����"@"�ַ�
		if (str.indexOf(Letters) == -1) {
			return false;
		}
		//����ַ������Ƿ���ڶ��"@"�ַ�
		for (var i = 0;i < str.length;i++) {
			var CheckChar = str.charAt(i);
			if (Letters.indexOf(CheckChar) >= 0) {
				Count = Count + 1;
			}
		}
		if(Count > 1){
			return false;
		}
	}
	return true;
}

function CheckTypeScript(sCheckWord,sCheckType){
	sCheckWord = sCheckWord.trim();
	if(sCheckType=="2"){
		var patrn=/^[0-9,.]{1,20}$/;
		if (patrn.exec(sCheckWord)) return true;		
	 }
	return false;
}

// У���ֻ����� added by tbzeng ��Ǫ���� ϵͳ
function checkMobile(field) {
	
	var sPhoneCode = field.value.replace(/[A-Za-z]/g, "");
	field.value = sPhoneCode;
	var patrn = /^(13[0-9]|15[0|2|5|3|6|7|8|9]|18[0|5|6|7|8|9]|170)\d{8}$/;
	if (!patrn.exec(sPhoneCode)) {
		alert("�ֻ�������������������ȷ�ϣ�");
		return;
	}
}

// ���绰���������Ƿ���ȷ  added by tbzeng ��Ǫ���� ϵͳ
function checkPhone(field) {

	var sTelCode = field.value.replace(/[A-Za-z]/g, "");
	field.value = sTelCode;
	if (!CheckPhoneCode(sTelCode)) {
		alert("�绰������������");
		return;
	}
}

//У������0-150
function checkAge(field) {

	var sAge = field.value.replace(/[A-Za-z]/g, "");
	field.value = sAge;
	var iAge = parseInt(sAge);
	if (iAge<=0 || iAge>=120) {
		alert("��������ֵӦ����0-120֮�䣬��ȷ��");
		return;
	}
	
}

//У������ʼ���������ʾ
function checkMyEmail(field) {

	if (!CheckEMail(field.value)) {
		alert("������ĵ����ʼ�������ȷ��");
		return;
	}
	
}


//���֤������У��
function isCardNo(obj)  
{
   // ���֤����Ϊ15λ����18λ��15λʱȫΪ���֣�18λǰ17λΪ���֣����һλ��У��λ������Ϊ���ֻ��ַ�X   
   var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;  
   if(!reg.test(obj.value))  
   {  
      alert("���֤���벻�Ϸ�!");
      obj.value = "";
      return  false;  
   }  
	return true;
}