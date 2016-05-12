package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * �ͻ���Ϣ�����Լ��
 * @author syang 
 * @since 2009/09/15
 */
public class CustomerCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		String sCustomerType = jboCustomer.getAttribute("CustomerType").getString();
		
		/** �������� **/
		boolean bContinue = true;
		String sCount = "";
		String sTempSaveFlag = "";
		SqlObject so = null;//��������
		/** ������ **/
		//�������
		// �����˿ͻ��ſ�����¼�루�����ֶ������룩
		
		//������Ϊ���˿ͻ�������ݴ��־�Ƿ�Ϊ��
		if( sCustomerType.substring(0,2).equals("03")){
			so = new SqlObject("select TempSaveFlag from IND_INFO where CustomerID=:CustomerID ");
			so.setParameter("CustomerID", sCustomerID);
			sTempSaveFlag = Sqlca.getString(so);
			if(sTempSaveFlag == null) sTempSaveFlag = "";
			if( sTempSaveFlag.equals("1")){
				putMsg("�ÿͻ��Ŀͻ��ſ���Ϣ¼�벻����");
			}
			bContinue = false;
			
		//������Ϊ���˿ͻ�������ݴ��־�Ƿ�Ϊ��
		}else if( sCustomerType.substring(0,2).equals("01") ){	
			so = new SqlObject("select TempSaveFlag from ENT_INFO where CustomerID=:CustomerID ");
			so.setParameter("CustomerID", sCustomerID);
			sTempSaveFlag = Sqlca.getString(so);
			if(sTempSaveFlag == null) sTempSaveFlag = "";
			if( sTempSaveFlag.equals("1") )
				putMsg("�ÿͻ��Ŀͻ��ſ���Ϣ¼�벻����");			
		}
		
		if( bContinue ){
			sCount = null;
			//�����˿ͻ�����Ϊ����˾�ͻ��ġ����߹���Ϣ�б����з��˴�����Ϣ
			if( sCustomerType.substring(0,2).equals("01") ){
				so = new SqlObject("select count(CustomerID) from CUSTOMER_RELATIVE where Relationship='0100' and CustomerID=:CustomerID");
				so.setParameter("CustomerID", sCustomerID);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 )
					putMsg("�ÿͻ��ĸ߹���Ϣ��ȱ�ٷ��˴�����Ϣ");
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
