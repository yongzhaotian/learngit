<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
 
	//获得页面参数
	String sRSSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RSSerialNo"));
	String sRSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RSerialNo"));
	String sViewId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewId"));
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	if (sRSSerialNo == null) sRSSerialNo = "";
	if (sRSerialNo == null) sRSerialNo = "";
	if (sViewId == null) sViewId = "01";
	if (sApplyType == null) sApplyType = "";
	
	if ("02".equals(sViewId)) CurComp.setAttribute("RightType", "ReadOnly");
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sRSSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","附件上传","附件上传","addAttachment()",sResourcesPath},
		{"true","","Button","查看附件","查看附件内容","viewFile()",sResourcesPath},
		{"false","","Button","签署意见","签署意见","signOpinion()",sResourcesPath},
		{"false","","Button","查看意见","查看意见","viewOpinions()",sResourcesPath},
		{"false","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
		{"true","","Button","复制门店信息","复制们的信息","copyStoreInfo()",sResourcesPath},
	};
	
	if (CommonConstans.ReTAILSTORE_APPROVE_TYPE.equals(sApplyType)) {
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "true";
		sButtons[5][0] = "true";
		sButtons[8][0] = "false";
	}
	
	if ("02".equals(sViewId)) sButtons[3][0] = "false";
	
	// 如果处于审核完成阶段，只能查看意见
	String sFinishePhaseNo = Sqlca.getString(new SqlObject("select PhaseNo from flow_object where objectno=:ObjectNo").setParameter("ObjectNo", sRSSerialNo));
	if ("2000".equals(sFinishePhaseNo)  || "9000".equals(sFinishePhaseNo)) {
		sButtons[5][0] = "false";
		sButtons[6][0] = "true";
	}
	
	String sSRPhaseType = Sqlca.getString(new SqlObject("select PhaseType from flow_object where objectno=:ObjectNo").setParameter("ObjectNo", sRSSerialNo));
	if (!"1010".equals(sSRPhaseType)) sButtons[8][0] = "false";
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	// 复制门店信息
	function copyStoreInfo() {
		var sSerialNo = getItemValue(0, getRow(), "SERIALNO");
		
		if (typeof(sSerialNo)=='undefined' || sSerialNo.length==0) {
			alert("请选择一条记录！");
			return;
		}
		
		RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "copyStoreInfo", "serialNo="+sSerialNo+",tableName=Store_Info,colName=SerialNo");
		reloadSelf();
	}

	function signOpinion()
	{
		//获得任务流水号、对象类型、对象编号
		sSerialNo = getItemValue(0,getRow(),"SERIALNO");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		//签署对应的意见
		AsControl.PopView("/Common/WorkFlow/SignTaskOpinionInfo2.jsp","SerialNo="+sSerialNo+"&ObjectType=<%=CommonConstans.RETAILSTORE_APPLY_TYPE %>&ObjectNo=<%=sRSSerialNo %>&SNo="+getItemValue(0, getRow(), "SNO"),"dialogWidth=580px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sSerialNoTemp = RunMethod("公用方法","GetColValue","Flow_Opinion,SerialNo,SerialNo='"+sSerialNo+"' and OpinionNo=<%=sRSSerialNo%>");
		if (sSerialNoTemp == "Null") {
			alert("还未签署意见，请先签署意见！");
			return;
		}
		
		//AsControl.PopView("/Common/WorkFlow/SignTaskOpinionInfo2.jsp","SerialNo="+sSerialNo+"&SNo="+getItemValue(0, getRow(), "SNO")+"&ViewId=002","dialogWidth=580px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		AsControl.PopView("/Common/WorkFlow/SignTaskOpinionInfo2.jsp","SerialNo="+sSerialNo+"&ObjectType=<%=CommonConstans.RETAILSTORE_APPLY_TYPE %>&ObjectNo=<%=sRSSerialNo %>&ViewId=002&SNo="+getItemValue(0, getRow(), "SNO"),"dialogWidth=580px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}

	/*~[Describe=上传附件;InputParam=无;OutPutParam=无;]~*/
	function addAttachment() {
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		// 如果附件已经上传，先删除该记录再上传
		var sDocNo = RunMethod("公用方法", "GetColValue", "DOC_ATTACHMENT,DocNo,DocNo='"+serialNo+"'");
		if (sDocNo!="Null") {
			RunMethod("公用方法", "DelByWhereClause", "DOC_ATTACHMENT,DocNo='"+serialNo+"'");
		}
		
		AsControl.PopView("/AppConfig/Document/AttachmentChooseDialog.jsp","DocNo="+serialNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
		
	/*~[Describe=查看附件内容;InputParam=无;OutPutParam=无;]~*/
	function viewFile()
	{
		var sDocNo= getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		else
		{
			// 获取附件编号
			var sAttachmentNo = RunMethod("公用方法", "GetColValue", "DOC_ATTACHMENT,AttachmentNo,DocNo='"+sDocNo+"'");
			AsControl.PopView("/AppConfig/Document/AttachmentView.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
		}
	}
	
	function newRecord(){
		
		AsControl.OpenView("/BusinessManage/ChannelManage/StoreInfo.jsp","RSSerialNo=<%=sRSSerialNo%>&RSerialNo=<%=sRSerialNo %>","_self");

	}
	
	function deleteRecord(){
		var serialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(serialNo)=="undefined" || serialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
				reloadSelf();
		}
	}

	function viewAndEdit(){
		
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenView("/BusinessManage/ChannelManage/StoreInfo.jsp","RSSerialNo=<%=sRSSerialNo%>&RSerialNo=<%=sRSerialNo %>&SSerialNo="+sSerialNo+"&ApplyType=<%=sApplyType%>&ViewId=<%=sViewId%>","_self");

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
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>