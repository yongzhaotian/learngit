<%@ page language="java"
	import="java.io.File,java.awt.image.BufferedImage,javax.imageio.ImageIO,java.awt.GraphicsEnvironment,
			com.amarsoft.app.als.process.action.BusinessProcessAction,
			com.amarsoft.app.als.process.ProcessService,
			com.amarsoft.app.als.process.ProcessServiceFactory,
			com.amarsoft.core.util.FileUtil,
			com.amarsoft.core.util.StringUtil,java.net.*,com.amarsoft.flow.*,com.amarsoft.core.object.*"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	if (!GraphicsEnvironment.isHeadless()) { 
		System.setProperty("java.awt.headless", "true"); 
	 }

	String sProcessDefID = CurPage.getParameter("ProcessDefID");
	if(sProcessDefID == null) sProcessDefID = "";
	String sProcessTaskID = CurPage.getParameter("ProcessTaskID");
	if(sProcessTaskID == null) sProcessTaskID = "";
	
	ARE.getLog().trace("ProcessDefID="+sProcessDefID);
	ARE.getLog().trace("ProcessTaskID="+sProcessTaskID);

	ProcessService ps = ProcessServiceFactory.getService();
	ps.restoreTask(sProcessDefID, sProcessTaskID);//流程引擎任务状态同步,防止引擎状态与应用不同步造成无法查看图形
	String[] aPosition = ps.getCoordinatesByDef(sProcessDefID, sProcessTaskID);
	
	
	ARE.getLog().trace(request.getContextPath()+"/Frame/page/sys/ViewGraph.jsp");
%>
<img src="<%=request.getContextPath()%>/Frame/page/sys/ViewGraph.jsp?ProcessDefID=<%=sProcessDefID %>&ProcessTaskID=<%=sProcessTaskID%>" style="position:absolute;left:0px;top:0px;">
<div style="position:absolute;border:1px solid red;left:<%=aPosition[0]%>px;top:<%=aPosition[1]%>px;width:<%=aPosition[2]%>px;height:<%=aPosition[3]%>px;"></div>
<%@ include file="/IncludeEnd.jsp"%>