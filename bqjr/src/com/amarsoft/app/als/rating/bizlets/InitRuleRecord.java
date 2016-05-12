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
 * �����ⲿ�������棬������������
 * @author pykang
 *
 */
public class InitRuleRecord extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
		//����������
		String sApplyNo = (String) this.getAttribute("RatingAppID");
		//����ģ�ͱ��
		String sModelID = (String) this.getAttribute("RefModelID");
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//��������
		String sApplyType = (String)this.getAttribute("ApplyType");
		//���̱��
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//�׶α��
		String sPhaseNo = (String)this.getAttribute("PhaseNo");	
		//�û�����
		String sUserID = (String)this.getAttribute("UserID");
		//��������
		String sOrgID = (String)this.getAttribute("OrgID");
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
		String recordID = roa.init(sApplyNo,sModelID,tx);
		if("null".equalsIgnoreCase(recordID)||recordID==null) throw new Exception("��ʼ��ģ�͹���ʧ��");
		else{
			bm = JBOFactory.getFactory().getManager("jbo.app.RATING_APPLY");
			tx.join(bm);
			bo = bm.createQuery("RatingAppID=:RatingAppID").setParameter("RatingAppID",sApplyNo).getSingleResult(true);
			bo.setAttributeValue("RatingModRecordID",recordID);
			bo.setAttributeValue("Status","0");//0������׶�    �� 1�������������
			bm.saveObject(bo);
		}
		ARE.getLog().info("-----��ʼ��ģ�͹����¼����-----");
		
		//--------------��ʼ�����̿�ʼ---------------------------------
		ARE.getLog().info("-----��ʼ�����̿�ʼ-----");
		if("CreditApply".equals(sObjectType)){
			//�ҳ�CustomerID
			String[] sFlowNoArray = sFlowNo.split("@");
			bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			bo = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",sObjectNo).getSingleResult(false);
			String sCustomerID = bo.getAttribute("CustomerID").getString();
			bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
			bo = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
			String sCustomerType = bo.getAttribute("CustomerType").getString();
			//0120 ��С����ҵ,ʹ�����ÿ�������̺�
			//FlowNo��ʽ��CreditFlow@SMEStandardFlow����1λ��ʾ������ҵʹ�����̣���2λ��ʾ��С��ҵʹ������
			if("0120".equals(sCustomerType)){
				if(sFlowNoArray.length >= 2){
					sFlowNo = sFlowNoArray[1];
				}else{
					sFlowNo = sFlowNoArray[0];
				}
			}else{
				sFlowNo = sFlowNoArray[0];
			}
			//��ȡ��ʼ���׶�
			bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
			bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",sFlowNo).getSingleResult(false);
			sPhaseNo = bo.getAttribute("InitPhase").getString();
			//���û�г�ʼ�׶α�ţ��׳���ʾ��Ϣ
			if(sPhaseNo==null||sPhaseNo.trim().equals(""))
				ARE.getLog().error("��������"+sFlowNo+"û�г�ʼ���׶α�ţ�");
				throw new Exception("��������"+sFlowNo+"û�г�ʼ���׶α�ţ�");
		}
		//�������һ���·�����ҵ���ֻ�������ȣ�����BUSINESS_TYPE��ָ������������,���֮��ȡ���������̱�źͳ�ʼ�׶α�ţ������ǵ��Ѿ�ȡ�õ�Ĭ��ֵ��
		if("CreditApply".equals(sObjectType))
		{
			String sOccurtype="";
			if(!"CreditLineApply".equals(sApplyType)){
				bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
				bo = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",sObjectNo).getSingleResult(false);
				sOccurtype = bo.getAttribute("Occurtype").getString();
			}
			//��������010���·�����ҵ�������������
			if("CreditLineApply".equals(sApplyType)||"010".equals(sOccurtype)){
				//��ҵ����в�ѯ�������̱��
				bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_TYPE");
				bo = bm.createQuery("TypeNo = (select businesstype from Business_Apply where SerialNo=:SerialNo)").setParameter("SerialNo",sObjectNo).getSingleResult(false);
				String sFlowNo1 = bo.getAttribute("Attribute9").getString();
				//��������������̱�����ѯ��ʼ�׶α��
				if(!"".equals(sFlowNo1)||sFlowNo1.trim().length()>0){
					sFlowNo = sFlowNo1;
					//��ȡ��ʼ���׶�
					bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
					bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",sFlowNo).getSingleResult(false);
					sPhaseNo = bo.getAttribute("InitPhase").getString();
					//���û�г�ʼ�׶α�ţ��׳���ʾ��Ϣ
					if(sPhaseNo==null||"".equals(sPhaseNo.trim())) {
						ARE.getLog().error("��������"+sFlowNo1+"û�г�ʼ���׶α�ţ�");
						throw new Exception("��������"+sFlowNo1+"û�г�ʼ���׶α�ţ�");
					}
				}
			}
												
		}	
		//��ȡ���û�����
		bm = JBOFactory.getFactory().getManager("jbo.sys.USER_INFO");
		bo = bm.createQuery("UserID=:UserID").setParameter("UserID",sUserID).getSingleResult(false);
		sUserName = bo.getAttribute("UserName").getString();
	    //ȡ�û�������
		bm = JBOFactory.getFactory().getManager("jbo.sys.ORG_INFO");
		bo = bm.createQuery("OrgID=:OrgID").setParameter("OrgID",sOrgID).getSingleResult(false);
		sOrgName = bo.getAttribute("OrgName").getString();
        //ȡ����������
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_CATALOG");
		bo = bm.createQuery("FlowNo=:FlowNo").setParameter("FlowNo",sFlowNo).getSingleResult(false);
		if(bo==null) throw new Exception("����"+sFlowNo+"�����ڣ�");
		else sFlowName = bo.getAttribute("FlowName").getString();
        //ȡ�ý׶�����
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_MODEL");
		bo = bm.createQuery("FlowNo=:FlowNo and PhaseNo=:PhaseNo").setParameter("FlowNo",sFlowNo).setParameter("PhaseNo",sPhaseNo).getSingleResult(false);
		if(bo==null) throw new Exception("����"+sFlowNo+"�Ľ׶�"+sPhaseNo+"�����ڣ�");
		else {
			sPhaseName = bo.getAttribute("PhaseName").getString();
			sPhaseType = bo.getAttribute("PhaseType").getString();
		}
		//��ÿ�ʼ����
	    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();
	    //����ֵת���ɿ��ַ���
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
	    //�����̶����FLOW_OBJECT������һ����Ϣ
		bm = JBOFactory.getFactory().getManager("jbo.sys.FLOW_OBJECT");
		tx.join(bm);
		bo = bm.newObject();
		bo.setAttributeValue("ObjectType", sObjectType).setAttributeValue("ObjectNo", sObjectNo).setAttributeValue("PhaseType", sPhaseType).
		setAttributeValue("ApplyType", sApplyType).setAttributeValue("FlowNo", sFlowNo).setAttributeValue("FlowName", sFlowName).
		setAttributeValue("PhaseNo", sPhaseNo).setAttributeValue("PhaseName", sPhaseName).setAttributeValue("OrgID", sOrgID).
		setAttributeValue("OrgName", sOrgName).setAttributeValue("UserID", sUserID).setAttributeValue("UserName", sUserName).
		setAttributeValue("InputDate", StringFunction.getToday());
		bm.saveObject(bo);
	    //�����������FLOW_TASK������һ����Ϣ
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
	    ARE.getLog().info("-----��ʼ�����̼�¼����-----");
        //--------------��ʼ�����̽���-----------------------------------------
		} catch (Exception e) {
			ARE.getLog().error("-----��ʼ�����̼�¼ʧ�ܣ�-----");
			tx.rollback();
			return "FAILURE";
		}
		return "SUCCESS";
	}

}
