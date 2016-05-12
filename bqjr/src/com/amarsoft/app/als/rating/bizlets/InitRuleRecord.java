package com.amarsoft.app.als.rating.bizlets;

import com.amarsoft.app.als.rule.action.RuleOpAction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * 调用外部规则引擎，采用内置流程
 * @author pykang
 *
 */
public class InitRuleRecord extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
		//评级申请编号
		String sApplyNo = (String) this.getAttribute("RatingAppID");
		//关联模型编号
		String sModelID = (String) this.getAttribute("RefModelID");
		//对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//申请类型
		String sApplyType = (String)this.getAttribute("ApplyType");
		//流程编号
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//阶段编号
		String sPhaseNo = (String)this.getAttribute("PhaseNo");	
		//用户代码
		String sUserID = (String)this.getAttribute("UserID");
		//机构代码
		String sOrgID = (String)this.getAttribute("OrgID");
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
		String recordID = roa.init(sApplyNo,sModelID,tx);
		if("null".equalsIgnoreCase(recordID)||recordID==null) throw new Exception("初始化模型规则失败");
		else{
			bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
			tx.join(bm);
			bo = bm.createQuery("RatingAppID=:RatingAppID").setParameter("RatingAppID",sApplyNo).getSingleResult(true);
			bo.setAttributeValue("RatingModRecordID",recordID);
			bo.setAttributeValue("Status","0");//0：申请阶段    ， 1：申请审批完成
			bm.saveObject(bo);
		}
		ARE.getLog().info("-----初始化模型规则记录结束-----");
		
		//--------------初始化流程开始---------------------------------
		ARE.getLog().info("-----初始化流程开始-----");
		if("CreditApply".equals(sObjectType)){
			//找出CustomerID
			String[] sFlowNoArray = sFlowNo.split("@");
			bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			bo = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",sObjectNo).getSingleResult(false);
			String sCustomerID = bo.getAttribute("CustomerID").getString();
			bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
			bo = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
			String sCustomerType = bo.getAttribute("CustomerType").getString();
			//0120 中小型企业,使用配置靠后的流程号
			//FlowNo格式：CreditFlow@SMEStandardFlow，第1位表示大型企业使用流程，第2位表示中小企业使用流程
			if("0120".equals(sCustomerType)){
				if(sFlowNoArray.length >= 2){
					sFlowNo = sFlowNoArray[1];
				}else{
					sFlowNo = sFlowNoArray[0];
				}
			}else{
				sFlowNo = sFlowNoArray[0];
			}
			//获取初始化阶段
			bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
			bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",sFlowNo).getSingleResult(false);
			sPhaseNo = bo.getAttribute("InitPhase").getString();
			//如果没有初始阶段编号，抛出提示信息
			if(sPhaseNo==null||sPhaseNo.trim().equals(""))
				ARE.getLog().error("审批流程"+sFlowNo+"没有初始化阶段编号！");
				throw new Exception("审批流程"+sFlowNo+"没有初始化阶段编号！");
		}
		//如果申请一笔新发生的业务或只是申请额度，且在BUSINESS_TYPE中指定了审批流程,则从之中取得审批流程编号和初始阶段编号，并覆盖掉已经取得的默认值；
		if("CreditApply".equals(sObjectType))
		{
			String sOccurtype="";
			if(!"CreditLineApply".equals(sApplyType)){
				bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
				bo = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",sObjectNo).getSingleResult(false);
				sOccurtype = bo.getAttribute("Occurtype").getString();
			}
			//发生类型010，新发生的业务或申请申请额度
			if("CreditLineApply".equals(sApplyType)||"010".equals(sOccurtype)){
				//从业务表中查询审批流程编号
				bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_TYPE");
				bo = bm.createQuery("TypeNo = (select businesstype from Business_Apply where SerialNo=:SerialNo)").setParameter("SerialNo",sObjectNo).getSingleResult(false);
				String sFlowNo1 = bo.getAttribute("Attribute9").getString();
				//如果存在审批流程编号则查询初始阶段编号
				if(!"".equals(sFlowNo1)||sFlowNo1.trim().length()>0){
					sFlowNo = sFlowNo1;
					//获取初始化阶段
					bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
					bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",sFlowNo).getSingleResult(false);
					sPhaseNo = bo.getAttribute("InitPhase").getString();
					//如果没有初始阶段编号，抛出提示信息
					if(sPhaseNo==null||"".equals(sPhaseNo.trim())) {
						ARE.getLog().error("审批流程"+sFlowNo1+"没有初始化阶段编号！");
						throw new Exception("审批流程"+sFlowNo1+"没有初始化阶段编号！");
					}
				}
			}
												
		}	
		//获取的用户名称
		bm = JBOFactory.getFactory().getManager("jbo.sys.USER_INFO");
		bo = bm.createQuery("UserID=:UserID").setParameter("UserID",sUserID).getSingleResult(false);
		sUserName = bo.getAttribute("UserName").getString();
	    //取得机构名称
		bm = JBOFactory.getFactory().getManager("jbo.sys.ORG_INFO");
		bo = bm.createQuery("OrgID=:OrgID").setParameter("OrgID",sOrgID).getSingleResult(false);
		sOrgName = bo.getAttribute("OrgName").getString();
        //取得流程名称
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
		bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",sFlowNo).getSingleResult(false);
		if(bo==null) throw new Exception("流程"+sFlowNo+"不存在！");
		else sFlowName = bo.getAttribute("FlowName").getString();
        //取得阶段名称
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_MODEL");
		bo = bm.createQuery("FlowNo=:FlowNo and PhaseNo=:PhaseNo").setParameter("FlowNo",sFlowNo).setParameter("PhaseNo",sPhaseNo).getSingleResult(false);
		if(bo==null) throw new Exception("流程"+sFlowNo+"的阶段"+sPhaseNo+"不存在！");
		else {
			sPhaseName = bo.getAttribute("PhaseName").getString();
			sPhaseType = bo.getAttribute("PhaseType").getString();
		}
		//获得开始日期
	    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();
	    //将空值转化成空字符串
	    if(sObjectType == null) sObjectType = "";
	    if(sObjectNo == null) sObjectNo = "";
	    if(sPhaseType == null) sPhaseType = "";
	    if(sApplyType == null) sApplyType = "";
	    if(sFlowNo == null) sFlowNo = "";
	    if(sFlowName == null) sFlowName = "";
	    if(sPhaseNo == null) sPhaseNo = "";
	    if(sPhaseName == null) sPhaseName = "";
	    if(sUserID == null) sUserID = "";
	    if(sUserName == null) sUserName = "";
	    if(sOrgID == null) sOrgID = "";
	    if(sOrgName == null) sOrgName = "";
	    //在流程对象表FLOW_OBJECT中新增一笔信息
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_OBJECT");
		tx.join(bm);
		bo = bm.newObject();
		bo.setAttributeValue("ObjectType", sObjectType).setAttributeValue("ObjectNo", sObjectNo).setAttributeValue("PhaseType", sPhaseType).
		setAttributeValue("ApplyType", sApplyType).setAttributeValue("FlowNo", sFlowNo).setAttributeValue("FlowName", sFlowName).
		setAttributeValue("PhaseNo", sPhaseNo).setAttributeValue("PhaseName", sPhaseName).setAttributeValue("OrgID", sOrgID).
		setAttributeValue("OrgName", sOrgName).setAttributeValue("UserID", sUserID).setAttributeValue("UserName", sUserName).
		setAttributeValue("InputDate", StringFunction.getToday());
		bm.saveObject(bo);
	    //在流程任务表FLOW_TASK中新增一笔信息
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_TASK");
		tx.join(bm);
		bo = bm.newObject();
		bo.setAttributeValue("ObjectType", sObjectType).setAttributeValue("ObjectNo", sObjectNo).
		setAttributeValue("PhaseType", sPhaseType).setAttributeValue("ApplyType", sApplyType).setAttributeValue("FlowNo", sFlowNo).
		setAttributeValue("FlowName", sFlowName).setAttributeValue("PhaseNo", sPhaseNo).setAttributeValue("PhaseName", sPhaseName).
		setAttributeValue("OrgID", sOrgID).setAttributeValue("UserID", sUserID).setAttributeValue("UserName", sUserName).
		setAttributeValue("OrgName", sOrgName).setAttributeValue("BegInTime", sBeginTime);
		bm.saveObject(bo);
	    tx.commit();
	    ARE.getLog().info("-----初始化流程记录结束-----");
        //--------------初始化流程结束-----------------------------------------
		} catch (Exception e) {
			ARE.getLog().error("-----初始化流程记录失败！-----");
			tx.rollback();
			return "FAILURE";
		}
		return "SUCCESS";
	}

}
