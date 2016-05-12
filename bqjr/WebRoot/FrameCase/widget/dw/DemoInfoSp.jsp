<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "TestCustomerInfo";//模板号
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	String sButtons[][] = {
		{"true","All","Button","保存","保存所有修改","as_save(0)","","","",""},
		{"true","All","Button","getRowCount","getRowCount","alert(getRowCount(0))","","","",""},
		{"true","All","Button","隐藏字段ISINUSE","hide ISINUSE","hideItem(0,'ISINUSE')","","","",""},
		{"true","All","Button","显示字段ISINUSE","show ISINUSE","showItem(0,'ISINUSE')","","","",""},
		{"true","All","Button","返回","返回列表","returnList()","","","",""},
		{"true","All","Button","锁定","lockall","lockall()","","","",""},
		{"true","All","Button","解除锁定","unlockall","unlockall()","","","",""},
		{"true","All","Button","设置TELEPHONE*","require","require()","","","",""},
		{"true","All","Button","取消TELEPHONE*","unrequire","unrequire()","","","",""},
		{"true","All","Button","获得所有值","getItemValue","getAllItemValue()","","","",""},
		{"true","All","Button","获得TELEPHONE标题","getTitlex","alert(getItemHeader(0,0,'telephone'))","","","",""},
		{"true","All","Button","设置TELEPHONE标题","setTitlex","setTitlex()","","","",""},
		{"true","All","Button","获得TELEPHONE unit","getUnit","alert(getItemUnit(0,0,'telephone'))","","","",""},
		{"true","All","Button","设置TELEPHON unit","setUnit","setItemUnit(0,0,'TELEPHONE',prompt('输入Unit','Unit'));","","","",""}
	};
	sButtonPosition = "south";
%><%@
include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function returnList(){
		 var sUrl = "/FrameCase/widget/dw/DemoListSimple.jsp";
		 OpenPage(sUrl,'_self','');
	}
	function unlockall(){
		var fields = "SerialNO,CustomerName,Telephone,ISINUSE,ADDRESS";
		var aFields = fields.split(",");
		//alert(aFields.length);
		var sResult = "";
		for(var i=0;i<aFields.length;i++){
			setItemDisabled(0,0,aFields[i],false);
		}
	}
	function lockall(){
		var fields = "SerialNO,CustomerName,Telephone,ISINUSE,ADDRESS";
		var aFields = fields.split(",");
		//alert(aFields.length);
		var sResult = "";
		for(var i=0;i<aFields.length;i++){
			setItemDisabled(0,0,aFields[i],true);
		}
	}
	function getAllItemValue(){
		var fields = "SerialNO,CustomerName,Telephone,ISINUSE,ADDRESS";
		var aFields = fields.split(",");
		//alert(aFields.length);
		var sResult = "";
		for(var i=0;i<aFields.length;i++){
			sResult += aFields[i] + ".value = " + getItemValue(0,0,aFields[i]) + "\n";
		}
		alert(sResult);
	}
	function require(){
		setItemRequired(0,"TELEPHONE",true);
	}
	function unrequire(){
		setItemRequired(0,"TELEPHONE",false);
	}
	function setTitlex(){
		var sTitle = prompt("输入标题",'标题');
		setItemHeader(0,0,"TELEPHONE",sTitle);
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
