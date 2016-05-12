<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String isSelected =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Selected"));
	if(isSelected==null) isSelected="";
	//首次转让或再转让判断标识
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	//out.println("转让类型:"+sTransferType);
	
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "TransferDealManagerList2";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//项目关联再转让协议时选择协议时的判断
	if(isSelected.equals("true"))
	{
		doTemp.multiSelectionEnabled=true;
	}
	
	//首次转让和再次转让时，原协议流水号字段隐藏判断
	if(sTransferType.equals("0020")){
		doTemp.setVisible("RelativeSerialNo", true);//再次转让协议时显示该字段
	}else{
		doTemp.setVisible("RelativeSerialNo", false);//非再次转让协议时隐藏该字段(false不显示;true显示)
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增协议信息","新增资产转让协议","newRecord()",sResourcesPath},
		{"true","","Button","协议详情","查看资产转让协议详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除资产转让协议","deleteRecord()",sResourcesPath},
		{"false","","Button","确定","确定","getAndReturnSelected()",sResourcesPath},
		//{"true","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
	};
	
	if(isSelected.equals("true")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="true";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">


	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo2.jsp","TransferType=<%=sTransferType%>","_self","");
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
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo2.jsp","SerialNo="+sSerialNo+"&RightType=ReadOnly&TransferType=<%=sTransferType%>","_self","");
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
