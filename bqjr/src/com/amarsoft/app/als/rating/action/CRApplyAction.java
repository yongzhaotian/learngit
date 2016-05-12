package com.amarsoft.app.als.rating.action;

import com.amarsoft.app.als.rule.action.RuleOpAction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.log.Log;
import com.amarsoft.awe.util.Transaction;

/**
 * author:yzhan
 * changed: DXS 20111006 为了方便子类CPRApplyAction继承该父类
 **/
public class CRApplyAction {
	protected String objectNo;
	protected String objectType;
	protected String applyNo;
	
	protected JBOFactory factory = JBOFactory.getFactory();
	protected BizObjectManager bom = null;
	protected BizObjectQuery query = null;
	protected BizObject bo = null;
	
	protected Log logger = ARE.getLog();
	
	/**
	 * 取消客户评级申请
	 * @param flowNo 流程编号
	 * @param objectNo 业务对象编号
	 * @param objectType 业务对象类型
	 * @param processInstNo 流程实例编号
	 * @return
	 * @throws JBOException
	 */
	public String cancelCRApply(JBOTransaction tx) throws Exception {
		String sReturn = "";
		String recordID = "";
		String reportDate = "";
		String reportScope = "";
		String customerID = "";
		String reportPeriod="";
		String auditFlag = "";
		
		//解锁报表
		//查询本期所用的报表
		try {
		BizObjectManager bm1 = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		BizObject bo1= bm1.createQuery("RatingAppID=:RatingAppID").setParameter("RatingAppID",applyNo).getSingleResult(false);
		reportDate = bo1.getAttribute("reportDate").getString();
		reportScope = bo1.getAttribute("reportScope").getString();
		auditFlag = bo1.getAttribute("auditFlag").getString();
		customerID = bo1.getAttribute("customerID").getString();
		reportPeriod = bo1.getAttribute("reportPeriod").getString();
		//判断该期报表除了本次评级外是否还被其他评级所引用。
		BizObjectQuery bq1 = bm1.createQuery("CustomerID=:CustomerID and reportDate=:reportDate and reportScope=:reportScope and " +
				" reportPeriod = :reportPeriod and auditFlag = :auditFlag and ratingAppID <> :ratingAppID");
		bq1.setParameter("CustomerID",customerID);
		bq1.setParameter("reportDate",reportDate);
		bq1.setParameter("reportScope",reportScope);
		bq1.setParameter("auditFlag",auditFlag);
		bq1.setParameter("reportPeriod",reportPeriod);
		bq1.setParameter("ratingAppID",applyNo);
		if(bq1.getSingleResult(false)==null){
			//修改报表状态
			BizObjectManager bm2 = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_FSRECORD");
			BizObjectQuery bq2 = bm2.createQuery("customerID=:customerID and reportDate=:reportDate and reportScope=:reportScope " +
					" and auditFlag = :auditFlag  and reportPeriod=:reportPeriod ");
			bq2.setParameter("customerID",customerID);
			bq2.setParameter("reportDate",reportDate);
			bq2.setParameter("auditFlag",auditFlag);
			bq2.setParameter("reportPeriod",reportPeriod);
			bq2.setParameter("reportScope",reportScope);
			
			BizObject bo2 = bq2.getSingleResult(true);
			if(bo2 != null){
				bo2.setAttributeValue("REPORTSTATUS","02");
				bm2.saveObject(bo2);
			}
		}
		//删除意见表信息
		BizObjectManager opinionBm = JBOFactory.getFactory().getManager("jbo.app.RATING_OPINION");
		tx.join(opinionBm);
		BizObjectQuery opinionBq = opinionBm.createQuery("delete from o where ApplyNo=:applyNo and applyType='RatingApply'");
		opinionBq.setParameter("applyNo",applyNo);
		opinionBq.executeUpdate();
		//删除申请表信息
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		tx.join(bm);
		BizObjectQuery bq = bm.createQuery("RatingAppID =:RatingAppID").setParameter("RatingAppID", applyNo);
		BizObject bo = bq.getSingleResult(false);
		recordID = bo.getAttribute("RATINGMODRECORDID").toString();//用于删除模型规则记录
		bm.deleteObject(bo);
		//删除模型记录表信息
		ARE.getLog().info("-----删除模型规则记录开始-----");
		RuleOpAction roa = new RuleOpAction("rating_service");
		sReturn = roa.delete(recordID,tx);
		if(!"SUCCESS".endsWith(sReturn))return "FAILURE";
		ARE.getLog().info("-----删除模型规则记录结束-----");

		ARE.getLog().info("-----删除内置流程信息开始-----");
		//删除流程对象记录
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_OBJECT");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		bm.deleteObject(bo);
		//删除流程任务记录
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		bm.deleteObject(bo);
		//删除流程意见
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_OPINION");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		bm.deleteObject(bo);
		tx.commit();
		ARE.getLog().info("-----删除流程信息结束-----");
		} catch (Exception e) {
			ARE.getLog().error("-----删除流程信息失败！-----");
			tx.rollback();
			return "FAILURE";
		}
		return "SUCCESS";
		//--------------调用流程引擎删除流程实例-------------------------
/*		ARE.getLog().info("******** BEGIN Delete process ["+ flowNo +"] ********");
		BusinessProcessAction processAction =  new BusinessProcessAction(tx);
		processAction.setProcessDefID(flowNo);
		processAction.setProcessInstID(processInstNo);
		processAction.setBizProcessObjectID(flowObjectNo);
		sReturn = processAction.delete();
		//删除流程失败，则抛出取消评级失败异常！
		if("FAILURE".equals(sReturn)){
			throw new Exception("取消评级失败！");
		}
		ARE.getLog().info("******** END Delete process ["+ flowNo +"] Status: "+sReturn + "  ********");*/
			//--------------删除流程实例结束---------------------------------
	}
	
