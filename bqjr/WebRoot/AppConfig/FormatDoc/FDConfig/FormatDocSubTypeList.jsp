<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String PG_TITLE = "格式化报告分类列表";
	String parentNo = CurPage.getParameter("ParentTypeNo");
	if(parentNo == null) parentNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("FDSubTypeList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(parentNo);

	String sButtons[][] = {
		{"true","","Button","新增","新增","add()","","","",""},
		{"true","","Button","详情","详情","editRecord()","","","",""},
		{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function mySelectRow(){
		//获取分类编号
		var sTypeNo=getItemValue(0,getRow(),"TypeNo");
		AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/FormatDocCatalogList.jsp","SubTypeNo="+sTypeNo,"rightdown");
	}
 	function add(){
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocSubTypeInfo.jsp",'',"dialogWidth=400px;dialogHeight=300px;resizable=yes;maximize:yes;help:no;status:no;");
	 	reloadSelf();
 	}
 	function editRecord(){
	 	var sTypeNo=getItemValue(0,getRow(),"TypeNo");
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocSubTypeInfo.jsp","SubTypeNo="+sTypeNo,"dialogWidth=400px;dialogHeight=300px;resizable=yes;maximize:yes;help:no;status:no;");
	 	reloadSelf();
 	}
 	function deleteRecord(){
 		if(confirm('确实要删除吗?')){
 			as_delete("myiframe0");
 		}
 	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>