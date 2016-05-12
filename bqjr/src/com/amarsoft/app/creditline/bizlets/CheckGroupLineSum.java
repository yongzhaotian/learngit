/*
 *	Author: jgao1 2009-10-26
 *	Tester:
 *	Describe: �ڼ��������ܶ����ʱ�������С�ܶ�ʱ������Ƿ�����Ҫ��
 *	Input Param:
 *			ObjectType:��������
 *			ObjectNo: ������
 *			BusinessSum: ���Ŷ��Э����
 *	Output Param:
 *	HistoryLog:
 *  @updatesuer:yhshan
 *  @updatedate:2012/09/12
 */

package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckGroupLineSum extends Bizlet{

	public Object  run(Transaction Sqlca) throws Exception{
	 	//�������ͣ�
	 	String sObjectType = (String)this.getAttribute("ObjectType");
	 	//�����ţ��������������ܶ�
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//���Ŷ��Э����
	 	String sBusinessSum = (String)this.getAttribute("BusinessSum");
	 	if(sBusinessSum==null||sBusinessSum.equals("")) sBusinessSum = "0";
	 	double dLineSum = DataConvert.toDouble(sBusinessSum);
	 	
	 	//����ֵ��־��1."00":��ʾ������2."02":�Ӷ�������޶�>���Э����
		String flag = "00";
		
		SqlObject so = null;//��������
		
		String sSql = "";
		//���Ŷ��ID
		String sParentLineID = "";
		//�������Ŷ�ȱ���
		String sCurrency="";
		//���Ŷ�ȱ���ת�������Ŷ�ȱ��ֺ����ֵ
		double dERateValue=0;
		ASResultSet rs = null;
		//��ͬ�Ķ�����������ȡֵҲ��ͬ
		if(sObjectType.equals("CreditApply"))
		{
			sSql = " select LineID,Currency from CL_INFO where ApplySerialNo =:ApplySerialNo order by LineID";
			so = new SqlObject(sSql);
			so.setParameter("ApplySerialNo", sObjectNo);
			rs=Sqlca.getASResultSet(so);
			if(rs.next())
			{
				sParentLineID=rs.getString("LineID"); 
				sCurrency=rs.getString("Currency"); 
			}
		}
		if(sObjectType.equals("BusinessContract"))
		{
			sSql = " select LineID,Currency from CL_INFO where BCSerialNo =:BCSerialNo order by LineID";
			so = new SqlObject(sSql);
			so.setParameter("BCSerialNo", sObjectNo);
			rs=Sqlca.getASResultSet(so);
			if(rs.next())
			{
				sParentLineID=rs.getString("LineID");
				sCurrency=rs.getString("Currency");
			}
		}
		rs.getStatement().close();
				
	 	//�Ӷ�ȸ���
	 	int iCount =0;
	 	so = new SqlObject("select LineSum1,GetERate1(Currency,:sCurrency) as ERateValue from GLINE_INFO where ParentLineID=:ParentLineID ");
		so.setParameter("sCurrency", sCurrency);
		so.setParameter("ParentLineID", sParentLineID);
		String[][] sArray = Sqlca.getStringMatrix(so);
		iCount = sArray.length;
		for(int i=0;i<iCount;i++){
			if(Double.valueOf(sArray[i][0])*Double.valueOf(sArray[i][1])//�����޶�*����ת��ֵ
					>dLineSum)//�Ӷ�������޶�>���Э����
				flag="02";	
		}		
		return flag;
	}
}
	

