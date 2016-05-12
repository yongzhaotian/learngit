<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	if(sSNo == null) sSNo = "";
	
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "StoreSalesmanList";//模型编号
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
	Vector vTemp = dwTemp.genHTMLDataWindow(sSNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  详情  激活  关闭  暂时关闭  取消关闭
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","解除绑定","解除绑定","deleteRecord()",sResourcesPath},
	};
	
	//add CCS-884 关闭状态隐藏保存按钮 tangyb 20150720
	if("06".equals(sStatus)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
	}
	//add CCS-1283 关闭销售经理门店加解绑销售代表的权限
	if(CurUser.hasRole("1005")){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
	}
	//PRM-831 销售经理及以上人员加绑功能取消 add by zty 20160411
	if(CurUser.hasRole("1005") || CurUser.hasRole("1004") || CurUser.hasRole("1008")){
		sButtons[1][0]="false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	
	function newRecord(){
		
		AsControl.OpenView("/BusinessManage/StoreManage/SalesmanInfo.jsp","SNo=<%=sSNo %>","_self","");
	}
	
	/**
	 * 接触绑定 --update CCS-884:门店优化 tangyb 20150720 start--
	 */
	function deleteRecord(){
		//var sSalesManager = getItemValue(0, getRow(), "SALEMANAGERNO"); //销售经理
		var sno = getItemValue(0, 0, "SNO"); // 门店编码
		var sSalesman = getItemValue(0, getRow(), "SALESMANNO"); //销售人员
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO"); //门店序号
		
		var userid = "<%=CurUser.getUserID()%>"; //登录用户
		var orgid = "<%=CurOrg.orgID%>"; //机构编号
		var stime = getTime(); //获取当前时间

		//alert("sno="+sno+",userid="+userid+",orgid="+orgid);
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想解除绑定该信息吗？")){
			//as_del("myiframe0");
			//as_save("myiframe0");  //如果单个删除，则要调用此语句
			//var sParam = "type=02,sNo="+sno+",salesmanNos="+sSalesman+",salesManager="+sSalesManager+",userid="+userid+",orgid="+orgid;
			//alert(sParam);
			//RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon","insertHistory",sParam);
			
			//查询销售人员与门店经理其他门店是否还存在关系 (0:否,1:是)
			var isThere = RunJavaMethodSqlca("com.amarsoft.app.billions.StoreInfo", "querySalesManagerRelation", "sno="+sno+",salesmanno="+sSalesman);
			if(isThere == "0"){
				// 解除销售人员与门店经理关系
				RunMethod("公用方法", "UpdateColValue", "User_Info,SuperId,,UserId='"+sSalesman+"' and IsCar='02' and Status='1'");
			} 
			
			var successType = RunMethod("PublicMethod","UpdateColValue","String@updateorg@"+orgid+"@String@updateuser@"+userid+"@String@updatedate@"+stime+"@String@stype@02,storerelativesalesman,String@serialno@"+sSerialNo);
			if(successType == "TRUE"){
				alert("提交成功");
			}
			
			reloadSelf();
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/StoreManage/SalesmanInfo.jsp","SerialNo="+sSerialNo+"&ActionType=Detail&VIWEFLAG=2&Status=<%=sStatus %>","_self","");
		
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

	//获取当前日期(yyyy/MM/dd HH:mm:ss) 20150720 tangyb add
	function getTime(){
		var date = new Date(); //当前日期
		var myyear = date.getFullYear(); //年
		var mymonth = date.getMonth() + 1; //月
		var myweekday = date.getDate(); //日
		if (mymonth < 10) {
			mymonth = "0" + mymonth;
		}
		if (myweekday < 10) {
			myweekday = "0" + myweekday;
		}
		//取时间 
		var hh = date.getHours(); //截取小时，即8 
		var mm = date.getMinutes(); //截取分钟，即34 
		var ss = date.getTime() % 60000; //获取时间，因为系统中时间是以毫秒计算的， 所以秒要通过余60000得到。
		ss = (ss - (ss % 1000)) / 1000; //然后，将得到的毫秒数再处理成秒 
		return (myyear + "/" + mymonth + "/" + myweekday + " " + hh + ":" + mm + ":" + ss);
	}

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>