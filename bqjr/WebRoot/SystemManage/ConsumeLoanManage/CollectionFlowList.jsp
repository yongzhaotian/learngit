<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	if(sFlowNo==null) sFlowNo="BqjrCollectionFlow0508";
	sFlowNo = "BqjrCollectionFlow0508";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AuditModelList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause = " where FlowNo='"+sFlowNo+"'";
	doTemp.setVisible("FLOWNO", false);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"false","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){

		AsControl.OpenView("/SystemManage/ConsumeLoanManage/CollectionFlowInfo.jsp","FlowNo=<%=sFlowNo %>","_self","");
	}
	
	function deleteRecord(){
		var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
		if (typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0){
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
		var sPhaseNo = getItemValue(0,getRow(),"PHASENO");
		if (typeof(sPhaseNo)=="undefined" || sPhaseNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/CollectionFlowInfo.jsp","FlowNo=<%=sFlowNo%>&PhaseNo='"+sPhaseNo+"'&ActionType=ViewDetail","_self","");
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
