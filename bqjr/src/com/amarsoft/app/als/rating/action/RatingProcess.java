package com.amarsoft.app.als.rating.action;

import com.amarsoft.app.als.rule.action.RuleOpAction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

public class RatingProcess {
	private String serialNo;
	private String flowNo;
	private String phaseNo;
	private String userID;
	private String orgID;
	private String phaseType;
	private String applyType;
	private String objectNo;
	private String objectType;
	private String applyNo;
	private String refModelID;
	
	/**
	 * 获取任务流水号
	 * @return
	 * @throws Exception
	 */
	public String getUnfinishedTaskNo() throws Exception{
		// 任务流水号
		String sSerialNo = null;
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bm = factory.getManager("jbo.sys.FLOW_TASK");
		BizObjectQuery bq = bm.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and FlowNo=:FlowNo and PhaseNo=:PhaseNo and userID =:userID and (PhaseAction is null or PhaseAction='') and (EndTime is null or EndTime ='')");
		bq.setParameter("ObjectType",objectType).setParameter("ObjectNo",objectNo).setParameter("FlowNo",flowNo).setParameter("PhaseNo",phaseNo).setParameter("userID",userID);
		BizObject bo = bq.getSingleResult(false);
		if(bo != null){
			sSerialNo = bo.getAttribute("SerialNo").getString();
		}else{
			throw new Exception("FLOW_TASK表中没有该条记录:ObjectType="+objectType+",ObjectNo="+objectNo+",FlowNo="+flowNo+",PhaseNo="+phaseNo+",userID="+userID);
		}
		return sSerialNo;
	}
	
