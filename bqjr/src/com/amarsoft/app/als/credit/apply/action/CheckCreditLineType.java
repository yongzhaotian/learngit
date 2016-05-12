package com.amarsoft.app.als.credit.apply.action;

import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class CheckCreditLineType {
	
	private String lmtCatalog = ""; //额度分类
	private String applySerialNo = ""; //申请编号
	private String creditObjectType = ""; //申请对象类型

	public String getApplySerialNo() {
		return applySerialNo;
	}

	public void setApplySerialNo(String applySerialNo) {
		this.applySerialNo = applySerialNo;
	}

	public String getCreditObjectType() {
		return creditObjectType;
	}

	public void setCreditObjectType(String creditObjectType) {
		this.creditObjectType = creditObjectType;
	}

	public String getLmtCatalog() {
		return lmtCatalog;
	}

	public void setLmtCatalog(String lmtCatalog) {
		this.lmtCatalog = lmtCatalog;
	}

	public String checkCLType(JBOTransaction tx) throws JBOException{
		String message = "";
		if(lmtCatalog.equals("3005") || lmtCatalog.equals("3008")){//公司综合授信额度\个人综合授信额度
			int count = JBOFactory.createBizObjectQuery("jbo.app.BUSINESS_CONTRACT", "O.BusinessType='"+lmtCatalog+"' and O.SerialNo in (select CO.RelativeSerialNo from jbo.app.CL_OCCUPY CO where CO.ObjectType =:ObjectType and CO.ObjectNo =:ObjectNo)").
							setParameter("ObjectType", this.creditObjectType).
							setParameter("ObjectNo", this.applySerialNo).
							getTotalCount();
			if(count >= 1){
				message = "该业务不能与多个综合授信额度同时建立有效关联！";
			}else{
				message="SUCCESS";
			}
		}else{
			message="SUCCESS";
		}
		return message;
	}
}
