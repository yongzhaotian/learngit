<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-05-25
 * Tester:
 *
 * Content: 
 *          Ԥ��������ʾ����
 *           
 * Input Param:
 *      AlarmModelNo:	Ԥ��ģ��ID
 *      CurAlarmSce:	���浽session�еĶ���
 *		OneStepRun:		Yes/No �Ƿ���Ե����ύ
 *      
 * Output param:
 *      ReturnValue:    Ԥ����鴦��ͨ����
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//��ò���	
	boolean bOneStep = false;
	String AlarmModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	String sOneStepRun = DataConvert.toRealString(iPostChange,(String)request.getParameter("OneStepRun"));
	if( sOneStepRun!=null && sOneStepRun.equalsIgnoreCase("yes") )
		bOneStep = true;
	String sResult="";

//������ʾ	
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