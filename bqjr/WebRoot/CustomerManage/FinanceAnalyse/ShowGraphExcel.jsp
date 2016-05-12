<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:--
		Tester:--
		Content: --客户财务分析图像
		Input Param:
		        --ItemNames    ：报表的名称
		        --AccountMonths：报表月份
		        --ItemValues   ：报表值
		        --GraphType    ：图像类型
		Output param:
		History Log: 
		  DATE	  CHANGER		CONTENT
           2005-7-25 fbkang     修改新版本

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "财务分析图像表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
   //定义变量
   
   //获得页面参数，报表名称、报表月份、报表值、图像类型
	String sItemNames     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNames"));
	//String sAccountMonths = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonths"));//原来的方法，没有多口径，只要一个月份参数就可以了
	String sMonthsScopes = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MonthsScopes")); //实现多口径后，要加上口径参数
	String sItemValues    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemValues"));
	String sGraphType	  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GraphType"));
    //获得组件参数	
    if (sItemValues.equals("")||sItemValues==null)
    sItemValues="0";

%>	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=主页面的编写;]~*/%>

<html>
<head>
<title>图形展现</title>
</head>

<body bgcolor="#000000"  leftmargin="0" topmargin="0" oncontextmenu="return true" >
<br>
<table width='98%' align='center' border="0" cellspacing="0" cellpadding="0" height="90%" bgcolor='#FFFFFF'>
  <tr width="100%" height="100%" valign='top'> 
    <td align='left' width="50%">
    	<!-- <object classid="clsid:0002E500-0000-0000-C000-000000000046" id="ChartSpace1" 
			codebase="file:\\server\office2000\Msowc.cab#version=9,0,0,2710" width="100%" height="100%"  align="left">
      	</object> -->
      	<object classid="CLSID:0002E55D-0000-0000-C000-000000000046" height=100% id="ChartSpace1"
			style="LEFT: 0px; TOP: 0px" width="100%" codebase="<%=sWebRootPath%>/FixStat/OWC11.DLL#version=0,0,0,0">
      	</object>
    </td>
  </tr>
</table>

</body>
</html>

<script type="text/javascript">
	itemnames = "<%=sItemNames%>";				//"货币资金@短期投资@存货（净额）"
	accountmonths = "<%=sMonthsScopes%>";		//"2001/12@2002/12"
	itemvalues = "<%=sItemValues%>";			//"1000@2200@6@31@5@14"
	
	ss = itemvalues.split("@");
	iMax = 100;
	iMin = 0;
	for(k=0;k<ss.length;k++)
	{
		if(ss[k]!="") 
		{
			iMax = Math.max(parseInt(ss[k],10)+1,iMax);
			iMin = Math.min(parseInt(ss[k],10),iMin);
		}
	}
</script>

<script language=vbscript >

	seriesNames = split(itemnames,"@")
	categories = split(accountmonths,"@")
	values = split(itemvalues,"@")
	one_values = split(itemvalues,"@")
	
	Set cht = ChartSpace1.Charts.Add
	cht.HasLegend = True 
	cht.Legend.Font.size=9 
	
	Set c = ChartSpace1.Constants
	'cht.Type = c.chChartTypeColumnClustered
	cht.Type = <%=sGraphType%>
	
	cht.SetData c.chDimSeriesNames, c.chDataLiteral, seriesNames
	cht.SetData c.chDimCategories, c.chDataLiteral, categories
	
	
	for i = 0 to UBound(seriesNames)
	
		for j = 0 to UBound(categories)
			one_values(j) = values(i*(UBound(categories)+1)+j)
			if one_values(j)="" then one_values(j) = 0  '无值用0代替
		next 
		
		cht.SeriesCollection(i).SetData c.chDimValues, c.chDataLiteral, one_values
		cht.SeriesCollection(i).DataLabelsCollection.Add
		cht.SeriesCollection(i).DataLabelsCollection(0).Font.Size = 9
		cht.SeriesCollection(i).DataLabelsCollection(0).NumberFormat = "#,###,##0.00"
	next 
	
	'设置图表显示字体及数据轴格式 
	'set ax = ChartSpace1.Charts(0).Axes(c.chAxisPositionBottom) 
	set ax = cht.Axes(c.chAxisPositionBottom) 
	ax.Font.Size = 9 
	ax.HasTitle = True 
	ax.Title.Caption = "报表时间" 
	ax.Title.Font.Size = 9 
	'ax.Title.Font.Color = "red"
	
	set ax = cht.Axes(c.chAxisPositionLeft) 
	ax.Font.Size = 9 
	ax.HasTitle = True 
	ax.Title.Caption = "人民币（万元）或百分比%" 
	ax.Title.Font.Size = 9 
	ax.NumberFormat = "#,###,##0.0" 	
	ax.CrossesAtValue = 0

	Set axisScale = ax.Scaling
	axisScale.Minimum = iMin + round((iMin - iMax)/10)
	axisScale.Maximum  = iMax + round((iMin + iMax)/10)

	'if iMin<0 and iMax>0 then
	'	Set c = ChartSpace1.Constants
	'	Set valueAxis = ChartSpace1.Charts(0).Axes(c.chAxisPositionLeft)
	'	Set categoryAxis = ChartSpace1.Charts(0).Axes(c.chAxisPositionBottom)
	'	valueAxis.CrossingAxis = categoryAxis
	'	categoryAxis.CrossesAtValue = 0
	'end if

	'设置指定坐标轴的刻度方向。
	ChartSpace1.Charts(0).Axes(1).Scaling.Orientation = c.chScaleOrientationMaxMin
	
	
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
