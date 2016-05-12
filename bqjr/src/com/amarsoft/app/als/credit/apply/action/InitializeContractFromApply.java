package com.amarsoft.app.als.credit.apply.action;

import com.amarsoft.app.als.credit.contract.action.AddContractInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

public class InitializeContractFromApply
{
	private String applySerialNo = ""; //申请流水号
	private String userID = ""; //用户代码
	
	public String getApplySerialNo() {
		return applySerialNo;
	}

	public void setApplySerialNo(String applySerialNo) {
		this.applySerialNo = applySerialNo;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}
	
	public String initialize(JBOTransaction tx) throws Exception{		
		String contractSerialNo = ""; //新生成的合同编号
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
	 	tx.join(m);
	 	BizObjectQuery q = m.createQuery("SerialNo=:SerialNo");
	 	BizObject bo = q.setParameter("SerialNo", applySerialNo).getSingleResult(true);
	 	ASUser curUser = ASUser.getUser(userID,Transaction.createTransaction(tx));
	 	
	 	AddContractInfo addContractInfo = new AddContractInfo(bo,"CreditApply",curUser);
	 	contractSerialNo = addContractInfo.transfer(tx);
	 	
	 	return contractSerialNo;
	}

}
