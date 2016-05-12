<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "资产转让协议列表页面";
	//获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	
	String sRelaSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelaSerialNo"));
	if(sRelaSerialNo==null) sRelaSerialNo="";
	
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	if(sApplyType==null) sApplyType="";
	
	
	
	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("ContractDealList",Sqlca);
		
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	dwTemp.ShowSummary = "1";//设置汇总

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sRelaSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","合同详情","合同详情","viewtab()",sResourcesPath},
		{"false","","Button","删除","删除资产转让协议","deleteRecord()",sResourcesPath},
		{"true","","Button","合同导入","合同导入","ContractImport()",sResourcesPath},
	};


%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~合同工详情~*/
	function viewtab(){
		//获得申请类型、申请流水号
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"ContractSerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function ContractImport(){
		var serialNo = "<%=sSerialNo%>";
		var sRelaSerialNo = "<%=sRelaSerialNo%>";
		var sReturn  = RunMethod("公用方法","GetColValue","dealcontract_reative,count(*),SerialNo='"+sRelaSerialNo+"'");
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)>0){
			if(!confirm("本资产包中已存在合同数据,\n确定继续导入合同数据？")){
				return;
			}
		}
		//文件上传
		AsControl.PopView("/BusinessManage/CollectionManage/TransferDealImportInfo.jsp", "ObjectNo="+serialNo+",RelaSerialNo="+sRelaSerialNo, "dialogWidth=450px;dialogHeight=250px;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
		reloadSelf();
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	//	reloadSelf();
	}
	
	$(document).ready(function(){
		hideFilterArea();
		AsOne.AsInit();
		init();
		my_load_show(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>