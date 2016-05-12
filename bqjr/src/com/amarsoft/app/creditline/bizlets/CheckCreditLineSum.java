package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * �������ܶ����ʱ�������С�ܶ�ʱ������Ƿ�����Ҫ��
 * @author jgao1
 * @date 2008-09-27
 * History Log:
 */
public class CheckCreditLineSum extends Bizlet {

	/**
	 * @param ObjectType ��������
	 * @param ObjectNo ������
	 * @param BusinessSum ���Ŷ��Э����
	 * @return flag
	 *         1."00":��ʾ������
	 *         2."01":�Ӷ�������޶� > �Ӷ�ȳ����޶
	 *         3."02":�Ӷ�������޶� > ���Э����
	 */
    public Object run(Transaction Sqlca) throws Exception {
	 	//�������ͣ�
	 	String sObjectType = (String)this.getAttribute("ObjectType");
	 	//�����ţ��������������ܶ�
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//���Ŷ��Э����
	 	String sBusinessSum = (String)this.getAttribute("BusinessSum");
	 	if(sBusinessSum==null||sBusinessSum.equals("")) sBusinessSum = "0";
	 	double dLineSum = Double.parseDouble(sBusinessSum);
	 	
	 	//����ֵ��־��1."00":��ʾ������2."01":�Ӷ�������޶� > �Ӷ�ȳ����޶3."02":�Ӷ�������޶� > ���Э����
		String flag = "00";
		SqlObject so = null;//��������
		
		String sSql = "";
		//���Ŷ��ID
		String sParentLineID = "";
		String sCurrency="";//���Ŷ�ȱ���
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
			rs.getStatement().close();
		}
		
		if(sObjectType.equals("BusinessContract"))
		{
			sSql = " select LineID,Currency from CL_INFO where BCSerialNo =:BCSerialNo order by LineID ";
			so = new SqlObject(sSql);
			so.setParameter("BCSerialNo", sObjectNo);
			rs=Sqlca.getASResultSet(so);
			
			if(rs.next())
			{
				sParentLineID=rs.getString("LineID");
				sCurrency=rs.getString("Currency");
			}
			rs.getStatement().close();
		}
		
	 	//�Ӷ�ȸ���
	 	int iCount =0;
	 	sSql = " select LineSum1,LineSum2,GetERate1(Currency,'"+sCurrency+"') as ERateValue from CL_INFO where ParentLineID=:ParentLineID ";
		so = new SqlObject(sSql).setParameter("ParentLineID", sParentLineID);
		String[][] sArray =Sqlca.getStringMatrix(so);
		iCount = sArray.length;
		
		for(int i=0;i<iCount;i++){
			if(Double.valueOf(sArray[i][0])*Double.valueOf(sArray[i][2])//�����޶�*����ת��ֵ
					<Double.valueOf(sArray[i][1])*Double.valueOf(sArray[i][2])//�����޶�*����ת��ֵ
					) flag="01";//�Ӷ�������޶�<�Ӷ�ȳ����޶�
			if(Double.valueOf(sArray[i][0])*Double.valueOf(sArray[i][2])>dLineSum) flag="02";//�Ӷ�������޶�>���Э����
		}
		return flag;
	}
}
