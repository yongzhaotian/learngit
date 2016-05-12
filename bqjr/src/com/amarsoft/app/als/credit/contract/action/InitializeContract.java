package com.amarsoft.app.als.credit.contract.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

public class InitializeContract
{
	private String approveSerialNo = ""; //������ˮ��
	private String userID = ""; //�û�����
	
	public String getApproveSerialNo() {
		return approveSerialNo;
	}
	public void setApproveSerialNo(String objectNo) {
		this.approveSerialNo = objectNo;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	
	String sSerialNo = ""; //�����ɵĺ�ͬ���

	public String  initialize(JBOTransaction tx) throws Exception{			
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE");
	 	tx.join(m);
	 	BizObjectQuery q = m.createQuery("SerialNo=:SerialNo");
	 	BizObject bo = q.setParameter("SerialNo", approveSerialNo).getSingleResult(true);
	 	ASUser curUser = ASUser.getUser(userID,Transaction.createTransaction(tx));
	 	
	 	//ȡ��ͬ�������ͬ������ֱ�ӷ��ظú�ͬ��ˮ
		BizObjectManager mContract = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(mContract);
		q = mContract.createQuery("RelativeSerialNo=:SerialNo").setParameter("SerialNo",approveSerialNo); 
		BizObject boContract = q.getSingleResult(false);
		if(boContract != null) return boContract.getAttribute("SerialNo").getString();
	 	
	 	AddContractInfo addContractInfo = new AddContractInfo(bo,"ApproveApply",curUser);
		sSerialNo = addContractInfo.transfer(tx);
	    return sSerialNo;
	}

}
