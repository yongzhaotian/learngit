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
 * changed: DXS 20111006 Ϊ�˷�������CPRApplyAction�̳иø���
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
	 * ȡ���ͻ���������
	 * @param flowNo ���̱��
	 * @param objectNo ҵ�������
	 * @param objectType ҵ���������
	 * @param processInstNo ����ʵ�����
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
		
		//��������
		//��ѯ�������õı���
		try {
		BizObjectManager bm1 = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		BizObject bo1= bm1.createQuery("RatingAppID=:RatingAppID").setParameter("RatingAppID",applyNo).getSingleResult(false);
		reportDate = bo1.getAttribute("reportDate").getString();
		reportScope = bo1.getAttribute("reportScope").getString();
		auditFlag = bo1.getAttribute("auditFlag").getString();
		customerID = bo1.getAttribute("customerID").getString();
		reportPeriod = bo1.getAttribute("reportPeriod").getString();
		//�жϸ��ڱ�����˱����������Ƿ񻹱��������������á�
		BizObjectQuery bq1 = bm1.createQuery("CustomerID=:CustomerID and reportDate=:reportDate and reportScope=:reportScope and " +
				" reportPeriod = :reportPeriod and auditFlag = :auditFlag and ratingAppID <> :ratingAppID");
		bq1.setParameter("CustomerID",customerID);
		bq1.setParameter("reportDate",reportDate);
		bq1.setParameter("reportScope",reportScope);
		bq1.setParameter("auditFlag",auditFlag);
		bq1.setParameter("reportPeriod",reportPeriod);
		bq1.setParameter("ratingAppID",applyNo);
		if(bq1.getSingleResult(false)==null){
			//�޸ı���״̬
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
		//ɾ���������Ϣ
		BizObjectManager opinionBm = JBOFactory.getFactory().getManager("jbo.app.RATING_OPINION");
		tx.join(opinionBm);
		BizObjectQuery opinionBq = opinionBm.createQuery("delete from o where ApplyNo=:applyNo and applyType='RatingApply'");
		opinionBq.setParameter("applyNo",applyNo);
		opinionBq.executeUpdate();
		//ɾ���������Ϣ
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		tx.join(bm);
		BizObjectQuery bq = bm.createQuery("RatingAppID =:RatingAppID").setParameter("RatingAppID", applyNo);
		BizObject bo = bq.getSingleResult(false);
		recordID = bo.getAttribute("RATINGMODRECORDID").toString();//����ɾ��ģ�͹����¼
		bm.deleteObject(bo);
		//ɾ��ģ�ͼ�¼����Ϣ
		ARE.getLog().info("-----ɾ��ģ�͹����¼��ʼ-----");
		RuleOpAction roa = new RuleOpAction("rating_service");
		sReturn = roa.delete(recordID,tx);
		if(!"SUCCESS".endsWith(sReturn))return "FAILURE";
		ARE.getLog().info("-----ɾ��ģ�͹����¼����-----");

		ARE.getLog().info("-----ɾ������������Ϣ��ʼ-----");
		//ɾ�����̶����¼
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_OBJECT");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		bm.deleteObject(bo);
		//ɾ�����������¼
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		bm.deleteObject(bo);
		//ɾ���������
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_OPINION");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		bm.deleteObject(bo);
		tx.commit();
		ARE.getLog().info("-----ɾ��������Ϣ����-----");
		} catch (Exception e) {
			ARE.getLog().error("-----ɾ��������Ϣʧ�ܣ�-----");
			tx.rollback();
			return "FAILURE";
		}
		return "SUCCESS";
		//--------------������������ɾ������ʵ��-------------------------
/*		ARE.getLog().info("******** BEGIN Delete process ["+ flowNo +"] ********");
		BusinessProcessAction processAction =  new BusinessProcessAction(tx);
		processAction.setProcessDefID(flowNo);
		processAction.setProcessInstID(processInstNo);
		processAction.setBizProcessObjectID(flowObjectNo);
		sReturn = processAction.delete();
		//ɾ������ʧ�ܣ����׳�ȡ������ʧ���쳣��
		if("FAILURE".equals(sReturn)){
			throw new Exception("ȡ������ʧ�ܣ�");
		}
		ARE.getLog().info("******** END Delete process ["+ flowNo +"] Status: "+sReturn + "  ********");*/
			//--------------ɾ������ʵ������---------------------------------
	}
	
	/**
	 * ���·���ͻ�����
	 * @param flowNo ���̶�����
	 * @param processTaskNo ����������
	 * @param businessTaskID ҵ��ϵͳ������
	 * @param userID �û����
	 * @param objectNo ҵ�������
	 * @param objectType ҵ���������
	 * @return
	 * @throws JBOException 
	 */
	public String reStartCRApply(Transaction Sqlca) throws Exception {
	   /*String sReturn = "FAILURE";
		String nextAction = "";//�ύ����
		String nextUser = "";  //�ύ������
		
		try {
			// --------------������������������������ʵ��---------------------------------
			ARE.getLog().info("******** BEGIN Restart process [" + flowNo + "] ********");
			
			
			//�˴��߼�ʵ��Ϊ�˻ز������Ͻ׶ε��ύ
			//1.ȡ����һ�׶ε��ύ����(һ��Ϊ"������ȫ")
			BusinessTaskAction btAction = new BusinessTaskAction();
			Map<String, String> actions = btAction.getTaskActions(flowNo,processTaskNo,userID,Sqlca);
			String[] actionValues = (String[])actions.values().toArray(new String[actions.size()]);
			if(actionValues == null || actionValues.length == 0){
				logger.debug("************ ������������ʵ��ʧ��,δȡ���ύ���� ************" );
				throw new Exception("************ ������������ʵ��ʧ��,δȡ���ύ���� ************" );
			}
			nextAction = actionValues[0];
			
			//2.ȡ����һ�׶δ�����
			BusinessActivityAction baAction = new BusinessActivityAction();
			String[] users = baAction.getTaskParticipants(flowNo, nextAction, processTaskNo, userID, Sqlca);
			if(users == null || users.length == 0){
				logger.debug("************ ������������ʵ��ʧ��,δȡ���ύ������ ************" );
				throw new Exception("************ ������������ʵ��ʧ��,δȡ���ύ������ ************" );
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
			
			//--------------������������ʵ������-----------------------------------------
			
		} catch (Exception e) {
			logger.debug("������������ʵ��ʧ��" + e.getMessage(), e);
			throw new Exception("������������ʵ��ʧ��" + e.getMessage(), e);
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
