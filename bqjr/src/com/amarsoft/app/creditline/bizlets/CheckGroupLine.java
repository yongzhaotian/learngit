/*
 *	Author: jgao1 2009-10-26
 *	Tester:
 *	Describe: ��鼯�����Ŷ�ȷ����м��ų�Ա���������޶��Ƿ���������ܶ�
 *		                ����Ƿ��ѷ���ü��ų�Ա�ļ������Ŷ�ȣ�ĿǰALS6.5�Լ��ų�Ա����ҵ��Ʒ�ֲ�������
 *	Input Param:
 *			LineSum1:���ų�Ա �����޶�
 *			ParentLineID:���������ܶ�LineID
 *			LineID:��ǰ���ų�Ա���ID
 *			Currency:��ǰ���ų�Ա��ȱ���
 *	Output Param:
 *	HistoryLog:
 *
 */

package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckGroupLine extends Bizlet{

	public Object  run(Transaction Sqlca) throws Exception{
	 	//��ü��������ܶ��LineID
		String sParentLineID = (String)this.getAttribute("ParentLineID");
	 	if(sParentLineID == null) sParentLineID = "";
	 	//��ü��ų�Ա��ȵ�LineID
	 	String sLineID = (String)this.getAttribute("LineID");
	 	if(sLineID == null) sParentLineID = "";
	 	//���ų�Ա�ͻ�ID
	 	String sCustomerID = (String)this.getAttribute("CustomerID");
	 	if(sCustomerID == null) sCustomerID = "";
	 	//��ü��ų�Ա��ȱ���
	 	String sCurrency = (String)this.getAttribute("Currency");
	 	if(sCurrency == null) sCurrency = "";
		//��õ�ǰ����ļ��ų�Ա��������޶�
		String sLineSum1 = (String)this.getAttribute("LineSum1");
		if(sLineSum1==null||sLineSum1.equals("")) sLineSum1 = "0";
		//���ѵ�Ȼ�����޶��String��ת��Ϊdouble�ͣ���ǰ�����޶����ΪdSubLineSum1
		double dSubLineSum1 = DataConvert.toDouble(sLineSum1);
		//���ų�Ա�������
		int iCount=0;
		//���ų�Ա��ȱ���ת�����Ŷ�ȱ��ֺ����ֵ
		double dERateValue=0;
		//��ǰ����ļ��ų�Ա�����޶���ڼ��������ܶ�ı�־��1.false��ʾ����;2.true��ʾ����.
		boolean flag1 = false;
		//����ֵ��־��1."00":��ʾ������
		//		     2."10"����ʾ�����޶���������ܶ
		//           3."99":�ѷ���ü��ų�Ա���
		String flag3 = "00";
		
		String sSql = "";
		ASResultSet rs = null;
		
		//���������ܶ�dLineSum
		double dLineSum = 0;
		//��CL_INFO����ȡ�����������ܶ�
		sSql = "select LineSum1,getERate1('"+sCurrency+"',Currency) as ERateValue from CL_INFO where LineID=:LineID";
	    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("LineID", sParentLineID));
		while(rs.next())
		{
			dLineSum = rs.getDouble("LineSum1");
			dERateValue = rs.getDouble("ERateValue");
		}
		rs.getStatement().close();
		
		//ĿǰALS6.5ֻ���ƿͻ�ID�Ƿ��ظ�������businessType���п��ƣ��������Ҫ�������и�����
		sSql = "select count(*) from GLINE_INFO where ParentLineID = :ParentLineID and LineID <> :LineID and CustomerID=:CustomerID";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ParentLineID", sParentLineID).setParameter("LineID", sLineID).setParameter("CustomerID", sCustomerID));
		if(rs.next()){
			iCount = rs.getInt(1);
		}
		rs.getStatement().close();
		if(iCount>0) flag3 = "99";//��ʾ���ų�Ա�Ѵ��ڷ�����Ӷ��
		//�Լ��������޶���л��ʿ���	
		dSubLineSum1=dSubLineSum1*dERateValue;
		//��������޶���������ܶ�򳬶�
		if(dSubLineSum1 > dLineSum) flag1 = true;
		
		//����������Ŷ����û��Ϊ�ó�Ա������
		if(!"99".equals(flag3)){
			//��������޶���������ܶ�
			if(flag1 == true){
				flag3 = "10";
			}
		}
		return flag3;	    
	}
}
