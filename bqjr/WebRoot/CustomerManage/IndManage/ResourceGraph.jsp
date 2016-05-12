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

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:-- xhgao 2009/10/28
		Tester:--
		Content: --ˮ����Ϣͼ��չʾ
		Input Param:
		        --GraphType    ��ͼ������
		        --ItemName	:չʾ������
		        --Caption    ��չʾ����
		        --hValue������ָ��
		        --vValue   ������ָ��
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
        		double d = 0; //ȷʡֵ��0����
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
                "��״ͼ��ʾ",       // chart title
                "",               // domain axis label
                "�Ȼ��",    // range axis label
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
                "����ͼ��ʾ",       // chart title
                "",               // domain axis label
                "�Ȼ��",    // range axis label
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
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ͼ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
   //�������
   
   //���ҳ�����
	String sGraphType	  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GraphType"));//ͼ������
    String sItemName     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemName"));//չʾ������
	String Caption     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Caption"));//չʾ����
	String shValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("hValue"));//����ָ��
	String svValue    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("vValue"));//����ָ��
	if (svValue==null || svValue.equals("")) {
		svValue="0";
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


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ҳ��ı�д;]~*/%>
<%
	JFreeChart chart;
	if (sGraphType.equals("0")) {
		chart = createBarChart(createDataset(sItemName,shValue,svValue));
	}else{
		chart = createLineChart(createDataset(sItemName,shValue,svValue));
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
<title>ͼ��չ��</title>
</head>

<body bgcolor="#000000"  leftmargin="0" topmargin="0" oncontextmenu="return true" >
</body>
<P ALIGN="CENTER">
<img src="<%=graphURL %>" width="<%=iScreenWidth %>" height="<%=iScreenHeight %>" border="0" usemap="#map0">
</P>
</html>

<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
