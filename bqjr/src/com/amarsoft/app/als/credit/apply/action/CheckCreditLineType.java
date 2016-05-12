package com.amarsoft.app.als.credit.apply.action;

import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class CheckCreditLineType {
	
	private String lmtCatalog = ""; //��ȷ���
	private String applySerialNo = ""; //������
	private String creditObjectType = ""; //�����������

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
		if(lmtCatalog.equals("3005") || lmtCatalog.equals("3008")){//��˾�ۺ����Ŷ��\�����ۺ����Ŷ��
			int count = JBOFactory.createBizObjectQuery("jbo.app.BUSINESS_CONTRACT", "O.BusinessType='"+lmtCatalog+"' and O.SerialNo in (select CO.RelativeSerialNo from jbo.app.CL_OCCUPY CO where CO.ObjectType =:ObjectType and CO.ObjectNo =:ObjectNo)").
							setParameter("ObjectType", this.creditObjectType).
							setParameter("ObjectNo", this.applySerialNo).
							getTotalCount();
			if(count >= 1){
				message = "��ҵ���������ۺ����Ŷ��ͬʱ������Ч������";
			}else{
				message="SUCCESS";
			}
		}else{
			message="SUCCESS";
		}
		return message;
	}
}
