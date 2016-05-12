package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ҵ��������Ϣ�����Լ��
 * @author syang
 * @since 2009/09/15
 */

public class ApplyInfoCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//��ò���
		String sObjectType = (String)this.getAttribute("ObjectType");		//ObjectType,ObjectNo�������κ�ҵ�������Ҫ�Գ�����ȡ
		BizObject apply = (BizObject)this.getAttribute("BusinessApply");	//����JBO
		
		SqlObject so=null;//��������
		
		String sApplySerialNo = apply.getAttribute("SerialNo").getString();
		String sCustomerID = apply.getAttribute("CustomerID").getString();
		String sBusinessType = apply.getAttribute("BusinessType").getString();
		String sOccurType = apply.getAttribute("OccurType").getString();
		String sTempSaveFlag = apply.getAttribute("TempSaveFlag").getString();
		double dBusinessSum = apply.getAttribute("BusinessSum").getDouble();
		int dBillNum = apply.getAttribute("BillNum").getInt();
		
		boolean bContinue = true;
		String sCount="",sHasIERight="",sNum="";
		
		//1���ݴ��־Ϊ�������Ƿ�¼�������ļ���־
		if( sTempSaveFlag != null && sTempSaveFlag.equals("1")&& sTempSaveFlag != "2"){
			putMsg("���������Ϣ������δ¼������");
			bContinue = false;
		}
		
		if( bContinue ){
			//��������Ϊչ�ڣ���������չ��ҵ��
			if(sOccurType.equals("015")){
				so = new SqlObject("select count(SerialNo) from Apply_RELATIVE where SerialNo=:SerialNo and ObjectType='BusinessDueBill'");
				so.setParameter("SerialNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("��������Ϊչ�ڣ���������ص�չ��ҵ����Ϣ");						
				}
				
			//��������Ϊ���»��ɣ������������»��ɵ�ҵ��
			}else if(sOccurType.equals("020")){
				so = new SqlObject("select count(SerialNo) from Apply_RELATIVE where SerialNo=:SerialNo and ObjectType='BusinessDueBill'");
				so.setParameter("SerialNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("��������Ϊ���»��ɣ���������صĽ��»���ҵ����Ϣ");						
				}
			//��������Ϊ�ʲ����飬���������ʲ����鷽��
			}else if(sOccurType.equals("030")){
				so = new SqlObject("select count(SerialNo) from Apply_RELATIVE where SerialNo=:SerialNo and ObjectType='NPAReformApply'");
				so.setParameter("SerialNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("��������Ϊ�ʲ����飬��������ص��ʲ����鷽����Ϣ");	
				}
			}
			
			//ҵ��Ʒ��Ϊ��Ŀ������������Ӧ����Ŀ��Ϣ
			if( sBusinessType.substring(0,4).equals("1030") ){					
				so = new SqlObject("select count(PR.ProjectNo) from PROJECT_RELATIVE PR,BUSINESS_APPLY BA where PR.ObjectNo=BA.SerialNo and PR.ObjectType='CreditApply' and PR.ObjectNo=:ObjectNo");
				so.setParameter("ObjectNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("ҵ��Ʒ��Ϊ��Ŀ������������Ӧ����Ŀ��Ϣ");
				}
				
			//�Ƿ��н����ھ�ӪȨ
			}else if (sBusinessType.substring(0, 4).equals("1080")){
				so = new SqlObject("select HasIERight from ENT_INFO where CustomerID =:CustomerID ");
				so.setParameter("CustomerID", sCustomerID);
				sHasIERight=Sqlca.getString(so);
				
	        	if(sHasIERight==null) sHasIERight="";
	        	if(sHasIERight.equals("2"))
	        		putMsg("ҵ��Ʒ��Ϊ�������ʣ������н����ھ�ӪȨ");
	                
	        } 
			
			
			//��ѯ���ͻ�����
			String sSql = " select CustomerType from CUSTOMER_INFO where CustomerID =:CustomerID ";
			so = new SqlObject(sSql);
			so.setParameter("CustomerID", sCustomerID);
			String sCustomerType = Sqlca.getString(so);
			if (sCustomerType == null) sCustomerType = "";	
			
			/*
			 * ��̽����010880,�Ƿ�����˷��ն������ظ�.������
			if (sCustomerType.substring(0,2).equals("01")){ //��˾�ͻ�
				so = new SqlObject("select Count(SerialNo) from EVALUATE_RECORD where ObjectType='CreditApply' and ObjectNo=:ObjectNo and EvaluateScore >=0");
				so.setParameter("ObjectNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("�����뻹δ���з��նȲ���");
				}
			}
			*/
						
			if (sBusinessType.equals("1080020")){
				so = new SqlObject("select count(SerialNo) from LC_INFO where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo");
				so.setParameter("ObjectNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("ҵ��Ʒ��Ϊ����֤���³��ڴ������ҵ��û���������֤��Ϣ");
				}					
			}
			
			if(sBusinessType.length()>=4) {
				//�����Ʒ����Ϊ����ҵ��
				if(sBusinessType.substring(0,4).equals("1020") && !sBusinessType.equals("1020040"))	{
					so = new SqlObject("select count(SerialNo) from BILL_INFO  where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo having sum(BillSum) =:dBusinessSum ");
					so.setParameter("ObjectNo", sApplySerialNo);
					so.setParameter("dBusinessSum", dBusinessSum);
					sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("ҵ��Ʒ��Ϊ����ҵ��ҵ�����Ʊ�ݽ���ܺͲ���");
					}
									
					so = new SqlObject("select count(SerialNo) from BILL_INFO  where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo having count(SerialNo) =:dBillNum ");
					so.setParameter("ObjectNo", sApplySerialNo);
					so.setParameter("dBillNum", dBillNum);
					sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("ҵ��Ʒ��Ϊ����ҵ��ҵ���������Ʊ�������������Ʊ����������");
					}									
				}
			}
			
			//����֤���³��ڴ���������֤���³���Ѻ�㡢�������³���Ѻ�㡢����֤���½���Ѻ��,����������֤��Ϣ
			if (sBusinessType.equals("1080020") ||sBusinessType.equals("1080030") ||sBusinessType.equals("1080040") ||sBusinessType.equals("1080010")){
				so = new SqlObject("select count(SerialNo) from LC_INFO where ObjectType =:ObjectType  and ObjectNo =:ObjectNo ");				
				so.setParameter("ObjectType", sObjectType);
				so.setParameter("ObjectNo", sApplySerialNo);
				sNum = Sqlca.getString(so);
				if( sNum == null || Integer.parseInt(sNum) <= 0 )
					putMsg("�������³���Ѻ�㡢������ҵ��Ʊ���ʻ�����֤���ҵ��û���������֤��Ϣ");
			}

			//���ڱ������ڱ��������ط�Ʊ��Ϣ
			if (sBusinessType.equals("1080310") ||  sBusinessType.equals("1080320")) {
				so = new SqlObject("select count(SerialNo) from INVOICE_INFO where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo");
				so.setParameter("ObjectNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("ҵ��Ʒ��Ϊ���ڱ���ҵ�����ڱ���ҵ��û����ֵ˰��Ʊ��Ϣ");
				}					
			}
			
			so = new SqlObject("select count(SerialNo) from FORMATDOC_DATA where ObjectType='CreditApply' and ObjectNo=:ObjectNo ");
			so.setParameter("ObjectNo", sApplySerialNo);
			sCount = Sqlca.getString(so);
			if( sCount == null || Integer.parseInt(sCount) <= 0 ){
				putMsg("�����뻹δ��д��ְ���鱨����Ϣ");
			}
									
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}

}
