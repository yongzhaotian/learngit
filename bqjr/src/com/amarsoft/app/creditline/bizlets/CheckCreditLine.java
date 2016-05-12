package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ������Ŷ�ȷ����е��������޶���ʳ����޶��Ƿ���������ܶ����Ƿ��ѷ�����Ӷ��ҵ�����ͼ�������ҵ��Ʒ�֡�
 * @author jgao1
 * date: 2008-09-26
 * History Log: 2009/07/07 �޸�У���߼�,ֻУ�����Ŷ�ȷ����е��������޶�����޶��Ƿ�������ź�ͬ���
 *              cbsu 2009/10/28 ������һ�������Ӷ��ʱ���׳��쳣��SQL��䣬������ע��
 */
 
public class CheckCreditLine extends Bizlet {

	/**
	 * ������Ŷ�ȷ����е��������޶���ʳ����޶��Ƿ���������ܶ����Ƿ��ѷ�����Ӷ��ҵ�����ͼ�������ҵ��Ʒ�֡�
	 * @param LineSum1 �����޶�
	 * @param LineSum2 �����޶�
	 * @param ParentLineID �����ܶ�LineID
	 * @param BusinessType ҵ������
	 * @param LineID ��ǰ�����Ӷ��ID
	 * @param Currency ��ǰ�����Ӷ�ȱ���
	 * @return flag3 "00": ��ʾ������
	 *               "01": ��ʾ��ǰ�����޶���������޶
	 *               "10"����ʾ�����޶�֮�ʹ��������ܶ
	 *               "11"����ʾ�����޶���������޶�������޶�֮�ʹ��������ܶ�
	 *               "99": �ѷ����ҵ�������Ӷ��
	 * 
	 */
 public Object  run(Transaction Sqlca) throws Exception {
	 	//��������ܶ��LineID
	 	String sParentLineID = (String)this.getAttribute("ParentLineID");
	 	if(sParentLineID == null) sParentLineID = "";
	 	//��õ�ǰ�Ӷ�ȵ�LineID
	 	String sLineID = (String)this.getAttribute("LineID");
	 	if(sLineID == null) sLineID = "";
	 	//����Ӷ��ҵ��Ʒ��
	 	String sBusinessType = (String)this.getAttribute("BusinessType");
	 	if(sBusinessType == null) sBusinessType = "";
	 	//����Ӷ�ȱ���
	 	String sCurrency = (String)this.getAttribute("Currency");
	 	if(sCurrency == null) sCurrency = "";
	 	//�ѷ�����Ӷ��ҵ����������,���ڴ���ѷ�����Ӷ��ҵ������
	 	String[] sBusinessTypes = null;
		//��õ�ǰ������Ӷ�������޶�
		String sLineSum1 = (String)this.getAttribute("LineSum1");
		if(sLineSum1==null||sLineSum1.equals("")) sLineSum1 = "0";
		//���ѵ�Ȼ�����޶��String��ת��Ϊdouble�ͣ���ǰ�����޶����ΪdSubLineSum1
		double dSubLineSum1 = Double.parseDouble(sLineSum1);
		//��õ�ǰ������Ӷ�ȳ����޶�
		String sLineSum2 = (String)this.getAttribute("LineSum2");
		if(sLineSum2==null||sLineSum2.equals("")) sLineSum2 = "0";
		//���ѵ�Ȼ�����޶��String��ת��Ϊdouble�ͣ���ǰ�����޶����ΪdSubLineSum2
		double dSubLineSum2 = Double.parseDouble(sLineSum2);
		//�Ӷ������
		int iCount=0;
		double dERateValue=0;//�Ӷ�ȱ���ת�����Ŷ�ȱ��ֺ����ֵ
		//��ǰ����������޶���������ܶ�ı�־��1.false��ʾ����;2.true��ʾ����.
		boolean flag1 = false;
		//��ǰ����ĳ����޶���ڵ�ǰ����������޶�ı�־��1.false��ʾ������2.true��ʾ����.
		boolean flag2 = false;
		//����ֵ��־��1."00":��ʾ������
		//           2."01":��ʾ��ǰ�����޶���ڵ�ǰ�����޶
		//           3."10"����ʾ�����޶���������ܶ
		//           4."11"����ʾ��ǰ�����޶���ڵ�ǰ�����޶�������޶���������ܶ
		//           5."99":�ѷ����ҵ�������Ӷ��
		String flag3 = "00";
		
		String sSql = "";
		ASResultSet rs = null;
		
		//�����ܶ�sLineSum
		double dLineSum = 0;
		//��CL_INFO����ȡ�������ܶ�
		sSql = "select LineSum1,getERate1('"+sCurrency+"',Currency) as ERateValue from CL_INFO where LineID=:LineID";
	    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("LineID", sParentLineID));
		while(rs.next())
		{
			dLineSum = rs.getDouble("LineSum1");
			dERateValue = rs.getDouble("ERateValue");
		}
		rs.getStatement().close();
		
		//�����ѷ�����Ӷ��ҵ������
		sSql = "select BusinessType from CL_INFO where LineID <> :LineID and ParentLineID = :ParentLineID";
		sBusinessTypes = Sqlca.getStringArray(new SqlObject(sSql).setParameter("ParentLineID", sParentLineID).setParameter("LineID", sLineID));
	    iCount = sBusinessTypes.length;
		for(int i=0;i<iCount;i++)
		{
			if(sBusinessType.equals(sBusinessTypes[i]) || sBusinessType.startsWith(sBusinessTypes[i])){
				flag3 = "99";
			}
		}
				
		//�����ǰ�����޶���ڵ�ǰ�����޶�򳬶�
		if(dSubLineSum2 > dSubLineSum1) flag2 = true;
		//�������޶���л��ʿ���
		dSubLineSum1=dSubLineSum1*dERateValue;
		//��������޶���������ܶ�򳬶�
		if(dSubLineSum1 > dLineSum) flag1 = true;
		
		//�жϷ���ֵ
		if(!"99".equals(flag3))//û�з�����ͬҵ�����ͻ��߱ȵ�ǰ�����ҵ�����ͷ�Χ
		{
			if(flag1 == false)//�����޶�С�������ܶ�
			{
				if(flag2 == false) flag3 = "00";//��ǰ�����޶�С�ڵ��ڵ�ǰ�����޶�
				else flag3 = "01";
			}
			else
			{
				if(flag2 == false) flag3 = "10";
				else flag3 = "11";
			}
		}
		return flag3;
	    
	}

}
