<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sMatchType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MatchType"));
	String sInputDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputDate"));
	String sflag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("flag"));
	String sBusinessDate=SystemConfig.getBusinessDate();
	
	if(sMatchType == null) sMatchType="";
	if(sInputDate == null) sInputDate="";
	if(sflag == null) sflag="";
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "TackbackFileList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	if(!"02".equalsIgnoreCase(sflag)){
		doTemp.WhereClause +=" and  flag is null ";
	}else{
		doTemp.WhereClause +=" and  flag ='02' ";
	}
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sInputDate+","+sMatchType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  详情  激活  关闭  暂时关闭  取消关闭
		{"false","","Button","手工匹配","手工匹配","newRecord()",sResourcesPath},
		{"false","","Button","手工分离","手工分离","manualLeave()",sResourcesPath},
	};
	if ("1".equals(sMatchType)) sButtons[0][0] = "true";
	if ("3".equals(sMatchType)) sButtons[1][0] = "true";
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function newRecord(){
		var Serialno = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(Serialno) == "undefined" || Serialno.length == 0){
			alert("请选择一条记录！");
			return;
		}
		
		var rpyNam = getItemValue(0,getRow(),"RPYNAM");
		if(rpyNam == "深圳市深银联易办事金融服务有限公司" || rpyNam == "中泰信托有限责任公司" || rpyNam == "深圳市快付通金融网络科技服务有限公司"){
			alert("收/付方名称为【"+rpyNam+"】的客户不允许进行手工匹配");
			return;
		}
		
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/BankLinkInfo.jsp","SerialNo="+Serialno,"_self","");
	}
	
	function manualLeave(){
		var sSerialno = getItemValue(0,getRow(),"SERIALNO");
		var sUpdateDate = getItemValue(0,getRow(),"UPDATEDATE");
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
		var sTrsAmtC = getItemValue(0,getRow(),"TRSAMTC");
		var sUpdateUserID = getItemValue(0,getRow(),"UPDATEUSERID");
		var sUpdateOrgID = getItemValue(0,getRow(),"UPDATEORGID");
				
		var sCurOrg = "<%=CurOrg.orgID %>";
		var sCurUser = "<%=CurUser.getUserID()%>";
		
		if (typeof(sSerialno) == "undefined" || sSerialno.length == 0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您确认分离该笔进账吗？")){
							
			var sDepositsAmt = RunMethod("BusinessManage","CustomerDeposits",sCustomerID);
			if(sDepositsAmt=="Null" || typeof(sDepositsAmt)=="undefined" || sDepositsAmt.length==0 || "<%=sBusinessDate%>"==sUpdateDate){
				var sParaString = sCustomerID+","+sUpdateDate+","+sUpdateUserID+","+sUpdateOrgID+","+sCurOrg+","+sCurUser+","+sTrsAmtC+","+sSerialno;
				
				var sReturn = RunMethod("BusinessManage","BankLinkChange",sParaString);
				if(sReturn == "success"){
					alert("分离成功");
				}
				reloadSelf();
			}else{
				
				if(sTrsAmtC > sDepositsAmt){
					alert("该进账已做了还款，不能做分离操作。。。");
					return;
				}
				
				var sParaString = sCustomerID+","+sUpdateDate+","+sUpdateUserID+","+sUpdateOrgID+","+sCurOrg+","+sCurUser+","+sTrsAmtC+","+sSerialno;
				
				var sReturn = RunMethod("BusinessManage","BankLinkChange",sParaString);
				if(sReturn == "success"){
					alert("分离成功");
				}
				reloadSelf();
			}
				
		}
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
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoTab.jsp","RSerialNo="+sSerialNo,"_blank","");
		reloadSelf();
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
		//showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>