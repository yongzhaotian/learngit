package com.amarsoft.app.lending.bizlets;
/*
		Author: --zywei 2005-12-10
		Tester:
		Describe: --ɾ��������ͬ;
		Input Param:
				ObjectType: --��������(ҵ��׶�)��
				ObjectNo: --�����ţ�����/����/��ͬ��ˮ�ţ���
				SerialNo:--������ͬ��
		Output Param:
				return������ֵ��SUCCEEDED --ɾ���ɹ���

		HistoryLog:
 */
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteGuarantyInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyID = (String)this.getAttribute("GuarantyID");

		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyID == null) sGuarantyID = "";
						
		
		//ɾ������Ѻ��
		String sSql = "";
		SqlObject so ;//��������
		sSql = 	" delete from GUARANTY_INFO "+
		" where GuarantyID =:GuarantyID "+
		" and GuarantyStatus = '01' ";
		so = new SqlObject(sSql).setParameter("GuarantyID", sGuarantyID);
        Sqlca.executeSQL(so);
		
		//ɾ������Ѻ���뵣����ͬ�Ĺ�����ϵ
        sSql = 	" delete from GUARANTY_RELATIVE "+
		" where ObjectType =:ObjectType "+
		" and ObjectNo =:ObjectNo "+
		" and ContractNo =:ContractNo "+
		" and GuarantyID =:GuarantyID ";
        so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
        Sqlca.executeSQL(so);
        
		return "SUCCEEDED";
	}
}
