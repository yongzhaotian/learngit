<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
 	String sDocID = CurPage.getParameter("DocID");
 	if(sDocID == null) sDocID = "";

	ASObjectModel doTemp = new ASObjectModel("FDDefList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0";
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sDocID);

	String sButtons[][] = {
		{"true","","Button","新增","新增","add()","","","",""},
		{"true","","Button","保存","保存","as_save('myiframe0')","","","",""},
		{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete"},
		{"true","","Button","预览模板文件","预览模板文件","preview_model()","","","",""},
		{"true","","Button","下载模板文件","下载模板文件","downloadModel()","","","",""},
		{"true","","Button","上传模板文件","上传模板文件","uploadModel()","","","",""},
		{"false","","Button","验证规则","验证规则","validatorDialog()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("报告节点定义");
 	function add(){
	 	as_add("myiframe0");
	 	//设置默认值
	 	setItemValue(0,getRow(),'DocID','<%=sDocID%>');
 	}
 	function deleteRecord(){
 		if(confirm('确实要删除吗?')){
 			as_delete("myiframe0");
 		}
 	}
 	//预览模板文件
 	function preview_model(){
		if(getRow()==-1){
			alert('没有选中可用的行');
			return;
		}
	 	var sUrl = getItemValue(0,getRow(),'HtmlFileName');
	 	if(!sUrl){
	 		alert('请填写模板文件名');
	 		return;
	 	}
	 	
	 	AsControl.OpenView(sUrl,'','');
 	}
 	//下载模板文件
 	function downloadModel(){
	 	if(getRow()==-1){
			alert('没有选中可用的行');
			return;
	 	}
	 	var sJspFileName=getItemValue(0,getRow(),'JspFileName');
	 	var sHtmlFileName=getItemValue(0,getRow(),'HtmlFileName');
	 	OpenPage("/AppConfig/FormatDoc/FDConfig/DownloadModelFile.jsp?JspFileName="+sJspFileName+"&HtmlFileName="+sHtmlFileName,"");
 	}
 	//上传模板文件
 	function uploadModel(){
	 	if(getRow()==-1){
			alert('没有选中可用的行');
			return;
	 	}
	 	var sDirID = getItemValue(0,getRow(),'DirID');
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/UploadModelFile.jsp","DocID=<%=sDocID%>&DirID="+sDirID,"dialogWidth=600px;dialogHeight=200px;");
 	}
	//验证规则
 	function validatorDialog(){
	 	var sDono=getItemValue(0,getRow(),"DocID")+"@"+getItemValue(0,getRow(),"DirID");
	 	if(getRow()==-1){
			alert('没有选中可用的行');
		 	return;
	 	}
	 	AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/ValidateEditFrame.jsp","Dono="+sDono,"");
 	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>