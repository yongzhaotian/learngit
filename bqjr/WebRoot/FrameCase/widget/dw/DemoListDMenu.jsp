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
		options[0] = new Option("请选择区县","");
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
		options[0] = new Option("请选择城市","");
		options[0].selected = true;
		//alert(options[0]);
		for(var i=0;i<aCode.length;i+=2){
			var curOption = new Option(aCode[i+1],aCode[i]);
			if(aCode[i]==cityValue)curOption.selected = true;
			options[options.length] = curOption;
		}
		setArea(cityValue,areaValue,rowindex);
	}
	//省份控件onchange事件
	function eventCity(){
		var provValue = getItemValue(0,getRow(0),"ATTR1",getRow(0));
		setCity(provValue);
	}
	//城市控件onchange事件
	function eventArea(){
		var cityValue = getItemValue(0,getRow(0),"ATTR2",getRow(0));
		setArea(cityValue);
	}
	//在加载完表格后调用
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
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0";//编辑模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","新增","新增","as_add(0)","","","",""},
		{"true","","Button","保存","保存","as_save(0)","","","",""},
		{"true","","Button","删除","删除","if(confirm('确实要删除吗?'))as_delete(0)","","","",""}
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@
 include file="/Frame/resources/include/include_end.jspf"%>
