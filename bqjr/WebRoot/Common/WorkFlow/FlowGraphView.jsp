<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.workflow.graph.FlowGraphService" %>
<%@page import="java.awt.image.BufferedImage,javax.imageio.ImageIO"%>


<html>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载附件，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>

</body>
</html>
<%
	String sObjectNo = DataConvert.toString((String)CurComp.getParameter("ObjectNo"));
	String sFlowNo = DataConvert.toString((String)CurComp.getParameter("FlowNo"));
	if(sObjectNo == null) sObjectNo = "";
	if(sFlowNo == null) sFlowNo = "";
	
	if(!"".equals(sObjectNo) || !"".equals(sFlowNo)){
		FlowGraphService fs = new FlowGraphService(Sqlca);
  		BufferedImage bufferedImage = fs.getFlowBufferedImage(sObjectNo,sFlowNo);
  		ServletOutputStream outputStream = response.getOutputStream();
  		ImageIO.write(bufferedImage, "gif", outputStream);
  		outputStream.flush();
  		outputStream.close();
  		
  		out.clear(); 
  	  	out = pageContext.pushBody(); 
	}

%>

<%@ include file="/IncludeEnd.jsp"%>
