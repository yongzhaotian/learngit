/**
 * Author: --hwang 2009-06-23 21:00            
 * Tester:                               
 * Describe: --ȡ�����Ŷ���Ӷ�����  
 * Input Param:                          
 * 		LineNo : �Ӷ���������Ŷ�ȶ��Э���
 * 		BusinessType : ��ǰ����(���롢��������ͬ)��ҵ������       
 * Output Param:                         
 * 		sBalance��
 * 			����ж�Ӧ���Ӷ���򷵻أ��������&�Ӷ�ȱ�������&�Ӷ�ȱ���
 * 			���û���򷵻�:  �������  
 * updatesuer:yhshan
 * updatedate:2012/09/11
 * HistoryLog:                           
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class GetCreditSubLineBalance extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
        String sLineNo = (String)this.getAttribute("LineNo");
        String sBusinessType = (String)this.getAttribute("BusinessType");
		
        ASResultSet rs = null;
		String sSql = "";
		String sParentLineID="";//�Ӷ�����ڶ�ȶ�ȱ��
        String sBalance = null;//���
        String sObjectNo = "";//��ȡ��������ȵĺ�ͬ��ˮ��
        String sContractNoList = "";//��ȡ��������ȵĺ�ͬ��ˮ������
        String[] sContractNos=null;//��ͬ��ˮ������,���ڼ���ÿ�ʺ�ͬ�ĳ���
        String sLineCurrency = "";//���Ŷ�ȱ���
        String sCurrency = "";//�Ӷ�ȱ���
        String sSubLineBusinessType="";//�Ӷ��ҵ������
        String sRotative = "";//�Ӷ��ѭ����־��1����ѭ����2������ѭ��
        String sAssignFlag ="";//�Ƿ����ָ��ҵ��Ʒ�ֵ��Ӷ�ȡ�false:δ����,true:�ѷ���
        String sPigeonholeDate=null;//��ɷŴ�����
        String sExposureFlag="";//���㳨�ڱ�־��sum:���㳨�ڽ��,balance:���㳨�����
        double dSubCLOpenBalance = 0.0;//�Ӷ�Ⱥ�ͬ�������
    	double dSubCLOpenSum = 0.0;//�Ӷ�Ⱥ�ͬ���ڽ��
    	double dSubCLContractSum=0.0;//�Ӷ�Ⱥ�ͬ���
    	double dSubCLContractBalance=0.0;//�Ӷ�Ⱥ�ͬ���
    	double dSubCreditLineBalance=0.0;//�Ӷ�ȿ������
        double dLineSum1=0.0;//�Ӷ�������޶�
    	double dLineSum2=0.0;//�Ӷ�ȳ����޶�
    	int i = 0;//���ڼ���
    	int iCount=0;//���Ӷ��ҵ��������ͬ�ĺ�ͬ��
    	SqlObject so = null;//��������
        
    	/***********************��һ����ȡ�Ӷ�������޶�,�����޶�,�Ƿ�ѭ����Ϣ**************************/
    	//ȡ�Ӷ�����ڶ�ȵĶ��ID������,���ڲ�ѯ�Ӷ�������޶�,�����޶�,�Ƿ�ѭ����Ϣ
    	sSql = "select LineID,Currency from CL_INFO where BCSerialNO =:BCSerialNO ";
    	so = new SqlObject(sSql);
    	so.setParameter("BCSerialNO", sLineNo);
    	rs = Sqlca.getASResultSet(so);
        if(rs.next()){
    		sLineCurrency = rs.getString("Currency");
    		sParentLineID = rs.getString("LineID");
    	}
    	rs.getStatement().close();
    	if(sLineCurrency==null) sLineCurrency="";
        if(sParentLineID == null) throw new Exception("ȡ��Ƚ�����û���ҵ����.�ñʶ�ȵĶ��Э���Ϊ��"+sLineNo);
        
        //��ȡ�Ӷ�������޶�,�����޶�,�Ƿ�ѭ����Ϣ,���֡��������ơ�ת���ɶ�ȱ��ֺ����ֵ
        if(sBusinessType.length() >=4){
        	sSql = "Select nvl(LineSum1,0) as LineSum1,nvl(LineSum2,0) as LineSum2,Currency,Rotative,BusinessType from CL_INFO Where ParentLineID =:ParentLineID  and (BusinessType=:BusinessType1 or BusinessType =:BusinessType2)";
        	so = new SqlObject(sSql).setParameter("ParentLineID", sParentLineID).setParameter("BusinessType1", sBusinessType).setParameter("BusinessType2", sBusinessType.substring(0,4));
        	rs = Sqlca.getASResultSet(so);
        }else{
        	sSql = "Select nvl(LineSum1,0) as LineSum1,nvl(LineSum2,0)  as LineSum2,Currency,Rotative,BusinessType from CL_INFO Where ParentLineID =:ParentLineID and (BusinessType=:BusinessType)";
        	so = new SqlObject(sSql).setParameter("ParentLineID", sParentLineID).setParameter("BusinessType", sBusinessType);
        	rs = Sqlca.getASResultSet(so);
        }
    	if(rs.next()){//����Ĭ����Ϊû�з���ҵ��������ͬ���Ӷ��
    		dLineSum1 = rs.getDouble("LineSum1");
    		dLineSum2 = rs.getDouble("LineSum2");
    		sRotative = rs.getString("Rotative");
    		sCurrency = rs.getString("Currency");
    		sSubLineBusinessType=rs.getString("BusinessType");
    	}else{//���û�з��䵱ǰҵ��������ͬ���Ӷ��,���Ƿ������Ϊfalse
    		sAssignFlag="false";
    	}
    	rs.getStatement().close();
    	if(sRotative == null) sRotative="";
    	if(sCurrency == null) sCurrency="";
    	if(sSubLineBusinessType == null) sSubLineBusinessType="";
    	
    	if(!sAssignFlag.equals("false")){//��ָ����ҵ�������Ӷ��
	    	/***********************�ڶ�����ȡ�Ӷ�Ⱥ�ͬ���dSubCLContractSum����ͬ���dSubCLContractBalance����ͬ���ڽ��dSubCLOpenSum����ͬ�������dSubCLOpenBalance**************************/
	    	//��ȡ���Ӷ��ҵ��������ͬ����ҵ�����������͵ĺ�ͬ��ˮ��,��ͬ����
    		String sSubLineBusinessType1 = sSubLineBusinessType+"%";
    		sSql = "Select ObjectNo from CREDITLINE_RELA where LineNo=:LineNo and ObjectType='BusinessContract' and BusinessType like :BusinessType ";
    		so = new SqlObject(sSql).setParameter("LineNo", sLineNo).setParameter("BusinessType", sSubLineBusinessType1);
    		sContractNos = Sqlca.getStringArray(so);
	    	iCount = sContractNos.length;
	    	for(i=0;i<iCount;i++){
	    		if(i==0){
	    			sContractNoList+="'"+sContractNos[i]+"'";
	    		}else{
	    			sContractNoList+=",'"+sContractNos[i]+"'";
	    		}
	    	}
	    	if(sContractNoList.length()==0) sContractNoList ="''";
	    	
	    	/******ȡ�Ӷ�Ⱥ�ͬ���dSubCLContractSum����ͬ���dSubCLContractBalance***/
	    	//ȡ�Ӷ�Ⱥ�ͬ����ܺ�,��ͬ����ܺ�(��ͬ����󷨣�����ñʺ�ͬ����ɷŴ���ȡ��ͬ������ñʺ�ͬδ��ɷŴ���ȡ��ͬ���)
	    	sSql = " select sum(nvl(BusinessSum,0)*getERate1(BusinessCurrency,:BusinessCurrency)) as Sum1,"+
		 		   " sum(case when (PigeonholeDate !=' ' and PigeonholeDate is not null) then nvl(Balance,0)*getERate1(BusinessCurrency,:BusinessCurrency1) "+
		 		   "     else  nvl(BusinessSum,0)*getERate1(BusinessCurrency,:BusinessCurrency2) end) as Balance1 "+
		 		   " from BUSINESS_CONTRACT where SerialNo in("+sContractNoList+")";
	    	so = new SqlObject(sSql).setParameter("BusinessCurrency", sCurrency).setParameter("BusinessCurrency1", sCurrency)
	    	.setParameter("BusinessCurrency2", sCurrency);
    		rs = Sqlca.getASResultSet(so);
	    	while(rs.next()){
	    		dSubCLContractSum = rs.getDouble("Sum1");
	    		dSubCLContractBalance = rs.getDouble("Balance1");
	    	}
	    	rs.getStatement().close();
	    	
	    	/******��ͬ���ڽ��dSubCLOpenSum����ͬ�������dSubCLOpenBalance***/
	    	//ȡ�Ӷ�Ⱥ�ͬ���ڽ���ܺ͡���ͬ����������
	    	Bizlet bzGetExposureBalance = new GetExposureBalance();
	    	//��ȡ�Ӷ�ȵĺ�ͬ��������ܺ�dSubCLOpenBalance
	    	for(i=0;i<iCount;i++)
	    	{
	    		sObjectNo=sContractNos[i];//��ÿ�ʺ�ͬ�������
	    		sSql="select PigeonholeDate from BUSINESS_CONTRACT where SerialNo =:SerialNo ";
	    		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
	    		rs = Sqlca.getASResultSet(so);
	        	if(rs.next()){
	        		sPigeonholeDate = rs.getString("PigeonholeDate");
	        	}
	        	rs.getStatement().close();
	        	if(sPigeonholeDate !=null && sPigeonholeDate.length() !=0){//�ñʺ�ͬ����ɷŴ�
	        		sExposureFlag="balance";
	        	}else{//û����ɷŴ�
	        		sExposureFlag="sum";
	        	}
	        	bzGetExposureBalance.setAttribute("Currency",sCurrency);
	    		bzGetExposureBalance.setAttribute("Flag",sExposureFlag);
	    		bzGetExposureBalance.setAttribute("ObjectType","BusinessContract");
	    		bzGetExposureBalance.setAttribute("ObjectNo",sObjectNo);
	    		dSubCLOpenBalance+=Double.valueOf((String)bzGetExposureBalance.run(Sqlca)).doubleValue();//���ۼ�
	    	}
	    	//��ȡ�Ӷ�ȵĺ�ͬ���ڽ���ܺ�dSubCLOpenSum
	    	for(i=0;i<iCount;i++)
	    	{
	    		sObjectNo=sContractNos[i];//��ÿ�ʺ�ͬ���ڽ��
	    		bzGetExposureBalance.setAttribute("Currency",sCurrency);
	    		bzGetExposureBalance.setAttribute("Flag","sum");
	    		bzGetExposureBalance.setAttribute("ObjectType","BusinessContract");
	    		bzGetExposureBalance.setAttribute("ObjectNo",sObjectNo);
	    		dSubCLOpenSum+=Double.valueOf((String)bzGetExposureBalance.run(Sqlca)).doubleValue();//���ۼ�
	    	}
	    	
	    	/**************************��������ȡ�Ӷ��ʵ�ʿ������************************************/
	    	//��ȡ�Ӷ��ʵ�ʿ������
	    	if(dLineSum1 ==0 && dLineSum2==0)//��������޶�,�����޶��Ϊ0,����Ӷ�ȿ��ö��Ϊ0.
	    	{
	    		dSubCreditLineBalance = 0.0;
	    	}else{
	    		if(sRotative.equals("1"))//��ѭ��,�������
	    		{
	    			if(dLineSum1==0 && dLineSum2>0)//�����޶�Ϊ0�������޶�>0
	    			{
	    				dSubCreditLineBalance = dLineSum2-dSubCLOpenBalance;//�Ӷ�ȿ������=�Ӷ�ȳ����޶�-�Ӷ�ȳ������;
	    			}else if(dLineSum2==0 && dLineSum1>0)//�����޶�>0�������޶�Ϊ0
	    			{
	    				dSubCreditLineBalance = dLineSum1-dSubCLContractBalance;//�Ӷ�ȿ������=�Ӷ�������޶�-�Ӷ�Ⱥ�ͬ���;
	    			}else{//�����޶�����޶��>0;�Գ������������������ƣ�ȡ���С�ߡ�
	    				if((dLineSum2-dSubCLOpenBalance)>=(dLineSum1-dSubCLContractBalance))
	    				{
	    					dSubCreditLineBalance = dLineSum1-dSubCLContractBalance;
	    				}else{
	    					dSubCreditLineBalance = dLineSum2-dSubCLOpenBalance;
	    				}						
	    			}
	    		}else{//����ѭ����������
	    			if(dLineSum1==0 && dLineSum2>0)//�����޶�Ϊ0�������޶�>0
	    			{
	    				dSubCreditLineBalance = dLineSum2-dSubCLOpenSum;//�Ӷ�ȿ������=�Ӷ�ȳ����޶�-�Ӷ�ȳ��ڽ��;
	    			}else if(dLineSum2==0 && dLineSum1>0)//�����޶�>0�������޶�=0
	    			{
	    				dSubCreditLineBalance = dLineSum1-dSubCLContractSum;//�Ӷ�ȿ������=�Ӷ�������޶�-�Ӷ�Ⱥ�ͬ���;
	    			}else{//�����޶�����޶��>0;ȡ�����޶�������޶���С��
	    				if((dLineSum2-dSubCLOpenSum)>=(dLineSum1-dSubCLContractSum))
	    				{
	    					dSubCreditLineBalance = dLineSum1-dSubCLContractSum;
	    				}else{
	    					dSubCreditLineBalance = dLineSum2-dSubCLOpenSum;
	    				}						
	    			}
	    		}
	    	}
	    	sBalance = ""+dSubCreditLineBalance+"&"+sCurrency;
    	}else{//û�з���ָ��ҵ�����͵��Ӷ��,���Ӷ�ȿ��������Ϊ-1
    		dSubCreditLineBalance=-1;
    		sBalance = ""+dSubCreditLineBalance;
    	}
    	sSql = "update CL_INFO set SubBalance =:SubBalance  where BCSerialNO =:BCSerialNO  and BusinessType =:BusinessType ";
    	so = new SqlObject(sSql).setParameter("SubBalance", dSubCreditLineBalance).setParameter("BCSerialNO", sLineNo).setParameter("BusinessType", sBusinessType);
    	Sqlca.executeSQL(so);
        return sBalance;

	}

}
