<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String PG_TITLE = "格式化报告目录列表";
	String sTypeNo = CurPage.getParameter("SubTypeNo");
	if(sTypeNo == null) sTypeNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("FDCatalogList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sTypeNo);

	String sButtons[][] = {
		{"true","","Button","新增","新增","add()","","","","btn_icon_add"},
		{"true","","Button","详情","详情","edit()","","","","btn_icon_detail"},
		{"true","","Button","复制","复制","copy()","","","","btn_icon_detail"},
		{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete"},
		{"true","","Button","报告定义","报告定义","viewDef()","","","","btn_icon_detail"},
		{"true","","Button","报告参数定义","报告参数定义","viewPara()","","","","btn_icon_detail"},
		{"true","","Button","填写调查报告","填写调查报告","newFormatDoc()","","","",""},
		{"true","","Button","查看调查报告","查看调查报告","viewFormatDoc()","","","",""},
		{"true","","Button","导出离线资料","导出离线资料","exportOfflineDoc()","","","",""},
		{"true","","Button","导出PDF","导出PDF","exportDocToPdf()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/as_formatdoc.js"></script>
<script type="text/javascript">
 	function add(){
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocCatalogInfo.jsp",'',"dialogWidth=600px;dialogHeight=500px;resizable=yes;maximize:yes;help:no;status:no;");
	 	reloadSelf();
 	}
 	
 	function edit(){
	 	if(getRow()==-1){
			alert('没有选中可用的行');
			return;
	 	}
	 	var sDocID=getItemValue(0,getRow(),'DocID');
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocCatalogInfo.jsp",'DocID=' + sDocID,"dialogWidth=600px;dialogHeight=500px;resizable=yes;maximize:yes;help:no;status:no;");
	 	reloadSelf();
 	}
 	
 	function copy(){
		if(getRow()==-1){
			alert('没有选中可用的行');
			return;
		}
		if(!confirm("您确认要复制该条记录及其相关联数据吗")) return;
		var sDocID=getItemValue(0,getRow(),'DocID');
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.formatdoc.action.FormatDocCatalogAction", "copy", "DocID="+sDocID);
		if(sReturn){
			if(sReturn == "SUCCESS"){
				reloadSelf();
			}else{
				alert(sReturn);
			}
		}else{
			alert("复制失败！");
		}
	}
 	
 	function deleteRecord(){
 		if(confirm('确实要删除吗?')){
 			var sDocID=getItemValue(0,getRow(),'DocID');
 			var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.formatdoc.action.FormatDocCatalogAction", "delete", "DocID="+sDocID);
 			if(sReturn && sReturn == "SUCCESS"){
 				reloadSelf();
 			}else{
 				alert("复制失败！");
 			}
 		}
 	}

 	//查看报告定义
 	function viewDef(){
	 	if(getRow()==-1){
			alert('没有选中可用的行');
			return;
	 	}
	 	var sDocID=getItemValue(0,getRow(),'DocID');
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocDefList.jsp",'DocID=' + sDocID,"");
 	}
 	
	//查看报告参数定义
 	function viewPara(){
	 	if(getRow()==-1){
			alert('没有选中可用的行');
			return;
	 	}
	 	var sDocID=getItemValue(0,getRow(),'DocID');
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocParaList.jsp",'DocID=' + sDocID,"");
 	}
	
	//---------------------------格式化报告的功能测试---------------------------
 	function newFormatDoc(){
		var sDocID = "D001";
		var sObjectNo = "2011022400000008"; //测试业务
		var sObjectType = "CreditApply";
		fillFormatDocWithOpen(sDocID,sObjectNo,sObjectType);
	}
	
	function viewFormatDoc(){
		var sDocID = "D001";
		var sObjectNo = "2011022400000008"; //测试业务
		var sObjectType = "CreditApply";
		//先生成
		var sReturn = productFormatDoc(sDocID,sObjectNo,sObjectType);
		//再查看
		if(typeof(sReturn)!='undefined' && sReturn!="" && sReturn != "FAILED"){
			previewFormatDoc(sDocID,sObjectNo,sObjectType);
		}				
	}
	
	function exportOfflineDoc(){
		var sDocID = "D001";
		var sObjectNo = "2011022400000008"; //测试业务
		var sObjectType = "CreditApply";
		exportOfflineFormatDoc(sDocID,sObjectNo,sObjectType);
	}
	
	function exportDocToPdf(){
		var sDocID = "D001";
		var sObjectNo = "2011022400000008"; //测试业务
		var sObjectType = "CreditApply";
		exportToPdf(sDocID,sObjectNo,sObjectType);
	}
	//---------------------------------------------------------------------------------
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>