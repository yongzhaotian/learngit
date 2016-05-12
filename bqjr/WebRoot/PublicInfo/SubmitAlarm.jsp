<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jacky hao 2005-07-28
 * Tester:
 *
 * Content: 
 *          �ύһ��Ԥ����������
 *          �����Ե����ύ 
 * Input Param:
 *      ScenarioNo:	Ԥ���ĳ���ID����������
 *      ObjectType:	�������ͣ�������Ϊ������ˮ��
 *      ObjectNo: 	����ֵ����������ˮ��
 *		
 *      
 * Output param:
 *      ReturnValue:    Ԥ���ύ�Ƿ�ɹ�
 * History Log:  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	boolean bOneStep = false;
	//��ò���	
	String sScenarioNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ScenarioNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	//������ʾ	
	ASAlarmScenario altsce = new ASAlarmScenario(sScenarioNo,sObjectType,sObjectNo,Sqlca,CurUser,bOneStep);
	String sScenarioName,sScenarioDescribe;
	sScenarioName = altsce.getName();
	sScenarioDescribe = altsce.getDescribe();
	int i=0;
%>
<html>
	
<head>
<title>�����������ж�</title>
<script type="text/javascript">
top.returnValue = 0;
</script>
<style type="text/css">
<!--
textarea {  height: 60px; width: 100%; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px}
-->
</style>
</head>
<body bgcolor="#EAEAEA" >
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
	<table>
		<tr>
		<%if(bOneStep){%>
		  <span id=al_run style="display:none">
			<td>
		          <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","����","�����ύ����","javascript:runAlarmModel();",sResourcesPath)%>
			</td>
		  </span>
		<%}%>
		  <span id=al_exit style="display:none">
			<td>
		          <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�˳�","Ԥ�������ֹ","javascript:alarm_exit();",sResourcesPath)%>
			</td>
		  </span>
		  <span id=al_next style="display:none">
			<td>
		          <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","�ύԤ��","�ύԤ������","javascript:alarm_act_submit();",sResourcesPath)%>
			</td>
		  </span>
		</tr>
	</table>
  </tr>
  <tr>
    <td width="100%" valign="top"> 
	�������ƣ�<%=sScenarioName%><br>����������<%=sScenarioDescribe%>
	  <table width="100%" border="1" cellspacing="0" cellpadding="0"  bordercolordark="#FFFFFF">
		<tr bgcolor=#fafafa>
			<td>&nbsp;</td>	
			<td>&nbsp;</td>
			<td>ģ������</td>
			<td>&nbsp;</td>
			<td>ģ������</td>
		</tr>
        <%
		String sModelNo,sDealMethod,sModelType,sModelName,sDescribe,sAlarmDescribe;
		String[] sKeys = altsce.getModelKeys();
		for (i=0;i< sKeys.length;i++){
			sModelNo = sKeys[i];
			sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
			sModelName = altsce.getModelAttribute(sModelNo,"AlarmModelName");
			sAlarmDescribe = altsce.getModelAttribute(sModelNo,"AlarmDescribe");
		%>
		<tr bgcolor=#fafafa>
			<td width='10%'>
				<span id=<%=i%>d style="display:none"><strong><img src=<%=sResourcesPath%>/logo.jpg></span>
			</td>	
		    <td align=center width='5%'>
				  
		    </td>
		    <td width='30%'>
		    	<%=sModelName%>
		    </td>
			<td width='5%'>
				 
			</td>	
			<td width='50%'>
				<%=sAlarmDescribe%> 
			</td>	
		</tr>
		<%
  		}
		%>
		<tr>
		<td>&nbsp;</td>	
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		</tr>
		<tr bgcolor=#fafafa>
		<td>ָ����<br>��ʱ�� </td>	
		<td>&nbsp;<input type="checkbox" value ="1" name="tellTime"></td>
		<td>&nbsp;����&nbsp;&nbsp;<input tpye="text" name="runDate"></td>
		<td>&nbsp;</td>
		<td>&nbsp;ʱ��&nbsp;&nbsp;<input tpye="text" name="runTime"></td>
	    </tr>
      </table>
	</td>
  </tr>
</table>
</body>
</html>

<script type="text/javascript">
	oldRtn = 99;
	curRtn = 0;
	 
	function alarm_exit(){
		top.returnValue = 0;
		self.close();
	}

	function alarm_act_submit(){
	    sReturn = PopPage( "/PublicInfo/ActSubmitAlarm.jsp","OneStepRun=yes&ScenarioNo="+<%=sScenarioNo%>+"&ObjectType=ApplySerialNo","dialogWidth=40;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no","");
		if (typeof(sReturn)== 'undefined' || sReturn.length == 0){
           	alert("�����Ǹ���ֵĴ���");
           	return;
       	}else if (sReturn >= 0){ //�ɹ� 
			alert("�ύ�ɹ�������ףһ�£�");  
           	top.returnValue = 0;
     		self.close();  
       	}else{  //ʧ��
           	alert("���أ���ʧ���� :..( ");
           	return;
		}
	}
</script>

<%@ include file="/IncludeEnd.jsp"%>