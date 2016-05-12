package com.amarsoft.app.lending.bizlets;

/*
Author: --ccxie 2010/03/22
Tester:
Describe: --ɾ��������ͬ������ϵ
Input Param:
		ContractNo: ������ͬ���
		GuarantyID: ����Ѻ����
Output Param:

HistoryLog:
*/

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteGuarantyRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		
		SqlObject so ;//��������
		
		//����ֵת��Ϊ���ַ���
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyID == null) sGuarantyID = "";
		so = new SqlObject("select GuarantyStatus from GUARANTY_INFO where GuarantyID =:GuarantyID").setParameter("GuarantyID", sGuarantyID);
		String sGuarantyStatus = Sqlca.getString(so);
		if(sGuarantyStatus == null) sGuarantyStatus = "";
		//sGuarantyStatus=01����Ʒδ���
		if(sGuarantyStatus.equals("01")){
			so = new SqlObject("delete from GUARANTY_RELATIVE where ContractNo=:ContractNo and GuarantyID=:GuarantyID").setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
			Sqlca.executeSQL(so);
		}else{//������ϵ��Ϊ��Ч
			so = new SqlObject("update GUARANTY_RELATIVE set RelationStatus = '020' where ContractNo=:ContractNo and GuarantyID=:GuarantyID ").setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
			Sqlca.executeSQL(so);
		  }
		return "sccuss";
	}		
}
