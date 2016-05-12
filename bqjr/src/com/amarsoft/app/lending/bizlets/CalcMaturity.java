package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ������ʼ�պ����޼��㵽����
 * @author rant
 *
 */

public class CalcMaturity extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception {
		//���ޱ�־
		String sLoanTermFlag = (String)this.getAttribute("LoanTermFlag");
		//��������
		String sLoanTerm = (String)this.getAttribute("LoanTerm");
		//ҵ����ʼ��
		String sPutOutDate = (String)this.getAttribute("PutOutDate");
		
		//����ֵת��Ϊ���ַ���
		if(sLoanTermFlag == null) sLoanTermFlag = "";
		if(sLoanTerm == null) sLoanTerm = "";
		if(sPutOutDate == null) sPutOutDate = "";
		
		//�������
		int iLoanTerm = Integer.parseInt(sLoanTerm);
		String sMaturity = DateFunctions.getRelativeDate(sPutOutDate, sLoanTermFlag, iLoanTerm);
		if(sMaturity == null) sMaturity = "";
		
		return sMaturity;
	}

}
