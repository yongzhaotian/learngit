<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_composelist.jspf"%>
 <script>
 function add(){
	 var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp";
	 OpenPage(sUrl,'_self','');
 }
 function edit(){
	 var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp";
	 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
 }
 </script>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectModel doTemp2 = new ASObjectModel("SelectValidate");
	//doTemp2.setParamstr("getItemValue(0,getRow(0),'SERIALNO')");
	doTemp.setSubDataObject(doTemp2);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(-1);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script>
var valueArray = new Array();
for(var ii=0;ii<DZ[0][2].length;ii++){
	//var sValue = getItemValue(0,ii,'SERIALNO');
	//valueArray[ii] = sValue;
	var aValue = ["Double","Regular","Integer","Class","Date","Double","Regular","Integer","Class","Date"];
	valueArray[ii] = (aValue[ii]?aValue[ii]:"1");
}
as_sublist(valueArray);
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
