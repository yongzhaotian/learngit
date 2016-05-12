package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * <p>
 * �����߶����ͬ����Ƿ�����������<br/>
 * 1.ȡ���ñ��������������е�����ͬ<br/>
 * 2.�ֱ���������ʵ�����ͬ�ĵ������<br/>
 * 3.ȡ���ϵ͵ĵ�����ͬ������������<br/>
 * 4.�Ƚϵ�������Ƿ������������������ͨ��<br/>
 * </p>
 * <p>
 * ���ǵ�������ͬ�����ַ�ʽ����<br/>
 * 1.��������ߵ�����ͬ��δǩ��ͬ��<br/>
 * 2.�������ߵ�����ͬ����ǩ��ͬ��<br/>
 * ����δǩ��ͬ����ߵ�����ͬ���������飬ֻ���������ߵ�����ͬ�������
 * </p>
 * @author djia
 * @since 2009/11/03
 * @history syang 2009/11/10
 */

public class ApproveGuaContractBalanceCheck extends AlarmBiz{
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/* ȡ���� */
		BizObject jboApprove = (BizObject)this.getAttribute("BusinessApprove");					//ȡҵ������
		BizObject[] jboGuarantys = (BizObject[])this.getAttribute("GuarantyContract");		//ȡ������ͬ��������ͬ�����ж�����ڵ����
		double dBusinessSum = jboApprove.getAttribute("BusinessSum").getDouble();				//�������
		
		/* �������� */
		String sSql="";
		String sTmp = "";
		double dUsedLimit = 0.0;			//��ռ�ö��
	 	double dGuarantySum = 0.0;			//�ܵ������
	 	double dMinGuarantyBalance = 0.0;	//���е�����ͬ�У���͵������
	 	
		for(int i=0;i<jboGuarantys.length;i++){
			BizObject jboGuaranty = jboGuarantys[i];
			String sContractType = jboGuaranty.getAttribute("ContractType").getString();	//��ͬ����
			String sContractStatus = jboGuaranty.getAttribute("ContractStatus").getString();//��ͬ״̬
			//Ϊ������ͬ������ǩ��ͬ
			if(sContractType.equals("020")&&sContractStatus.equals("020")){
				String sGuarantyNo = jboGuaranty.getAttribute("SerialNo").getString();	//������ͬ��
				dGuarantySum = jboGuaranty.getAttribute("GuarantyValue").getDouble();	//���������ܶ�
			 	
			 	//��ѯ�ñʵ�������������ҵ���ͬ������ȡ����Ч��ͬ���������ǵ��ܶ�
				sSql = "select sum(Balance*GetErate(businesscurrency,'01','')) from BUSINESS_CONTRACT BC "
			 			+" where SerialNo in("
			 			+" select SerialNo from Contract_Relative "
			 			+" where objecttype='GuarantyContract' "
			 			+" and ObjectNo=:ObjectNo"
			 			+")"
			 			+" and (BC.FinishDate is null or BC.FinishDate = '' or BC.FinishDate = ' ')"
			 			;
				SqlObject so = new SqlObject(sSql);
				so.setParameter("ObjectNo", sGuarantyNo);
		 	    sTmp = Sqlca.getString(so);
			 	if(sTmp == null) sTmp = "0";
			 	dUsedLimit = Double.parseDouble(sTmp);
			 	
			 	//���㵣�����
			 	double dGuarantyBalance = dGuarantySum - dUsedLimit;
			 	//ȡ��һ��ֵ
			 	if(i == 0){dMinGuarantyBalance = dGuarantyBalance;}
			 	//ȡ��Сֵ
			 	if(dMinGuarantyBalance>dGuarantyBalance){
			 		dMinGuarantyBalance = dGuarantyBalance;
			 	}
			}
		}
		if((dMinGuarantyBalance- dBusinessSum) < 0){
			putMsg("������������߶����ͬ���");	
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