	/**
	 * 启动评级
	 * @return
	 * @throws Exception
	 */
	public String startRating() throws Exception {
		//定义变量:用户名称、机构名称、流程名称、阶段名称、阶段类型、开始时间、任务流水号
		String sUserName = "";
		String sOrgName = "";
		String sFlowName = "";
		String sPhaseName = "";	
		String sPhaseType = "";
		String sBeginTime = "";
		JBOTransaction tx = JBOFactory.createJBOTransaction();
		BizObjectManager bm = null;
		BizObject bo = null;
		try {
		//--------------初始化模型记录---------------------------------------
		ARE.getLog().info("-----初始化模型规则记录开始-----");
		RuleOpAction roa = new RuleOpAction("rating_service");
		String recordID = roa.init(applyNo,refModelID,tx);
		if("null".equalsIgnoreCase(recordID)||recordID==null) throw new Exception("初始化模型规则失败");
		else{
			bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
			tx.join(bm);
			bo = bm.createQuery("RatingAppID=:RatingAppID").setParameter("RatingAppID",applyNo).getSingleResult(true);
			bo.setAttributeValue("RatingModRecordID",recordID);
			bo.setAttributeValue("Status","0");//0：申请阶段    ， 1：申请审批完成
			bm.saveObject(bo);
		}
		ARE.getLog().info("-----初始化模型规则记录结束-----");
		
		//--------------初始化流程开始---------------------------------
		ARE.getLog().info("-----初始化流程开始-----");
		if("CreditApply".equals(objectType)){
			//找出CustomerID
			String[] flowNoArray = flowNo.split("@");
			bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			bo = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",objectNo).getSingleResult(false);
			String sCustomerID = bo.getAttribute("CustomerID").getString();
			bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
			bo = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
			String sCustomerType = bo.getAttribute("CustomerType").getString();
			//0120 中小型企业,使用配置靠后的流程号
			//FlowNo格式：CreditFlow@SMEStandardFlow，第1位表示大型企业使用流程，第2位表示中小企业使用流程
			if("0120".equals(sCustomerType)){
				if(flowNoArray.length >= 2){
					flowNo = flowNoArray[1];
				}else{
					flowNo = flowNoArray[0];
				}
			}else{
				flowNo = flowNoArray[0];
			}
			//获取初始化阶段
			bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
			bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",flowNo).getSingleResult(false);
			flowNo = bo.getAttribute("InitPhase").getString();
			//如果没有初始阶段编号，抛出提示信息
			if(flowNo==null||flowNo.trim().equals(""))
				ARE.getLog().error("审批流程"+flowNo+"没有初始化阶段编号！");
				throw new Exception("审批流程"+flowNo+"没有初始化阶段编号！");
		}
		//如果申请一笔新发生的业务或只是申请额度，且在BUSINESS_TYPE中指定了审批流程,则从之中取得审批流程编号和初始阶段编号，并覆盖掉已经取得的默认值；
		if("CreditApply".equals(objectType))
		{
			String sOccurtype="";
			if(!"CreditLineApply".equals(applyType)){
				bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
				bo = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",objectNo).getSingleResult(false);
				sOccurtype = bo.getAttribute("Occurtype").getString();
			}
			//发生类型010，新发生的业务或申请申请额度
			if("CreditLineApply".equals(applyType)||"010".equals(sOccurtype)){
				//从业务表中查询审批流程编号
				bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_TYPE");
				bo = bm.createQuery("TypeNo = (select businesstype from Business_Apply where SerialNo=:SerialNo)").setParameter("SerialNo",objectNo).getSingleResult(false);
				String flowNo1 = bo.getAttribute("Attribute9").getString();
				//如果存在审批流程编号则查询初始阶段编号
				if(!"".equals(flowNo1)||flowNo1.trim().length()>0){
					flowNo = flowNo1;
					//获取初始化阶段
					bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
					bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",flowNo).getSingleResult(false);
					flowNo = bo.getAttribute("InitPhase").getString();
					//如果没有初始阶段编号，抛出提示信息
					if(flowNo==null||"".equals(flowNo.trim())) {
						ARE.getLog().error("审批流程"+flowNo1+"没有初始化阶段编号！");
						throw new Exception("审批流程"+flowNo1+"没有初始化阶段编号！");
					}
				}
			}
												
		}	
		//获取的用户名称
		bm = JBOFactory.getFactory().getManager("jbo.sys.USER_INFO");
		bo = bm.createQuery("UserID=:UserID").setParameter("UserID",userID).getSingleResult(false);
		sUserName = bo.getAttribute("UserName").getString();
	    //取得机构名称
		bm = JBOFactory.getFactory().getManager("jbo.sys.ORG_INFO");
		bo = bm.createQuery("OrgID=:OrgID").setParameter("OrgID",orgID).getSingleResult(false);
		sOrgName = bo.getAttribute("OrgName").getString();
        //取得流程名称
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
		bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",flowNo).getSingleResult(false);
		if(bo==null) throw new Exception("流程"+flowNo+"不存在！");
		else sFlowName = bo.getAttribute("FlowName").getString();
        //取得阶段名称
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_MODEL");
		bo = bm.createQuery("FlowNo=:FlowNo and PhaseNo=:PhaseNo").setParameter("FlowNo",flowNo).setParameter("PhaseNo",phaseNo).getSingleResult(false);
		if(bo==null) throw new Exception("流程"+flowNo+"的阶段"+phaseNo+"不存在！");
		else {
			sPhaseName = bo.getAttribute("PhaseName").getString();
			sPhaseType = bo.getAttribute("PhaseType").getString();
		}
		//获得开始日期
	    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();
	    //将空值转化成空字符串
	    if(objectType == null) objectType = "";
	    if(objectNo == null) objectNo = "";
	    if(sPhaseType == null) sPhaseType = "";
	    if(applyType == null) applyType = "";
	    if(flowNo == null) flowNo = "";
	    if(sFlowName == null) sFlowName = "";
	    if(flowNo == null) flowNo = "";
	    if(sPhaseName == null) sPhaseName = "";
	    if(userID == null) userID = "";
	    if(sUserName == null) sUserName = "";
	    if(orgID == null) orgID = "";
	    if(sOrgName == null) sOrgName = "";
	    //在流程对象表FLOW_OBJECT中新增一笔信息
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_OBJECT");
		tx.join(bm);
		bo = bm.newObject();
		bo.setAttributeValue("ObjectType", objectType).setAttributeValue("ObjectNo", objectNo).setAttributeValue("PhaseType", sPhaseType).
		setAttributeValue("ApplyType", applyType).setAttributeValue("FlowNo", flowNo).setAttributeValue("FlowName", sFlowName).
		setAttributeValue("PhaseNo", phaseNo).setAttributeValue("PhaseName", sPhaseName).setAttributeValue("OrgID", orgID).
		setAttributeValue("OrgName", sOrgName).setAttributeValue("UserID", userID).setAttributeValue("UserName", sUserName).
		setAttributeValue("InputDate", StringFunction.getToday());
		bm.saveObject(bo);
	    //在流程任务表FLOW_TASK中新增一笔信息
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_TASK");
		tx.join(bm);
		bo = bm.newObject();
		bo.setAttributeValue("ObjectType", objectType).setAttributeValue("ObjectNo", objectNo).
		setAttributeValue("PhaseType", sPhaseType).setAttributeValue("ApplyType", applyType).setAttributeValue("FlowNo", flowNo).
		setAttributeValue("FlowName", sFlowName).setAttributeValue("PhaseNo", phaseNo).setAttributeValue("PhaseName", sPhaseName).
		setAttributeValue("OrgID", orgID).setAttributeValue("UserID", userID).setAttributeValue("UserName", sUserName).
		setAttributeValue("OrgName", sOrgName).setAttributeValue("BegInTime", sBeginTime);
		bm.saveObject(bo);
	    tx.commit();
	    ARE.getLog().info("-----初始化流程记录结束-----");
        //--------------初始化流程结束-----------------------------------------
		} catch (Exception e) {
			ARE.getLog().error("-----初始化流程记录失败！-----",e);
			tx.rollback();
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * 取消评级
	 * @return
	 * @throws Exception
	 */
	public String cancelRating() throws Exception{
		String sReturn = "";
		String recordID = "";
		String reportDate = "";
		String reportScope = "";
		String customerID = "";
		String reportPeriod="";
		String auditFlag = "";
		JBOTransaction tx = JBOFactory.createJBOTransaction();
		BizObjectManager bm = null;
		BizObject bo = null;
		//解锁报表
		//查询本期所用的报表
		try {
		bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		bo= bm.createQuery("RatingAppID=:RatingAppID").setParameter("RatingAppID",applyNo).getSingleResult(false);
		reportDate = bo.getAttribute("reportDate").getString();
		reportScope = bo.getAttribute("reportScope").getString();
		auditFlag = bo.getAttribute("auditFlag").getString();
		customerID = bo.getAttribute("customerID").getString();
		reportPeriod = bo.getAttribute("reportPeriod").getString();
		//判断该期报表除了本次评级外是否还被其他评级所引用。
		bo = bm.createQuery("CustomerID=:CustomerID and reportDate=:reportDate and reportScope=:reportScope and reportPeriod = :reportPeriod and auditFlag = :auditFlag and ratingAppID <> :ratingAppID").
		setParameter("CustomerID",customerID).setParameter("reportDate",reportDate).setParameter("reportScope",reportScope).
		setParameter("auditFlag",auditFlag).setParameter("reportPeriod",reportPeriod).setParameter("ratingAppID",applyNo).getSingleResult(false);
		if(bo==null){
			//修改报表状态
			bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
			tx.join(bm);
			bo = bm.createQuery("customerID=:customerID and reportDate=:reportDate and reportScope=:reportScope and auditFlag = :auditFlag  and reportPeriod=:reportPeriod ").
			setParameter("customerID",customerID).setParameter("reportDate",reportDate).setParameter("auditFlag",auditFlag).
			setParameter("reportPeriod",reportPeriod).setParameter("reportScope",reportScope).getSingleResult(true);
			if(bo!=null){
				bo.setAttributeValue("REPORTSTATUS","02");
				bm.saveObject(bo);
			}
		}
		//删除意见表信息
		bm = JBOFactory.getFactory().getManager("jbo.app.RATING_OPINION");
		tx.join(bm);
		bo = bm.createQuery("ApplyNo=:applyNo and applyType=:applyType").
		setParameter("applyNo",applyNo).setParameter("applyType",applyType).getSingleResult(false);
		if(bo!=null) bm.deleteObject(bo);
		//删除申请表信息
		bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		tx.join(bm);
		bo = bm.createQuery("RatingAppID =:RatingAppID").setParameter("RatingAppID", applyNo).getSingleResult(false);
		if(bo!=null) bm.deleteObject(bo);
		else throw new Exception("评级申请记录"+applyNo+"不存在！");
		recordID = bo.getAttribute("RATINGMODRECORDID").toString();//用于删除模型规则记录
		//删除模型记录表信息
		ARE.getLog().info("-----删除模型规则记录开始-----");
		RuleOpAction roa = new RuleOpAction("rating_service");
		sReturn = roa.delete(recordID,tx);
		if(!"SUCCESS".endsWith(sReturn))return "FAILURE";
		ARE.getLog().info("-----删除模型规则记录结束-----");

		ARE.getLog().info("-----删除内置流程信息开始-----");
		//删除流程对象记录
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_OBJECT");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		if(bo!=null) bm.deleteObject(bo);
		//删除流程任务记录
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_TASK");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		if(bo!=null) bm.deleteObject(bo);
		//删除流程意见
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_OPINION");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		if(bo!=null) bm.deleteObject(bo);
		tx.commit();
		ARE.getLog().info("-----删除内置流程信息结束-----");
		} catch (Exception e) {
			ARE.getLog().error("-----删除内置 流程信息失败！-----",e);
			tx.rollback();
			return "FAILURE";
		}
		return "SUCCESS";
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getFlowNo() {
		return flowNo;
	}

	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}

	public String getPhaseNo() {
		return phaseNo;
	}

	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getPhaseType() {
		return phaseType;
	}

	public void setPhaseType(String phaseType) {
		this.phaseType = phaseType;
	}

	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getApplyNo() {
		return applyNo;
	}

	public void setApplyNo(String applyNo) {
		this.applyNo = applyNo;
	}

	public String getRefModelID() {
		return refModelID;
	}

	public void setRefModelID(String refModelID) {
		this.refModelID = refModelID;
	}
	
} 
