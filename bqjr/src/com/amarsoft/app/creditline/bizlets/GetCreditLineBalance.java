/**
 * ȡ�����Ŷ��ʵ�ʿ��ý��  
 * @author hwang
 * @date 2009-06-23 21:00  
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class GetCreditLineBalance extends Bizlet {

	/**
	 * @return ʵ�ʿ��ý��
	 */
	public Object run(Transaction Sqlca) throws Exception {
		/**
		 * ���Ŷ��Э���(��ͬ��)
		 */
        String sLineNo = (String)this.getAttribute("LineNo");        
		
		String sSql = "";
		ASResultSet rs = null;
		String sLineCurrency="";//��ȱ���
		String sObjectNo="";//��ͬ��ˮ��
		String sContractNoList="";//��ͬ��ˮ������
		String[] sContractNos=null;//��ͬ��ˮ������,���ڼ���ÿ�ʺ�ͬ�ĳ���
		String sCreditCycle="";//����Ƿ�ѭ��
        String sBalance = null;//���
        String sPigeonholeDate=null;//��ɷŴ�����
        String sExposureFlag="";//���㳨�ڱ�־��sum:���㳨�ڽ��,balance:���㳨�����
        double dLine = 0.0;//��Ƚ��
        double dContractSum = 0.0;//����ɷŴ���ͬ�ܽ��
        double dContractBalance = 0.0;//����ɷŴ���ͬ����ܺ�
        int iCount=0;//��������Ⱥ�ͬ��
        SqlObject so = null;//��������
        
        //ȡ���Э����,����,ѭ����Ϣ
        sSql = "select nvl(BusinessSum,0) as BusinessSum,BusinessCurrency,CreditCycle from BUSINESS_CONTRACT where SerialNO =:SerialNO ";
        so = new SqlObject(sSql);
		so.setParameter("SerialNO", sLineNo);
		rs = Sqlca.getASResultSet(so);
		
    	while(rs.next()){
    		sLineCurrency = rs.getString("BusinessCurrency");
    		sCreditCycle = rs.getString("CreditCycle");
    		dLine = rs.getDouble("BusinessSum");
    	}
    	rs.getStatement().close();
    	
        //ȡ�ù����ö�ȵ�:��ͬ��ˮ������sContractNoList,��ͬ��ˮ������sContractNos
    	sSql = "Select ObjectNo from CREDITLINE_RELA where LineNo=:LineNo and ObjectType='BusinessContract' ";
    	so = new SqlObject(sSql);
		so.setParameter("LineNo", sLineNo);
		sContractNos = Sqlca.getStringArray(so);
    	iCount = sContractNos.length;//��ȡ��������Ⱥ�ͬ��
    	for(int i=0;i<iCount;i++){
    		if(i==0){
    			sContractNoList+="'"+sContractNos[i]+"'";
    		}else{
    			sContractNoList+=",'"+sContractNos[i]+"'";
    		}
    	}
    	if(sContractNoList.length()==0) sContractNoList ="''";
    	
    	//��ȡ�������������ɷŴ���ͬ�ܽ��(�������Ƿ�����ɷŴ�),����ת�ɶ�ȱ���
    	sSql = "select sum(nvl(BusinessSum,0)*getERate1(BusinessCurrency,'"+sLineCurrency+"')) as ContractSum from BUSINESS_CONTRACT where SerialNo in("+sContractNoList+")";
    	so = new SqlObject(sSql);
		rs = Sqlca.getASResultSet(so);
    	while(rs.next()){
    		dContractSum = rs.getDouble("ContractSum");
    	}
    	rs.getStatement().close();
    	
    	//��ȡ�������������ɷŴ���ͬ��������ܺ�
    	Bizlet bzGetExposureBalance = new GetExposureBalance();
    	//��ÿ�ʺ�ͬ�������
    	for(int i=0;i<iCount;i++)
    	{
    		sObjectNo=sContractNos[i];
    		sSql="select PigeonholeDate from BUSINESS_CONTRACT where SerialNo =:SerialNo ";
    		so = new SqlObject(sSql);
    		so.setParameter("SerialNo", sObjectNo);
    		rs = Sqlca.getASResultSet(so);
        	if(rs.next()){
        		sPigeonholeDate = rs.getString("PigeonholeDate");
        	}
        	rs.getStatement().close();
        	if(sPigeonholeDate !=null && sPigeonholeDate.length() !=0){//�ñʺ�ͬ����ɷŴ�
        		sExposureFlag="balance";
        	}else{
        	//û����ɷŴ�
        		sExposureFlag="sum";
        	}
        	bzGetExposureBalance.setAttribute("Currency",sLineCurrency);
    		bzGetExposureBalance.setAttribute("Flag",sExposureFlag);
    		bzGetExposureBalance.setAttribute("ObjectType","BusinessContract");
    		bzGetExposureBalance.setAttribute("ObjectNo",sObjectNo);
    		dContractBalance+=Double.valueOf((String)bzGetExposureBalance.run(Sqlca)).doubleValue();//���ۼ�
    	}
    	
    	//ȡ���ʵ�ʿ��ý��
    	if("1".equals(sCreditCycle))//��ѭ��
    	{
    		sBalance = ""+(dLine - dContractBalance);//������=��Ⱥ�ͬ���-�������ʶ�Ⱥ�ͬ��������ܺ�
    	}else{//����ѭ��,����û���Ƿ�ѭ����Ϣ����Ϊ����ѭ��
    		sBalance = ""+(dLine - dContractSum);//������=��Ⱥ�ͬ���-�������ʶ�Ⱥ�ͬ�ܽ��
    	}
    	//���¶�����
    	sSql = "update BUSINESS_CONTRACT set TotalBalance =:TotalBalance where SerialNo =:SerialNo ";
    	so = new SqlObject(sSql);
		so.setParameter("TotalBalance", DataConvert.toDouble(sBalance));
		so.setParameter("SerialNo", sLineNo);
    	return sBalance;

	}

}
