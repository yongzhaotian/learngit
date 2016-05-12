<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="org.jfree.data.category.CategoryDataset" %>
<%@ page import="org.jfree.data.category.DefaultCategoryDataset" %>
<%@ page import="org.jfree.chart.JFreeChart" %>
<%@ page import="org.jfree.chart.ChartRenderingInfo" %>
<%@ page import="org.jfree.chart.ChartFactory" %>
<%@ page import="org.jfree.chart.plot.PlotOrientation" %>
<%@ page import="org.jfree.chart.servlet.ServletUtilities" %>
<%@ page import="org.jfree.chart.entity.StandardEntityCollection" %>
<%@ page import="org.jfree.chart.ChartUtilities" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.awt.Color" %>
<%@ page import="org.jfree.chart.plot.CategoryPlot" %>

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

	 */
	%>
<%/*~END~*/%>

<%! 
	CategoryDataset createDataset(String itemStr, String monthStr, String valueStr) {
        // row keys...
        String items[] = itemStr.split("@");
        String months[] = monthStr.split("@");
        String values[] = valueStr.split("@");

        // create the dataset...
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        for (int i1 = 0; i1 < items.length; i1 ++) {
        	for (int i2 = months.length - 1; i2 >= 0; i2 --) {
        		double d = 0; //确省值用0代替
        		try {
        			d = Double.parseDouble(values[i1*months.length+i2]);
        		}
        		catch (Exception e) {
        		}
        		dataset.addValue(d,items[i1],months[i2]);
        	}
        }
        return dataset;
    }

    JFreeChart createBarChart(CategoryDataset dataset) {

        JFreeChart chart = ChartFactory.createBarChart3D(
                "财务分析柱状图显示",       // chart title
                "",               // domain axis label
                "人民币（万元）或百分比%",    // range axis label
                dataset,                  // data
                PlotOrientation.VERTICAL, // orientation
                true,                     // include legend
                true,                     // tooltips?
                false                     // URLs?
        );

        chart.setBackgroundPaint(Color.white);

        // get a reference to the plot for further customisation...
        CategoryPlot plot = (CategoryPlot) chart.getPlot();
        plot.setBackgroundPaint(Color.lightGray);
        plot.setDomainGridlinePaint(Color.white);
        plot.setDomainGridlinesVisible(true);
        plot.setRangeGridlinePaint(Color.white);

        return chart;
    }

    JFreeChart createLineChart(CategoryDataset dataset) {

        JFreeChart chart = ChartFactory.createLineChart3D(
                "财务分析折线图显示",       // chart title
                "",               // domain axis label
                "人民币（万元）或百分比%",    // range axis label
                dataset,                  // data
                PlotOrientation.VERTICAL, // orientation
                true,                     // include legend
                true,                     // tooltips?
                false                     // URLs?
        );

        chart.setBackgroundPaint(Color.white);

        // get a reference to the plot for further customisation...
        CategoryPlot plot = (CategoryPlot) chart.getPlot();
        plot.setBackgroundPaint(Color.lightGray);
        plot.setDomainGridlinePaint(Color.white);
        plot.setDomainGridlinesVisible(true);
        plot.setRangeGridlinePaint(Color.white);

        return chart;
    }
 %>
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
	String sMonthsScopes = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MonthsScopes"));//实现多口径后，要加上口径参数
	String sItemValues    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemValues"));
	String sGraphType	  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GraphType"));
    if (sItemValues==null || sItemValues.equals("")) {
    	sItemValues="0";
    }
    int iScreenWidth = 1024;
    int iScreenHeight = 768;
	String sScreenWidth	= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ScreenWidth"));
    if (sScreenWidth !=null && !sScreenWidth.equals("")) {
    	iScreenWidth = Integer.parseInt(sScreenWidth);
    }
	String sScreenHeight= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ScreenHeight"));
    if (sScreenHeight !=null && !sScreenHeight.equals("")) {
    	iScreenHeight = Integer.parseInt(sScreenHeight);
    }
%>	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=主页面的编写;]~*/%>
<%
	JFreeChart chart;
	if (sGraphType.equals("0")) {
		chart = createBarChart(createDataset(sItemNames,sMonthsScopes,sItemValues));
	}
	else {
		chart = createLineChart(createDataset(sItemNames,sMonthsScopes,sItemValues));
	}

	PrintWriter w = new PrintWriter(out);
	StandardEntityCollection sec = new StandardEntityCollection();
	ChartRenderingInfo info = new ChartRenderingInfo(sec);
	String fname = ServletUtilities.saveChartAsPNG(chart,iScreenWidth,iScreenHeight,info,session);
	ChartUtilities.writeImageMap(w,"map0",info,false);
	String graphURL = request.getContextPath()+"/chartview?filename="+fname;
%>
<html>
<head>
<title>图形展现</title>
</head>

<body bgcolor="#000000"  leftmargin="0" topmargin="0" oncontextmenu="return true" >
</body>
<P ALIGN="CENTER">
<img src="<%=graphURL %>" width="<%=iScreenWidth %>" height="<%=iScreenHeight %>" border="0" usemap="#map0">
</P>
</html>

<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>