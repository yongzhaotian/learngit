package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * ��֤�˿ͻ���Ϣ�����Լ��
 * @author syang
 * @since 2009/09/15

 */
public class GuarantyCustomerCheck extends AlarmBiz {

	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");					//ȡҵ������
		BizObject[] jboGuarantys = (BizObject[])this.getAttribute("GuarantyContract");	//ȡ������ͬ����Ϊ������ͬ�����ж�����ڵ����
		
		
		String sVouchType = jboApply.getAttribute("VouchType").getString();
		if(sVouchType == null) sVouchType = "";
		
		/** �������� **/
		String sSql="";
		boolean bContinue = true;
		String sCount="";
		String sGuarantorID="";
		String sGuarantorName="";
		String sCustomerType="";
		SqlObject so = null;//��������
		
		/** ������ **/
		if(sVouchType.length()>=3) {
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤,���ѯ����֤�˿ͻ�����
			if(sVouchType.substring(0,3).equals("010")){
				for(int i=0;i<jboGuarantys.length;i++){
					BizObject jboGuaranty = jboGuarantys[i];
					String sGuarantyType = jboGuaranty.getAttribute("GuarantyType").getString();
					if(sGuarantyType == null) sGuarantyType = "";
					if(sGuarantyType.indexOf("010") < 0 ){
						continue;
					}
					
	            	sGuarantorID = jboGuaranty.getAttribute("GuarantorID").getString();
	            	if(sGuarantorID == null || sGuarantorID.equals("")) sGuarantorID = "";
	            	sGuarantorName = jboGuaranty.getAttribute("GuarantorName").getString();
	            	
	            	so = new SqlObject("select CustomerType from CUSTOMER_INFO where CustomerID =:CustomerID");
	            	so.setParameter("CustomerID", sGuarantorID);
	            	sCustomerType=Sqlca.getString(so);
	            	
	            	if(sCustomerType == null) sCustomerType = "";
	            	//���ݲ�ѯ�ó��ı�֤�˿ͻ����룬��ѯ���ǵĿͻ��ſ��Ƿ�¼������
	            	//��˾�ͻ�
	            	if (sCustomerType.substring(0,2).equals("01")){ 
	            		sSql = "select Count(CustomerID) from ENT_INFO  where CustomerID =:CustomerID  and TempSaveFlag = '1' ";
	            		so = new SqlObject(sSql);
	            		so.setParameter("CustomerID", sGuarantorID);
	            		sCount = Sqlca.getString(so);
	            		
	            	}
	            	//��ظ���
	            	if (sCustomerType.substring(0,2).equals("03")){
	            		sSql ="select Count(CustomerID) from IND_INFO  where CustomerID =:CustomerID  and TempSaveFlag = '1' ";
	            		so = new SqlObject(sSql);
	            		so.setParameter("CustomerID", sGuarantorID);
	            		sCount = Sqlca.getString(so);
	            		
	            	}
	            	
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						bContinue = true;
					}else{
					 	putMsg("��֤��["+sGuarantorName+"]�Ŀͻ��ſ���Ϣ¼�벻����");
					 	bContinue = false;
					}
					
					if( bContinue ){
						sCount = null;
						//�����˿ͻ�����Ϊ����˾�ͻ��ġ����߹���Ϣ�б����з��˴�����Ϣ
						if( sCustomerType.substring(0,2).equals("01") ){
							so = new SqlObject("select count(CustomerID) from CUSTOMER_RELATIVE where Relationship='0100' and CustomerID=:CustomerID ");
			            	so.setParameter("CustomerID", sGuarantorID);
							sCount = Sqlca.getString(so);
							if( sCount == null || Integer.parseInt(sCount) <= 0 ){
								putMsg("��֤��["+sGuarantorName+"]�ĸ߹���Ϣ��ȱ�ٷ��˴�����Ϣ");
							}
						}
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
