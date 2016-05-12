/*
 *	Author: zywei 2006-1-18
 *	Tester:
 *	Describe: ȡ��ҵ��������
 *	Input Param:
 *			ObjectType����������
 *			RelaObjectType��������������
 *			ObjectNo��������
 *	Output Param:
 *			SerialNo��ҵ��������
 *	HistoryLog:
 *
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetRelativeSerialNo extends Bizlet 
{
	public Object run(Transaction Sqlca) throws Exception
	{
		//��ȡ����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sRelaObjectType = (String)this.getAttribute("RelaObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sRelaObjectType == null) sRelaObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//���������SQL���
		String sSerialNo = "";
		String sRelativeSerialNo = "";
		SqlObject so ;
		
		//��ѯ�������Ӧ��ҵ�������ˮ�ţ����Ŷ����ˮ�š��ʲ����鷽����
		if(sObjectType.equals("CreditApply"))
		{	
			//��������Ϊ���Ŷ�ȶ���
			if(sRelaObjectType.equals("CreditLine"))
			{
				//����������ˮ�Ż�����Ŷ����ˮ��
				so = new SqlObject("select CreditAggreement from BUSINESS_APPLY where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo =  Sqlca.getString(so);
			}

			//��������Ϊ�ʲ����鷽������
			if(sRelaObjectType.equals("NPAReformApply"))
			{
				//����������ˮ�Ż���ʲ����鷽����ˮ��
				so = new SqlObject("select ObjectNo from APPLY_RELATIVE where SerialNo =:SerialNo and ObjectType = 'NPAReformApply'").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
			
		}
		
		//��ѯ��������������Ӧ��ҵ�������ˮ�ţ����Ŷ����ˮ�š��ʲ����鷽����
		if(sObjectType.equals("ApproveApply") || sObjectType.equals("ApproveApplyNo"))
		{	
			//��������Ϊ�������
			if(sRelaObjectType.equals("CreditApply"))
			{
				//�����������������ˮ�Ż��������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			if(sObjectType.equals("ApproveApply"))
			{			
				//��������Ϊ���Ŷ�ȶ���
				if(sRelaObjectType.equals("CreditLine"))
				{
					//�����������������ˮ�Ż�����Ŷ����ˮ��
					so = new SqlObject("select CreditAggreement from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
					sSerialNo = Sqlca.getString(so);
				}
	
				//��������Ϊ�ʲ����鷽������
				if(sRelaObjectType.equals("NPAReformApply"))
				{
					//�����������������ˮ�Ż���ʲ����鷽����ˮ��
					so = new SqlObject("select ObjectNo from APPROVE_RELATIVE where SerialNo =:SerialNo and ObjectType = 'NPAReformApply'").setParameter("SerialNo", sObjectNo);
					sSerialNo = Sqlca.getString(so);
				}
			}			
		}
		
		//��ѯ��ͬ���Ӧ��ҵ�������ˮ�ţ����Ŷ����ˮ�š��������������ˮ�š�������ˮ�š��ʲ����鷽����
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan"))
		{
			
			//��������Ϊ�������
			if(sRelaObjectType.equals("CreditApply"))
			{
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//�����������������ˮ�Ż��������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
				IsPassApprove ipa = new IsPassApprove();
				ipa.setAttribute("ObjectNo", sObjectNo);
				if(ipa.run(Sqlca).equals("false")) sSerialNo = sRelativeSerialNo;//���û�д��������ȡ�����ݣ��������û�����������̣���ô��ͬ���RelativeSerialNo����������ˮ��
			}
			
			//��������Ϊ���������������
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}

			//��������Ϊ���Ŷ�ȶ���
			if(sRelaObjectType.equals("CreditLine"))
			{
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				so = new SqlObject("select CreditAggreement from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}

			//��������Ϊ�ʲ����鷽������
			if(sRelaObjectType.equals("NPAReformApply"))
			{
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				so = new SqlObject("select ObjectNo from CONTRACT_RELATIVE where SerialNo =:SerialNo and ObjectType = 'NPAReformApply'").setParameter("SerialNo", sObjectNo);
				sSerialNo =  Sqlca.getString(so);
			}
			
		}
				
		//��ѯ�������Ӧ��ҵ�������ˮ�ţ���ͬ�����������룩
		if(sObjectType.equals("PutOutApply"))
		{
			//��������Ϊ�������
			if(sRelaObjectType.equals("CreditApply"))
			{
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//�����������������ˮ�Ż��������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
				
			}
			
			//��������Ϊ���������������
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//��������Ϊ��ͬ����
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}						
		}
		
		//��ѯ֧�����Ӧ��ҵ�������ˮ�ţ��Ŵ�����ͬ�����������룩
		if(sObjectType.equals("PaymentApply"))
		{
			//��������Ϊ�������
			if(sRelaObjectType.equals("CreditApply"))
			{
				//����֧����ˮ�Ż�ó�����ˮ��
				so = new SqlObject("select distinct PutoutSerialNo from PAYMENT_INFO where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sRelativeSerialNo =  Sqlca.getString(so);
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//�����������������ˮ�Ż��������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//��������Ϊ���������������
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//����֧����ˮ�Ż�ó�����ˮ��
				so = new SqlObject("select distinct PutoutSerialNo from PAYMENT_INFO where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//��������Ϊ��ͬ����
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//����֧����ˮ�Ż�ó�����ˮ��
				so = new SqlObject("select distinct PutoutSerialNo from PAYMENT_INFO where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//��������Ϊ���ʶ���
			if(sRelaObjectType.equals("PutOutApply"))
			{
				//����֧����ˮ�Ż�ó�����ˮ��
				so = new SqlObject("select distinct PutoutSerialNo from PAYMENT_INFO where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
		}
							
		//��ѯ������Ӧ��ҵ�������ˮ�ţ���ͬ�����ʣ�
		if(sObjectType.equals("BusinessDueBill"))
		{
			//��������Ϊ�������
			if(sRelaObjectType.equals("CreditApply"))
			{
				//���ݽ����ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//�����������������ˮ�Ż��������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
				
			}
			
			//��ѯ������Ӧ�������������
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//���ݽ����ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//���ݺ�ͬ��ˮ�Ż���������������ˮ��
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//��������Ϊ��ͬ����
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//���ݳ�����ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
		}
		
		
		//��ѯ��ֵ׼�����Ӧ��ҵ�������ˮ�ţ���ͬ����ݣ�
		if(sObjectType.equals("Reserve"))
		{
			//��������Ϊ��ݶ���
			if(sRelaObjectType.equals("BusinessDueBill"))
			{
				//����������ˮ�Ż�ý����ˮ��
				so = new SqlObject("select distinct DuebillNo from RESERVE_APPLY where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//��ѯ�������Ӧ�ĺ�ͬ
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//����������ˮ�Ż�ý����ˮ��
				so = new SqlObject("select distinct DuebillNo from RESERVE_APPLY where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//���ݽ����ˮ�Ż�ú�ͬ��ˮ��
				so = new SqlObject("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}

		}	
		
		
		//��ѯ������ͬ������Ӧ��ҵ�������ˮ��
		if(sObjectType.equals("TransformApply"))
		{
			//��ѯ�������Ӧ�ĺ�ͬ
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//����������ˮ�Ż�ý����ˮ��
				so = new SqlObject("select RelativeSerialNo from GUARANTY_TRANSFORM where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
		}
		return sSerialNo;
	}
}