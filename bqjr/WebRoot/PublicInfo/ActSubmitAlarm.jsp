<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.alert.ASAlarmScenario"%>
<%@page import="com.amarsoft.are.task.taskscheduler.*"%>
<%@page import="com.amarsoft.are.task.taskscheduler.helpers.TriggerUtils"%>
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
<%
	boolean bOneStep = false;
	//��ò���	
	String sScenarioNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ScenarioNo")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sOneStepRun = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OneStepRun"));
	String sUserID=CurUser.getUserID();
	String sOrgID=CurUser.getOrgID();
	sOneStepRun="no"; 
	String sSerialNo="";  

    //������ʾ	
	ASAlarmScenario altsce = new ASAlarmScenario(sScenarioNo,sObjectType,sObjectNo,Sqlca,CurUser,bOneStep);
	String sScenarioName;
	sScenarioName = altsce.getName();
    sSerialNo=altsce.getScenarioNo(); 
  	   
    SchedulerFactory sf=   new com.amarsoft.are.task.taskscheduler.impl.ASClientSchedulerFactory();
    Scheduler sched = sf.getScheduler();      
    String jobGroupName=sScenarioNo;
    String jobName=sSerialNo;
    String triggerGroupName=sScenarioNo;
    String triggerName=sSerialNo;
    long ts = TriggerUtils.getNextGivenSecondDate(null, 1).getTime();

    JobDetail job = new JobDetail( jobName,jobGroupName, ASAlartTask.class);	  
  
	job.getJobDataMap().put("ScenarioNo",sScenarioNo);
	job.getJobDataMap().put("ObjectType",sObjectType);
	job.getJobDataMap().put("ObjectNo",sObjectNo);
	job.getJobDataMap().put("OneStepRun",sOneStepRun);
	job.getJobDataMap().put("UserID",sUserID);
	job.getJobDataMap().put("OrgID",sOrgID);
	job.getJobDataMap().put("SerialNo",sSerialNo);
	
	java.util.Date triggerTime=new java.util.Date(ts);
	SimpleTrigger trigger = new SimpleTrigger(triggerName, triggerGroupName,triggerTime);
	TaskProgress taskProgress=new TaskProgress();
	taskProgress.setTriggerName(trigger.getName());
	taskProgress.setGroupName(trigger.getGroup());
	taskProgress.setDescription(sScenarioName);//jacky hao 2005-08-01 charset
	taskProgress.setUserId(sUserID);
	taskProgress.setCreateDate(TriggerUtils.getNextGivenSecondDate(null, 0).getTime());
	taskProgress.setCurrExecProgress(0);
	
	sched.addTaskProgress(taskProgress);	   
    sched.scheduleJob(job, trigger);
%>
<html>
<head>
</head>
<body onkeydown=mykd1 >
	<iframe name="myprint10" width=0% height=0% style="display:none" frameborder=1></iframe>
</body>
</html>

<script type="text/javascript">
	self.returnValue = 1;
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>