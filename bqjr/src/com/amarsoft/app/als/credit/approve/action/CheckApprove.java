package com.amarsoft.app.als.credit.approve.action;

import com.amarsoft.app.als.credit.model.CreditObjectAction;
import com.amarsoft.are.jbo.JBOException;

public class CheckApprove {
	
	private String approveSerialNo = "";
	
	public String getApproveSerialNo() {
		return approveSerialNo;
	}

	public void setApproveSerialNo(String approveSerialNo) {
		this.approveSerialNo = approveSerialNo;
	}

	public String checkRelaLine() throws JBOException{
		String message = "";
		CreditObjectAction creditObjectAction = new CreditObjectAction(this.getApproveSerialNo(),"ApproveApply");
		if(creditObjectAction.getRelativeCreditLineList().isEmpty()){
			message = "false";
		}else{
			message = "success";
		}
		return message;
	}

}
