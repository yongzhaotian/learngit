package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 批复保证人信用评级检查
 * @author syang
 * @since 2009/11/12
 */
public class ApproveGuaCustEvaluateCheck extends AlarmBiz {

	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboApprove = (BizObject)this.getAttribute("BusinessApprove");		//取出批复JBO对象
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		BizObject[] jboGuarantys = (BizObject[])this.getAttribute("GuarantyContract");	//取担保合同，因为担保合同可能有多个存在的情况

		String sVouchType = jboApprove.getAttribute("VouchType").getString();
		String sCustomerType = jboCustomer.getAttribute("CustomerType").getString();
		
		if(sVouchType == null) sVouchType = "";
		if(sCustomerType == null) sCustomerType = "";
		
		/** 变量定义 **/
		String sCount="";
		String sGuarantorID="";	
		String sGuarantorName="";
		
		
		/** 程序体 **/
		if(sVouchType.length()>=3) {
			//假如业务基本信息中的主要担保方式为保证,则查询出保证人客户代码
			if(sVouchType.substring(0,3).equals("010")){
	        	for(int i=0;i<jboGuarantys.length;i++){
	        		BizObject jboGuaranty = jboGuarantys[i];
	        		
	        		String sGuarantyType = jboGuaranty.getAttribute("GuarantyType").getString();
	        		if(sGuarantyType == null) sGuarantyType = "";
	        		
	        		if(sGuarantyType.indexOf("010") > 0) continue;
	        		
	            	sGuarantorID = jboGuaranty.getAttribute("GuarantorID").getString();
	            	sGuarantorName = jboGuaranty.getAttribute("GuarantorName").getString();
	            	
	            	//检查保证人信用评级信息
					String sTodayMonth = StringFunction.getToday();
					String sBgMonth = String.valueOf(Integer.parseInt(sTodayMonth.substring(0,4),10)-1).concat(sTodayMonth.substring(4,7));
					
					SqlObject so = new SqlObject("select count(SerialNo) from EVALUATE_RECORD where ObjectType='Customer' And ObjectNo=:ObjectNo And AccountMonth >=:AccountMonth");
					so.setParameter("ObjectNo", sGuarantorID);
					so.setParameter("AccountMonth", sBgMonth);
					sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("保证人["+sGuarantorName+"]缺少一年内的信用评级");
					}					
				}
			}
		}	
		
		/** 返回结果处理 **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
