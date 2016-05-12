/*
		Author: --jgao 2008-10-24
		Tester:
		Describe: --�������ҵ���Ƿ���Ʊ��
		Input Param:
				ObjectNo:��ͬ��ˮ��
				BusinessType��ҵ��Ʒ��
		Output Param:
				"00":��ʾû��Ʊ��
				"01":��ʾ����Ʊ��
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckBillInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{

		//��ú�ͬ��ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//���ҵ��Ʒ��
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//����ֵת���ɿ��ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";

		//���������Sql���
		String sSql = "";
		//�����������ѯ�����
		ASResultSet rs = null;
		//���巵�ر���
		String flag = "00";//"00"����BILL_INFO�ﲻ����������Ʊ��
	
		//��ҵ��Ʒ��Ϊ���гжһ�Ʊ���֡���ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ������
		if(sBusinessType.equals("1020010") || sBusinessType.equals("1020020") || sBusinessType.equals("1020030"))
		{
			//���ֺ�ͬ���´��ڻ�Ʊ��Ϣ
			sSql = 	" select * from BILL_INFO "+
					" where ObjectType = 'BusinessContract' "+
					" and ObjectNo = :ObjectNo "+
					" and BillNo not in "+
					" (select BillNo from BUSINESS_PUTOUT "+
					" where ContractSerialNo = :ContractSerialNo)";	
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ContractSerialNo", sObjectNo));
			if(rs.next()) flag = "01";//"01"����BILL_INFO�����������Ʊ��
			rs.getStatement().close();
		}
		return flag;
	}
		
}