	/**
	 * 重新发起客户评级
	 * @param flowNo 流程定义编号
	 * @param processTaskNo 流程任务编号
	 * @param businessTaskID 业务系统任务编号
	 * @param userID 用户编号
	 * @param objectNo 业务对象编号
	 * @param objectType 业务对象类型
	 * @return
	 * @throws JBOException 
	 */
	public String reStartCRApply(Transaction Sqlca) throws Exception {
	   /*String sReturn = "FAILURE";
		String nextAction = "";//提交动作
		String nextUser = "";  //提交处理人
		
		try {
			// --------------调用流程引擎重新启动流程实例---------------------------------
			ARE.getLog().info("******** BEGIN Restart process [" + flowNo + "] ********");
			
			
			//此处逻辑实质为退回补充资料阶段的提交
			//1.取得下一阶段的提交动作(一般为"补充完全")
			BusinessTaskAction btAction = new BusinessTaskAction();
			Map<String, String> actions = btAction.getTaskActions(flowNo,processTaskNo,userID,Sqlca);
			String[] actionValues = (String[])actions.values().toArray(new String[actions.size()]);
			if(actionValues == null || actionValues.length == 0){
				logger.debug("************ 重新启动流程实例失败,未取得提交动作 ************" );
				throw new Exception("************ 重新启动流程实例失败,未取得提交动作 ************" );
			}
			nextAction = actionValues[0];
			
			//2.取得下一阶段处理人
			BusinessActivityAction baAction = new BusinessActivityAction();
			String[] users = baAction.getTaskParticipants(flowNo, nextAction, processTaskNo, userID, Sqlca);
			if(users == null || users.length == 0){
				logger.debug("************ 重新启动流程实例失败,未取得提交处理人 ************" );
				throw new Exception("************ 重新启动流程实例失败,未取得提交处理人 ************" );
			}
			nextUser = users[0];
			
			JBOTransaction tx = JBOFactory.createJBOTransaction();
			BusinessProcessAction processAction = new BusinessProcessAction(tx);
			processAction.setProcessTaskID(processTaskNo);
			processAction.setProcessDefID(flowNo);
			processAction.setApplyType(applyType);
			processAction.setApplyNo(applyNo);
			processAction.setBizProcessTaskID(businessTaskID);
			processAction.setProcessAction(nextAction);
			processAction.setTaskParticipants(nextUser);
			sReturn = processAction.commit(Sqlca);
			ARE.getLog().info("******** END Restart process ["+ flowNo +"] Status: "+sReturn + "  ********");
			
			//--------------重新启动流程实例结束-----------------------------------------
			
		} catch (Exception e) {
			logger.debug("重新启动流程实例失败" + e.getMessage(), e);
			throw new Exception("重新启动流程实例失败" + e.getMessage(), e);
		}*/
		return "FAILURE";
	}

	public String getApplyNo() {
		return applyNo;
	}

	public void setApplyNo(String applyNo) {
		this.applyNo = applyNo;
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
}
