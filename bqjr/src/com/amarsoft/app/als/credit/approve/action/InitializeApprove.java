package com.amarsoft.app.als.credit.approve.action;

import com.amarsoft.app.lending.bizlets.InitializeFlow;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class InitializeApprove {
	//������
	private String applySerialNo = "";
	//��������
	private String applyType = "";
	//���̱��
	private String initFlowNo = "";
	//�׶α��
	private String initPhaseNo = "";	
	//�û�����
	private String userID = "";
	//��ȡ�����������
	private String approveOpinion = "";
	//��ȡ������
	private String disagreeOpinion = "";

	public String getApplySerialNo() {
		return applySerialNo;
	}

	public void setApplySerialNo(String applySerialNo) {
		this.applySerialNo = applySerialNo;
	}

	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}

	public String getInitFlowNo() {
		return initFlowNo;
	}

	public void setInitFlowNo(String initFlowNo) {
		this.initFlowNo = initFlowNo;
	}

	public String getInitPhaseNo() {
		return initPhaseNo;
	}

	public void setInitPhaseNo(String initPhaseNo) {
		this.initPhaseNo = initPhaseNo;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getApproveOpinion() {
		return approveOpinion;
	}

	public void setApproveOpinion(String approveOpinion) {
		this.approveOpinion = approveOpinion;
	}

	public String getDisagreeOpinion() {
		return disagreeOpinion;
	}

	public void setDisagreeOpinion(String disagreeOpinion) {
		this.disagreeOpinion = disagreeOpinion;
	}
	
	public String   initialize(JBOTransaction tx) throws Exception{			
	 	BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
	 	tx.join(m);
	 	BizObjectQuery q = m.createQuery("SerialNo=:SerialNo");
	 	BizObject bo = q.setParameter("SerialNo", applySerialNo).getSingleResult(true);
	 	ASUser curUser = ASUser.getUser(userID,Transaction.createTransaction(tx));
	 	
		/*
		 * 1�������������������ʼ��		  
		*/
		AddApproveInfo addApprove = new AddApproveInfo(bo,curUser);
		addApprove.setApproveOpinion(approveOpinion);
		addApprove.setDisagreeOpinion(disagreeOpinion);
		String sSerialNo = addApprove.transfer(tx); //�²�����������ˮ��
		
		/*
		 * 2������ InitializeFlow.java��������������������̳�ʼ��		  
		*/
		Bizlet bzInitFlow = new InitializeFlow();
		bzInitFlow.setAttribute("ObjectType","ApproveApply"); 
		bzInitFlow.setAttribute("ObjectNo",sSerialNo); 
		bzInitFlow.setAttribute("ApplyType",applyType);
		bzInitFlow.setAttribute("FlowNo",initFlowNo);
		bzInitFlow.setAttribute("PhaseNo",initPhaseNo);
		bzInitFlow.setAttribute("UserID",userID);
		bzInitFlow.setAttribute("OrgID",curUser.getOrgID());
		bzInitFlow.run(Transaction.createTransaction(tx));
		  
	    return sSerialNo;
	 }
}
