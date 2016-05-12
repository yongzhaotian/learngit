<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "关联产品";
	//获得页面参数
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SSerialNo"));
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sFlag"));

	
	if(sSSerialNo == null) sSSerialNo = "";
	if(sSNo == null) sSNo = "";
	if(sFlag == null) sFlag = ""; 

	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreProductList";//模型编号StoreProductList
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled=true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(30);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  详情  激活  关闭  暂时关闭  取消关闭
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
		{"true","","Button","费用佣金设置","费用佣金设置","commissionFeeSet()",sResourcesPath},
		{"true","","Button","批量导入","批量导入","batchImport()",sResourcesPath},
	};
	
	//add CCS-884 关闭状态隐藏保存按钮 tangyb 20150720
	if("06".equals(sStatus)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
		sButtons[4][0]="false";
	}
	if("CountAndCheck".equals(sFlag)){
		sButtons[0][0] ="false";
		sButtons[1][0] ="false";
		sButtons[2][0] ="false";
		sButtons[3][0] ="false";
		sButtons[4][0] ="false";	
	}	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function batchImport() {
		
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImport", "filePath="+sFilePath);
	}

	function commissionFeeSet() {
		
		var sSerialNoS = getItemValueArray(0,"SERIALNO");
		var sSerialNo = sSerialNoS[0];
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.PopView("/BusinessManage/StoreManage/FeeCommissionInfo.jsp", "SerialNo="+sSerialNo+"&SerialNoS="+sSerialNoS, "dialogWidth=360px;dialogHeight=320px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	function newRecord(){
		AsControl.OpenView("/BusinessManage/StoreManage/ProductInfo.jsp","SSerialNo=<%=sSSerialNo %>&SNo=<%=sSNo%>","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
		reloadSelf();
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0, getRow(), "SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/StoreManage/ProductInfo.jsp","SerialNo="+sSerialNo+"&SSerialNo=<%=sSSerialNo %>&ActionType=<%=CommonConstans.VIEW_DETAIL%>&Status=<%=sStatus %>","_blank","");
		reloadSelf();
	}
	
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//使用ObjectViewer以视图001打开Example，
	}

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>