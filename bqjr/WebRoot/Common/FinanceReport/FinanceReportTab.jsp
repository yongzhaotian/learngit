<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   qfang 2011-5-30 20:35
		Tester:
		Content: 用于显示一期所有的财务报表
		Input Param:
                
		Output param:
			qfang 2011-06-13 增加传递参数"报表日期"：ReportDate
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "财务报表一览"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	

	//获得页面参数	
	String sObjectNo = "",sObjectType = "",sReportDate = "",sRole = "",sRecordNo = "",sReportScope = "";
	//对象编号 暂时为客户号
	sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sReportDate =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate"));
    sRole =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Role"));
    sRecordNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	sReportScope =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportScope"));
	String sEditable =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Editable"));
	
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sReportDate == null) sReportDate = "";
	if(sRole == null) sRole = "";
	if(sRecordNo == null) sRecordNo = "";
	if(sReportScope == null) sReportScope = "";
	if(sEditable == null) sEditable = "";
	
	%>
<%/*~END~*/%>     

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script type="text/javascript">
	var tabstrip = new Array();
  	<%
		String sSql = "",sReportName = "",sReportType = "",sReportNo = "",sVisibleFlag = "",sModelClass = "";
		String sCustomerName = "",sTitle = "";
		ASResultSet rs ;
		int initTab = 1;//设定默认的 tab ，数值代表第几个tab
		
		//设定标题
		sSql = "select CustomerName from CUSTOMER_INFO where CustomerID = '"+sObjectNo+"'";
		rs = Sqlca.getResultSet(sSql);
		if(rs.next())
		{
			sCustomerName = rs.getString("CustomerName");
		}
		rs.getStatement().close();
		
		sTitle = sCustomerName +"  "+sReportDate.substring(0,4)+"年"+sReportDate.substring(5,7)+"月 财务报表";
		
		//取得对应的报表类型
		sSql =  " select 'true',ReportName,'doTabAction('''||ReportNo||''')',ReportNo,ReportDate from REPORT_RECORD "+
				" where ObjectType = '"+sObjectType+"' "+
				" and ObjectNo = '"+sObjectNo+"' "+
				" and ReportScope = '"+sReportScope+"' "+
				" and ReportDate = '"+sReportDate+"' "+							
				" order by ModelNo";
		
		//利用sql语句初始化tab 组
		String sTabStrip[][] = HTMLTab.getTabArrayWithSql(sSql,Sqlca);
		
		//根据定义组生成 tab
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('tabtd')"));

		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=yes";

	%>

</script>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title><%=sTitle%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground" onBeforeUnload="unloadCheck()">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script type="text/javascript">
  	function doTabAction(sReportNo)
  	{
		// add by byhu 20050328: 离开未保存提示
		try{
			if(typeof(<%=sIframeName%>.dataModified)=="undefined" || <%=sIframeName%>.dataModified==false){
			}else if(<%=sIframeName%>.dataModified==true && confirm(sUnloadMessage)){
			}else{
				return false;
			}
			
		}catch(e){
		}
		// end

		if(sReportNo=="goBack"){
  			if(confirm(getHtmlMessage('14'))){//你确实要退出吗？
				self.close();
			}else{
				return false;
			}
  		}else{	//增加了两个Tab页：报表说明和客户资产与负债明细
  			sModelNo = PopPageAjax("/CustomerManage/EntManage/FindModelType.jsp?ReportNo="+sReportNo+"","","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");	
  			var reportDate = "<%=sReportDate%>";
  			if(sModelNo == "00") {
				//进入报表说明界面
				sReback="false";
				OpenComp("ReportDescribe","/CustomerManage/EntManage/ReportDescribe.jsp","Role=<%=sRole%>&CustomerID=<%=sObjectNo%>&RecordNo=<%=sRecordNo%>&ReportDate=<%=sReportDate%>&ReportNo="+sReportNo+"&Editable="+"<%=sEditable%>","<%=sIframeName%>","");
			}else if(sModelNo == "01"){
				//进入客户资产与负债明细页面
				sReback="false";
				OpenComp("FSdescribeView","/CustomerManage/EntManage/FSdescribeView.jsp","Role=<%=sRole%>&CustomerID=<%=sObjectNo%>&RecordNo=<%=sRecordNo%>&ReportDate=<%=sReportDate%>&ReportNo="+sReportNo+"&Editable="+"<%=sEditable%>","<%=sIframeName%>","");
			}else{
  				OpenComp("ReportData","/Common/FinanceReport/ReportData.jsp","Role=<%=sRole%>&CustomerID=<%=sObjectNo%>&RecordNo=<%=sRecordNo%>&ReportNo="+sReportNo+"&Editable="+"<%=sEditable%>","<%=sIframeName%>","");
				return true;
  			}
		}
  	}

	function unloadCheck(){
		try{
			if(<%=sIframeName%>.dataModified){
				event.returnValue=sUnloadMessage;
			}else{
			}
		}catch(e){
		}
	}

	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script type="text/javascript">
	//参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,<%=initTab%>,document.getElementById('<%=sTabID%>'));
	//设定默认页面
	<%=sTabStrip[initTab-1][2]%>
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
