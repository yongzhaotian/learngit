<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ��������ʾ��������ģ��
 *           
 * Input Param:
 *      altsce:			��Session��ץȡԤ������
 *      sModelNo:		��requst�л�ȡ��ǰ�����ģ�ͱ��
 *      
 * Output param:
 *      ReturnValue:    Ԥ����鴦��ͨ������'$'�ָǰ��λ���ִ���ʽ��ţ�����ʾ�ַ���
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sResult;
	//��ò���	�Լ�����Ҫ��ȡ
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

//������ʾ	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		//��ò���
		String sApplySerialNo = altsce.getArgValue("ApplySerialNo");
		
		//�������
		System.out.println("haha............test"+sModelNo);
		
		//���ò���
		//altsce.setArgValue("ApplyNo",sObjectNo);
		
		//���÷���ֵ
		sResult = "99$ûʲô��˵��";
	
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