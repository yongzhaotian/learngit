<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	doTemp.setReadOnly("SERIALNO",true);
	doTemp.setHtmlEvent("TELEPHONE","onkeyup","testkeyup");
	doTemp.setHtmlEvent("ISINUSE","onclick","testclick");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "0";//�༭ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","����","����","as_save(0)","","","",""}
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function testkeyup(){
		alert("����绰Ϊ��" + getItemValue(0,getRow(),"TELEPHONE"));
	}
	function testclick(){
		alert("�Ƿ�ʹ�ã�" + getItemValue(0,getRow(),"ISINUSE"));
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
