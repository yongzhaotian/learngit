<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	doTemp.setReadOnly("SERIALNO",true);
	doTemp.setHtmlEvent("TELEPHONE","onkeyup","testkeyup");
	doTemp.setHtmlEvent("ISINUSE","onclick","testclick");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0";//编辑模式
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","保存","保存","as_save(0)","","","",""}
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function testkeyup(){
		alert("输入电话为：" + getItemValue(0,getRow(),"TELEPHONE"));
	}
	function testclick(){
		alert("是否使用：" + getItemValue(0,getRow(),"ISINUSE"));
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
