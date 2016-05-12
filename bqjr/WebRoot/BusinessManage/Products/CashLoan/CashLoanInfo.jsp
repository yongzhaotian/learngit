<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
	<%
	String PG_TITLE = "交叉现金贷活动维护"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得页面参数	：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//活动序号
	if(sSerialNo==null) sSerialNo="";
	String sEventStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EventStatus"));//活动状态
	if(sEventStatus==null) sEventStatus="";

	
	// 通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("CashLoanInfo",Sqlca);//交易定义详情模板
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly="0";
	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","保存","保存","SaveRecord()",sResourcesPath},
		{"true","","Button","返回","返回","goBack()",sResourcesPath},
	};
	//未开始的活动
	if("01".equals(sEventStatus))
	{
		sButtons[0][0] = "true";
	}
	%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>

	// 返回交易列表
	function goBack()
	{
		self.close();
	}
	
	function SaveRecord(){
		var sdate = getItemValue(0,getRow(),"BEGINDATE"); //开始日期
		var edate = getItemValue(0,getRow(),"ENDDATE"); //结束日期
		if (sdate != '' && edate != '') {
			sdate = sdate.split('/'); //用的是时间控件格式是yyyy/MM/dd
			edate = edate.split('/');
			//因为当前时间的月份需要+1，故在此-1，不然和当前时间做比较会判断错误
			var start = new Date(sdate[0], sdate[1] - 1, sdate[2]); 
			var end = new Date(edate[0], edate[1] - 1, edate[2]);
			var date = new Date();//当前时间
			if (end <= date) {
				alert("结束日期必须大于当前日期");
				return;
			}
			if (start >= end) {
				alert("结束日期必须大于开始日期 ");
				return;
			}
		}
		
		as_save("myiframe0");
	}

	function initPage(){
		AsControl.OpenView("/BusinessManage/Products/CashLoan/CashLoanImportList.jsp","SerialNo=<%=sSerialNo%>&EventStatus=<%=sEventStatus%>","rightdown","");
	}
	
</script>	

<script language=javascript>
$(document).ready(function(){
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initPage();
});
</script>	

<%@ include file="/IncludeEnd.jsp"%>
