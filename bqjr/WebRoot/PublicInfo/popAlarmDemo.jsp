<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          预警处理提示处理样例模板
 *           
 * Input Param:
 *      altsce:			从Session中抓取预警对象
 *      sModelNo:		从requst中获取当前处理的模型编号
 *      
 * Output param:
 *      ReturnValue:    预警检查处理通过否，用'$'分割，前两位数字处理方式编号，后提示字符串
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sResult;
	//获得参数	自己按需要获取
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

//风险提示	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		//获得参数
		String sApplySerialNo = altsce.getArgValue("ApplySerialNo");
		
		//处理过程
		System.out.println("haha............test"+sModelNo);
		
		//设置参数
		//altsce.setArgValue("ApplyNo",sObjectNo);
		
		//设置返回值
		sResult = "99$没什么可说得";
	
	}catch(Exception ea){
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