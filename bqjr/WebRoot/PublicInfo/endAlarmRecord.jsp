<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-05-25
 * Tester:
 *
 * Content: 
 *          从Session中清楚制定变量
 *           
 * Input Param:
 *      SessionAttr:	变量名称
 *      
 * Output param:
 *
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//获得参数	
	boolean bOneStep = false;
	String sSessionAttr = DataConvert.toRealString(iPostChange,(String)request.getParameter("SessionAttr")); 
	String sOneStepRun = DataConvert.toRealString(iPostChange,(String)request.getParameter("OneStepRun"));
	if( sSessionAttr == null ) sSessionAttr = "";
	if( sOneStepRun!=null && sOneStepRun.equalsIgnoreCase("yes") )
		bOneStep = true;

	if( "CurAlarmSce".equals(sSessionAttr) ){
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");
		if( !bOneStep )
			altsce.updateRecord(Sqlca);
		
		//销毁对象
		altsce = null;
	}
	if( !bOneStep )
		session.removeAttribute(sSessionAttr);
%>

<script type="text/javascript">
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>