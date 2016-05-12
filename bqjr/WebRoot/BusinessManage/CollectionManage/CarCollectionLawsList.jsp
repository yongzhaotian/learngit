<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "汽车法务催收登记列表页面";
	//获得页面参数
	String sContractSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractSerialNo"));
	if(sContractSerialNo==null) sContractSerialNo="";
	String sCollectionSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CollectionSerialNo"));
	if(sCollectionSerialNo==null) sCollectionSerialNo="";
	//out.println("sColSerialNo:"+sContractSerialNo+"sBcSerialNo:"+sCollectionSerialNo);
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CARCOLLECTIONLAWSLIST";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sContractSerialNo+","+sCollectionSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		//{"true","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/CarColectionLawsInfo.jsp","CollectionSerialNo=<%=sCollectionSerialNo%>&ContractSerialNo=<%=sContractSerialNo%>","_self","");
	}
	
	/*~~删除法务催收记录~~*/
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
		//alert("SerialNo="+sSerialNo+"CollectionSerialNo=<%=sCollectionSerialNo%>&ContractSerialNo=<%=sContractSerialNo%>");
		AsControl.OpenView("/BusinessManage/CollectionManage/CarColectionLawsInfo.jsp","CollectionSerialNo=<%=sCollectionSerialNo%>&ContractSerialNo=<%=sContractSerialNo%>&SerialNo="+sSerialNo,"_self","");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
