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
    var form = document.forms[formname];
    	/*
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
	var elemArray = form.elements;
            else if (elemType == "HIDDEN" )			//�������id��Ҫȡԭֵ,��˽�hidden����Ϊ������
            	GetHiddenElemValue(elemName, element.value);