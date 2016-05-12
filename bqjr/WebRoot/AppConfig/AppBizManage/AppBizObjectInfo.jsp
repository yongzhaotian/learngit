<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	//获得参数	
	String sObjectType =  CurPage.getParameter("ObjectType");
	if(sObjectType==null) sObjectType="";

	ASObjectModel doTemp = new ASObjectModel("AppBizObjectInfo");
	
	//如果不为新增页面，则参数的ID不可修改
	if(sObjectType.length() != 0 ){
		doTemp.setReadOnly("ObjectType",true);
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectType);

	String sButtons[][] = {
		{"true","","Button","保存","","saveRecord()","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0","parent.frames[0].as_refreshCurrentRow(0)");
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>