<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 <script>
 	var cityArray = new Array();
 	var areaArray = new Array();
 	function setArea(cityValue,areaValue,rowindex){
 	 	//alert(areaValue+"-"+cityValue);
 	 	if(rowindex==undefined)rowindex=getRow(0);
		var aCode = [];
		if(areaArray[cityValue]){
			aCode = areaArray[cityValue];
		}
		else{
			var sReturn = RunJavaMethod("com.amarsoft.awe.dw.ui.control.address.AreaFetcher","getAreas","city="+cityValue);
			if(sReturn!=""){
				aCode = sReturn.split(",");
			}
		}
		//alert(aCode);
		var oArea = getObj(0,rowindex,"ATTR3");//document.getElementById("ATTR3");
		var options = oArea.options;
		options.length = 1;
		options[0] = new Option("��ѡ������","");
		options[0].selected = true;
		for(var i=0;i<aCode.length;i+=2){
			var curOption = new Option(aCode[i+1],aCode[i]);
			if(aCode[i]==areaValue)curOption.selected = true;
				options[options.length] = curOption;
		}
	}
	function setCity(provValue,cityValue,areaValue,rowindex){
		//alert(provValue+ ","+cityValue+","+areaValue);
		if(rowindex==undefined)rowindex=getRow(0);
		var aCode = [];
		if(cityArray[provValue]){
			aCode = cityArray[provValue];
		}
		else{
			var sReturn = RunJavaMethod("com.amarsoft.awe.dw.ui.control.address.CityFetcher","getCities","prov="+provValue);
			//alert("sReturn="+ sReturn);
			if(sReturn!=""){
				aCode = sReturn.split(",");
			}
		}
		var oCity = getObj(0,rowindex,"ATTR2");
		var options = oCity.options;
		options.length = 1;
		options[0] = new Option("��ѡ�����","");
		options[0].selected = true;
		//alert(options[0]);
		for(var i=0;i<aCode.length;i+=2){
			var curOption = new Option(aCode[i+1],aCode[i]);
			if(aCode[i]==cityValue)curOption.selected = true;
			options[options.length] = curOption;
		}
		setArea(cityValue,areaValue,rowindex);
	}
	//ʡ�ݿؼ�onchange�¼�
	function eventCity(){
		var provValue = getItemValue(0,getRow(0),"ATTR1",getRow(0));
		setCity(provValue);
	}
	//���пؼ�onchange�¼�
	function eventArea(){
		var cityValue = getItemValue(0,getRow(0),"ATTR2",getRow(0));
		setArea(cityValue);
	}
	//�ڼ�����������
	function afterSearch(){
		for(var i=0;i<getRowCount(0);i++){
			var sProv = getItemValue(0,i,'ATTR1');
			var sCity = getItemValue(0,i,'ATTR2');
			var sArea = getItemValue(0,i,'ATTR3');
			if(sProv && sProv!="")
				setCity(sProv,sCity,sArea,i);
		}
	}
 </script>
<%	
	ASObjectModel doTemp = new ASObjectModel("DemoLinkageTest");
	doTemp.setReadOnly("SERIALNO",true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "0";//�༭ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","����","����","as_add(0)","","","",""},
		{"true","","Button","����","����","as_save(0)","","","",""},
		{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0)","","","",""}
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@
 include file="/Frame/resources/include/include_end.jspf"%>
