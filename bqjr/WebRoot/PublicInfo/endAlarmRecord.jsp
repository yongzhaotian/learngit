<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-05-25
 * Tester:
 *
 * Content: 
 *          ��Session������ƶ�����
 *           
 * Input Param:
 *      SessionAttr:	��������
 *      
 * Output param:
 *
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//��ò���	
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
		
		//���ٶ���
		altsce = null;
	}
	if( !bOneStep )
		session.removeAttribute(sSessionAttr);
%>

<script type="text/javascript">
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>