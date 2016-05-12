<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	String sWhereClause =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("WhereClause"));
	if(sWhereClause==null) sWhereClause="";
	if(sTemp==null) sTemp="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "";//模型编号
	if(sTemp.equals("001")){
		sTempletNo = "RetailList";
	}else if(sTemp.equals("002")){
		sTempletNo = "UserList";
	}else{
		sTempletNo = "StoreList";
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	//CCS-1209 需求申请：销售部同事信息查询界面中，增加查询字段：身份证号码
	if(sTemp.equals("002")){
		doTemp.setFilter(Sqlca, "0225", "CertId", "Operators=BeginsWith,EndWith,Contains,EqualsString;");
	}
	doTemp.parseFilterData(request,iPostChange);
	
	doTemp.WhereClause = " where 1=1";
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause = " where 1=2";
	if (!sWhereClause.equals("")) doTemp.WhereClause = sWhereClause;
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{sTemp.equals("001")?"false":"true","","Button","门店详情","门店详情","viewStoreInfo()",sResourcesPath},
		{sTemp.equals("001")?"false":"true","","Button","客户预约","客户预约","viewReservCustomerInfo()",sResourcesPath},
		{sTemp.equals("001")?"false":"true","","Button","商户预约","商户预约","viewReservCommercialInfo()",sResourcesPath},
		{sTemp.equals("001")?"false":"true","","Button","查看客户预约","查看客户预约","viewAppointInfo()",sResourcesPath},
		{sTemp.equals("001")?"false":"true","","Button","查看商户预约","查看商户预约","viewCommeInfo()",sResourcesPath},
	};
	if(sTemp.equals("002")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
		sButtons[4][0]="false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	<%/*~[Describe=客户预约;InputParam=无;OutPutParam=无;]~*/%>
	function viewReservCustomerInfo(){
		AsControl.OpenView("/CustomService/BusinessConsult/ReservCustomerConsultInfo.jsp","CType=01&WhereClause=<%=doTemp.WhereClause%>","_self","");
	}
	
	<%/*~[Describe=商户预约;InputParam=无;OutPutParam=无;]~*/%>
	function viewReservCommercialInfo(){
		AsControl.OpenView("/CustomService/BusinessConsult/ReservCommecialConsultInfo.jsp","CType=02&WhereClause=<%=doTemp.WhereClause %>","_self","");
	}
	
	<%/*~[Describe=门店信息查看;InputParam=无;OutPutParam=无;]~*/%>
	function viewStoreInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/CustomService/BusinessConsult/StoreInfo.jsp","SerialNo="+sSerialNo+"&WhereClause=<%=doTemp.WhereClause %>&ViewId=02","_self","");
	}

	<%/*~[Describe=客户预约查看;InputParam=无;OutPutParam=无;]~*/%>
	function viewAppointInfo(){
		sCompID = "AppointManageList";
		sCompURL = "/InfoManage/QuickSearch/AppointManageList.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=800px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;help:no;");
	    reloadSelf();
	}
	
	<%/*~[Describe=商户预约查看;InputParam=无;OutPutParam=无;]~*/%>
	function viewCommeInfo(){
		sCompID = "CommecialAppoinmentList";
		sCompURL = "/BusinessManage/ChannelManage/CommecialAppoinmentList.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=800px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:yes;help:no;");
	    reloadSelf();
	}


	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>