package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 监管当局限额检查
 * @author yxzhang
 * @date 2010/03/16
 *
 */
 
public class InspectLimitCheck extends AlarmBiz{

	public Object run(Transaction Sqlca) throws Exception {
		
			//获得客户jbo对象
			BizObject jboCustomer=(BizObject)this.getAttribute("CustomerInfo");
			//获得客户ID
			String sCustomerID=(String) this.getAttribute("CustomerID");
			//获得客户类型
			String sCustomerType=(String)this.getAttribute("CustomerType");
			sCustomerType=sCustomerType.substring(0,2);
			//获得申请jbo对象
			BizObject jboApply=(BizObject)this.getAttribute("BusinessApply");
			//获得BA表的SerialNo
			String sSerialNo=jboApply.getAttribute("SerialNo").getString();
			
			SqlObject so; //声明对象
			
			/*定义参数**/
			String  sLineSum="";//集团客户授信额度之和
			String  sBusinessSum="";//集团客户当前申请金额
			String  sSingleBusinessSum="";//单一客户当前申请金额
			String  sBalance="";//单一客户余额
			
			double dLimitSumGroup = 0.0;//集团客户监管限额
	        double dLimitSumSingle = 0.0;//单一客户监管限额
	        double dAttribute2=0.0;//最高集中度百分比
	        
	        //根据不同的客户类型，对监管限额进行比较
	        if(sCustomerType.startsWith("02"))
	        {
	        	//获得集团客户的监管限额
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
				
	        	//获得集团客户成员授信额度的总和	
				 sSql = "select nvl(sum(BusinessSum),0) from Business_Contract where CustomerID in (select CustomerID from CUSTOMER_INFO  " +
						" where BelongGroupID=:BelongGroupID) and (FinishDate is null or FinishDate = ' ')";
				so = new SqlObject(sSql).setParameter("BelongGroupID", sCustomerID);
				sLineSum=Sqlca.getString(so);
	        	 //获得集团客户当前申请金额
				sSql = "select nvl(BusinessSum,0) from BUSINESS_APPLY where SerialNo =:SerialNo ";
				so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
	        	sBusinessSum=Sqlca.getString(so);
	        	
	        	double dLineSum=DataConvert.toDouble(sLineSum);
	        	double dBusinessSum=DataConvert.toDouble(sBusinessSum);
	        	
	        	if((dLineSum+dBusinessSum)>(dLimitSumGroup*(dAttribute2/100)))
	        	{
	        		putMsg("集团客户授信限额度超额！");
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
	        		putMsg("单一客户授信限额超额！");
	        	}
	        }
	        
	        //对检测通过的返回值进行处理
	        if(messageSize() > 0){
	            setPass(false);
	        }else{
	            setPass(true);
	        }     
	        return null;
	}
}