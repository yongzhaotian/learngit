<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "示例列表页面";
 	String sOperateType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateType"));
 	String sChannelSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
 	if(sOperateType == null) sOperateType = "";
 	if(sChannelSerialNo==null || "".equals(sChannelSerialNo))  sChannelSerialNo = "";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RepaymentChannelDetailList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sChannelSerialNo); 
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","导入","导入","importExcel()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
	};
	
	if(!"".equals(sOperateType)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sChannelSerialNo="<%=sChannelSerialNo%>";
		if("" ==sChannelSerialNo){
			alert("请首先保存还款渠道基本信息");
			reloadSelf();
			return;
		}
		AsControl.OpenPage("/CustomService/BusinessConsult/RepaymentChannelInfo.jsp","ChannelSerialNo=<%=sChannelSerialNo%>","_self");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			//as_del("myiframe0");
			//as_save("myiframe0");  //如果单个删除，则要调用此语句
			RunMethod("公用方法", "DelByWhereClause", "REPAYMENT_CHANNEL_LIST,SerialNo='"+sSerialNo+"'");
		}
		reloadSelf();
	}

	function importExcel(){
		var sChannelSerialNo="<%=sChannelSerialNo%>";
		if("" ==sChannelSerialNo){
			alert("请首先保存还款渠道基本信息");
			reloadSelf();
			return;
		}
		var sFilePath = AsControl.PopView("/CustomService/BusinessConsult/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0 || sFilePath =='_none_') {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "importChannelDetailList",  "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",channelSerialNo="+sChannelSerialNo);
		reloadSelf();
	}
	
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenPage("/CustomService/BusinessConsult/RepaymentChannelInfo.jsp","ChannelSerialNo=<%=sChannelSerialNo%>&detailSerialNo="+sSerialNo+"&OperateType=<%=sOperateType%>","_self");
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
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
