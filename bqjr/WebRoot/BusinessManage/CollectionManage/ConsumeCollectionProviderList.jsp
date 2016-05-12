<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "委外催收";
	//获得页面参数
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	if(sPhaseType1==null) sPhaseType1="";
	String sTempletNo="";
	
	//通过DW模型产生ASDataObject对象doTemp
	if(sType.endsWith("4")){
		sTempletNo = "ConsumeQIQIANCollectionList";//模型编号
	}else{
		sTempletNo ="ConsumeCollectionProviderList";
	}
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseType1);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","查看合同","查看合同","OverDuelContractList()",sResourcesPath},
		{"true","","Button","查看历史","查看历史","viewHistory()",sResourcesPath},
		{"true","","Button","导入","导入","viewAndEdit()",sResourcesPath},
		{"true","","Button","导出","导出","expornt()",sResourcesPath},
		{"true","","Button","删除 ","删除","deleteXin()",sResourcesPath},
		{"false","","Button","调整委外公司","调整委外公司","editCommpany()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	//行动代码录入
	function viewAndEdit(){
		var sType="<%=sType%>";
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		alert(sFilePath);
		if(sType=="4"){
			RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "importCommusModel1", "filePath="+sFilePath+",flag=1"+",userid="+"<%=CurUser.getUserID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		}else{
			RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "importCommusModel", "filePath="+sFilePath+",flag=1"+",userid="+"<%=CurUser.getUserID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		}
		reloadSelf();
	}
	
	function expornt(){
		amarExport("myiframe0");
	}
	
	//查看催收历史 
	function viewHistory(){
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenPage("/BusinessManage/CollectionManage/ConsumeCollectionRegistList.jsp", "CustomerID="+sCustomerID+"&PhaseType1=<%=sPhaseType1%>", "_self","");
		
	}
	
	function deleteXin(){
		var sLoanNo = getItemValue(0,getRow(),"SERIALNO");//修改为 wlq 
		if (typeof(sLoanNo)=="undefined" || sLoanNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}
	
	/*查看客户项下所有逾期合同*/
	function OverDuelContractList(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("该催收任务信息不完整，客户号为空！");
			return;
		}
	
		sCompID = "ConsumeOverDuelBCList";
		sCompURL = "/BusinessManage/CollectionManage/ConsumeOverDuelBCList.jsp";
		sParamString = "CustomerID="+sCustomerID;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=850px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		reloadSelf();
	}

	
	//add  wlq  调整委外公司  20140725  --
	function editCommpany(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "ConsumeOverDuelBCList";
		sCompURL = "/BusinessManage/CollectionManage/ConsumeOverDuelBCFrame.jsp";
		sParamString = "temp=002&SerialNo="+sSerialNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=950px;dialogHeight=650px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:yes;help:no;");
		reloadSelf();
	}
	

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
