package com.amarsoft.app.als.flow.cfg.action;

import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.log.Log;

public class FlowCfgProcess {
	public String flowNo;
	public String isInUse;
	public JBOFactory factory = JBOFactory.getFactory();
	public BizObjectManager bm;
	public BizObject bo;
	public Log logger = ARE.getLog();
	
	public String deleteFlowModel() throws JBOException {
		logger.info("---删除流程模型开始---");
		JBOTransaction tx = factory.createTransaction();
		try {
			bm = factory.getManager("jbo.sys.FLOW_CATALOG");
			tx.join(bm);
			bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",flowNo).getSingleResult(true);
			if(bo!=null) bm.deleteObject(bo);
			bm = factory.getManager("jbo.sys.FLOW_MODEL");
			tx.join(bm);
			List bl = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",flowNo).getResultList(true);
			for(int i=0;i<bl.size();i++){
				bm.deleteObject((BizObject)bl.get(i));
			}
			bm = factory.getManager("jbo.sys.FLOW_RULERELA");
			tx.join(bm);
			bl = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",flowNo).getResultList(true);
			for(int i=0;i<bl.size();i++){
				bm.deleteObject((BizObject)bl.get(i));
			}
			tx.commit();
		} catch (JBOException e) {
			logger.error("删除流程模型出错！",e);
			tx.rollback();
			return "FAILURE";
		}
		logger.info("---删除流程模型成功---");
		return "SUCCESS";
	}
	
	public String checkFlowModelStatus() throws JBOException {
		bm	= factory.getManager("jbo.sys.FLOW_CATALOG");
		BizObject bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo", flowNo).getSingleResult(false);
		if(bo!=null){
			 String isInUse = bo.getAttribute("IsInUse").getString();
			 if("1".equals(isInUse)) return "VALID";
			 bm = JBOFactory.getBizObjectManager("jbo.app.FLOW_OBJECT");
			 bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo", flowNo).getSingleResult(false);
			 if(bo!=null) return "INUSE";
		}
		return "INVALID";
	}
	
	public String ChangeFlowModelStatus() throws JBOException {
		bm	= factory.getManager("jbo.sys.FLOW_CATALOG");
		BizObject bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo", flowNo).getSingleResult(true).
		setAttributeValue("IsInUse", isInUse);
		bm.saveObject(bo);
		return "SUCCESS";
	}
	
	public String getFlowNo() {
		return flowNo;
	}
	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}

	public String getIsInUse() {
		return isInUse;
	}

	public void setIsInUse(String isInUse) {
		this.isInUse = isInUse;
	}
	
}
