<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-05-25
 * Tester:
 *
 * Content: 
 *          预警处理提示处理
 *           
 * Input Param:
 *      AlarmModelNo:	预警模型ID
 *      CurAlarmSce:	保存到session中的对象
 *		OneStepRun:		Yes/No 是否可以单步提交
 *      
 * Output param:
 *      ReturnValue:    预警检查处理通过否
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//获得参数	
	boolean bOneStep = false;
	String AlarmModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	String sOneStepRun = DataConvert.toRealString(iPostChange,(String)request.getParameter("OneStepRun"));
	if( sOneStepRun!=null && sOneStepRun.equalsIgnoreCase("yes") )
		bOneStep = true;
	String sResult="";

//风险提示	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");
	
		//altsce.setArgValue("ApplyNo",sObjectNo);
		sResult = altsce.triggerAlarm(AlarmModelNo,Sqlca);
	}catch(Exception ea){
		ea.printStackTrace();
		sResult="10$"+ea.getMessage();
	}
%>
<html>
<head>
</head>
<body onkeydown=mykd1 >
	<iframe name="myprint10" width=0% height=0% style="display:none" frameborder=1></iframe>
</body>
</html>

<script type="text/javascript">
	self.returnValue = "<%=SpecialTools.real2Amarsoft(sResult)%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>