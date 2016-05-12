<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMDAJAX.jsp"%><%@
 page import="com.amarsoft.biz.workflow.*" %><%@
 page import="com.amarsoft.amarscript.*" %><%
	/*
		Content: 提示下一阶段信息
		Input Param:
			SerialNo：当前任务的流水号
			PhaseAction：所选的下一步动作
			PhaseOpinion1：意见
		Output param:
			sReturnValue:	返回值Commit表示完成操作
	 */
	String sSerialNo = CurPage.getParameter("SerialNo");//从上个页面得到传入的任务流水号
	String oldPhaseNo = CurPage.getParameter("oldPhaseNo");//当前被提交业务所处阶段
	String objectType = CurPage.getParameter("objectType");//当前被提交业务所处流程中的流程对象类型
	String objectNo = CurPage.getParameter("objectNo");//当前被提交业务所处流程中的流程对象编号
	String sPhaseAction = CurPage.getParameter("PhaseAction");//从上个页面得到传入的动作信息
	String sPhaseOpinion1 = CurPage.getParameter("PhaseOpinion1");//从上个页面得到传入的意见信息
	//将空值转化成空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(oldPhaseNo == null) oldPhaseNo = "";
	if(objectType == null) objectType = "";
	if(objectNo == null) objectNo = "";
	if(sPhaseAction == null) sPhaseAction = "";
	if(sPhaseOpinion1 == null) sPhaseOpinion1 = "";
	String sReturnValue="";
	
	//定义变量：返回阶段信息、阶段名称
	String sPhaseInfo = "",sNextPhaseName = "",sNextPhaseNo = "",sNextPhaseNameStr="";
	String sToday = StringFunction.getTodayNow();

	//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）。 
	ASMethod	asm = new ASMethod("WorkFlowEngine","GetEndTime",Sqlca);//改用endtime作为校验字段 by qxu 2013/6/28
	Any anyValue  = asm.execute(sSerialNo);
	String endTime = anyValue.toString();
	
	if(endTime.length() > 0){
		sReturnValue= "Working";//该放贷申请已经提交了，不能再次提交！
	}else{
		//初始化任务对象
		FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
		//执行提交操作
		FlowPhase flowphase = null;
		FlowPhase[] fpFlow = ftBusiness.commitAction(sPhaseAction,sPhaseOpinion1);
		
		for(int i=0;i<fpFlow.length;i++)
		{
			flowphase = fpFlow[i];
			//获取下一阶段的阶段名称
			sNextPhaseName = flowphase.PhaseName;
			sNextPhaseNo = flowphase.PhaseNo;
			sNextPhaseNameStr += sNextPhaseName+";";
		}
		
		//拼出提示信息
		sPhaseInfo="下一阶段:";
		sPhaseInfo = sPhaseInfo+" " + sNextPhaseNameStr;		
		if (sPhaseInfo!=null && sPhaseInfo.trim().length()>0){
			sReturnValue="Success";
		}else{
			sReturnValue="Failure";
		}
		if("8000".equals(sNextPhaseNo)&&"TransFeeFlow".equals(ftBusiness.FlowNo)){//费用减免 已否决 010，更新费用减免费表状态
			String updateSql = "update acct_fee_waive afw set afw.status='0' where afw.remark=:serialno and afw.status='1'";
			Sqlca.executeSQL(new SqlObject(updateSql).setParameter("serialno", ftBusiness.ObjectNo));
		}//add by jiangyuanlin 20150805 修改费用减免否决后，不能再次申请
		// add by tbzeng 2014/07/11
		//下阶段为批准、附条件批准，更新合同状态
		String sSql = "";
		if(sNextPhaseNo.equals("1000") || sNextPhaseNo.equals("2000")){//已批准 080
			sSql = "update business_contract set contractstatus = '080' where SerialNo = :Serialno";
		}else if(sNextPhaseNo.equals("8000")){//已否决 010
			sSql = "update business_contract set contractstatus = '010' where SerialNo = :Serialno";
		}else if(sNextPhaseNo.equals("9000")){//已取消
			sSql = "update business_contract set contractstatus = '100' where SerialNo = :Serialno";
		}else{//新发生
			if (!sNextPhaseNo.equals("0010")) {
				sSql = "update business_contract set contractstatus = '070' where SerialNo = :Serialno";
			} else {
				sSql = "update business_contract set contractstatus = '060' where SerialNo = :Serialno";
			}
		}
		
		if (sSql!=null && sSql.length() > 0) {
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("Serialno", objectNo));
			Sqlca.commit();
		}
		// end 2014/07/11
	}
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>