<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
 <script>
 var cityArray = new Array();
 var areaArray = new Array();
 </script>
<%
	String sTempletNo = "TestCustomerInfoD";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""}
	};
	sButtonPosition = "south";
%><%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function setArea(cityValue,areaValue){
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
		var oArea = document.getElementById("ATTR3");
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
	function setCity(provValue,cityValue,areaValue){
		//alert(provValue+ ","+cityValue+","+areaValue);
		var aCode = [];
		if(cityArray[provValue]){
			aCode = cityArray[provValue];
		}
		else{
			var sReturn = RunJavaMethod("com.amarsoft.awe.dw.ui.control.address.CityFetcher","getCities","prov="+provValue);
			if(sReturn!=""){
				aCode = sReturn.split(",");
			}
		}
		var oCity = document.getElementById("ATTR2");
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
		setArea(cityValue,areaValue);
	}
	function returnList(){
		var sUrl = "/FrameCase/widget/dw/DemoListSimple.jsp";
		OpenPage(sUrl,'_self','');
	}
	//初始化联动菜单值
	setCity(getItemValue(0,0,'ATTR1'),getItemValue(0,0,'ATTR2'),getItemValue(0,0,'ATTR3'));
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
