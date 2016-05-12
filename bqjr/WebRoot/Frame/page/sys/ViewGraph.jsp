<%@ page contentType="image/png; charset=GBK"%>
<%@ page language="java"
	import="java.io.File,java.awt.image.BufferedImage,javax.imageio.ImageIO,java.awt.GraphicsEnvironment,
			com.amarsoft.app.als.process.action.BusinessProcessAction,
			com.amarsoft.app.als.process.ProcessService,
			com.amarsoft.app.als.process.ProcessServiceFactory,
			com.amarsoft.core.util.FileUtil,
			com.amarsoft.core.util.StringUtil,java.net.*,com.amarsoft.flow.*"%>

<%
	if (!GraphicsEnvironment.isHeadless()) { 
		System.setProperty("java.awt.headless", "true"); 
	 }

	//获得参数
	String sProcessDefID = request.getParameter("ProcessDefID");//流程定义编号
	if(sProcessDefID == null) sProcessDefID = "";
	String sProcessTaskID = request.getParameter("ProcessTaskID");//流程任务编号
	if(sProcessTaskID == null) sProcessTaskID = "";
	
	System.out.println("【ProcessDefID】="+sProcessDefID);
	System.out.println("【ProcessTaskID】="+sProcessTaskID);
	
	ProcessService ps = ProcessServiceFactory.getService();
	String sResult = ps.getFlowImage(sProcessDefID, sProcessTaskID);
	response.reset();
	ServletOutputStream out2 = response.getOutputStream();
	StringUtil.string2Stream(sResult,out2);
	out2.flush();
	out2.close();
	out.clear(); 
	out = pageContext.pushBody(); 
%>

