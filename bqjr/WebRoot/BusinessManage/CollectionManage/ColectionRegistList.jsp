<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%
	/*
		--页面说明: 催收任务跟进结果登记列表页面--
	 */
	String PG_TITLE = "催收任务跟进结果登记列表页面";
	//获得页面参数
	String sColSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColectionSerialNo"));//催收任务编号
	String sBcSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractSerialNo"));//催收任务合同号
	//out.println("sColSerialNo:"+sColSerialNo+"sBcSerialNo:"+sBcSerialNo);
	if(sColSerialNo==null) sColSerialNo="";
	if(sBcSerialNo==null) sBcSerialNo="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CARCOLLECTIONREGISTLIST";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sBcSerialNo+","+sColSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
	};
%>

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenPage("/BusinessManage/CollectionManage/ColectionRegistInfo.jsp", "ContractSerialNo=<%=sBcSerialNo%>&ColectionSerialNo=<%=sColSerialNo%>","_self","");
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
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenPage("/BusinessManage/CollectionManage/ColectionRegistInfo.jsp","ContractSerialNo=<%=sBcSerialNo%>&ColectionSerialNo=<%=sColSerialNo%>&RightType=ReadOnly&SerialNo="+sSerialNo,"_self","");
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
