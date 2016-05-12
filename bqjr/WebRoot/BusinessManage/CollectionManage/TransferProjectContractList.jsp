<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "资产转让项目项下关联合同信息列表界面";
	//获得页面参数
	String sProjectSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectSerialNo"));//项目编号
	String sProtocolNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProtocolNo"));//项目所关联的协议编号
	//String sTransferType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));//项目所关联的协议编号
	if(sProjectSerialNo==null) sProjectSerialNo="";
	if(sProtocolNo==null) sProtocolNo="";
	//if(sTransferType==null)sTransferType="";
	//out.println("项目编号:"+sProjectSerialNo+";协议编号:"+sProtocolNo+"转让类型："+sTransferType);
	
	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("TransferProjectContractList",Sqlca);

	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
	//CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增关联合同","选择关联合同","newRecord()",sResourcesPath},
		//{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		//{"true","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sBcSerialNo = AsControl.PopPage("/BusinessManage/CollectionManage/AssetsBusinessContractList.jsp","ProjectSerialNo=<%=sProjectSerialNo%>","_self","");
		var sSerialNo = getSerialNo("TRANSFER_PROJECT_CONTRACT", "SerialNo", "");//关联表的流水号
		var sTransferDealSerialNo = "<%=sProtocolNo%>";//资产转让协议号
		var sProjectSerialNo = "<%=sProjectSerialNo%>";//资产转让协议项下项目编号
		var sContractSerialNo = sBcSerialNo;//资产转让协议项目项下关联的合同号
		var sTransferType = "0010";//资产转让类型(0010首次转让;0020再次转让)
		var sInputUserID = "<%=CurUser.getUserID()%>";
		var sInputOrgID = "<%=CurUser.getOrgID()%>";
		var sInputDate = "<%=StringFunction.getToday()%>";
		if(typeof(sTransferDealSerialNo)==null||sTransferDealSerialNo=="" ||typeof(sContractSerialNo)==null||sContractSerialNo==""||typeof(sProjectSerialNo)==null||sProjectSerialNo==""){
			alert("协议号、项目号、合同号都不能为空!");
			return;
		}
		
		sParam = "SerialNo="+sSerialNo+",TransferDealSerialNo="+sTransferDealSerialNo+",ProjectSerialNo="+sProjectSerialNo+",ContractSerialNo="+sContractSerialNo+",TransferType="+sTransferType+",InputUserID="+sInputUserID+",InputOrgID="+sInputOrgID+",InputDate="+sInputDate;
		var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.hhcf.after.colection.AfterColectionAction","projectRelationContract",sParam);
		
		if(sReturn=="true")
		{
			reloadSelf();
		}
		else if(sReturn =="ContractIsExist")
		{
			alert("该合同己与项目关联!");
			return;
		}
		else
		{
			alert("项目项下选择的合同关联失败!");
			return;
		}
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
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
