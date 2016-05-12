<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String sDocID = CurPage.getParameter("DocID");
 	if(sDocID == null) sDocID = "";

	ASObjectModel doTemp = new ASObjectModel("FDParaList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0";//只读模式
	dwTemp.genHTMLObjectWindow(sDocID);

	String sButtons[][] = {
		{"true","","Button","新增","新增","add()","","","",""},
		{"true","","Button","保存","保存","as_save('myiframe0')","","","",""},
		{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("报告参数定义");
 	function add(){
	 	as_add("myiframe0");
	 	//设置默认值
	 	setItemValue(0,getRow(0),'DocID','<%=sDocID%>');
 	}
 
	function deleteRecord(){
	 	if(confirm('确实要删除吗?')){
		 	as_delete("myiframe0");
	 	}
 	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>