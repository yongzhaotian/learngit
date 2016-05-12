<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "现金流列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//定义变量
	String sSql = "";
	//获得页面参数
	String objectNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")));
	String objectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")));
	String sPayType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PayType")));
	
	if(objectNo==null) objectNo="";
	if(objectType==null) objectType="";
	if(sPayType==null) sPayType="";
	
	// 贷款台账列表
	ASDataObject doTemp = new ASDataObject("PaymentScheduleList",Sqlca);

	
	// 设置查询框
    doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));


	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);//服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+objectType+","+sPayType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath},
		{"true","","Button","还款计划表","还款计划表","viewPayment()",sResourcesPath},
		};
	%>


<%@include file="/Resources/CodeParts/List05.jsp"%>

	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	
	function exportAll()
	{
		amarExport("myiframe0");
	}
	
	/*~[Describe=查询还款计划表;InputParam=无;OutPutParam=无;]~*/
	function viewPayment(){
		PopComp("SimulationPaymentSchedule","/Accounting/Transaction/SimulationPaymentSchedule.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&RightType=ReadOnly","");
	}
	
	/*~[Describe=页面初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		//计算应还总金额、实还总金额
			var num = getRowCount(0);
			for(var i=0;i<num;i++){
			var PayPrincipalAmt=getItemValue(0,i,"PayPrincipalAmt");
			var PayInteAMT=getItemValue(0,i,"PayInteAMT");
			var PayFineAMT=getItemValue(0,i,"PayFineAMT");
			var PayCompdInteAMT=getItemValue(0,i,"PayCompdInteAMT");
			var sPayAll=PayPrincipalAmt+PayInteAMT+PayFineAMT+PayCompdInteAMT;
			setItemValue(0,i,"PayAll",sPayAll);
			var ActualPayPrincipalAmt=getItemValue(0,i,"ActualPayPrincipalAmt");
			var ActualPayInteAMT=getItemValue(0,i,"ActualPayInteAMT");
			var ActualPayFineAMT=getItemValue(0,getRow(),"ActualPayFineAMT");
			var ActualPayCompdInteAMT=getItemValue(0,i,"ActualPayCompdInteAMT");
			var sActualAll=ActualPayPrincipalAmt+ActualPayInteAMT+ActualPayFineAMT+ActualPayCompdInteAMT;
			setItemValue(0,i,"ActualAll",sActualAll);
		}
	}
	/*~[Describe=页面分页赋值;InputParam=无;OutPutParam=无;]~*/
	function MR1_s(myobjname,myact,my_sortorder,sort_which,need_change){
		if(!beforeMR1S(myobjname,myact,my_sortorder,sort_which,need_change)) return;
	 	var s = getDWData(myobjname,myact);
	 	if(typeof(s)!="undefined") my_load(2,0,myobjname);
	 	initRow();
	}
	</script>


<script	language=javascript>
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	initRow();
</script>


<%@	include file="/IncludeEnd.jsp"%>