<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sSNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if (sSNo == null) sSNo = "";
	
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
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","附件","附件","openWithObjectViewer()",sResourcesPath},
		{"false","","Button","详情","查看催收录入/修改详情","viewAndEdit()",sResourcesPath},
		{"false","","Button","录入催收历史","录入催收历史","newRecord()",sResourcesPath},
		{"false","","Button","催收历史查询","催收历史查询","newRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.PopView("/BusinessManage/ChannelManage/StoreInfo.jsp","SNo=<%=sSNo %>","");
	}
	
	function deleteRecord(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId,"_self","");
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