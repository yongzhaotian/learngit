package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ��ܵ����޶���
 * @author yxzhang
 * @date 2010/03/16
 *
 */
 
public class InspectLimitCheck extends AlarmBiz{

	public Object run(Transaction Sqlca) throws Exception {
		
			//��ÿͻ�jbo����
			BizObject jboCustomer=(BizObject)this.getAttribute("CustomerInfo");
			//��ÿͻ�ID
			String sCustomerID=(String) this.getAttribute("CustomerID");
			//��ÿͻ�����
			String sCustomerType=(String)this.getAttribute("CustomerType");
			sCustomerType=sCustomerType.substring(0,2);
			//�������jbo����
			BizObject jboApply=(BizObject)this.getAttribute("BusinessApply");
			//���BA���SerialNo
			String sSerialNo=jboApply.getAttribute("SerialNo").getString();
			
			SqlObject so; //��������
			
			/*�������**/
			String  sLineSum="";//���ſͻ����Ŷ��֮��
			String  sBusinessSum="";//���ſͻ���ǰ������
			String  sSingleBusinessSum="";//��һ�ͻ���ǰ������
			String  sBalance="";//��һ�ͻ����
			
			double dLimitSumGroup = 0.0;//���ſͻ�����޶�
	        double dLimitSumSingle = 0.0;//��һ�ͻ�����޶�
	        double dAttribute2=0.0;//��߼��жȰٷֱ�
	        
	        //���ݲ�ͬ�Ŀͻ����ͣ��Լ���޶���бȽ�
	        if(sCustomerType.startsWith("02"))
	        {
	        	//��ü��ſͻ��ļ���޶�
		        String sSql=" select ItemAttribute,Attribute2 from CODE_LIBRARY where CodeNo='InspectLimitSum' and ItemNo='010'";
		        ASResultSet rs = Sqlca.getASResultSet(sSql);
		        if(rs.next())
				{
		        	String sLimitSumGroup= rs.getString("ItemAttribute");
					String sAttribute2 = rs.getString("Attribute2");
					 if(sLimitSumGroup != null && !sLimitSumGroup.equals(""))
				        {
				        	dLimitSumGroup=DataConvert.toDouble(sLimitSumGroup);
				        	 dAttribute2=DataConvert.toDouble(sAttribute2);
				        }else{
				        	dLimitSumGroup=0.0;
				        }
				}
				rs.getStatement().close();
				
	        	//��ü��ſͻ���Ա���Ŷ�ȵ��ܺ�	
				 sSql = "select nvl(sum(BusinessSum),0) from Business_Contract where CustomerID in (select CustomerID from CUSTOMER_INFO  " +
						" where BelongGroupID=:BelongGroupID) and (FinishDate is null or FinishDate = ' ')";
				so = new SqlObject(sSql).setParameter("BelongGroupID", sCustomerID);
				sLineSum=Sqlca.getString(so);
	        	 //��ü��ſͻ���ǰ������
				sSql = "select nvl(BusinessSum,0) from BUSINESS_APPLY where SerialNo =:SerialNo ";
				so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
	        	sBusinessSum=Sqlca.getString(so);
	        	
	        	double dLineSum=DataConvert.toDouble(sLineSum);
	        	double dBusinessSum=DataConvert.toDouble(sBusinessSum);
	        	
	        	if((dLineSum+dBusinessSum)>(dLimitSumGroup*(dAttribute2/100)))
	        	{
	        		putMsg("���ſͻ������޶�ȳ��");
	        	}	
	        }else{
	        	String sSql=" select ItemAttribute,Attribute2 from CODE_LIBRARY where CodeNo='InspectLimitSum' and ItemNo='020'";
		        ASResultSet rs = Sqlca.getASResultSet(sSql);
		        if(rs.next())
				{
		        	String sLimitSumSingle= rs.getString("ItemAttribute");
					String sAttribute2 = rs.getString("Attribute2");
					 if(sLimitSumSingle != null && !sLimitSumSingle.equals(""))
				        {
						 dLimitSumSingle=DataConvert.toDouble(sLimitSumSingle);
						 dAttribute2=DataConvert.toDouble(sAttribute2);
				        }else{
				        	dLimitSumSingle=0.0;
				        }
				}
				rs.getStatement().close();
				
				SqlObject so1 = new SqlObject("select nvl(BusinessSum,0) from BUSINESS_APPLY where SerialNo =:SerialNo ").setParameter("SerialNo", sSerialNo);
				sSingleBusinessSum = Sqlca.getString(so1);
				sSql = "select nvl(sum(Balance),0) from Business_Contract "
	        			+" where CustomerID=:CustomerID and (FinishDate is null or FinishDate = ' ')";
				so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
				sBalance = Sqlca.getString(so);
				double dSingleBusinessSum=DataConvert.toDouble(sSingleBusinessSum);
	        	double dBalance=DataConvert.toDouble(sBalance);
	        	
	        	if((dSingleBusinessSum+dBalance)>(dLimitSumSingle*(dAttribute2/100)))
	        	{
	        		putMsg("��һ�ͻ������޶�");
	        	}
	        }
	        
	        //�Լ��ͨ���ķ���ֵ���д���
	        if(messageSize() > 0){
	            setPass(false);
	        }else{
	            setPass(true);
	        }     
	        return null;
	}
}