<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "示例列表页面";
 	String sOperateType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateType"));
 	if(sOperateType == null) sOperateType = "";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RepaymentChannelListNew";//模型编号
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
		{"false","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
	};
	if(!"".equals(sOperateType)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sSerialNo = getSerialNo("BaseDataSet_Info","SERIALNO");
		AsControl.PopView("/CustomService/BusinessConsult/RepaymentChannelInfoFrame.jsp","SerialNo="+sSerialNo,"dialogwidth=900px;dialogheight=600px;");
		reloadSelf();
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
			RunMethod("公用方法", "DelByWhereClause", "BaseDataSet_Info,SerialNo='"+sSerialNo+"'");
		}
		reloadSelf();
	}

	function viewAndEdit(){
		setSessionValue("repaymentChannelSerialNo","");//将流水号移除出session
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.PopView("/CustomService/BusinessConsult/RepaymentChannelInfoFrame.jsp","SerialNo="+sSerialNo+"&OperateType=<%=sOperateType%>","dialogwidth=900px;dialogheight=600px;");
		reloadSelf();
	}
	
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			RunJavaMethodSqlca("", "", "");
			Run
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
