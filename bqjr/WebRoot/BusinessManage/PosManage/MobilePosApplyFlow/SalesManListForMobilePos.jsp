<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sMobilePoseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MOBLIEPOSNO"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	if(sSNo == null) sSNo = "";
	if(sMobilePoseNo == null) sMobilePoseNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "MobilePosSalesmanList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    doTemp.WhereClause+=" and SType is null";
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(30);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sMobilePoseNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  详情  激活  关闭  暂时关闭  取消关闭
		{CurUser.hasRole("1005")&&"0010".equals(sPhaseNo)?"true":"false","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{sPhaseNo.equals("0010")||CurUser.hasRole("1004")||CurUser.hasRole("1049")?"true":"false","","Button","解除绑定","删除","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	
	function newRecord(){
//		alert("<%=sSNo %>");
//		alert("<%=sMobilePoseNo %>");
		
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/SalesmanInfo.jsp","SNo=<%=sSNo %>&MobilePoseNo=<%=sMobilePoseNo%>&PhaseNo=<%=sPhaseNo%>","_self","");
	}
	
	function deleteRecord(){
		var sSno = getItemValue(0, getRow(), "SNO");
		var sSalesManager = getItemValue(0, getRow(), "SALEMANAGERNO");
		var sSalesman = getItemValue(0, getRow(), "SALESMANNO");
    	var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			// 更新当前销售人员
			<%-- RunMethod("公用方法", "UpdateColValue", "User_Info,SuperId,,UserId='"+sSalesman+"' and IsCar='02' and Status='1'");
			var sParam = "type=02,sNo="+getItemValue(0, 0, "SNO")+",salesmanNos="+sSalesman+",salesManager="+sSalesManager+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
			RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon","insertHistory",sParam); --%>
			reloadSelf();
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/SalesmanInfo.jsp","SerialNo="+sSerialNo+"&SNo=<%=sSNo %>&MobilePoseNo=<%=sMobilePoseNo%>&ActionType=Detail&VIWEFLAG=2&PhaseNo=<%=sPhaseNo%>","_self","");
		
	}
	

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>