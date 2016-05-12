package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ������֤�������������
 * @author syang
 * @since 2009/11/12
 */
public class ApproveGuaCustEvaluateCheck extends AlarmBiz {

	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboApprove = (BizObject)this.getAttribute("BusinessApprove");		//ȡ������JBO����
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		BizObject[] jboGuarantys = (BizObject[])this.getAttribute("GuarantyContract");	//ȡ������ͬ����Ϊ������ͬ�����ж�����ڵ����

		String sVouchType = jboApprove.getAttribute("VouchType").getString();
		String sCustomerType = jboCustomer.getAttribute("CustomerType").getString();
		
		if(sVouchType == null) sVouchType = "";
		if(sCustomerType == null) sCustomerType = "";
		
		/** �������� **/
		String sCount="";
		String sGuarantorID="";	
		String sGuarantorName="";
		
		
		/** ������ **/
		if(sVouchType.length()>=3) {
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤,���ѯ����֤�˿ͻ�����
			if(sVouchType.substring(0,3).equals("010")){
	        	for(int i=0;i<jboGuarantys.length;i++){
	        		BizObject jboGuaranty = jboGuarantys[i];
	        		
	        		String sGuarantyType = jboGuaranty.getAttribute("GuarantyType").getString();
	        		if(sGuarantyType == null) sGuarantyType = "";
	        		
	        		if(sGuarantyType.indexOf("010") > 0) continue;
	        		
	            	sGuarantorID = jboGuaranty.getAttribute("GuarantorID").getString();
	            	sGuarantorName = jboGuaranty.getAttribute("GuarantorName").getString();
	            	
	            	//��鱣֤������������Ϣ
					String sTodayMonth = StringFunction.getToday();
					String sBgMonth = String.valueOf(Integer.parseInt(sTodayMonth.substring(0,4),10)-1).concat(sTodayMonth.substring(4,7));
					
					SqlObject so = new SqlObject("select count(SerialNo) from EVALUATE_RECORD where ObjectType='Customer' And ObjectNo=:ObjectNo And AccountMonth >=:AccountMonth");
					so.setParameter("ObjectNo", sGuarantorID);
					so.setParameter("AccountMonth", sBgMonth);
					sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("��֤��["+sGuarantorName+"]ȱ��һ���ڵ���������");
					}					
				}
			}
		}	
		
		/** ���ؽ������ **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
