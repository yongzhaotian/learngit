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
	 * ��ȡ������ˮ��
	 * @return
	 * @throws Exception
	 */
	public String getUnfinishedTaskNo() throws Exception{
		// ������ˮ��
		String sSerialNo = null;
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bm = factory.getManager("jbo.sys.FLOW_TASK");
		BizObjectQuery bq = bm.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and FlowNo=:FlowNo and PhaseNo=:PhaseNo and userID =:userID and (PhaseAction is null or PhaseAction='') and (EndTime is null or EndTime ='')");
		bq.setParameter("ObjectType",objectType).setParameter("ObjectNo",objectNo).setParameter("FlowNo",flowNo).setParameter("PhaseNo",phaseNo).setParameter("userID",userID);
		BizObject bo = bq.getSingleResult(false);
		if(bo != null){
			sSerialNo = bo.getAttribute("SerialNo").getString();
		}else{
			throw new Exception("FLOW_TASK����û�и�����¼:ObjectType="+objectType+",ObjectNo="+objectNo+",FlowNo="+flowNo+",PhaseNo="+phaseNo+",userID="+userID);
		}
		return sSerialNo;
	}
	
	/**
	 * ��������
	 * @return
	 * @throws Exception
	 */
	public String startRating() throws Exception {
		//�������:�û����ơ��������ơ��������ơ��׶����ơ��׶����͡���ʼʱ�䡢������ˮ��
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
		//--------------��ʼ��ģ�ͼ�¼---------------------------------------
		ARE.getLog().info("-----��ʼ��ģ�͹����¼��ʼ-----");
		RuleOpAction roa = new RuleOpAction("rating_service");
		String recordID = roa.init(applyNo,refModelID,tx);
		if("null".equalsIgnoreCase(recordID)||recordID==null) throw new Exception("��ʼ��ģ�͹���ʧ��");
		else{
			bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
			tx.join(bm);
			bo = bm.createQuery("RatingAppID=:RatingAppID").setParameter("RatingAppID",applyNo).getSingleResult(true);
			bo.setAttributeValue("RatingModRecordID",recordID);
			bo.setAttributeValue("Status","0");//0������׶�    �� 1�������������
			bm.saveObject(bo);
		}
		ARE.getLog().info("-----��ʼ��ģ�͹����¼����-----");
		
		//--------------��ʼ�����̿�ʼ---------------------------------
		ARE.getLog().info("-----��ʼ�����̿�ʼ-----");
		if("CreditApply".equals(objectType)){
			//�ҳ�CustomerID
			String[] flowNoArray = flowNo.split("@");
			bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			bo = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",objectNo).getSingleResult(false);
			String sCustomerID = bo.getAttribute("CustomerID").getString();
			bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
			bo = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
			String sCustomerType = bo.getAttribute("CustomerType").getString();
			//0120 ��С����ҵ,ʹ�����ÿ�������̺�
			//FlowNo��ʽ��CreditFlow@SMEStandardFlow����1λ��ʾ������ҵʹ�����̣���2λ��ʾ��С��ҵʹ������
			if("0120".equals(sCustomerType)){
				if(flowNoArray.length >= 2){
					flowNo = flowNoArray[1];
				}else{
					flowNo = flowNoArray[0];
				}
			}else{
				flowNo = flowNoArray[0];
			}
			//��ȡ��ʼ���׶�
			bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
			bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",flowNo).getSingleResult(false);
			flowNo = bo.getAttribute("InitPhase").getString();
			//���û�г�ʼ�׶α�ţ��׳���ʾ��Ϣ
			if(flowNo==null||flowNo.trim().equals(""))
				ARE.getLog().error("��������"+flowNo+"û�г�ʼ���׶α�ţ�");
				throw new Exception("��������"+flowNo+"û�г�ʼ���׶α�ţ�");
		}
		//�������һ���·�����ҵ���ֻ�������ȣ�����BUSINESS_TYPE��ָ������������,���֮��ȡ���������̱�źͳ�ʼ�׶α�ţ������ǵ��Ѿ�ȡ�õ�Ĭ��ֵ��
		if("CreditApply".equals(objectType))
		{
			String sOccurtype="";
			if(!"CreditLineApply".equals(applyType)){
				bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
				bo = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",objectNo).getSingleResult(false);
				sOccurtype = bo.getAttribute("Occurtype").getString();
			}
			//��������010���·�����ҵ�������������
			if("CreditLineApply".equals(applyType)||"010".equals(sOccurtype)){
				//��ҵ����в�ѯ�������̱��
				bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_TYPE");
				bo = bm.createQuery("TypeNo = (select businesstype from Business_Apply where SerialNo=:SerialNo)").setParameter("SerialNo",objectNo).getSingleResult(false);
				String flowNo1 = bo.getAttribute("Attribute9").getString();
				//��������������̱�����ѯ��ʼ�׶α��
				if(!"".equals(flowNo1)||flowNo1.trim().length()>0){
					flowNo = flowNo1;
					//��ȡ��ʼ���׶�
					bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
					bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",flowNo).getSingleResult(false);
					flowNo = bo.getAttribute("InitPhase").getString();
					//���û�г�ʼ�׶α�ţ��׳���ʾ��Ϣ
					if(flowNo==null||"".equals(flowNo.trim())) {
						ARE.getLog().error("��������"+flowNo1+"û�г�ʼ���׶α�ţ�");
						throw new Exception("��������"+flowNo1+"û�г�ʼ���׶α�ţ�");
					}
				}
			}
												
		}	
		//��ȡ���û�����
		bm = JBOFactory.getFactory().getManager("jbo.sys.USER_INFO");
		bo = bm.createQuery("UserID=:UserID").setParameter("UserID",userID).getSingleResult(false);
		sUserName = bo.getAttribute("UserName").getString();
	    //ȡ�û�������
		bm = JBOFactory.getFactory().getManager("jbo.sys.ORG_INFO");
		bo = bm.createQuery("OrgID=:OrgID").setParameter("OrgID",orgID).getSingleResult(false);
		sOrgName = bo.getAttribute("OrgName").getString();
        //ȡ����������
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
		bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",flowNo).getSingleResult(false);
		if(bo==null) throw new Exception("����"+flowNo+"�����ڣ�");
		else sFlowName = bo.getAttribute("FlowName").getString();
        //ȡ�ý׶�����
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_MODEL");
		bo = bm.createQuery("FlowNo=:FlowNo and PhaseNo=:PhaseNo").setParameter("FlowNo",flowNo).setParameter("PhaseNo",phaseNo).getSingleResult(false);
		if(bo==null) throw new Exception("����"+flowNo+"�Ľ׶�"+phaseNo+"�����ڣ�");
		else {
			sPhaseName = bo.getAttribute("PhaseName").getString();
			sPhaseType = bo.getAttribute("PhaseType").getString();
		}
		//��ÿ�ʼ����
	    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();
	    //����ֵת���ɿ��ַ���
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
	    //�����̶����FLOW_OBJECT������һ����Ϣ
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_OBJECT");
		tx.join(bm);
		bo = bm.newObject();
		bo.setAttributeValue("ObjectType", objectType).setAttributeValue("ObjectNo", objectNo).setAttributeValue("PhaseType", sPhaseType).
		setAttributeValue("ApplyType", applyType).setAttributeValue("FlowNo", flowNo).setAttributeValue("FlowName", sFlowName).
		setAttributeValue("PhaseNo", phaseNo).setAttributeValue("PhaseName", sPhaseName).setAttributeValue("OrgID", orgID).
		setAttributeValue("OrgName", sOrgName).setAttributeValue("UserID", userID).setAttributeValue("UserName", sUserName).
		setAttributeValue("InputDate", StringFunction.getToday());
		bm.saveObject(bo);
	    //�����������FLOW_TASK������һ����Ϣ
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
	    ARE.getLog().info("-----��ʼ�����̼�¼����-----");
        //--------------��ʼ�����̽���-----------------------------------------
		} catch (Exception e) {
			ARE.getLog().error("-----��ʼ�����̼�¼ʧ�ܣ�-----",e);
			tx.rollback();
			return "FAILURE";
		}
		return "SUCCESS";
	}
	
	/**
	 * ȡ������
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
		//��������
		//��ѯ�������õı���
		try {
		bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		bo= bm.createQuery("RatingAppID=:RatingAppID").setParameter("RatingAppID",applyNo).getSingleResult(false);
		reportDate = bo.getAttribute("reportDate").getString();
		reportScope = bo.getAttribute("reportScope").getString();
		auditFlag = bo.getAttribute("auditFlag").getString();
		customerID = bo.getAttribute("customerID").getString();
		reportPeriod = bo.getAttribute("reportPeriod").getString();
		//�жϸ��ڱ�����˱����������Ƿ񻹱��������������á�
		bo = bm.createQuery("CustomerID=:CustomerID and reportDate=:reportDate and reportScope=:reportScope and reportPeriod = :reportPeriod and auditFlag = :auditFlag and ratingAppID <> :ratingAppID").
		setParameter("CustomerID",customerID).setParameter("reportDate",reportDate).setParameter("reportScope",reportScope).
		setParameter("auditFlag",auditFlag).setParameter("reportPeriod",reportPeriod).setParameter("ratingAppID",applyNo).getSingleResult(false);
		if(bo==null){
			//�޸ı���״̬
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
		//ɾ���������Ϣ
		bm = JBOFactory.getFactory().getManager("jbo.app.RATING_OPINION");
		tx.join(bm);
		bo = bm.createQuery("ApplyNo=:applyNo and applyType=:applyType").
		setParameter("applyNo",applyNo).setParameter("applyType",applyType).getSingleResult(false);
		if(bo!=null) bm.deleteObject(bo);
		//ɾ���������Ϣ
		bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
		tx.join(bm);
		bo = bm.createQuery("RatingAppID =:RatingAppID").setParameter("RatingAppID", applyNo).getSingleResult(false);
		if(bo!=null) bm.deleteObject(bo);
		else throw new Exception("���������¼"+applyNo+"�����ڣ�");
		recordID = bo.getAttribute("RATINGMODRECORDID").toString();//����ɾ��ģ�͹����¼
		//ɾ��ģ�ͼ�¼����Ϣ
		ARE.getLog().info("-----ɾ��ģ�͹����¼��ʼ-----");
		RuleOpAction roa = new RuleOpAction("rating_service");
		sReturn = roa.delete(recordID,tx);
		if(!"SUCCESS".endsWith(sReturn))return "FAILURE";
		ARE.getLog().info("-----ɾ��ģ�͹����¼����-----");

		ARE.getLog().info("-----ɾ������������Ϣ��ʼ-----");
		//ɾ�����̶����¼
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_OBJECT");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		if(bo!=null) bm.deleteObject(bo);
		//ɾ�����������¼
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_TASK");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		if(bo!=null) bm.deleteObject(bo);
		//ɾ���������
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_OPINION");
		tx.join(bm);
		bo = bm.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getSingleResult(false);
		if(bo!=null) bm.deleteObject(bo);
		tx.commit();
		ARE.getLog().info("-----ɾ������������Ϣ����-----");
		} catch (Exception e) {
			ARE.getLog().error("-----ɾ������ ������Ϣʧ�ܣ�-----",e);
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
