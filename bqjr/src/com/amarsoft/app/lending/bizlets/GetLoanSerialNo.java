package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetLoanSerialNo extends Bizlet {
		
	public Object run(Transaction Sqlca) throws Exception {
		//���֤��
		String sCertID = (String)this.getAttribute("CertID");
		//��ͬ��
		String sContractSerialno = (String)this.getAttribute("ContractSerialno");
		//�ƻ���ǰ������
		String sScheduleDate = (String)this.getAttribute("ScheduleDate");
		//����ֵת��Ϊ���ַ���
		if(sCertID == null) sCertID = "";
		if(sContractSerialno == null) sContractSerialno = "";
		if(sScheduleDate == null) sScheduleDate = "";
		
		String sSql = "";
		String sSerialno = "";
		String sNextdueDate = "";	//�´λ�����
		String sMaturity = "";		//�����ִ������
		ASResultSet rs = null;
		
		sSql =  "select serialno,NextdueDate from acct_loan al,business_contract bc where al.contractserialno=bc.serialno and al.LoanStatus in('0','1') and ContractSerialno='"+sContractSerialno+"' ";
		/*if(sContractSerialno != "" && sCertID == ""){
			sSql += " ContractSerialno='"+sContractSerialno+"' ";
		}else if(sCertID != ""){
			sSql += " contractserialno in (select serialno from business_contract where certid='"+sCertID+"') ";
		}*/
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){			
		  sSerialno = rs.getString("serialno");
		  sNextdueDate = rs.getString("NextdueDate");
		  if(sSerialno==null){
			  sSerialno = "";
		  }
		  	  
		}
			rs.getStatement().close();
		//��ִ����ǰ��������ѡ��
			
		//�������
		
		int sDays = DateFunctions.getDays(sScheduleDate, sNextdueDate);
		if(sDays < 10){
			sMaturity = DateFunctions.getRelativeDate(sScheduleDate, DateFunctions.TERM_UNIT_MONTH, 1);
		}else{
			sMaturity=sScheduleDate;
		}
		
		return sSerialno+"@"+sMaturity;
	}

}
