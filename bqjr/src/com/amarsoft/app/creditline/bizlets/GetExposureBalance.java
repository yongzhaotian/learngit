/**
 * Author: --hwang 2009-06-23 21:00            
 * Tester:                               
 * Describe: --���㳨�ڽ��/���
 * Input Param:                          
 * 		Currency: ����(�ö�������Ķ��/�Ӷ�ȱ���)
 * 		ObjectType : ��������(CreditApply,ApproveApply,BusinessContract)		
 * 		ObjectNo : ������(������ˮ��,������ˮ��,��ͬ��ˮ��)
 * 		Flag:      ��־λ(sum:���㳨�ڽ�balance:���㳨����Ĭ�ϼ�����)
 * Output Param:                         
 * 		sBalance�����ڽ��/�������          
 * HistoryLog:                           
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class GetExposureBalance extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
		String sCurrency = (String)this.getAttribute("Currency");//������Ϣ
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sFlag = (String)this.getAttribute("Flag");
		String sSql = "";
		ASResultSet rs = null;//���ݼ�
		double dBalance=0.0;//��ͬ���/���
		double dBailSum=0.0;//��֤��
		double dAvailableBalance=0.0;//���ڽ��/���
		String sBalance = null;//���ڽ��/���
		
		String sTable="";//��ر�
		if(sObjectType.equals("CreditApply")){//��������Ϊҵ������,��ر�Ϊ����
			sTable="BUSINESS_APPLY";
		}else if(sObjectType.equals("ApproveApply")){//��������Ϊҵ������,��ر�Ϊ����
			sTable="BUSINESS_APPROVE";
		}else{//Ĭ����ر�Ϊ��ͬ
			sTable="BUSINESS_CONTRACT";
		}
        
        //���Flagû��ֵ,Ĭ�ϼ��㳨�ڽ��
        if(sFlag==null || sFlag.length() ==0) sFlag="sum";
        
        //��ȡ����,��ȡ�Ľ���ת��Ϊ��ǰҵ������Ķ��/�Ӷ�Ƚ��
        if("balance".equals(sFlag)){
        	sSql = " Select nvl(Balance,0)*getERate1(BusinessCurrency,'"+sCurrency+"') as Balance,nvl(BailSum,0)*getERate1(BailCurrency,'"+sCurrency+"') as BailSum "+
        		   " from "+sTable+" where SerialNo=:SerialNo and (PigeonholeDate !=' ' and PigeonholeDate is not null) ";
        	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
        }else{
        	sSql = " Select nvl(BusinessSum,0)*getERate1(BusinessCurrency,'"+sCurrency+"') as Balance,nvl(BailSum,0)*getERate1(BailCurrency,'"+sCurrency+"') as BailSum "+
			       " from "+sTable+" where SerialNo=:SerialNo ";
        	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
        }
    	while(rs.next()){
    		dBalance=rs.getDouble("Balance");
    		dBailSum=rs.getDouble("BailSum");
    	}
    	rs.getStatement().close();
    	//�Գ��ڽ����д���,����õ�ֵ<0,����Ϊ����Ϊ0����ѯ����������������Ż�����
    	dAvailableBalance = dBalance-dBailSum;
    	if(dBalance<0){
    		dBalance=0.0;
    	}
    	
        sBalance=""+dBalance;
        return sBalance;
	}
}
