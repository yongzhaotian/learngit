<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String sTempletNo = "TestCustomerInfo";//ģ���
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.genHTMLObjectWindow(CurPage.getParameter("SerialNo"));
	
	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","as_save(0)","","","",""},
		{"true","All","Button","getRowCount","getRowCount","alert(getRowCount(0))","","","",""},
		{"true","All","Button","�����ֶ�ISINUSE","hide ISINUSE","hideItem(0,'ISINUSE')","","","",""},
		{"true","All","Button","��ʾ�ֶ�ISINUSE","show ISINUSE","showItem(0,'ISINUSE')","","","",""},
		{"true","All","Button","����","�����б�","returnList()","","","",""},
		{"true","All","Button","����","lockall","lockall()","","","",""},
		{"true","All","Button","�������","unlockall","unlockall()","","","",""},
		{"true","All","Button","����TELEPHONE*","require","require()","","","",""},
		{"true","All","Button","ȡ��TELEPHONE*","unrequire","unrequire()","","","",""},
		{"true","All","Button","�������ֵ","getItemValue","getAllItemValue()","","","",""},
		{"true","All","Button","���TELEPHONE����","getTitlex","alert(getItemHeader(0,0,'telephone'))","","","",""},
		{"true","All","Button","����TELEPHONE����","setTitlex","setTitlex()","","","",""},
		{"true","All","Button","���TELEPHONE unit","getUnit","alert(getItemUnit(0,0,'telephone'))","","","",""},
		{"true","All","Button","����TELEPHON unit","setUnit","setItemUnit(0,0,'TELEPHONE',prompt('����Unit','Unit'));","","","",""}
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
		var sTitle = prompt("�������",'����');
		setItemHeader(0,0,"TELEPHONE",sTitle);
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
