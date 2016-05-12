<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: --客户财务报表分析
		Input Param:
			  CustomerID：--当前客户编号
		Output Param:
			  CustomerID：--当前客户编号
			
		HistoryLog:
		--fbkang 2005.7.21,页面调整和修改
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "财务分析"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	
	//获得组件参数，客户代码
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

%>
<%/*~END~*/%>


<%
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CustomerFAList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
			{"true","","Button","杜邦分析","杜邦分析","dupondInfo()",sResourcesPath},
			{"true","","Button","结构分析","结构分析","structureInfo()",sResourcesPath},
			{"true","","Button","指标分析","指标分析","itemInfo()",sResourcesPath},
			{"true","","Button","趋势分析","趋势分析","trendInfo()",sResourcesPath}
	  };
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=杜邦分析;InputParam=客户代码;OutPutParam=无;]~*/
	function dupondInfo()
	{   
		var sReportDate=getItemValue(0,getRow(),"ReportDate");

		if(typeof(sReportDate)=="undefined" || sReportDate.length==0){
		//返回值：报表的年月
			alert("请选择要分析的报表！");
		}else{
			//sMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=16;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;scrollbar:yes");
			//if(typeof(sMonth)=="undefined" || sMonth=="_none_" || sReturnValue == null)	 return;
			PopComp("DBAnalyse","/CustomerManage/FinanceAnalyse/DBAnalyse.jsp","CustomerID=<%=sCustomerID%>&AccountMonth="+sReportDate);
		}
	}
	
	/*~[Describe=结构分析;InputParam=客户代码;OutPutParam=无;]~*/
	function structureInfo(){
	    //返回值：报表的期数、报表的年月、报表范围
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm.jsp?CustomerID=<%=sCustomerID%>","","dialogWidth=40;dialogHeight=30;minimize:no;maximize:no;status:yes;center:yes");
	    if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_"  || sReturnValue == null)	return;
		PopComp("StructureMain","/CustomerManage/FinanceAnalyse/StructureView.jsp","CustomerID=<%=sCustomerID%>&Term=" + sReturnValue);
	}

	/*~[Describe=指标分析;InputParam=客户代码;OutPutParam=无;]~*/
	function itemInfo(){
	    //返回值：报表的期数、报表的年月、报表范围
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm.jsp?CustomerID=<%=sCustomerID%>","","dialogWidth=40;dialogHeight=30;minimize:no;maximize:no;status:yes;center:yes");
	    if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_" || sReturnValue == null) return;
		PopComp("ItemDetail","/CustomerManage/FinanceAnalyse/ItemView.jsp","CustomerID=<%=sCustomerID%>&Term="+sReturnValue);
	}

	/*~[Describe=趋势分析;InputParam=客户代码;OutPutParam=无;]~*/
	function trendInfo(){
	    //返回值：报表的期数、报表的年月、报表范围
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm_Trend.jsp?CustomerID=<%=sCustomerID%>","","dialogWidth=40;dialogHeight=30;minimize:no;maximize:no;status:yes;center:yes");
		if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_" || sReturnValue == null) return;
		PopComp("TrendMain","/CustomerManage/FinanceAnalyse/TrendView.jsp","CustomerID=<%=sCustomerID%>&Term="+sReturnValue);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
