//*************************************** Ajax *************************
//create xmlHttp Object ����als6.0����XmlHttp
function getXmlHttpObject() {
	var xmlHttp=null;
	try{
		  // Firefox, Opera 8.0+, Safari
		  xmlHttp=new XMLHttpRequest();
	  }catch (e) {
		  // Internet Explorer
		  try{
		    xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
		  }catch (e){
		    xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
		  }
  	}
	return xmlHttp;
}

function getquerystring(formname) {
    var form = document.forms[formname];	var qstr = "";    function GetElemValue(name, value) {
    	/*        qstr += (qstr.length > 0 ? "&" : "")            + escape(name).replace(/\+/g, "%2B") + "="            + escape(value ? value : "").replace(/\+/g, "%2B");			//+ escape(value ? value : "").replace(/\n/g, "%0D");
			*/
    	qstr += (qstr.length > 0 ? "&" : "")
    		+ (name) + "=" + escape(escape(value ? value : ""));
    }
    function GetHiddenElemValue(name, value) {
    	//�������id��Ҫȡԭֵ,��˽�hidden����Ϊ������
    	if(name=="CompClientID" || name=="PageClientID" || name=="ToDestroyPageClientID"){
    		qstr += (qstr.length > 0 ? "&" : "")
        		+ (elemName) + "=" + (element.value ? element.value : "");
    	}else{
    		GetElemValue(name, value);
    	}
    }
	var elemArray = form.elements;    for (var i = 0; i < elemArray.length; i++) {        var element = elemArray[i];        var elemType = element.type.toUpperCase();        var elemName = element.name;        if (elemName) {            if (elemType == "TEXT"                    || elemType == "TEXTAREA"                    || elemType == "PASSWORD"					|| elemType == "BUTTON"					|| elemType == "RESET"					|| elemType == "SUBMIT"					|| elemType == "FILE"					|| elemType == "IMAGE")                GetElemValue(elemName, element.value);
            else if (elemType == "HIDDEN" )			//�������id��Ҫȡԭֵ,��˽�hidden����Ϊ������
            	GetHiddenElemValue(elemName, element.value);            else if (elemType == "CHECKBOX" && element.checked)                GetElemValue(elemName,                     element.value ? element.value : "On");            else if (elemType == "RADIO" && element.checked)                GetElemValue(elemName, element.value);            else if (elemType.indexOf("SELECT") != -1)                for (var j = 0; j < element.options.length; j++) {                    var option = element.options[j];                    if (option.selected)                        GetElemValue(elemName,                            option.value ? option.value : option.text);                }        }    }    return qstr;}