<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jacky hao 2005-07-28
 * Tester:
 *
 * Content: 
 *          提交一个预警处理任务
 *          不可以单步提交 
 * Input Param:
 *      ScenarioNo:	预警的场景ID，如审批等
 *      ObjectType:	参数类型，如类型为审批流水号
 *      ObjectNo: 	参数值，如审批流水号
 *		
 *      
 * Output param:
 *      ReturnValue:    预警提交是否成功
 * History Log:  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	boolean bOneStep = false;
	//获得参数	
	String sScenarioNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ScenarioNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	//风险提示	
	ASAlarmScenario altsce = new ASAlarmScenario(sScenarioNo,sObjectType,sObjectNo,Sqlca,CurUser,bOneStep);
	String sScenarioName,sScenarioDescribe;
	sScenarioName = altsce.getName();
	sScenarioDescribe = altsce.getDescribe();
	int i=0;
%>
<html>
	
<head>
<title>符合性条件判断</title>
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
		          <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","运行","单步提交运行","javascript:runAlarmModel();",sResourcesPath)%>
			</td>
		  </span>
		<%}%>
		  <span id=al_exit style="display:none">
			<td>
		          <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","退出","预警检查终止","javascript:alarm_exit();",sResourcesPath)%>
			</td>
		  </span>
		  <span id=al_next style="display:none">
			<td>
		          <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","提交预警","提交预警操作","javascript:alarm_act_submit();",sResourcesPath)%>
			</td>
		  </span>
		</tr>
	</table>
  </tr>
  <tr>
    <td width="100%" valign="top"> 
	场景名称：<%=sScenarioName%><br>场景描述：<%=sScenarioDescribe%>
	  <table width="100%" border="1" cellspacing="0" cellpadding="0"  bordercolordark="#FFFFFF">
		<tr bgcolor=#fafafa>
			<td>&nbsp;</td>	
			<td>&nbsp;</td>
			<td>模型名称</td>
			<td>&nbsp;</td>
			<td>模型描述</td>
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
		<td>指定运<br>行时间 </td>	
		<td>&nbsp;<input type="checkbox" value ="1" name="tellTime"></td>
		<td>&nbsp;日期&nbsp;&nbsp;<input tpye="text" name="runDate"></td>
		<td>&nbsp;</td>
		<td>&nbsp;时间&nbsp;&nbsp;<input tpye="text" name="runTime"></td>
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
           	alert("好像是个奇怪的错误！");
           	return;
       	}else if (sReturn >= 0){ //成功 
			alert("提交成功啦，庆祝一下！");  
           	top.returnValue = 0;
     		self.close();  
       	}else{  //失败
           	alert("呜呜，又失败了 :..( ");
           	return;
		}
	}
</script>

<%@ include file="/IncludeEnd.jsp"%>