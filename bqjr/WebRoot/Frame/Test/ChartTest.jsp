<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="org.jfree.data.general.PieDataset" %>
<%@ page import="org.jfree.data.general.DefaultPieDataset" %>
<%@ page import="org.jfree.chart.JFreeChart" %>
<%@ page import="org.jfree.chart.ChartRenderingInfo" %>
<%@ page import="org.jfree.chart.ChartFactory" %>
<%@ page import="org.jfree.chart.plot.PiePlot" %>
<%@ page import="org.jfree.chart.servlet.ServletUtilities" %>
<%@ page import="org.jfree.chart.entity.StandardEntityCollection" %>
<%@ page import="org.jfree.chart.ChartUtilities" %>
<%@ page import="java.io.PrintWriter" %>
<%!
    PieDataset createDataset() {
        DefaultPieDataset dataset = new DefaultPieDataset();
        dataset.setValue("流动一", new Double(43.2));
        dataset.setValue("固定二", new Double(10.0));
        dataset.setValue("三似乎", new Double(27.5));
        dataset.setValue("四", new Double(17.5));
        dataset.setValue("五", new Double(11.0));
        dataset.setValue("六", new Double(19.4));
        return dataset;
    }

    JFreeChart createChart(PieDataset dataset) {

        JFreeChart chart = ChartFactory.createPieChart(
            "饼图显示",  // chart title
            dataset,             // data
            true,               // include legend
            true,
            false
        );
        PiePlot plot = (PiePlot) chart.getPlot();
        plot.setSectionOutlinesVisible(false);
        plot.setNoDataMessage("No data available");

        return chart;

    }
 %>
<%
	JFreeChart chart = createChart(createDataset());
	PrintWriter w = new PrintWriter(out);
	StandardEntityCollection sec = new StandardEntityCollection();
	ChartRenderingInfo info = new ChartRenderingInfo(sec);
	String fname = ServletUtilities.saveChartAsPNG(chart,500,300,info,session);
	ChartUtilities.writeImageMap(w,"map0",info,false);
	String graphURL = request.getContextPath()+"/chartview?filename="+fname;
%>
<html>
<P ALIGN="CENTER">
<img src="<%=graphURL %>" width=500 height=300 border=0 usemap="#map0">
</P>
</html>
